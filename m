Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:5090 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934004AbcKQDkv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2016 22:40:51 -0500
Date: Thu, 17 Nov 2016 14:39:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161117033955.GD19783@dastard>
References: <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
 <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
 <20161114235801.GO28922@dastard>
 <20161115055416.GP28922@dastard>
 <77e23f2d-04f6-beb1-4515-6513a82b0686@fb.com>
 <20161116013009.GQ28922@dastard>
 <20161116030344.GA7746@clm-mbp.masoncoding.com>
 <20161117004745.GB19783@dastard>
 <20161117010727.GB4811@clm-mbp.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161117010727.GB4811@clm-mbp.masoncoding.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 16, 2016 at 08:07:28PM -0500, Chris Mason wrote:
> On Thu, Nov 17, 2016 at 11:47:45AM +1100, Dave Chinner wrote:
> >On Tue, Nov 15, 2016 at 10:03:52PM -0500, Chris Mason wrote:
> >>Moving forward, I think I can manage to carry the one line patch in
> >>code that hasn't measurably changed in years.  We'll get it tested
> >>in a variety of workloads and come back with more benchmarks for the
> >>great slab rework coming soon to a v5.x kernel near you.
> >
> >FWIW, I just tested your one-liner against my simoops config here,
> >and by comparing the behaviour to my patchset that still allows
> >direct reclaim to block on dirty inodes, it would appear that all
> >the allocation latency I'm seeing here is from direct reclaim.
> 
> Meaning that your allocation latencies are constant regardless of if
> we're waiting in the xfs shrinker?

No, what I mean is that all the big p99 latencies are a result of
blocking in direct reclaim, not blocking kswapd. i.e. fully
non-blocking kswapd + blocking direct reclaim == big bad p99
latencies vs non-blocking kswapd + direct reclaim == no big
latencies.

It also /appears/ that the bad FFE kswapd behaviour is closely
correlated to the long blocking latencies in direct reclaim, though
I haven't been able to confirm this hypothesis yet.

> >commit 795ae7a0de6b834a0cc202aa55c190ef81496665
> >Author: Johannes Weiner <hannes@cmpxchg.org>
> >Date:   Thu Mar 17 14:19:14 2016 -0700
> >
> >   mm: scale kswapd watermarks in proportion to memory
> >
> >
> >What's painfully obvious, though, is that even when I wind it up to
> >it's full threshold (10% memory), it does not prevent direct reclaim
> >from being entered and causing excessive latencies when it blocks.
> >This is despite the fact that simoops is now running with a big free
> >memory reserve (3-3.5GB of free memory on my machine as the page
> >cache now only consumes ~4GB instead of 7-8GB).
> 
> Huh, I'll try to reproduce that.  It might be NUMA imbalance or just
> that simoop is so bursty that we're blowing past that 3.5GB.

It's probably blowing through it, but regardless of this there's
more serious problems with this approach. I originally
turned up the watermarks a few seconds after starting simoops and
everythign was fine. However, when I stopped and tried to restart
simoops, it *always* fails in a few seconds with either:

....
Creating working files
done creating working files
du thread is running /mnt/scratch
du thread is done /mnt/scratch
error 11 from pthread_create
$

or

....
Creating working files
done creating working files
du thread is running /mnt/scratch
du thread is done /mnt/scratch
mmap: Cannot allocate memory
$

I couldn't start simoops again until I backed out the watermark
tuning, and then it started straight away.

IOWs, screwing with the watermarks to try to avoid direct reclaim
appears to make userspace randomly fail with ENOMEM problems when
there are large reserves still available. So AFAICT this doesn't fix
the problems that I've been seeing and instead creates a bunch of
new ones.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
