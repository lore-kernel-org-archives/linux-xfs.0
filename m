Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3UEVVr6000311 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 09:31:31 -0500
Date: Mon, 30 Apr 2012 09:34:34 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/37] xfs: current 3.4 patch queue
Message-ID: <20120430143434.GM16881@sgi.com>
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

While testing this patchset without Jan's freeze work, I hit this assert.

This one rings bells for me, but I can't find where it's been reported.

-Ben


[56571.411824] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[56571.412798] IP: [<ffffffffa00bf477>] xfs_log_space_wake+0x17/0x140 [xfs]
[56571.412798] PGD 0
[56571.412798] Oops: 0000 [#1] SMP
[56571.412798] CPU 3
[56571.412798] Modules linked in: xfs(O) nfsd exportfs e1000e
[56571.412798]
[56571.412798] Pid: 14544, comm: kworker/3:25 Tainted: G           O 3.4.0-rc2+ #3 SGI.COM AltixXE310/X7DGT-INF
[56571.412798] RIP: 0010:[<ffffffffa00bf477>]  [<ffffffffa00bf477>] xfs_log_space_wake+0x17/0x140 [xfs]
[56571.412798] RSP: 0018:ffff8801204a7ce0  EFLAGS: 00010282
[56571.412798] RAX: ffff88010fdd3de8 RBX: ffff88010a4971c0 RCX: 0000000000000000
[56571.412798] RDX: ffff88010fdd3de8 RSI: 0000000000000282 RDI: ffff88010fdd3580
[56571.412798] RBP: ffff8801204a7d00 R08: ffff88010fdd3dd0 R09: 0000000000000000
[56571.412798] R10: 0000000000000400 R11: 0000000000000001 R12: 0000000000000000
[56571.412798] R13: 0000000000000001 R14: ffff8801204a7d80 R15: ffff88010fdd3d80
[56571.412798] FS:  0000000000000000(0000) GS:ffff88012fd80000(0000) knlGS:0000000000000000
[56571.412798] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[56571.412798] CR2: 0000000000000028 CR3: 0000000001c0c000 CR4: 00000000000007e0
[56571.412798] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[56571.412798] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[56571.412798] Process kworker/3:25 (pid: 14544, threadinfo ffff8801204a6000, task ffff880101750750)
[56571.412798] Stack:
[56571.412798]  ffff88010fdd3da8 0000000000000001 ffff88010a4971c0 ffff88010fdd3da8
[56571.412798]  ffff8801204a7d60 ffffffffa00c64ef 0000000000000000 0000000100000008
[56571.412798]  ffff88010a4971c0 0000000181063e35 ffff88010fdd3d90 ffff88010a4971c0
[56571.412798] Call Trace:
[56571.412798]  [<ffffffffa00c64ef>] xfs_trans_ail_delete_bulk+0x14f/0x1e0 [xfs]
[56571.412798]  [<ffffffffa00c31c7>] xfs_buf_iodone+0x67/0x90 [xfs]
[56571.412798]  [<ffffffff810663fc>] ? ttwu_do_activate+0x4c/0x60
[56571.412798]  [<ffffffffa00c2d9c>] xfs_buf_do_callbacks+0x5c/0x70 [xfs]
[56571.412798]  [<ffffffffa00c2f49>] xfs_buf_iodone_callbacks+0x39/0x230 [xfs]
[56571.412798]  [<ffffffffa005a2d1>] xfs_buf_iodone_work+0x21/0x50 [xfs]
[56571.412798]  [<ffffffff81051498>] process_one_work+0x158/0x440
[56571.412798]  [<ffffffffa005a2b0>] ? xfs_bioerror_relse+0x80/0x80 [xfs]
[56571.412798]  [<ffffffff8105428b>] worker_thread+0x17b/0x410
[56571.412798]  [<ffffffff81054110>] ? manage_workers+0x200/0x200
[56571.412798]  [<ffffffff81058bce>] kthread+0x9e/0xb0
[56571.412798]  [<ffffffff816f8014>] kernel_thread_helper+0x4/0x10
[56571.412798]  [<ffffffff81058b30>] ? kthread_freezable_should_stop+0x70/0x70
[56571.412798]  [<ffffffff816f8010>] ? gs_change+0xb/0xb
[56571.412798] Code: 5e 41 5f c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 5d f0 4c 89 65 f8 4c 8b a7 40 01 00 00 <41> 8b 54 24 28 f6 c2 08 0f 85 db 00 00 00 49 8d 84 24 88 01 00
[56571.412798] RIP  [<ffffffffa00bf477>] xfs_log_space_wake+0x17/0x140 [xfs]
[56571.412798]  RSP <ffff8801204a7ce0>
[56571.412798] CR2: 0000000000000028
[56572.245080] ---[ end trace 389bb5c2de2235a4 ]---
[56572.258912] BUG: unable to handle kernel paging request at fffffffffffffff8
[56572.270001] IP: [<ffffffff810586ab>] kthread_data+0xb/0x20
[56572.270001] PGD 1c0e067 PUD 1c0f067 PMD 0
[56572.270001] Oops: 0000 [#2] SMP
[56572.270001] CPU 3
[56572.270001] Modules linked in: xfs(O) nfsd exportfs e1000e
[56572.270001]
[56572.270001] Pid: 14544, comm: kworker/3:25 Tainted: G      D    O 3.4.0-rc2+ #3 SGI.COM AltixXE310/X7DGT-INF
[56572.270001] RIP: 0010:[<ffffffff810586ab>]  [<ffffffff810586ab>] kthread_data+0xb/0x20
[56572.270001] RSP: 0018:ffff8801204a7838  EFLAGS: 00010096
[56572.270001] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 00000698cbadbdda
[56572.270001] RDX: 0000000000000003 RSI: 0000000000000003 RDI: ffff880101750750
[56572.270001] RBP: ffff8801204a7838 R08: ffff88012fd8d248 R09: 0000000000000000
[56572.270001] R10: 0000000000000400 R11: 0000000000000001 R12: ffff880101750ad8
[56572.270001] R13: ffff88012fd920c0 R14: 0000000000000003 R15: ffff8801017509e0
[56572.270001] FS:  0000000000000000(0000) GS:ffff88012fd80000(0000) knlGS:0000000000000000
[56572.270001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[56572.270001] CR2: fffffffffffffff8 CR3: 0000000001c0c000 CR4: 00000000000007e0
[56572.270001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[56572.270001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[56572.270001] Process kworker/3:25 (pid: 14544, threadinfo ffff8801204a6000, task ffff880101750750)
[56572.270001] Stack:
[56572.270001]  ffff8801204a7858 ffffffff81052680 ffff8801204a7858 ffff880101750750
[56572.270001]  ffff8801204a7998 ffffffff816ee4df ffff8801204a6010 00000000000120c0
[56572.270001]  00000000000120c0 ffff880101750750 00000000000120c0 ffff8801204a7fd8
[56572.270001] Call Trace:
[56572.270001]  [<ffffffff81052680>] wq_worker_sleeping+0x10/0xa0
[56572.270001]  [<ffffffff816ee4df>] __schedule+0x64f/0x810
[56572.270001]  [<ffffffff81051c49>] ? __queue_work+0x219/0x400
[56572.270001]  [<ffffffff8113ab77>] ? d_hash_and_lookup+0x37/0x70
[56572.270001]  [<ffffffff81051e76>] ? queue_work_on+0x16/0x20
[56572.270001]  [<ffffffff81051eba>] ? queue_work+0x1a/0x20
[56572.270001]  [<ffffffff81259392>] ? put_io_context+0x62/0x90
[56572.270001]  [<ffffffff816ee994>] schedule+0x24/0x70
[56572.270001]  [<ffffffff8103c926>] do_exit+0x676/0xa00
[56572.270001]  [<ffffffff816f04cc>] oops_end+0xdc/0xe0
[56572.270001]  [<ffffffff8102c7a8>] no_context+0x118/0x2e0
[56572.270001]  [<ffffffff8102ca9d>] __bad_area_nosemaphore+0x12d/0x200
[56572.270001]  [<ffffffff8102cb7e>] bad_area_nosemaphore+0xe/0x10
[56572.270001]  [<ffffffff816f2b8e>] do_page_fault+0x34e/0x480
[56572.270001]  [<ffffffff816ef9af>] page_fault+0x1f/0x30
[56572.270001]  [<ffffffffa00bf477>] ? xfs_log_space_wake+0x17/0x140 [xfs]
[56572.270001]  [<ffffffffa00c64ef>] xfs_trans_ail_delete_bulk+0x14f/0x1e0 [xfs]
[56572.270001]  [<ffffffffa00c31c7>] xfs_buf_iodone+0x67/0x90 [xfs]
[56572.270001]  [<ffffffff810663fc>] ? ttwu_do_activate+0x4c/0x60
[56572.270001]  [<ffffffffa00c2d9c>] xfs_buf_do_callbacks+0x5c/0x70 [xfs]
[56572.270001]  [<ffffffffa00c2f49>] xfs_buf_iodone_callbacks+0x39/0x230 [xfs]
[56572.270001]  [<ffffffffa005a2d1>] xfs_buf_iodone_work+0x21/0x50 [xfs]
[56572.270001]  [<ffffffff81051498>] process_one_work+0x158/0x440
[56572.270001]  [<ffffffffa005a2b0>] ? xfs_bioerror_relse+0x80/0x80 [xfs]
[56572.270001]  [<ffffffff8105428b>] worker_thread+0x17b/0x410
[56572.270001]  [<ffffffff81054110>] ? manage_workers+0x200/0x200
[56572.270001]  [<ffffffff81058bce>] kthread+0x9e/0xb0
[56572.270001]  [<ffffffff816f8014>] kernel_thread_helper+0x4/0x10
[56572.270001]  [<ffffffff81058b30>] ? kthread_freezable_should_stop+0x70/0x70
[56572.270001]  [<ffffffff816f8010>] ? gs_change+0xb/0xb
[56572.270001] Code: 55 65 48 8b 04 25 40 b7 00 00 48 8b 80 30 03 00 00 48 89 e5 8b 40 f0 c9 c3 0f 1f 80 00 00 00 00 48 8b 87 30 03 00 00 55 48 89 e5 <48> 8b 40 f8 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
[56572.270001] RIP  [<ffffffff810586ab>] kthread_data+0xb/0x20
[56572.270001]  RSP <ffff8801204a7838>
[56572.270001] CR2: fffffffffffffff8
[56572.270001] ---[ end trace 389bb5c2de2235a5 ]---
[56572.270001] Fixing recursive fault but reboot is needed!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
