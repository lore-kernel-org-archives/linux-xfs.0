Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbeKBUic (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Nov 2018 16:38:32 -0400
Date: Fri, 2 Nov 2018 07:31:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/7] cache: prevent expansion races
Message-ID: <20181102113138.GA6794@bfoster>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-4-david@fromorbit.com>
 <20181031171302.GA16769@bfoster>
 <20181101012739.GY19305@dastard>
 <20181101131732.GB21654@bfoster>
 <20181101212344.GZ19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101212344.GZ19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 02, 2018 at 08:23:44AM +1100, Dave Chinner wrote:
> On Thu, Nov 01, 2018 at 09:17:32AM -0400, Brian Foster wrote:
> > On Thu, Nov 01, 2018 at 12:27:39PM +1100, Dave Chinner wrote:
> > > On Wed, Oct 31, 2018 at 01:13:02PM -0400, Brian Foster wrote:
> > > > On Tue, Oct 30, 2018 at 10:20:39PM +1100, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > When a sudden buffer cache growth demand occurs from multiple
> > > > > concurrent sources, they can all fail shaking the cache at the same
> > > > > time and expand the cache. This results in the cache doubling in
> > > > > size multiple times when only a single expansion was really
> > > > > necessary. The resultant massive cache can cause repair to OOM as
> > > > > the cache will grow to much larger than memory can actually hold.
> > > > > 
> > > > > Prevent this sudden and unnecessary expansion by rate limiting cache
> > > > > growth to one size increase every tens seconds. This is sufficient
> > > > > to prevent racing expansion calls from doing the wrong thing, but
> > > > > not too long to prevent necesary cache growth when it is undersized.
> > > > > 
> > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > ---
> > > > 
> > > > This seems fairly harmless, but I'm not really a fan of this kind of
> > > > time-based algorithm in general. Could we do something similarly
> > > > effective that doesn't require a magic time value?
> > > > 
> > > > For example, suppose we sample the current cache size at the top of the
> > > > function, pass that value along to cache_expand() and have the latter
> > > > only bump ->c_maxcount if it still matches the parameter value. Then
> > > > return-assign the local var with the latest value:
> > > > 
> > > > 	max_sample = cache_expand(cache, max_sample);
> > > > 
> > > > The end result is that an allocator must shake every mru under a given
> > > > cache size before it's allowed to grow the cache. Hm?
> > > 
> > > I tried that and it still causes excessive cache expansion on my
> > > really fast IO subsystem.  I'm seeing peaks of 300,000 IOPS when cache
> > > expansion bursts occur. They are lasting for up to 20s on my machine
> > > and it's enough to cause the cache to double in size multiple times.
> > > Once the initial bursts have run their course, demand drops to a
> > > steady state of 130-150kiops which the original cache size is quite
> > > capable of sustaining.
> > > 
> > 
> > Interesting.
> > 
> > > These bursts are driven by the initial read-ahead queues being
> > > filled and stop when the queues fill up.  If the IO is slow, then
> > > there isn't cache pressure because processing keeps up with
> > > readahead. If IO is fast, it fills the RA queues and then throttles
> > > back to processing speed. It's filling the RA queues that causes the
> > > buffer cache growth pressure, and it's really not necessary - the RA
> > > queues are already full enough to maximise performance in phase 6,
> > > and so growing memory footprint doesn't gain us anything.
> > > 
> > 
> > Makes sense..
> > 
> > > i.e. the buffer cache on large filesystems like this is used as a
> > > prefetch buffer. It is not a cache that stores anything for repeated
> > > use - there's 500GB of metadata (>450 million inodes) in this
> > > filesystem and we're only running w/ 128GB RAM, so we have no hope
> > > of caching the entire working set in RAM. Hence we want to keep the
> > > cache size down to just what is necessary to sustain effective
> > > prefetch.
> > > 
> > > The problem with throttling on "scanned the whole cache" is that
> > > this happens really quickly when you have a buffer demand of ~300k/s
> > > When I start with a cache size of 800k buffers (-o bhash=101031)
> > > doubling the cache size from 800k objects to 1.6m objects occurs
> > > within a couple of seconds of phase 6 starting. A couple of seconds
> > > later it doubles again, and by the time the initial 20s burst has
> > > finished, it's doubled 3 or 4 times.
> > > 
> > 
> > Ok, but I'm curious how much of this boils down to lock contention
> > exacerbated by the fast I/O.
> 
> There is a fair bit of lock contention during the expansion period
> at the start of phase 6, but that appears to mostly due to memory
> allocation causing serialisation on the process mmap_sem in page
> faults.  The time spent contending on userspace locks and shaking
> caches appears to be small compared to, say, the CPU time we spend
> CRCing the metadata being pulled in from disk. The lock contention
> slowly reduces as the heap footprint grows large enough not to
> require frequent memory allocation....
> 
> > I can see how reduced I/O latency could
> > contribute to the rapid growth rate. At the same time, it looks like all
> > the shaker does in this pattern is flush buffers if dirty (which seems
> > unlikely if we're in some kind of prefetch overload?) and move them to
> > another list (for potential reuse of memory). 
> > 
> > We clearly have multiple lookup/fail/expand races going on as evidenced
> > by the need for this patch in the first place. The cache growth is
> > driven by cache misses (i.e. prefetch). The buffer lookups acquire hash
> > locks and the cache lock (for the node allocation attempt). If the alloc
> > is allowed, we read the buf and add it to the hash. If not, we shake the
> > mru and retry the same mru or next. The shake trylocks each node (buf)
> > and hash lock in the mru. If either lock fails, we skip to the next
> > buffer.
> > 
> > I'm not sure how likely this is, but what are the chances the shakes are
> > contending with eachother such that lock contention prevents real work
> > from being done in the shaker?
> 
> Yes, it's definitely a possibility - the cache infrastructure needs
> an overhaul to scale beyond about 8 AGs concurrently prefetching.
> I've had a long term plan to replace the global hash based cache
> with something closer to the kernel per-ag cache code to get rid
> of a lot of the cross-ag cache contention (because most of the
> processing is per-ag in repair).
> 

Ok.

> > That seems like a reasonable possibility
> > to me given that you're clearly reproducing enough parallel shakes to
> > explode the cache rather quickly. Each shake is essentially iterating
> > through the same dataset, right? Of course, I don't have the complete
> > picture so perhaps there are other factors at play. I think it's at
> > least worth looking into if you haven't already because if something
> > like that is going on, it could be more likely that the time-based
> > implementation basically trades one kind of resource (memory) wastage
> > for another (cpu).
> 
> Given that we are talking about filesystems that take hours/days to
> run repair over, 10s here or there is just noise. It's a simple,
> easy fix that doesn't require a massive amount of investment of time
> or resources to avoid. It's a trade off - I've got way more things
> to do than I have time for, so if a simple "throttle to one change
> per 10s" avoids a gnarly OOM-killer death hours later for a user
> with an immediate "can't repair a broken filesystem because...",
> then that's a no-brainer...
> 

Fair enough, but I'm still curious if doing something like changing the
hash trylock in the shaker to a blocking lock would improve shaker
effectiveness enough to avoid the need for the time-based hackery. It's
possible it has no effect or just replaces one problem with a set of
others, but it's an even more trivial change than this patch is.

Another approach may be to lift the cache shaker from a per-lookup-miss
execution context to something more central (like its own thread(s))
such that lookups can block on (bounded) shakes without introducing too
much concurrency therein. That is certainly more involved than bolting a
throttle onto cache expansion and may not be worth the effort if the
long term plan is to replace the whole cache mechanism.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
