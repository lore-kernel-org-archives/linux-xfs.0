Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3C9Tmtd142921 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 04:29:48 -0500
Received: from sam.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BB7114BCFBF
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 02:33:08 -0700 (PDT)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id VBE1sYEELbu2DgpA for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2011 02:33:08 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.69)
	(envelope-from <lists@nabble.com>) id 1Q9Zy7-0001np-Kv
	for xfs@oss.sgi.com; Tue, 12 Apr 2011 02:33:07 -0700
Message-ID: <31377534.post@talk.nabble.com>
Date: Tue, 12 Apr 2011 02:33:07 -0700 (PDT)
From: stress_buster <leo1783@yahoo.com>
Subject: fs corruption
MIME-Version: 1.0
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


My dmesg output shows the below trace. It repeats over and over again.

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1545 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff881a8961

Call Trace:
 [<ffffffff881a6e27>] :xfs:xfs_free_ag_extent+0x19e/0x67e
 [<ffffffff881a8961>] :xfs:xfs_free_extent+0xa9/0xc9
 [<ffffffff881d96cf>] :xfs:xlog_recover_process_efi+0x112/0x16c
 [<ffffffff881f31b4>] :xfs:xfs_fs_fill_super+0x0/0x3e4
 [<ffffffff881da8c2>] :xfs:xlog_recover_process_efis+0x4f/0x8d
 [<ffffffff881da914>] :xfs:xlog_recover_finish+0x14/0xad
 [<ffffffff881f31b4>] :xfs:xfs_fs_fill_super+0x0/0x3e4
 [<ffffffff881df420>] :xfs:xfs_mountfs+0x498/0x5e2
 [<ffffffff881dfb42>] :xfs:xfs_mru_cache_create+0x113/0x143
 [<ffffffff881f33b7>] :xfs:xfs_fs_fill_super+0x203/0x3e4
 [<ffffffff800e544f>] get_sb_bdev+0x10a/0x16c
 [<ffffffff800e4dec>] vfs_kern_mount+0x93/0x11a
 [<ffffffff800e4eb5>] do_kern_mount+0x36/0x4d
 [<ffffffff800ef2ed>] do_mount+0x6a9/0x719
 [<ffffffff80008d84>] __handle_mm_fault+0x5f2/0xfaa
 [<ffffffff80022127>] __up_read+0x19/0x7f
 [<ffffffff80067b88>] do_page_fault+0x4fe/0x874
 [<ffffffff8012c580>] inode_doinit_with_dentry+0x86/0x47c
 [<ffffffff800cd378>] zone_statistics+0x3e/0x6d
 [<ffffffff8000f2ff>] __alloc_pages+0x78/0x308
 [<ffffffff8004c9fd>] sys_mount+0x8a/0xcd
 [<ffffffff8005e116>] system_call+0x7e/0x83

Failed to recover EFIs on filesystem: cciss/c0d0
XFS: log mount finish failed

Can someone shed some light on what is happening here?

Also what the next steps I need to take to repair the fs? (assuming my xfs
fs is corrupted)
Will running xfs_repair be good enough in this case?

Thanks in advance
-- 
View this message in context: http://old.nabble.com/fs-corruption-tp31377534p31377534.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
