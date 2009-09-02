Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82DMpYp004377 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 08:23:01 -0500
Received: from nexus.dynaweb.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C7151B886C3
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 06:23:21 -0700 (PDT)
Received: from nexus.dynaweb.hu (nexus.dynaweb.hu [195.70.37.87]) by
	cuda.sgi.com with ESMTP id 7iZN6mzd0f2dO8P8 for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 06:23:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by nexus.dynaweb.hu (Postfix) with ESMTP id A5B304D454
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 15:22:47 +0200 (CEST)
Received: from nexus.dynaweb.hu ([127.0.0.1])
	by localhost (nexus.dynaweb.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F5OKfyZODlOD for <xfs@oss.sgi.com>;
	Wed,  2 Sep 2009 15:22:46 +0200 (CEST)
Received: from raketa.ipn.dynaweb.hu (catv-80-99-36-176.catv.broadband.hu
	[80.99.36.176])
	by nexus.dynaweb.hu (Postfix) with ESMTPSA id 2A22C43B15
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 15:22:46 +0200 (CEST)
Date: Wed, 2 Sep 2009 15:22:45 +0200
From: RUMI Szabolcs <rumi_ml@rtfm.hu>
Subject: Structure needs cleaning? (take #2)
Message-Id: <20090902152245.b2969883.rumi_ml@rtfm.hu>
Mime-Version: 1.0
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

Hi!

Sorry but my previous post was missing the important first two lines: 

d62c8000: 2c 30 78 41 41 41 41 30 30 30 30 2c 36 2c 30 78  ,0xAAAA0000,6,0x
Filesystem "sda10": XFS internal error xfs_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c.  Caller 0xc02cc790

Pid: 29510, comm: mc Tainted: P           2.6.29-gentoo-r5-PAE #1
Call Trace:
 [<c02cc6c4>] xfs_da_do_buf+0x8c4/0x900
 [<c02cc790>] xfs_da_read_buf+0x30/0x40
 [<c02cc790>] xfs_da_read_buf+0x30/0x40
 [<c0191ef0>] pollwake+0x0/0x50
 [<c0191ef0>] pollwake+0x0/0x50
 [<c02cc790>] xfs_da_read_buf+0x30/0x40
 [<c02d2943>] xfs_dir2_leaf_lookup_int+0x63/0x2f0
 [<c02d2943>] xfs_dir2_leaf_lookup_int+0x63/0x2f0
 [<c02d3667>] xfs_dir2_leaf_lookup+0x27/0xc0
 [<c02cf32f>] xfs_dir2_isleaf+0x1f/0x60
 [<c02cfc78>] xfs_dir_lookup+0xd8/0x180
 [<c02fedab>] xfs_lookup+0x6b/0xf0
 [<c0309165>] xfs_vn_lookup+0x55/0xa0
 [<c018adda>] do_lookup+0x1ba/0x1e0
 [<c018ca1d>] __link_path_walk+0x6cd/0xd60
 [<c02d3def>] xfs_dir2_leaf_getdents+0x5ff/0xad0
 [<c018d264>] path_walk+0x54/0xc0
 [<c018d3a3>] do_path_lookup+0x83/0x170
 [<c018c30b>] getname+0x9b/0xe0
 [<c018e03a>] user_path_at+0x5a/0x90
 [<c018633f>] vfs_lstat_fd+0x1f/0x50
 [<c01863bf>] sys_lstat64+0xf/0x30
 [<c0194fd4>] touch_atime+0x14/0x130
 [<c01907b8>] vfs_readdir+0x78/0xb0
 [<c0190891>] sys_getdents64+0xa1/0xd0
 [<c01032f1>] sysenter_do_call+0x12/0x25

Thanks,
Sab

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
