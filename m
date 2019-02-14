Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbfBNNAS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Feb 2019 08:00:18 -0500
Date: Thu, 14 Feb 2019 08:00:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/3]: Extreme fragmentation ahoy!
Message-ID: <20190214130014.GA47851@bfoster>
References: <20190207052114.GA7991@magnolia>
 <20190207053941.GL14116@dastard>
 <20190207155242.GE2880@bfoster>
 <20190208024730.GM14116@dastard>
 <20190208123432.GB21317@bfoster>
 <20190212011333.GB23989@magnolia>
 <20190212114630.GA35242@bfoster>
 <20190212202150.GS14116@dastard>
 <20190213135021.GB42812@bfoster>
 <20190213222726.GT14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213222726.GT14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Feb 14, 2019 at 09:27:26AM +1100, Dave Chinner wrote:
> On Wed, Feb 13, 2019 at 08:50:22AM -0500, Brian Foster wrote:
> > On Wed, Feb 13, 2019 at 07:21:51AM +1100, Dave Chinner wrote:
> > > On Tue, Feb 12, 2019 at 06:46:31AM -0500, Brian Foster wrote:
> > > > On Mon, Feb 11, 2019 at 05:13:33PM -0800, Darrick J. Wong wrote:
> > > > > On Fri, Feb 08, 2019 at 07:34:33AM -0500, Brian Foster wrote:
> > > > For example, extent size hints just happen to skip delayed allocation.
> > > > I don't recall the exact history, but I don't think this was always the
> > > > case for extsz hints.
> > > 
> > > It wasn't, but extent size hints + delalloc never played nicely and
> > > could corrupt or expose stale data and caused all sorts of problems
> > > at ENOSPC because delalloc reservations are unaware of alignment
> > > requirements for extent size hints. Hence to make extent size hints
> > > work for buffered writes, I simply made them work the same way as
> > > direct writes (i.e. immediate allocation w/ unwritten extents).
> > > 
> > > > So would the close time eofb trim be as
> > > > problematic as for extsz hint files if the behavior of the latter
> > > > changed back to using delayed allocation?
> > > 
> > > Yes, but if it's a write-once file that doesn't matter. If it's
> > > write-many, then we'd retain the post-eof blocks...
> > > 
> > > > I think a patch for that was
> > > > proposed fairly recently, but it depended on delalloc -> unwritten
> > > > functionality which still had unresolved issues (IIRC).
> > > 
> > > *nod*
> > > 
> > > > From another angle, would a system that held files open for a
> > > > significant amount of time relative to a one-time write such that close
> > > > consistently occurred after writeback (and thus delalloc conversion) be
> > > > susceptible to the same level of free space fragmentation as shown
> > > > above?
> > > 
> > > If the file is held open for writing for a long time, we have to
> > > assume that they are going to write again (and again) so we should
> > > leave the EOF blocks there. If they are writing slower than the eofb
> > > gc, then there's nothing more we can really do in that case...
> > > 
> > 
> > I'm not necessarily sure that this condition is always a matter of
> > writing too slow. It very well may be true, but I'm curious if there are
> > parallel copy scenarios (perhaps under particular cpu/RAM configs)
> > where we could end up doing a large number of one time file writes and
> > not doing the release time trim until an underlying extent (with
> > post-eof blocks) has been converted in more cases than not.
> 
> I'm not sure I follow what sort of workload and situation you are
> describing here. Are you talking about the effect of an EOFB gc pass
> during ongoing writes?
> 

I'm not sure if it's an actual reproducible situation.. I'm just
wondering out loud if there are normal workloads that might still defeat
a one-time trim at release time. For example, copy enough files in
parallel such that writeback touches most of them before the copies
complete and we end up trimming physical blocks rather than delalloc
blocks.

This is not so much of a problem if those files are large, I think,
because then the preallocs and the resulting trimmed free space is on
the larger side as well. If we're copying a bunch of little files with
small preallocs, however, then we put ourselves in the pathological
situation shown in Darrick's test.

I was originally thinking about whether this could happen or not on a
highly parallel small file copy workload, but having thought about it a
bit more I think there is a more simple example. What about an untar
like workload that creates small files and calls fsync() before each fd
is released? Wouldn't that still defeat a one-time release heuristic and
produce the same layout issues as shown above? We'd prealloc,
writeback/convert then trim small/spurious fragments of post-eof space
back to the allocator.

> > Perhaps this is more of a question of writeback behavior than anything
> > in XFS, but if that can occur with files on the smaller side it's a
> > clear path to free space fragmentation. I think it's at least worth
> > considering whether we can improve things, but of course this requires
> > significantly more thought and analysis to determine whether that's an
> > actual problem and if the cure is worse than the disease. :P
> > 
> > > > (I'm not sure if/why anybody would actually do that.. userspace
> > > > fs with an fd cache perhaps? It's somewhat besides the point,
> > > > anyways...)).
> > > 
> > > *nod*
> > > 
> > > > More testing and thought is probably required. I _was_ wondering if we
> > > > should consider something like always waiting as long as possible to
> > > > eofb trim already converted post-eof blocks, but I'm not totally
> > > > convinced that actually has value. For files that are not going to see
> > > > any further appends, we may have already lost since the real post-eof
> > > > blocks will end up truncated just the same whether it happens sooner or
> > > > not until inode reclaim.
> > > 
> > > If the writes are far enough apart, then we lose any IO optimisation
> > > advantage of retaining post-eof blocks (induces seeks because
> > > location of new writes is fixed ahead of time). Then it just becomes
> > > a fragmentation avoidance If the writes are slow enough,
> > > fragmentation really doesn't matter a whole lot - it's when writes
> > > are frequent and we trash the post-eof blocks quickly that it
> > > matters.
> > > 
> > 
> > It sounds like what you're saying is that it doesn't really matter
> > either way at this point. There's no perf advantage to keeping the eof
> > blocks in this scenario, but there's also no real harm in deferring the
> > eofb trim of physical post-eof blocks because any future free space
> > fragmentation damage has already been done (assuming no more writes come
> > in).
> 
> Essentially, yes.
> 
> > The thought above was tip-toeing around the idea of (in addition to the
> > one-time trim heuristic you mentioned above) never doing a release time
> > trim of non-delalloc post-eof blocks.
> 
> Except we want to trim blocks in the in the cases where it's a write
> once file that has been fsync()d or written by O_DIRECT w/ really
> large extent size hints....
> 

We still would trim it. The one time write case is essentially
unaffected because the only advantage of that hueristic is to trim eof
blocks before they are converted. If the eof blocks are real, the
release time heuristic has already failed (i.e., it hasn't provided any
benefit that background trim doesn't already provide).

IOW, what we really want to avoid is trimming (small batches of) unused
physical eof blocks.

> It seems to me that once we start making exceptions to the general
> rule, we end up in a world of corner cases and, most likely,
> unreliable heuristics.
> 

I agree in principle, but my purpose for this discussion is to try and
think about whether we can come up with a better set of rules/behaviors.

> > > IOWs, speculative prealloc beyond EOF is not just about preventing
> > > fragmentation - it also helps minimise the per-write CPU overhead of
> > > delalloc space accounting. (i.e. allows faster write rates into
> > > cache). IOWs, for anything more than a really small files, we want
> > > to be doing speculative delalloc on the first time the file is
> > > written to.
> > > 
> > 
> > Ok, this paper refers to CPU overhead as it contributes to lack of
> > scalability.
> 
> Well, that was the experiments that were being performed. I'm using
> it as an example of how per-write overhead is actually important to
> throughput. Ignore the "global lock caused overall throughput
> issues" because we don't have that problem any more, and instead
> look at it as a demonstration of "anything that slows down a write()
> reduces per-thread throughput".
> 

Makes sense, and that's how I took it after reading through the paper.
My point was just that I think this is more of a tradeoff and caveat to
consider than something that outright rules out doing less agressive
preallocation in certain cases.

I ran a few tests yesterday out of curiousity and was able to measure (a
small) difference in single-threaded buffered writes to cache with and
without preallocation. What I found a bit interesting was that my
original attempt to test this actually showed _faster_ throughput
without preallocation because the mechanism I happened to use to bypass
preallocation was an up front truncate. I eventually realized that this
had other effects (i.e., one copy doing size updates vs. the other not
doing so) and just compared a fixed, full size (1G) preallocation with a
fixed 4k preallocation to reproduce the boost provided by the former.
The point here is that while there is such a boost, there are also other
workload dependent factors that are out of our control. For example,
somebody who today cares about preallocation only for a boost on writes
to cache can apparently achieve a greater benefit by truncating the file
up front and disabling preallocation entirely.

Moving beyond the truncate thing, I also saw the benefit of
preallocation diminish as write buffer size was increased. As the write
size increases from 4k to around 64k, the pure performance benefit of
preallocation trailed off to zero. Part of that could also be effects of
less frequent size updates and whatnot due to the larger writes, but I
also don't think that's an uncommon thing in practice.

My only point here is that I don't think it's so cut and dry that we
absolutely need dynamic speculative preallocation for write to cache
performance. There is definitely an existing benefit and
perf/scalability caveats to consider before changing anything as such.
TBH it's probably not worth getting too much into the weeds here because
I don't really have any great solution/alternative in mind at the moment
beyond what has already been proposed. It's much easier to reason about
(and test) an actual prototype of some sort as opposed to handwavy and
poorly described ideas :P, but I also don't think it's reasonable or
wise to restrict ourselves to a particular implementation for what seem
like secondary benefits.

> > It certainly makes sense that a delayed allocation buffered
> > write does more work than a non-alloc write, but this document isn't
> > necessarily claiming that as evidence of measurably faster or slower
> > single threaded buffered writes. Rather, that overhead becomes
> > measurable with enough parallel buffered writes contending on a global
> > allocation critical section (section 5.1 "Spinlocks in Hot Paths").
> 
> It's just an example of how increasing per-write overhead impacts
> performance. The same can be said for all the memory reclaim
> mods - they also reduced per-write overhead because memory
> allocation for the page cache was much, much faster and required
> much less CPU, so each write spent less time allocating pages to
> cache the data to be written. hence, faster writes....
> 
> > Subsequently, section 6.1.2 addresses that particular issue via the
> > introduction of per-cpu accounting. It looks like there is further
> > discussion around the general link between efficiency and performance,
> > which makes sense, but I don't think that draws a definite conclusion
> > that speculative preallocation needs to be introduced immediately on
> > sequential buffered writes.
> 
> Sure, because the post-EOF preallocation that was already happening
> wasn't the problem, and we couldn't easily address the per-page
> block mapping overhead with generic code changes that would be
> useful in any circumstance (Linux community at the time was hostile
> towards bringing anything useful to XFS into the core kernel code).
> 
> And this was only a small machine (24 CPUs) so we had to address the
> locking problem because increasing speculative prealloc wouldn't
> help solve the global lock contention problems on the 2048p machines
> that SGI was shipping at the time....
> 

Makes sense.

> > What I think it suggests is that we need to
> > consider the potential scalability impact of any prospective change in
> > speculative preallocation behavior (along with the other tradeoffs
> > associated with preallocation) because less aggressive preallocation
> > means more buffered write overhead.
> 
> It's not a scalability problem now because of the fixes made back
> then - it's now just a per-write thread latency and throughput
> issue.
> 
> What is not obvious from the paper is that I designed the XFS
> benchmarks so that it wrote each file into a separate directories to
> place them into different AGs so that they didn't fragment due to
> interleaving writes. i.e. so we could directly control the number of
> sequential write streams going to the disks.
> 
> We had to do that to minimise the seek overhead of the disks so
> they'd run at full bandwidth rather than being seek bound - we had
> to keep the 256 disks at >97% bandwidth utilisation to get to
> 10GB/S, so even one extra seek per disk per second and we wouldn't
> get there.
> 
> IOWs, we'd carefully taken anything to do with fragmentation out of
> the picture entirely, both for direct and buffered writes. We were
> just focussed on write efficiency and maximising total throughput
> and that largely made post-EOF preallocation irrelevant to us.
> 

Ok.

> > BTW for historical context.. was speculative preallocation a thing when
> > this paper was written?
> 
> Yes. specualtive prealloc goes way back into the 90s from Irix.  It
> was first made configurable in XFS via the biosize mount option
> added with v3 superblocks in 1997, but the initial linux port only
> allowed up to 64k.
> 

Hmm, Ok.. so it was originally speculative preallocation without the
"dynamic sizing" logic that we have today. Thanks for the background.

> In 2005, the linux mount option allowed biosize to be extended to
> 1GB, which made sense because >4GB allocation groups (mkfs enabled
> them late 2003) were now starting to be widely used and so users
> were reporting new large AG fragmentation issues that had never been
> seen before. i.e.  it was now practical to have contiguous multi-GB
> extents in files and the delalloc code was struggling to create
> them, so having EOF-prealloc be able to make use of that capability
> was needed....
> 
> And then auto-tuning made sense because more and more people were
> having to use the mount option in more general workloads to avoid
> fragmentation.
> 

"auto-tuning" means "dynamic sizing" here, yes? FWIW, much of this
discussion also makes me wonder how appropriate the current size limit
(64k) on preallocation is for today's filesystems and systems (e.g. RAM
availability), as opposed to something larger (on the order of hundreds
of MBs for example, perhaps 256-512MB).

Brian

> And even since then it's abeen able tweaking the algorithms to stop
> userspace from defeating it and re-introducing fragmentation
> vectors...
> 
> > The doc suggests per-page block allocation needs
> > to be reduced on XFS,
> 
> Yup. It still stands - that was the specific design premise that
> lead to the iomap infrastructure we now have. i.e. do block mapping
> once per write() call, not once per page per write call. early
> prototypes got us a 10-20% increase in single threaded bufered write
> throughput on slow CPUs, and with the current code some high
> throughput buffered write cases either went up by 30-40% or CPU
> usage went down by that amount.
> 
> > but also indicates that XFS had minimal
> > fragmentation compared to other fs'. AFAICT, section 5.2 attributes XFS
> > fragmentation avoidance to delayed allocation (not necessarily
> > preallocation).
> 
> Right, because none of the other filesystems had delayed allocation
> and they were interleaving concurent allocations at write() time.
> i.e. they serialised write() for long periods of time while they did
> global fs allocation, whilst XFS had a low overhead delalloc path
> with a tiny critical global section. i.e. delalloc allowed us to
> defer allocation to writeback where it isn't so throughput critical
> and better allocation decisions can be made.
> 
> IOWs, delalloc was the primary difference in both the fragmentation
> and scalability differences reported in the paper. That XFS did
> small amounts of in-memory-only prealloc beyond EOF during delalloc
> was irrelevant - it's just part of the delalloc mechanism in this
> context....
> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
