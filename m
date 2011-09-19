Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JDuQnR252635 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 08:56:27 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45E3B17248D
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 06:56:23 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id Tg66n1RNCeEKKC21 for
	<xfs@oss.sgi.com>; Mon, 19 Sep 2011 06:56:23 -0700 (PDT)
Date: Mon, 19 Sep 2011 15:56:22 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: System stuck in D state while deleting messages in mutt
Message-ID: <20110919135622.GA13039@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
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

My system just got stuck while I was trying to delete old messages in
mutt. I'm running the latest git kernel. This happened on my SSD:

 # xfs_info /dev/sda
meta-data=/dev/sda               isize=256    agcount=4, agsize=91571162 blks
         =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=366284646, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=178849, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none

I was able to capture the following SysRq-w output:

Sep 19 15:29:59 x4 kernel: SysRq : Show Blocked State
Sep 19 15:29:59 x4 kernel: task                        PC stack   pid father
Sep 19 15:29:59 x4 kernel: gconfd-2        D 0000000000000000     0  1513      1 0x00000000
Sep 19 15:29:59 x4 kernel: ffff8802102f9d88 0000000000000086 ffff880200000000 ffff8802102f9fd8
Sep 19 15:29:59 x4 kernel: 0000000000004000 ffff8802102f9fd8 ffff8802168d5740 ffff8802125015d0
Sep 19 15:29:59 x4 kernel: 00000001102f9d68 ffffffff8111ad40 0000000000000000 0000000000000000
Sep 19 15:29:59 x4 kernel: Call Trace:
Sep 19 15:29:59 x4 kernel: [<ffffffff8111ad40>] ? link_path_walk+0x70/0x850
Sep 19 15:29:59 x4 kernel: [<ffffffff8111aa38>] ? complete_walk+0x88/0x110
Sep 19 15:29:59 x4 kernel: [<ffffffff8106bb0a>] schedule+0x3a/0x50
Sep 19 15:29:59 x4 kernel: [<ffffffff8150288f>] __mutex_lock_slowpath+0xef/0x180
Sep 19 15:29:59 x4 kernel: [<ffffffff8150268d>] mutex_lock+0x1d/0x40
Sep 19 15:29:59 x4 kernel: [<ffffffff8111d0c7>] kern_path_create+0x77/0x120
Sep 19 15:29:59 x4 kernel: [<ffffffff8120ce0c>] ? strncpy_from_user+0x2c/0x40
Sep 19 15:29:59 x4 kernel: [<ffffffff811195e0>] ? getname_flags+0xe0/0x210
Sep 19 15:29:59 x4 kernel: [<ffffffff8112c138>] ? mntput+0x18/0x30
Sep 19 15:29:59 x4 kernel: [<ffffffff8111d1b5>] user_path_create+0x45/0x70
Sep 19 15:29:59 x4 kernel: [<ffffffff8111d5d5>] sys_mkdirat+0x25/0xd0
Sep 19 15:29:59 x4 kernel: [<ffffffff81122411>] ? sys_poll+0x71/0x110
Sep 19 15:29:59 x4 kernel: [<ffffffff8111d693>] sys_mkdir+0x13/0x20
Sep 19 15:29:59 x4 kernel: [<ffffffff8150467b>] system_call_fastpath+0x16/0x1b
Sep 19 15:29:59 x4 kernel: mutt            D 0000000000000001     0  1631   1609 0x00000000
Sep 19 15:29:59 x4 kernel: ffff8802094bfc68 0000000000000082 0000000100000000 ffff8802094bffd8
Sep 19 15:29:59 x4 kernel: 0000000000004000 ffff8802094bffd8 ffff880215425740 ffff8802124015d0
Sep 19 15:29:59 x4 kernel: 000000010000001c 0000000000000292 ffff8802094bfbc8 ffffffff810971cc
Sep 19 15:29:59 x4 kernel: Call Trace:
Sep 19 15:29:59 x4 kernel: [<ffffffff810971cc>] ? up+0x2c/0x50
Sep 19 15:29:59 x4 kernel: [<ffffffff811d708e>] ? xfs_trans_unreserve_and_mod_sb+0x22e/0x370
Sep 19 15:29:59 x4 kernel: [<ffffffff81186188>] ? xfs_buf_rele+0x48/0x150
Sep 19 15:29:59 x4 kernel: [<ffffffff811dffa1>] ? xfs_ail_push+0x1/0x80
Sep 19 15:29:59 x4 kernel: [<ffffffff8106bb0a>] schedule+0x3a/0x50
Sep 19 15:29:59 x4 kernel: [<ffffffff811d975a>] xlog_grant_log_space+0x32a/0x630
Sep 19 15:29:59 x4 kernel: [<ffffffff8106e670>] ? try_to_wake_up+0x280/0x280
Sep 19 15:29:59 x4 kernel: [<ffffffff811dc17a>] xfs_log_reserve+0x14a/0x1b0
Sep 19 15:29:59 x4 kernel: [<ffffffff811d6b06>] xfs_trans_reserve+0x96/0x210
Sep 19 15:29:59 x4 kernel: [<ffffffff811d6989>] ? xfs_trans_alloc+0x99/0xb0
Sep 19 15:29:59 x4 kernel: [<ffffffff8119a17c>] xfs_inactive+0x39c/0x410
Sep 19 15:29:59 x4 kernel: [<ffffffff811272fb>] ? end_writeback+0x2b/0x90
Sep 19 15:29:59 x4 kernel: [<ffffffff81194d07>] xfs_fs_evict_inode+0x97/0x110
Sep 19 15:29:59 x4 kernel: [<ffffffff81127407>] evict+0xa7/0x1a0
Sep 19 15:29:59 x4 kernel: [<ffffffff81128115>] iput+0x105/0x210
Sep 19 15:29:59 x4 kernel: [<ffffffff8111db9e>] do_unlinkat+0x15e/0x1c0
Sep 19 15:29:59 x4 kernel: [<ffffffff8110fcb8>] ? vfs_write+0x118/0x150
Sep 19 15:29:59 x4 kernel: [<ffffffff8110fdc5>] ? sys_write+0x45/0x90
Sep 19 15:29:59 x4 kernel: [<ffffffff8103eaa9>] ? do_device_not_available+0x9/0x10
Sep 19 15:29:59 x4 kernel: [<ffffffff8111dc51>] sys_unlink+0x11/0x20
Sep 19 15:29:59 x4 kernel: [<ffffffff8150467b>] system_call_fastpath+0x16/0x1b
Sep 19 15:29:59 x4 kernel: zsh             D 0000000000000000     0  1638   1609 0x00000000
Sep 19 15:29:59 x4 kernel: ffff8802094bdd88 0000000000000082 ffff8802094bdca8 ffff8802094bdfd8
Sep 19 15:29:59 x4 kernel: 0000000000004000 ffff8802094bdfd8 ffff880214c5d740 ffff88020be08000
Sep 19 15:29:59 x4 kernel: ffff8802094bdd68 ffffffff8111ad40 ffff8802094bdcd8 ffffffff8105cc50
Sep 19 15:29:59 x4 kernel: Call Trace:
Sep 19 15:29:59 x4 kernel: [<ffffffff8111ad40>] ? link_path_walk+0x70/0x850
Sep 19 15:29:59 x4 kernel: [<ffffffff8105cc50>] ? ptep_set_access_flags+0x30/0x40
Sep 19 15:29:59 x4 kernel: [<ffffffff810efec8>] ? do_wp_page+0x328/0x790
Sep 19 15:29:59 x4 kernel: [<ffffffff8111aa38>] ? complete_walk+0x88/0x110
Sep 19 15:29:59 x4 kernel: [<ffffffff8106bb0a>] schedule+0x3a/0x50
Sep 19 15:29:59 x4 kernel: [<ffffffff8150288f>] __mutex_lock_slowpath+0xef/0x180
Sep 19 15:29:59 x4 kernel: [<ffffffff8150268d>] mutex_lock+0x1d/0x40
Sep 19 15:29:59 x4 kernel: [<ffffffff8111d0c7>] kern_path_create+0x77/0x120
Sep 19 15:29:59 x4 kernel: [<ffffffff8120ce0c>] ? strncpy_from_user+0x2c/0x40
Sep 19 15:29:59 x4 kernel: [<ffffffff811195e0>] ? getname_flags+0xe0/0x210
Sep 19 15:29:59 x4 kernel: [<ffffffff8111d1b5>] user_path_create+0x45/0x70
Sep 19 15:29:59 x4 kernel: [<ffffffff8111dd5f>] sys_symlinkat+0x3f/0xd0
Sep 19 15:29:59 x4 kernel: [<ffffffff8111de01>] sys_symlink+0x11/0x20
Sep 19 15:29:59 x4 kernel: [<ffffffff8150467b>] system_call_fastpath+0x16/0x1b
Sep 19 15:29:59 x4 kernel: zsh             D 0000000000000001     0  1640   1609 0x00000000
Sep 19 15:29:59 x4 kernel: ffff880209497c08 0000000000000082 0000000000000000 ffff880209497fd8
Sep 19 15:29:59 x4 kernel: 0000000000004000 ffff880209497fd8 ffff880214f72ba0 ffff8802157715d0
Sep 19 15:29:59 x4 kernel: ffff880214f72be8 ffff88021fc91970 0000000000000001 ffff880214f72ba0
Sep 19 15:29:59 x4 kernel: Call Trace:
Sep 19 15:29:59 x4 kernel: [<ffffffff81069b46>] ? __wake_up+0x46/0x60
Sep 19 15:29:59 x4 kernel: [<ffffffff81272052>] ? put_ldisc+0x42/0x90
Sep 19 15:29:59 x4 kernel: [<ffffffff8106bb0a>] schedule+0x3a/0x50
Sep 19 15:29:59 x4 kernel: [<ffffffff811d99d3>] xlog_grant_log_space+0x5a3/0x630
Sep 19 15:29:59 x4 kernel: [<ffffffff8120da49>] ? random32+0x39/0x60
Sep 19 15:29:59 x4 kernel: [<ffffffff8106e670>] ? try_to_wake_up+0x280/0x280
Sep 19 15:29:59 x4 kernel: [<ffffffff811dc17a>] xfs_log_reserve+0x14a/0x1b0
Sep 19 15:29:59 x4 kernel: [<ffffffff811d6b06>] xfs_trans_reserve+0x96/0x210
Sep 19 15:29:59 x4 kernel: [<ffffffff8119b449>] xfs_symlink+0x209/0x870
Sep 19 15:29:59 x4 kernel: [<ffffffff811253c0>] ? d_lookup+0x30/0x50
Sep 19 15:29:59 x4 kernel: [<ffffffff81119b34>] ? lookup_hash+0x14/0x20
Sep 19 15:29:59 x4 kernel: [<ffffffff8111d0d3>] ? kern_path_create+0x83/0x120
Sep 19 15:29:59 x4 kernel: [<ffffffff81191a74>] xfs_vn_symlink+0x54/0xc0
Sep 19 15:29:59 x4 kernel: [<ffffffff8111dccd>] vfs_symlink+0x6d/0xc0
Sep 19 15:29:59 x4 kernel: [<ffffffff8111dddb>] sys_symlinkat+0xbb/0xd0
Sep 19 15:29:59 x4 kernel: [<ffffffff8111de01>] sys_symlink+0x11/0x20
Sep 19 15:29:59 x4 kernel: [<ffffffff8150467b>] system_call_fastpath+0x16/0x1b
Sep 19 15:29:59 x4 kernel: kworker/3:1     D 0000000000000000     0 30556      2 0x00000000
Sep 19 15:29:59 x4 kernel: ffff88017b65bc80 0000000000000046 ffff880100000000 ffff88017b65bfd8
Sep 19 15:29:59 x4 kernel: 0000000000004000 ffff88017b65bfd8 ffff8802168ec170 ffff880216bac170
Sep 19 15:29:59 x4 kernel: 0000000100000400 0000000000000000 ffff880215447980 ffff880215447968
Sep 19 15:29:59 x4 kernel: Call Trace:
Sep 19 15:29:59 x4 kernel: [<ffffffff8106e67d>] ? default_wake_function+0xd/0x10
Sep 19 15:29:59 x4 kernel: [<ffffffff81120e91>] ? pollwake+0x61/0x70
Sep 19 15:29:59 x4 kernel: [<ffffffff8106e670>] ? try_to_wake_up+0x280/0x280
Sep 19 15:29:59 x4 kernel: [<ffffffff8105e2bf>] ? __wake_up_common+0x4f/0x80
Sep 19 15:29:59 x4 kernel: [<ffffffff8106bb0a>] schedule+0x3a/0x50
Sep 19 15:29:59 x4 kernel: [<ffffffff811d99d3>] xlog_grant_log_space+0x5a3/0x630
Sep 19 15:29:59 x4 kernel: [<ffffffff8120da49>] ? random32+0x39/0x60
Sep 19 15:29:59 x4 kernel: [<ffffffff8106e670>] ? try_to_wake_up+0x280/0x280
Sep 19 15:29:59 x4 kernel: [<ffffffff811dc17a>] xfs_log_reserve+0x14a/0x1b0
Sep 19 15:29:59 x4 kernel: [<ffffffff811d6b06>] xfs_trans_reserve+0x96/0x210
Sep 19 15:29:59 x4 kernel: [<ffffffff8118cb1e>] xfs_fs_log_dummy+0x3e/0x90
Sep 19 15:29:59 x4 kernel: [<ffffffff81196804>] xfs_sync_worker+0x74/0x80
Sep 19 15:29:59 x4 kernel: [<ffffffff8108c446>] process_one_work+0x116/0x440
Sep 19 15:29:59 x4 kernel: [<ffffffff81196790>] ? xfs_sync_inode_attr+0xf0/0xf0
Sep 19 15:29:59 x4 kernel: [<ffffffff8108cd27>] worker_thread+0x167/0x300
Sep 19 15:29:59 x4 kernel: [<ffffffff8108cbc0>] ? manage_workers.isra.25+0x1f0/0x1f0
Sep 19 15:29:59 x4 kernel: [<ffffffff81091597>] kthread+0x87/0x90
Sep 19 15:29:59 x4 kernel: [<ffffffff81505834>] kernel_thread_helper+0x4/0x10
Sep 19 15:29:59 x4 kernel: [<ffffffff81091510>] ? kthread_flush_work_fn+0x10/0x10
Sep 19 15:29:59 x4 kernel: [<ffffffff81505830>] ? gs_change+0xb/0xb
Sep 19 15:29:59 x4 kernel: flush-8:16      D 0000000000000003     0  3450      2 0x00000000
Sep 19 15:29:59 x4 kernel: ffff880173e0b660 0000000000000046 ffff880173e0b580 ffff880173e0bfd8
Sep 19 15:29:59 x4 kernel: 0000000000004000 ffff880173e0bfd8 ffff880216baaba0 ffff880215ac2ba0
Sep 19 15:29:59 x4 kernel: ffff880173e0b590 ffffffff8108d475 ffff880173e0b5b0 ffffffff811f0d2c
Sep 19 15:29:59 x4 kernel: Call Trace:
Sep 19 15:29:59 x4 kernel: [<ffffffff8108d475>] ? queue_delayed_work+0x25/0x30
Sep 19 15:29:59 x4 kernel: [<ffffffff811f0d2c>] ? blk_run_queue_async+0x3c/0x60
Sep 19 15:29:59 x4 kernel: [<ffffffff811f0e4d>] ? queue_unplugged+0xfd/0x110
Sep 19 15:29:59 x4 kernel: [<ffffffff8106bb0a>] schedule+0x3a/0x50
Sep 19 15:29:59 x4 kernel: [<ffffffff811d99d3>] xlog_grant_log_space+0x5a3/0x630
Sep 19 15:29:59 x4 kernel: [<ffffffff8120da49>] ? random32+0x39/0x60
Sep 19 15:29:59 x4 kernel: [<ffffffff8106e670>] ? try_to_wake_up+0x280/0x280
Sep 19 15:29:59 x4 kernel: [<ffffffff811dc17a>] xfs_log_reserve+0x14a/0x1b0
Sep 19 15:29:59 x4 kernel: [<ffffffff811d6b06>] xfs_trans_reserve+0x96/0x210
Sep 19 15:29:59 x4 kernel: [<ffffffff81190cf4>] xfs_iomap_write_allocate+0x204/0x310
Sep 19 15:29:59 x4 kernel: [<ffffffff81183992>] xfs_map_blocks+0x212/0x2a0
Sep 19 15:29:59 x4 kernel: [<ffffffff81184a62>] xfs_vm_writepage+0x192/0x520
Sep 19 15:29:59 x4 kernel: [<ffffffff810d89c2>] __writepage+0x12/0x40
Sep 19 15:29:59 x4 kernel: [<ffffffff810da147>] write_cache_pages+0x1e7/0x4b0
Sep 19 15:29:59 x4 kernel: [<ffffffff810d89b0>] ? free_pages_exact+0x40/0x40
Sep 19 15:29:59 x4 kernel: [<ffffffff810da44b>] generic_writepages+0x3b/0x60
Sep 19 15:29:59 x4 kernel: [<ffffffff81183749>] xfs_vm_writepages+0x49/0x60
Sep 19 15:29:59 x4 kernel: [<ffffffff810da48c>] do_writepages+0x1c/0x30
Sep 19 15:29:59 x4 kernel: [<ffffffff81133e33>] writeback_single_inode+0x113/0x3b0
Sep 19 15:29:59 x4 kernel: [<ffffffff811342b8>] writeback_sb_inodes+0x1e8/0x2a0
Sep 19 15:29:59 x4 kernel: [<ffffffff81134407>] __writeback_inodes_wb+0x97/0xd0
Sep 19 15:29:59 x4 kernel: [<ffffffff8113542b>] wb_writeback+0x32b/0x360
Sep 19 15:29:59 x4 kernel: [<ffffffff811358ff>] wb_do_writeback+0x28f/0x2a0
Sep 19 15:29:59 x4 kernel: [<ffffffff81135993>] bdi_writeback_thread+0x83/0x2b0
Sep 19 15:29:59 x4 kernel: [<ffffffff81135910>] ? wb_do_writeback+0x2a0/0x2a0
Sep 19 15:29:59 x4 kernel: [<ffffffff81091597>] kthread+0x87/0x90
Sep 19 15:29:59 x4 kernel: [<ffffffff81505834>] kernel_thread_helper+0x4/0x10
Sep 19 15:29:59 x4 kernel: [<ffffffff81091510>] ? kthread_flush_work_fn+0x10/0x10
Sep 19 15:29:59 x4 kernel: [<ffffffff81505830>] ? gs_change+0xb/0xb
Sep 19 15:29:59 x4 kernel: rm              D 0000000000000000     0 17349   1460 0x00000004
Sep 19 15:29:59 x4 kernel: ffff880210031de8 0000000000000086 0000000200000000 ffff880210031fd8
Sep 19 15:29:59 x4 kernel: 0000000000004000 ffff880210031fd8 ffff8802168d5740 ffff880216bf0000
Sep 19 15:29:59 x4 kernel: 0000000116bf0000 ffff880216bf0000 000000000040a000 ffff8802139b8cc8
Sep 19 15:29:59 x4 kernel: Call Trace:
Sep 19 15:29:59 x4 kernel: [<ffffffff8111aa38>] ? complete_walk+0x88/0x110
Sep 19 15:29:59 x4 kernel: [<ffffffff8111b588>] ? path_lookupat+0x68/0x730
Sep 19 15:29:59 x4 kernel: [<ffffffff81107c5b>] ? kmem_cache_free+0x1b/0x110
Sep 19 15:29:59 x4 kernel: [<ffffffff8106bb0a>] schedule+0x3a/0x50
Sep 19 15:29:59 x4 kernel: [<ffffffff8150288f>] __mutex_lock_slowpath+0xef/0x180
Sep 19 15:29:59 x4 kernel: [<ffffffff8150268d>] mutex_lock+0x1d/0x40
Sep 19 15:29:59 x4 kernel: [<ffffffff8111dad6>] do_unlinkat+0x96/0x1c0
Sep 19 15:29:59 x4 kernel: [<ffffffff81113fa5>] ? sys_newfstatat+0x25/0x30
Sep 19 15:29:59 x4 kernel: [<ffffffff8111dc1d>] sys_unlinkat+0x1d/0x40
Sep 19 15:29:59 x4 kernel: [<ffffffff8150467b>] system_call_fastpath+0x16/0x1b
Sep 19 15:29:59 x4 kernel: xauth           D 0000000000000000     0 17360  17353 0x00000000
Sep 19 15:29:59 x4 kernel: ffff8802103d3bd8 0000000000000082 ffff880200000000 ffff8802103d3fd8
Sep 19 15:29:59 x4 kernel: 0000000000004000 ffff8802103d3fd8 ffff8802168d5740 ffff880216bf15d0
Sep 19 15:29:59 x4 kernel: 00000001103d3b48 00000001ffffffff 0000000000000000 0000003fffffffc0
Sep 19 15:29:59 x4 kernel: Call Trace:
Sep 19 15:29:59 x4 kernel: [<ffffffff810d51da>] ? zone_watermark_ok+0x1a/0x20
Sep 19 15:29:59 x4 kernel: [<ffffffff810d6f00>] ? get_page_from_freelist+0x2c0/0x570
Sep 19 15:29:59 x4 kernel: [<ffffffff8106bb0a>] schedule+0x3a/0x50
Sep 19 15:29:59 x4 kernel: [<ffffffff8150288f>] __mutex_lock_slowpath+0xef/0x180
Sep 19 15:29:59 x4 kernel: [<ffffffff8150268d>] mutex_lock+0x1d/0x40
Sep 19 15:29:59 x4 kernel: [<ffffffff8111a85f>] do_lookup+0x25f/0x370
Sep 19 15:29:59 x4 kernel: [<ffffffff810eee80>] ? __do_fault+0x1e0/0x4e0
Sep 19 15:29:59 x4 kernel: [<ffffffff8111b627>] path_lookupat+0x107/0x730
Sep 19 15:29:59 x4 kernel: [<ffffffff8111952f>] ? getname_flags+0x2f/0x210
Sep 19 15:29:59 x4 kernel: [<ffffffff8111bc7b>] do_path_lookup+0x2b/0x70
Sep 19 15:29:59 x4 kernel: [<ffffffff8111c114>] user_path_at+0x54/0xa0
Sep 19 15:29:59 x4 kernel: [<ffffffff810592f4>] ? do_page_fault+0x184/0x440
Sep 19 15:29:59 x4 kernel: [<ffffffff8112b71b>] ? mntput_no_expire+0x2b/0xe0
Sep 19 15:29:59 x4 kernel: [<ffffffff81113e22>] vfs_fstatat+0x42/0x70
Sep 19 15:29:59 x4 kernel: [<ffffffff810870a4>] ? do_sigaction+0x124/0x1e0
Sep 19 15:29:59 x4 kernel: [<ffffffff81113e66>] vfs_stat+0x16/0x20
Sep 19 15:29:59 x4 kernel: [<ffffffff81113f35>] sys_newstat+0x15/0x30
Sep 19 15:29:59 x4 kernel: [<ffffffff81087465>] ? sys_rt_sigaction+0xa5/0xc0
Sep 19 15:29:59 x4 kernel: [<ffffffff8150426f>] ? page_fault+0x1f/0x30
Sep 19 15:29:59 x4 kernel: [<ffffffff8150467b>] system_call_fastpath+0x16/0x1b

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
