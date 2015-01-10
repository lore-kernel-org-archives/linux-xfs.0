Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5EEFF7F47
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2015 11:41:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D01E304032
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2015 09:41:38 -0800 (PST)
Received: from mail-qc0-f172.google.com (mail-qc0-f172.google.com
	[209.85.216.172]) by cuda.sgi.com with ESMTP id
	cHakqoxQZQ1pGCG8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 10 Jan 2015 09:41:37 -0800 (PST)
Received: by mail-qc0-f172.google.com with SMTP id m20so13377006qcx.3
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2015 09:41:36 -0800 (PST)
Date: Sat, 10 Jan 2015 12:41:33 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150110174133.GC25319@htj.dyndns.org>
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
	<20150109232815.GL31508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150109232815.GL31508@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Hello, Dave.

On Sat, Jan 10, 2015 at 10:28:15AM +1100, Dave Chinner wrote:
> process A			kworker (1..N)
> ilock(excl)
> alloc
>   queue work(allocwq)
>     (work queued as no kworker
>      threads available)
>      				execute work from xfsbuf-wq
>      				xfs_end_io
> 				  ilock(excl)
> 				    (blocks waiting on queued work)
> 
> No new kworkers are started, so the queue never makes progress,
> we deadlock.

But allocwq is a separate workqueue from xfsbuf-wq and should have its
own rescuer.  The work item queued by process on A is guaranteed to
make forward progress no matter what work items on xfsbuf-wq are
doing.  The deadlock as depicted above cannot happen.  A workqueue
with WQ_MEM_RECLAIM can deadlock iff an executing work item on the
workqueue deadlocks.

> AFAICT, the only way we can get here is that we have N idle
> kworkers, and N+M works get queued where the allocwq work is at the
> tail end of the queue. This results in newly queued work is not
> kicking a new kworker threadi as there are idle threads, and as
> works are executed the are all for the xfsbuf-wq and blocking on the
> ilock(excl).

The workqueue doesn't work that way.  Forward progress guarantee is
separate for each workqueue with WQ_MEM_RECLAIM set.  Each is
guaranteed to make forward progress indepdently of what others are
doing.

> We eventually get to the point where there are no more idle
> kworkers, but we still have works queued, and progress is still
> dependent the queued works completing....
> 
> This is actually not an uncommon queuing occurrence, because we
> can get storms of end-io works queued from batched IO completion
> processing.

And all these have nothing to with why the deadlock is happening.

> > Ummm, this feel pretty voodoo.  In practice, it'd change the order of
> > things being executed and may make certain deadlocks unlikely enough,
> > but I don't think this can be a proper fix.
> 
> Right, that's why Eric approached about this a few weeks ago asking
> whether it could be fixed in the workqueue code.
> 
> As I've said before (in years gone by), we've got multiple levels of
> priority needed for executing XFS works because of lock ordering
> requirements. We *always* want the allocation workqueue work to run

There's no problem there - create a separate WQ_MEM_RECLAIM workqueue
at each priority level.  Each is guaranteed to make forward progress
and as long as the dependency graph isn't looped, the whole thing is
guaranteed to make forward progress.

> before the end-io processing of the xfsbuf-wq and unwritten-wq
> because of this lock inversion, just like we we always want the
> xfsbufd to run before the unwritten-wq because unwritten extent
> conversion may block waiting for metadata buffer IO to complete, and
> we always want the the xfslog-wq works to run before all of them
> because metadata buffer IO may get blocked waiting for buffers
> pinned by the log to be unpinned for log Io completion...

I'm not really following your logic here.  Are you saying that xfs is
trying to work around cyclic dependency by manipulating execution
order of specific work items?

> We solve these dependencies in a sane manner with a single high
> priority workqueue level, so we're stuck with hacking around the
> worst of the problems for the moment.

I'm afraid I'm lost.  Sans bugs in the rescuer logic, each workqueue
with WQ_MEM_RECLAIM guarantees forward progress of a single work item
at any given time.  If there are dependencies among the work items,
each node of the dependency graph should correspond to a separate
workqueue.  As long as the dependency graph isn't cyclic, the whole is
guaranteed to make forward progress.

There no reason to play with priorities to avoid deadlock.  That
doesn't make any sense to me.  Priority or chained queueing, which is
a lot better way to do it, can be used to optimize queueing and
execution behavior if one set of work items are likely to wait on
another set, but that should have *NOTHING* to do with deadlock
avoidance.

If the dependency graph is cyclic, it will deadlock.  If not, it
won't.  It's as simple as that.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
