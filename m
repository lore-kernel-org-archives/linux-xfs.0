Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2285D7F78
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 19:26:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C1AB5304059
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 17:26:01 -0700 (PDT)
Received: from nm14-vm8.access.bullet.mail.gq1.yahoo.com
	(nm14-vm8.access.bullet.mail.gq1.yahoo.com [216.39.63.222]) by
	cuda.sgi.com with ESMTP id Ox124GkUZ59mmrIr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Aug 2014 17:25:59 -0700 (PDT)
Message-ID: <53E02495.4080208@sbcglobal.net>
Date: Mon, 04 Aug 2014 19:25:57 -0500
From: Bill <billstuff2001@sbcglobal.net>
MIME-Version: 1.0
Subject: xfs hang in 3.14.15
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I've been running a stress test on 3.14.15 and eventually my xfs 
filesystem hangs. Both 3.10.50 and 3.16 seem to work ok.

The test is a continual loop building a kernel. Once it hangs, the 
machine needs to be hard reset.

xfs_info shows this:

meta-data=/dev/md3               isize=256    agcount=16, agsize=1627664 
blks
          =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=26042624, imaxpct=25
          =                       sunit=16     swidth=80 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=12716, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

It's on a raid5, although I've gotten the hang on a regular single disk 
fs as well.

md3 : active raid5 sda1[0] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
       104171200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
       bitmap: 0/5 pages [0KB], 2048KB chunk

Here's the mount options:
/dev/md3 on /mnt/md3 type xfs (rw,noatime,swalloc)

Things usually run well for a while before hanging - in this instance it 
ran nearly 24 hours before it hung.

A whole bunch of message info is below. Any idea what's happening here?

Thanks
Bill


/var/log/messages shows this shortly after the hang:

Aug  4 17:34:34 xplane kernel: kworker/u16:0   D 00000286     0 
26574      2 0x00000000
Aug  4 17:34:34 xplane kernel: Workqueue: writeback bdi_writeback_workfn 
(flush-9:3)
Aug  4 17:34:34 xplane kernel: kworker/0:1     D ea649638     0 
17883      2 0x00000000
Aug  4 17:34:34 xplane kernel: Workqueue: xfs-log/md3 xfs_log_worker [xfs]
Aug  4 17:34:34 xplane kernel: sh              D 00000000     0 3237   
3234 0x00000000
Aug  4 17:34:34 xplane kernel: mv              D c1506cc8     0 17651  
13354 0x00000000
Aug  4 17:34:34 xplane kernel: recordmcount    D 00000000     0 17655  
17580 0x00000000
Aug  4 17:34:34 xplane kernel: sh              D 00001000     0 17677  
17675 0x00000000
Aug  4 17:36:34 xplane kernel: kworker/u16:0   D 00000286     0 
26574      2 0x00000000
Aug  4 17:36:34 xplane kernel: Workqueue: writeback bdi_writeback_workfn 
(flush-9:3)
Aug  4 17:36:34 xplane kernel: kworker/0:1     D ea649638     0 
17883      2 0x00000000
Aug  4 17:36:34 xplane kernel: Workqueue: xfs-log/md3 xfs_log_worker [xfs]
Aug  4 17:36:34 xplane kernel: sh              D 00000000     0 3237   
3234 0x00000000
Aug  4 17:36:34 xplane kernel: mv              D c1506cc8     0 17651  
13354 0x00000000

and dmesg is here:

INFO: task kworker/u16:0:26574 blocked for more than 120 seconds.
       Tainted: P           O 3.14.15fe-dirty #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u16:0   D 00000286     0 26574      2 0x00000000
Workqueue: writeback bdi_writeback_workfn (flush-9:3)
  ce385b84 00000046 df51bb30 00000286 f3e8a097 df51ba78 df51bb30 c1787600
  c1787600 c16a5e40 d03a3160 00000065 ce385b64 f3e8b14f 00000004 f3ec8986
  e65bccf8 ce385b80 c10f457e dcc9e740 e925e800 e92b2e00 000000fa e8593c00
Call Trace:
  [<f3e8a097>] ? xfs_trans_free+0x57/0x60 [xfs]
  [<f3e8b14f>] ? xfs_trans_commit+0x12f/0x230 [xfs]
  [<f3ec8986>] ? xlog_space_left+0x26/0xa0 [xfs]
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<f3ec8aa1>] ? xlog_grant_push_ail+0xa1/0xc0 [xfs]
  [<c1504b03>] schedule+0x23/0x60
  [<f3ec8c35>] xlog_grant_head_wait+0x75/0x130 [xfs]
  [<f3ec8d62>] xlog_grant_head_check+0x72/0xc0 [xfs]
  [<f3ecc0cf>] xfs_log_reserve+0xbf/0x160 [xfs]
  [<f3e8a444>] xfs_trans_reserve+0x214/0x220 [xfs]
  [<f3e6ce18>] xfs_setfilesize_trans_alloc.isra.7+0x38/0x90 [xfs]
  [<f3e6da05>] xfs_vm_writepage+0x465/0x580 [xfs]
  [<c10cb6d0>] __writepage+0x10/0x40
  [<c10cb6c0>] ? mapping_tagged+0x20/0x20
  [<c10cbbd0>] write_cache_pages+0x170/0x3d0
  [<c10cb6c0>] ? mapping_tagged+0x20/0x20
  [<c12814f6>] ? blk_flush_plug_list+0x86/0x1b0
  [<c10cbe63>] generic_writepages+0x33/0x60
  [<f3e6c8a3>] xfs_vm_writepages+0x33/0x40 [xfs]
  [<c10cd31a>] do_writepages+0x1a/0x40
  [<c111b6b2>] __writeback_single_inode+0x42/0x1f0
  [<c106f2ec>] ? wake_up_bit+0x1c/0x20
  [<c111c413>] writeback_sb_inodes+0x193/0x2e0
  [<c111c5dc>] __writeback_inodes_wb+0x7c/0xb0
  [<c111c7e2>] wb_writeback+0x1d2/0x270
  [<c111ccbc>] bdi_writeback_workfn+0x20c/0x380
  [<c1050b08>] process_one_work+0x108/0x340
  [<c1046045>] ? mod_timer+0xd5/0x180
  [<c1051621>] worker_thread+0x101/0x330
  [<c1051520>] ? manage_workers.isra.28+0x250/0x250
  [<c10566a1>] kthread+0xa1/0xc0
  [<c150e1b7>] ret_from_kernel_thread+0x1b/0x28
  [<c1056600>] ? kthread_create_on_node+0x110/0x110
INFO: task kworker/0:1:17883 blocked for more than 120 seconds.
       Tainted: P           O 3.14.15fe-dirty #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:1     D ea649638     0 17883      2 0x00000000
Workqueue: xfs-log/md3 xfs_log_worker [xfs]
  e385be50 00000046 00000001 ea649638 ced77c5f 00004ed9 ea649638 c1787600
  c1787600 e741b1a0 e0f872a0 e385be84 c106aaec 00000000 00000000 f3ec8986
  e2c8bda8 e385be4c c10f457e 00000000 00000000 0000b40e 000000fa e8593c00
Call Trace:
  [<c106aaec>] ? load_balance+0x16c/0x5b0
  [<f3ec8986>] ? xlog_space_left+0x26/0xa0 [xfs]
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<f3ec8aa1>] ? xlog_grant_push_ail+0xa1/0xc0 [xfs]
  [<c1504b03>] schedule+0x23/0x60
  [<f3ec8c35>] xlog_grant_head_wait+0x75/0x130 [xfs]
  [<f3ec8d62>] xlog_grant_head_check+0x72/0xc0 [xfs]
  [<f3ecc0cf>] xfs_log_reserve+0xbf/0x160 [xfs]
  [<f3e8a444>] xfs_trans_reserve+0x214/0x220 [xfs]
  [<f3e7abd4>] xfs_fs_log_dummy+0x34/0x80 [xfs]
  [<f3ecba1f>] xfs_log_worker+0x3f/0x50 [xfs]
  [<c1050b08>] process_one_work+0x108/0x340
  [<c104fdc3>] ? destroy_worker+0x83/0xc0
  [<c1051475>] ? manage_workers.isra.28+0x1a5/0x250
  [<c1051621>] worker_thread+0x101/0x330
  [<c1051520>] ? manage_workers.isra.28+0x250/0x250
  [<c10566a1>] kthread+0xa1/0xc0
  [<c150e1b7>] ret_from_kernel_thread+0x1b/0x28
  [<c1056600>] ? kthread_create_on_node+0x110/0x110
INFO: task sh:3237 blocked for more than 120 seconds.
       Tainted: P           O 3.14.15fe-dirty #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sh              D 00000000     0  3237   3234 0x00000000
  c094dd48 00000082 00000000 00000000 c094dd04 f3ec8b16 e8593e04 c1787600
  c1787600 ea18f630 e741ad50 e8593c00 e8593e00 e8593c74 c094dd24 f3ec8986
  c697c058 c094dd44 c10f457e c094dd2c c10379be ea81d180 000000fa e8593c00
Call Trace:
  [<f3ec8b16>] ? xlog_grant_head_wake+0x56/0xc0 [xfs]
  [<f3ec8986>] ? xlog_space_left+0x26/0xa0 [xfs]
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<c10379be>] ? kmap_atomic_prot+0x3e/0xd0
  [<f3ec8aa1>] ? xlog_grant_push_ail+0xa1/0xc0 [xfs]
  [<c1504b03>] schedule+0x23/0x60
  [<f3ec8c35>] xlog_grant_head_wait+0x75/0x130 [xfs]
  [<f3ec8d62>] xlog_grant_head_check+0x72/0xc0 [xfs]
  [<f3ecc0cf>] xfs_log_reserve+0xbf/0x160 [xfs]
  [<f3e8a444>] xfs_trans_reserve+0x214/0x220 [xfs]
  [<f3e811b8>] xfs_vn_update_time+0x58/0x150 [xfs]
  [<f3e81160>] ? xfs_vn_getattr+0x200/0x200 [xfs]
  [<c110df5e>] update_time+0x1e/0xa0
  [<c110e15b>] file_update_time+0x6b/0xa0
  [<f3e7868d>] xfs_file_aio_write_checks+0x8d/0x140 [xfs]
  [<f3e787a8>] xfs_file_buffered_aio_write+0x68/0x180 [xfs]
  [<c10e1ff5>] ? do_wp_page+0x2e5/0x740
  [<f3e78989>] xfs_file_aio_write+0xc9/0x180 [xfs]
  [<c10f8187>] do_sync_write+0x57/0x90
  [<c10f8130>] ? do_sync_read+0x90/0x90
  [<c10f88e0>] vfs_write+0x90/0x180
  [<c10f8f2c>] SyS_write+0x4c/0xb0
  [<c1507148>] syscall_call+0x7/0x7
INFO: task mv:17651 blocked for more than 120 seconds.
       Tainted: P           O 3.14.15fe-dirty #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mv              D c1506cc8     0 17651  13354 0x00000000
  cfbabd0c 00000086 cfbabca0 c1506cc8 00000001 c16e4c74 00000003 c1787600
  c1787600 ea15ed50 cace76b0 c106f28f 00000000 00000000 00000001 f3ec8986
  c697c108 cfbabd08 c10f457e c14de398 00000000 ce29bd80 000000fa e8593c00
Call Trace:
  [<c1506cc8>] ? _raw_spin_unlock_bh+0x18/0x20
  [<c106f28f>] ? __wake_up+0x3f/0x50
  [<f3ec8986>] ? xlog_space_left+0x26/0xa0 [xfs]
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<c14de398>] ? rpc_release_client+0x78/0x80
  [<f3ec8aa1>] ? xlog_grant_push_ail+0xa1/0xc0 [xfs]
  [<c1504b03>] schedule+0x23/0x60
  [<f3ec8c35>] xlog_grant_head_wait+0x75/0x130 [xfs]
  [<f3ec8d62>] xlog_grant_head_check+0x72/0xc0 [xfs]
  [<f3ecc0cf>] xfs_log_reserve+0xbf/0x160 [xfs]
  [<f3e8a444>] xfs_trans_reserve+0x214/0x220 [xfs]
  [<f3ebc6bb>] xfs_rename+0xeb/0x5a0 [xfs]
  [<c1101c46>] ? inode_permission+0x16/0x50
  [<c11081a4>] ? filldir64+0x44/0x110
  [<f3e813ab>] xfs_vn_rename+0x8b/0xa0 [xfs]
  [<c11058ce>] vfs_rename+0x4fe/0x510
  [<c1100f44>] ? lookup_dcache+0x24/0xa0
  [<c11064ce>] SyS_renameat+0x21e/0x340
  [<c150a25f>] ? __do_page_fault+0x28f/0x4d0
  [<c110661d>] SyS_rename+0x2d/0x30
  [<c1507148>] syscall_call+0x7/0x7
INFO: task recordmcount:17655 blocked for more than 120 seconds.
       Tainted: P           O 3.14.15fe-dirty #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
recordmcount    D 00000000     0 17655  17580 0x00000000
  dbf57d48 00000086 00000000 00000000 c14e099e c5690160 e8593e04 c1787600
  c1787600 e9989670 d01551e0 e8593c00 e8593e00 e8593c74 dbf57d24 f3ec8986
  cf59aa38 dbf57d44 c10f457e cf72c73c 00000000 dbf57d2c 000000fa e8593c00
Call Trace:
  [<c14e099e>] ? xprt_release+0x11e/0x250
  [<f3ec8986>] ? xlog_space_left+0x26/0xa0 [xfs]
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<f3ec8aa1>] ? xlog_grant_push_ail+0xa1/0xc0 [xfs]
  [<c1504b03>] schedule+0x23/0x60
  [<f3ec8c35>] xlog_grant_head_wait+0x75/0x130 [xfs]
  [<f3ec8d62>] xlog_grant_head_check+0x72/0xc0 [xfs]
  [<f3ecc0cf>] xfs_log_reserve+0xbf/0x160 [xfs]
  [<f3e8a444>] xfs_trans_reserve+0x214/0x220 [xfs]
  [<f3e811b8>] xfs_vn_update_time+0x58/0x150 [xfs]
  [<f3e81160>] ? xfs_vn_getattr+0x200/0x200 [xfs]
  [<c110df5e>] update_time+0x1e/0xa0
  [<c110e15b>] file_update_time+0x6b/0xa0
  [<f3e7868d>] xfs_file_aio_write_checks+0x8d/0x140 [xfs]
  [<f3e787a8>] xfs_file_buffered_aio_write+0x68/0x180 [xfs]
  [<f3e78989>] xfs_file_aio_write+0xc9/0x180 [xfs]
  [<c10f8187>] do_sync_write+0x57/0x90
  [<c10f8130>] ? do_sync_read+0x90/0x90
  [<c10f88e0>] vfs_write+0x90/0x180
  [<c10f8f2c>] SyS_write+0x4c/0xb0
  [<c1507148>] syscall_call+0x7/0x7
INFO: task sh:17677 blocked for more than 120 seconds.
       Tainted: P           O 3.14.15fe-dirty #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sh              D 00001000     0 17677  17675 0x00000000
  e3d73cd4 00000086 dc9e2420 00001000 e3d73c90 c1122497 f0bbcb20 c1787600
  c1787600 c16a5e40 e91bbb40 00000287 00000001 00000288 e93b5400 f3ec8986
  c63862a8 e3d73cd0 c10f457e e3d73cd0 c112259b 00001287 000000fa e8593c00
Call Trace:
  [<c1122497>] ? __block_commit_write.isra.18+0x67/0x90
  [<f3ec8986>] ? xlog_space_left+0x26/0xa0 [xfs]
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<c112259b>] ? generic_write_end+0x7b/0xb0
  [<f3ec8aa1>] ? xlog_grant_push_ail+0xa1/0xc0 [xfs]
  [<c1504b03>] schedule+0x23/0x60
  [<f3ec8c35>] xlog_grant_head_wait+0x75/0x130 [xfs]
  [<f3ec8d62>] xlog_grant_head_check+0x72/0xc0 [xfs]
  [<f3ecc0cf>] xfs_log_reserve+0xbf/0x160 [xfs]
  [<f3e8a444>] xfs_trans_reserve+0x214/0x220 [xfs]
  [<f3ebb1b3>] xfs_create+0x113/0x490 [xfs]
  [<f3e814d4>] xfs_vn_mknod+0x84/0xe0 [xfs]
  [<f3e8156a>] xfs_vn_create+0x1a/0x20 [xfs]
  [<c110240c>] vfs_create+0x9c/0xe0
  [<c110439a>] do_last.isra.46+0x7aa/0xbf0
  [<c1101e6d>] ? link_path_walk+0x1ed/0x6f0
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<c110488c>] path_openat+0xac/0x590
  [<c10e3a32>] ? handle_mm_fault+0x132/0x850
  [<c1105b11>] do_filp_open+0x31/0x80
  [<c10f7c21>] do_sys_open+0x121/0x220
  [<c1049d07>] ? sigprocmask+0x67/0xb0
  [<c10f7d42>] SyS_open+0x22/0x30
  [<c1507148>] syscall_call+0x7/0x7
INFO: task kworker/u16:0:26574 blocked for more than 120 seconds.
       Tainted: P           O 3.14.15fe-dirty #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u16:0   D 00000286     0 26574      2 0x00000000
Workqueue: writeback bdi_writeback_workfn (flush-9:3)
  ce385b84 00000046 df51bb30 00000286 f3e8a097 df51ba78 df51bb30 c1787600
  c1787600 c16a5e40 d03a3160 00000065 ce385b64 f3e8b14f 00000004 f3ec8986
  e65bccf8 ce385b80 c10f457e dcc9e740 e925e800 e92b2e00 000000fa e8593c00
Call Trace:
  [<f3e8a097>] ? xfs_trans_free+0x57/0x60 [xfs]
  [<f3e8b14f>] ? xfs_trans_commit+0x12f/0x230 [xfs]
  [<f3ec8986>] ? xlog_space_left+0x26/0xa0 [xfs]
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<f3ec8aa1>] ? xlog_grant_push_ail+0xa1/0xc0 [xfs]
  [<c1504b03>] schedule+0x23/0x60
  [<f3ec8c35>] xlog_grant_head_wait+0x75/0x130 [xfs]
  [<f3ec8d62>] xlog_grant_head_check+0x72/0xc0 [xfs]
  [<f3ecc0cf>] xfs_log_reserve+0xbf/0x160 [xfs]
  [<f3e8a444>] xfs_trans_reserve+0x214/0x220 [xfs]
  [<f3e6ce18>] xfs_setfilesize_trans_alloc.isra.7+0x38/0x90 [xfs]
  [<f3e6da05>] xfs_vm_writepage+0x465/0x580 [xfs]
  [<c10cb6d0>] __writepage+0x10/0x40
  [<c10cb6c0>] ? mapping_tagged+0x20/0x20
  [<c10cbbd0>] write_cache_pages+0x170/0x3d0
  [<c10cb6c0>] ? mapping_tagged+0x20/0x20
  [<c12814f6>] ? blk_flush_plug_list+0x86/0x1b0
  [<c10cbe63>] generic_writepages+0x33/0x60
  [<f3e6c8a3>] xfs_vm_writepages+0x33/0x40 [xfs]
  [<c10cd31a>] do_writepages+0x1a/0x40
  [<c111b6b2>] __writeback_single_inode+0x42/0x1f0
  [<c106f2ec>] ? wake_up_bit+0x1c/0x20
  [<c111c413>] writeback_sb_inodes+0x193/0x2e0
  [<c111c5dc>] __writeback_inodes_wb+0x7c/0xb0
  [<c111c7e2>] wb_writeback+0x1d2/0x270
  [<c111ccbc>] bdi_writeback_workfn+0x20c/0x380
  [<c1050b08>] process_one_work+0x108/0x340
  [<c1046045>] ? mod_timer+0xd5/0x180
  [<c1051621>] worker_thread+0x101/0x330
  [<c1051520>] ? manage_workers.isra.28+0x250/0x250
  [<c10566a1>] kthread+0xa1/0xc0
  [<c150e1b7>] ret_from_kernel_thread+0x1b/0x28
  [<c1056600>] ? kthread_create_on_node+0x110/0x110
INFO: task kworker/0:1:17883 blocked for more than 120 seconds.
       Tainted: P           O 3.14.15fe-dirty #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:1     D ea649638     0 17883      2 0x00000000
Workqueue: xfs-log/md3 xfs_log_worker [xfs]
  e385be50 00000046 00000001 ea649638 ced77c5f 00004ed9 ea649638 c1787600
  c1787600 e741b1a0 e0f872a0 e385be84 c106aaec 00000000 00000000 f3ec8986
  e2c8bda8 e385be4c c10f457e 00000000 00000000 0000b40e 000000fa e8593c00
Call Trace:
  [<c106aaec>] ? load_balance+0x16c/0x5b0
  [<f3ec8986>] ? xlog_space_left+0x26/0xa0 [xfs]
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<f3ec8aa1>] ? xlog_grant_push_ail+0xa1/0xc0 [xfs]
  [<c1504b03>] schedule+0x23/0x60
  [<f3ec8c35>] xlog_grant_head_wait+0x75/0x130 [xfs]
  [<f3ec8d62>] xlog_grant_head_check+0x72/0xc0 [xfs]
  [<f3ecc0cf>] xfs_log_reserve+0xbf/0x160 [xfs]
  [<f3e8a444>] xfs_trans_reserve+0x214/0x220 [xfs]
  [<f3e7abd4>] xfs_fs_log_dummy+0x34/0x80 [xfs]
  [<f3ecba1f>] xfs_log_worker+0x3f/0x50 [xfs]
  [<c1050b08>] process_one_work+0x108/0x340
  [<c104fdc3>] ? destroy_worker+0x83/0xc0
  [<c1051475>] ? manage_workers.isra.28+0x1a5/0x250
  [<c1051621>] worker_thread+0x101/0x330
  [<c1051520>] ? manage_workers.isra.28+0x250/0x250
  [<c10566a1>] kthread+0xa1/0xc0
  [<c150e1b7>] ret_from_kernel_thread+0x1b/0x28
  [<c1056600>] ? kthread_create_on_node+0x110/0x110
INFO: task sh:3237 blocked for more than 120 seconds.
       Tainted: P           O 3.14.15fe-dirty #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sh              D 00000000     0  3237   3234 0x00000000
  c094dd48 00000082 00000000 00000000 c094dd04 f3ec8b16 e8593e04 c1787600
  c1787600 ea18f630 e741ad50 e8593c00 e8593e00 e8593c74 c094dd24 f3ec8986
  c697c058 c094dd44 c10f457e c094dd2c c10379be ea81d180 000000fa e8593c00
Call Trace:
  [<f3ec8b16>] ? xlog_grant_head_wake+0x56/0xc0 [xfs]
  [<f3ec8986>] ? xlog_space_left+0x26/0xa0 [xfs]
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<c10379be>] ? kmap_atomic_prot+0x3e/0xd0
  [<f3ec8aa1>] ? xlog_grant_push_ail+0xa1/0xc0 [xfs]
  [<c1504b03>] schedule+0x23/0x60
  [<f3ec8c35>] xlog_grant_head_wait+0x75/0x130 [xfs]
  [<f3ec8d62>] xlog_grant_head_check+0x72/0xc0 [xfs]
  [<f3ecc0cf>] xfs_log_reserve+0xbf/0x160 [xfs]
  [<f3e8a444>] xfs_trans_reserve+0x214/0x220 [xfs]
  [<f3e811b8>] xfs_vn_update_time+0x58/0x150 [xfs]
  [<f3e81160>] ? xfs_vn_getattr+0x200/0x200 [xfs]
  [<c110df5e>] update_time+0x1e/0xa0
  [<c110e15b>] file_update_time+0x6b/0xa0
  [<f3e7868d>] xfs_file_aio_write_checks+0x8d/0x140 [xfs]
  [<f3e787a8>] xfs_file_buffered_aio_write+0x68/0x180 [xfs]
  [<c10e1ff5>] ? do_wp_page+0x2e5/0x740
  [<f3e78989>] xfs_file_aio_write+0xc9/0x180 [xfs]
  [<c10f8187>] do_sync_write+0x57/0x90
  [<c10f8130>] ? do_sync_read+0x90/0x90
  [<c10f88e0>] vfs_write+0x90/0x180
  [<c10f8f2c>] SyS_write+0x4c/0xb0
  [<c1507148>] syscall_call+0x7/0x7
INFO: task mv:17651 blocked for more than 120 seconds.
       Tainted: P           O 3.14.15fe-dirty #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mv              D c1506cc8     0 17651  13354 0x00000000
  cfbabd0c 00000086 cfbabca0 c1506cc8 00000001 c16e4c74 00000003 c1787600
  c1787600 ea15ed50 cace76b0 c106f28f 00000000 00000000 00000001 f3ec8986
  c697c108 cfbabd08 c10f457e c14de398 00000000 ce29bd80 000000fa e8593c00
Call Trace:
  [<c1506cc8>] ? _raw_spin_unlock_bh+0x18/0x20
  [<c106f28f>] ? __wake_up+0x3f/0x50
  [<f3ec8986>] ? xlog_space_left+0x26/0xa0 [xfs]
  [<c10f457e>] ? kmem_cache_alloc+0xae/0x110
  [<c14de398>] ? rpc_release_client+0x78/0x80
  [<f3ec8aa1>] ? xlog_grant_push_ail+0xa1/0xc0 [xfs]
  [<c1504b03>] schedule+0x23/0x60
  [<f3ec8c35>] xlog_grant_head_wait+0x75/0x130 [xfs]
  [<f3ec8d62>] xlog_grant_head_check+0x72/0xc0 [xfs]
  [<f3ecc0cf>] xfs_log_reserve+0xbf/0x160 [xfs]
  [<f3e8a444>] xfs_trans_reserve+0x214/0x220 [xfs]
  [<f3ebc6bb>] xfs_rename+0xeb/0x5a0 [xfs]
  [<c1101c46>] ? inode_permission+0x16/0x50
  [<c11081a4>] ? filldir64+0x44/0x110
  [<f3e813ab>] xfs_vn_rename+0x8b/0xa0 [xfs]
  [<c11058ce>] vfs_rename+0x4fe/0x510
  [<c1100f44>] ? lookup_dcache+0x24/0xa0
  [<c11064ce>] SyS_renameat+0x21e/0x340
  [<c150a25f>] ? __do_page_fault+0x28f/0x4d0
  [<c110661d>] SyS_rename+0x2d/0x30
  [<c1507148>] syscall_call+0x7/0x7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
