Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B2CB07CA0
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 15:34:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88F0D304043
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 13:33:58 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	uoj9oOBALJUPXleC for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 13:33:55 -0800 (PST)
Date: Tue, 8 Mar 2016 08:33:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/2] percpu_counter: Enable switching to global counter
Message-ID: <20160307213340.GU30721@dastard>
References: <1457146299-1601-1-git-send-email-Waiman.Long@hpe.com>
	<20160305063447.GB2235@devil.localdomain>
	<56DDBCEB.8060307@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56DDBCEB.8060307@hpe.com>
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
To: Waiman Long <waiman.long@hpe.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Scott J Norton <scott.norton@hp.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, Douglas Hatch <doug.hatch@hp.com>, Dave Chinner <dchinner@redhat.com>, Tejun Heo <tj@kernel.org>

On Mon, Mar 07, 2016 at 12:39:55PM -0500, Waiman Long wrote:
> On 03/05/2016 01:34 AM, Dave Chinner wrote:
> >On Fri, Mar 04, 2016 at 09:51:37PM -0500, Waiman Long wrote:
> >>This patchset allows the degeneration of per-cpu counters back
> >>to global counters when:
> >>
> >>  1) The number of CPUs in the system is large, hence a high
> >>  cost for calling percpu_counter_sum().  2) The initial count
> >>  value is small so that it has a high chance of excessive
> >>  percpu_counter_sum() calls.
> >>
> >>When the above 2 conditions are true, this patchset allows the
> >>user of per-cpu counters to selectively degenerate them into
> >>global counters with lock. This is done by calling the new
> >>percpu_counter_set_limit() API after percpu_counter_set().
> >>Without this call, there is no change in the behavior of the
> >>per-cpu counters.
> >>
> >>Patch 1 implements the new percpu_counter_set_limit() API.
> >>
> >>Patch 2 modifies XFS to call the new API for the m_ifree and
> >>m_fdblocks per-cpu counters.
> >>
> >>Waiman Long (2): percpu_counter: Allow falling back to global
> >>counter on large system xfs: Allow degeneration of
> >>m_fdblocks/m_ifree to global counters
> >NACK.
> >
> >This change to turns off per-counter free block counters for 32p
> >for the XFS free block counters.  We proved 10 years ago that a
> >global lock for these counters was a massive scalability
> >limitation for concurrent buffered writes on 16p machines.
> >
> >IOWs, this change is going to cause fast path concurrent
> >sequential write regressions for just about everyone, even on
> >empty filesystems.
> 
> That is not really the case here. The patch won't change anything
> if there is enough free blocks available in the filesystem.  It
> will turn on global lock at mount time iff the number of free
> blocks available is less than the given limit. In the case of XFS,
> it is 12MB per CPU. On the 80-thread system that I used for
> testing, it will be a bit less than 1GB. Even if global lock is
> enabled at the beginning, it will be transitioned back to percpu
> lock as soon as enough free blocks become available.

Again: How is this an optimisation that is generally useful? Nobody
runs their production 80-thread workloads on a filesystems with less
than 1GB of free space. This is a situation that most admins would
consider "impending doom".

> I am aware that if there are enough threads pounding on the lock,
> it can cause a scalability bottleneck. However, the qspinlock used
> in x86 should greatly alleviate the scalability impact compared
> with 10 years ago when we used the ticket lock.

Regardless of whether there is less contention, it still brings back
a global serialisation point and modified cacheline (the free block
counter) in the filesystem that, at some point, will limit
concurrency....

> BTW, what exactly
> was the microbenchmark that you used to exercise concurrent
> sequential write? I would like to try it out on the new hardware
> and kernel.

Just something that HPC apps have been known to do for more then 20
years: concurrent sequential write from every CPU in the system.

http://oss.sgi.com/projects/xfs/papers/ols2006/ols-2006-paper.pdf

> >near to ENOSPC. As i asked you last time - if you want to make
> >this problem go away, please increase the size of the filesystem
> >you are running your massively concurrent benchmarks on.
> >
> >IOWs, please stop trying to optimise a filesystem slow path that:
> >
> >	a) 99.9% of production workloads never execute, b) where we
> >	expect performance to degrade as allocation gets
> >	computationally expensive as we close in on ENOSPC, c) we
> >	start to execute blocking data flush operations that slow
> >	everything down massively, and d) is indicative that the
> >	workload is about to suffer from a fatal, unrecoverable
> >	error (i.e. ENOSPC)
> >
> 
> I totally agree. I am not trying to optimize a filesystem
> slowpath.

Where else in the kernel is there a requirement for 100%
accurate threshold detection on per-cpu counters? There isn't, is
there?

> There are use cases, however, where we may want to
> create relatively small filesystem. One example that I cited in
> patch 2 is the battery backed NVDIMM that I have played with
> recently. They can be used for log files or other small files.
> Each dimm is 8 GB. You can have a few of those available. So the
> filesystem size could be 32GB or so.  That can come close to the
> the limit where excessive percpu_counter_sum() call can happen.
> What I want to do here is to try to reduce the chance of excessive
> percpu_counter_sum() calls causing a performance problem. For a
> large filesystem that is nowhere near ENOSPC, my patch will have
> no performance impact whatsoever.

Yet your patch won't have any effect on these "small" filesystems
because unless they have less free space than your threshold at
mount time (rare!) they won't ever have this global lock turned on.
Not to mention if space if freed in the fs, the global lock is
turned off, and will never get turned back on. 

Further, anyone using XFS on nvdimms will be enabling DAX, which
goes through the direct IO path rather than the buffered IO path
that is generating all this block accounting pressure. Hence it will
behave differently, and so your solution doesn't obviously apply to
that workload space, either.

When we get production workloads hitting free block accounting
issues near ENOSPC, then we'll look at optimising the XFS accounting
code. Microbenchmarks are great when they have real-work relevance,
but this doesn't right now. Not to mention we've got bigger things
to worry about in XFS right now in terms of ENOSPC accounting (think
reverse mapping, shared blocks and breaking shares via COW right
next to ENOSPC) and getting these working *correctly* takes
precendence of optimisation of the accounting code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
