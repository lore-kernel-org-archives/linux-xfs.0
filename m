Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8794VeW233255 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 04:04:32 -0500
Received: from hera.kernel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A8711E5F6A7
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 02:05:13 -0700 (PDT)
Received: from hera.kernel.org (hera.kernel.org [140.211.167.34]) by
	cuda.sgi.com with ESMTP id LppMpGcHDlASuJeU for
	<xfs@oss.sgi.com>; Tue, 07 Sep 2010 02:05:13 -0700 (PDT)
Message-ID: <4C86003B.6090706@kernel.org>
Date: Tue, 07 Sep 2010 11:04:59 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard>
In-Reply-To: <20100907072954.GM705@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello,

On 09/07/2010 09:29 AM, Dave Chinner wrote:
> 1. I have had xfstests deadlock twice via #3, once on 2.6.36-rc2,
> and once on 2.6.36-rc3. This is clearly a regression, but it is not
> caused by any XFS changes since 2.6.35.  From what I can tell from
> the backtraces I saw was that it appears that the delaying of the
> data IO completion processing by requeuing does not allow the
> workqueue to move off the kworker thread. As a result, any work that
> is still queued on that kworker queue appears to be starved, and
> hence we never get the log workqueue processed that would allow data
> IO completion processing to make progress.

This is puzzling.  Queueing order shouldn't have changed.  Maybe I
screwed up queueing order handling of delayed works.  Which workqueue
is this?  Or better, can you give me a small test case which
reproduces the problem?

> 2. I have circumstantial evidence that #4 is contributing to
> several minute long livelocks. This is intertwined with memory
> reclaim and lock contention, but fundamentally log IO completion
> processing is being blocked for extremely long periods of time
> waiting for a kworker thread to start processing them.  In this
> case, I'm creating close to 100,000 inodes every second, and they
> are getting written to disk. There is a burst of log IO every 3s or
> so, so the log Io completion is getting queued behind at least tens
> of thousands of inode IO completion work items. These work
> completion items are generating lock contention which slows down
> processing even further. The transaciton subsystem stalls completely
> while it waits for log IO completion to be processed. AFAICT, this
> did not happen on 2.6.35.

Creating the workqueue for log completion w/ WQ_HIGHPRI should solve
this.

> XFS has used workqueues for these "separate processing threads"
> because they were a simple primitve that provided the separation and
> isolation guarantees that XFS IO completion processing required.
> That is, work deferred from one processing queue to another would
> not block the original queue, and queues can be blocked
> independently of the processing of other queues.

Semantically, that property is (or should be) preserved.  The
scheduling properties change tho and if the code has been depending on
more subtile aspects of work scheduling, it will definitely need to be
adjusted.

>>From what I can tell of the new kworker thread based implementation,
> I cannot see how it provides the same work queue separation,
> blocking and isolation guarantees. If we block during work
> processing, then anything on the queue for that thread appears to be
> blocked from processing until the work is unblocked.

I fail to follow here.  Can you elaborate a bit?

> Hence my main concern is that the new work queue implementation does
> not provide the same semantics as the old workqueues, and as such
> re-introduces a class of problems that will cause random hangs and
> other bad behaviours on XFS filesystems under heavy load.

I don't think it has that level of fundamental design flaw.

> Hence, I'd like to know if my reading of the new workqueue code is
> correct and:

Probably not.

> 	a) if not, understand why the workqueues are deadlocking;

Yeah, let's track this one down.

> 	c) understand how we can prioritise log IO completion
> 	processing over data, metadata and unwritten extent IO
> 	completion processing; and

As I wrote above, WQ_HIGHPRI is there for you.

> 	d) what can be done before 2.6.36 releases.

To preserve the original behavior, create_workqueue() and friends
create workqueues with @max_active of 1, which is pretty silly and bad
for latency.  Aside from fixing the above problems, it would be nice
to find out better values for @max_active for xfs workqueues.  For
most users, using the pretty high default value is okay as they
usually have much stricter constraint elsewhere (like limited number
of work_struct), but last time I tried xfs allocated work_structs and
fired them as fast as it could, so it looked like it definitely needed
some kind of resasonable capping value.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
