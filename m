Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3UESvbh261787 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 09:28:58 -0500
Date: Mon, 30 Apr 2012 09:32:00 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Assertion failed: RB_EMPTY_NODE(&bp->b_rbnode)
Message-ID: <20120430143200.GL16881@sgi.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

While testing this patchset without Jan's freeze work, I hit this assert.  I
believe I have not seen this one before.

-Ben

[36850.416217] XFS: Assertion failed: RB_EMPTY_NODE(&bp->b_rbnode), file: /work/xfs/fs/xfs/xfs_buf.c, line: 838
[36850.445669] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[36850.446633] IP: [<ffffffff816ef359>] _raw_spin_lock+0x9/0x30
[36850.446633] PGD 1291e5067 PUD 129a9f067 PMD 0
[36850.446633] Oops: 0002 [#1] SMP
[36850.446633] CPU 0
[36850.446633] Modules linked in: xfs(O) nfsd exportfs e1000e
[36850.446633]
[36850.446633] Pid: 20529, comm: kworker/0:10 Tainted: G           O 3.4.0-rc2+ #3 SGI.COM AltixXE310/X7DGT-INF
[36850.446633] RIP: 0010:[<ffffffff816ef359>]  [<ffffffff816ef359>] _raw_spin_lock+0x9/0x30
[36850.446633] RSP: 0018:ffff880106e6fb40  EFLAGS: 00010286
[36850.446633] RAX: 0000000000000100 RBX: ffff880121c0fba0 RCX: 0000000000000000
[36850.446633] RDX: 0000007800004e53 RSI: ffff880121c0fba0 RDI: 0000000000000038
[36850.446633] RBP: ffff880106e6fb40 R08: ffff88010c209b00 R09: 0000000000000000
[36850.446633] R10: 0000000000000800 R11: 0000000000000001 R12: ffff88010c209580
[36850.446633] R13: ffff880127711300 R14: ffff880127711330 R15: ffff88012852c780
[36850.446633] FS:  0000000000000000(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
[36850.446633] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[36850.446633] CR2: 0000000000000038 CR3: 0000000129bd3000 CR4: 00000000000007f0
[36850.446633] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[36850.446633] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[36850.446633] Process kworker/0:10 (pid: 20529, threadinfo ffff880106e6e000, task ffff88011931ba80)
[36850.446633] Stack:
[36850.446633]  ffff880106e6fcd0 ffffffffa00bc531 0000000000000400 0000000000001000
[36850.446633]  0000000000000000 0000007800004e53 0000000000000000 0000000000000038
[36850.446633]  ffff880106e6fba0 ffffffff8126b923 0000000000000040 ffff88012b004880
[36850.446633] Call Trace:
[36850.446633]  [<ffffffffa00bc531>] xfs_trans_committed_bulk+0x41/0x300 [xfs]
[36850.446633]  [<ffffffff8126b923>] ? cpumask_next_and+0x23/0x40
[36850.446633]  [<ffffffff8106c5f7>] ? select_task_rq_fair+0x547/0xa00
[36850.446633]  [<ffffffff8106d205>] ? enqueue_task_fair+0x135/0x520
[36850.446633]  [<ffffffff81065911>] ? enqueue_task+0x61/0x70
[36850.446633]  [<ffffffff81063e25>] ? check_preempt_curr+0x85/0xa0
[36850.446633]  [<ffffffff8106b5d8>] ? update_curr+0x158/0x1b0
[36850.446633]  [<ffffffffa00c24f6>] xlog_cil_committed+0x36/0x130 [xfs]
[36850.446633]  [<ffffffffa00be07d>] xlog_state_do_callback+0x16d/0x390 [xfs]
[36850.446633]  [<ffffffffa00be387>] xlog_state_done_syncing+0xe7/0x110 [xfs]
[36850.446633]  [<ffffffffa00beb8e>] xlog_iodone+0x7e/0x100 [xfs]
[36850.446633]  [<ffffffffa005a2d1>] xfs_buf_iodone_work+0x21/0x50 [xfs]
[36850.446633]  [<ffffffff81051498>] process_one_work+0x158/0x440
[36850.446633]  [<ffffffffa005a2b0>] ? xfs_bioerror_relse+0x80/0x80 [xfs]
[36850.446633]  [<ffffffff8105428b>] worker_thread+0x17b/0x410
[36850.446633]  [<ffffffff81054110>] ? manage_workers+0x200/0x200
[36850.446633]  [<ffffffff81058bce>] kthread+0x9e/0xb0
[36850.446633]  [<ffffffff816f8014>] kernel_thread_helper+0x4/0x10
[36850.446633]  [<ffffffff81058b30>] ? kthread_freezable_should_stop+0x70/0x70
[36850.446633]  [<ffffffff816f8010>] ? gs_change+0xb/0xb
[36850.446633] Code: 89 c8 f0 66 0f b1 37 66 39 c1 c9 0f 94 c0 0f b6 d0 89 d0 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 b8 00 01 00 00 48 89 e5 <f0> 66 0f c1 07 89 c2 66 c1 ea 08 38 d0 74 11 0f 1f 84 00 00 00
[36850.446633] RIP  [<ffffffff816ef359>] _raw_spin_lock+0x9/0x30
[36850.446633]  RSP <ffff880106e6fb40>
[36850.446633] CR2: 0000000000000038
[36851.384076] ---[ end trace ef4b0c0782ed6ecf ]---
[36851.397935] ------------[ cut here ]------------
[36851.411775] kernel BUG at /work/xfs/fs/xfs/xfs_message.c:100!
[36851.411777] invalid opcode: 0000 [#2] SMP
[36851.411779] CPU 0
[36851.411779] Modules linked in: xfs(O) nfsd exportfs e1000e
[36851.411782]
[36851.411784] Pid: 20533, comm: kworker/0:14 Tainted: G      D    O 3.4.0-rc2+ #3 SGI.COM AltixXE310/X7DGT-INF
[36851.411786] RIP: 0010:[<ffffffffa00688dd>]  [<ffffffffa00688dd>] assfail+0x1d/0x30 [xfs]
[36851.411797] RSP: 0018:ffff8801051a7bf0  EFLAGS: 00010286
[36851.411798] RAX: 0000000000000076 RBX: ffff880121c14500 RCX: 0000000000000082
[36851.411799] RDX: 0000000000000075 RSI: 0000000000000046 RDI: ffffffff81d79538
[36851.411801] RBP: ffff8801051a7bf0 R08: 0000000000000000 R09: 0000000000000000
[36851.411802] R10: 00000000ffffffff R11: 0000000000000000 R12: ffff880121c14500
[36851.411804] R13: ffffffffa005a54b R14: 0000000000000000 R15: 0000000000000002
[36851.411806] FS:  0000000000000000(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
[36851.411807] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[36851.411809] CR2: 0000000000000038 CR3: 0000000129bd3000 CR4: 00000000000007f0
[36851.411810] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[36851.411812] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[36851.411813] Process kworker/0:14 (pid: 20533, threadinfo ffff8801051a6000, task ffff88011931d7c0)
[36851.411815] Stack:
[36851.411815]  ffff8801051a7c20 ffffffffa0059859 ffff880121c14500 ffff880121c14500
[36851.411818]  ffffffffa00be58e ffff88010c209500 ffff8801051a7c50 ffffffffa005a54b
[36851.411820]  ffff8801051a7c60 ffff880121c14500 ffff880103ff3800 ffff88012fc12cc0
[36851.411822] Call Trace:
[36851.411829]  [<ffffffffa0059859>] xfs_buf_rele+0x179/0x1b0 [xfs]
[36851.411838]  [<ffffffffa00be58e>] ? xlog_bdstrat+0x1e/0x60 [xfs]
[36851.411845]  [<ffffffffa005a54b>] xfs_buf_iorequest+0xab/0xc0 [xfs]
[36851.411854]  [<ffffffffa00be58e>] xlog_bdstrat+0x1e/0x60 [xfs]
[36851.411863]  [<ffffffffa00c0080>] xlog_sync+0x350/0x540 [xfs]
[36851.411872]  [<ffffffffa00c032a>] xlog_state_release_iclog+0xba/0x130 [xfs]
[36851.411881]  [<ffffffffa00c093f>] _xfs_log_force_lsn+0x20f/0x2a0 [xfs]
[36851.411884]  [<ffffffff81068cc0>] ? try_to_wake_up+0x280/0x280
[36851.411893]  [<ffffffffa00bcde3>] xfs_trans_commit+0x293/0x2a0 [xfs]
[36851.411900]  [<ffffffffa005f74b>] xfs_fs_log_dummy+0x5b/0x80 [xfs]
[36851.411910]  [<ffffffffa006ba1c>] xfs_sync_worker+0x8c/0xa0 [xfs]
[36851.411912]  [<ffffffff81051498>] process_one_work+0x158/0x440
[36851.411921]  [<ffffffffa006b990>] ? xfs_flush_inodes+0x40/0x40 [xfs]
[36851.411923]  [<ffffffff8105428b>] worker_thread+0x17b/0x410
[36851.411925]  [<ffffffff81054110>] ? manage_workers+0x200/0x200
[36851.411927]  [<ffffffff81058bce>] kthread+0x9e/0xb0
[36851.411930]  [<ffffffff816f8014>] kernel_thread_helper+0x4/0x10
[36851.411932]  [<ffffffff81058b30>] ? kthread_freezable_should_stop+0x70/0x70
[36851.411934]  [<ffffffff816f8010>] ? gs_change+0xb/0xb
[36851.411935] Code: 00 00 00 48 89 45 c8 e8 72 fc ff ff c9 c3 55 41 89 d0 48 89 f1 48 89 fa 48 c7 c6 d0 f3 0d a0 31 ff 48 89 e5 31 c0 e8 93 ff ff ff <0f> 0b eb fe 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 4c
[36851.411950] RIP  [<ffffffffa00688dd>] assfail+0x1d/0x30 [xfs]
[36851.411958]  RSP <ffff8801051a7bf0>
[36851.411960] ---[ end trace ef4b0c0782ed6ed0 ]---
[36851.411993] BUG: unable to handle kernel paging request at fffffffffffffff8
[36851.411995] IP: [<ffffffff810586ab>] kthread_data+0xb/0x20
[36851.411998] PGD 1c0e067 PUD 1c0f067 PMD 0
[36851.412000] Oops: 0000 [#3] SMP
[36851.412001] CPU 0
[36851.412002] Modules linked in: xfs(O) nfsd exportfs e1000e
[36851.412004]
[36851.412006] Pid: 20533, comm: kworker/0:14 Tainted: G      D    O 3.4.0-rc2+ #3 SGI.COM AltixXE310/X7DGT-INF
[36851.412008] RIP: 0010:[<ffffffff810586ab>]  [<ffffffff810586ab>] kthread_data+0xb/0x20
[36851.412011] RSP: 0018:ffff8801051a77e8  EFLAGS: 00010092
[36851.412012] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000012acd60aa60
[36851.412013] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88011931d7c0
[36851.412015] RBP: ffff8801051a77e8 R08: ffff88012fc0d248 R09: 0000000000000000
[36851.412016] R10: 0000000000000800 R11: 0000000000000001 R12: ffff88011931db48
[36851.412018] R13: ffff88012fc120c0 R14: 0000000000000000 R15: ffff88011931da50
[36851.412020] FS:  0000000000000000(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
[36851.412021] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[36851.412023] CR2: fffffffffffffff8 CR3: 0000000129bd3000 CR4: 00000000000007f0
[36851.412024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[36851.412026] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[36851.412027] Process kworker/0:14 (pid: 20533, threadinfo ffff8801051a6000, task ffff88011931d7c0)
[36851.412029] Stack:
[36851.412029]  ffff8801051a7808 ffffffff81052680 ffff8801051a7808 ffff88011931d7c0
[36851.412032]  ffff8801051a7948 ffffffff816ee4df ffff8801051a6010 00000000000120c0
[36851.412034]  00000000000120c0 ffff88011931d7c0 00000000000120c0 ffff8801051a7fd8
[36851.412036] Call Trace:
[36851.412038]  [<ffffffff81052680>] wq_worker_sleeping+0x10/0xa0
[36851.412040]  [<ffffffff816ee4df>] __schedule+0x64f/0x810
[36851.412042]  [<ffffffff81051c49>] ? __queue_work+0x219/0x400
[36851.412044]  [<ffffffff81051e76>] ? queue_work_on+0x16/0x20
[36851.412046]  [<ffffffff81051eba>] ? queue_work+0x1a/0x20
[36851.412049]  [<ffffffff81259392>] ? put_io_context+0x62/0x90
[36851.412051]  [<ffffffff816ee994>] schedule+0x24/0x70
[36851.412054]  [<ffffffff8103c926>] do_exit+0x676/0xa00
[36851.412056]  [<ffffffff816f04cc>] oops_end+0xdc/0xe0
[36851.412059]  [<ffffffff81005676>] die+0x56/0x90
[36851.412061]  [<ffffffff816f0098>] do_trap+0x148/0x160
[36851.412064]  [<ffffffff816f2d65>] ? atomic_notifier_call_chain+0x15/0x20
[36851.412071]  [<ffffffffa005a54b>] ? xfs_buf_iorequest+0xab/0xc0 [xfs]
[36851.412073]  [<ffffffff810033c0>] do_invalid_op+0x90/0xb0
[36851.412082]  [<ffffffffa00688dd>] ? assfail+0x1d/0x30 [xfs]
[36851.412089]  [<ffffffffa005a54b>] ? xfs_buf_iorequest+0xab/0xc0 [xfs]
[36851.412091]  [<ffffffff816ec899>] ? printk+0x3c/0x3e
[36851.412094]  [<ffffffff816f7e95>] invalid_op+0x15/0x20
[36851.412100]  [<ffffffffa005a54b>] ? xfs_buf_iorequest+0xab/0xc0 [xfs]
[36851.412109]  [<ffffffffa00688dd>] ? assfail+0x1d/0x30 [xfs]
[36851.412116]  [<ffffffffa0059859>] xfs_buf_rele+0x179/0x1b0 [xfs]
[36851.412124]  [<ffffffffa00be58e>] ? xlog_bdstrat+0x1e/0x60 [xfs]
[36851.412131]  [<ffffffffa005a54b>] xfs_buf_iorequest+0xab/0xc0 [xfs]
[36851.412140]  [<ffffffffa00be58e>] xlog_bdstrat+0x1e/0x60 [xfs]
[36851.412149]  [<ffffffffa00c0080>] xlog_sync+0x350/0x540 [xfs]
[36851.412157]  [<ffffffffa00c032a>] xlog_state_release_iclog+0xba/0x130 [xfs]
[36851.412166]  [<ffffffffa00c093f>] _xfs_log_force_lsn+0x20f/0x2a0 [xfs]
[36851.412168]  [<ffffffff81068cc0>] ? try_to_wake_up+0x280/0x280
[36851.412177]  [<ffffffffa00bcde3>] xfs_trans_commit+0x293/0x2a0 [xfs]
[36851.412184]  [<ffffffffa005f74b>] xfs_fs_log_dummy+0x5b/0x80 [xfs]
[36851.412193]  [<ffffffffa006ba1c>] xfs_sync_worker+0x8c/0xa0 [xfs]
[36851.412195]  [<ffffffff81051498>] process_one_work+0x158/0x440
[36851.412204]  [<ffffffffa006b990>] ? xfs_flush_inodes+0x40/0x40 [xfs]
[36851.412206]  [<ffffffff8105428b>] worker_thread+0x17b/0x410
[36851.412208]  [<ffffffff81054110>] ? manage_workers+0x200/0x200
[36851.412210]  [<ffffffff81058bce>] kthread+0x9e/0xb0
[36851.412212]  [<ffffffff816f8014>] kernel_thread_helper+0x4/0x10
[36851.412215]  [<ffffffff81058b30>] ? kthread_freezable_should_stop+0x70/0x70
[36851.412217]  [<ffffffff816f8010>] ? gs_change+0xb/0xb
[36851.412218] Code: 55 65 48 8b 04 25 40 b7 00 00 48 8b 80 30 03 00 00 48 89 e5 8b 40 f0 c9 c3 0f 1f 80 00 00 00 00 48 8b 87 30 03 00 00 55 48 89 e5 <48> 8b 40 f8 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
[36851.412233] RIP  [<ffffffff810586ab>] kthread_data+0xb/0x20
[36851.412235]  RSP <ffff8801051a77e8>
[36851.412236] CR2: fffffffffffffff8
[36851.412237] ---[ end trace ef4b0c0782ed6ed1 ]---
[36851.412238] Fixing recursive fault but reboot is needed!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
