function [V, linePowerTransfer, loadPower, transPowerTransfer] = runPFfull(DSSObj,P,Q)
DSSText=DSSObj.text;

%adjust loads
nNodes=33;%primary network
secNodes=55;%secondary network
for ind=2:nNodes
    for secInd=56:110
        loadIdx=(ind-2)*55+secInd-55;
        nodeNumber=num2str(ind*1000+secInd);
        DSSText.Command = ['Edit Load.' nodeNumber ' kW=' num2str(P(loadIdx)) ' kvar=' num2str(Q(loadIdx))];
    end
end

%solve power flow
DSSCircuit=DSSObj.ActiveCircuit;
DSSText.Command='Set mode=snapshot';
DSSText.Command='solve';

% DSSText.command='show voltages';
% DSSText.command='show Power';

% get bus voltages
vckt = DSSCircuit.YNodeVarray;
% vckt_len = length(vckt);
vpri_len=33*3*2;
V = vckt(1:2:vpri_len)+1i*vckt(2:2:vpri_len);

linePowerTransfer=[];
loadPower=[];
transPowerTransfer=[];

%get transformers power transfer
% transPowerTransfer = zeros(DSSCircuit.Transformers.count,3);
% Tindex = DSSCircuit.Transformers.First();
% transCounter = 0;
% while Tindex ~= 0
%     transCounter=transCounter+1;
%     EPowers = DSSCircuit.ActiveCktElement.Powers();
%     transPowerTransfer(transCounter,1) = str2double(DSSCircuit.ActiveCktElement.BusNames{1});
%     transPowerTransfer(transCounter,2:3) = 3e3*EPowers([1,2]);
%     Tindex = DSSCircuit.Transformers.Next();
% end

% get power transfer
% linePowerTransfer = zeros(DSSCircuit.Lines.count*2,4);
% Lindex = DSSCircuit.Lines.First();
% lineCounter = 0;
% while Lindex ~= 0
%     lineCounter=lineCounter+1;
%     EPowers = DSSCircuit.ActiveCktElement.Powers();
%     linePowerTransfer(2*lineCounter-1,1:2) = [str2double(DSSCircuit.ActiveCktElement.BusNames{1}),str2double(DSSCircuit.ActiveCktElement.BusNames{2})];
%     linePowerTransfer(2*lineCounter-1,3:4) = 3e3*EPowers([1,2]);
%     linePowerTransfer(2*lineCounter,1:2) = linePowerTransfer(2*lineCounter-1,[2,1]);
%     linePowerTransfer(2*lineCounter,3:4) = 3e3*EPowers([7,8]);
%     Lindex = DSSCircuit.Lines.Next();
% end

%get load power
% loadPower = zeros((nNodes-1)*secNodes,3);%bus number, Pload, Qload
% Lindex = DSSCircuit.Loads.First();
% loadCounter = 0;
% while Lindex ~= 0
%     loadCounter = loadCounter+1;
%     EPowers = DSSCircuit.ActiveCktElement.Powers();
%     loadPower(loadCounter,1) = str2double(DSSCircuit.ActiveCktElement.BusNames{1});
%     loadPower(loadCounter,2:3) = 3e3*EPowers(1:2);
%     Lindex = DSSCircuit.Loads.Next();
% end