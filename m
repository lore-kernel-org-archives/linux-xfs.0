Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 01:13:47 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1O9DeRa003188
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 01:13:44 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9C67EA4267
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 01:14:06 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id 3TiVCMvI03xeWuKH for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 01:14:06 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by flyingAngel.upjs.sk (Postfix) with ESMTP id B75362235B4
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 10:14:07 +0100 (CET)
Date: Sun, 24 Feb 2008 10:14:07 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: xfs_force_shutdown called when no space
Message-ID: <Pine.LNX.4.63.0802240957400.16317@alienAngel.home.sk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello.

Yesterday I recoded some video files but I guess wrong space for
the output files. When I today morning checked results I found that xfs FS
is unavailable. Mencoder process ended without error but at the same time,
when mencoder process ended, xfs_force_shutdown was called. The output video
files is damaged on the end of file. I mount FS to leave kernel replay
metadata. After this, xfs_check didn't find any errors.

Architecture: x86
Kernel: SGI-XFS CVS-2008-02-15_08:00_UTC with ACLs, no debug enabled
        SGI XFS Quota Management subsystem

# xfs_repair -V
xfs_repair version 2.9.6

# xfs_info /mnt/mnt
meta-data=/dev/hda9              isize=256    agcount=16, agsize=613430 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=9814880, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=4792, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

# df /mnt/mnt
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hda9             39240352  39217456     22896 100% /mnt/mnt

Feb 24 05:09:03 host kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 2058 of file fs/xfs/xfs_bmap_btree.c.  Caller 0xc01cb1e9
Feb 24 05:09:03 host kernel: Pid: 186, comm: pdflush Not tainted 2.6.24-rc6 #1
Feb 24 05:09:03 host kernel:  [<c01d48b0>] xfs_bmbt_insert+0x120/0x130
Feb 24 05:09:03 host kernel:  [<c01cb1e9>] xfs_bmap_add_extent_delay_real+0x7a9/0x1590
Feb 24 05:09:03 host kernel:  [<c01cb1e9>] xfs_bmap_add_extent_delay_real+0x7a9/0x1590
Feb 24 05:09:03 host kernel:  [<c01d645f>] xfs_btree_del_cursor+0x2f/0x70
Feb 24 05:09:03 host kernel:  [<c0206a3a>] xfs_trans_log_buf+0x5a/0x90
Feb 24 05:09:03 host kernel:  [<c01b9777>] xfs_alloc_log_agf+0x47/0x60
Feb 24 05:09:03 host kernel:  [<c01baf53>] xfs_alloc_ag_vextent+0x73/0x100
Feb 24 05:09:03 host kernel:  [<c01bbfed>] xfs_alloc_vextent+0x22d/0x4a0
Feb 24 05:09:03 host kernel:  [<c01ce291>] xfs_bmap_add_extent+0x571/0x590
Feb 24 05:09:03 host kernel:  [<c01d0068>] xfs_bmapi+0x7b8/0x13c0
Feb 24 05:09:03 host kernel:  [<c01c6c61>] xfs_bmap_search_multi_extents+0x91/0x100
Feb 24 05:09:03 host kernel:  [<c01ed72b>] xfs_iext_get_ext+0x4b/0x80
Feb 24 05:09:03 host kernel:  [<c01f4215>] xfs_iomap_write_allocate+0x2b5/0x440
Feb 24 05:09:04 host kernel:  [<c0233801>] elv_insert+0x101/0x160
Feb 24 05:09:04 host kernel:  [<c01f4cc8>] xfs_iomap+0x388/0x3d0
Feb 24 05:09:04 host kernel:  [<c0210c8a>] xfs_map_blocks+0x3a/0x70
Feb 24 05:09:04 host kernel:  [<c02123a8>] xfs_page_state_convert+0x3b8/0x720
Feb 24 05:09:04 host kernel:  [<c02a5f11>] ide_do_request+0x5e1/0xaf0
Feb 24 05:09:04 host kernel:  [<c0212851>] xfs_vm_writepage+0x61/0x100
Feb 24 05:09:04 host kernel:  [<c014a948>] __writepage+0x8/0x30
Feb 24 05:09:04 host kernel:  [<c014b8d0>] write_cache_pages+0x260/0x340
Feb 24 05:09:04 host kernel:  [<c014a940>] __writepage+0x0/0x30
Feb 24 05:09:04 host kernel:  [<c014b9d0>] generic_writepages+0x20/0x30
Feb 24 05:09:04 host kernel:  [<c014ba0b>] do_writepages+0x2b/0x50
Feb 24 05:09:04 host kernel:  [<c017e910>] __writeback_single_inode+0x80/0x310
Feb 24 05:09:04 host kernel:  [<c0218877>] xfs_bdstrat_cb+0x47/0x50
Feb 24 05:09:04 host kernel:  [<c0206466>] xfs_trans_first_ail+0x16/0x30
Feb 24 05:09:04 host kernel:  [<c01f73d9>] xfs_log_need_covered+0x49/0x80
Feb 24 05:09:04 host kernel:  [<c017f0cf>] sync_sb_inodes+0x1af/0x240
Feb 24 05:09:04 host kernel:  [<c017f313>] writeback_inodes+0x53/0x80
Feb 24 05:09:04 host kernel:  [<c014aa25>] wb_kupdate+0x85/0xf0
Feb 24 05:09:04 host kernel:  [<c014bae0>] pdflush+0x0/0x170
Feb 24 05:09:04 host kernel:  [<c014bbaf>] pdflush+0xcf/0x170
Feb 24 05:09:04 host kernel:  [<c014a9a0>] wb_kupdate+0x0/0xf0
Feb 24 05:09:04 host kernel:  [<c012d1e4>] kthread+0x74/0x80
Feb 24 05:09:04 host kernel:  [<c012d170>] kthread+0x0/0x80
Feb 24 05:09:04 host kernel:  [<c0104aa7>] kernel_thread_helper+0x7/0x10
Feb 24 05:09:04 host kernel:  =======================
Feb 24 05:09:04 host kernel: Filesystem "hda9": XFS internal error xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller 0xc01f42d6
Feb 24 05:09:04 host kernel: Pid: 186, comm: pdflush Not tainted 2.6.24-rc6 #1
Feb 24 05:09:04 host kernel:  [<c0205dae>] xfs_trans_cancel+0xfe/0x120
Feb 24 05:09:04 host kernel:  [<c01f42d6>] xfs_iomap_write_allocate+0x376/0x440
Feb 24 05:09:04 host kernel:  [<c01f42d6>] xfs_iomap_write_allocate+0x376/0x440
Feb 24 05:09:04 host kernel:  [<c0233801>] elv_insert+0x101/0x160
Feb 24 05:09:04 host kernel:  [<c01f4cc8>] xfs_iomap+0x388/0x3d0
Feb 24 05:09:04 host kernel:  [<c0210c8a>] xfs_map_blocks+0x3a/0x70
Feb 24 05:09:04 host kernel:  [<c02123a8>] xfs_page_state_convert+0x3b8/0x720
Feb 24 05:09:04 host kernel:  [<c02a5f11>] ide_do_request+0x5e1/0xaf0
Feb 24 05:09:04 host kernel:  [<c0212851>] xfs_vm_writepage+0x61/0x100
Feb 24 05:09:04 host kernel:  [<c014a948>] __writepage+0x8/0x30
Feb 24 05:09:04 host kernel:  [<c014b8d0>] write_cache_pages+0x260/0x340
Feb 24 05:09:04 host kernel:  [<c014a940>] __writepage+0x0/0x30
Feb 24 05:09:04 host kernel:  [<c014b9d0>] generic_writepages+0x20/0x30
Feb 24 05:09:04 host kernel:  [<c014ba0b>] do_writepages+0x2b/0x50
Feb 24 05:09:05 host kernel:  [<c017e910>] __writeback_single_inode+0x80/0x310
Feb 24 05:09:05 host kernel:  [<c0218877>] xfs_bdstrat_cb+0x47/0x50
Feb 24 05:09:05 host kernel:  [<c0206466>] xfs_trans_first_ail+0x16/0x30
Feb 24 05:09:05 host kernel:  [<c01f73d9>] xfs_log_need_covered+0x49/0x80
Feb 24 05:09:05 host kernel:  [<c017f0cf>] sync_sb_inodes+0x1af/0x240
Feb 24 05:09:05 host kernel:  [<c017f313>] writeback_inodes+0x53/0x80
Feb 24 05:09:05 host kernel:  [<c014aa25>] wb_kupdate+0x85/0xf0
Feb 24 05:09:05 host kernel:  [<c014bae0>] pdflush+0x0/0x170
Feb 24 05:09:05 host kernel:  [<c014bbaf>] pdflush+0xcf/0x170
Feb 24 05:09:05 host kernel:  [<c014a9a0>] wb_kupdate+0x0/0xf0
Feb 24 05:09:05 host kernel:  [<c012d1e4>] kthread+0x74/0x80
Feb 24 05:09:05 host kernel:  [<c012d170>] kthread+0x0/0x80
Feb 24 05:09:05 host kernel:  [<c0104aa7>] kernel_thread_helper+0x7/0x10
Feb 24 05:09:05 host kernel:  =======================
Feb 24 05:09:05 host kernel: xfs_force_shutdown(hda9,0x8) called from line 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xc0205dc6
Feb 24 05:09:05 host kernel: Filesystem "hda9": Corruption of in-memory data detected.  Shutting down filesystem: hda9
Feb 24 05:09:05 host kernel: Please umount the filesystem, and rectify the problem(s)
 
Feb 24 09:49:42 host kernel: xfs_force_shutdown(hda9,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xc0210106
Feb 24 09:50:03 host kernel: XFS mounting filesystem hda9
Feb 24 09:50:03 host kernel: Starting XFS recovery on filesystem: hda9 (logdev: internal)
Feb 24 09:50:04 host kernel: Ending XFS recovery on filesystem: hda9 (logdev: internal)
Feb 24 09:51:15 host kernel: XFS mounting filesystem hda9
Feb 24 09:51:16 host kernel: Ending clean XFS mount for filesystem: hda9


Cheers,

jan

-- 
