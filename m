Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:58704 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756965AbcJRCD2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 22:03:28 -0400
Date: Tue, 18 Oct 2016 13:03:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161018020324.GA23194@dastard>
References: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
 <20161015223454.GS23194@dastard>
 <20161017002427.GA70229@clm-mbp.masoncoding.com>
 <20161017015251.GU23194@dastard>
 <e0c37926-a670-98b6-4bd7-b438def130bd@fb.com>
 <20161017223057.GV23194@dastard>
 <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 17, 2016 at 07:20:56PM -0400, Chris Mason wrote:
> On 10/17/2016 06:30 PM, Dave Chinner wrote:
> >On Mon, Oct 17, 2016 at 09:30:05AM -0400, Chris Mason wrote:
> >What you are reporting is equivalent to having pageout() run and do
> >all the writeback (badly) instead of the bdi flusher threads doing
> >all the writeback (efficiently). pageout() is a /worst case/
> >behaviour we try very hard to avoid and when it occurs it is
> >generally indicative of some other problem or imbalance. Same goes
> >here for the inode shrinker.
> 
> Yes!  But the big difference is that pageout() already has a backoff
> for congestion.  The xfs shrinker doesn't.

pageout() is only ever called from kswapd context for file pages.
Hence applications hitting direct reclaim really hard will never
call pageout() directly - they'll skip over it and end up calling
congestion_wait() instead and at that point the page cache dirty
throttle and background writeback should take over.

This, however, breaks down when there are hundreds of direct
reclaimers because the pressure put on direct reclaim can exceed the
amount of cleaning work that can be done by the background threads
in the maximum congestion backoff period and there are other caches
that require IO to clean.

Direct reclaim then has no clean page cache pages to clean on each
LRU scan, so it effectively then transfers that excess pressure to
the shrinkers that require IO to reclaim.  If a shrinker hits a
similar "reclaim pressure > background cleaning rate" threshold,
then it will end up directly blocking on IO congestion, exactly as
you are describing.

Both direct reclaim and kswapd can get stuck in this becase
shrinkers - unlike pageout() - are called from direct reclaim as
well as kswapd.  i.e. Shrinkers are exposed to unbound direct
reclaim pressure, pageout() writeback isn't. Hence shrinkers need to
handle unbound incoming concurrency without killing IO patterns,
without trashing the working set of objects it controls, and it has
to - somehow - adequately throttle reclaim rates in times of
pressure overload.

Right now the XFS code uses IO submission to do that throttling.
Shrinkers have no higher layer throttling we can rely on here.
Blocking on congestion during IO submission is effectively no
different to calling congestion_wait() in the shrinker itself after
skipping a bunch of dirty inodes that we can't write because of
congestion. While we can do this, it doesn't change the fact that
shrinkers that do IO need to block callers to adequately control the
reclaim pressure being directed at them.

If the XFS background metadata writeback threads are doing their
work properly, shrinker reclaim should not be blocking on dirty
inodes.  However, for all I know right now the problem could be that
the background reclaimer is *working too well* and so leaving only
dirty inodes for the shrinkers to act on.....

IOWs, what we need to do *first* is to work out why there is so much
blocking occuring - we need to find the /root cause of the
blocking problem/ and once we've found that we can discuss potential
solutions.

[snip]

> >If you're taking great lengths to avoid pageout() from being called,
> >then it's no surprise to me that your workload is, instead,
> >triggering the equivalent "oh shit, we're in real trouble here"
> >behaviour in XFS inode cache reclaim.  I also wonder, after turning
> >down the dirty ratios, if you've done other typical writeback tuning
> >tweaks like speeding up XFS's periodic metadata writeback to clean
> >inodes faster in the absence of journal pressure.
> 
> No, we haven't.  I'm trying really hard to avoid the need for 50
> billion tunables when the shrinkers are so clearly doing the wrong
> thing.

XFS has *1* tunable that can change the behaviour of metadata
writeback. Please try it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
