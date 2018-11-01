Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:20715 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbeKAK21 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Nov 2018 06:28:27 -0400
Date: Thu, 1 Nov 2018 12:27:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/7] cache: prevent expansion races
Message-ID: <20181101012739.GY19305@dastard>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-4-david@fromorbit.com>
 <20181031171302.GA16769@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031171302.GA16769@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 31, 2018 at 01:13:02PM -0400, Brian Foster wrote:
> On Tue, Oct 30, 2018 at 10:20:39PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When a sudden buffer cache growth demand occurs from multiple
> > concurrent sources, they can all fail shaking the cache at the same
> > time and expand the cache. This results in the cache doubling in
> > size multiple times when only a single expansion was really
> > necessary. The resultant massive cache can cause repair to OOM as
> > the cache will grow to much larger than memory can actually hold.
> > 
> > Prevent this sudden and unnecessary expansion by rate limiting cache
> > growth to one size increase every tens seconds. This is sufficient
> > to prevent racing expansion calls from doing the wrong thing, but
> > not too long to prevent necesary cache growth when it is undersized.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> This seems fairly harmless, but I'm not really a fan of this kind of
> time-based algorithm in general. Could we do something similarly
> effective that doesn't require a magic time value?
> 
> For example, suppose we sample the current cache size at the top of the
> function, pass that value along to cache_expand() and have the latter
> only bump ->c_maxcount if it still matches the parameter value. Then
> return-assign the local var with the latest value:
> 
> 	max_sample = cache_expand(cache, max_sample);
> 
> The end result is that an allocator must shake every mru under a given
> cache size before it's allowed to grow the cache. Hm?

I tried that and it still causes excessive cache expansion on my
really fast IO subsystem.  I'm seeing peaks of 300,000 IOPS when cache
expansion bursts occur. They are lasting for up to 20s on my machine
and it's enough to cause the cache to double in size multiple times.
Once the initial bursts have run their course, demand drops to a
steady state of 130-150kiops which the original cache size is quite
capable of sustaining.

These bursts are driven by the initial read-ahead queues being
filled and stop when the queues fill up.  If the IO is slow, then
there isn't cache pressure because processing keeps up with
readahead. If IO is fast, it fills the RA queues and then throttles
back to processing speed. It's filling the RA queues that causes the
buffer cache growth pressure, and it's really not necessary - the RA
queues are already full enough to maximise performance in phase 6,
and so growing memory footprint doesn't gain us anything.

i.e. the buffer cache on large filesystems like this is used as a
prefetch buffer. It is not a cache that stores anything for repeated
use - there's 500GB of metadata (>450 million inodes) in this
filesystem and we're only running w/ 128GB RAM, so we have no hope
of caching the entire working set in RAM. Hence we want to keep the
cache size down to just what is necessary to sustain effective
prefetch.

The problem with throttling on "scanned the whole cache" is that
this happens really quickly when you have a buffer demand of ~300k/s
When I start with a cache size of 800k buffers (-o bhash=101031)
doubling the cache size from 800k objects to 1.6m objects occurs
within a couple of seconds of phase 6 starting. A couple of seconds
later it doubles again, and by the time the initial 20s burst has
finished, it's doubled 3 or 4 times.

After the last expansion, the buffer cache can now grow way beyond
what we can fit in memory and reapir eventually gets OOM killed on a
128GB RAM machine even though it really only needs ~70GB RAM to
complete successfully.

IOWs, throttling expansion based on "cache full" demand doesn't
throttle hard enough to prevent OOM kill in these cases. The time
based throttling is based around preventing bursts for driving
unnecessary expansion. If the sudden burst turns out ot be sustained
demand and hence the cache really does need to be expanded multiple
times, then the cache will grow quickly enough to meet that demand.
We just don't want bursts to trigger that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
