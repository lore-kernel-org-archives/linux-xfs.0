Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1BEMVHp152523 for <xfs@oss.sgi.com>; Thu, 11 Feb 2010 08:22:31 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34C6F1C5961
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2010 06:23:44 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id lkM0FQlQ14ebEewf for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2010 06:23:44 -0800 (PST)
Date: Thu, 11 Feb 2010 09:23:44 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.32.3 x86_64 - XFS hangs, all I/O to D-state bug (again)
In-Reply-To: <alpine.DEB.2.00.1002110912120.25392@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1002110921550.25392@p34.internal.lan>
References: <alpine.DEB.2.00.1002110903080.25392@p34.internal.lan>
	<alpine.DEB.2.00.1002110912120.25392@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

Is this normal?  After the crash I just showed, the system was rebooted,
it is resyncing now but is this normal?

$ cat /proc/mdstat 
Personalities : [raid1] [raid6] [raid5] [raid4] 
md1 : active raid1 sdb2[1] sda2[0]
       136448 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
       129596288 blocks [2/2] [UU]

md3 : active raid5 sdj1[7] sdi1[6] sdh1[5] sdf1[3] sdg1[4] sde1[2] sdd1[1] sdc1[0]
       5128001536 blocks level 5, 1024k chunk, algorithm 2 [8/8] [UUUUUUUU]
       [==>..................]  resync = 12.3% (90186112/732571648) finish=1046.9min speed=10226K/sec

md0 : active raid1 sdb1[1] sda1[0]
       16787776 blocks [2/2] [UU]

unused devices: <none>

--

root        24  0.3  0.0      0     0 ?        S    07:37   0:23 [async/mgr]
root     15514  0.2  0.0      0     0 ?        S    08:04   0:11 [async/0]
root     15515  0.2  0.0      0     0 ?        S    08:04   0:09 [async/1]
root     15516  0.2  0.0      0     0 ?        S    08:04   0:10 [async/2]
root     15517  0.2  0.0      0     0 ?        S    08:04   0:09 [async/3]
root     15518  0.2  0.0      0     0 ?        S    08:04   0:10 [async/4]
root     15519  0.2  0.0      0     0 ?        S    08:04   0:10 [async/5]
root     15520  0.2  0.0      0     0 ?        S    08:04   0:11 [async/6]
root     15521  0.2  0.0      0     0 ?        S    08:04   0:10 [async/7]
root     15522  0.2  0.0      0     0 ?        S    08:04   0:10 [async/8]
root     15523  0.2  0.0      0     0 ?        S    08:04   0:10 [async/9]
root     15524  0.2  0.0      0     0 ?        S    08:04   0:10 [async/10]
root     15525  0.2  0.0      0     0 ?        S    08:04   0:10 [async/11]
root     15526  0.2  0.0      0     0 ?        S    08:04   0:11 [async/12]
root     15527  0.2  0.0      0     0 ?        S    08:04   0:10 [async/13]
root     15528  0.2  0.0      0     0 ?        S    08:04   0:11 [async/14]
root     15529  0.2  0.0      0     0 ?        S    08:04   0:10 [async/15]
root     15530  0.2  0.0      0     0 ?        S    08:04   0:10 [async/16]
root     15531  0.2  0.0      0     0 ?        S    08:04   0:11 [async/17]
root     15532  0.2  0.0      0     0 ?        S    08:04   0:11 [async/18]
root     15533  0.2  0.0      0     0 ?        S    08:04   0:11 [async/19]
root     15534  0.2  0.0      0     0 ?        S    08:04   0:11 [async/20]
root     15535  0.2  0.0      0     0 ?        S    08:04   0:11 [async/21]
root     15536  0.2  0.0      0     0 ?        S    08:04   0:10 [async/22]
root     15537  0.2  0.0      0     0 ?        S    08:04   0:10 [async/23]
root     15538  0.2  0.0      0     0 ?        S    08:04   0:11 [async/24]
root     15539  0.2  0.0      0     0 ?        S    08:04   0:11 [async/25]
root     15540  0.2  0.0      0     0 ?        S    08:04   0:11 [async/26]
root     15541  0.2  0.0      0     0 ?        S    08:04   0:11 [async/27]
root     15542  0.2  0.0      0     0 ?        S    08:04   0:10 [async/28]
root     15543  0.2  0.0      0     0 ?        S    08:04   0:12 [async/29]
root     15544  0.2  0.0      0     0 ?        S    08:04   0:10 [async/30]
root     15545  0.2  0.0      0     0 ?        S    08:04   0:11 [async/31]
root     15546  0.2  0.0      0     0 ?        R    08:04   0:11 [async/32]
root     15547  0.2  0.0      0     0 ?        S    08:04   0:11 [async/33]
root     15548  0.2  0.0      0     0 ?        S    08:04   0:11 [async/34]
root     15549  0.2  0.0      0     0 ?        R    08:04   0:11 [async/35]
root     15550  0.2  0.0      0     0 ?        S    08:04   0:11 [async/36]
root     15551  0.2  0.0      0     0 ?        S    08:04   0:11 [async/37]
root     15552  0.2  0.0      0     0 ?        S    08:04   0:11 [async/38]
root     15553  0.2  0.0      0     0 ?        S    08:04   0:10 [async/39]
root     15554  0.2  0.0      0     0 ?        S    08:04   0:11 [async/40]
root     15555  0.2  0.0      0     0 ?        S    08:04   0:11 [async/41]
root     15556  0.2  0.0      0     0 ?        S    08:04   0:11 [async/42]
root     15557  0.2  0.0      0     0 ?        S    08:04   0:10 [async/43]
root     15558  0.2  0.0      0     0 ?        S    08:04   0:10 [async/44]
root     15559  0.2  0.0      0     0 ?        R    08:04   0:11 [async/45]
root     15560  0.2  0.0      0     0 ?        S    08:04   0:10 [async/46]
root     15561  0.2  0.0      0     0 ?        S    08:04   0:11 [async/47]
root     15562  0.2  0.0      0     0 ?        S    08:04   0:10 [async/48]
root     15563  0.2  0.0      0     0 ?        S    08:04   0:11 [async/49]
root     15564  0.2  0.0      0     0 ?        S    08:04   0:11 [async/50]
root     15565  0.2  0.0      0     0 ?        R    08:04   0:11 [async/51]
root     15566  0.2  0.0      0     0 ?        S    08:04   0:11 [async/52]
root     15567  0.2  0.0      0     0 ?        S    08:04   0:11 [async/53]
root     15568  0.2  0.0      0     0 ?        S    08:04   0:11 [async/54]
root     15569  0.2  0.0      0     0 ?        S    08:04   0:10 [async/55]
root     15570  0.2  0.0      0     0 ?        S    08:04   0:11 [async/56]
root     15571  0.2  0.0      0     0 ?        S    08:04   0:10 [async/57]
root     15572  0.2  0.0      0     0 ?        S    08:04   0:12 [async/58]
root     15573  0.2  0.0      0     0 ?        S    08:04   0:10 [async/59]
root     15574  0.2  0.0      0     0 ?        S    08:04   0:12 [async/60]
root     15575  0.2  0.0      0     0 ?        S    08:04   0:11 [async/61]
root     15576  0.2  0.0      0     0 ?        S    08:04   0:10 [async/62]
root     15577  0.2  0.0      0     0 ?        R    08:04   0:12 [async/63]
root     15578  0.2  0.0      0     0 ?        S    08:04   0:11 [async/64]
root     15579  0.2  0.0      0     0 ?        S    08:04   0:11 [async/65]
root     15580  0.2  0.0      0     0 ?        S    08:04   0:11 [async/66]
root     15581  0.2  0.0      0     0 ?        S    08:04   0:10 [async/67]
root     15582  0.2  0.0      0     0 ?        S    08:04   0:12 [async/68]
root     15583  0.2  0.0      0     0 ?        S    08:04   0:10 [async/69]
root     15584  0.2  0.0      0     0 ?        R    08:04   0:11 [async/70]
root     15585  0.2  0.0      0     0 ?        S    08:04   0:10 [async/71]
root     15586  0.2  0.0      0     0 ?        S    08:04   0:11 [async/72]
root     15587  0.2  0.0      0     0 ?        S    08:04   0:11 [async/73]
root     15588  0.2  0.0      0     0 ?        S    08:04   0:11 [async/74]
root     15589  0.2  0.0      0     0 ?        S    08:04   0:11 [async/75]
root     15590  0.2  0.0      0     0 ?        S    08:04   0:11 [async/76]
root     15591  0.2  0.0      0     0 ?        S    08:04   0:11 [async/77]
root     15592  0.2  0.0      0     0 ?        S    08:04   0:11 [async/78]
root     15593  0.2  0.0      0     0 ?        S    08:04   0:11 [async/79]
root     15594  0.2  0.0      0     0 ?        S    08:04   0:11 [async/80]
root     15595  0.2  0.0      0     0 ?        S    08:04   0:10 [async/81]
root     15596  0.2  0.0      0     0 ?        S    08:04   0:11 [async/82]
root     15597  0.2  0.0      0     0 ?        S    08:04   0:12 [async/83]
root     15598  0.2  0.0      0     0 ?        S    08:04   0:11 [async/84]
root     15599  0.2  0.0      0     0 ?        S    08:04   0:11 [async/85]
root     15600  0.2  0.0      0     0 ?        S    08:04   0:11 [async/86]
root     15601  0.2  0.0      0     0 ?        S    08:04   0:10 [async/87]
root     15602  0.2  0.0      0     0 ?        S    08:04   0:12 [async/88]
root     15603  0.2  0.0      0     0 ?        S    08:04   0:11 [async/89]
root     15604  0.2  0.0      0     0 ?        S    08:04   0:11 [async/90]
root     15605  0.2  0.0      0     0 ?        S    08:04   0:11 [async/91]
root     15606  0.2  0.0      0     0 ?        S    08:04   0:11 [async/92]
root     15607  0.2  0.0      0     0 ?        S    08:04   0:13 [async/93]
root     15608  0.2  0.0      0     0 ?        S    08:04   0:11 [async/94]
root     15609  0.2  0.0      0     0 ?        S    08:04   0:11 [async/95]
root     15610  0.2  0.0      0     0 ?        S    08:04   0:11 [async/96]
root     15611  0.2  0.0      0     0 ?        S    08:04   0:10 [async/97]
root     15612  0.2  0.0      0     0 ?        S    08:04   0:12 [async/98]
root     15613  0.2  0.0      0     0 ?        S    08:04   0:11 [async/99]
root     15614  0.2  0.0      0     0 ?        S    08:04   0:11 [async/100]
root     15615  0.2  0.0      0     0 ?        S    08:04   0:11 [async/101]
root     15616  0.2  0.0      0     0 ?        S    08:04   0:11 [async/102]
root     15617  0.2  0.0      0     0 ?        S    08:04   0:12 [async/103]
root     15618  0.2  0.0      0     0 ?        S    08:04   0:11 [async/104]
root     15619  0.2  0.0      0     0 ?        R    08:04   0:12 [async/105]
root     15620  0.2  0.0      0     0 ?        S    08:04   0:11 [async/106]
root     15621  0.2  0.0      0     0 ?        S    08:04   0:10 [async/107]
root     15622  0.2  0.0      0     0 ?        S    08:04   0:12 [async/108]
root     15623  0.2  0.0      0     0 ?        S    08:04   0:12 [async/109]
root     15624  0.2  0.0      0     0 ?        S    08:04   0:11 [async/110]
root     15625  0.2  0.0      0     0 ?        S    08:04   0:11 [async/111]
root     15626  0.2  0.0      0     0 ?        S    08:04   0:11 [async/112]
root     15627  0.2  0.0      0     0 ?        S    08:04   0:12 [async/113]
root     15628  0.2  0.0      0     0 ?        S    08:04   0:12 [async/114]
root     15629  0.2  0.0      0     0 ?        S    08:04   0:12 [async/115]
root     15630  0.2  0.0      0     0 ?        S    08:04   0:12 [async/116]
root     15631  0.2  0.0      0     0 ?        S    08:04   0:10 [async/117]
root     15632  0.2  0.0      0     0 ?        S    08:04   0:12 [async/118]
root     15633  0.2  0.0      0     0 ?        S    08:04   0:11 [async/119]
root     15634  0.2  0.0      0     0 ?        S    08:04   0:11 [async/120]
root     15635  0.2  0.0      0     0 ?        S    08:04   0:11 [async/121]
root     15636  0.2  0.0      0     0 ?        S    08:04   0:11 [async/122]
root     15637  0.2  0.0      0     0 ?        S    08:04   0:12 [async/123]
root     15638  0.2  0.0      0     0 ?        R    08:04   0:11 [async/124]
root     15639  0.2  0.0      0     0 ?        S    08:04   0:11 [async/125]
root     15640  0.2  0.0      0     0 ?        S    08:04   0:12 [async/126]
root     15641  0.2  0.0      0     0 ?        S    08:04   0:10 [async/127]
root     15642  0.2  0.0      0     0 ?        S    08:04   0:12 [async/128]
root     15643  0.2  0.0      0     0 ?        S    08:04   0:12 [async/129]
root     15644  0.2  0.0      0     0 ?        S    08:04   0:11 [async/130]
root     15645  0.2  0.0      0     0 ?        S    08:04   0:11 [async/131]
root     15646  0.2  0.0      0     0 ?        S    08:04   0:11 [async/132]
root     15647  0.2  0.0      0     0 ?        S    08:04   0:12 [async/133]
root     15648  0.2  0.0      0     0 ?        S    08:04   0:12 [async/134]
root     15649  0.2  0.0      0     0 ?        S    08:04   0:11 [async/135]
root     15650  0.2  0.0      0     0 ?        S    08:04   0:11 [async/136]
root     15651  0.2  0.0      0     0 ?        S    08:04   0:11 [async/137]
root     15652  0.2  0.0      0     0 ?        S    08:04   0:12 [async/138]
root     15653  0.2  0.0      0     0 ?        S    08:04   0:11 [async/139]
root     15654  0.2  0.0      0     0 ?        S    08:04   0:11 [async/140]
root     15655  0.2  0.0      0     0 ?        S    08:04   0:11 [async/141]
root     15656  0.2  0.0      0     0 ?        S    08:04   0:11 [async/142]
root     15657  0.2  0.0      0     0 ?        S    08:04   0:12 [async/143]
root     15658  0.2  0.0      0     0 ?        S    08:04   0:11 [async/144]
root     15659  0.2  0.0      0     0 ?        S    08:04   0:11 [async/145]
root     15660  0.2  0.0      0     0 ?        S    08:04   0:11 [async/146]
root     15661  0.2  0.0      0     0 ?        S    08:04   0:11 [async/147]
root     15662  0.2  0.0      0     0 ?        S    08:04   0:12 [async/148]
root     15663  0.2  0.0      0     0 ?        S    08:04   0:11 [async/149]
root     15664  0.2  0.0      0     0 ?        S    08:04   0:11 [async/150]
root     15665  0.2  0.0      0     0 ?        S    08:04   0:11 [async/151]
root     15666  0.2  0.0      0     0 ?        S    08:04   0:11 [async/152]
root     15667  0.2  0.0      0     0 ?        S    08:04   0:12 [async/153]
root     15668  0.2  0.0      0     0 ?        S    08:04   0:11 [async/154]
root     15669  0.2  0.0      0     0 ?        S    08:04   0:11 [async/155]
root     15670  0.2  0.0      0     0 ?        S    08:04   0:11 [async/156]
root     15671  0.2  0.0      0     0 ?        S    08:04   0:11 [async/157]
root     15672  0.2  0.0      0     0 ?        S    08:04   0:13 [async/158]
root     15673  0.2  0.0      0     0 ?        S    08:04   0:11 [async/159]
root     15674  0.2  0.0      0     0 ?        S    08:04   0:11 [async/160]
root     15675  0.2  0.0      0     0 ?        S    08:04   0:11 [async/161]
root     15676  0.2  0.0      0     0 ?        S    08:04   0:10 [async/162]
root     15677  0.2  0.0      0     0 ?        S    08:04   0:12 [async/163]
root     15678  0.2  0.0      0     0 ?        S    08:04   0:11 [async/164]
root     15679  0.2  0.0      0     0 ?        S    08:04   0:11 [async/165]
root     15680  0.2  0.0      0     0 ?        S    08:04   0:11 [async/166]
root     15681  0.2  0.0      0     0 ?        S    08:04   0:11 [async/167]
root     15682  0.2  0.0      0     0 ?        S    08:04   0:12 [async/168]
root     15683  0.2  0.0      0     0 ?        S    08:04   0:11 [async/169]
root     15684  0.2  0.0      0     0 ?        R    08:04   0:11 [async/170]
root     15685  0.2  0.0      0     0 ?        S    08:04   0:11 [async/171]
root     15686  0.2  0.0      0     0 ?        S    08:04   0:10 [async/172]
root     15687  0.2  0.0      0     0 ?        S    08:04   0:12 [async/173]
root     15688  0.2  0.0      0     0 ?        S    08:04   0:11 [async/174]
root     15689  0.2  0.0      0     0 ?        S    08:04   0:11 [async/175]
root     15690  0.2  0.0      0     0 ?        S    08:04   0:11 [async/176]
root     15691  0.2  0.0      0     0 ?        S    08:04   0:11 [async/177]
root     15692  0.2  0.0      0     0 ?        S    08:04   0:12 [async/178]
root     15693  0.2  0.0      0     0 ?        S    08:04   0:10 [async/179]
root     15694  0.2  0.0      0     0 ?        S    08:04   0:12 [async/180]
root     15695  0.2  0.0      0     0 ?        S    08:04   0:11 [async/181]
root     15696  0.2  0.0      0     0 ?        S    08:04   0:10 [async/182]
root     15697  0.2  0.0      0     0 ?        S    08:04   0:12 [async/183]
root     15698  0.2  0.0      0     0 ?        R    08:04   0:11 [async/184]
root     15699  0.2  0.0      0     0 ?        S    08:04   0:11 [async/185]
root     15700  0.2  0.0      0     0 ?        S    08:04   0:11 [async/186]
root     15701  0.2  0.0      0     0 ?        S    08:04   0:10 [async/187]
root     15702  0.2  0.0      0     0 ?        R    08:04   0:12 [async/188]
root     15703  0.2  0.0      0     0 ?        S    08:04   0:10 [async/189]
root     15704  0.2  0.0      0     0 ?        R    08:04   0:11 [async/190]
root     15705  0.2  0.0      0     0 ?        S    08:04   0:11 [async/191]
root     15706  0.2  0.0      0     0 ?        R    08:04   0:11 [async/192]
root     15707  0.2  0.0      0     0 ?        S    08:04   0:11 [async/193]
root     15708  0.2  0.0      0     0 ?        R    08:04   0:11 [async/194]
root     15709  0.2  0.0      0     0 ?        S    08:04   0:11 [async/195]
root     15710  0.2  0.0      0     0 ?        S    08:04   0:11 [async/196]
root     15711  0.2  0.0      0     0 ?        R    08:04   0:10 [async/197]
root     15712  0.2  0.0      0     0 ?        R    08:04   0:12 [async/198]
root     15713  0.2  0.0      0     0 ?        S    08:04   0:11 [async/199]
root     15714  0.2  0.0      0     0 ?        S    08:04   0:11 [async/200]
root     15715  0.2  0.0      0     0 ?        R    08:04   0:11 [async/201]
root     15716  0.2  0.0      0     0 ?        S    08:04   0:11 [async/202]
root     15717  0.2  0.0      0     0 ?        R    08:04   0:12 [async/203]
root     15718  0.2  0.0      0     0 ?        R    08:04   0:11 [async/204]
root     15719  0.2  0.0      0     0 ?        S    08:04   0:11 [async/205]
root     15720  0.2  0.0      0     0 ?        R    08:04   0:11 [async/206]
root     15721  0.2  0.0      0     0 ?        R    08:04   0:11 [async/207]
root     15722  0.2  0.0      0     0 ?        S    08:04   0:12 [async/208]
root     15723  0.2  0.0      0     0 ?        R    08:04   0:11 [async/209]
root     15724  0.2  0.0      0     0 ?        S    08:04   0:11 [async/210]
root     15725  0.2  0.0      0     0 ?        R    08:04   0:11 [async/211]
root     15726  0.2  0.0      0     0 ?        S    08:04   0:11 [async/212]
root     15727  0.2  0.0      0     0 ?        R    08:04   0:12 [async/213]
root     15728  0.2  0.0      0     0 ?        S    08:04   0:11 [async/214]
root     15729  0.2  0.0      0     0 ?        R    08:04   0:12 [async/215]
root     15730  0.2  0.0      0     0 ?        S    08:04   0:11 [async/216]
root     15731  0.2  0.0      0     0 ?        R    08:04   0:11 [async/217]
root     15732  0.2  0.0      0     0 ?        S    08:04   0:12 [async/218]
root     15733  0.2  0.0      0     0 ?        R    08:04   0:11 [async/219]
root     15734  0.2  0.0      0     0 ?        S    08:04   0:11 [async/220]
root     15735  0.2  0.0      0     0 ?        R    08:04   0:11 [async/221]
root     15736  0.2  0.0      0     0 ?        R    08:04   0:11 [async/222]
root     15737  0.2  0.0      0     0 ?        R    08:04   0:12 [async/223]
root     15738  0.2  0.0      0     0 ?        S    08:04   0:11 [async/224]
root     15739  0.2  0.0      0     0 ?        R    08:04   0:11 [async/225]
root     15740  0.2  0.0      0     0 ?        R    08:04   0:12 [async/226]
root     15741  0.2  0.0      0     0 ?        S    08:04   0:11 [async/227]
root     15742  0.2  0.0      0     0 ?        R    08:04   0:12 [async/228]
root     15743  0.2  0.0      0     0 ?        S    08:04   0:11 [async/229]
root     15744  0.2  0.0      0     0 ?        R    08:04   0:11 [async/230]
root     15745  0.2  0.0      0     0 ?        R    08:04   0:11 [async/231]
root     15746  0.2  0.0      0     0 ?        S    08:04   0:11 [async/232]
root     15747  0.2  0.0      0     0 ?        S    08:04   0:12 [async/233]
root     15748  0.2  0.0      0     0 ?        S    08:04   0:11 [async/234]
root     15749  0.2  0.0      0     0 ?        S    08:04   0:12 [async/235]
root     15750  0.2  0.0      0     0 ?        S    08:04   0:12 [async/236]
root     15751  0.2  0.0      0     0 ?        S    08:04   0:11 [async/237]
root     15752  0.2  0.0      0     0 ?        S    08:04   0:13 [async/238]
root     15753  0.2  0.0      0     0 ?        S    08:04   0:12 [async/239]
root     15754  0.2  0.0      0     0 ?        R    08:04   0:12 [async/240]
root     15755  0.2  0.0      0     0 ?        S    08:04   0:13 [async/241]
root     15756  0.3  0.0      0     0 ?        R    08:04   0:15 [async/242]
root     15757  0.2  0.0      0     0 ?        R    08:04   0:13 [async/243]
root     15758  0.2  0.0      0     0 ?        R    08:04   0:13 [async/244]
root     15759  0.2  0.0      0     0 ?        R    08:04   0:13 [async/245]
root     15760  0.3  0.0      0     0 ?        R    08:04   0:14 [async/246]
root     15761  0.5  0.0      0     0 ?        S    08:04   0:24 [async/247]
root     15762  0.3  0.0      0     0 ?        R    08:04   0:16 [async/248]
root     15763  0.4  0.0      0     0 ?        R    08:04   0:18 [async/249]
root     15764  0.4  0.0      0     0 ?        R    08:04   0:20 [async/250]
root     15765  0.5  0.0      0     0 ?        R    08:04   0:25 [async/251]
root     15766  0.8  0.0      0     0 ?        R    08:04   0:37 [async/252]
root     15767  1.3  0.0      0     0 ?        R    08:04   1:01 [async/253]
root     15768  1.9  0.0      0     0 ?        S    08:04   1:30 [async/254]
root     15769  2.1  0.0      0     0 ?        R    08:04   1:40 [async/255]



On Thu, 11 Feb 2010, Justin Piszcz wrote:

> The errors in the e-mail had bad formatting, please see the following: 
> http://home.comcast.net/~jpiszcz/20100211/crash.txt
>
> In addition, the linux-raid list had a typo in it, fixed.
>
> On Thu, 11 Feb 2010, Justin Piszcz wrote:
>
>> Hello,
>> 
>> While tarring and compressing (bzip2) a lot of files, the following error
>> occurred, note the output is not clean because this was taken from 
>> netconsole.
>> 
>> When this occurs, the host cannot be rebooted with reboot/proceses cannot
>> be killed and the box locks up.  There are no apparent hardware issues.
>> 
>> Before, asterisk would trigger this bug, since asterisk no longer runs on 
>> this host, it ran for ~2-3 months without any problems, until now.
>> 
>> Please cc me as I am not on the lists, thanks.
>> 
>> Is this a md raid issue or XFS? From the trace it appears to be an XFS bug?
>> 
>> Feb 11 07:38:14 l1 [   20.270270] e100: eth1 NIC Link is Up 100 Mbps Full 
>> Duplex Feb 11 07:47:54 l1 [  600.432165] INFO: task scp:4871 blocked for 
>> more than 120 seconds. Feb 11 07:47:54 l1 [  600.432177] "echo 0 > 
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message. Feb 11 
>> 07:47:54 l1 [  600.432182] scp           D
>> Feb 11 07:47:54 l1  ffff8801eee6f14c Feb 11 07:47:54 l1     0  4871   4870 
>> 0x00000000 Feb 11 07:47:54 l1 [  600.432188]  ffff880220c87950
>> Feb 11 07:47:54 l1  0000000000000082
>> Feb 11 07:47:54 l1  0000000000200200
>> Feb 11 07:47:54 l1  ffff88023eb71400
>> Feb 11 07:47:54 l1 Feb 11 07:47:54 l1 [  600.432196]  000000000000c928
>> Feb 11 07:47:54 l1  ffff8801f7a55fd8
>> Feb 11 07:47:54 l1  ffff880205fc6150
>> Feb 11 07:47:54 l1  ffff880205fc63c8
>> Feb 11 07:47:54 l1 Feb 11 07:47:54 l1 [  600.432203]  0000000000001000
>> Feb 11 07:47:54 l1  ffffffff8108d02a
>> Feb 11 07:47:54 l1  ffff8801eee6f0c0
>> Feb 11 07:47:54 l1  ffff880205fc63c8
>> Feb 11 07:47:54 l1 Feb 11 07:47:54 l1 [  600.432209] Call Trace: Feb 11 
>> 07:47:54 l1 [  600.432230]  [<ffffffff8108d02a>] ? 
>> generic_file_buffered_write+0x1aa/0x290 Feb 11 07:47:54 l1 [  600.432236] 
>> [<ffffffff8145f02d>] ? __down_write_nested+0x7d/0xb0 Feb 11 07:47:54 l1 [ 
>> 600.432242]  [<ffffffff8120387d>] ? xfs_write+0x23d/0x950 Feb 11 07:47:54 
>> l1 [  600.432250]  [<ffffffff810ba913>] ? do_sync_write+0xe3/0x130 Feb 11 
>> 07:47:54 l1 [  600.432260]  [<ffffffff8106dd90>] ? 
>> autoremove_wake_function+0x0/0x30 Feb 11 07:47:54 l1 [  600.432266] 
>> [<ffffffff810e9654>] ? fsnotify+0x4/0x1a0 Feb 11 07:47:54 l1 [  600.432271] 
>> [<ffffffff8102f78e>] ? common_interrupt+0xe/0x13 Feb 11 07:47:54 l1 [ 
>> 600.432276]  [<ffffffff810bb45b>] ? vfs_write+0xcb/0x180 Feb 11 07:47:54 l1 
>> [ 600.432280]  [<ffffffff810bb613>] ? sys_write+0x53/0xa0 Feb 11 07:47:54 
>> l1 [ 600.432285]  [<ffffffff8102eeeb>] ? system_call_fastpath+0x16/0x1b Feb 
>> 11 07:47:54 l1 [  600.432291] INFO: task flush-9:3:4874 blocked for more 
>> than 120 seconds. Feb 11 07:47:54 l1 [  600.432294] "echo 0 > 
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message. Feb 11 
>> 07:47:54 l1 [  600.432297] flush-9:3     D
>> Feb 11 07:47:54 l1  ffff88021948d750 Feb 11 07:47:54 l1     0  4874      2 
>> 0x00000000 Feb 11 07:47:54 l1 [  600.432309]  ffff88023fa3c8c0
>> Feb 11 07:47:54 l1  0000000000000046
>> Feb 11 07:47:54 l1  000000001948d750
>> Feb 11 07:47:54 l1  ffffffff8163d788
>> Feb 11 07:47:54 l1 Feb 11 07:47:54 l1 [  600.432323]  000000000000c928
>> Feb 11 07:47:54 l1  ffff8801f79fbfd8
>> Feb 11 07:47:54 l1  ffff88021948d750
>> Feb 11 07:47:54 l1  ffff88021948d9c8
>> Feb 11 07:47:54 l1 Feb 11 07:47:54 l1 [  600.432329]  000000013f467bb0
>> Feb 11 07:47:54 l1  ffffffff8108c183
>> Feb 11 07:47:54 l1  0000000000000000
>> Feb 11 07:47:54 l1  ffff88021948d9c8
>> Feb 11 07:47:54 l1 Feb 11 07:47:54 l1 [  600.432337] Call Trace: Feb 11 
>> 07:47:54 l1 [  600.432341]  [<ffffffff8108c183>] ? find_lock_page+0x23/0x80 
>> Feb 11 07:47:54 l1 [  600.432344]  [<ffffffff8108cbb1>] ? 
>> find_or_create_page+0x41/0xc0 Feb 11 07:47:54 l1 [  600.432349] 
>> [<ffffffff8145dbc5>] ? schedule_timeout+0x195/0x1f0 Feb 11 07:47:54 l1 [ 
>> 600.432352]  [<ffffffff8145ea81>] ? __down+0x61/0xa0 Feb 11 07:47:54 l1 [ 
>> 600.432356]  [<ffffffff81072046>] ? down+0x46/0x50 Feb 11 07:47:54 l1 [ 
>> 600.432360]  [<ffffffff811ff4a4>] ? _xfs_buf_find+0x134/0x220 Feb 11 
>> 07:47:54 l1 [  600.432363]  [<ffffffff811ff5fe>] ? 
>> xfs_buf_get_flags+0x6e/0x190 Feb 11 07:47:54 l1 [  600.432366] 
>> [<ffffffff811ff732>] ? xfs_buf_read_flags+0x12/0xa0 Feb 11 07:47:54 l1 [ 
>> 600.432371] [<ffffffff811f5226>] ? xfs_trans_read_buf+0x1f6/0x350 Feb 11 
>> 07:47:54 l1 [ 600.432377]  [<ffffffff811b0268>] ? xfs_read_agf+0x68/0x190 
>> Feb 11 07:47:54 l1 [  600.432380]  [<ffffffff811b03c0>] ? 
>> xfs_alloc_read_agf+0x30/0xd0 Feb 11 07:47:54 l1 [  600.432383] 
>> [<ffffffff811b2519>] ? xfs_alloc_fix_freelist+0x379/0x450 Feb 11 07:47:54 
>> l1 [  600.432388] [<ffffffff811ddfe5>] ? xfs_iext_remove+0x35/0x80 Feb 11 
>> 07:47:54 l1 [ 600.432393]  [<ffffffff811bd83f>] ? 
>> xfs_bmap_add_extent_delay_real+0x5ef/0x11a0 Feb 11 07:47:54 l1 [ 
>> 600.432396] [<ffffffff811f4e73>] ? xfs_trans_log_buf+0x63/0xa0 Feb 11 
>> 07:47:54 l1 [ 600.432401]  [<ffffffff811e7410>] ? 
>> xlog_state_get_iclog_space+0x60/0x2c0 Feb 11 07:47:54 l1 [  600.432404] 
>> [<ffffffff8145f087>] ? __down_read+0x17/0xae Feb 11 07:47:54 l1 [ 
>> 600.432408]  [<ffffffff811b29c0>] ? xfs_alloc_vextent+0x310/0x4b0 Feb 11 
>> 07:47:54 l1 [  600.432412] [<ffffffff811bf148>] ? 
>> xfs_bmap_btalloc+0x598/0xa40 Feb 11 07:47:54 l1 [ 600.432417] 
>> [<ffffffff811c19a2>] ? xfs_bmapi+0x9e2/0x11a0 Feb 11 07:47:54 l1 [ 
>> 600.432422]  [<ffffffff811f3d4f>] ? xfs_trans_reserve+0x9f/0x210 Feb 11 
>> 07:47:54 l1 [  600.432425]  [<ffffffff811e2efe>] ? 
>> xfs_iomap_write_allocate+0x23e/0x3b0 Feb 11 07:47:54 l1 [  600.432429] 
>> [<ffffffff811e3aa0>] ? xfs_iomap+0x2c0/0x300 Feb 11 07:47:54 l1 [ 
>> 600.432433]  [<ffffffff811fb875>] ? xfs_map_blocks+0x25/0x30 Feb 11 
>> 07:47:54 l1 [  600.432437]  [<ffffffff811fc9a4>] ? 
>> xfs_page_state_convert+0x414/0x6c0 Feb 11 07:47:54 l1 [  600.432443] 
>> [<ffffffff81224463>] ? radix_tree_gang_lookup_tag_slot+0xc3/0xf0 Feb 11 
>> 07:47:54 l1 [  600.432447] [<ffffffff811fcf57>] ? 
>> xfs_vm_writepage+0x77/0x130 Feb 11 07:47:54 l1 [ 600.432453] 
>> [<ffffffff8109249a>] ? __writepage+0xa/0x40 Feb 11 07:47:54 l1 [ 
>> 600.432456]  [<ffffffff81092c6f>] ? write_cache_pages+0x1df/0x3c0 Feb 11 
>> 07:47:54 l1 [  600.432459]  [<ffffffff81092490>] ? __writepage+0x0/0x40 Feb 
>> 11 07:47:54 l1 [  600.432464]  [<ffffffff810d9092>] ? 
>> writeback_single_inode+0xd2/0x390 Feb 11 07:47:54 l1 [  600.432468] 
>> [<ffffffff810d9f3f>] ? writeback_inodes_wb+0x3ff/0x5e0 Feb 11 07:47:54 l1 [ 
>> 600.432473]  [<ffffffff810da23e>] ? wb_writeback+0x11e/0x1f0 Feb 11 
>> 07:47:54 l1 [  600.432479]  [<ffffffff810630ee>] ? 
>> try_to_del_timer_sync+0x5e/0x90 Feb 11 07:47:54 l1 [  600.432484] 
>> [<ffffffff810da56b>] ? wb_do_writeback+0x17b/0x180 Feb 11 07:47:54 l1 [ 
>> 600.432487] [<ffffffff810da5cd>] ? bdi_writeback_task+0x5d/0xa0 Feb 11 
>> 07:47:54 l1 [ 600.432492]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0 Feb 
>> 11 07:47:54 l1 [  600.432496]  [<ffffffff8109e97e>] ? 
>> bdi_start_fn+0x7e/0xf0 Feb 11 07:47:54 l1 [  600.432499] 
>> [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0 Feb 11 07:47:54 l1 [ 
>> 600.432503]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0 Feb 11 07:47:54 l1 [ 
>> 600.432508]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20 Feb 11 07:47:54 l1 [ 
>> 600.432513]  [<ffffffff8106da20>] ? kthread+0x0/0xa0 Feb 11 07:47:54 l1 [ 
>> 600.432517]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20 Feb 11 07:49:54 l1 [ 
>> 720.432171] INFO: task scp:4871 blocked for more than 120 seconds. Feb 11 
>> 07:49:54 l1 [  720.432187] "echo 0 > 
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message. Feb 11 
>> 07:49:54 l1 [  720.432192] scp           D
>> Feb 11 07:49:54 l1  ffff8801eee6f14c Feb 11 07:49:54 l1     0  4871   4870 
>> 0x00000000 Feb 11 07:49:54 l1 [  720.432198]  ffff880220c87950
>> Feb 11 07:49:54 l1  0000000000000082
>> Feb 11 07:49:54 l1  0000000000200200
>> Feb 11 07:49:54 l1  ffff88023eb71400
>> Feb 11 07:49:54 l1 Feb 11 07:49:54 l1 [  720.432206]  000000000000c928
>> Feb 11 07:49:54 l1  ffff8801f7a55fd8
>> Feb 11 07:49:54 l1  ffff880205fc6150
>> Feb 11 07:49:54 l1  ffff880205fc63c8
>> Feb 11 07:49:54 l1 Feb 11 07:49:54 l1 [  720.432217]  0000000000001000
>> Feb 11 07:49:54 l1  ffffffff8108d02a
>> Feb 11 07:49:54 l1  ffff8801eee6f0c0
>> Feb 11 07:49:54 l1  ffff880205fc63c8
>> Feb 11 07:49:54 l1 Feb 11 07:49:54 l1 [  720.432224] Call Trace: Feb 11 
>> 07:49:54 l1 [  720.432238]  [<ffffffff8108d02a>] ? 
>> generic_file_buffered_write+0x1aa/0x290 Feb 11 07:49:54 l1 [  720.432243] 
>> [<ffffffff8145f02d>] ? __down_write_nested+0x7d/0xb0 Feb 11 07:49:54 l1 [ 
>> 720.432249]  [<ffffffff8120387d>] ? xfs_write+0x23d/0x950 Feb 11 07:49:54 
>> l1 [  720.432254]  [<ffffffff810ba913>] ? do_sync_write+0xe3/0x130 Feb 11 
>> 07:49:54 l1 [  720.432259]  [<ffffffff8106dd90>] ? 
>> autoremove_wake_function+0x0/0x30 Feb 11 07:49:54 l1 [  720.432265] 
>> [<ffffffff810e9654>] ? fsnotify+0x4/0x1a0 Feb 11 07:49:54 l1 [  720.432270] 
>> [<ffffffff8102f78e>] ? common_interrupt+0xe/0x13 Feb 11 07:49:54 l1 [ 
>> 720.432275]  [<ffffffff810bb45b>] ? vfs_write+0xcb/0x180 Feb 11 07:49:54 l1 
>> [ 720.432280]  [<ffffffff810bb613>] ? sys_write+0x53/0xa0 Feb 11 07:49:54 
>> l1 [ 720.432285]  [<ffffffff8102eeeb>] ? system_call_fastpath+0x16/0x1b Feb 
>> 11 07:49:54 l1 [  720.432291] INFO: task flush-9:3:4874 blocked for more 
>> than 120 seconds. Feb 11 07:49:54 l1 [  720.432295] "echo 0 > 
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message. Feb 11 
>> 07:49:54 l1 [  720.432298] flush-9:3     D
>> Feb 11 07:49:54 l1  ffff88021948d750 Feb 11 07:49:54 l1     0  4874      2 
>> 0x00000000 Feb 11 07:49:54 l1 [  720.432306]  ffff88023fa3c8c0
>> Feb 11 07:49:54 l1  0000000000000046
>> Feb 11 07:49:54 l1  000000001948d750
>> Feb 11 07:49:54 l1  ffffffff8163d788
>> Feb 11 07:49:54 l1 Feb 11 07:49:54 l1 [  720.432322]  000000000000c928
>> Feb 11 07:49:54 l1  ffff8801f79fbfd8
>> Feb 11 07:49:54 l1  ffff88021948d750
>> Feb 11 07:49:54 l1  ffff88021948d9c8
>> Feb 11 07:49:54 l1 Feb 11 07:49:54 l1 [  720.432329]  000000013f467bb0
>> Feb 11 07:49:54 l1  ffffffff8108c183
>> Feb 11 07:49:54 l1  0000000000000000
>> Feb 11 07:49:54 l1  ffff88021948d9c8
>> Feb 11 07:49:54 l1 Feb 11 07:49:54 l1 [  720.432336] Call Trace: Feb 11 
>> 07:49:54 l1 [  720.432340]  [<ffffffff8108c183>] ? find_lock_page+0x23/0x80 
>> Feb 11 07:49:54 l1 [  720.432343]  [<ffffffff8108cbb1>] ? 
>> find_or_create_page+0x41/0xc0 Feb 11 07:49:54 l1 [  720.432348] 
>> [<ffffffff8145dbc5>] ? schedule_timeout+0x195/0x1f0 Feb 11 07:49:54 l1 [ 
>> 720.432351]  [<ffffffff8145ea81>] ? __down+0x61/0xa0 Feb 11 07:49:54 l1 [ 
>> 720.432356]  [<ffffffff81072046>] ? down+0x46/0x50 Feb 11 07:49:54 l1 [ 
>> 720.432361]  [<ffffffff811ff4a4>] ? _xfs_buf_find+0x134/0x220 Feb 11 
>> 07:49:54 l1 [  720.432365]  [<ffffffff811ff5fe>] ? 
>> xfs_buf_get_flags+0x6e/0x190 Feb 11 07:49:54 l1 [  720.432368] 
>> [<ffffffff811ff732>] ? xfs_buf_read_flags+0x12/0xa0 Feb 11 07:49:54 l1 [ 
>> 720.432373] [<ffffffff811f5226>] ? xfs_trans_read_buf+0x1f6/0x350 Feb 11 
>> 07:49:54 l1 [ 720.432378]  [<ffffffff811b0268>] ? xfs_read_agf+0x68/0x190 
>> Feb 11 07:49:54 l1 [  720.432382]  [<ffffffff811b03c0>] ? 
>> xfs_alloc_read_agf+0x30/0xd0 Feb 11 07:49:54 l1 [  720.432386] 
>> [<ffffffff811b2519>] ? xfs_alloc_fix_freelist+0x379/0x450 Feb 11 07:49:54 
>> l1 [  720.432391] [<ffffffff811ddfe5>] ? xfs_iext_remove+0x35/0x80 Feb 11 
>> 07:49:54 l1 [ 720.432396]  [<ffffffff811bd83f>] ? 
>> xfs_bmap_add_extent_delay_real+0x5ef/0x11a0 Feb 11 07:49:54 l1 [ 
>> 720.432399] [<ffffffff811f4e73>] ? xfs_trans_log_buf+0x63/0xa0 Feb 11 
>> 07:49:54 l1 [ 720.432404]  [<ffffffff811e7410>] ? 
>> xlog_state_get_iclog_space+0x60/0x2c0 Feb 11 07:49:54 l1 [  720.432410] 
>> [<ffffffff8145f087>] ? __down_read+0x17/0xae Feb 11 07:49:54 l1 [ 
>> 720.432415]  [<ffffffff811b29c0>] ? xfs_alloc_vextent+0x310/0x4b0 Feb 11 
>> 07:49:54 l1 [  720.432420] [<ffffffff811bf148>] ? 
>> xfs_bmap_btalloc+0x598/0xa40 Feb 11 07:49:54 l1 [ 720.432426] 
>> [<ffffffff811c19a2>] ? xfs_bmapi+0x9e2/0x11a0 Feb 11 07:49:54 l1 [ 
>> 720.432430]  [<ffffffff811f3d4f>] ? xfs_trans_reserve+0x9f/0x210 Feb 11 
>> 07:49:54 l1 [  720.432434]  [<ffffffff811e2efe>] ? 
>> xfs_iomap_write_allocate+0x23e/0x3b0 Feb 11 07:49:54 l1 [  720.432437] 
>> [<ffffffff811e3aa0>] ? xfs_iomap+0x2c0/0x300 Feb 11 07:49:54 l1 [ 
>> 720.432441]  [<ffffffff811fb875>] ? xfs_map_blocks+0x25/0x30 Feb 11 
>> 07:49:54 l1 [  720.432445]  [<ffffffff811fc9a4>] ? 
>> xfs_page_state_convert+0x414/0x6c0 Feb 11 07:49:54 l1 [  720.432451] 
>> [<ffffffff81224463>] ? radix_tree_gang_lookup_tag_slot+0xc3/0xf0 Feb 11 
>> 07:49:54 l1 [  720.432455] [<ffffffff811fcf57>] ? 
>> xfs_vm_writepage+0x77/0x130 Feb 11 07:49:54 l1 [ 720.432459] 
>> [<ffffffff8109249a>] ? __writepage+0xa/0x40 Feb 11 07:49:54 l1 [ 
>> 720.432462]  [<ffffffff81092c6f>] ? write_cache_pages+0x1df/0x3c0 Feb 11 
>> 07:49:54 l1 [  720.432466]  [<ffffffff81092490>] ? __writepage+0x0/0x40 Feb 
>> 11 07:49:54 l1 [  720.432472]  [<ffffffff810d9092>] ? 
>> writeback_single_inode+0xd2/0x390 Feb 11 07:49:54 l1 [  720.432476] 
>> [<ffffffff810d9f3f>] ? writeback_inodes_wb+0x3ff/0x5e0 Feb 11 07:49:54 l1 [ 
>> 720.432480]  [<ffffffff810da23e>] ? wb_writeback+0x11e/0x1f0 Feb 11 
>> 07:49:54 l1 [  720.432485]  [<ffffffff810630ee>] ? 
>> try_to_del_timer_sync+0x5e/0x90 Feb 11 07:49:54 l1 [  720.432489] 
>> [<ffffffff810da56b>] ? wb_do_writeback+0x17b/0x180 Feb 11 07:49:54 l1 [ 
>> 720.432493] [<ffffffff810da5cd>] ? bdi_writeback_task+0x5d/0xa0 Feb 11 
>> 07:49:54 l1 [ 720.432497]  [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0 Feb 
>> 11 07:49:54 l1 [  720.432500]  [<ffffffff8109e97e>] ? 
>> bdi_start_fn+0x7e/0xf0 Feb 11 07:49:54 l1 [  720.432503] 
>> [<ffffffff8109e900>] ? bdi_start_fn+0x0/0xf0 Feb 11 07:49:54 l1 [ 
>> 720.432506]  [<ffffffff8106dab6>] ? kthread+0x96/0xa0 Feb 11 07:49:54 l1 [ 
>> 720.432511]  [<ffffffff8102fdfa>] ? child_rip+0xa/0x20 Feb 11 07:49:54 l1 [ 
>> 720.432515]  [<ffffffff8106da20>] ? kthread+0x0/0xa0 Feb 11 07:49:54 l1 [ 
>> 720.432519]  [<ffffffff8102fdf0>] ? child_rip+0x0/0x20
>> 
>> Justin.
>> 
>> 
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
