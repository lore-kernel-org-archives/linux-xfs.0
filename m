Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbeKAWUb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Nov 2018 18:20:31 -0400
Date: Thu, 1 Nov 2018 09:17:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/7] cache: prevent expansion races
Message-ID: <20181101131732.GB21654@bfoster>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-4-david@fromorbit.com>
 <20181031171302.GA16769@bfoster>
 <20181101012739.GY19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101012739.GY19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 01, 2018 at 12:27:39PM +1100, Dave Chinner wrote:
> On Wed, Oct 31, 2018 at 01:13:02PM -0400, Brian Foster wrote:
> > On Tue, Oct 30, 2018 at 10:20:39PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When a sudden buffer cache growth demand occurs from multiple
> > > concurrent sources, they can all fail shaking the cache at the same
> > > time and expand the cache. This results in the cache doubling in
> > > size multiple times when only a single expansion was really
> > > necessary. The resultant massive cache can cause repair to OOM as
> > > the cache will grow to much larger than memory can actually hold.
> > > 
> > > Prevent this sudden and unnecessary expansion by rate limiting cache
> > > growth to one size increase every tens seconds. This is sufficient
> > > to prevent racing expansion calls from doing the wrong thing, but
> > > not too long to prevent necesary cache growth when it is undersized.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > This seems fairly harmless, but I'm not really a fan of this kind of
> > time-based algorithm in general. Could we do something similarly
> > effective that doesn't require a magic time value?
> > 
> > For example, suppose we sample the current cache size at the top of the
> > function, pass that value along to cache_expand() and have the latter
> > only bump ->c_maxcount if it still matches the parameter value. Then
> > return-assign the local var with the latest value:
> > 
> > 	max_sample = cache_expand(cache, max_sample);
> > 
> > The end result is that an allocator must shake every mru under a given
> > cache size before it's allowed to grow the cache. Hm?
> 
> I tried that and it still causes excessive cache expansion on my
> really fast IO subsystem.  I'm seeing peaks of 300,000 IOPS when cache
> expansion bursts occur. They are lasting for up to 20s on my machine
> and it's enough to cause the cache to double in size multiple times.
> Once the initial bursts have run their course, demand drops to a
> steady state of 130-150kiops which the original cache size is quite
> capable of sustaining.
> 

Interesting.

> These bursts are driven by the initial read-ahead queues being
> filled and stop when the queues fill up.  If the IO is slow, then
> there isn't cache pressure because processing keeps up with
> readahead. If IO is fast, it fills the RA queues and then throttles
> back to processing speed. It's filling the RA queues that causes the
> buffer cache growth pressure, and it's really not necessary - the RA
> queues are already full enough to maximise performance in phase 6,
> and so growing memory footprint doesn't gain us anything.
> 

Makes sense..

> i.e. the buffer cache on large filesystems like this is used as a
> prefetch buffer. It is not a cache that stores anything for repeated
> use - there's 500GB of metadata (>450 million inodes) in this
> filesystem and we're only running w/ 128GB RAM, so we have no hope
> of caching the entire working set in RAM. Hence we want to keep the
> cache size down to just what is necessary to sustain effective
> prefetch.
> 
> The problem with throttling on "scanned the whole cache" is that
> this happens really quickly when you have a buffer demand of ~300k/s
> When I start with a cache size of 800k buffers (-o bhash=101031)
> doubling the cache size from 800k objects to 1.6m objects occurs
> within a couple of seconds of phase 6 starting. A couple of seconds
> later it doubles again, and by the time the initial 20s burst has
> finished, it's doubled 3 or 4 times.
> 

Ok, but I'm curious how much of this boils down to lock contention
exacerbated by the fast I/O. I can see how reduced I/O latency could
contribute to the rapid growth rate. At the same time, it looks like all
the shaker does in this pattern is flush buffers if dirty (which seems
unlikely if we're in some kind of prefetch overload?) and move them to
another list (for potential reuse of memory). 

We clearly have multiple lookup/fail/expand races going on as evidenced
by the need for this patch in the first place. The cache growth is
driven by cache misses (i.e. prefetch). The buffer lookups acquire hash
locks and the cache lock (for the node allocation attempt). If the alloc
is allowed, we read the buf and add it to the hash. If not, we shake the
mru and retry the same mru or next. The shake trylocks each node (buf)
and hash lock in the mru. If either lock fails, we skip to the next
buffer.

I'm not sure how likely this is, but what are the chances the shakes are
contending with eachother such that lock contention prevents real work
from being done in the shaker? That seems like a reasonable possibility
to me given that you're clearly reproducing enough parallel shakes to
explode the cache rather quickly. Each shake is essentially iterating
through the same dataset, right? Of course, I don't have the complete
picture so perhaps there are other factors at play. I think it's at
least worth looking into if you haven't already because if something
like that is going on, it could be more likely that the time-based
implementation basically trades one kind of resource (memory) wastage
for another (cpu).

Brian

> After the last expansion, the buffer cache can now grow way beyond
> what we can fit in memory and reapir eventually gets OOM killed on a
> 128GB RAM machine even though it really only needs ~70GB RAM to
> complete successfully.
> 
> IOWs, throttling expansion based on "cache full" demand doesn't
> throttle hard enough to prevent OOM kill in these cases. The time
> based throttling is based around preventing bursts for driving
> unnecessary expansion. If the sudden burst turns out ot be sustained
> demand and hence the cache really does need to be expanded multiple
> times, then the cache will grow quickly enough to meet that demand.
> We just don't want bursts to trigger that.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
