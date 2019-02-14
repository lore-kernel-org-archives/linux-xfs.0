Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:26237 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390768AbfBNVva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 16:51:30 -0500
Date: Fri, 15 Feb 2019 08:51:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/3]: Extreme fragmentation ahoy!
Message-ID: <20190214215124.GU14116@dastard>
References: <20190207053941.GL14116@dastard>
 <20190207155242.GE2880@bfoster>
 <20190208024730.GM14116@dastard>
 <20190208123432.GB21317@bfoster>
 <20190212011333.GB23989@magnolia>
 <20190212114630.GA35242@bfoster>
 <20190212202150.GS14116@dastard>
 <20190213135021.GB42812@bfoster>
 <20190213222726.GT14116@dastard>
 <20190214130014.GA47851@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214130014.GA47851@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Feb 14, 2019 at 08:00:14AM -0500, Brian Foster wrote:
> On Thu, Feb 14, 2019 at 09:27:26AM +1100, Dave Chinner wrote:
> > On Wed, Feb 13, 2019 at 08:50:22AM -0500, Brian Foster wrote:
> > > On Wed, Feb 13, 2019 at 07:21:51AM +1100, Dave Chinner wrote:
> > > > On Tue, Feb 12, 2019 at 06:46:31AM -0500, Brian Foster wrote:
> > > > > On Mon, Feb 11, 2019 at 05:13:33PM -0800, Darrick J. Wong wrote:
> > > > > > On Fri, Feb 08, 2019 at 07:34:33AM -0500, Brian Foster wrote:
> > > > > For example, extent size hints just happen to skip delayed allocation.
> > > > > I don't recall the exact history, but I don't think this was always the
> > > > > case for extsz hints.
> > > > 
> > > > It wasn't, but extent size hints + delalloc never played nicely and
> > > > could corrupt or expose stale data and caused all sorts of problems
> > > > at ENOSPC because delalloc reservations are unaware of alignment
> > > > requirements for extent size hints. Hence to make extent size hints
> > > > work for buffered writes, I simply made them work the same way as
> > > > direct writes (i.e. immediate allocation w/ unwritten extents).
> > > > 
> > > > > So would the close time eofb trim be as
> > > > > problematic as for extsz hint files if the behavior of the latter
> > > > > changed back to using delayed allocation?
> > > > 
> > > > Yes, but if it's a write-once file that doesn't matter. If it's
> > > > write-many, then we'd retain the post-eof blocks...
> > > > 
> > > > > I think a patch for that was
> > > > > proposed fairly recently, but it depended on delalloc -> unwritten
> > > > > functionality which still had unresolved issues (IIRC).
> > > > 
> > > > *nod*
> > > > 
> > > > > From another angle, would a system that held files open for a
> > > > > significant amount of time relative to a one-time write such that close
> > > > > consistently occurred after writeback (and thus delalloc conversion) be
> > > > > susceptible to the same level of free space fragmentation as shown
> > > > > above?
> > > > 
> > > > If the file is held open for writing for a long time, we have to
> > > > assume that they are going to write again (and again) so we should
> > > > leave the EOF blocks there. If they are writing slower than the eofb
> > > > gc, then there's nothing more we can really do in that case...
> > > > 
> > > 
> > > I'm not necessarily sure that this condition is always a matter of
> > > writing too slow. It very well may be true, but I'm curious if there are
> > > parallel copy scenarios (perhaps under particular cpu/RAM configs)
> > > where we could end up doing a large number of one time file writes and
> > > not doing the release time trim until an underlying extent (with
> > > post-eof blocks) has been converted in more cases than not.
> > 
> > I'm not sure I follow what sort of workload and situation you are
> > describing here. Are you talking about the effect of an EOFB gc pass
> > during ongoing writes?
> > 
> 
> I'm not sure if it's an actual reproducible situation.. I'm just
> wondering out loud if there are normal workloads that might still defeat
> a one-time trim at release time. For example, copy enough files in
> parallel such that writeback touches most of them before the copies
> complete and we end up trimming physical blocks rather than delalloc
> blocks.
> 
> This is not so much of a problem if those files are large, I think,
> because then the preallocs and the resulting trimmed free space is on
> the larger side as well. If we're copying a bunch of little files with
> small preallocs, however, then we put ourselves in the pathological
> situation shown in Darrick's test.
> 
> I was originally thinking about whether this could happen or not on a
> highly parallel small file copy workload, but having thought about it a
> bit more I think there is a more simple example. What about an untar
> like workload that creates small files and calls fsync() before each fd
> is released?

Which is the same as an O_SYNC write if it's the same fd, which
means we'll trim allocated blocks on close. i.e. it's no different
to the current behaviour.  If such files are written in parallel then,
again, it is no different to the existing behaviour. i.e. it
largely depends on the timing of allocation in writeback and EOF
block clearing in close(). If close happens before the next
allocation in that AG, then they'll pack because there's no EOF
blocks that push out the new allocation.  If it's the other way
around, we get some level of freespace fragmentation.

THis is mitigated by the fact that workloads like this tend to be
separated into separate AGs - allocation first attempts to be
non-blocking which means if it races with a free in progress it will
skip to the next AG and it won't pack sequentially, anyway. So I
don't think this is a major concern in terms of free space
fragmentation - the allocator AG selection makes it impossible to
predict what happens when racing alloc/frees occur in a single AG
and we really try to avoid that as much as possible, anyway.

If it's a separate open/fsync/close pass after all the writes (and
close) then the behaviour is the same with either the existing code
or the "trim on first close" behaviour - and the delalloc blocks
beyond EOF will get killed on the first close and not be present for
the writeback, and all is good.

> Wouldn't that still defeat a one-time release heuristic and
> produce the same layout issues as shown above? We'd prealloc,
> writeback/convert then trim small/spurious fragments of post-eof space
> back to the allocator.

Yes, but as far as I can reason (sanely), "trim on first close" is
no worse that the existing heuristic in these cases, whilst being
significantly better in others we have observed in the wild that
cause problems...

I'm not looking for perfect here, just "better with no obvious
regressions". We can't predict every situation, so if it deals with
all the problems we've had reported and a few similar cases we don't
curently handle as well, then we should run with that and not really
worry about the cases that it (or the existing code) does not
solve until we have evidence that those workloads exist and are
causing real world problems. It's a difficult enough issue to reason
about without making it more complex by playing "what about" games..

> > > It sounds like what you're saying is that it doesn't really matter
> > > either way at this point. There's no perf advantage to keeping the eof
> > > blocks in this scenario, but there's also no real harm in deferring the
> > > eofb trim of physical post-eof blocks because any future free space
> > > fragmentation damage has already been done (assuming no more writes come
> > > in).
> > 
> > Essentially, yes.
> > 
> > > The thought above was tip-toeing around the idea of (in addition to the
> > > one-time trim heuristic you mentioned above) never doing a release time
> > > trim of non-delalloc post-eof blocks.
> > 
> > Except we want to trim blocks in the in the cases where it's a write
> > once file that has been fsync()d or written by O_DIRECT w/ really
> > large extent size hints....
> 
> We still would trim it. The one time write case is essentially
> unaffected because the only advantage of that hueristic is to trim eof
> blocks before they are converted. If the eof blocks are real, the
> release time heuristic has already failed (i.e., it hasn't provided any
> benefit that background trim doesn't already provide).

No, all it means is that the blocks were allocated before the fd was
closed, not that the release time heuristic failed. The release time
heuristic is deciding what to do /after/ the writes have been
completed, whatever the post-eof situation is. It /can't fail/ if it
hasn't been triggered before physical allocation has been done, it
can only decide what to do about those extents once it is called...

In which case, if it's a write-once file we want to kill the blocks,
no matter whether they are allocated or not. And if it's a repeated
open/X/close workload, then a single removal of EOF blocks won't
greatly impact the file layout because subsequent closes won't
trigger.

IOWs, in the general case it does the right thing, and when it's
wrong the impact is negated by the fact it will do the right thing
on all future closes on that inode....

> IOW, what we really want to avoid is trimming (small batches of) unused
> physical eof blocks.

For the general case, I disagree. :)

> > > > IOWs, speculative prealloc beyond EOF is not just about preventing
> > > > fragmentation - it also helps minimise the per-write CPU overhead of
> > > > delalloc space accounting. (i.e. allows faster write rates into
> > > > cache). IOWs, for anything more than a really small files, we want
> > > > to be doing speculative delalloc on the first time the file is
> > > > written to.
> > > > 
> > > 
> > > Ok, this paper refers to CPU overhead as it contributes to lack of
> > > scalability.
> > 
> > Well, that was the experiments that were being performed. I'm using
> > it as an example of how per-write overhead is actually important to
> > throughput. Ignore the "global lock caused overall throughput
> > issues" because we don't have that problem any more, and instead
> > look at it as a demonstration of "anything that slows down a write()
> > reduces per-thread throughput".
> > 
> 
> Makes sense, and that's how I took it after reading through the paper.
> My point was just that I think this is more of a tradeoff and caveat to
> consider than something that outright rules out doing less agressive
> preallocation in certain cases.
> 
> I ran a few tests yesterday out of curiousity and was able to measure (a
> small) difference in single-threaded buffered writes to cache with and
> without preallocation. What I found a bit interesting was that my
> original attempt to test this actually showed _faster_ throughput
> without preallocation because the mechanism I happened to use to bypass
> preallocation was an up front truncate.

So, like:

$ xfs_io -f -t -c "pwrite 0 1g" /mnt/scratch/testfile
wrote 1073741824/1073741824 bytes at offset 0
1 GiB, 262144 ops; 0.6582 sec (1.519 GiB/sec and 398224.4691 ops/sec)
$

Vs:

$ xfs_io -f -t -c "truncate 1g" -c "pwrite 0 1g" -c "fsync" /mnt/scratch/testfile
wrote 1073741824/1073741824 bytes at offset 0
1 GiB, 262144 ops; 0.7159 sec (1.397 GiB/sec and 366147.4512 ops/sec)
$

I get an average of 1.53GiB/s write rate into cache with
speculative prealloc active, and only 1.36GiB/s write rate in cache
without it. I've run these 10 times each, ranges are
1.519-1.598GiB/s for prealloc and 1.291-1.361GiB/s whenusing
truncate to prevent prealloc.

IOWs, on my test machine, the write rate into cache using 4kB writes
is over 10% faster with prealloc enabled. And to point out the
dminishing returns, with a write size of 1MB:

$  xfs_io -f -t -c "truncate 1g" -c "pwrite 0 1g -b 1M" -c "fsync" /mnt/scratch/testfile
wrote 1073741824/1073741824 bytes at offset 0
1 GiB, 1024 ops; 0.4975 sec (2.010 GiB/sec and 2058.1922 ops/sec)

The throughput with or without prealloc average out just over
2GiB/s and the difference is noise (2.03GiB/s vs 2.05GiB/s)

Note: I'm jsut measuring write-in rates here, and I've isolated them
from writeback completely because the file size is small enough
that dirty throttling (20% of memory) isn't kicking in because I
have 16GB of RAM on this machine. If I go over 3GB in file size,
dirty throttling and writeback kicks in and the results are a
complete crap-shoot because it's dependent on when writeback kicks
in and how the writeback rate ramps up in the first second of
writeback.

> I eventually realized that this
> had other effects (i.e., one copy doing size updates vs. the other not
> doing so) and just compared a fixed, full size (1G) preallocation with a
> fixed 4k preallocation to reproduce the boost provided by the former.

That only matters for *writeback overhead*, not ingest efficiency.
Indeed, using a preallocated extent:

$ time sudo xfs_io -f -t -c "falloc 0 1g" -c "pwrite 0 1g" -c "fsync" /mnt/scratch/testfile
wrote 1073741824/1073741824 bytes at offset 0
1 GiB, 262144 ops; 0.6610 sec (1.513 GiB/sec and 396557.5926 ops/sec)


$ xfs_io -f -t -c "falloc 0 1g" -c "pwrite 0 1g -b 1M" -c "fsync" /mnt/scratch/testfile
wrote 1073741824/1073741824 bytes at offset 0
1 GiB, 1024 ops; 0.4946 sec (2.022 GiB/sec and 2070.0795 ops/sec)

The write-in rates are identical to when specualtive prealloc is
enabled (always hitting a preexisting extent and not having to
extend an extent on every iomap lookup). If I time the fsync, then
things are different because there's additional writeback overhead
(i.e. unwritten extent conversion), but this does not affect the
per-write cache ingest CPU overhead.

> The point here is that while there is such a boost, there are also other
> workload dependent factors that are out of our control. For example,
> somebody who today cares about preallocation only for a boost on writes
> to cache can apparently achieve a greater benefit by truncating the file
> up front and disabling preallocation entirely.

Can you post your tests and results, because I'm getting very
different results from running what I think are the same tests.

> Moving beyond the truncate thing, I also saw the benefit of
> preallocation diminish as write buffer size was increased. As the write
> size increases from 4k to around 64k, the pure performance benefit of
> preallocation trailed off to zero.

Yes, because we've optimised the overhead out of larger writes with
the iomap infrastructure. This used to be a whole lot worse when we
did a delalloc mapping for every page instead of one per write()
call. IOWs, a significant part of the 30-35% speed increase you see in my numbers above
going from 4kB writes to 1MB writes is a result of iomap dropping
the number of delalloc mapping calls by a factor of 256....

> Part of that could also be effects of
> less frequent size updates and whatnot due to the larger writes, but I
> also don't think that's an uncommon thing in practice.

Again, size updates are only done on writeback, not ingest....

> My only point here is that I don't think it's so cut and dry that we
> absolutely need dynamic speculative preallocation for write to cache
> performance.

History, experience with both embedded and high end NAS machines
(where per-write CPU usage really matters!) and my own experiements
tell me a different story :/

> > > BTW for historical context.. was speculative preallocation a thing when
> > > this paper was written?
> > 
> > Yes. specualtive prealloc goes way back into the 90s from Irix.  It
> > was first made configurable in XFS via the biosize mount option
> > added with v3 superblocks in 1997, but the initial linux port only
> > allowed up to 64k.
> > 
> 
> Hmm, Ok.. so it was originally speculative preallocation without the
> "dynamic sizing" logic that we have today. Thanks for the background.
> 
> > In 2005, the linux mount option allowed biosize to be extended to
> > 1GB, which made sense because >4GB allocation groups (mkfs enabled
> > them late 2003) were now starting to be widely used and so users
> > were reporting new large AG fragmentation issues that had never been
> > seen before. i.e.  it was now practical to have contiguous multi-GB
> > extents in files and the delalloc code was struggling to create
> > them, so having EOF-prealloc be able to make use of that capability
> > was needed....
> > 
> > And then auto-tuning made sense because more and more people were
> > having to use the mount option in more general workloads to avoid
> > fragmentation.
> > 
> 
> "auto-tuning" means "dynamic sizing" here, yes?

Yes.

> FWIW, much of this
> discussion also makes me wonder how appropriate the current size limit
> (64k) on preallocation is for today's filesystems and systems (e.g. RAM
> availability), as opposed to something larger (on the order of hundreds
> of MBs for example, perhaps 256-512MB).

RAM size is irrelevant. What matters is file size and the impact
of allocation patterns on writeback IO patterns. i.e. the size limit
is about optimising writeback, not preventing fragmentation or
making more efficient use of memory, etc.

i.e. when we have lots of small files, we want writeback to pack
them so we get multiple-file sequentialisation of the write stream -
this makes things like untarring a kernel tarball (which is a large
number of small files) a sequential write workload rather than a
seek-per-individual-file-write workload. That make a massive
difference to performance on spinning disks, and that's what the 64k
threshold (and post-EOF block removal on close for larger files)
tries to preserve.

Realistically, we should probably change that 64k threshold to match
sunit if it is set, so that we really do end up trying to pack
any write once file smaller than sunit as the allocator won't try
to align them, anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
