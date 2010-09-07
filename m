Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o877TJah229523 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 02:29:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BBE152334
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 00:30:02 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	7QuDRAA591raP2D7 for <xfs@oss.sgi.com>;
	Tue, 07 Sep 2010 00:30:02 -0700 (PDT)
Date: Tue, 7 Sep 2010 17:29:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
Message-ID: <20100907072954.GM705@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi Tejun,

I've got a few concerns about workqueue consolidation it has gone
into 2.6.36-rc and the way XFS has been using workqueues for
concurrency and deadlock avoidance in IO completion. To give you an
idea of the complex dependencies of the IO completion workqueues XFS
uses, I'll start by describing the major deadlock iand latency
issues that they were crafted to avoid:

1. XFS used separate processing threads to prevent deadlocks between
data and log IO completion processing. The deadlock is as follows:

	- inode locked in transaction
	- transaction commit triggers writes to log buffer
	- log buffer write blocks because all log buffers are under
	  IO
	- log IO completion queued behind data IO completion
	- data IO completion blocks on inode lock held by
	  transaction blocked waiting for log IO.

This has been avoided by log IO completion processing being placed
in a separate processing workqueue so they do not get blocked behind
data IO completion. XFS has used this separation of IO completion
processing since this deadlock was discovered in the late 90s on
Irix.

2. XFS used separate threads to avoid OOM deadlocks on unwritten
extent conversion. The deadlock is as follows:

	- data IO into unwritten extent completes
	- unwritten extent conversion starts a transaction
	- transaction requires memory allocation
	- data IO to complete cleaning of dirty pages (say issued by
	  kswapd) gets queued up behind unwritten extent conversion
	  processing
	- data IO completion stalls
	- system goes (B)OOM

XFS pushes unwritten extent conversion off into a separate
processing thread so that it doesn't block other data IO completion
needed to clean pages and hence avoids the OOM deadlock in these
cases.

3. Loop devices turn log IO into data IO on backing filesystem. This
leads to deadlocks because:

	- transaction on loop device holds inode locked, commit
	  blocks waiting for log IO. Log-IO-on-loop-device is turned
	  into data-IO-on-backing-device.
	- data-IO-on-loop-device completes, blocks taking inode lock
	  to update file size.
	- data-IO-on-backing-device for the log-IO-on-loop-device
	  gets queued behind blocked data-IO-on-loop-device
	  completion. Deadlocks loop device and IO completion
	  processing thread.

XFS has worked around this deadlock by using try-lock semantics for
the inode lock on data IO completion, and if it fails we backoff by
sleeping for a jiffie and requeuing the work back to the tail of the
work queue. This works perfectly well for a dedicated set of
processing threads as the only impact is on XFS....

4. XFS used separate threads to minimise log IO completion latency

Queuing log IO completion behind thousands of data and metadata IO
completions stalls the entire transaction subsystem until the log IO
completion is done. By having separate processing threads, log IO
completion processing is not delayed by having to first wait for
data/metadata IO completion processing. This delay can be
significant because XFS can have thousands of IOs in flight at a
time and IO completion processing backlog can extend to tens to
hundreds of thousands of objects that have to be processed every
second.

-----

So, with those descriptions out of the way, I've seen the following
problems in the past week or so:

1. I have had xfstests deadlock twice via #3, once on 2.6.36-rc2,
and once on 2.6.36-rc3. This is clearly a regression, but it is not
caused by any XFS changes since 2.6.35.  From what I can tell from
the backtraces I saw was that it appears that the delaying of the
data IO completion processing by requeuing does not allow the
workqueue to move off the kworker thread. As a result, any work that
is still queued on that kworker queue appears to be starved, and
hence we never get the log workqueue processed that would allow data
IO completion processing to make progress.

2. I have circumstantial evidence that #4 is contributing to
several minute long livelocks. This is intertwined with memory
reclaim and lock contention, but fundamentally log IO completion
processing is being blocked for extremely long periods of time
waiting for a kworker thread to start processing them.  In this
case, I'm creating close to 100,000 inodes every second, and they
are getting written to disk. There is a burst of log IO every 3s or
so, so the log Io completion is getting queued behind at least tens
of thousands of inode IO completion work items. These work
completion items are generating lock contention which slows down
processing even further. The transaciton subsystem stalls completely
while it waits for log IO completion to be processed. AFAICT, this
did not happen on 2.6.35.

This also seems to be correlated memory starvation because we can't
free any memory until the log subsystem comes alive again and allows
all the pinned metadata and transaction structures to be freed (can
be tens to hundreds of megabytes of memory).

http://marc.info/?l=linux-kernel&m=128374586809180&w=2
http://marc.info/?l=linux-kernel&m=128380988716141&w=2

----

XFS has used workqueues for these "separate processing threads"
because they were a simple primitve that provided the separation and
isolation guarantees that XFS IO completion processing required.
That is, work deferred from one processing queue to another would
not block the original queue, and queues can be blocked
independently of the processing of other queues.

>From what I can tell of the new kworker thread based implementation,
I cannot see how it provides the same work queue separation,
blocking and isolation guarantees. If we block during work
processing, then anything on the queue for that thread appears to be
blocked from processing until the work is unblocked.

Hence my main concern is that the new work queue implementation does
not provide the same semantics as the old workqueues, and as such
re-introduces a class of problems that will cause random hangs and
other bad behaviours on XFS filesystems under heavy load.

Hence, I'd like to know if my reading of the new workqueue code is
correct and:

	a) if not, understand why the workqueues are deadlocking;
	b) if so, understand what needs to be done to solve the
	deadlocks;
	c) understand how we can prioritise log IO completion
	processing over data, metadata and unwritten extent IO
	completion processing; and
	d) what can be done before 2.6.36 releases.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
