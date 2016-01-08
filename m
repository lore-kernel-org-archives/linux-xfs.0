Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 83F287F37
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 04:44:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42D2E8F8040
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 02:44:27 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id mLFx7a1xvVOhiBhO (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2016 02:44:23 -0800 (PST)
Date: Fri, 8 Jan 2016 11:44:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: Suspend does not work with v4.4-rc8
In-Reply-To: <20160104194014.GD19802@dastard>
Message-ID: <alpine.LNX.2.00.1601081138110.3402@cbobk.fhfr.pm>
References: <20160104202611.5b100540@saldaea> <20160104194014.GD19802@dastard>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Julian Wollrath <jwollrath@web.de>, xfs@oss.sgi.com

On Tue, 5 Jan 2016, Dave Chinner wrote:

> > kernel: Freezing of tasks failed after 20.006 seconds (2 tasks refusing to freeze, wq_bu_busy=0):
> > kernel: xfsaild/dm-1    S 0000000000014100     0   283      2 0x00000000
> > kernel:  ffff880213f53e10 ffffffff8180e4c0 ffff880213f05040 0000000000000000
> > kernel:  0000000000000000 ffff880213f54000 0000000000000000 0000000000000000
> > kernel:  ffff8800ca389e40 ffff8800ca392000 ffff880213f53ed0 ffffffff814cd8ac
> > kernel: Call Trace:
> > kernel:  [<ffffffff814cd8ac>] ? schedule+0x2c/0x70
> > kernel:  [<ffffffff8125e37d>] ? xfsaild+0x4fd/0x5b0
> > kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> > kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> > kernel:  [<ffffffff8108bd18>] ? kthread+0xb8/0xd0
> > kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> > kernel:  [<ffffffff814d115f>] ? ret_from_fork+0x3f/0x70 
> > kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> > kernel: xfsaild/sda1    S 0000000000014100     0   591      2 0x00000000
> > kernel:  ffff88021193be10 ffff8802159c4dc0 ffff880213ab9340 0000000000000000
> > kernel:  0000000000000000 ffff88021193c000 0000000000000000 0000000000000000
> > kernel:  ffff8800ca2a4240 ffff880214eea000 ffff88021193bed0 ffffffff814cd8ac
> > kernel: Call Trace:
> > kernel:  [<ffffffff814cd8ac>] ? schedule+0x2c/0x70
> > kernel:  [<ffffffff8125e37d>] ? xfsaild+0x4fd/0x5b0
> > kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> > kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> > kernel:  [<ffffffff8108bd18>] ? kthread+0xb8/0xd0
> > kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> > kernel:  [<ffffffff814d115f>] ? ret_from_fork+0x3f/0x70 
> > kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> > 
> > Please tell me what more information you need to be able to fix this
> > issue.
> 
> The freezer detection is broken. The thread is sleeping in schedule
> until a wakeup occurs some time in the future, which means it cannot
> "enter then freezer" because it's not a running thread. This is a
> problem introduced by commit 24ba16b ("xfs: clear PF_NOFREEZE for
> xfsaild kthread").
> 
> Jiri, I'm tempted just to revert this change - if the freezer
> doesn't detect processes that are not in TASK_RUNNABLE state as
> frozeni or can't mark them as frozen, then this change will never
> work reliably for XFS....

Well, clearly the thread is sleeping in schedule() during the freezing 
operation and it's supposed to be doing so; therefore it doesn't need 
explicit freezing point, right?

So the proper fix would rather be something like



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] xfs: xfsaild doesn't need to be freezable

Commit 24ba16b ("xfs: clear PF_NOFREEZE for xfsaild kthread") introduced
clearing of the PF_NOFREEZE flag for xfsaild.

It turns out though that the normal mode of operation through the system
suspend for xfsaild is to sleep in schedule(), and therefore it doesn't
need explicit freezing point (even more so that the actual freezing point
is *just* after coming out of schedule() (and only there), which doesn't
make sense by itself either).

Let's just make xfsaild explicitly non-freezable and keep it sleep in
schedule() during system suspend, as it was before 24ba16b.

Reported-by: Dave Chinner <david@fromorbit.com>
Reported-by: Julian Wollrath <jwollrath@web.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 fs/xfs/xfs_trans_ail.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index aa67339..760d303 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -497,7 +497,6 @@ xfsaild(
 	long		tout = 0;	/* milliseconds */
 
 	current->flags |= PF_MEMALLOC;
-	set_freezable();
 
 	while (!kthread_should_stop()) {
 		if (tout && tout <= 20)
@@ -531,8 +530,6 @@ xfsaild(
 
 		__set_current_state(TASK_RUNNING);
 
-		try_to_freeze();
-
 		tout = xfsaild_push(ailp);
 	}
 
-- 
Jiri Kosina
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
