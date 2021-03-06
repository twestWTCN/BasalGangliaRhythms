function R = plotSweepSpectraWrapper_M2_SI(R)
close all
rootan = [R.rootn 'data\' R.out.oldtag '\ConnectionSweep'];

% load([R.rootn 'routine\' R.out.oldtag '\BetaBurstAnalysis\Data\BB_' R.out.tag '_ConnectionSweep_feat_F1.mat'],'feat_HD','feat_STR_GPe')
cmap = brewermap(30,'Spectral');
R.CONnames = {'M2 -> STN','STR -| GPe','GPe -| STN','STN -> GPe'};
R.condname = {'Fitted','1% M2->STN','150% M2->STN','Fitted','1% STN->GPe','150% STN->GPe'};
cmap1 = brewermap(40,'Reds');
% cmap1(22,:) = [0 0 0];
cmap2 = brewermap(40,'Blues');
% cmap2(28,:) = [0 0 0];
ip = 0;
for CON = [1 3]
    ip = ip + 1;
    load([rootan '\BB_' R.out.tag '_ConnectionSweep_CON_' num2str(CON) '_feat_F1.mat'])
    figure(1)
    subplot(2,2,ip)
    plotSweepSpectra(R.frqz,feat,feat{6},cmap1,{R.condname{[2 1 3]}},[1 5 15],1:5:35,[1,1,1])
    title(R.CONnames{CON})
    ylim([1e-15 1e-13])
    set(gca, 'YScale', 'log', 'XScale', 'log')
    
    figure(2)
    subplot(2,2,ip)
    plotSweepSpectra(R.frqz,feat,feat{6},cmap1,{R.condname{[2 1 3]}},[1 5 15],1:5:35,[1,4,4])
    title(R.CONnames{CON})
    %     ylim([1e-16 1e-11])
    
end
% set(gcf,'Position',[684         501        1024         366])

% ck_1 = logspace(-1,0.7,30);

% cmap = brewermap(30,'Reds');

ip = 0;
for CON = [1 3]
        ip = ip + 1;
    load([rootan '\BB_' R.out.tag '_ConnectionSweep_CON_' num2str(CON) '_ck_1_F1.mat'])
    load([rootan '\BB_' R.out.tag '_ConnectionSweep_CON_' num2str(CON) '_feat_F1.mat'])
    bpow = []; fpow = [];
    for ck = 1:numel(feat)
        [bpowr_br(ck) b] = max(feat{ck}(1,1,1,3,R.frqz>14 & R.frqz<21));
        fpow_br(ck) = R.frqz(b) + R.frqz(1);
        [bpowr(ck) b] = max(feat{ck}(1,1,1,3,R.frqz>14 & R.frqz<30));
        fpow(ck) = R.frqz(b) + R.frqz(1);
        [bcohr(ck) b] = max(feat{ck}(1,4,1,4,R.frqz>14 & R.frqz<30));
        fcoh(ck) = R.frqz(b) + R.frqz(1);
    end
        ck_1 = ck_1(CON,:); % The scale for this connection modification

    % Scale bpow to 0
    [a zind] = min(abs(ck_1-1)); % base model
    bpowr = 100*(bpowr-bpowr(zind))/bpowr(zind);
    bpowr_br = 100*(bpowr_br-bpowr_br(zind))/bpowr_br(zind);
        bcohr = 100*(bcohr-bcohr(zind))/bcohr(zind);

    % Remove non-physiological
    powInds = find(bpowr>500);
    fpow(powInds) = nan(1,numel(powInds));
    bpow(powInds) = nan(1,numel(powInds));
        bpowr(powInds) = nan(1,numel(powInds));
    fcoh(powInds) = nan(1,numel(powInds));
    bcohr(powInds) = nan(1,numel(powInds));
    

        bsel = 1:5:35;
   
    figure(1)
    subplot(2,2,ip+2)
    br = plot(ck_1(1,:)*100,(bpowr(:)),'k-');
    hold on
    Sr = scatter(ck_1(1,bsel)*100,(bpowr(bsel)),50,cmap1(bsel,:),'filled');
    ylabel('log % of STN Fitted Power')
    grid on; set(gca,"XScale",'log')
    
    yyaxis right
    br = plot(ck_1(1,:)*100,(fpow(:)),':');
    hold on
    Sr = scatter(ck_1(1,bsel)*100,(fpow(bsel)),50,cmap2(bsel,:),'filled');
    Sr.Marker = 'diamond';
    ylabel('Peak Frequency (Hz)')
    xlabel('log_{10} % Connection Strength')
    title(R.CONnames{CON})
    xlim([10 1000]); 
    ylim([12 25])
    yyaxis left
    ylim([-100 200])
    
    figure(2)
    subplot(2,2,ip+2)
    br = plot(ck_1(1,:)*100,bcohr(:),'k-');
    hold on
    Sr = scatter(ck_1(1,bsel)*100,bcohr(bsel),50,cmap1(bsel,:),'filled');
    ylabel('M2/STN Coherence')
    grid on; set(gca,"XScale",'log')
    
    yyaxis right
    br = plot(ck_1(1,:)*100,(fcoh(:)),':');
    hold on
    Sr = scatter(ck_1(1,bsel)*100,(fcoh(bsel)),50,cmap2(bsel,:),'filled');
    Sr.Marker = 'diamond';
    ylabel('Peak Coh. Frequency (Hz)')
    xlabel('log_{10} % Connection Strength')
    title(R.CONnames{CON})
    xlim([10 1000]); 
    ylim([12 25])
    yyaxis left
    ylim([-75 75])

end
% R.betaKrange = betaKrange;
% R.betaKrange(3,3) = 19;
