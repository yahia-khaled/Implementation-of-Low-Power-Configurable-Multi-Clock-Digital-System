module Serializer#(parameter WIDTH_DATA = 8)(
    input       wire        [WIDTH_DATA-1:0]        P_DATA,
    input       wire                                DATA_VALID,
    input       wire                                ser_en,
    input       wire                                CLK,
    input       wire                                RST,
    input       wire                                BUSY,  
    output      wire                                ser_done,
    output      wire                                ser_data
);
    
//internal signal
reg         [WIDTH_DATA-1:0]        P_DATA_RECEIVED;
reg         [3:0]        Counter;
integer i;


////////////////////////////////

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        P_DATA_RECEIVED <= 0;
    end
    else if(DATA_VALID)begin
        P_DATA_RECEIVED <= P_DATA;
    end
    else begin
        P_DATA_RECEIVED <= P_DATA_RECEIVED;
    end
end

////////////////////////////////
/*
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        ser_done = 1'b0;
        ser_data = 1'b0;
        i = 1;
        Counter = 4'b1000; 
    end
    else if (ser_en) begin
        if(Counter > 0)begin
            ser_data = P_DATA_RECEIVED[i];
            i = i +1;
            Counter = Counter -1;
        end
        else begin
            Counter = 4'b1000;
            i = 0;
        end
    if(Counter == 0)begin
        ser_done = 1'b1;
    end
    else begin
        ser_done = 1'b0;
    end
    end
    else begin
        i = 0;
        ser_done = 1'b0;
        Counter = 4'b1000;
        //ser_data = P_DATA_RECEIVED[0];
    end
end    

*/

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        Counter <= 0;
        //ser_done <= 0;
    end
    else if (Counter == 7 || !ser_en) begin
        Counter <= 0;
        //ser_done <= 1;
    end
    else if (ser_en) begin
        Counter <= Counter + 1;
        //ser_done <= 0;
    end
    else begin
        Counter <= Counter;
        //ser_done <= ser_done;
    end
end


assign ser_data = (ser_en) ? P_DATA[Counter] : 1'b0; 

assign ser_done = (Counter == 7) ? 1'b1 : 1'b0;

/*
reg  [WIDTH_DATA-1:0]    P_DATA_RECEIVED ;
reg  [2:0]          ser_count ;
              
//isolate input 
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    P_DATA_RECEIVED <= 'b0 ;
   end
  else if(DATA_VALID && !BUSY)
   begin
    P_DATA_RECEIVED <= P_DATA ;
   end	
  else if(ser_en)
   begin
    P_DATA_RECEIVED <= P_DATA_RECEIVED >> 1 ;         // shift register
   end
 end
 

//counter
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    ser_count <= 'b0 ;
   end
  else
   begin
    if (ser_en)
	 begin
      ser_count <= ser_count + 'b1 ;		 
	 end
	else 
	 begin
      ser_count <= 'b0 ;		 
	 end	
   end
 end 

assign ser_done = (ser_count == 'b111) ? 1'b1 : 1'b0 ;

assign ser_data = P_DATA_RECEIVED[0] ;
*/

endmodule //Serializer

