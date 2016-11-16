Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:36865 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751981AbcKPBaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 20:30:16 -0500
Date: Wed, 16 Nov 2016 12:30:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161116013009.GQ28922@dastard>
References: <e0c37926-a670-98b6-4bd7-b438def130bd@fb.com>
 <20161017223057.GV23194@dastard>
 <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
 <20161018020324.GA23194@dastard>
 <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
 <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
 <20161114235801.GO28922@dastard>
 <20161115055416.GP28922@dastard>
 <77e23f2d-04f6-beb1-4515-6513a82b0686@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77e23f2d-04f6-beb1-4515-6513a82b0686@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2016 at 02:00:47PM -0500, Chris Mason wrote:
> On 11/15/2016 12:54 AM, Dave Chinner wrote:
> >On Tue, Nov 15, 2016 at 10:58:01AM +1100, Dave Chinner wrote:
> >>On Mon, Nov 14, 2016 at 03:56:14PM -0500, Chris Mason wrote:
> >There have been 1.2 million inodes reclaimed from the cache, but
> >there have only been 20,000 dirty inode buffer writes. Yes, that's
> >written 440,000 dirty inodes - the inode write clustering is
> >capturing about 22 inodes per write - but the inode writeback load
> >is minimal at about 10 IO/s. XFS inode reclaim is not blocking
> >significantly on dirty inodes.
> 
> I think our machines are different enough that we're not seeing the
> same problems.  Or at least we're seeing different sides of the
> problem.
> 
> We have 130GB of ram and on average about 300-500MB of XFS slab,
> total across all 15 filesystems.  Your inodes are small and cuddly,
> and I'd rather have more than less.  I see more with simoop than we
> see in prod, but either way its a reasonable percentage of system
> ram considering the horrible things being done.

So I'm running on 16GB RAM and have 100-150MB of XFS slab.
Percentage wise, the inode cache is a larger portion of memory than
in your machines. I can increase the number of files to increase it
further, but I don't think that will change anything.

> Both patched (yours or mine) and unpatched, XFS inode reclaim is
> keeping up.   With my patch in place, tracing during simoop does
> show more kswapd prio=1 scanning than unpatched, so I'm clearly
> stretching the limits a little more.  But we've got 30+ days of
> uptime in prod on almost 60 machines.  The oom rate is roughly in
> line with v3.10, and miles better than v4.0.

IOWs, you have a workaround that keeps your production systems
running. That's fine for your machines that are running this load,
but it's not working well for any of the other other loads I've
looked at.  That is, removing the throttling from the XFS inode
shrinker causes instability and adverse reclaim of the inode cache
in situations where the maintaining a working set in memory is
required for performance.

Indeed, one of the things I noticed with the simoops workload
running the shrinker patches is that it no longer kept either the
inode cache or the XFS metadata cache in memory long enough for the
du to run without requiring IO. i.e. the caches no longer maintained
the working set of objects needed to optimise a regular operation
and the du scans took a lot longer.

That's why on the vanilla kernels the inode cache footprint went
through steep sided valleys - reclaim would trash the inode cache,
but the metadata cache stayed intact and so all the inodes were
imemdiately pulled from there again and populated back into the
inode cache. With the patches to remove the XFS shrinker blocking,
the pressure was moved to other caches like the metadata cache, and
so the clean inode buffers were reclaimed instead. Hence when the
inodes were reclaimed, IO was necessary to re-read the inodes during
the du scan, and hence the cache growth was also slow.

That's what removing the blocking from the shrinker causes the
overall work rate to go down - it results in the cache not
maintaining a working set of inodes and so increases the IO load and
that then slows everything down.

There's secondary and tertiary effects all over the place that, and 
from the XFS POV this is a catch-22. The shrinker blocking has been
put in place to control the impact of unbound reclaim concurrency on
the working set caches need to maintain to sustain acceptible
performance. This blocking, however, is causing issues with latency
under your workload. If we remove the shrinker blocking
to address the FB allocation latency issue, then we screw up the
cached working set balance for every other XFS user out there and
we'll end up making things worse for many of XFS users.

Quite frankly, if I have to choose between these two things, then
I'm not going to change the shrinker implementation. FB can maintain
their own fixes until such a point in time  that the underlying
reclaim problem that requires the XFS shrinker to block has been
fully addressed and then we can change the XFS shrinker to work well
in all situations.

> >The XFS inode shrinker blocking plays no significant part in this
> >series of events. yes, it contributes to /reclaim latency/, but it
> >is not the cause of the catastrophic breakdown that results in
> >kswapd emptying the page cache and the slab caches to accomodate the
> >memory demand coming from userspace. We can fix the blocking
> >problems with the XFS shrinker, but it's not the shrinker's job to
> >stop this overload situation from happening.
> 
> My bigger concern with the blocking in the shrinker was more around
> the pile up of processes arguing about how to free a relatively
> small amount of ram.

This is not a shrinker problem, though. The shrinkers should be
completely isolated from allocation demand concurrency. The fact is
that they aren't isolated from it, and we have to deal with that as
best we can.

IOWs, this is a direct reclaim architecture problem. i.e. it
presents unbound concurrency to the shrinkers and then requires them
to "behave nicely" when the mm subsystem starts saying "I don't care
that you're already dealing with 200 other concurrent calls from me
- fucking well free everything for me now!".

Controlling and limiting the unbound concurrency of reclaim and
isolating shrinkers from the incoming demand is the only way we can
sanely keep both the reclaim latency to a minimum and maintain a
decent working set in the caches under extreme memory pressure.
We obviously cannot do both in a shrinker implementation, so
we really need a high level re-architecting here...

> The source of the overload for us is almost
> always going to be the users, and any little bit of capacity we give
> them back will get absorbed with added load.

Exactly why we need to re-acrhitect reclaim. because if we don't,
then the users will simply increase the load until it reclaim breaks
down through whatever band-aid we've added to hide the last
problem...

Put simply: reclaim algorithms should not change just because there
are more processes demanding memory - increased demand should simply
mean that the processes demanding memory should /wait longer/. Right
now they end up waiting longer by adding load and concurrency to the
reclaim subsystems, and somewhere in those reclaim subsystems we end
up blocking to try to avoid catastrophic degradations.

This is exactly analogous to the IO-less dirty page throttling
situation we battled with for years. We had an architecture where we
had direct submission of IO that throttling in the block layer on
request queues. When we had tens to hundreds of processes all doing
this, the IO patterns randomised, throughput tanked completely and
applications saw extremely non-deterministic long-tail latencies
during write() operations.

We fixed this by decoupling incoming process dirty page throttling
from the mechanism of cleaning of dirty pages. We now have a queue
of incoming processes that wait in turn for a number of pages to be
cleaned, and when that threshold is cleaned by the background
flusher threads, they are woken and on they go. it's efficient,
reliable, predictable and, above all, is completely workload
independent. We haven't had a "system is completely unresponsive
because I did a large write" problem since we made this
architectural change - we solved the catastrophic overload problem
one and for all.(*)

Direct memory reclaim is doing exactly what the old dirty page
throttle did - it is taking direct action and relying the underlying
reclaim mechanisms to throttle overload situations. Just like the
request queue throttling in the old dirty page code, the memory
reclaim subsystem is unable to behave sanely when large amounts of
concurrent pressure is put on it. The throttling happens too late,
too unpredictably, and too randomly for it to be controllable and
stable. And the result of that is that application see
non-deterministic long-tail latencies once memory reclaim starts.

We've already got background reclaim threads - kswapd - and there
are already hooks for throttling direct reclaim
(throttle_direct_reclaim()). The problem is that direct reclaim
throttling only kicks in once we are very near to low memory limits,
so it doesn't prevent concurency and load from being presented to
the underlying reclaim mechanism until it's already too late.

IMO, direct reclaim should be replaced with a queuing mechanism and
deferral to kswapd to clean pages.  Every time kswapd completes a
batch of freeing, it can check if it's freed enough to allow the
head of the queue to make progress. If it has, then it can walk down
the queue waking processes until all the pages it just freed have
been accounted for.

If we want to be truly fair, this queuing should occur at the
allocation entry points, not the direct reclaim entry point. i.e if
we are in a reclaim situation, go sit in the queue until you're told
we have memory for you and then run allocation.

Then we can design page scanning and shrinkers for maximum
efficiency, to be fully non-blocking, and to never have to directly
issue or wait for IO completion. They can all feed back reclaim
state to a central backoff mechanism which can sleep to alleviate
situations where reclaim cannot be done without blocking. This
allows us to constrain reclaim to a well controlled set of
background threads that we can scale according to observed need.

We know that this model works - IO-less dirty page throttling has
been a spectacular success. We now just take it for granted that
the thottling works because it self tunes to the underlying storage
characteristics and rarely, if ever, does the wrong thing. The same
cannot be said about memory reclaim behaviour....

> >The fact that we are seeing dirty page writeback from kswapd
> >indicates that the memory pressure this workload generates from
> >userspace is not being adequately throttled in
> >throttle_direct_reclaim() to allow dirty writeback to be done in an
> >efficient and timely manner. The memory reclaim throttling needs to
> >back off more in overload situations like this - we need to slow
> >down the incoming demand to the reclaim rate rather than just
> >increasing pressure and hoping that kswapd doesn't burn up in a ball
> >of OOM....
> 
> Johannes was addressing the dirty writeback from kswapd.  His first
> patch didn't make as big a difference as we hoped, but I've changed
> around simoop a bunch since then.  We'll try again.

We need an architectural change - bandaids aren't going to solve the
problem...

Cheers,

Dave.

(*) Yes, I'm aware of Jen's block throttling patches - that's
fixing an IO scheduling issue to avoid long read latencies due to
background writeback being /too efficient/ at cleaning pages when
we're driving the system really hard.  IOWs, it's a good problem to
have because it's a result of things working too well under load...
-- 
Dave Chinner
david@fromorbit.com
