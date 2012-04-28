Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3SLPhHU049848 for <xfs@oss.sgi.com>; Sat, 28 Apr 2012 16:25:43 -0500
Date: Sat, 28 Apr 2012 16:28:33 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/37] xfs: current 3.4 patch queue
Message-ID: <20120428212833.GJ16881@sgi.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<20120428021546.GI16881@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120428021546.GI16881@sgi.com>
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

On Fri, Apr 27, 2012 at 09:15:46PM -0500, Ben Myers wrote:
> I want to pull this in and have been testing toward that end.  With Jan's
> patches this seems to be working well.

Another BUG without Jan's patches:

[ 1811.832319] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[ 1811.833303] IP: [<ffffffff816ef359>] _raw_spin_lock+0x9/0x30
[ 1811.833303] PGD 128d0d067 PUD 128675067 PMD 0
[ 1811.833303] Oops: 0002 [#1] SMP
[ 1811.833303] CPU 2
[ 1811.833303] Modules linked in: xfs(O) nfsd exportfs e1000e
[ 1811.833303]
[ 1811.833303] Pid: 12942, comm: kworker/2:15 Tainted: G           O 3.4.0-rc2+ #3 SGI.COM AltixXE310/X7DGT-INF
[ 1811.833303] RIP: 0010:[<ffffffff816ef359>]  [<ffffffff816ef359>] _raw_spin_lock+0x9/0x30
[ 1811.833303] RSP: 0018:ffff880129235b40  EFLAGS: 00010286
[ 1811.833303] RAX: 0000000000000100 RBX: ffff880128685480 RCX: 0000000000000000
[ 1811.833303] RDX: 0000000f00004cb5 RSI: ffff880128685480 RDI: 0000000000000038
[ 1811.833303] RBP: ffff880129235b40 R08: ffff88012870ab00 R09: 0000000000000000
[ 1811.833303] R10: 0000000000000400 R11: 0000000000000001 R12: ffff88012870ad80
[ 1811.833303] R13: ffff880126e5c180 R14: ffff880126e5c1b0 R15: ffff880128f48780
[ 1811.833303] FS:  0000000000000000(0000) GS:ffff88012fd00000(0000) knlGS:0000000000000000
[ 1811.833303] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1811.833303] CR2: 0000000000000038 CR3: 0000000128aa2000 CR4: 00000000000007e0
[ 1811.833303] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1811.833303] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1811.833303] Process kworker/2:15 (pid: 12942, threadinfo ffff880129234000, task ffff88012ab83a80)
[ 1811.833303] Stack:
[ 1811.833303]  ffff880129235cd0 ffffffffa00b8531 0000000000000000 0000000000001000
[ 1811.833303]  0000000000000000 0000000f00004cb5 0000000000000000 0000000000000038
[ 1811.833303]  0000000000000001 0000000000000000 0000000000000000 0000000000000000
[ 1811.833303] Call Trace:
[ 1811.833303]  [<ffffffffa00b8531>] xfs_trans_committed_bulk+0x41/0x300 [xfs]
[ 1811.833303]  [<ffffffff81068c3e>] ? try_to_wake_up+0x1fe/0x280
[ 1811.833303]  [<ffffffffa00be4f6>] xlog_cil_committed+0x36/0x130 [xfs]
[ 1811.833303]  [<ffffffffa00ba07d>] xlog_state_do_callback+0x16d/0x390 [xfs]
[ 1811.833303]  [<ffffffffa00ba387>] xlog_state_done_syncing+0xe7/0x110 [xfs]
[ 1811.833303]  [<ffffffffa00bab8e>] xlog_iodone+0x7e/0x100 [xfs]
[ 1811.833303]  [<ffffffffa00562d1>] xfs_buf_iodone_work+0x21/0x50 [xfs]
[ 1811.833303]  [<ffffffff81051498>] process_one_work+0x158/0x440
[ 1811.833303]  [<ffffffffa00562b0>] ? xfs_bioerror_relse+0x80/0x80 [xfs]
[ 1811.833303]  [<ffffffff8105428b>] worker_thread+0x17b/0x410
[ 1811.833303]  [<ffffffff81054110>] ? manage_workers+0x200/0x200
[ 1811.833303]  [<ffffffff81058bce>] kthread+0x9e/0xb0
[ 1811.833303]  [<ffffffff816f8014>] kernel_thread_helper+0x4/0x10
[ 1811.833303]  [<ffffffff81058b30>] ? kthread_freezable_should_stop+0x70/0x70
[ 1811.833303]  [<ffffffff816f8010>] ? gs_change+0xb/0xb
[ 1811.833303] Code: 89 c8 f0 66 0f b1 37 66 39 c1 c9 0f 94 c0 0f b6 d0 89 d0 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 b8 00 01 00 00 48 89 e5 <f0> 66 0f c1 07 89 c2 66 c1 ea 08 38 d0 74 11 0f 1f 84 00 00 00
[ 1811.833303] RIP  [<ffffffff816ef359>] _raw_spin_lock+0x9/0x30
[ 1811.833303]  RSP <ffff880129235b40>
[ 1811.833303] CR2: 0000000000000038
[ 1812.682556] ---[ end trace b7ab7432175048af ]---

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
