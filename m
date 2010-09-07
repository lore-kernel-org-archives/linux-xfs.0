Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o87AZAru237013 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 05:35:10 -0500
Received: from hera.kernel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6F715292C
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 03:35:53 -0700 (PDT)
Received: from hera.kernel.org (hera.kernel.org [140.211.167.34]) by
	cuda.sgi.com with ESMTP id j5w01qcr9MUyuIOQ for
	<xfs@oss.sgi.com>; Tue, 07 Sep 2010 03:35:53 -0700 (PDT)
Message-ID: <4C861582.6080102@kernel.org>
Date: Tue, 07 Sep 2010 12:35:46 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org>
	<20100907100108.GN705@dastard>
In-Reply-To: <20100907100108.GN705@dastard>
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

On 09/07/2010 12:01 PM, Dave Chinner wrote:
> The three workqueues are initialised in
> fs/xfs/linux-2.6/xfs_buf.c::xfs_buf_init().
>
> They do not use delayed works, the requeuing of interest here
> occurs in .../xfs_aops.c::xfs_end_io via
> .../xfs_aops.c:xfs_finish_ioend() onto the xfsdatad_workqueue

Oh, I was talking about cwq->delayed_works which is a mechanism which
is used to enforce max_active among other things.

>> Or better, can you give me a small test case which
>> reproduces the problem?
> 
> I've seen it twice in about 100 xfstests runs in the past week.
> I can't remember the test that tripped over it - 078 I think did
> once, and it was a different test the first time - only some tests
> use the loopback device. We've never had a reliable reproducer
> because of the complexity of the race condition that leads to
> the deadlock....

I see.

>> Creating the workqueue for log completion w/ WQ_HIGHPRI should solve
>> this.
> 
> So what you are saying is that we need to change the workqueue
> creation interface to use alloc_workqueue() with some special set of
> flags to make the workqueue behave as we want, and that each
> workqueue will require a different configuration?  Where can I find
> the interface documentation that describes how the different flags
> affect the workqueue behaviour?

Heh, sorry about that.  I'm writing it now.  The plan is to audit all
the create_*workqueue() users and replace them with alloc_workqueue()
w/ appropriate parameters.  Most of them would be fine with the
default set of parameters but there are a few which would need some
adjustments.

>> I fail to follow here.  Can you elaborate a bit?
> 
> Here's what the work function does:
> 
>  -> run @work
> 	-> trylock returned EAGAIN
> 	-> queue_work(@work)
> 	-> delay(1); // to stop workqueue spinning chewing up CPU
>
> So basically I'm seeing a kworker thread blocked in delay(1) - it's
> appears to be making progress by processing the same work item over and over
> again with delay(1) calls between them. The queued log IO completion
> is not being processed, even though it is sitting in a queue
> waiting...

Can you please help me a bit more?  Are you saying the following?

Work w0 starts execution on wq0.  w0 tries locking but fails.  Does
delay(1) and requeues itself on wq0 hoping another work w1 would be
queued on wq0 which will release the lock.  The requeueing should make
w0 queued and executed after w1, but instead w1 never gets executed
while w0 hogs the CPU constantly by re-executing itself.  Also, how
does delay(1) help with chewing up CPU?  Are you talking about
avoiding constant lock/unlock ops starving other lockers?  In such
case, wouldn't cpu_relax() make more sense?

>> To preserve the original behavior, create_workqueue() and friends
>> create workqueues with @max_active of 1, which is pretty silly and bad
>> for latency.  Aside from fixing the above problems, it would be nice
>> to find out better values for @max_active for xfs workqueues.  For
> 
> Um, call me clueless, but WTF does max_active actually do?

It regulates the maximum level of per-cpu concurrency.  ie. If a
workqueue has @max_active of 16.  16 works on the workqueue may
execute concurrently per-cpu.

> It's not described anywhere, it's clamped to magic numbers ("I
> really like 512"), etc.

Yeap, that's just a random safety value I chose.  In most cases, the
level of concurrency is limited by the number of work_struct, so the
default limit is there just to survive complete runaway cases.

>> most users, using the pretty high default value is okay as they
>> usually have much stricter constraint elsewhere (like limited number
>> of work_struct), but last time I tried xfs allocated work_structs and
>> fired them as fast as it could, so it looked like it definitely needed
>> some kind of resasonable capping value.
> 
> What part of XFS fired work structures as fast as it could? Queuing
> rates are determined completely by the IO completion rates...

I don't remember but once I increased maximum concurrency for every
workqueue (the limit was 128 or something) and xfs pretty quickly hit
the concurrency limit.  IIRC, there was a function which allocates
work_struct and schedules it.  I'll look through the emails.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
