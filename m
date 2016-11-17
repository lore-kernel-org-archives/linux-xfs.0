Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61517 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752694AbcKQAru (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2016 19:47:50 -0500
Date: Thu, 17 Nov 2016 11:47:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161117004745.GB19783@dastard>
References: <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
 <20161018020324.GA23194@dastard>
 <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
 <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
 <20161114235801.GO28922@dastard>
 <20161115055416.GP28922@dastard>
 <77e23f2d-04f6-beb1-4515-6513a82b0686@fb.com>
 <20161116013009.GQ28922@dastard>
 <20161116030344.GA7746@clm-mbp.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161116030344.GA7746@clm-mbp.masoncoding.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2016 at 10:03:52PM -0500, Chris Mason wrote:
> Moving forward, I think I can manage to carry the one line patch in
> code that hasn't measurably changed in years.  We'll get it tested
> in a variety of workloads and come back with more benchmarks for the
> great slab rework coming soon to a v5.x kernel near you.

FWIW, I just tested your one-liner against my simoops config here,
and by comparing the behaviour to my patchset that still allows
direct reclaim to block on dirty inodes, it would appear that all
the allocation latency I'm seeing here is from direct reclaim.

So I went looking at the direct reclaim throttle with the intent to
hack it to throttle earlier. It throttles based on watermarks, so
I figured Id just hack them to be larger to trigger direct reclaim
throttling earlier. And then I found this recent addition:

https://patchwork.kernel.org/patch/8426381/

+=============================================================
+
+watermark_scale_factor:
+
+This factor controls the aggressiveness of kswapd. It defines the
+amount of memory left in a node/system before kswapd is woken up and
+how much memory needs to be free before kswapd goes back to sleep.
+
+The unit is in fractions of 10,000. The default value of 10 means the
+distances between watermarks are 0.1% of the available memory in the
+node/system. The maximum value is 1000, or 10% of memory.
+
+A high rate of threads entering direct reclaim (allocstall) or kswapd
+going to sleep prematurely (kswapd_low_wmark_hit_quickly) can indicate
+that the number of free pages kswapd maintains for latency reasons is
+too small for the allocation bursts occurring in the system. This knob
+can then be used to tune kswapd aggressiveness accordingly.
+

The /exact hack/ I was thinking of was committed about 6 months
ago and added "support for ever more" /proc file:

commit 795ae7a0de6b834a0cc202aa55c190ef81496665
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Thu Mar 17 14:19:14 2016 -0700

    mm: scale kswapd watermarks in proportion to memory


What's painfully obvious, though, is that even when I wind it up to
it's full threshold (10% memory), it does not prevent direct reclaim
from being entered and causing excessive latencies when it blocks.
This is despite the fact that simoops is now running with a big free
memory reserve (3-3.5GB of free memory on my machine as the page
cache now only consumes ~4GB instead of 7-8GB).

And, while harder to trigger, kswapd still goes on the "free fucking
everything" rampages that trigger page writeback from kswapd and
empty both the page cache and the slab caches. The only difference
now is that it does this /without triggering the allocstall
counter/....

So it's seems that just upping the direct reclaim throttle point
isn't a sufficient workaround for the "too much direct reclaim"
problem here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
