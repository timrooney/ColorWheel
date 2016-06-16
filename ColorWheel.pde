import processing.serial.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;

Serial port;


import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
float value;

int i=0;
 
void setup(){
size(400,300);
 port = new Serial(this, "/dev/cu.usbmodem1421", 9600); //remember to replace COM20 with the appropriate serial port on your computer

oscP5 = new OscP5(this,12000);
myRemoteLocation = new NetAddress("127.0.0.1",12001);
//fullScreen();
}
 
 
String buff = "";

int wRed, wGreen, wBlue, wClear;
String hexColor = "ffffff";
 

void draw(){
  if (keyPressed == true) {
  exit();
  }
 background(wRed,wGreen,wBlue);

 while (port.available() > 0) {
   serialEvent(port.read());
 }
}
 
void serialEvent(int serial) {
 if(serial != '\n') {
   buff += char(serial);
 } else {
   
   int cRed = buff.indexOf("R");
   int cGreen = buff.indexOf("G");
   int cBlue = buff.indexOf("B");
   int clear = buff.indexOf("C");
   if(clear >=0){
     String val = buff.substring(clear+3);
     val = val.split("\t")[0]; 
     wClear = Integer.parseInt(val.trim());
   } else { return; }
   
   if(cRed >=0){
     String val = buff.substring(cRed+3);
     val = val.split("\t")[0]; 
     wRed = Integer.parseInt(val.trim());
   } else { return; }
   
   if(cGreen >=0) {
     String val = buff.substring(cGreen+3);
     val = val.split("\t")[0]; 
     wGreen = Integer.parseInt(val.trim());
   } else { return; }
   
   if(cBlue >=0) {
     String val = buff.substring(cBlue+3);
     val = val.split("\t")[0]; 
     wBlue = Integer.parseInt(val.trim());
   } else { return; }
   
   print("Red: "); print(wRed);
   print("\tGrn: "); print(wGreen);
   print("\tBlue: "); print(wBlue);
   print("\tClr: "); println(wClear);
   
   wRed *= 255; wRed /= wClear;
   wGreen *= 255; wGreen /= wClear; 
   wBlue *= 255; wBlue /= wClear; 

   hexColor = hex(color(wRed, wGreen, wBlue), 6);
   println(hexColor);
   buff = "";
   

  
    if (wGreen > 0){
   OscMessage msg = new OscMessage("1");
     msg.add(wGreen);
     oscP5.send(msg, myRemoteLocation);
 }
  if (wBlue > 0){
   OscMessage msg = new OscMessage("2");
     msg.add(wBlue);
    oscP5.send(msg, myRemoteLocation);
}
  if (wRed > 0){
   OscMessage msg = new OscMessage("3");
     msg.add(wRed);
    oscP5.send(msg, myRemoteLocation);
}
 }
}