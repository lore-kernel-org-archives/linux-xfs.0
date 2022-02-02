Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A83C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Feb 2022 02:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbiBBCWo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 21:22:44 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40344 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231835AbiBBCWo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 21:22:44 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4623310C4CAA;
        Wed,  2 Feb 2022 13:22:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nF5I8-0071eF-Gt; Wed, 02 Feb 2022 13:22:40 +1100
Date:   Wed, 2 Feb 2022 13:22:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20220202022240.GY59729@dread.disaster.area>
References: <20220113133701.629593-3-bfoster@redhat.com>
 <20220113223810.GG3290465@dread.disaster.area>
 <20220114173535.GA90423@magnolia>
 <YeHSxg3HrZipaLJg@bfoster>
 <20220114213043.GB90423@magnolia>
 <YeVxCXE6hXa1S/ic@bfoster>
 <20220118185647.GB13563@magnolia>
 <Yehvc4g+WakcG1mP@bfoster>
 <20220120003636.GF13563@magnolia>
 <Ye7aaIUvHFV18yNn@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye7aaIUvHFV18yNn@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61f9eaf2
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Omg7idZYQmLFB2Zj8dsA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 24, 2022 at 11:57:12AM -0500, Brian Foster wrote:
> On Wed, Jan 19, 2022 at 04:36:36PM -0800, Darrick J. Wong wrote:
> > > Of course if you wanted to recycle inactive inodes or do something else
> > > entirely, then it's probably not worth going down this path..
> > 
> > I'm a bit partial to /trying/ to recycle inactive inodes because (a)
> > it's less tangling with -fsdevel for you and (b) inode scans in the
> > online repair patchset got a little weird once xfs_iget lost the ability
> > to recycle _NEEDS_INACTIVE inodes...
> > 
> > OTOH I tried to figure out how to deal with the lockless list that those
> > inodes are put on, and I couldn't figure out how to get them off the
> > list safely, so that might be a dead end.  If you have any ideas I'm all
> > ears. :)
> > 
> 
> So one of the things that I've been kind of unclear on about the current
> deferred inactivation implementation is the primary goal of the percpu
> optimization. I obviously can see the value of the percpu list in
> general, but how much processing needs to occur in percpu context to
> achieve the primary goal?
> 
> For example, I can see how a single or small multi threaded sustained
> file removal might be batched efficiently, but what happens if said task
> happens to bounce around many cpus?

In that case we have a scheduler problem, not a per-cpu
infrastructure issue.

> What if a system has hundreds of
> cpus and enough removal tasks to populate most or all of the
> queues?

It behaves identically to before the per-cpu inactivation queues
were added. Essentially, everything serialises and burns CPU
spinning on the CIL push lock regardless of where the work is coming
from. The per-cpu queues do not impact this behaviour at all, nor do
they change the distribution of the work that needs to be done.

Even Darrick's original proposal had this same behaviour:

https://lore.kernel.org/linux-xfs/20210801234709.GD2757197@dread.disaster.area/

> Is
> it worth having 200 percpu workqueue tasks doing block truncations and
> inode frees to a filesystem that might have something like 16-32 AGs?

If you have a workload with 200-way concurrency that hits a
filesystem path with 16-32 way concurrency because of per-AG
locking (e.g. unlink needs to lock the AGI twice - once to put the
inode on the unlinked list, then again to remove and free it),
then you're only going to get 16-32 way concurrency from your
workload regardless of whether you have per-cpu algorithms for parts
of the workload.

From a workload scalability POV, we've always used the rule that the
filesystem AG count needs to be at least 2x the concurrency
requirement of the workload. Generally speaking, that means if you
want the FS to scale to operations on all CPUs at once, you need to
configure the FS with agcount=(2 * ncpus). This was one fo the first
things I was taught about performance tuning large CPU count HPC
machines when I first started working at SGI back in 2002, and it's
still true today.

> So I dunno, ISTM that the current implementation can be hyper efficient
> for some workloads and perhaps unpredictable for others. As Dave already
> alluded to, the tradeoff often times for such hyper efficient structures
> is functional inflexibility, which is kind of what we're seeing between
> the inability to recycle inodes wrt to this topic as well as potential
> optimizations on the whole RCU recycling thing. The only real approach
> that comes to mind for managing this kind of infrastructure short of
> changing data structures is to preserve the ability to drain and quiesce
> it regardless of filesystem state.
> 
> For example, I wonder if we could do something like have the percpu
> queues amortize insertion into lock protected perag lists that can be
> managed/processed accordingly rather than complete the entire
> inactivation sequence in percpu context. From there, the perag lists
> could be processed by an unbound/multithreaded workqueue that's maybe
> more aligned with the AG count on the filesystem than cpu count on the
> system.

That per-ag based back end processing is exactly what Darrick's
original proposals did:

https://lore.kernel.org/linux-xfs/162758431072.332903.17159226037941080971.stgit@magnolia/

It used radix tree walks run in background kworker threads to batch
all the inode inactivation in a given AG via radix tree walks to
find them.

It performed poorly at scale because it destroyed the CPU affinity
between the unlink() operation and the inactivation operation of the
unlinked inode when the last reference to the inode is dropped and
the inode evicted from task syscall exit context. REgardless of
whether there is a per-cpu front end or not, the per-ag based
processing will destroy the CPU affinity of the data set being
processed because we cannot guarantee that the per-ag objects are
all local to the CPU that is processing the per-ag objects....

IOWs, all the per-cpu queues are trying to do is keep the inode
inactivation processing local to the CPU where they are already hot
in cache.  The per-cpu queues do not acheive this perfectly in all
cases, but they perform far, far better than the original
parallelised AG affinity inactivation processing that cannot
maintain any cache affinity for the objects being processed at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
