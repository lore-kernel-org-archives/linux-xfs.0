Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8F587CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 05:16:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C9FE304043
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 03:16:54 -0700 (PDT)
Received: from mail-oi0-f51.google.com (mail-oi0-f51.google.com
	[209.85.218.51]) by cuda.sgi.com with ESMTP id f1uPzrnsX7fz1YEy
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2016 03:16:49 -0700 (PDT)
Received: by mail-oi0-f51.google.com with SMTP id w18so245606080oiw.3
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 03:16:49 -0700 (PDT)
MIME-Version: 1.0
From: Jinesh Choksi <jinesh.choksi@algomi.com>
Date: Mon, 18 Jul 2016 11:16:28 +0100
Message-ID: <CAOdEjeVMXjv4ke0qKifrcOKBY4_cH66FtrTG5erC0d42hUL0RQ@mail.gmail.com>
Subject: XFS file system hang
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4500478978027550361=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4500478978027550361==
Content-Type: multipart/alternative; boundary=001a113ce4dc12838f0537e6442b

--001a113ce4dc12838f0537e6442b
Content-Type: text/plain; charset=UTF-8

Hi,

We recently experienced a kernel hang on a CentOs Linux 7.2.1511 server
which
was operating as a Nexus artefacts repository.

I believe the hang is file system related and am looking for assistance in
diagnosing the root cause of the issue and whether there is a resolution for
it.

I am unable to reproduce the hang. It has only happened once so far.
The server is operating properly at the moment.

Below are the requested details in the XFS FAQ for reporting problems and if
any further information is required, please ask.

TIA and regards,
Jinesh


---------------------------------------
console output when the server was hung
---------------------------------------
[4120921.739069] INFO: task kthreadd:2 blocked for more than 120 seconds.
[4120921.744848] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[4120921.751254] kthreadd        D ffffffffffffffff     0     2      0
0x00000000
[4120921.757324]  ffff8802041734e0 0000000000000046 ffff8802040f0b80
ffff880204173fd8
[4120921.763417]  ffff880204173fd8 ffff880204173fd8 ffff8802040f0b80
ffff880204173628
[4120921.769465]  ffff880204173630 7fffffffffffffff ffff8802040f0b80
ffffffffffffffff
[4120921.775993] Call Trace:
[4120921.780164]  [<ffffffff8163b139>] schedule+0x29/0x70
[4120921.784900]  [<ffffffff81638e29>] schedule_timeout+0x209/0x2d0
[4120921.790127]  [<ffffffff810b5df9>] ? ttwu_do_wakeup+0x19/0xd0
[4120921.796310]  [<ffffffff810b5f8d>] ?
ttwu_do_activate.constprop.84+0x5d/0x70
[4120921.801870]  [<ffffffff810b8726>] ? try_to_wake_up+0x1b6/0x300
[4120921.806965]  [<ffffffff8163b506>] wait_for_completion+0x116/0x170
[4120921.811843]  [<ffffffff810b88d0>] ? wake_up_state+0x20/0x20
[4120921.816596]  [<ffffffff8109e7ac>] flush_work+0xfc/0x1c0
[4120921.821211]  [<ffffffff8109a7e0>] ? move_linked_works+0x90/0x90
[4120921.826269]  [<ffffffffa015b43a>] xlog_cil_force_lsn+0x8a/0x210 [xfs]
[4120921.831431]  [<ffffffffa0159a7e>] _xfs_log_force_lsn+0x6e/0x2f0 [xfs]
[4120921.836699]  [<ffffffff816322f5>] ? __slab_free+0x10e/0x277
[4120921.841314]  [<ffffffffa0159d2e>] xfs_log_force_lsn+0x2e/0x90 [xfs]
[4120921.846290]  [<ffffffffa014bfc9>] ? xfs_iunpin_wait+0x19/0x20 [xfs]
[4120921.851084]  [<ffffffffa01484b7>] __xfs_iunpin_wait+0xa7/0x150 [xfs]
[4120921.855634]  [<ffffffff810a6b60>] ? wake_atomic_t_function+0x40/0x40
[4120921.860379]  [<ffffffffa014bfc9>] xfs_iunpin_wait+0x19/0x20 [xfs]
[4120921.864993]  [<ffffffffa014084c>] xfs_reclaim_inode+0x8c/0x350 [xfs]
[4120921.869706]  [<ffffffffa0140d77>] xfs_reclaim_inodes_ag+0x267/0x390
[xfs]
[4120921.874552]  [<ffffffff810b5f8d>] ?
ttwu_do_activate.constprop.84+0x5d/0x70
[4120921.879503]  [<ffffffff810b8726>] ? try_to_wake_up+0x1b6/0x300
[4120921.883890]  [<ffffffff810b8893>] ? wake_up_process+0x23/0x40
[4120921.888214]  [<ffffffffa0141923>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
[4120921.892889]  [<ffffffffa0150895>] xfs_fs_free_cached_objects+0x15/0x20
[xfs]
[4120921.897710]  [<ffffffff811e0ea8>] prune_super+0xe8/0x170
[4120921.901538]  [<ffffffff8117c795>] shrink_slab+0x165/0x300
[4120921.905558]  [<ffffffff811d60d1>] ? vmpressure+0x21/0x90
[4120921.909477]  [<ffffffff8117f912>] do_try_to_free_pages+0x3c2/0x4e0
[4120921.913752]  [<ffffffff8117fb2c>] try_to_free_pages+0xfc/0x180
[4120921.917891]  [<ffffffff8117382d>] __alloc_pages_nodemask+0x7fd/0xb90
[4120921.922224]  [<ffffffff81078d73>] copy_process.part.25+0x163/0x1610
[4120921.926508]  [<ffffffff810c226e>] ? dequeue_task_fair+0x42e/0x640
[4120921.930581]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120921.934837]  [<ffffffff8107a401>] do_fork+0xe1/0x320
[4120921.938364]  [<ffffffff8107a666>] kernel_thread+0x26/0x30
[4120921.942056]  [<ffffffff810a65f2>] kthreadd+0x2b2/0x2f0
[4120921.945527]  [<ffffffff810a6340>] ? kthread_create_on_cpu+0x60/0x60
[4120921.949393]  [<ffffffff81646118>] ret_from_fork+0x58/0x90
[4120921.953247]  [<ffffffff810a6340>] ? kthread_create_on_cpu+0x60/0x60
[4120921.957337] INFO: task kswapd0:63 blocked for more than 120 seconds.
[4120921.961229] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[4120921.965814] kswapd0         D ffffffffffffffff     0    63      2
0x00000000
[4120921.970177]  ffff8801edebf6f0 0000000000000046 ffff88020433c500
ffff8801edebffd8
[4120921.974816]  ffff8801edebffd8 ffff8801edebffd8 ffff88020433c500
ffff8801edebf838
[4120921.979486]  ffff8801edebf840 7fffffffffffffff ffff88020433c500
ffffffffffffffff
[4120921.984171] Call Trace:
[4120921.986327]  [<ffffffff8163b139>] schedule+0x29/0x70
[4120921.989613]  [<ffffffff81638e29>] schedule_timeout+0x209/0x2d0
[4120921.993136]  [<ffffffff810b5df9>] ? ttwu_do_wakeup+0x19/0xd0
[4120921.996564]  [<ffffffff810b5f8d>] ?
ttwu_do_activate.constprop.84+0x5d/0x70
[4120922.000534]  [<ffffffff810b8726>] ? try_to_wake_up+0x1b6/0x300
[4120922.004365]  [<ffffffff8163b506>] wait_for_completion+0x116/0x170
[4120922.008129]  [<ffffffff810b88d0>] ? wake_up_state+0x20/0x20
[4120922.011631]  [<ffffffff8109e7ac>] flush_work+0xfc/0x1c0
[4120922.015008]  [<ffffffff8109a7e0>] ? move_linked_works+0x90/0x90
[4120922.018747]  [<ffffffffa015b43a>] xlog_cil_force_lsn+0x8a/0x210 [xfs]
[4120922.022623]  [<ffffffff81171abb>] ? free_pcppages_bulk+0x34b/0x3a0
[4120922.026463]  [<ffffffffa0159a7e>] _xfs_log_force_lsn+0x6e/0x2f0 [xfs]
[4120922.030559]  [<ffffffff816322f5>] ? __slab_free+0x10e/0x277
[4120922.034123]  [<ffffffffa0159d2e>] xfs_log_force_lsn+0x2e/0x90 [xfs]
[4120922.037986]  [<ffffffffa014bfc9>] ? xfs_iunpin_wait+0x19/0x20 [xfs]
[4120922.041840]  [<ffffffffa01484b7>] __xfs_iunpin_wait+0xa7/0x150 [xfs]
[4120922.045748]  [<ffffffff810a6b60>] ? wake_atomic_t_function+0x40/0x40
[4120922.049556]  [<ffffffffa014bfc9>] xfs_iunpin_wait+0x19/0x20 [xfs]
[4120922.053515]  [<ffffffffa014084c>] xfs_reclaim_inode+0x8c/0x350 [xfs]
[4120922.057429]  [<ffffffffa0140d77>] xfs_reclaim_inodes_ag+0x267/0x390
[xfs]
[4120922.061637]  [<ffffffffa0141923>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
[4120922.065723]  [<ffffffffa0150895>] xfs_fs_free_cached_objects+0x15/0x20
[xfs]
[4120922.069902]  [<ffffffff811e0ea8>] prune_super+0xe8/0x170
[4120922.073288]  [<ffffffff8117c795>] shrink_slab+0x165/0x300
[4120922.076715]  [<ffffffff811d6111>] ? vmpressure+0x61/0x90
[4120922.080154]  [<ffffffff81180401>] balance_pgdat+0x4b1/0x5e0
[4120922.083522]  [<ffffffff811806a3>] kswapd+0x173/0x450
[4120922.086630]  [<ffffffff810a6ae0>] ? wake_up_atomic_t+0x30/0x30
[4120922.090186]  [<ffffffff81180530>] ? balance_pgdat+0x5e0/0x5e0
[4120922.093399]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
[4120922.096164]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.102513]  [<ffffffff81646118>] ret_from_fork+0x58/0x90
[4120922.105472]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.108855] INFO: task xfsaild/xvdb1:499 blocked for more than 120
seconds.
[4120922.112411] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[4120922.116496] xfsaild/xvdb1   D ffffffffffffffff     0   499      2
0x00000000
[4120922.120931]  ffff8801ec897a80 0000000000000046 ffff8801ed827300
ffff8801ec897fd8
[4120922.126370]  ffff8801ec897fd8 ffff8801ec897fd8 ffff8801ed827300
ffff8801ec897bd0
[4120922.131959]  ffff8801ec897bd8 7fffffffffffffff ffff8801ed827300
ffffffffffffffff
[4120922.137824] Call Trace:
[4120922.140429]  [<ffffffff8163b139>] schedule+0x29/0x70
[4120922.144426]  [<ffffffff81638e29>] schedule_timeout+0x209/0x2d0
[4120922.148294]  [<ffffffff81009ee0>] ? xen_clocksource_read+0x20/0x30
[4120922.152181]  [<ffffffff8101cd69>] ? sched_clock+0x9/0x10
[4120922.155625]  [<ffffffff812d0876>] ? __blk_segment_map_sg+0x56/0x1b0
[4120922.159579]  [<ffffffff810b8726>] ? try_to_wake_up+0x1b6/0x300
[4120922.163346]  [<ffffffff8163b506>] wait_for_completion+0x116/0x170
[4120922.166567]  [<ffffffff810b88d0>] ? wake_up_state+0x20/0x20
[4120922.169550]  [<ffffffff8109e7ac>] flush_work+0xfc/0x1c0
[4120922.172533]  [<ffffffff8109a7e0>] ? move_linked_works+0x90/0x90
[4120922.175723]  [<ffffffffa015b43a>] xlog_cil_force_lsn+0x8a/0x210 [xfs]
[4120922.179179]  [<ffffffffa0138d1c>] ? xfs_buf_read_map+0x2c/0x140 [xfs]
[4120922.183095]  [<ffffffffa0159720>] _xfs_log_force+0x70/0x290 [xfs]
[4120922.186887]  [<ffffffffa0159966>] xfs_log_force+0x26/0x80 [xfs]
[4120922.190574]  [<ffffffffa014ce8a>] xfs_iflush+0x22a/0x240 [xfs]
[4120922.194204]  [<ffffffffa015d76e>] xfs_inode_item_push+0xee/0x150 [xfs]
[4120922.198158]  [<ffffffffa0164470>] ?
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[4120922.202174]  [<ffffffffa0164771>] xfsaild+0x301/0x5e0 [xfs]
[4120922.205486]  [<ffffffffa0164470>] ?
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[4120922.209462]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
[4120922.213098]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.217013]  [<ffffffff81646118>] ret_from_fork+0x58/0x90
[4120922.220426]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.224358] INFO: task kworker/1:0H:3437 blocked for more than 120
seconds.
[4120922.228432] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[4120922.232937] kworker/1:0H    D ffffffffffffffff     0  3437      2
0x00000080
[4120922.237282] Workqueue: xfs-log/xvdb1 xfs_log_worker [xfs]
[4120922.240825]  ffff8800d287bb30 0000000000000046 ffff880119b18b80
ffff8800d287bfd8
[4120922.245511]  ffff8800d287bfd8 ffff8800d287bfd8 ffff880119b18b80
ffff8800d287bc78
[4120922.250044]  ffff8800d287bc80 7fffffffffffffff ffff880119b18b80
ffffffffffffffff
[4120922.255485] Call Trace:
[4120922.260678]  [<ffffffff8163b139>] schedule+0x29/0x70
[4120922.266190]  [<ffffffff81638e29>] schedule_timeout+0x209/0x2d0
[4120922.269977]  [<ffffffff810b5dc5>] ? check_preempt_curr+0x85/0xa0
[4120922.274092]  [<ffffffff810b5df9>] ? ttwu_do_wakeup+0x19/0xd0
[4120922.279267]  [<ffffffff810b8726>] ? try_to_wake_up+0x1b6/0x300
[4120922.284441]  [<ffffffff8163b506>] wait_for_completion+0x116/0x170
[4120922.298485]  [<ffffffff810b88d0>] ? wake_up_state+0x20/0x20
[4120922.302237]  [<ffffffff8109e7ac>] flush_work+0xfc/0x1c0
[4120922.305656]  [<ffffffff8109a7e0>] ? move_linked_works+0x90/0x90
[4120922.309291]  [<ffffffffa015b43a>] xlog_cil_force_lsn+0x8a/0x210 [xfs]
[4120922.313239]  [<ffffffff810c1a26>] ? dequeue_entity+0x106/0x520
[4120922.317172]  [<ffffffffa0159720>] _xfs_log_force+0x70/0x290 [xfs]
[4120922.321545]  [<ffffffff810c226e>] ? dequeue_task_fair+0x42e/0x640
[4120922.326162]  [<ffffffff810bb768>] ? sched_clock_cpu+0x98/0xc0
[4120922.330583]  [<ffffffff81013588>] ? __switch_to+0xf8/0x4b0
[4120922.334868]  [<ffffffffa0159966>] xfs_log_force+0x26/0x80 [xfs]
[4120922.339370]  [<ffffffffa01599e4>] xfs_log_worker+0x24/0x50 [xfs]
[4120922.343136]  [<ffffffff8109d5fb>] process_one_work+0x17b/0x470
[4120922.347247]  [<ffffffff8109e3cb>] worker_thread+0x11b/0x400
[4120922.350965]  [<ffffffff8109e2b0>] ? rescuer_thread+0x400/0x400
[4120922.354513]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
[4120922.357578]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.369011]  [<ffffffff81646118>] ret_from_fork+0x58/0x90
[4120922.373843]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.379463] INFO: task kworker/u30:2:14068 blocked for more than 120
seconds.
[4120922.384006] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[4120922.387872] kworker/u30:2   D ffffffffffffffff     0 14068      2
0x00000080
[4120922.391575] Workqueue: writeback bdi_writeback_workfn (flush-202:16)
[4120922.395090]  ffff8800630e7210 0000000000000046 ffff8800c11f6780
ffff8800630e7fd8
[4120922.399023]  ffff8800630e7fd8 ffff8800630e7fd8 ffff8800c11f6780
ffff8800630e7360
[4120922.402933]  ffff8800630e7368 7fffffffffffffff ffff8800c11f6780
ffffffffffffffff
[4120922.406926] Call Trace:
[4120922.408912]  [<ffffffff8163b139>] schedule+0x29/0x70
[4120922.411795]  [<ffffffff81638e29>] schedule_timeout+0x209/0x2d0
[4120922.415046]  [<ffffffff810b5df9>] ? ttwu_do_wakeup+0x19/0xd0
[4120922.418146]  [<ffffffff810b5f8d>] ?
ttwu_do_activate.constprop.84+0x5d/0x70
[4120922.421720]  [<ffffffff810b8726>] ? try_to_wake_up+0x1b6/0x300
[4120922.425018]  [<ffffffff8163b506>] wait_for_completion+0x116/0x170
[4120922.428241]  [<ffffffff810b88d0>] ? wake_up_state+0x20/0x20
[4120922.431397]  [<ffffffff8109e7ac>] flush_work+0xfc/0x1c0
[4120922.434393]  [<ffffffff8109a7e0>] ? move_linked_works+0x90/0x90
[4120922.437597]  [<ffffffffa015b43a>] xlog_cil_force_lsn+0x8a/0x210 [xfs]
[4120922.441499]  [<ffffffffa0156127>] ? kmem_zone_alloc+0x77/0x100 [xfs]
[4120922.445773]  [<ffffffffa0159720>] _xfs_log_force+0x70/0x290 [xfs]
[4120922.449958]  [<ffffffffa0137b60>] ? xfs_buf_rele+0x40/0x100 [xfs]
[4120922.453640]  [<ffffffffa0159966>] xfs_log_force+0x26/0x80 [xfs]
[4120922.457413]  [<ffffffffa00fa29f>]
xfs_alloc_ag_vextent_near+0x36f/0xa60 [xfs]
[4120922.461804]  [<ffffffffa00fb20d>] xfs_alloc_ag_vextent+0xcd/0x110 [xfs]
[4120922.465858]  [<ffffffffa00fbf89>] xfs_alloc_vextent+0x429/0x5e0 [xfs]
[4120922.469691]  [<ffffffffa010c37f>] xfs_bmap_btalloc+0x3af/0x710 [xfs]
[4120922.473465]  [<ffffffffa010c6ee>] xfs_bmap_alloc+0xe/0x10 [xfs]
[4120922.477311]  [<ffffffffa010d148>] xfs_bmapi_write+0x4d8/0xa90 [xfs]
[4120922.480941]  [<ffffffffa0145c9b>] xfs_iomap_write_allocate+0x14b/0x350
[xfs]
[4120922.485629]  [<ffffffffa0130dc6>] xfs_map_blocks+0x1c6/0x230 [xfs]
[4120922.489841]  [<ffffffffa0131fe3>] xfs_vm_writepage+0x193/0x5d0 [xfs]
[4120922.500558]  [<ffffffff81173d33>] __writepage+0x13/0x50
[4120922.506407]  [<ffffffff81174851>] write_cache_pages+0x251/0x4d0
[4120922.512752]  [<ffffffff81173d20>] ? global_dirtyable_memory+0x70/0x70
[4120922.517334]  [<ffffffff81174b1d>] generic_writepages+0x4d/0x80
[4120922.522017]  [<ffffffffa0131993>] xfs_vm_writepages+0x43/0x50 [xfs]
[4120922.526214]  [<ffffffff81175bce>] do_writepages+0x1e/0x40
[4120922.530955]  [<ffffffff812086b0>] __writeback_single_inode+0x40/0x220
[4120922.536643]  [<ffffffff8120911e>] writeback_sb_inodes+0x25e/0x420
[4120922.542013]  [<ffffffff8120937f>] __writeback_inodes_wb+0x9f/0xd0
[4120922.547375]  [<ffffffff81209bc3>] wb_writeback+0x263/0x2f0
[4120922.552294]  [<ffffffff811f89dc>] ? get_nr_inodes+0x4c/0x70
[4120922.557162]  [<ffffffff8120be4b>] bdi_writeback_workfn+0x2cb/0x460
[4120922.562484]  [<ffffffff8109d5fb>] process_one_work+0x17b/0x470
[4120922.567628]  [<ffffffff8109e3cb>] worker_thread+0x11b/0x400
[4120922.572471]  [<ffffffff8109e2b0>] ? rescuer_thread+0x400/0x400
[4120922.577574]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
[4120922.582063]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.587646]  [<ffffffff81646118>] ret_from_fork+0x58/0x90
[4120922.592440]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.597920] INFO: task kworker/1:2H:14981 blocked for more than 120
seconds.
[4120922.603822] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[4120922.610202] kworker/1:2H    D ffff88001d3e3dd8     0 14981      2
0x00000080
[4120922.616222]  ffff88001d3e3bf0 0000000000000046 ffff88005dbf9700
ffff88001d3e3fd8
[4120922.622752]  ffff88001d3e3fd8 ffff88001d3e3fd8 ffff88005dbf9700
ffff88001d3e3d58
[4120922.629212]  ffff88001d3e3d60 7fffffffffffffff ffff88005dbf9700
ffff88001d3e3dd8
[4120922.635607] Call Trace:
[4120922.638373]  [<ffffffff8163b139>] schedule+0x29/0x70
[4120922.642868]  [<ffffffff81638e29>] schedule_timeout+0x209/0x2d0
[4120922.647988]  [<ffffffff813a3c3b>] ? xen_send_IPI_one+0x2b/0x30
[4120922.652966]  [<ffffffff81011ba0>] ? xen_smp_send_reschedule+0x10/0x20
[4120922.658465]  [<ffffffff810b5128>] ? resched_task+0xb8/0xd0
[4120922.663425]  [<ffffffff810b5db5>] ? check_preempt_curr+0x75/0xa0
[4120922.668687]  [<ffffffff810b5df9>] ? ttwu_do_wakeup+0x19/0xd0
[4120922.673715]  [<ffffffff8163b506>] wait_for_completion+0x116/0x170
[4120922.678970]  [<ffffffff810b88d0>] ? wake_up_state+0x20/0x20
[4120922.683886]  [<ffffffff810a5988>] kthread_create_on_node+0xa8/0x140
[4120922.689305]  [<ffffffff8109e2b0>] ? rescuer_thread+0x400/0x400
[4120922.694460]  [<ffffffff8109d9da>] create_worker+0xea/0x250
[4120922.699194]  [<ffffffff8109dcd6>] manage_workers.isra.24+0xf6/0x2d0
[4120922.704599]  [<ffffffff8109e5e9>] worker_thread+0x339/0x400
[4120922.709613]  [<ffffffff8109e2b0>] ? rescuer_thread+0x400/0x400
[4120922.714725]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
[4120922.719205]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.724918]  [<ffffffff81646118>] ret_from_fork+0x58/0x90
[4120922.729775]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.735513] INFO: task kworker/u30:0:15076 blocked for more than 120
seconds.
[4120922.741555] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[4120922.747874] kworker/u30:0   D ffff8800dc79fdd8     0 15076      2
0x00000080
[4120922.753364]  ffff8800dc79fbf0 0000000000000046 ffff88005dbfdc00
ffff8800dc79ffd8
[4120922.758892]  ffff8800dc79ffd8 ffff8800dc79ffd8 ffff88005dbfdc00
ffff8800dc79fd58
[4120922.763731]  ffff8800dc79fd60 7fffffffffffffff ffff88005dbfdc00
ffff8800dc79fdd8
[4120922.768429] Call Trace:
[4120922.770718]  [<ffffffff8163b139>] schedule+0x29/0x70
[4120922.774272]  [<ffffffff81638e29>] schedule_timeout+0x209/0x2d0
[4120922.777813]  [<ffffffff810b5dc5>] ? check_preempt_curr+0x85/0xa0
[4120922.781779]  [<ffffffff810b5df9>] ? ttwu_do_wakeup+0x19/0xd0
[4120922.784985]  [<ffffffff8163b506>] wait_for_completion+0x116/0x170
[4120922.788227]  [<ffffffff810b88d0>] ? wake_up_state+0x20/0x20
[4120922.791261]  [<ffffffff810a5988>] kthread_create_on_node+0xa8/0x140
[4120922.795287]  [<ffffffff8109e2b0>] ? rescuer_thread+0x400/0x400
[4120922.798776]  [<ffffffff8109d9da>] create_worker+0xea/0x250
[4120922.801800]  [<ffffffff8109dcd6>] manage_workers.isra.24+0xf6/0x2d0
[4120922.805166]  [<ffffffff8109e5e9>] worker_thread+0x339/0x400
[4120922.810183]  [<ffffffff8109e2b0>] ? rescuer_thread+0x400/0x400
[4120922.814169]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
[4120922.817285]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.821596]  [<ffffffff81646118>] ret_from_fork+0x58/0x90
[4120922.825714]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.829190] INFO: task kworker/1:2:15134 blocked for more than 120
seconds.
[4120922.832931] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[4120922.836876] kworker/1:2     D ffff880034f0d500     0 15134      2
0x00000080
[4120922.842589] Workqueue: xfs-cil/xvdb1 xlog_cil_push_work [xfs]
[4120922.847416]  ffff880075483be8 0000000000000046 ffff880034365080
ffff880075483fd8
[4120922.852258]  ffff880075483fd8 ffff880075483fd8 ffff880034365080
ffff880034f0d400
[4120922.856752]  ffff880034f0d528 ffff88013ca56170 ffff880034365080
ffff880034f0d500
[4120922.860940] Call Trace:
[4120922.863004]  [<ffffffff8163b139>] schedule+0x29/0x70
[4120922.867417]  [<ffffffffa0158b9c>]
xlog_state_get_iclog_space+0xec/0x2f0 [xfs]
[4120922.873230]  [<ffffffffa0158815>] ? xlog_sync+0x285/0x430 [xfs]
[4120922.877108]  [<ffffffff810b88d0>] ? wake_up_state+0x20/0x20
[4120922.880725]  [<ffffffffa0159077>] xlog_write+0x1b7/0x700 [xfs]
[4120922.884418]  [<ffffffffa015abd9>] xlog_cil_push+0x239/0x420 [xfs]
[4120922.887771]  [<ffffffffa015add5>] xlog_cil_push_work+0x15/0x20 [xfs]
[4120922.891643]  [<ffffffff8109d5fb>] process_one_work+0x17b/0x470
[4120922.896259]  [<ffffffff8109e543>] worker_thread+0x293/0x400
[4120922.900676]  [<ffffffff8109e2b0>] ? rescuer_thread+0x400/0x400
[4120922.904386]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
[4120922.907220]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.910680]  [<ffffffff81646118>] ret_from_fork+0x58/0x90
[4120922.913985]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[4120922.917758] INFO: task xfs_db:15150 blocked for more than 120 seconds.
[4120922.922778] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[4120922.928450] xfs_db          D ffff8801ed87cb00     0 15150  15149
0x00000080
[4120922.932936]  ffff88003fc3fd48 0000000000000086 ffff8801f0cf1700
ffff88003fc3ffd8
[4120922.937513]  ffff88003fc3ffd8 ffff88003fc3ffd8 ffff8801f0cf1700
ffff880035f1b128
[4120922.942401]  ffff8801f0cf1700 0000000000000000 ffff880035f1b000
ffff8801ed87cb00
[4120922.946982] Call Trace:
[4120922.949242]  [<ffffffff8163b139>] schedule+0x29/0x70
[4120922.952840]  [<ffffffffa0159842>] _xfs_log_force+0x192/0x290 [xfs]
[4120922.957966]  [<ffffffff810b88d0>] ? wake_up_state+0x20/0x20
[4120922.962437]  [<ffffffffa0159966>] xfs_log_force+0x26/0x80 [xfs]
[4120922.965795]  [<ffffffffa01510ad>] xfs_fs_sync_fs+0x2d/0x50 [xfs]
[4120922.969715]  [<ffffffff8120fcf2>] sync_filesystem+0x72/0xa0
[4120922.973197]  [<ffffffff8121a344>] fsync_bdev+0x24/0x60
[4120922.976962]  [<ffffffff812d937b>] blkdev_ioctl+0x3bb/0x760
[4120922.980871]  [<ffffffff812199a1>] block_ioctl+0x41/0x50
[4120922.984190]  [<ffffffff811f2175>] do_vfs_ioctl+0x2e5/0x4c0
[4120922.987944]  [<ffffffff8128c01e>] ? file_has_perm+0xae/0xc0
[4120922.991108]  [<ffffffff811f23f1>] SyS_ioctl+0xa1/0xc0
[4120922.994021]  [<ffffffff816461c9>] system_call_fastpath+0x16/0x1b


--------------
Kernel version
--------------
Linux version 3.10.0-327.18.2.el7.x86_64 (builder@kbuilder.dev.centos.org)
(gcc version 4.8.3 20140911 (Red Hat 4.8.3-9) (GCC) ) #1 SMP Thu May 12
11:03
:55 UTC 2016


----------------
xfsprogs version
----------------
xfs_repair version 3.2.2


--------------
number of CPUs
--------------
 #  cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 63
model name      : Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
stepping        : 2
microcode       : 0x25
cpu MHz         : 2400.088
cache size      : 30720 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm
constant_tsc rep_good nopl xtopology eagerfpu pni pclmulqdq ssse3 fma cx16
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
f16c rdrand hypervisor lahf_lm abm fsgsbase bmi1 avx2 smep bmi2 erms
invpcid xsaveopt
bogomips        : 4800.17
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 63
model name      : Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
stepping        : 2
microcode       : 0x25
cpu MHz         : 2400.088
cache size      : 30720 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm
constant_tsc rep_good nopl xtopology eagerfpu pni pclmulqdq ssse3 fma cx16
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
f16c rdrand hypervisor lahf_lm abm fsgsbase bmi1 avx2 smep bmi2 erms
invpcid xsaveopt
bogomips        : 4800.17
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:


-------------------------
contents of /proc/meminfo
-------------------------
 #  cat /proc/meminfo
MemTotal:        7747768 kB
MemFree:         5771240 kB
MemAvailable:    6161328 kB
Buffers:             460 kB
Cached:           559916 kB
SwapCached:            0 kB
Active:          1459048 kB
Inactive:         314992 kB
Active(anon):    1217424 kB
Inactive(anon):    17100 kB
Active(file):     241624 kB
Inactive(file):   297892 kB
Unevictable:        8644 kB
Mlocked:            8644 kB
SwapTotal:       8388604 kB
SwapFree:        8388604 kB
Dirty:              1536 kB
Writeback:             0 kB
AnonPages:       1222356 kB
Mapped:            47524 kB
Shmem:             17264 kB
Slab:              70744 kB
SReclaimable:      39000 kB
SUnreclaim:        31744 kB
KernelStack:        5616 kB
PageTables:         8696 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    12262488 kB
Committed_AS:    3412392 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       27068 kB
VmallocChunk:   34359697144 kB
HardwareCorrupted:     0 kB
AnonHugePages:   1040384 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       75776 kB
DirectMap2M:     8312832 kB


------------------------
contents of /proc/mounts
------------------------
 #  cat /proc/mounts
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs
rw,seclabel,nosuid,size=3986336k,nr_inodes=996584,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime
0 0
tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0
devpts /dev/pts devpts
rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs ro,seclabel,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup
rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd
0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup
rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/devices cgroup
rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup
rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/hugetlb cgroup
rw,nosuid,nodev,noexec,relatime,hugetlb 0 0
cgroup /sys/fs/cgroup/net_cls cgroup
rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset
0 0
cgroup /sys/fs/cgroup/perf_event cgroup
rw,nosuid,nodev,noexec,relatime,perf_event 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory
0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
/dev/xvda1 / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs
rw,relatime,fd=25,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,seclabel,relatime 0 0
mqueue /dev/mqueue mqueue rw,seclabel,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
/dev/xvdb1 /opt xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
tmpfs /run/user/0 tmpfs
rw,seclabel,nosuid,nodev,relatime,size=774780k,mode=700 0 0


----------------------------
contents of /proc/partitions
----------------------------
 #  cat /proc/partitions
major minor  #blocks  name

 202        0   16777216 xvda
 202        1   16770836 xvda1
 202       16 2147483648 xvdb
 202       17 2147483616 xvdb1


--------------------------------------
RAID layout (hardware and/or software)
--------------------------------------
N/A


-----------------
LVM configuration
-----------------
N/A


---------------------------
type of disks you are using
---------------------------
Amazon Elastic Block Storage - General Purpose SSD


----------------------------
write cache status of drives
----------------------------
N/A


--------------------------------------
size of BBWC and mode it is running in
--------------------------------------
N/A


---------------------------------------------
xfs_info output on the filesystem in question
---------------------------------------------
 #  xfs_info /dev/xvdb1
meta-data=/dev/xvdb1             isize=256    agcount=8, agsize=67108862
blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=536870896, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=131071, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


--------------------------------
dmesg output (/var/log/messages)
--------------------------------
Note, I know that the messages below refer to the XVDA1 drive and not the
XVDB1 drive whose filesystem had hung.

Jul 18 09:19:29 ip-172-31-18-53 kernel: XFS (xvda1): Metadata corruption
detected at xfs_attr3_leaf_read_verify+0x5e/0x110 [xfs], block 0x14277a0
Jul 18 09:19:29 ip-172-31-18-53 kernel: XFS (xvda1): Unmount and run
xfs_repair
Jul 18 09:19:29 ip-172-31-18-53 kernel: XFS (xvda1): First 64 bytes of
corrupted metadata buffer:
Jul 18 09:19:29 ip-172-31-18-53 kernel: ffff8801f01a9000: 31 34 33 34 39 38
31 34 33 32 34 39 33 30 3d 31  14349814324930=1
Jul 18 09:19:29 ip-172-31-18-53 kernel: ffff8801f01a9010: 34 36 38 36 36 37
37 35 33 0a 31 34 33 34 39 38  468667753.143498
Jul 18 09:19:29 ip-172-31-18-53 kernel: ffff8801f01a9020: 31 34 32 38 34 37
30 37 3d 31 34 36 38 36 36 36  14284707=1468666
Jul 18 09:19:29 ip-172-31-18-53 kernel: ffff8801f01a9030: 38 32 32 0a 00 00
00 00 00 00 00 00 00 00 00 00  822.............
Jul 18 09:19:29 ip-172-31-18-53 kernel: XFS (xvda1): metadata I/O error:
block 0x14277a0 ("xfs_trans_read_buf_map") error 117 numblks 8
Jul 18 09:19:29 ip-172-31-18-53 kernel: SELinux: inode_doinit_with_dentry:
 getxattr returned 117 for dev=xvda1 ino=42271394
Jul 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): Metadata corruption
detected at xfs_da3_node_read_verify+0x5f/0x150 [xfs], block 0x14277a0
Jul 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): Unmount and run
xfs_repair
Jul 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): First 64 bytes of
corrupted metadata buffer:
Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f0139000: 31 34 33 34 39 38
31 34 33 32 34 39 33 30 3d 31  14349814324930=1
Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f0139010: 34 36 38 36 36 37
37 35 33 0a 31 34 33 34 39 38  468667753.143498
Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f0139020: 31 34 32 38 34 37
30 37 3d 31 34 36 38 36 36 36  14284707=1468666
Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f0139030: 38 32 32 0a 00 00
00 00 00 00 00 00 00 00 00 00  822.............
Jul 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): Metadata corruption
detected at xfs_attr3_leaf_read_verify+0x5e/0x110 [xfs], block 0x1b0
Jul 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): Unmount and run
xfs_repair
Jul 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): First 64 bytes of
corrupted metadata buffer:
Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f013b000: 3c 3f 78 6d 6c 20
76 65 72 73 69 6f 6e 3d 22 31  <?xml version="1
Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f013b010: 2e 30 22 20 65 6e
63 6f 64 69 6e 67 3d 22 55 54  .0" encoding="UT
Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f013b020: 46 2d 38 22 3f 3e
0a 3c 72 65 70 6f 6d 64 20 78  F-8"?>.<repomd x
Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f013b030: 6d 6c 6e 73 3d 22
68 74 74 70 3a 2f 2f 6c 69 6e  mlns="http://lin
Jul 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): metadata I/O error:
block 0x1b0 ("xfs_trans_read_buf_map") error 117 numblks 8
Jul 18 09:19:30 ip-172-31-18-53 kernel: SELinux: inode_doinit_with_dentry:
 getxattr returned 117 for dev=xvda1 ino=2943
Jul 18 09:19:31 ip-172-31-18-53 kernel: XFS (xvda1): Metadata corruption
detected at xfs_da3_node_read_verify+0x5f/0x150 [xfs], block 0x1b0
Jul 18 09:19:31 ip-172-31-18-53 kernel: XFS (xvda1): Unmount and run
xfs_repair
Jul 18 09:19:31 ip-172-31-18-53 kernel: XFS (xvda1): First 64 bytes of
corrupted metadata buffer:
Jul 18 09:19:31 ip-172-31-18-53 kernel: ffff8800e91fc000: 3c 3f 78 6d 6c 20
76 65 72 73 69 6f 6e 3d 22 31  <?xml version="1
Jul 18 09:19:31 ip-172-31-18-53 kernel: ffff8800e91fc010: 2e 30 22 20 65 6e
63 6f 64 69 6e 67 3d 22 55 54  .0" encoding="UT
Jul 18 09:19:31 ip-172-31-18-53 kernel: ffff8800e91fc020: 46 2d 38 22 3f 3e
0a 3c 72 65 70 6f 6d 64 20 78  F-8"?>.<repomd x
Jul 18 09:19:31 ip-172-31-18-53 kernel: ffff8800e91fc030: 6d 6c 6e 73 3d 22
68 74 74 70 3a 2f 2f 6c 69 6e  mlns="http://lin


-------------------------------------------
Running xfs_repair on the /dev/xvdb1 volume
-------------------------------------------
#  xfs_repair /dev/xvdb1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done


At the moment, I can't run xfs_repair on the XVDA1 file system since its an
AWS EC2 root EBS volume with market codes on it and I can't mount it as a
secondary disk in another instance to run xfs_repair on it.

--001a113ce4dc12838f0537e6442b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>We recently experienced a kernel hang on a Cent=
Os Linux 7.2.1511 server which<br>was operating as a Nexus artefacts reposi=
tory.<br><br>I believe the hang is file system related and am looking for a=
ssistance in<br>diagnosing the root cause of the issue and whether there is=
 a resolution for<br>it.<br><br>I am unable to reproduce the hang. It has o=
nly happened once so far.<br>The server is operating properly at the moment=
.<br><br>Below are the requested details in the XFS FAQ for reporting probl=
ems and if<br>any further information is required, please ask.<br><br>TIA a=
nd regards,<br>Jinesh<br><br><br>---------------------------------------<br=
>console output when the server was hung<br>-------------------------------=
--------<br>[4120921.739069] INFO: task kthreadd:2 blocked for more than 12=
0 seconds.<br>[4120921.744848] &quot;echo 0 &gt; /proc/sys/kernel/hung_task=
_timeout_secs&quot; disables this message.<br>[4120921.751254] kthreadd =C2=
=A0 =C2=A0 =C2=A0 =C2=A0D ffffffffffffffff =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 2 =
=C2=A0 =C2=A0 =C2=A00 0x00000000<br>[4120921.757324] =C2=A0ffff8802041734e0=
 0000000000000046 ffff8802040f0b80 ffff880204173fd8<br>[4120921.763417] =C2=
=A0ffff880204173fd8 ffff880204173fd8 ffff8802040f0b80 ffff880204173628<br>[=
4120921.769465] =C2=A0ffff880204173630 7fffffffffffffff ffff8802040f0b80 ff=
ffffffffffffff<br>[4120921.775993] Call Trace:<br>[4120921.780164] =C2=A0[&=
lt;ffffffff8163b139&gt;] schedule+0x29/0x70<br>[4120921.784900] =C2=A0[&lt;=
ffffffff81638e29&gt;] schedule_timeout+0x209/0x2d0<br>[4120921.790127] =C2=
=A0[&lt;ffffffff810b5df9&gt;] ? ttwu_do_wakeup+0x19/0xd0<br>[4120921.796310=
] =C2=A0[&lt;ffffffff810b5f8d&gt;] ? ttwu_do_activate.constprop.84+0x5d/0x7=
0<br>[4120921.801870] =C2=A0[&lt;ffffffff810b8726&gt;] ? try_to_wake_up+0x1=
b6/0x300<br>[4120921.806965] =C2=A0[&lt;ffffffff8163b506&gt;] wait_for_comp=
letion+0x116/0x170<br>[4120921.811843] =C2=A0[&lt;ffffffff810b88d0&gt;] ? w=
ake_up_state+0x20/0x20<br>[4120921.816596] =C2=A0[&lt;ffffffff8109e7ac&gt;]=
 flush_work+0xfc/0x1c0<br>[4120921.821211] =C2=A0[&lt;ffffffff8109a7e0&gt;]=
 ? move_linked_works+0x90/0x90<br>[4120921.826269] =C2=A0[&lt;ffffffffa015b=
43a&gt;] xlog_cil_force_lsn+0x8a/0x210 [xfs]<br>[4120921.831431] =C2=A0[&lt=
;ffffffffa0159a7e&gt;] _xfs_log_force_lsn+0x6e/0x2f0 [xfs]<br>[4120921.8366=
99] =C2=A0[&lt;ffffffff816322f5&gt;] ? __slab_free+0x10e/0x277<br>[4120921.=
841314] =C2=A0[&lt;ffffffffa0159d2e&gt;] xfs_log_force_lsn+0x2e/0x90 [xfs]<=
br>[4120921.846290] =C2=A0[&lt;ffffffffa014bfc9&gt;] ? xfs_iunpin_wait+0x19=
/0x20 [xfs]<br>[4120921.851084] =C2=A0[&lt;ffffffffa01484b7&gt;] __xfs_iunp=
in_wait+0xa7/0x150 [xfs]<br>[4120921.855634] =C2=A0[&lt;ffffffff810a6b60&gt=
;] ? wake_atomic_t_function+0x40/0x40<br>[4120921.860379] =C2=A0[&lt;ffffff=
ffa014bfc9&gt;] xfs_iunpin_wait+0x19/0x20 [xfs]<br>[4120921.864993] =C2=A0[=
&lt;ffffffffa014084c&gt;] xfs_reclaim_inode+0x8c/0x350 [xfs]<br>[4120921.86=
9706] =C2=A0[&lt;ffffffffa0140d77&gt;] xfs_reclaim_inodes_ag+0x267/0x390 [x=
fs]<br>[4120921.874552] =C2=A0[&lt;ffffffff810b5f8d&gt;] ? ttwu_do_activate=
.constprop.84+0x5d/0x70<br>[4120921.879503] =C2=A0[&lt;ffffffff810b8726&gt;=
] ? try_to_wake_up+0x1b6/0x300<br>[4120921.883890] =C2=A0[&lt;ffffffff810b8=
893&gt;] ? wake_up_process+0x23/0x40<br>[4120921.888214] =C2=A0[&lt;fffffff=
fa0141923&gt;] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]<br>[4120921.892889] =
=C2=A0[&lt;ffffffffa0150895&gt;] xfs_fs_free_cached_objects+0x15/0x20 [xfs]=
<br>[4120921.897710] =C2=A0[&lt;ffffffff811e0ea8&gt;] prune_super+0xe8/0x17=
0<br>[4120921.901538] =C2=A0[&lt;ffffffff8117c795&gt;] shrink_slab+0x165/0x=
300<br>[4120921.905558] =C2=A0[&lt;ffffffff811d60d1&gt;] ? vmpressure+0x21/=
0x90<br>[4120921.909477] =C2=A0[&lt;ffffffff8117f912&gt;] do_try_to_free_pa=
ges+0x3c2/0x4e0<br>[4120921.913752] =C2=A0[&lt;ffffffff8117fb2c&gt;] try_to=
_free_pages+0xfc/0x180<br>[4120921.917891] =C2=A0[&lt;ffffffff8117382d&gt;]=
 __alloc_pages_nodemask+0x7fd/0xb90<br>[4120921.922224] =C2=A0[&lt;ffffffff=
81078d73&gt;] copy_process.part.25+0x163/0x1610<br>[4120921.926508] =C2=A0[=
&lt;ffffffff810c226e&gt;] ? dequeue_task_fair+0x42e/0x640<br>[4120921.93058=
1] =C2=A0[&lt;ffffffff810a5a20&gt;] ? kthread_create_on_node+0x140/0x140<br=
>[4120921.934837] =C2=A0[&lt;ffffffff8107a401&gt;] do_fork+0xe1/0x320<br>[4=
120921.938364] =C2=A0[&lt;ffffffff8107a666&gt;] kernel_thread+0x26/0x30<br>=
[4120921.942056] =C2=A0[&lt;ffffffff810a65f2&gt;] kthreadd+0x2b2/0x2f0<br>[=
4120921.945527] =C2=A0[&lt;ffffffff810a6340&gt;] ? kthread_create_on_cpu+0x=
60/0x60<br>[4120921.949393] =C2=A0[&lt;ffffffff81646118&gt;] ret_from_fork+=
0x58/0x90<br>[4120921.953247] =C2=A0[&lt;ffffffff810a6340&gt;] ? kthread_cr=
eate_on_cpu+0x60/0x60<br>[4120921.957337] INFO: task kswapd0:63 blocked for=
 more than 120 seconds.<br>[4120921.961229] &quot;echo 0 &gt; /proc/sys/ker=
nel/hung_task_timeout_secs&quot; disables this message.<br>[4120921.965814]=
 kswapd0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 D ffffffffffffffff =C2=A0 =C2=A0 0 =C2=
=A0 =C2=A063 =C2=A0 =C2=A0 =C2=A02 0x00000000<br>[4120921.970177] =C2=A0fff=
f8801edebf6f0 0000000000000046 ffff88020433c500 ffff8801edebffd8<br>[412092=
1.974816] =C2=A0ffff8801edebffd8 ffff8801edebffd8 ffff88020433c500 ffff8801=
edebf838<br>[4120921.979486] =C2=A0ffff8801edebf840 7fffffffffffffff ffff88=
020433c500 ffffffffffffffff<br>[4120921.984171] Call Trace:<br>[4120921.986=
327] =C2=A0[&lt;ffffffff8163b139&gt;] schedule+0x29/0x70<br>[4120921.989613=
] =C2=A0[&lt;ffffffff81638e29&gt;] schedule_timeout+0x209/0x2d0<br>[4120921=
.993136] =C2=A0[&lt;ffffffff810b5df9&gt;] ? ttwu_do_wakeup+0x19/0xd0<br>[41=
20921.996564] =C2=A0[&lt;ffffffff810b5f8d&gt;] ? ttwu_do_activate.constprop=
.84+0x5d/0x70<br>[4120922.000534] =C2=A0[&lt;ffffffff810b8726&gt;] ? try_to=
_wake_up+0x1b6/0x300<br>[4120922.004365] =C2=A0[&lt;ffffffff8163b506&gt;] w=
ait_for_completion+0x116/0x170<br>[4120922.008129] =C2=A0[&lt;ffffffff810b8=
8d0&gt;] ? wake_up_state+0x20/0x20<br>[4120922.011631] =C2=A0[&lt;ffffffff8=
109e7ac&gt;] flush_work+0xfc/0x1c0<br>[4120922.015008] =C2=A0[&lt;ffffffff8=
109a7e0&gt;] ? move_linked_works+0x90/0x90<br>[4120922.018747] =C2=A0[&lt;f=
fffffffa015b43a&gt;] xlog_cil_force_lsn+0x8a/0x210 [xfs]<br>[4120922.022623=
] =C2=A0[&lt;ffffffff81171abb&gt;] ? free_pcppages_bulk+0x34b/0x3a0<br>[412=
0922.026463] =C2=A0[&lt;ffffffffa0159a7e&gt;] _xfs_log_force_lsn+0x6e/0x2f0=
 [xfs]<br>[4120922.030559] =C2=A0[&lt;ffffffff816322f5&gt;] ? __slab_free+0=
x10e/0x277<br>[4120922.034123] =C2=A0[&lt;ffffffffa0159d2e&gt;] xfs_log_for=
ce_lsn+0x2e/0x90 [xfs]<br>[4120922.037986] =C2=A0[&lt;ffffffffa014bfc9&gt;]=
 ? xfs_iunpin_wait+0x19/0x20 [xfs]<br>[4120922.041840] =C2=A0[&lt;ffffffffa=
01484b7&gt;] __xfs_iunpin_wait+0xa7/0x150 [xfs]<br>[4120922.045748] =C2=A0[=
&lt;ffffffff810a6b60&gt;] ? wake_atomic_t_function+0x40/0x40<br>[4120922.04=
9556] =C2=A0[&lt;ffffffffa014bfc9&gt;] xfs_iunpin_wait+0x19/0x20 [xfs]<br>[=
4120922.053515] =C2=A0[&lt;ffffffffa014084c&gt;] xfs_reclaim_inode+0x8c/0x3=
50 [xfs]<br>[4120922.057429] =C2=A0[&lt;ffffffffa0140d77&gt;] xfs_reclaim_i=
nodes_ag+0x267/0x390 [xfs]<br>[4120922.061637] =C2=A0[&lt;ffffffffa0141923&=
gt;] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]<br>[4120922.065723] =C2=A0[&lt;f=
fffffffa0150895&gt;] xfs_fs_free_cached_objects+0x15/0x20 [xfs]<br>[4120922=
.069902] =C2=A0[&lt;ffffffff811e0ea8&gt;] prune_super+0xe8/0x170<br>[412092=
2.073288] =C2=A0[&lt;ffffffff8117c795&gt;] shrink_slab+0x165/0x300<br>[4120=
922.076715] =C2=A0[&lt;ffffffff811d6111&gt;] ? vmpressure+0x61/0x90<br>[412=
0922.080154] =C2=A0[&lt;ffffffff81180401&gt;] balance_pgdat+0x4b1/0x5e0<br>=
[4120922.083522] =C2=A0[&lt;ffffffff811806a3&gt;] kswapd+0x173/0x450<br>[41=
20922.086630] =C2=A0[&lt;ffffffff810a6ae0&gt;] ? wake_up_atomic_t+0x30/0x30=
<br>[4120922.090186] =C2=A0[&lt;ffffffff81180530&gt;] ? balance_pgdat+0x5e0=
/0x5e0<br>[4120922.093399] =C2=A0[&lt;ffffffff810a5aef&gt;] kthread+0xcf/0x=
e0<br>[4120922.096164] =C2=A0[&lt;ffffffff810a5a20&gt;] ? kthread_create_on=
_node+0x140/0x140<br>[4120922.102513] =C2=A0[&lt;ffffffff81646118&gt;] ret_=
from_fork+0x58/0x90<br>[4120922.105472] =C2=A0[&lt;ffffffff810a5a20&gt;] ? =
kthread_create_on_node+0x140/0x140<br>[4120922.108855] INFO: task xfsaild/x=
vdb1:499 blocked for more than 120 seconds.<br>[4120922.112411] &quot;echo =
0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables this message.=
<br>[4120922.116496] xfsaild/xvdb1 =C2=A0 D ffffffffffffffff =C2=A0 =C2=A0 =
0 =C2=A0 499 =C2=A0 =C2=A0 =C2=A02 0x00000000<br>[4120922.120931] =C2=A0fff=
f8801ec897a80 0000000000000046 ffff8801ed827300 ffff8801ec897fd8<br>[412092=
2.126370] =C2=A0ffff8801ec897fd8 ffff8801ec897fd8 ffff8801ed827300 ffff8801=
ec897bd0<br>[4120922.131959] =C2=A0ffff8801ec897bd8 7fffffffffffffff ffff88=
01ed827300 ffffffffffffffff<br>[4120922.137824] Call Trace:<br>[4120922.140=
429] =C2=A0[&lt;ffffffff8163b139&gt;] schedule+0x29/0x70<br>[4120922.144426=
] =C2=A0[&lt;ffffffff81638e29&gt;] schedule_timeout+0x209/0x2d0<br>[4120922=
.148294] =C2=A0[&lt;ffffffff81009ee0&gt;] ? xen_clocksource_read+0x20/0x30<=
br>[4120922.152181] =C2=A0[&lt;ffffffff8101cd69&gt;] ? sched_clock+0x9/0x10=
<br>[4120922.155625] =C2=A0[&lt;ffffffff812d0876&gt;] ? __blk_segment_map_s=
g+0x56/0x1b0<br>[4120922.159579] =C2=A0[&lt;ffffffff810b8726&gt;] ? try_to_=
wake_up+0x1b6/0x300<br>[4120922.163346] =C2=A0[&lt;ffffffff8163b506&gt;] wa=
it_for_completion+0x116/0x170<br>[4120922.166567] =C2=A0[&lt;ffffffff810b88=
d0&gt;] ? wake_up_state+0x20/0x20<br>[4120922.169550] =C2=A0[&lt;ffffffff81=
09e7ac&gt;] flush_work+0xfc/0x1c0<br>[4120922.172533] =C2=A0[&lt;ffffffff81=
09a7e0&gt;] ? move_linked_works+0x90/0x90<br>[4120922.175723] =C2=A0[&lt;ff=
ffffffa015b43a&gt;] xlog_cil_force_lsn+0x8a/0x210 [xfs]<br>[4120922.179179]=
 =C2=A0[&lt;ffffffffa0138d1c&gt;] ? xfs_buf_read_map+0x2c/0x140 [xfs]<br>[4=
120922.183095] =C2=A0[&lt;ffffffffa0159720&gt;] _xfs_log_force+0x70/0x290 [=
xfs]<br>[4120922.186887] =C2=A0[&lt;ffffffffa0159966&gt;] xfs_log_force+0x2=
6/0x80 [xfs]<br>[4120922.190574] =C2=A0[&lt;ffffffffa014ce8a&gt;] xfs_iflus=
h+0x22a/0x240 [xfs]<br>[4120922.194204] =C2=A0[&lt;ffffffffa015d76e&gt;] xf=
s_inode_item_push+0xee/0x150 [xfs]<br>[4120922.198158] =C2=A0[&lt;ffffffffa=
0164470&gt;] ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]<br>[4120922.20217=
4] =C2=A0[&lt;ffffffffa0164771&gt;] xfsaild+0x301/0x5e0 [xfs]<br>[4120922.2=
05486] =C2=A0[&lt;ffffffffa0164470&gt;] ? xfs_trans_ail_cursor_first+0x90/0=
x90 [xfs]<br>[4120922.209462] =C2=A0[&lt;ffffffff810a5aef&gt;] kthread+0xcf=
/0xe0<br>[4120922.213098] =C2=A0[&lt;ffffffff810a5a20&gt;] ? kthread_create=
_on_node+0x140/0x140<br>[4120922.217013] =C2=A0[&lt;ffffffff81646118&gt;] r=
et_from_fork+0x58/0x90<br>[4120922.220426] =C2=A0[&lt;ffffffff810a5a20&gt;]=
 ? kthread_create_on_node+0x140/0x140<br>[4120922.224358] INFO: task kworke=
r/1:0H:3437 blocked for more than 120 seconds.<br>[4120922.228432] &quot;ec=
ho 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables this messa=
ge.<br>[4120922.232937] kworker/1:0H =C2=A0 =C2=A0D ffffffffffffffff =C2=A0=
 =C2=A0 0 =C2=A03437 =C2=A0 =C2=A0 =C2=A02 0x00000080<br>[4120922.237282] W=
orkqueue: xfs-log/xvdb1 xfs_log_worker [xfs]<br>[4120922.240825] =C2=A0ffff=
8800d287bb30 0000000000000046 ffff880119b18b80 ffff8800d287bfd8<br>[4120922=
.245511] =C2=A0ffff8800d287bfd8 ffff8800d287bfd8 ffff880119b18b80 ffff8800d=
287bc78<br>[4120922.250044] =C2=A0ffff8800d287bc80 7fffffffffffffff ffff880=
119b18b80 ffffffffffffffff<br>[4120922.255485] Call Trace:<br>[4120922.2606=
78] =C2=A0[&lt;ffffffff8163b139&gt;] schedule+0x29/0x70<br>[4120922.266190]=
 =C2=A0[&lt;ffffffff81638e29&gt;] schedule_timeout+0x209/0x2d0<br>[4120922.=
269977] =C2=A0[&lt;ffffffff810b5dc5&gt;] ? check_preempt_curr+0x85/0xa0<br>=
[4120922.274092] =C2=A0[&lt;ffffffff810b5df9&gt;] ? ttwu_do_wakeup+0x19/0xd=
0<br>[4120922.279267] =C2=A0[&lt;ffffffff810b8726&gt;] ? try_to_wake_up+0x1=
b6/0x300<br>[4120922.284441] =C2=A0[&lt;ffffffff8163b506&gt;] wait_for_comp=
letion+0x116/0x170<br>[4120922.298485] =C2=A0[&lt;ffffffff810b88d0&gt;] ? w=
ake_up_state+0x20/0x20<br>[4120922.302237] =C2=A0[&lt;ffffffff8109e7ac&gt;]=
 flush_work+0xfc/0x1c0<br>[4120922.305656] =C2=A0[&lt;ffffffff8109a7e0&gt;]=
 ? move_linked_works+0x90/0x90<br>[4120922.309291] =C2=A0[&lt;ffffffffa015b=
43a&gt;] xlog_cil_force_lsn+0x8a/0x210 [xfs]<br>[4120922.313239] =C2=A0[&lt=
;ffffffff810c1a26&gt;] ? dequeue_entity+0x106/0x520<br>[4120922.317172] =C2=
=A0[&lt;ffffffffa0159720&gt;] _xfs_log_force+0x70/0x290 [xfs]<br>[4120922.3=
21545] =C2=A0[&lt;ffffffff810c226e&gt;] ? dequeue_task_fair+0x42e/0x640<br>=
[4120922.326162] =C2=A0[&lt;ffffffff810bb768&gt;] ? sched_clock_cpu+0x98/0x=
c0<br>[4120922.330583] =C2=A0[&lt;ffffffff81013588&gt;] ? __switch_to+0xf8/=
0x4b0<br>[4120922.334868] =C2=A0[&lt;ffffffffa0159966&gt;] xfs_log_force+0x=
26/0x80 [xfs]<br>[4120922.339370] =C2=A0[&lt;ffffffffa01599e4&gt;] xfs_log_=
worker+0x24/0x50 [xfs]<br>[4120922.343136] =C2=A0[&lt;ffffffff8109d5fb&gt;]=
 process_one_work+0x17b/0x470<br>[4120922.347247] =C2=A0[&lt;ffffffff8109e3=
cb&gt;] worker_thread+0x11b/0x400<br>[4120922.350965] =C2=A0[&lt;ffffffff81=
09e2b0&gt;] ? rescuer_thread+0x400/0x400<br>[4120922.354513] =C2=A0[&lt;fff=
fffff810a5aef&gt;] kthread+0xcf/0xe0<br>[4120922.357578] =C2=A0[&lt;fffffff=
f810a5a20&gt;] ? kthread_create_on_node+0x140/0x140<br>[4120922.369011] =C2=
=A0[&lt;ffffffff81646118&gt;] ret_from_fork+0x58/0x90<br>[4120922.373843] =
=C2=A0[&lt;ffffffff810a5a20&gt;] ? kthread_create_on_node+0x140/0x140<br>[4=
120922.379463] INFO: task kworker/u30:2:14068 blocked for more than 120 sec=
onds.<br>[4120922.384006] &quot;echo 0 &gt; /proc/sys/kernel/hung_task_time=
out_secs&quot; disables this message.<br>[4120922.387872] kworker/u30:2 =C2=
=A0 D ffffffffffffffff =C2=A0 =C2=A0 0 14068 =C2=A0 =C2=A0 =C2=A02 0x000000=
80<br>[4120922.391575] Workqueue: writeback bdi_writeback_workfn (flush-202=
:16)<br>[4120922.395090] =C2=A0ffff8800630e7210 0000000000000046 ffff8800c1=
1f6780 ffff8800630e7fd8<br>[4120922.399023] =C2=A0ffff8800630e7fd8 ffff8800=
630e7fd8 ffff8800c11f6780 ffff8800630e7360<br>[4120922.402933] =C2=A0ffff88=
00630e7368 7fffffffffffffff ffff8800c11f6780 ffffffffffffffff<br>[4120922.4=
06926] Call Trace:<br>[4120922.408912] =C2=A0[&lt;ffffffff8163b139&gt;] sch=
edule+0x29/0x70<br>[4120922.411795] =C2=A0[&lt;ffffffff81638e29&gt;] schedu=
le_timeout+0x209/0x2d0<br>[4120922.415046] =C2=A0[&lt;ffffffff810b5df9&gt;]=
 ? ttwu_do_wakeup+0x19/0xd0<br>[4120922.418146] =C2=A0[&lt;ffffffff810b5f8d=
&gt;] ? ttwu_do_activate.constprop.84+0x5d/0x70<br>[4120922.421720] =C2=A0[=
&lt;ffffffff810b8726&gt;] ? try_to_wake_up+0x1b6/0x300<br>[4120922.425018] =
=C2=A0[&lt;ffffffff8163b506&gt;] wait_for_completion+0x116/0x170<br>[412092=
2.428241] =C2=A0[&lt;ffffffff810b88d0&gt;] ? wake_up_state+0x20/0x20<br>[41=
20922.431397] =C2=A0[&lt;ffffffff8109e7ac&gt;] flush_work+0xfc/0x1c0<br>[41=
20922.434393] =C2=A0[&lt;ffffffff8109a7e0&gt;] ? move_linked_works+0x90/0x9=
0<br>[4120922.437597] =C2=A0[&lt;ffffffffa015b43a&gt;] xlog_cil_force_lsn+0=
x8a/0x210 [xfs]<br>[4120922.441499] =C2=A0[&lt;ffffffffa0156127&gt;] ? kmem=
_zone_alloc+0x77/0x100 [xfs]<br>[4120922.445773] =C2=A0[&lt;ffffffffa015972=
0&gt;] _xfs_log_force+0x70/0x290 [xfs]<br>[4120922.449958] =C2=A0[&lt;fffff=
fffa0137b60&gt;] ? xfs_buf_rele+0x40/0x100 [xfs]<br>[4120922.453640] =C2=A0=
[&lt;ffffffffa0159966&gt;] xfs_log_force+0x26/0x80 [xfs]<br>[4120922.457413=
] =C2=A0[&lt;ffffffffa00fa29f&gt;] xfs_alloc_ag_vextent_near+0x36f/0xa60 [x=
fs]<br>[4120922.461804] =C2=A0[&lt;ffffffffa00fb20d&gt;] xfs_alloc_ag_vexte=
nt+0xcd/0x110 [xfs]<br>[4120922.465858] =C2=A0[&lt;ffffffffa00fbf89&gt;] xf=
s_alloc_vextent+0x429/0x5e0 [xfs]<br>[4120922.469691] =C2=A0[&lt;ffffffffa0=
10c37f&gt;] xfs_bmap_btalloc+0x3af/0x710 [xfs]<br>[4120922.473465] =C2=A0[&=
lt;ffffffffa010c6ee&gt;] xfs_bmap_alloc+0xe/0x10 [xfs]<br>[4120922.477311] =
=C2=A0[&lt;ffffffffa010d148&gt;] xfs_bmapi_write+0x4d8/0xa90 [xfs]<br>[4120=
922.480941] =C2=A0[&lt;ffffffffa0145c9b&gt;] xfs_iomap_write_allocate+0x14b=
/0x350 [xfs]<br>[4120922.485629] =C2=A0[&lt;ffffffffa0130dc6&gt;] xfs_map_b=
locks+0x1c6/0x230 [xfs]<br>[4120922.489841] =C2=A0[&lt;ffffffffa0131fe3&gt;=
] xfs_vm_writepage+0x193/0x5d0 [xfs]<br>[4120922.500558] =C2=A0[&lt;fffffff=
f81173d33&gt;] __writepage+0x13/0x50<br>[4120922.506407] =C2=A0[&lt;fffffff=
f81174851&gt;] write_cache_pages+0x251/0x4d0<br>[4120922.512752] =C2=A0[&lt=
;ffffffff81173d20&gt;] ? global_dirtyable_memory+0x70/0x70<br>[4120922.5173=
34] =C2=A0[&lt;ffffffff81174b1d&gt;] generic_writepages+0x4d/0x80<br>[41209=
22.522017] =C2=A0[&lt;ffffffffa0131993&gt;] xfs_vm_writepages+0x43/0x50 [xf=
s]<br>[4120922.526214] =C2=A0[&lt;ffffffff81175bce&gt;] do_writepages+0x1e/=
0x40<br>[4120922.530955] =C2=A0[&lt;ffffffff812086b0&gt;] __writeback_singl=
e_inode+0x40/0x220<br>[4120922.536643] =C2=A0[&lt;ffffffff8120911e&gt;] wri=
teback_sb_inodes+0x25e/0x420<br>[4120922.542013] =C2=A0[&lt;ffffffff8120937=
f&gt;] __writeback_inodes_wb+0x9f/0xd0<br>[4120922.547375] =C2=A0[&lt;fffff=
fff81209bc3&gt;] wb_writeback+0x263/0x2f0<br>[4120922.552294] =C2=A0[&lt;ff=
ffffff811f89dc&gt;] ? get_nr_inodes+0x4c/0x70<br>[4120922.557162] =C2=A0[&l=
t;ffffffff8120be4b&gt;] bdi_writeback_workfn+0x2cb/0x460<br>[4120922.562484=
] =C2=A0[&lt;ffffffff8109d5fb&gt;] process_one_work+0x17b/0x470<br>[4120922=
.567628] =C2=A0[&lt;ffffffff8109e3cb&gt;] worker_thread+0x11b/0x400<br>[412=
0922.572471] =C2=A0[&lt;ffffffff8109e2b0&gt;] ? rescuer_thread+0x400/0x400<=
br>[4120922.577574] =C2=A0[&lt;ffffffff810a5aef&gt;] kthread+0xcf/0xe0<br>[=
4120922.582063] =C2=A0[&lt;ffffffff810a5a20&gt;] ? kthread_create_on_node+0=
x140/0x140<br>[4120922.587646] =C2=A0[&lt;ffffffff81646118&gt;] ret_from_fo=
rk+0x58/0x90<br>[4120922.592440] =C2=A0[&lt;ffffffff810a5a20&gt;] ? kthread=
_create_on_node+0x140/0x140<br>[4120922.597920] INFO: task kworker/1:2H:149=
81 blocked for more than 120 seconds.<br>[4120922.603822] &quot;echo 0 &gt;=
 /proc/sys/kernel/hung_task_timeout_secs&quot; disables this message.<br>[4=
120922.610202] kworker/1:2H =C2=A0 =C2=A0D ffff88001d3e3dd8 =C2=A0 =C2=A0 0=
 14981 =C2=A0 =C2=A0 =C2=A02 0x00000080<br>[4120922.616222] =C2=A0ffff88001=
d3e3bf0 0000000000000046 ffff88005dbf9700 ffff88001d3e3fd8<br>[4120922.6227=
52] =C2=A0ffff88001d3e3fd8 ffff88001d3e3fd8 ffff88005dbf9700 ffff88001d3e3d=
58<br>[4120922.629212] =C2=A0ffff88001d3e3d60 7fffffffffffffff ffff88005dbf=
9700 ffff88001d3e3dd8<br>[4120922.635607] Call Trace:<br>[4120922.638373] =
=C2=A0[&lt;ffffffff8163b139&gt;] schedule+0x29/0x70<br>[4120922.642868] =C2=
=A0[&lt;ffffffff81638e29&gt;] schedule_timeout+0x209/0x2d0<br>[4120922.6479=
88] =C2=A0[&lt;ffffffff813a3c3b&gt;] ? xen_send_IPI_one+0x2b/0x30<br>[41209=
22.652966] =C2=A0[&lt;ffffffff81011ba0&gt;] ? xen_smp_send_reschedule+0x10/=
0x20<br>[4120922.658465] =C2=A0[&lt;ffffffff810b5128&gt;] ? resched_task+0x=
b8/0xd0<br>[4120922.663425] =C2=A0[&lt;ffffffff810b5db5&gt;] ? check_preemp=
t_curr+0x75/0xa0<br>[4120922.668687] =C2=A0[&lt;ffffffff810b5df9&gt;] ? ttw=
u_do_wakeup+0x19/0xd0<br>[4120922.673715] =C2=A0[&lt;ffffffff8163b506&gt;] =
wait_for_completion+0x116/0x170<br>[4120922.678970] =C2=A0[&lt;ffffffff810b=
88d0&gt;] ? wake_up_state+0x20/0x20<br>[4120922.683886] =C2=A0[&lt;ffffffff=
810a5988&gt;] kthread_create_on_node+0xa8/0x140<br>[4120922.689305] =C2=A0[=
&lt;ffffffff8109e2b0&gt;] ? rescuer_thread+0x400/0x400<br>[4120922.694460] =
=C2=A0[&lt;ffffffff8109d9da&gt;] create_worker+0xea/0x250<br>[4120922.69919=
4] =C2=A0[&lt;ffffffff8109dcd6&gt;] manage_workers.isra.24+0xf6/0x2d0<br>[4=
120922.704599] =C2=A0[&lt;ffffffff8109e5e9&gt;] worker_thread+0x339/0x400<b=
r>[4120922.709613] =C2=A0[&lt;ffffffff8109e2b0&gt;] ? rescuer_thread+0x400/=
0x400<br>[4120922.714725] =C2=A0[&lt;ffffffff810a5aef&gt;] kthread+0xcf/0xe=
0<br>[4120922.719205] =C2=A0[&lt;ffffffff810a5a20&gt;] ? kthread_create_on_=
node+0x140/0x140<br>[4120922.724918] =C2=A0[&lt;ffffffff81646118&gt;] ret_f=
rom_fork+0x58/0x90<br>[4120922.729775] =C2=A0[&lt;ffffffff810a5a20&gt;] ? k=
thread_create_on_node+0x140/0x140<br>[4120922.735513] INFO: task kworker/u3=
0:0:15076 blocked for more than 120 seconds.<br>[4120922.741555] &quot;echo=
 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables this message=
.<br>[4120922.747874] kworker/u30:0 =C2=A0 D ffff8800dc79fdd8 =C2=A0 =C2=A0=
 0 15076 =C2=A0 =C2=A0 =C2=A02 0x00000080<br>[4120922.753364] =C2=A0ffff880=
0dc79fbf0 0000000000000046 ffff88005dbfdc00 ffff8800dc79ffd8<br>[4120922.75=
8892] =C2=A0ffff8800dc79ffd8 ffff8800dc79ffd8 ffff88005dbfdc00 ffff8800dc79=
fd58<br>[4120922.763731] =C2=A0ffff8800dc79fd60 7fffffffffffffff ffff88005d=
bfdc00 ffff8800dc79fdd8<br>[4120922.768429] Call Trace:<br>[4120922.770718]=
 =C2=A0[&lt;ffffffff8163b139&gt;] schedule+0x29/0x70<br>[4120922.774272] =
=C2=A0[&lt;ffffffff81638e29&gt;] schedule_timeout+0x209/0x2d0<br>[4120922.7=
77813] =C2=A0[&lt;ffffffff810b5dc5&gt;] ? check_preempt_curr+0x85/0xa0<br>[=
4120922.781779] =C2=A0[&lt;ffffffff810b5df9&gt;] ? ttwu_do_wakeup+0x19/0xd0=
<br>[4120922.784985] =C2=A0[&lt;ffffffff8163b506&gt;] wait_for_completion+0=
x116/0x170<br>[4120922.788227] =C2=A0[&lt;ffffffff810b88d0&gt;] ? wake_up_s=
tate+0x20/0x20<br>[4120922.791261] =C2=A0[&lt;ffffffff810a5988&gt;] kthread=
_create_on_node+0xa8/0x140<br>[4120922.795287] =C2=A0[&lt;ffffffff8109e2b0&=
gt;] ? rescuer_thread+0x400/0x400<br>[4120922.798776] =C2=A0[&lt;ffffffff81=
09d9da&gt;] create_worker+0xea/0x250<br>[4120922.801800] =C2=A0[&lt;fffffff=
f8109dcd6&gt;] manage_workers.isra.24+0xf6/0x2d0<br>[4120922.805166] =C2=A0=
[&lt;ffffffff8109e5e9&gt;] worker_thread+0x339/0x400<br>[4120922.810183] =
=C2=A0[&lt;ffffffff8109e2b0&gt;] ? rescuer_thread+0x400/0x400<br>[4120922.8=
14169] =C2=A0[&lt;ffffffff810a5aef&gt;] kthread+0xcf/0xe0<br>[4120922.81728=
5] =C2=A0[&lt;ffffffff810a5a20&gt;] ? kthread_create_on_node+0x140/0x140<br=
>[4120922.821596] =C2=A0[&lt;ffffffff81646118&gt;] ret_from_fork+0x58/0x90<=
br>[4120922.825714] =C2=A0[&lt;ffffffff810a5a20&gt;] ? kthread_create_on_no=
de+0x140/0x140<br>[4120922.829190] INFO: task kworker/1:2:15134 blocked for=
 more than 120 seconds.<br>[4120922.832931] &quot;echo 0 &gt; /proc/sys/ker=
nel/hung_task_timeout_secs&quot; disables this message.<br>[4120922.836876]=
 kworker/1:2 =C2=A0 =C2=A0 D ffff880034f0d500 =C2=A0 =C2=A0 0 15134 =C2=A0 =
=C2=A0 =C2=A02 0x00000080<br>[4120922.842589] Workqueue: xfs-cil/xvdb1 xlog=
_cil_push_work [xfs]<br>[4120922.847416] =C2=A0ffff880075483be8 00000000000=
00046 ffff880034365080 ffff880075483fd8<br>[4120922.852258] =C2=A0ffff88007=
5483fd8 ffff880075483fd8 ffff880034365080 ffff880034f0d400<br>[4120922.8567=
52] =C2=A0ffff880034f0d528 ffff88013ca56170 ffff880034365080 ffff880034f0d5=
00<br>[4120922.860940] Call Trace:<br>[4120922.863004] =C2=A0[&lt;ffffffff8=
163b139&gt;] schedule+0x29/0x70<br>[4120922.867417] =C2=A0[&lt;ffffffffa015=
8b9c&gt;] xlog_state_get_iclog_space+0xec/0x2f0 [xfs]<br>[4120922.873230] =
=C2=A0[&lt;ffffffffa0158815&gt;] ? xlog_sync+0x285/0x430 [xfs]<br>[4120922.=
877108] =C2=A0[&lt;ffffffff810b88d0&gt;] ? wake_up_state+0x20/0x20<br>[4120=
922.880725] =C2=A0[&lt;ffffffffa0159077&gt;] xlog_write+0x1b7/0x700 [xfs]<b=
r>[4120922.884418] =C2=A0[&lt;ffffffffa015abd9&gt;] xlog_cil_push+0x239/0x4=
20 [xfs]<br>[4120922.887771] =C2=A0[&lt;ffffffffa015add5&gt;] xlog_cil_push=
_work+0x15/0x20 [xfs]<br>[4120922.891643] =C2=A0[&lt;ffffffff8109d5fb&gt;] =
process_one_work+0x17b/0x470<br>[4120922.896259] =C2=A0[&lt;ffffffff8109e54=
3&gt;] worker_thread+0x293/0x400<br>[4120922.900676] =C2=A0[&lt;ffffffff810=
9e2b0&gt;] ? rescuer_thread+0x400/0x400<br>[4120922.904386] =C2=A0[&lt;ffff=
ffff810a5aef&gt;] kthread+0xcf/0xe0<br>[4120922.907220] =C2=A0[&lt;ffffffff=
810a5a20&gt;] ? kthread_create_on_node+0x140/0x140<br>[4120922.910680] =C2=
=A0[&lt;ffffffff81646118&gt;] ret_from_fork+0x58/0x90<br>[4120922.913985] =
=C2=A0[&lt;ffffffff810a5a20&gt;] ? kthread_create_on_node+0x140/0x140<br>[4=
120922.917758] INFO: task xfs_db:15150 blocked for more than 120 seconds.<b=
r>[4120922.922778] &quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_sec=
s&quot; disables this message.<br>[4120922.928450] xfs_db =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0D ffff8801ed87cb00 =C2=A0 =C2=A0 0 15150 =C2=A015149 0x000=
00080<br>[4120922.932936] =C2=A0ffff88003fc3fd48 0000000000000086 ffff8801f=
0cf1700 ffff88003fc3ffd8<br>[4120922.937513] =C2=A0ffff88003fc3ffd8 ffff880=
03fc3ffd8 ffff8801f0cf1700 ffff880035f1b128<br>[4120922.942401] =C2=A0ffff8=
801f0cf1700 0000000000000000 ffff880035f1b000 ffff8801ed87cb00<br>[4120922.=
946982] Call Trace:<br>[4120922.949242] =C2=A0[&lt;ffffffff8163b139&gt;] sc=
hedule+0x29/0x70<br>[4120922.952840] =C2=A0[&lt;ffffffffa0159842&gt;] _xfs_=
log_force+0x192/0x290 [xfs]<br>[4120922.957966] =C2=A0[&lt;ffffffff810b88d0=
&gt;] ? wake_up_state+0x20/0x20<br>[4120922.962437] =C2=A0[&lt;ffffffffa015=
9966&gt;] xfs_log_force+0x26/0x80 [xfs]<br>[4120922.965795] =C2=A0[&lt;ffff=
ffffa01510ad&gt;] xfs_fs_sync_fs+0x2d/0x50 [xfs]<br>[4120922.969715] =C2=A0=
[&lt;ffffffff8120fcf2&gt;] sync_filesystem+0x72/0xa0<br>[4120922.973197] =
=C2=A0[&lt;ffffffff8121a344&gt;] fsync_bdev+0x24/0x60<br>[4120922.976962] =
=C2=A0[&lt;ffffffff812d937b&gt;] blkdev_ioctl+0x3bb/0x760<br>[4120922.98087=
1] =C2=A0[&lt;ffffffff812199a1&gt;] block_ioctl+0x41/0x50<br>[4120922.98419=
0] =C2=A0[&lt;ffffffff811f2175&gt;] do_vfs_ioctl+0x2e5/0x4c0<br>[4120922.98=
7944] =C2=A0[&lt;ffffffff8128c01e&gt;] ? file_has_perm+0xae/0xc0<br>[412092=
2.991108] =C2=A0[&lt;ffffffff811f23f1&gt;] SyS_ioctl+0xa1/0xc0<br>[4120922.=
994021] =C2=A0[&lt;ffffffff816461c9&gt;] system_call_fastpath+0x16/0x1b<br>=
<br><br>--------------<br>Kernel version<br>--------------<br>Linux version=
 3.10.0-327.18.2.el7.x86_64 (<a href=3D"mailto:builder@kbuilder.dev.centos.=
org">builder@kbuilder.dev.centos.org</a>) (gcc version 4.8.3 20140911 (Red =
Hat 4.8.3-9) (GCC) ) #1 SMP Thu May 12 11:03<br>:55 UTC 2016<br><br><br>---=
-------------<br>xfsprogs version<br>----------------<br>xfs_repair version=
 3.2.2<br><br><br>--------------<br>number of CPUs<br>--------------<br>=C2=
=A0# =C2=A0cat /proc/cpuinfo<br>processor =C2=A0 =C2=A0 =C2=A0 : 0<br>vendo=
r_id =C2=A0 =C2=A0 =C2=A0 : GenuineIntel<br>cpu family =C2=A0 =C2=A0 =C2=A0=
: 6<br>model =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 63<br>model name =C2=A0 =
=C2=A0 =C2=A0: Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz<br>stepping =C2=A0=
 =C2=A0 =C2=A0 =C2=A0: 2<br>microcode =C2=A0 =C2=A0 =C2=A0 : 0x25<br>cpu MH=
z =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 2400.088<br>cache size =C2=A0 =C2=A0 =C2=A0=
: 30720 KB<br>physical id =C2=A0 =C2=A0 : 0<br>siblings =C2=A0 =C2=A0 =C2=
=A0 =C2=A0: 2<br>core id =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 0<br>cpu cores =C2=
=A0 =C2=A0 =C2=A0 : 1<br>apicid =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: 0<br>in=
itial apicid =C2=A0: 0<br>fpu =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : y=
es<br>fpu_exception =C2=A0 : yes<br>cpuid level =C2=A0 =C2=A0 : 13<br>wp =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: yes<br>flags =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr=
 pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm c=
onstant_tsc rep_good nopl xtopology eagerfpu pni pclmulqdq ssse3 fma cx16 p=
cid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c=
 rdrand hypervisor lahf_lm abm fsgsbase bmi1 avx2 smep bmi2 erms invpcid xs=
aveopt<br>bogomips =C2=A0 =C2=A0 =C2=A0 =C2=A0: 4800.17<br>clflush size =C2=
=A0 =C2=A0: 64<br>cache_alignment : 64<br>address sizes =C2=A0 : 46 bits ph=
ysical, 48 bits virtual<br>power management:<br><br>processor =C2=A0 =C2=A0=
 =C2=A0 : 1<br>vendor_id =C2=A0 =C2=A0 =C2=A0 : GenuineIntel<br>cpu family =
=C2=A0 =C2=A0 =C2=A0: 6<br>model =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 63<br=
>model name =C2=A0 =C2=A0 =C2=A0: Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz=
<br>stepping =C2=A0 =C2=A0 =C2=A0 =C2=A0: 2<br>microcode =C2=A0 =C2=A0 =C2=
=A0 : 0x25<br>cpu MHz =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 2400.088<br>cache size =
=C2=A0 =C2=A0 =C2=A0: 30720 KB<br>physical id =C2=A0 =C2=A0 : 0<br>siblings=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0: 2<br>core id =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 0<=
br>cpu cores =C2=A0 =C2=A0 =C2=A0 : 1<br>apicid =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0: 1<br>initial apicid =C2=A0: 1<br>fpu =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 : yes<br>fpu_exception =C2=A0 : yes<br>cpuid level =C2=A0 =C2=
=A0 : 13<br>wp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: yes<br>fla=
gs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : fpu vme de pse tsc msr pae mce cx8 =
apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall n=
x rdtscp lm constant_tsc rep_good nopl xtopology eagerfpu pni pclmulqdq sss=
e3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes x=
save avx f16c rdrand hypervisor lahf_lm abm fsgsbase bmi1 avx2 smep bmi2 er=
ms invpcid xsaveopt<br>bogomips =C2=A0 =C2=A0 =C2=A0 =C2=A0: 4800.17<br>clf=
lush size =C2=A0 =C2=A0: 64<br>cache_alignment : 64<br>address sizes =C2=A0=
 : 46 bits physical, 48 bits virtual<br>power management:<br><br><br>------=
-------------------<br>contents of /proc/meminfo<br>-----------------------=
--<br>=C2=A0# =C2=A0cat /proc/meminfo<br>MemTotal: =C2=A0 =C2=A0 =C2=A0 =C2=
=A07747768 kB<br>MemFree: =C2=A0 =C2=A0 =C2=A0 =C2=A0 5771240 kB<br>MemAvai=
lable: =C2=A0 =C2=A06161328 kB<br>Buffers: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 460 kB<br>Cached: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 559916 kB<b=
r>SwapCached: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 kB<br>Active: =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01459048 kB<br>Inactive: =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 314992 kB<br>Active(anon): =C2=A0 =C2=A01217424 kB<br>Inactive(anon=
): =C2=A0 =C2=A017100 kB<br>Active(file): =C2=A0 =C2=A0 241624 kB<br>Inacti=
ve(file): =C2=A0 297892 kB<br>Unevictable: =C2=A0 =C2=A0 =C2=A0 =C2=A08644 =
kB<br>Mlocked: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A08644 kB<br>SwapTota=
l: =C2=A0 =C2=A0 =C2=A0 8388604 kB<br>SwapFree: =C2=A0 =C2=A0 =C2=A0 =C2=A0=
8388604 kB<br>Dirty: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01536 k=
B<br>Writeback: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 kB<br>AnonPages=
: =C2=A0 =C2=A0 =C2=A0 1222356 kB<br>Mapped: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A047524 kB<br>Shmem: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1=
7264 kB<br>Slab: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A070744 kB<b=
r>SReclaimable: =C2=A0 =C2=A0 =C2=A039000 kB<br>SUnreclaim: =C2=A0 =C2=A0 =
=C2=A0 =C2=A031744 kB<br>KernelStack: =C2=A0 =C2=A0 =C2=A0 =C2=A05616 kB<br=
>PageTables: =C2=A0 =C2=A0 =C2=A0 =C2=A0 8696 kB<br>NFS_Unstable: =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00 kB<br>Bounce: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 kB<br>WritebackTmp: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 kB<br>CommitLimit: =C2=A0 =C2=A012262488 kB<br>Committed_AS: =C2=A0=
 =C2=A03412392 kB<br>VmallocTotal: =C2=A0 34359738367 kB<br>VmallocUsed: =
=C2=A0 =C2=A0 =C2=A0 27068 kB<br>VmallocChunk: =C2=A0 34359697144 kB<br>Har=
dwareCorrupted: =C2=A0 =C2=A0 0 kB<br>AnonHugePages: =C2=A0 1040384 kB<br>H=
ugePages_Total: =C2=A0 =C2=A0 =C2=A0 0<br>HugePages_Free: =C2=A0 =C2=A0 =C2=
=A0 =C2=A00<br>HugePages_Rsvd: =C2=A0 =C2=A0 =C2=A0 =C2=A00<br>HugePages_Su=
rp: =C2=A0 =C2=A0 =C2=A0 =C2=A00<br>Hugepagesize: =C2=A0 =C2=A0 =C2=A0 2048=
 kB<br>DirectMap4k: =C2=A0 =C2=A0 =C2=A0 75776 kB<br>DirectMap2M: =C2=A0 =
=C2=A0 8312832 kB<br><br><br>------------------------<br>contents of /proc/=
mounts<br>------------------------<br>=C2=A0# =C2=A0cat /proc/mounts<br>roo=
tfs / rootfs rw 0 0<br>sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,rel=
atime 0 0<br>proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0<br>devtmpf=
s /dev devtmpfs rw,seclabel,nosuid,size=3D3986336k,nr_inodes=3D996584,mode=
=3D755 0 0<br>securityfs /sys/kernel/security securityfs rw,nosuid,nodev,no=
exec,relatime 0 0<br>tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0<br>d=
evpts /dev/pts devpts rw,seclabel,nosuid,noexec,relatime,gid=3D5,mode=3D620=
,ptmxmode=3D000 0 0<br>tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=3D755=
 0 0<br>tmpfs /sys/fs/cgroup tmpfs ro,seclabel,nosuid,nodev,noexec,mode=3D7=
55 0 0<br>cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relat=
ime,xattr,release_agent=3D/usr/lib/systemd/systemd-cgroups-agent,name=3Dsys=
temd 0 0<br>pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 =
0<br>cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relati=
me,cpuacct,cpu 0 0<br>cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,no=
exec,relatime,blkio 0 0<br>cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,n=
odev,noexec,relatime,devices 0 0<br>cgroup /sys/fs/cgroup/freezer cgroup rw=
,nosuid,nodev,noexec,relatime,freezer 0 0<br>cgroup /sys/fs/cgroup/hugetlb =
cgroup rw,nosuid,nodev,noexec,relatime,hugetlb 0 0<br>cgroup /sys/fs/cgroup=
/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0<br>cgroup /sys/=
fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0<br>cgrou=
p /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_eve=
nt 0 0<br>cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relati=
me,memory 0 0<br>configfs /sys/kernel/config configfs rw,relatime 0 0<br>/d=
ev/xvda1 / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0<br>rpc_pipefs=
 /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0<br>selinuxfs /sys/fs/se=
linux selinuxfs rw,relatime 0 0<br>systemd-1 /proc/sys/fs/binfmt_misc autof=
s rw,relatime,fd=3D25,pgrp=3D1,timeout=3D300,minproto=3D5,maxproto=3D5,dire=
ct 0 0<br>hugetlbfs /dev/hugepages hugetlbfs rw,seclabel,relatime 0 0<br>mq=
ueue /dev/mqueue mqueue rw,seclabel,relatime 0 0<br>debugfs /sys/kernel/deb=
ug debugfs rw,relatime 0 0<br>nfsd /proc/fs/nfsd nfsd rw,relatime 0 0<br>/d=
ev/xvdb1 /opt xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0<br>tmpfs /=
run/user/0 tmpfs rw,seclabel,nosuid,nodev,relatime,size=3D774780k,mode=3D70=
0 0 0<br><br><br>----------------------------<br>contents of /proc/partitio=
ns<br>----------------------------<br>=C2=A0# =C2=A0cat /proc/partitions<br=
>major minor =C2=A0#blocks =C2=A0name<br><br>=C2=A0202 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 16777216 xvda<br>=C2=A0202 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=
=A0 16770836 xvda1<br>=C2=A0202 =C2=A0 =C2=A0 =C2=A0 16 2147483648 xvdb<br>=
=C2=A0202 =C2=A0 =C2=A0 =C2=A0 17 2147483616 xvdb1<br><br><br>-------------=
-------------------------<br>RAID layout (hardware and/or software)<br>----=
----------------------------------<br>N/A<br><br><br>-----------------<br>L=
VM configuration<br>-----------------<br>N/A<br><br><br>-------------------=
--------<br>type of disks you are using<br>---------------------------<br>A=
mazon Elastic Block Storage - General Purpose SSD<br><br><br>--------------=
--------------<br>write cache status of drives<br>-------------------------=
---<br>N/A<br><br><br>--------------------------------------<br>size of BBW=
C and mode it is running in<br>--------------------------------------<br>N/=
A<br><br><br>---------------------------------------------<br>xfs_info outp=
ut on the filesystem in question<br>---------------------------------------=
------<br>=C2=A0# =C2=A0xfs_info /dev/xvdb1<br>meta-data=3D/dev/xvdb1 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 isize=3D256 =C2=A0 =C2=A0agcount=3D8=
, agsize=3D67108862 blks<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sects=
z=3D512 =C2=A0 attr=3D2, projid32bit=3D1<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 crc=3D0 =C2=A0 =C2=A0 =C2=A0 =C2=A0finobt=3D0<br>data =C2=A0 =C2=
=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D536870896, imaxpct=3D25<br>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D0 =C2=A0 =C2=A0 =C2=A0swidth=3D0=
 blks<br>naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0bsize=3D4096 =C2=A0 ascii-ci=3D0 ftype=3D0<br>log =C2=A0 =C2=A0 =
=C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D=
4096 =C2=A0 blocks=3D131071, version=3D2<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D0 blks, lazy-count=3D1<br>realtime =
=3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exts=
z=3D4096 =C2=A0 blocks=3D0, rtextents=3D0<br><br><br>----------------------=
----------<br>dmesg output (/var/log/messages)<br>-------------------------=
-------<br>Note, I know that the messages below refer to the XVDA1 drive an=
d not the XVDB1 drive whose filesystem had hung.<br><br>Jul 18 09:19:29 ip-=
172-31-18-53 kernel: XFS (xvda1): Metadata corruption detected at xfs_attr3=
_leaf_read_verify+0x5e/0x110 [xfs], block 0x14277a0<br>Jul 18 09:19:29 ip-1=
72-31-18-53 kernel: XFS (xvda1): Unmount and run xfs_repair<br>Jul 18 09:19=
:29 ip-172-31-18-53 kernel: XFS (xvda1): First 64 bytes of corrupted metada=
ta buffer:<br>Jul 18 09:19:29 ip-172-31-18-53 kernel: ffff8801f01a9000: 31 =
34 33 34 39 38 31 34 33 32 34 39 33 30 3d 31 =C2=A014349814324930=3D1<br>Ju=
l 18 09:19:29 ip-172-31-18-53 kernel: ffff8801f01a9010: 34 36 38 36 36 37 3=
7 35 33 0a 31 34 33 34 39 38 =C2=A0468667753.143498<br>Jul 18 09:19:29 ip-1=
72-31-18-53 kernel: ffff8801f01a9020: 31 34 32 38 34 37 30 37 3d 31 34 36 3=
8 36 36 36 =C2=A014284707=3D1468666<br>Jul 18 09:19:29 ip-172-31-18-53 kern=
el: ffff8801f01a9030: 38 32 32 0a 00 00 00 00 00 00 00 00 00 00 00 00 =C2=
=A0822.............<br>Jul 18 09:19:29 ip-172-31-18-53 kernel: XFS (xvda1):=
 metadata I/O error: block 0x14277a0 (&quot;xfs_trans_read_buf_map&quot;) e=
rror 117 numblks 8<br>Jul 18 09:19:29 ip-172-31-18-53 kernel: SELinux: inod=
e_doinit_with_dentry: =C2=A0getxattr returned 117 for dev=3Dxvda1 ino=3D422=
71394<br>Jul 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): Metadata corr=
uption detected at xfs_da3_node_read_verify+0x5f/0x150 [xfs], block 0x14277=
a0<br>Jul 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): Unmount and run =
xfs_repair<br>Jul 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): First 64=
 bytes of corrupted metadata buffer:<br>Jul 18 09:19:30 ip-172-31-18-53 ker=
nel: ffff8801f0139000: 31 34 33 34 39 38 31 34 33 32 34 39 33 30 3d 31 =C2=
=A014349814324930=3D1<br>Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f0=
139010: 34 36 38 36 36 37 37 35 33 0a 31 34 33 34 39 38 =C2=A0468667753.143=
498<br>Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f0139020: 31 34 32 3=
8 34 37 30 37 3d 31 34 36 38 36 36 36 =C2=A014284707=3D1468666<br>Jul 18 09=
:19:30 ip-172-31-18-53 kernel: ffff8801f0139030: 38 32 32 0a 00 00 00 00 00=
 00 00 00 00 00 00 00 =C2=A0822.............<br>Jul 18 09:19:30 ip-172-31-1=
8-53 kernel: XFS (xvda1): Metadata corruption detected at xfs_attr3_leaf_re=
ad_verify+0x5e/0x110 [xfs], block 0x1b0<br>Jul 18 09:19:30 ip-172-31-18-53 =
kernel: XFS (xvda1): Unmount and run xfs_repair<br>Jul 18 09:19:30 ip-172-3=
1-18-53 kernel: XFS (xvda1): First 64 bytes of corrupted metadata buffer:<b=
r>Jul 18 09:19:30 ip-172-31-18-53 kernel: ffff8801f013b000: 3c 3f 78 6d 6c =
20 76 65 72 73 69 6f 6e 3d 22 31 =C2=A0&lt;?xml version=3D&quot;1<br>Jul 18=
 09:19:30 ip-172-31-18-53 kernel: ffff8801f013b010: 2e 30 22 20 65 6e 63 6f=
 64 69 6e 67 3d 22 55 54 =C2=A0.0&quot; encoding=3D&quot;UT<br>Jul 18 09:19=
:30 ip-172-31-18-53 kernel: ffff8801f013b020: 46 2d 38 22 3f 3e 0a 3c 72 65=
 70 6f 6d 64 20 78 =C2=A0F-8&quot;?&gt;.&lt;repomd x<br>Jul 18 09:19:30 ip-=
172-31-18-53 kernel: ffff8801f013b030: 6d 6c 6e 73 3d 22 68 74 74 70 3a 2f =
2f 6c 69 6e =C2=A0mlns=3D&quot;<a href=3D"http://lin">http://lin</a><br>Jul=
 18 09:19:30 ip-172-31-18-53 kernel: XFS (xvda1): metadata I/O error: block=
 0x1b0 (&quot;xfs_trans_read_buf_map&quot;) error 117 numblks 8<br>Jul 18 0=
9:19:30 ip-172-31-18-53 kernel: SELinux: inode_doinit_with_dentry: =C2=A0ge=
txattr returned 117 for dev=3Dxvda1 ino=3D2943<br>Jul 18 09:19:31 ip-172-31=
-18-53 kernel: XFS (xvda1): Metadata corruption detected at xfs_da3_node_re=
ad_verify+0x5f/0x150 [xfs], block 0x1b0<br>Jul 18 09:19:31 ip-172-31-18-53 =
kernel: XFS (xvda1): Unmount and run xfs_repair<br>Jul 18 09:19:31 ip-172-3=
1-18-53 kernel: XFS (xvda1): First 64 bytes of corrupted metadata buffer:<b=
r>Jul 18 09:19:31 ip-172-31-18-53 kernel: ffff8800e91fc000: 3c 3f 78 6d 6c =
20 76 65 72 73 69 6f 6e 3d 22 31 =C2=A0&lt;?xml version=3D&quot;1<br>Jul 18=
 09:19:31 ip-172-31-18-53 kernel: ffff8800e91fc010: 2e 30 22 20 65 6e 63 6f=
 64 69 6e 67 3d 22 55 54 =C2=A0.0&quot; encoding=3D&quot;UT<br>Jul 18 09:19=
:31 ip-172-31-18-53 kernel: ffff8800e91fc020: 46 2d 38 22 3f 3e 0a 3c 72 65=
 70 6f 6d 64 20 78 =C2=A0F-8&quot;?&gt;.&lt;repomd x<br>Jul 18 09:19:31 ip-=
172-31-18-53 kernel: ffff8800e91fc030: 6d 6c 6e 73 3d 22 68 74 74 70 3a 2f =
2f 6c 69 6e =C2=A0mlns=3D&quot;<a href=3D"http://lin">http://lin</a><br><br=
><br>-------------------------------------------<br>Running xfs_repair on t=
he /dev/xvdb1 volume<br>-------------------------------------------<br># =
=C2=A0xfs_repair /dev/xvdb1<br>Phase 1 - find and verify superblock...<br>P=
hase 2 - using internal log<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - zero log...<br=
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - scan filesystem freespace and inode maps...<=
br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - found root inode chunk<br>Phase 3 - for ea=
ch AG...<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - scan and clear agi unlinked lists=
...<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - process known inodes and perform inode=
 discovery...<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - agno =3D 0<br>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 - agno =3D 1<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - agno =3D 2<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 - agno =3D 3<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - a=
gno =3D 4<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - agno =3D 5<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 - agno =3D 6<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - agno =3D 7<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 - process newly discovered inodes...<br>Phase 4 - =
check for duplicate blocks...<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - setting up d=
uplicate extent list...<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - check for inodes c=
laiming duplicate blocks...<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - agno =3D 0<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 - agno =3D 1<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - a=
gno =3D 2<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - agno =3D 3<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 - agno =3D 4<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - agno =3D 5<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 - agno =3D 6<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - agno=
 =3D 7<br>Phase 5 - rebuild AG headers and trees...<br>=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 - reset superblock...<br>Phase 6 - check inode connectivity...<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 - resetting contents of realtime bitmap and sum=
mary inodes<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - traversing filesystem ...<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 - traversal finished ...<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 - moving disconnected inodes to lost+found ...<br>Phase 7 - veri=
fy and correct link counts...<br>done<br><br><br>At the moment, I can&#39;t=
 run xfs_repair on the XVDA1 file system since its an AWS EC2 root EBS volu=
me with market codes on it and I can&#39;t mount it as a secondary disk in =
another instance to run xfs_repair on it.<br></div>

--001a113ce4dc12838f0537e6442b--


--===============4500478978027550361==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4500478978027550361==--
