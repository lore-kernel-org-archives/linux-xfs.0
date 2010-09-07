Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o87CmFfD242374 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 07:48:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B278352FDE
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 05:48:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	mJESllduIeQ8eh6O for <xfs@oss.sgi.com>;
	Tue, 07 Sep 2010 05:48:57 -0700 (PDT)
Date: Tue, 7 Sep 2010 22:48:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
Message-ID: <20100907124850.GP705@dastard>
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org>
	<20100907100108.GN705@dastard> <4C861582.6080102@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C861582.6080102@kernel.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 07, 2010 at 12:35:46PM +0200, Tejun Heo wrote:
> On 09/07/2010 12:01 PM, Dave Chinner wrote:
> >> Creating the workqueue for log completion w/ WQ_HIGHPRI should solve
> >> this.
> > 
> > So what you are saying is that we need to change the workqueue
> > creation interface to use alloc_workqueue() with some special set of
> > flags to make the workqueue behave as we want, and that each
> > workqueue will require a different configuration?  Where can I find
> > the interface documentation that describes how the different flags
> > affect the workqueue behaviour?
> 
> Heh, sorry about that.  I'm writing it now.  The plan is to audit all
> the create_*workqueue() users and replace them with alloc_workqueue()
> w/ appropriate parameters.  Most of them would be fine with the
> default set of parameters but there are a few which would need some
> adjustments.

Ok. Do you have an advance draft of the docco I can read?

> >> I fail to follow here.  Can you elaborate a bit?
> > 
> > Here's what the work function does:
> > 
> >  -> run @work
> > 	-> trylock returned EAGAIN
> > 	-> queue_work(@work)
> > 	-> delay(1); // to stop workqueue spinning chewing up CPU
> >
> > So basically I'm seeing a kworker thread blocked in delay(1) - it's
> > appears to be making progress by processing the same work item over and over
> > again with delay(1) calls between them. The queued log IO completion
> > is not being processed, even though it is sitting in a queue
> > waiting...
> 
> Can you please help me a bit more?  Are you saying the following?
> 
> Work w0 starts execution on wq0.  w0 tries locking but fails.  Does
> delay(1) and requeues itself on wq0 hoping another work w1 would be
> queued on wq0 which will release the lock.  The requeueing should make
> w0 queued and executed after w1, but instead w1 never gets executed
> while w0 hogs the CPU constantly by re-executing itself.

Almost. What happens is that there is a queue of data IO
completions on q0, say w1...wN where wX is in the middle of the
queue. wX requires lock A, but lock A is held by a a transaction
commit that is blocked by IO completion t1 on q1. The dependency
chain we then have is:

	wX on q0 -> lock A -> t1 on q1

To prevent wX from blocking q0, when lock A is not gained, we
requeue wX to the tail of q0 such that the queue is not wX+1..wN,wX.
this means that wX will not block completion processing of data IO.
If wX is the only work on q0, then to stop the work queue from
spinning processing wX, queueing wX, processing wX.... there is a
delay(1) call to allow some time for other IOs to complete to occur
before trying again to process wX again.

At some point, q1 is processed and t1 is run and lock A
released. Once this happens, wX will gain lock A and finish the
completion and be freed.

The issue I appear to be seeing is that while q0 is doing:

	wX -> requeue on q0 -> delay(1) -> wX -> requeue q0 -> wX

q1 which contains t1 is never getting processed, and hence the q0/wX
loop is never getting broken.

> Also, how
> does delay(1) help with chewing up CPU?  Are you talking about
> avoiding constant lock/unlock ops starving other lockers?  In such
> case, wouldn't cpu_relax() make more sense?

Basically delay(1) is used in many places in XFS as a "backoff and
retry after a short period of time" mechanism in places where
blocking would lead to deadlock or we need a state change to occur
before retrying the operation that would have deadlocked. If we
don't put a backoff in, then we simply burn CPU until the condition
clears.

In the case of the data Io completion workqueue processing, the CPU
burn occurred when the only item on the workqueue was the inode that
we could not lock.  Hence the backoff. It's not a great solution,
but it's the only one that could be sued without changing everything
to use delayed works and hence suffer the associated structure bloat
for what is a rare corner case....

As I said, this is fine if the only thing that is delayed is data IO
completion processing for XFS. When it is a generic kworker thread,
it has much greater impact, I think....

> >> To preserve the original behavior, create_workqueue() and friends
> >> create workqueues with @max_active of 1, which is pretty silly and bad
> >> for latency.  Aside from fixing the above problems, it would be nice
> >> to find out better values for @max_active for xfs workqueues.  For
> > 
> > Um, call me clueless, but WTF does max_active actually do?
> 
> It regulates the maximum level of per-cpu concurrency.  ie. If a
> workqueue has @max_active of 16.  16 works on the workqueue may
> execute concurrently per-cpu.
> 
> > It's not described anywhere, it's clamped to magic numbers ("I
> > really like 512"), etc.
> 
> Yeap, that's just a random safety value I chose.  In most cases, the
> level of concurrency is limited by the number of work_struct, so the
> default limit is there just to survive complete runaway cases.

Ok, make sense now. I wish that was already in a comment in the code ;)

> >> most users, using the pretty high default value is okay as they
> >> usually have much stricter constraint elsewhere (like limited number
> >> of work_struct), but last time I tried xfs allocated work_structs and
> >> fired them as fast as it could, so it looked like it definitely needed
> >> some kind of resasonable capping value.
> > 
> > What part of XFS fired work structures as fast as it could? Queuing
> > rates are determined completely by the IO completion rates...
> 
> I don't remember but once I increased maximum concurrency for every
> workqueue (the limit was 128 or something) and xfs pretty quickly hit
> the concurrency limit.  IIRC, there was a function which allocates
> work_struct and schedules it.  I'll look through the emails.

How do you get concurrency requirements of 128 when you only have a
small number of CPUs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
