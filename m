Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q86C69uC060741 for <xfs@oss.sgi.com>; Thu, 6 Sep 2012 07:06:09 -0500
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	RDBg8Q76YpXaGP0H (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Sep 2012 05:07:08 -0700 (PDT)
Received: by ieak12 with SMTP id k12so2922270iea.26
	for <xfs@oss.sgi.com>; Thu, 06 Sep 2012 05:07:07 -0700 (PDT)
Message-ID: <504891EB.2090202@inktank.com>
Date: Thu, 06 Sep 2012 07:07:07 -0500
From: Alex Elder <elder@inktank.com>
MIME-Version: 1.0
Subject: Oops from unlock in xfs_trans_ail_delete_bulk()
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

I'm trying to capture something useful here because I need to move
on with what I'm doing.  I was running xfstests using a kernel with
this as the latest commit affecting fs/xfs:

    commit a0e881b7c189fa2bd76c024dbff91e79511c971d
    Merge: eff0d13 dbc6e02
    Author: Linus Torvalds <torvalds@linux-foundation.org>
    Date:   Wed Aug 1 10:26:23 2012 -0700

    Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/vi

While running test 135 (it had started but its completion time had
not yet been reported) I got an oops whose details I'll include below.

My console window isn't properly wrapping long lines so some info
has been truncated below.  The fault address is at
__ticket_spin_is_locked+0x10, called via xfs_trans_ail_delete_bulk().

I may be able to offer a little more information if someone is
interested, and if I find this is repeatable I will certainly
report it.

					-Alex

Entering kdb (current=0xffff880224130000, pid 1413) on processor 5 Oops:
(null)
due to oops @ 0xffffffff81042c40
CPU 5 dPid: 1413, comm: kworker/5:1H Not tainted
3.6.0-rc2-ceph-00203-gacf44c98
dRIP: 0010:[<ffffffff81042c40>]  [<ffffffff81042c40>]
__ticket_spin_unlock+0x10
dRSP: 0018:ffff88020c603c18  EFLAGS: 00010202
dRAX: 0000000000000000 RBX: ffff880223762e00 RCX: 0000000000000001
dRDX: 0000000000000001 RSI: ffff8802211b54d8 RDI: 00750001007f006b
dRBP: ffff88020c603c30 R08: dead000000100100 R09: dead000000200200
dR10: 0000000000000000 R11: 0000000000000001 R12: 0003000000000000
dR13: 0000000000000008 R14: ffff880223762210 R15: ffff8802211b54d8
dFS:  0000000000000000(0000) GS:ffff8802272a0000(0000)
knlGS:0000000000000000
dCS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
dCR2: 00007f5c17c59120 CR3: 0000000001c0b000 CR4: 00000000000007e0
dDR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
dDR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
dProcess kworker/5:1H (pid: 1413, threadinfo ffff88020c602000, task
ffff880224)
dStack:
 ffffffffa09853ac ffff880223762200 ffff88020c603ca8 ffff88020c603c90
 ffffffffa098b7a5 0000000000000000 ffff880200000000 0000000000000000
 ffff8802211b54d8 ffff88020c603c90 ffff8802211b54d8 ffff880223762200
dCall Trace:
d [<ffffffffa09853ac>] ? xlog_assign_tail_lsn_locked+0x2c/0x70 [xfs]
more>
d [<ffffffffa098b7a5>] xfs_trans_ail_delete_bulk+0x1a5/0x1d0 [xfs]
d [<ffffffffa0989375>] xfs_buf_iodone+0x45/0x60 [xfs]
d [<ffffffffa098812c>] xfs_buf_do_callbacks+0x3c/0x50 [xfs]
d [<ffffffffa0988326>] xfs_buf_iodone_callbacks+0x46/0x230 [xfs]
d [<ffffffffa092ecf3>] xfs_buf_iodone_work+0x23/0x50 [xfs]
d [<ffffffff81071840>] process_one_work+0x1a0/0x5f0
d [<ffffffff810717d6>] ? process_one_work+0x136/0x5f0
d [<ffffffffa092ecd0>] ? xfs_buf_get_map+0x1a0/0x1a0 [xfs]
d [<ffffffff8107360d>] worker_thread+0x18d/0x4c0
d [<ffffffff81129f50>] ? __lock_page+0x70/0x70
d [<ffffffff81073480>] ? manage_workers.isra.22+0x2c0/0x2c0
d [<ffffffff810791ee>] kthread+0xae/0xc0
d [<ffffffff810b379d>] ? trace_hardirqs_on+0xd/0x10
d [<ffffffff8163e744>] kernel_thread_helper+0x4/0x10
d [<ffffffff81635430>] ? retint_restore_args+0x13/0x13
d [<ffffffff81079140>] ? flush_kthread_work+0x1a0/0x1a0
d [<ffffffff8163e740>] ? gs_change+0x13/0x13
dCode: 00 89 d0 f0 66 0f b1 0f 66 39 d0 0f 94 c0 0f b6 c0 5d c3 0f 1f
84 00 00

[5]kdb> 0xffffffff81042c40
0xffffffff81042c40 = 0xffffffff81042c40 (__ticket_spin_is_locked)
[5]kdb> md1c128 0xffffffff81042c00
0xffffffff81042c00 0f b7 17 55 31 c0 48 89 e5 38 d6 74 03 5d c3 90
...U1.H..8.
0xffffffff81042c10 8d 8a 00 01 00 00 89 d0 f0 66 0f b1 0f 66 39 d0
.........f.
0xffffffff81042c20 0f 94 c0 0f b6 c0 5d c3 0f 1f 84 00 00 00 00 00
......]....
0xffffffff81042c30 55 48 89 e5 80 07 01 5d c3 0f 1f 80 00 00 00 00
UH.....]...
0xffffffff81042c40 0f b7 07 55 48 89 e5 5d 38 c4 0f 95 c0 0f b6 c0
...UH..]8..
0xffffffff81042c50 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
.ffffff....
0xffffffff81042c60 0f b7 07 55 48 89 e5 5d 0f b6 d4 28 c2 80 fa 01
...UH..]...
0xffffffff81042c70 0f 97 c0 0f b6 c0 c3 66 0f 1f 84 00 00 00 00 00
.......f...
[5]kdb> 0xffffffff81042c30
0xffffffff81042c30 = 0xffffffff81042c30 (__ticket_spin_unlock)
[5]kdb>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
