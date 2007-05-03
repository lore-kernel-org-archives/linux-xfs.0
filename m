Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 May 2007 08:02:00 -0700 (PDT)
Received: from smtp-ft6.fr.colt.net (smtp-ft6.fr.colt.net [213.41.78.198])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l43F1ufB005799
	for <xfs@oss.sgi.com>; Thu, 3 May 2007 08:01:57 -0700
Received: from harpe.intellique.com (host.93.124.68.195.rev.coltfrance.com [195.68.124.93])
	by smtp-ft6.fr.colt.net (8.13.8/8.13.8/Debian-3) with ESMTP id l43EjJQV005258
	for <xfs@oss.sgi.com>; Thu, 3 May 2007 16:45:19 +0200
Date: Thu, 3 May 2007 16:45:21 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: XFS crash on linux raid
Message-ID: <20070503164521.16efe075@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hello, 
Apparently quite a lot of people do encounter the same problem from
time to time, but I couldn't find any solution. 

When writing quite a lot to the filesystem (heavy load on the
fileserver), the filesystem crashes when filled at 2.5~3TB (varies from
time to time). The filesystems tested where always running on a software
raid 0, with disabled barriers. I tend to think that disabled write
barriers are causing the crash but I'll do some more tests to get sure.

I've met this problem for the first time on 12/23 (yup... merry
christmas :) when a 13 TB filesystem went belly up :

Dec 23 01:38:10 storiq1 -- MARK --
Dec 23 01:58:10 storiq1 -- MARK --
Dec 23 02:10:29 storiq1 kernel: xfs_iunlink_remove: xfs_itobp()
returned an error 990 on md0. Returning error.
Dec 23 02:10:29 storiq1 kernel: xfs_inactive:^Ixfs_ifree() returned an
error = 990 on md0
Dec 23 02:10:29 storiq1 kernel: xfs_force_shutdown(md0,0x1) called from
line 1763 of file fs/xfs/xfs_vnodeops.c. Return address = 0xc027f78b
Dec 23 02:38:11 storiq1 -- MARK --
Dec 23 02:58:11 storiq1 -- MARK -- 


When mounting, it did that :

Filesystem "md0": Disabling barriers, not supported by the underlying
device XFS mounting filesystem md0
Starting XFS recovery on filesystem: md0 (logdev: internal)
Filesystem "md0": xfs_inode_recover: Bad inode magic number, dino ptr =
0xf7196600, dino bp = 0xf718e980, ino = 119318 Filesystem "md0": XFS
internal error xlog_recover_do_inode_trans(1) at line 2352 of file
fs/xfs/xfs_log_recover.c. Caller 0xc025d180 <c025cb9d>
xlog_recover_do_inode_trans+0x93d/0xa00 <c025d180>
xlog_recover_do_trans+0x140/0x160 <c0277afb>
xfs_buf_delwri_queue+0x2b/0xb0 <c025d180>
xlog_recover_do_trans+0x140/0x160 <c027385f> kmem_zalloc+0x1f/0x50
<c025d27f> xlog_recover_commit_trans+0x3f/0x50 <c025d39a>
xlog_recover_process_data+0xea/0x240 <c025e48a>
xlog_do_recovery_pass+0x39a/0xb70 <c013d189>
hrtimer_run_queues+0x29/0x110 <c025ecf6>
xlog_do_log_recovery+0x96/0xd0 <c025ed6b> xlog_do_recover+0x3b/0x170
<c025ef7d> xlog_recover+0xdd/0xf0 <c0255da1> xfs_log_mount+0xa1/0x110
<c02607e5> xfs_mountfs+0x825/0xf30 <c02420c7> xfs_fs_cmn_err+0x27/0x30
<c0251137> xfs_ioinit+0x27/0x50 <c02693ef> xfs_mount+0x2ff/0x520
<c027f3f3> vfs_mount+0x43/0x50 <c027f20a> xfs_fs_fill_super+0x9a/0x200
<c013e42d> debug_mutex_add_waiter+0x3d/0xd0 <c029eb07>
snprintf+0x27/0x30 <c01a9204> disk_name+0xb4/0xc0 <c01727bf>
sb_set_blocksize+0x1f/0x50 <c01721a6> get_sb_bdev+0x106/0x150
<c027f3a0> xfs_fs_get_sb+0x30/0x40 <c027f170>
xfs_fs_fill_super+0x0/0x200 <c01723ff> do_kern_mount+0x5f/0xe0
<c0189e57> do_new_mount+0x77/0xc0 <c018a4ad> do_mount+0x18d/0x1f0
<c014007b> take_cpu_down+0xb/0x20 <c018a2c3>
copy_mount_options+0x63/0xc0 <c018a85f> sys_mount+0x9f/0xe0 <c01031d7>
syscall_call+0x7/0xb XFS: log mount/recovery failed: error 990 XFS: log
mount failed 

XFS_repair (too old a version...) hosed the filesystem and destroyed
most of the 2.6TB of data. Yes, there were no backup, I wrote a recovery
tool to restore the video data from the raw device but the is a
different story.

The system was running vanilla 2.6.17.9, and md0 was made of 3 striped
RAID-5 on 3 3Ware-9550 cards, each hardware RAID-5 made of 8 750 GB
drives.

On a similar hardware with 2 3Ware-9550 16x750GB striped together, but
running 2.6.17.13, I had a similar fs crash last week. Unfortunately I
don't have the logs at hand, but we where able to reproduce several
times the crash at home :

Filesystem "md0": XFS internal error xfs_btree_check_sblock at line 336
of file fs/xfs/xfs_btree.c.  Caller 0xc01fb282 <c0214568>
xfs_btree_check_sblock+0x58/0xe0  <c01fb282>
xfs_alloc_lookup+0x142/0x400 <c01fb282> xfs_alloc_lookup+0x142/0x400
<c0254e59> kmem_zone_alloc+0x59/0xd0 <c02149e3>
xfs_btree_init_cursor+0x23/0x190  <c01f7834>
xfs_alloc_ag_vextent_near+0x54/0x9e0 <c0204893>
xfs_bmap_add_extent+0x383/0x430  <c020a9e6>
xfs_bmap_search_multi_extents+0x76/0xf0 <c01f7619>
xfs_alloc_ag_vextent+0x119/0x120  <c01f9b1b>
xfs_alloc_vextent+0x3db/0x4f0 <c0208e4e> xfs_bmap_btalloc+0x3ee/0x890
<c020cf96> xfs_bmapi+0x1216/0x1690 <c021b2e6>
xfs_dir2_grow_inode+0xf6/0x400  <c015f636>
cache_alloc_refill+0xb6/0x1e0 <c023263b> xfs_idata_realloc+0x3b/0x130
<c021cebc> xfs_dir2_sf_to_block+0xac/0x5d0 <c021ad69>
xfs_dir2_lookup+0x129/0x130  <c0223147> xfs_dir2_sf_addname+0x97/0x110
<c021ac34> xfs_dir2_createname+0x144/0x150  <c0249f9b>
xfs_trans_ijoin+0x2b/0x80 <c0245b74> xfs_rename+0x354/0x9f0  <c024ec6f>
xfs_access+0x3f/0x50 <c025c278> xfs_vn_rename+0x48/0xa0  <c017146c>
__link_path_walk+0xc7c/0xc90 <c024dbcf> xfs_getattr+0x23f/0x2f0
<c017e72b> mntput_no_expire+0x1b/0x80 <c015f636>
cache_alloc_refill+0xb6/0x1e0  <c0173946> vfs_rename_other+0x96/0xd0
<c0173bd8> vfs_rename+0x258/0x2d0  <c0173dc1> do_rename+0x171/0x1a0
<c015f52b> cache_grow+0x10b/0x160  <c015f636>
cache_alloc_refill+0xb6/0x1e0 <c017000b> do_getname+0x4b/0x80
<c0173e37> sys_renameat+0x47/0x80 <c0173e98> sys_rename+0x28/0x30
<c0103037> syscall_call+0x7/0xb Filesystem "md0": XFS internal error
xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c.  Caller
0xc0245ec7 <c0248aa0> xfs_trans_cancel+0xd0/0x100  <c0245ec7>
xfs_rename+0x6a7/0x9f0 <c0245ec7> xfs_rename+0x6a7/0x9f0  <c024ec6f>
xfs_access+0x3f/0x50 <c025c278> xfs_vn_rename+0x48/0xa0  <c017146c>
__link_path_walk+0xc7c/0xc90 <c024dbcf> xfs_getattr+0x23f/0x2f0
<c017e72b> mntput_no_expire+0x1b/0x80 <c015f636>
cache_alloc_refill+0xb6/0x1e0  <c0173946> vfs_rename_other+0x96/0xd0
<c0173bd8> vfs_rename+0x258/0x2d0  <c0173dc1> do_rename+0x171/0x1a0
<c015f52b> cache_grow+0x10b/0x160  <c015f636>
cache_alloc_refill+0xb6/0x1e0 <c017000b> do_getname+0x4b/0x80
<c0173e37> sys_renameat+0x47/0x80 <c0173e98> sys_rename+0x28/0x30
<c0103037> syscall_call+0x7/0xb xfs_force_shutdown(md0,0x8) called from
line 1151 of file fs/xfs/xfs_trans.c.  Return address = 0xc025f7b9
Filesystem "md0": Corruption of in-memory data detected.  Shutting down
filesystem: md0 Please umount the filesystem, and rectify the
problem(s) xfs_force_shutdown(md0,0x1) called from line 338 of file
fs/xfs/xfs_rw.c.  Return address = 0xc025f7b9
xfs_force_shutdown(md0,0x1) called from line 338 of file
fs/xfs/xfs_rw.c.  Return address = 0xc025f7b9

After xfs_repair, the fs is fine. However, it crashes again when
writing again a couple of GBs of data. It crashes again under 2.6.17.13,
2.6.17.13 SMP, 2.6.18.8, 2.6.16.36... 

Out of curiosity, I've tried to use reiserfs (just to see how it
compares regarding this). Reiserfs crashed before even writing 100MB!

So I tend to believe this is a "write barrier" problem and it looks
really nasty!!! 

To sort this out I've started a test on a single 3Ware raid, without
software raid. 

Any idea on how to circumvent the problem to make software RAID/LVM
usable?

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
