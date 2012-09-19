Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JDueaF206466 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 08:56:40 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id YObAX89fccgdTHf2 for
	<xfs@oss.sgi.com>; Wed, 19 Sep 2012 06:57:50 -0700 (PDT)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 488014C8070
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 15:57:46 +0200 (CEST)
Date: Wed, 19 Sep 2012 15:57:48 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: XFS corruption with rsync
Message-ID: <20120919155748.620e9230@harpe.intellique.com>
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


I'"ve seen this error showing up on the list previously: while
rsync'ing a large volume (66 TB copied to a 114 TB filesystem), I've got
this error showing up:


Pid: 2069, comm: rsync Not tainted 3.2.28-storiq64-opteron #1
Call Trace:
 [<ffffffff811e037f>] ? xfs_alloc_fixup_trees+0x22f/0x370
 [<ffffffff811f6ee3>] ? xfs_btree_get_rec+0x53/0x90
 [<ffffffff811e32ee>] ? xfs_alloc_ag_vextent_near+0x83e/0xbe0
 [<ffffffff811e3b4b>] ? xfs_alloc_fix_freelist+0x3cb/0x460
 [<ffffffff811e3755>] ? xfs_alloc_ag_vextent+0xc5/0xf0
 [<ffffffff811e40ba>] ? xfs_alloc_vextent+0x3aa/0x5f0
 [<ffffffff81222d4a>] ? xfs_trans_read_buf+0x22a/0x420
 [<ffffffff8120a857>] ? xfs_ialloc_ag_alloc+0x3c7/0x4d0
 [<ffffffff8120aa2b>] ? xfs_dialloc+0xcb/0x870
 [<ffffffff81077ffd>] ? up+0xd/0x40
 [<ffffffff8120d705>] ? xfs_ialloc+0x75/0x760
 [<ffffffff811df986>] ? kmem_zone_alloc+0x66/0xe0
 [<ffffffff811dbc23>] ? xfs_dir_ialloc+0x93/0x330
 [<ffffffff812198bd>] ? xfs_trans_reserve+0x9d/0x210
 [<ffffffff811df705>] ? xfs_create+0x455/0x670
 [<ffffffff811d4286>] ? xfs_vn_mknod+0xa6/0x1b0
 [<ffffffff8110f129>] ? vfs_create+0x89/0xc0
 [<ffffffff811107a0>] ? do_last+0x550/0x750
 [<ffffffff811112bb>] ? path_openat+0xdb/0x3d0
 [<ffffffff81103617>] ? do_sync_write+0xc7/0x100
 [<ffffffff810e43e6>] ? handle_mm_fault+0x226/0x270
 [<ffffffff811116dd>] ? do_filp_open+0x4d/0xc0
 [<ffffffff8111d923>] ? alloc_fd+0x43/0x130
 [<ffffffff81102fb5>] ? do_sys_open+0x105/0x1e0
 [<ffffffff81424652>] ? system_call_fastpath+0x16/0x1b


Rsync logs says that "structure needs cleaning". After running
xfs_repair, there's a few files making reference to a free block. 

This machine has had serious filesystem failure previously, but the
RAID array and filesystem have been rebuild from the ground up, so it
should be OK; however I'd like to be really sure there's no hidden
hardware glitch waiting to bite us again...

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
