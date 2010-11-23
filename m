Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANCNK2S206226 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 06:23:20 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63AC813E5069
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 04:24:53 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7q7vcgLiWDecwAPK for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 04:24:53 -0800 (PST)
Date: Tue, 23 Nov 2010 23:24:49 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: XFS performance oddity
Message-ID: <20101123122449.GA4812@amd>
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

Hi,

Running parallel fs_mark (0 size inodes, fsync on close) on a ramdisk
ends up with XFS in funny patterns.

procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
24  1   6576 166396    252 393676  132  140 16900 80666 21308 104333  1 84 14  1
21  0   6712 433856    256 387080  100  224  9152 53487 13677 53732  0 55 45  0
 2  0   7068 463496    248 389100    0  364  2940 17896 4485 26122  0 33 65  2
 1  0   7068 464340    248 388928    0    0     0     0   66  207  0  0 100  0
 0  0   7068 464340    248 388928    0    0     0     0   79  200  0  0 100  0
 0  0   7068 464544    248 388928    0    0     0     0   65  199  0  0 100  0
 1  0   7068 464748    248 388928    0    0     0     0   79  201  0  0 100  0
 0  0   7068 465064    248 388928    0    0     0     0   66  202  0  0 100  0
 0  0   7068 465312    248 388928    0    0     0     0   80  200  0  0 100  0
 0  0   7068 465500    248 388928    0    0     0     0   65  199  0  0 100  0
 0  0   7068 465500    248 388928    0    0     0     0   80  202  0  0 100  0
 1  0   7068 465500    248 388928    0    0     0     0   66  203  0  0 100  0
 0  0   7068 465500    248 388928    0    0     0     0   79  200  0  0 100  0
23  0   7068 460332    248 388800    0    0  1416  8896 1981 7142  0  1 99  0
 6  0   6968 360248    248 403736   56    0 15568 95171 19438 110825  1 79 21  0
23  0   6904 248736    248 419704  392    0 17412 118270 20208 111396  1 82 17  0
 9  0   6884 266116    248 435904  128    0 14956 79756 18554 118020  1 76 23  0
 0  0   6848 219640    248 445760  212    0  9932 51572 12622 76491  0 60 40  0

Got a dump of sleeping tasks. Any ideas?


[  495.828231] SysRq : Show Blocked State
[  495.828457]   task                        PC stack   pid father
[  495.828639] rm            D 0000000000000000  3856  4267   1860 0x00000000
[  495.828942]  ffff8800444fbc58 0000000000000046 ffff880000000000 00000000ffffffff
[  495.829061]  0000000000000282 ffff8800444fa000 ffff8800444fa000 000000000000d6c8
[  495.829061]  ffff8800444fa010 ffff8800444fbfd8 ffff88012bc25d00 ffff880124333e00
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3208  4268   1860 0x00000000
[  495.829061]  ffff880075ce7c58 0000000000000046 ffff880000000000 00000000ffffffff
[  495.829061]  0000000000000282 ffff880075ce6000 ffff880075ce6000 000000000000d6c8
[  495.829061]  ffff880075ce6010 ffff880075ce7fd8 ffff88012bd29f00 ffff880124330f80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3448  4269   1860 0x00000000
[  495.829061]  ffff880052411c98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff880052410000 ffff880052410000 000000000000d6c8
[  495.829061]  ffff880052410010 ffff880052411fd8 ffff88012bcadd00 ffff880124335d00
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3648  4270   1860 0x00000000
[  495.829061]  ffff88007361dc98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff88007361c000 ffff88007361c000 000000000000d6c8
[  495.829061]  ffff88007361c010 ffff88007361dfd8 ffff88012bc45d00 ffff880124330000
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3568  4271   1860 0x00000000
[  495.829061]  ffff88005e9d3c58 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000282 ffff88005e9d2000 ffff88005e9d2000 000000000000d6c8
[  495.829061]  ffff88005e9d2010 ffff88005e9d3fd8 ffff88012bcd5d00 ffff880124334d80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3568  4272   1860 0x00000000
[  495.829061]  ffff88007543bc58 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000282 ffff88007543a000 ffff88007543a000 000000000000d6c8
[  495.829061]  ffff88007543a010 ffff88007543bfd8 ffff88012bd91f00 ffff880124331f00
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3568  4273   1860 0x00000000
[  495.829061]  ffff880076efbc98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff880076efa000 ffff880076efa000 000000000000d6c8
[  495.829061]  ffff880076efa010 ffff880076efbfd8 ffff88012bd2dd00 ffff880124336c80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3280  4274   1860 0x00000000
[  495.829061]  ffff8800767f7c58 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000282 ffff8800767f6000 ffff8800767f6000 000000000000d6c8
[  495.829061]  ffff8800767f6010 ffff8800767f7fd8 ffff88012bd95d00 ffff880124332e80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3488  4275   1860 0x00000000
[  495.829061]  ffff880075299c58 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000282 ffff880075298000 ffff880075298000 000000000000d6c8
[  495.829061]  ffff880075298010 ffff880075299fd8 ffffffff81c0b020 ffff8801e9be3e00
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3056  4276   1860 0x00000000
[  495.829061]  ffff8800459b9c98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff8800459b8000 ffff8800459b8000 000000000000d6c8
[  495.829061]  ffff8800459b8010 ffff8800459b9fd8 ffff88012bdd1f00 ffff8801e9be5d00
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3224  4277   1860 0x00000000
[  495.829061]  ffff880081a65c98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff880081a64000 ffff880081a64000 000000000000d6c8
[  495.829061]  ffff880081a64010 ffff880081a65fd8 ffff88012bc01f00 ffff8801e9be6c80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3488  4278   1860 0x00000000
[  495.829061]  ffff88007fcfbc98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff88007fcfa000 ffff88007fcfa000 000000000000d6c8
[  495.829061]  ffff88007fcfa010 ffff88007fcfbfd8 ffff88012bcd1f00 ffff8801e9be2e80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3360  4279   1860 0x00000000
[  495.829061]  ffff880082201c98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff880082200000 ffff880082200000 000000000000d6c8
[  495.829061]  ffff880082200010 ffff880082201fd8 ffff88012be11f00 ffff8801e9be0000
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3456  4280   1860 0x00000000
[  495.829061]  ffff88004478dc58 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000282 ffff88004478c000 ffff88004478c000 000000000000d6c8
[  495.829061]  ffff88004478c010 ffff88004478dfd8 ffff88012bd05d00 ffff8801e9be0f80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3216  4281   1860 0x00000000
[  495.829061]  ffff8800478a9c98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff8800478a8000 ffff8800478a8000 000000000000d6c8
[  495.829061]  ffff8800478a8010 ffff8800478a9fd8 ffff88012bd01f00 ffff8801ea026c80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3488  4282   1860 0x00000000
[  495.829061]  ffff88003e82dc98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff88003e82c000 ffff88003e82c000 000000000000d6c8
[  495.829061]  ffff88003e82c010 ffff88003e82dfd8 ffff88012bc6dd00 ffff8801ea025d00
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3568  4283   1860 0x00000000
[  495.829061]  ffff88003ccafc58 0000000000000046 ffff88003ccafbd8 0000000000000000
[  495.829061]  0000000000000282 ffff88003ccae000 ffff88003ccae000 000000000000d6c8
[  495.829061]  ffff88003ccae010 ffff88003ccaffd8 ffff88012bc05d00 ffff8800777a8000
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3568  4284   1860 0x00000000
[  495.829061]  ffff880071d57c58 0000000000000046 ffff880000000000 00000000ffffffff
[  495.829061]  0000000000000282 ffff880071d56000 ffff880071d56000 000000000000d6c8
[  495.829061]  ffff880071d56010 ffff880071d57fd8 ffff88012bd55d00 ffff8800777a8f80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3488  4285   1860 0x00000000
[  495.829061]  ffff88004bd59c98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff88004bd58000 ffff88004bd58000 000000000000d6c8
[  495.829061]  ffff88004bd58010 ffff88004bd59fd8 ffff88012bc69f00 ffff8800777a9f00
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3568  4286   1860 0x00000000
[  495.829061]  ffff880075ebbc98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff880075eba000 ffff880075eba000 000000000000d6c8
[  495.829061]  ffff880075eba010 ffff880075ebbfd8 ffff88012bd51f00 ffff8800777aae80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  2624  4287   1860 0x00000000
[  495.829061]  ffff880037f1fc58 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000282 ffff880037f1e000 ffff880037f1e000 000000000000d6c8
[  495.829061]  ffff880037f1e010 ffff880037f1ffd8 ffff88012bca9f00 ffff8800777abe00
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3440  4288   1860 0x00000000
[  495.829061]  ffff880070d21c58 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000282 ffff880070d20000 ffff880070d20000 000000000000d6c8
[  495.829061]  ffff880070d20010 ffff880070d21fd8 ffff88012bc41f00 ffff8800777acd80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  3056  4289   1860 0x00000000
[  495.829061]  ffff880047dd3c58 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000282 ffff880047dd2000 ffff880047dd2000 000000000000d6c8
[  495.829061]  ffff880047dd2010 ffff880047dd3fd8 ffff88012bc05d00 ffff8800777add00
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079358>] xlog_grant_log_space+0x2c8/0x8a0 [xfs]
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a61>] ? xfs_iunlock+0x121/0x1f0 [xfs]
[  495.829061]  [<ffffffffa008eb0c>] xfs_remove+0x12c/0x470 [xfs]
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffff8112f1e0>] ? __d_lookup+0x1c0/0x1f0
[  495.829061]  [<ffffffff8112f020>] ? __d_lookup+0x0/0x1f0
[  495.829061]  [<ffffffff81123d58>] ? vfs_unlink+0x68/0xf0
[  495.829061]  [<ffffffffa009f303>] xfs_vn_unlink+0x43/0x90 [xfs]
[  495.829061]  [<ffffffff81123d84>] vfs_unlink+0x94/0xf0
[  495.829061]  [<ffffffff81126893>] do_unlinkat+0x193/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[  495.829061] rm            D 0000000000000000  2728  4290   1860 0x00000000
[  495.829061]  ffff880056577c98 0000000000000046 ffff880000000000 0000000000000000
[  495.829061]  0000000000000286 ffff880056576000 ffff880056576000 000000000000d6c8
[  495.829061]  ffff880056576010 ffff880056577fd8 ffff88012bc21f00 ffff8800777aec80
[  495.829061] Call Trace:
[  495.829061]  [<ffffffffa0079228>] xlog_grant_log_space+0x198/0x8a0 [xfs]
[  495.829061]  [<ffffffff81606d3d>] ? sub_preempt_count+0x9d/0xd0
[  495.829061]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
[  495.829061]  [<ffffffffa007a9bb>] xfs_log_reserve+0x16b/0x2b0 [xfs]
[  495.829061]  [<ffffffffa0088be4>] xfs_trans_reserve+0xe4/0x290 [xfs]
[  495.829061]  [<ffffffffa0067a1d>] ? xfs_iunlock+0xdd/0x1f0 [xfs]
[  495.829061]  [<ffffffffa009058c>] xfs_inactive+0x22c/0x520 [xfs]
[  495.829061]  [<ffffffff8127dfd6>] ? __init_rwsem+0x56/0x70
[  495.829061]  [<ffffffffa009ff8b>] xfs_fs_evict_inode+0xeb/0x180 [xfs]
[  495.829061]  [<ffffffff81130aa2>] evict+0x22/0xb0
[  495.829061]  [<ffffffff81131075>] iput+0x1c5/0x2b0
[  495.829061]  [<ffffffff81126825>] do_unlinkat+0x125/0x1d0
[  495.829061]  [<ffffffff8111d231>] ? sys_newfstatat+0x31/0x50
[  495.829061]  [<ffffffff816028c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  495.829061]  [<ffffffff81126a3d>] sys_unlinkat+0x1d/0x40
[  495.829061]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
