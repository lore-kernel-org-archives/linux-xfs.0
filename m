Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 014027F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 17:28:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D28B0304048
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 15:28:38 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EwbokuT1iL9aQ2ay for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 15:28:36 -0800 (PST)
Date: Sat, 10 Jan 2015 10:28:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150109232815.GL31508@dastard>
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150109182310.GA2785@htj.dyndns.org>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jan 09, 2015 at 01:23:10PM -0500, Tejun Heo wrote:
> Hello, Eric.
> 
> On Fri, Jan 09, 2015 at 12:12:04PM -0600, Eric Sandeen wrote:
> > I had a case reported where a system under high stress
> > got deadlocked.  A btree split was handed off to the xfs
> > allocation workqueue, and it is holding the xfs_ilock
> > exclusively.  However, other xfs_end_io workers are
> > not running, because they are waiting for that lock.
> > As a result, the xfs allocation workqueue never gets
> > run, and everything grinds to a halt.
> 
> I'm having a difficult time following the exact deadlock.  Can you
> please elaborate in more detail?

process A			kworker (1..N)
ilock(excl)
alloc
  queue work(allocwq)
    (work queued as no kworker
     threads available)
     				execute work from xfsbuf-wq
     				xfs_end_io
				  ilock(excl)
				    (blocks waiting on queued work)

No new kworkers are started, so the queue never makes progress,
we deadlock.

AFAICT, the only way we can get here is that we have N idle
kworkers, and N+M works get queued where the allocwq work is at the
tail end of the queue. This results in newly queued work is not
kicking a new kworker threadi as there are idle threads, and as
works are executed the are all for the xfsbuf-wq and blocking on the
ilock(excl).

We eventually get to the point where there are no more idle
kworkers, but we still have works queued, and progress is still
dependent the queued works completing....

This is actually not an uncommon queuing occurrence, because we
can get storms of end-io works queued from batched IO completion
processing.

> > To be honest, it's not clear to me how the workqueue
> > subsystem manages this sort of thing.  But in testing,
> > making the allocation workqueue high priority so that
> > it gets added to the front of the pending work list,
> > resolves the problem.  We did similar things for
> > the xfs-log workqueues, for similar reasons.
> 
> Ummm, this feel pretty voodoo.  In practice, it'd change the order of
> things being executed and may make certain deadlocks unlikely enough,
> but I don't think this can be a proper fix.

Right, that's why Eric approached about this a few weeks ago asking
whether it could be fixed in the workqueue code.

As I've said before (in years gone by), we've got multiple levels of
priority needed for executing XFS works because of lock ordering
requirements. We *always* want the allocation workqueue work to run
before the end-io processing of the xfsbuf-wq and unwritten-wq
because of this lock inversion, just like we we always want the
xfsbufd to run before the unwritten-wq because unwritten extent
conversion may block waiting for metadata buffer IO to complete, and
we always want the the xfslog-wq works to run before all of them
because metadata buffer IO may get blocked waiting for buffers
pinned by the log to be unpinned for log Io completion...

We solve these dependencies in a sane manner with a single high
priority workqueue level, so we're stuck with hacking around the
worst of the problems for the moment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
