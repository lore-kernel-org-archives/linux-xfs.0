Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 621A37F37
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 15:31:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 552208F8049
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 13:31:32 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7uWZrwzouKqtJgAz for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2016 13:31:29 -0800 (PST)
Date: Sat, 9 Jan 2016 08:31:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Suspend does not work with v4.4-rc8
Message-ID: <20160108213127.GS21461@dastard>
References: <20160104202611.5b100540@saldaea> <20160104194014.GD19802@dastard>
	<alpine.LNX.2.00.1601081138110.3402@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1601081138110.3402@cbobk.fhfr.pm>
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
To: Jiri Kosina <jkosina@suse.cz>
Cc: Julian Wollrath <jwollrath@web.de>, xfs@oss.sgi.com

On Fri, Jan 08, 2016 at 11:44:21AM +0100, Jiri Kosina wrote:
> On Tue, 5 Jan 2016, Dave Chinner wrote:
> 
> > > kernel: Freezing of tasks failed after 20.006 seconds (2 tasks refusing to freeze, wq_bu_busy=0):
> > > kernel: xfsaild/dm-1    S 0000000000014100     0   283      2 0x00000000
> > > kernel:  ffff880213f53e10 ffffffff8180e4c0 ffff880213f05040 0000000000000000
> > > kernel:  0000000000000000 ffff880213f54000 0000000000000000 0000000000000000
> > > kernel:  ffff8800ca389e40 ffff8800ca392000 ffff880213f53ed0 ffffffff814cd8ac
> > > kernel: Call Trace:
> > > kernel:  [<ffffffff814cd8ac>] ? schedule+0x2c/0x70
> > > kernel:  [<ffffffff8125e37d>] ? xfsaild+0x4fd/0x5b0
> > > kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> > > kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> > > kernel:  [<ffffffff8108bd18>] ? kthread+0xb8/0xd0
> > > kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> > > kernel:  [<ffffffff814d115f>] ? ret_from_fork+0x3f/0x70 
> > > kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> > > kernel: xfsaild/sda1    S 0000000000014100     0   591      2 0x00000000
> > > kernel:  ffff88021193be10 ffff8802159c4dc0 ffff880213ab9340 0000000000000000
> > > kernel:  0000000000000000 ffff88021193c000 0000000000000000 0000000000000000
> > > kernel:  ffff8800ca2a4240 ffff880214eea000 ffff88021193bed0 ffffffff814cd8ac
> > > kernel: Call Trace:
> > > kernel:  [<ffffffff814cd8ac>] ? schedule+0x2c/0x70
> > > kernel:  [<ffffffff8125e37d>] ? xfsaild+0x4fd/0x5b0
> > > kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> > > kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
> > > kernel:  [<ffffffff8108bd18>] ? kthread+0xb8/0xd0
> > > kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> > > kernel:  [<ffffffff814d115f>] ? ret_from_fork+0x3f/0x70 
> > > kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
> > > 
> > > Please tell me what more information you need to be able to fix this
> > > issue.
> > 
> > The freezer detection is broken. The thread is sleeping in schedule
> > until a wakeup occurs some time in the future, which means it cannot
> > "enter then freezer" because it's not a running thread. This is a
> > problem introduced by commit 24ba16b ("xfs: clear PF_NOFREEZE for
> > xfsaild kthread").
> > 
> > Jiri, I'm tempted just to revert this change - if the freezer
> > doesn't detect processes that are not in TASK_RUNNABLE state as
> > frozeni or can't mark them as frozen, then this change will never
> > work reliably for XFS....
> 
> Well, clearly the thread is sleeping in schedule() during the freezing 
> operation and it's supposed to be doing so; therefore it doesn't need 
> explicit freezing point, right?

No.

It's sleeping in schedule because it's got nothing more to do - it's
issued all it's IO and is idle. It is not going to run again until
filesystem modification activity is restarted.

But if the AIL still has objects in it (like it will after a sync),
then it will continue to run and issue IO until it returns to the
empty, idle state.  In this active state, we need to freeze the
thread on suspend so that it doesn't keep issuing IO all through the
suspend process...

> So the proper fix would rather be something like
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] xfs: xfsaild doesn't need to be freezable

No, that just means we guarantee that there will be suspend image
coherency problems when suspend is run on a busy filesystem...

This process is not going to enter a runable state, so is never
going to enter the freezer.  But we can't be certain of that,
because we haven't frozen the filesystem and hence it can still be
modified and this thread could be woken and do stuff when it
shouldn't.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
