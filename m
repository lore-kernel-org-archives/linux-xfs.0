Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6C17sRD253875 for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 20:07:54 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F15B21B88500
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 18:10:47 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id 4AlEvNmxBa1HlHFE for
	<xfs@oss.sgi.com>; Sun, 11 Jul 2010 18:10:47 -0700 (PDT)
Received: from [128.114.125.112] (HELO ucsc.edu)
	by email-prod-out-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPS id 15019274 for xfs@oss.sgi.com;
	Sun, 11 Jul 2010 18:10:46 -0700
Received: from [98.234.26.5] (account ermorris@ucsc.edu HELO [10.0.1.3])
	by email-prod-fe-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPSA id 355238711 for xfs@oss.sgi.com;
	Sun, 11 Jul 2010 18:10:41 -0700
From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: filesystem shrinks after using xfs_repair
Date: Sun, 11 Jul 2010 18:10:41 -0700
Message-Id: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
Mime-Version: 1.0 (Apple Message framework v1081)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi guys,

Here are some of the log files from my XFS problem. Yes, I think this all started with a hardware failure of some sort. My storage is RAID 6, a an Astra SecureStor ES.


[root@nimbus log]# more messages.1 | grep I/O
Jul  2 17:02:30 nimbus kernel: sd 6:0:0:0: rejecting I/O to offline device
Jul  2 17:02:30 nimbus kernel: sd 6:0:0:0: rejecting I/O to offline device
Jul  2 17:02:30 nimbus kernel: sr 5:0:0:0: rejecting I/O to offline device
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687805082
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687826610
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687827634
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687828658
Jul  3 12:41:41 nimbus kernel: Buffer I/O error on device dm-0, logical block 2835978787
Jul  3 12:41:41 nimbus kernel: lost page write due to I/O error on dm-0
Jul  3 12:41:41 nimbus kernel: Buffer I/O error on device dm-0, logical block 2835978788
Jul  3 12:41:41 nimbus kernel: lost page write due to I/O error on dm-0
Jul  3 12:41:41 nimbus kernel: Buffer I/O error on device dm-0, logical block 2835978789
Jul  3 12:41:41 nimbus kernel: lost page write due to I/O error on dm-0
Jul  3 12:41:41 nimbus kernel: Buffer I/O error on device dm-0, logical block 2835978790
Jul  3 12:41:41 nimbus kernel: lost page write due to I/O error on dm-0
Jul  3 12:41:41 nimbus kernel: Buffer I/O error on device dm-0, logical block 2835978791
Jul  3 12:41:41 nimbus kernel: lost page write due to I/O error on dm-0
Jul  3 12:41:41 nimbus kernel: Buffer I/O error on device dm-0, logical block 2835978792
Jul  3 12:41:41 nimbus kernel: lost page write due to I/O error on dm-0
Jul  3 12:41:41 nimbus kernel: Buffer I/O error on device dm-0, logical block 2835978793
Jul  3 12:41:41 nimbus kernel: lost page write due to I/O error on dm-0
Jul  3 12:41:41 nimbus kernel: Buffer I/O error on device dm-0, logical block 2835978794
Jul  3 12:41:41 nimbus kernel: lost page write due to I/O error on dm-0
Jul  3 12:41:41 nimbus kernel: Buffer I/O error on device dm-0, logical block 2835978795
Jul  3 12:41:41 nimbus kernel: lost page write due to I/O error on dm-0
Jul  3 12:41:41 nimbus kernel: Buffer I/O error on device dm-0, logical block 2835978796
Jul  3 12:41:41 nimbus kernel: lost page write due to I/O error on dm-0
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687814314
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687815338
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687816362
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687817386

Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372371106
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372372130
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372373154
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372374178
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471976114
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471977138
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471978162
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471979186

Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471987386
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471988410
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471989434
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471990458
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471991482
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980261922
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262050
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372375202
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262050
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372376226
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687847114
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687848138
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262114
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980261986
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687849162
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687850186
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687851210
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262434
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687852234
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471991490
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262434
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687853258
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262178
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687854282
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687855306
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980261922
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262498
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262514
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262498
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262242
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262562
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262306
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262594
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262658
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262370
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262722
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262786
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262850
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687798938
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262914
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262978
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687797914
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980263042
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687797906
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980263106
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980263170
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687796882
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980263234
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980263298
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687795858
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980263362
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980263426
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687794834
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980263490
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687793810
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687792786
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687791762
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471975082
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471974058
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687790738
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687789714
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471973034
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471992514
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471993538
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471994562
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471995586
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471996610
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471997634
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471998658
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471999682
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471972010
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471970986
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471969962
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471968938
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471967914
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471966890
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471966882
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372343426
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471999690
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471965858
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12472000714
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12472003786
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12472001738
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12472002762
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12472004810
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471964834
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12472005834
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12472006858
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12472007882
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471963810
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471962786
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372342402
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471961762
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471960738
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471959714
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdd, sector 12471958690
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372330106
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687855314
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687856338
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687857362
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687858386
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687859410
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687860434
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372277834
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687861458
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687862482
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 22687863506
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372327026
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372324978
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372328058
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372376234
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372377258
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372378282
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372379306
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372380330
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372381354
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372382378
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372383402
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372384426
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372320882
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372327034
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372326002
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372329082
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372323954
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372341378
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372340354
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372339330
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372338306
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372337282
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372336258
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372335234
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372335226
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372334202
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372333178
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372332154
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdc, sector 24372331130
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980261922
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262114
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262178
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262242
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262306
Jul  3 12:41:41 nimbus kernel: end_request: I/O error, dev sdg, sector 1980262370
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 22687804058
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 159634
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 159634
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 159634
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 22687803034
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 159634
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 159634
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 159634
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 159634
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 22687802010
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 22687800986
Jul  3 12:41:42 nimbus kernel: end_request: I/O error, dev sdc, sector 22687799962
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x26df0       ("xfs_trans_read_buf") error 5 buf count 8192
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 12:41:42 nimbus kernel: I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x32ee86931       ("xlog_iodone") error 5 buf count 24576
Jul  3 12:41:42 nimbus kernel: Filesystem "dm-0": Log I/O Error Detected.  Shutting down filesystem: dm-0
Jul  3 12:41:42 nimbus kernel: scsi 1:0:0:0: rejecting I/O to dead device
Jul  3 13:42:57 nimbus kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul  3 13:42:57 nimbus kernel: serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Jul  3 13:42:57 nimbus kernel: 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul  3 13:42:57 nimbus kernel: 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[root@nimbus log]# 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
