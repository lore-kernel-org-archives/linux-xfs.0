Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F42CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 22:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiAYWgV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 17:36:21 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41372 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233945AbiAYWgS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 17:36:18 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 46DDD62C1A6;
        Wed, 26 Jan 2022 09:36:14 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nCUQ3-004Cqq-2G; Wed, 26 Jan 2022 09:36:07 +1100
Date:   Wed, 26 Jan 2022 09:36:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220125223607.GP59729@dread.disaster.area>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <20220125144044.GM4285@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125144044.GM4285@paulmck-ThinkPad-P17-Gen-1>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61f07b60
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=2x_fEa4ae6z0pYYvnKYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 25, 2022 at 06:40:44AM -0800, Paul E. McKenney wrote:
> On Tue, Jan 25, 2022 at 11:31:20AM +1100, Dave Chinner wrote:
> > > Ok, I think we're talking about slightly different things. What I mean
> > > above is that if a task removes a file and goes off doing unrelated
> > > $work, that inode will just sit on the percpu queue indefinitely. That's
> > > fine, as there's no functional need for us to process it immediately
> > > unless we're around -ENOSPC thresholds or some such that demand reclaim
> > > of the inode.
> > 
> > Yup, an occasional unlink sitting around for a while on an unlinked
> > list isn't going to cause a performance problem.  Indeed, such
> > workloads are more likely to benefit from the reduced unlink()
> > syscall overhead and won't even notice the increase in background
> > CPU overhead for inactivation of those occasional inodes.
> > 
> > > It sounds like what you're talking about is specifically
> > > the behavior/performance of sustained file removal (which is important
> > > obviously), where apparently there is a notable degradation if the
> > > queues become deep enough to push the inode batches out of CPU cache. So
> > > that makes sense...
> > 
> > Yup, sustained bulk throughput is where cache residency really
> > matters. And for unlink, sustained unlink workloads are quite
> > common; they often are something people wait for on the command line
> > or make up a performance critical component of a highly concurrent
> > workload so it's pretty important to get this part right.
> > 
> > > > Darrick made the original assumption that we could delay
> > > > inactivation indefinitely and so he allowed really deep queues of up
> > > > to 64k deferred inactivations. But with queues this deep, we could
> > > > never get that background inactivation code to perform anywhere near
> > > > the original synchronous background inactivation code. e.g. I
> > > > measured 60-70% performance degradataions on my scalability tests,
> > > > and nothing stood out in the profiles until I started looking at
> > > > CPU data cache misses.
> > > > 
> > > 
> > > ... but could you elaborate on the scalability tests involved here so I
> > > can get a better sense of it in practice and perhaps observe the impact
> > > of changes in this path?
> > 
> > The same conconrrent fsmark create/traverse/unlink workloads I've
> > been running for the past decade+ demonstrates it pretty simply. I
> > also saw regressions with dbench (both op latency and throughput) as
> > the clinet count (concurrency) increased, and with compilebench.  I
> > didn't look much further because all the common benchmarks I ran
> > showed perf degradations with arbitrary delays that went away with
> > the current code we have.  ISTR that parts of aim7/reaim scalability
> > workloads that the intel zero-day infrastructure runs are quite
> > sensitive to background inactivation delays as well because that's a
> > CPU bound workload and hence any reduction in cache residency
> > results in a reduction of the number of concurrent jobs that can be
> > run.
> 
> Curiosity and all that, but has this work produced any intuition on
> the sensitivity of the performance/scalability to the delays?  As in
> the effect of microseconds vs. tens of microsecond vs. hundreds of
> microseconds?

Some, yes.

The upper delay threshold where performance is measurably
impacted is in the order of single digit milliseconds, not
microseconds.

What I saw was that as the batch processing delay goes beyond ~5ms,
IPC starts to fall. The CPU usage profile does not change shape, nor
does the proportions of where CPU time is spent change. All I see if
data cache misses go up substantially and IPC drop substantially. If
I read my notes correctly, typical change from "fast" to "slow" in
IPC was 0.82 to 0.39 and LLC-load-misses from 3% to 12%. The IPC
degradation was all done by the time the background batch processing
times were longer than a typical scheduler tick (10ms).

Now, I've been testing on Xeon CPUs with 36-76MB of l2-l3 caches, so
there's a fair amount of data that these can hold. I expect that
with smaller caches, the inflection point will be at smaller batch
sizes rather than more. Hence while I could have used larger batches
for background processing (e.g. 64-128 inodes rather than 32), I
chose smaller batch sizes by default so that CPUs with smaller
caches are less likely to be adversely affected by the batch size
being too large. OTOH, I started to measure noticable degradation by
batch sizes of 256 inodes on my machines, which is why the hard
queue limit got set to 256 inodes.

Scaling the delay/batch size down towards single inode queuing also
resulted in perf degradation. This was largely because of all the
extra scheduling overhead that trying to switching between user task
and kernel worker task for every inode entailed. Context switch rate
went from a couple of thousand/sec to over 100,000/s for single
inode batches, and performance went backwards in proportion with the
amount of CPU then spent on context switches. It also lead to
increases in buffer lock contention (hence context switches) as both
user task and kworker try to access the same buffers...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
