Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C1AC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 22:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0B76207CB
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 22:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgEWW3m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 18:29:42 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:58829 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbgEWW3m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 18:29:42 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 47E4DD78897;
        Sun, 24 May 2020 08:29:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jcce7-0000pu-Gs; Sun, 24 May 2020 08:29:35 +1000
Date:   Sun, 24 May 2020 08:29:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/24] xfs: make inode reclaim almost non-blocking
Message-ID: <20200523222935.GH2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-14-david@fromorbit.com>
 <20200522224806.GQ8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522224806.GQ8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=GmiGDodYbOOJxNmjC48A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 03:48:06PM -0700, Darrick J. Wong wrote:
> On Fri, May 22, 2020 at 01:50:18PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that dirty inode writeback doesn't cause read-modify-write
> > cycles on the inode cluster buffer under memory pressure, the need
> > to throttle memory reclaim to the rate at which we can clean dirty
> > inodes goes away. That is due to the fact that we no longer thrash
> > inode cluster buffers under memory pressure to clean dirty inodes.
> > 
> > This means inode writeback no longer stalls on memory allocation
> > or read IO, and hence can be done asynchrnously without generating
> 
> "...asynchronously..."
> 
> > memory pressure. As a result, blocking inode writeback in reclaim is
> > no longer necessary to prevent reclaim priority windup as cleaning
> > dirty inodes is no longer dependent on having memory reserves
> > available for the filesystem to make progress reclaiming inodes.
> > 
> > Hence we can convert inode reclaim to be non-blocking for shrinker
> > callouts, both for direct reclaim and kswapd.
> > 
> > On a vanilla kernel, running a 16-way fsmark create workload on a
> > 4 node/16p/16GB RAM machine, I can reliably pin 14.75GB of RAM via
> > userspace mlock(). The OOM killer gets invoked at 15GB of
> > pinned RAM.
> > 
> > With this patch alone, pinning memory triggers premature OOM
> > killer invocation, sometimes with as much as 45% of RAM being free.
> > It's trivially easy to trigger the OOM killer when reclaim does not
> > block.
> > 
> > With pinning inode clusters in RAM adn then adding this patch, I can
> > reliably pin 14.5GB of RAM and still have the fsmark workload run to
> > completion. The OOM killer gets invoked 14.75GB of pinned RAM, which
> > is only a small amount of memory less than the vanilla kernel. It is
> > much more reliable than just with async reclaim alone.
> 
> So the lack of OOM kills is the result of not having to do RMW and
> ratcheting up the reclaim priority, right?

Effectively. The ratcheting up the reclaim priority without
writeback is a secondary effect of RMW in inode writeback.

That is, the AIL blocks on memory reclaim doing dirty inode
writeback because it has unbound demand (async flushing). Hence it
exhausts memory reserves if there are lots of dirty inodes. It's
also PF_MEMALLOC so, like kswapd, it can dip into certain reserves
that normal allocation can't.

The synchronous write behaviour of reclaim, however, bounds memory
demand at (N * ag count * pages per inode cluster), and hence it is
much more likely to make forwards progress, albeit slowly. The
synchronous write also has the effect of throttling the rate at
which reclaim cycles, hence slowly down the speed at which it ramps
up the reclaim priority rate. IOWs, we get both forwards progress
and lower reclaim priority because we block reclaim like this.

IOWs, removing the synchronous writeback from reclaim does two
things. The first is that it removes the ability to make forwards
progress reclaiming inodes from XFS when there is very low free
memory. This is bad for obvious reasons.

The second is that it allows reclaim to think it can't free
inode memory quickly and that's what causes the increase in reclaim
priority. i.e. it needs more scan loops to free inodes because
writeback of dirty inodes is slow and not making progress. This is
also bad, because we can make progress, just not as fast as memory
reclaim is capable of backing off from.

The sync writeback of inode clusters from reclaim mitigated both of
these issues when they occurred at the cost of increased allocation
latency at extreme OOM conditions...

This is why, despite everyone with OOM latency problems claiming "it
works for them so you should just merge it", just skipping inode
writeback in the shrinker has not been a solution to the problem -
it didn't solve the underlying "reclaim of dirty inodes can create
unbound memory demand" problem that the sync inode writeback
controlled.

Previous attempts to solve this problem had been focussed on
replacing the throttling the shrinker did with backoffs in the core
reclaim algorithms, but that's made no progress on the mm/ side of
things. Hence this patchset - trying to tackle the problem from a
different direction so we are no longer reliant on changing core OS
infrastructure to solve problems XFS users are having.

> And, {con|per}versely, can I run fstests with 400MB of RAM now? :D

If it is bound on sync inode writeback from memory reclaim, then it
will help, otherwise it may make things worse because the trade off
we are making here is that dirty inodes can pin substantially more
memory in cache while they queue to be written back.

Yup, that's the ugly downside of this approach. Rather than have the
core memory reclaim throttle and wait according to what we need it
to do, we simply make the XFS cache footprint larger every time we
dirty an inode. It also costs us 1-2% extra CPU per transaction, so
this change certainly isn't free. IMO, it's most definitely not the
most efficient, performant or desirable solution to the problem, but
it's one that works and is wholly contained within XFS.

> > simoops shows that allocation stalls go away when async reclaim is
> > used. Vanilla kernel:
> > 
> > Run time: 1924 seconds
> > Read latency (p50: 3,305,472) (p95: 3,723,264) (p99: 4,001,792)
> > Write latency (p50: 184,064) (p95: 553,984) (p99: 807,936)
> > Allocation latency (p50: 2,641,920) (p95: 3,911,680) (p99: 4,464,640)
> > work rate = 13.45/sec (avg 13.44/sec) (p50: 13.46) (p95: 13.58) (p99: 13.70)
> > alloc stall rate = 3.80/sec (avg: 2.59) (p50: 2.54) (p95: 2.96) (p99: 3.02)
> > 
> > With inode cluster pinning and async reclaim:
> > 
> > Run time: 1924 seconds
> > Read latency (p50: 3,305,472) (p95: 3,715,072) (p99: 3,977,216)
> > Write latency (p50: 187,648) (p95: 553,984) (p99: 789,504)
> > Allocation latency (p50: 2,748,416) (p95: 3,919,872) (p99: 4,448,256)
> 
> I'm not familiar with simoops, and ElGoog is not helpful.  What are the
> units here?

Microseconds, IIRC.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
