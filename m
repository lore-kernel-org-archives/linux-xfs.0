Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18704C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Feb 2022 23:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343845AbiBJXIL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Feb 2022 18:08:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbiBJXIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Feb 2022 18:08:09 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD917C66
        for <linux-xfs@vger.kernel.org>; Thu, 10 Feb 2022 15:08:09 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A1F3F52C5D5;
        Fri, 11 Feb 2022 10:08:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nIIXm-00AWQX-WB; Fri, 11 Feb 2022 10:08:07 +1100
Date:   Fri, 11 Feb 2022 10:08:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20220210230806.GO59729@dread.disaster.area>
References: <20220114173535.GA90423@magnolia>
 <YeHSxg3HrZipaLJg@bfoster>
 <20220114213043.GB90423@magnolia>
 <YeVxCXE6hXa1S/ic@bfoster>
 <20220118185647.GB13563@magnolia>
 <Yehvc4g+WakcG1mP@bfoster>
 <20220120003636.GF13563@magnolia>
 <Ye7aaIUvHFV18yNn@bfoster>
 <20220202022240.GY59729@dread.disaster.area>
 <YgVhe/mAQvzPIK7M@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgVhe/mAQvzPIK7M@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62059ad9
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=hzFKve-40REhhot-BIAA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 10, 2022 at 02:03:23PM -0500, Brian Foster wrote:
> On Wed, Feb 02, 2022 at 01:22:40PM +1100, Dave Chinner wrote:
> > On Mon, Jan 24, 2022 at 11:57:12AM -0500, Brian Foster wrote:
> > > On Wed, Jan 19, 2022 at 04:36:36PM -0800, Darrick J. Wong wrote:
> > > > > Of course if you wanted to recycle inactive inodes or do something else
> > > > > entirely, then it's probably not worth going down this path..
> > > > 
> > > > I'm a bit partial to /trying/ to recycle inactive inodes because (a)
> > > > it's less tangling with -fsdevel for you and (b) inode scans in the
> > > > online repair patchset got a little weird once xfs_iget lost the ability
> > > > to recycle _NEEDS_INACTIVE inodes...
> > > > 
> > > > OTOH I tried to figure out how to deal with the lockless list that those
> > > > inodes are put on, and I couldn't figure out how to get them off the
> > > > list safely, so that might be a dead end.  If you have any ideas I'm all
> > > > ears. :)
> > > > 
> > > 
> > > So one of the things that I've been kind of unclear on about the current
> > > deferred inactivation implementation is the primary goal of the percpu
> > > optimization. I obviously can see the value of the percpu list in
> > > general, but how much processing needs to occur in percpu context to
> > > achieve the primary goal?
> > > 
> > > For example, I can see how a single or small multi threaded sustained
> > > file removal might be batched efficiently, but what happens if said task
> > > happens to bounce around many cpus?
> > 
> > In that case we have a scheduler problem, not a per-cpu
> > infrastructure issue.
> > 
> 
> Last I tested on my box, a single threaded rm -rf had executed on
> something like 24 of the 80 cpus available after about ~1m of runtime.

Not surprising - the scheduler will select a sibling cores that
share caches when the previous CPU the task was running on is busy
running CPU affine tasks (i.e. the per-cpu inactive kworker thread).

But how many CPUs it bounces the workload around over a long period
is not important. What is important is the cache residency between
the inodes when they are queued and when they are then inactivated.
That's measured in microseconds to single digit milliseconds (i.e.
within a single scheduling tick), and this is the metric that
matters the most. It doesn't matter if the first batch is unlinked
on CPU 1 and then inactived on CPU 1 while the scheduler moves the
unlink task to CPU 2 where it queues the next batch to be
inactivated on CPU 2, and so on. What matters is the data set in
each batch remains on the same CPU for inactivation processing.

The tracing I've done indicates taht the majority of the time that
the scehduler bounces the tasks between two or three sibling CPUs
repeatedly. This occurs when the inactivation is keeping up with the
unlink queueing side. When we have lots of extents to remove in
inactivation, the amount of inactivation work is much greater than
the unlink() work, and so we see inactivation batch processing
taking longer and the CPU spread of the unlink task gets larger
because there are more CPUs running CPU-affine tasks doing
background inactivation.

IOWs, having the number of CPUs the unlink task is scheduled on
grow over the long term is not at all unexpected - this is exactly
what we'd expect to see when we move towards async background
processing of complex operations...

> Of course the inactivation work for an inode occurs on the cpu that the
> rm task was running on when the inode was destroyed, but I don't think
> there's any guarantee that kworker task will be the next task selected
> on the cpu if the system is loaded with other runnable tasks (and then
> whatever task is selected doesn't pollute the cache).

The scheduler will select the next CPU based on phsyical machine
topology - core latencies, shared caches, numa distances, whether
the target CPU has affinity bound tasks already queued, etc.

> For example, I
> also noticed rm-<pidX> -> rm-<pidY> context switching on concurrent
> remove tests. That is obviously not a caching issue in this case because
> both tasks are still doing remove work, but behavior is less
> deterministic of the target task happens to be something unrelated. Of
> course, that doesn't mean the approach might not otherwise be effective
> for the majority of common workloads..

As long as the context switch rate does not substantially increase,
having tasks migrate between sibling cores every so often isn't a
huge problem.

> > That per-ag based back end processing is exactly what Darrick's
> > original proposals did:
> > 
> > https://lore.kernel.org/linux-xfs/162758431072.332903.17159226037941080971.stgit@magnolia/
> > 
> > It used radix tree walks run in background kworker threads to batch
> > all the inode inactivation in a given AG via radix tree walks to
> > find them.
> > 
> > It performed poorly at scale because it destroyed the CPU affinity
> > between the unlink() operation and the inactivation operation of the
> > unlinked inode when the last reference to the inode is dropped and
> > the inode evicted from task syscall exit context. REgardless of
> > whether there is a per-cpu front end or not, the per-ag based
> > processing will destroy the CPU affinity of the data set being
> > processed because we cannot guarantee that the per-ag objects are
> > all local to the CPU that is processing the per-ag objects....
> > 
> 
> Ok. The role/significance of cpu caching was not as apparent to me when
> I had last replied to this thread. The discussion around the rcu inode
> lifecycle issue helped clear some of that up.
> 
> That said, why not conditionally tag and divert to a background worker
> when the inodegc is disabled? That could allow NEEDS_INACTIVE inodes to
> be claimed/recycled from other contexts in scenarios like when the fs is
> frozen, since they won't be stuck in inaccessible and inactive percpu
> queues, but otherwise preserves current behavior in normal runtime
> conditions. Darrick mentioned online repair wanting to do something
> similar earlier, but it's not clear to me if scrub could or would want
> to disable the percpu inodegc workers in favor of a temporary/background
> mode while repair is running. I'm just guessing that performance is
> probably small enough of a concern in that situation that it wouldn't be
> a mitigating factor. Hm?

WE probably could do this, but I'm not sure the complexity is
justified by the rarity of the problem it is trying to avoid.
Freezes are not long term, nor are they particularly common for
performance sensitive workloads. Hence I'm just not this corner case
is important enough to justify doing the work given that we've had
similar freeze-will-delay-some-stuff-indefinitely behaviour for a
long time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
