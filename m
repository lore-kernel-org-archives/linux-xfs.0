Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E058B7F3F
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 12:04:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9530FAC008
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 10:04:36 -0700 (PDT)
Received: from mail-ie0-f175.google.com (mail-ie0-f175.google.com
	[209.85.223.175]) by cuda.sgi.com with ESMTP id
	G6bGQuYlf7P2nsEY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 10:04:34 -0700 (PDT)
Received: by mail-ie0-f175.google.com with SMTP id tp5so1936778ieb.34
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 10:04:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140625140005.GB26883@htj.dyndns.org>
References: <20140513034647.GA5421@dastard>
	<CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
	<20140513063943.GQ26353@dastard>
	<CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
	<20140513090321.GR26353@dastard>
	<CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
	<CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
	<20140624030240.GB9508@dastard> <20140624032521.GA12164@htj.dyndns.org>
	<CANGgnMY5cBSXOayDbbOvqNXEG8e6sAYEjpWEQO2X8XPxx2R5-Q@mail.gmail.com>
	<20140625140005.GB26883@htj.dyndns.org>
From: Austin Schuh <austin@peloton-tech.com>
Date: Wed, 25 Jun 2014 10:04:13 -0700
Message-ID: <CANGgnMb_eqipXLhJfvDjWywG2xxFSiEPySiuYz=mvU94h0P6sw@mail.gmail.com>
Subject: Re: On-stack work item completion race? (was Re: XFS crash?)
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
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, xfs <xfs@oss.sgi.com>

On Wed, Jun 25, 2014 at 7:00 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, Jun 24, 2014 at 08:05:07PM -0700, Austin Schuh wrote:
> > > I can see no reason why manual completion would behave differently
> > > from flush_work() in this case.
> >
> > I went looking for a short trace in my original log to show the problem,
> > and instead found evidence of the second problem.  I still like the shorter
> > flush_work call, but that's not my call.
>
> So, are you saying that the original issue you reported isn't actually
> a problem?  But didn't you imply that changing the waiting mechanism
> fixed a deadlock or was that a false positive?

Correct, that was a false positive.  Sorry for the noise.

> > I spent some more time debugging, and I am seeing that tsk_is_pi_blocked is
> > returning 1 in sched_submit_work (kernel/sched/core.c).  It looks
> > like sched_submit_work is not detecting that the worker task is blocked on
> > a mutex.
>
> The function unplugs the block layer and doesn't have much to do with
> workqueue although it has "_work" in its name.

Thomas moved
+ if (tsk->flags & PF_WQ_WORKER)
+   wq_worker_sleeping(tsk);
into sched_submit_work as part of the RT patchset.

> > This looks very RT related right now.  I see 2 problems from my reading
> > (and experimentation).  The first is that the second worker isn't getting
> > started because tsk_is_pi_blocked is reporting that the task isn't blocked
> > on a mutex.  The second is that even if another worker needs to be
> > scheduled because the original worker is blocked on a mutex, we need the
> > pool lock to schedule another worker.  The pool lock can be acquired by any
> > CPU, and is a spin_lock.  If we end up on the slow path for the pool lock,
> > we hit BUG_ON(rt_mutex_real_waiter(task->pi_blocked_on))
> > in task_blocks_on_rt_mutex in rtmutex.c.  I'm not sure how to deal with
> > either problem.
> >
> > Hopefully I've got all my facts right...  Debugging kernel code is a whole
> > new world from userspace code.
>
> I don't have much idea how RT kernel works either.  Can you reproduce
> the issues that you see on mainline?
>
> Thanks.
>
> --
> tejun

I'll see what I can do.

Thanks!
  Austin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
