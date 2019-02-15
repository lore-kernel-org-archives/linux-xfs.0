Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731691AbfBOUd1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Feb 2019 15:33:27 -0500
Date: Fri, 15 Feb 2019 15:33:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/3]: Extreme fragmentation ahoy!
Message-ID: <20190215203322.GA53333@bfoster>
References: <20190208123432.GB21317@bfoster>
 <20190212011333.GB23989@magnolia>
 <20190212114630.GA35242@bfoster>
 <20190212202150.GS14116@dastard>
 <20190213135021.GB42812@bfoster>
 <20190213222726.GT14116@dastard>
 <20190214130014.GA47851@bfoster>
 <20190214215124.GU14116@dastard>
 <20190215023520.GA50265@bfoster>
 <20190215072332.GZ14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215072332.GZ14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Feb 15, 2019 at 06:23:32PM +1100, Dave Chinner wrote:
> On Thu, Feb 14, 2019 at 09:35:21PM -0500, Brian Foster wrote:
> > On Fri, Feb 15, 2019 at 08:51:24AM +1100, Dave Chinner wrote:
> > > On Thu, Feb 14, 2019 at 08:00:14AM -0500, Brian Foster wrote:
> > > > On Thu, Feb 14, 2019 at 09:27:26AM +1100, Dave Chinner wrote:
> > > > > On Wed, Feb 13, 2019 at 08:50:22AM -0500, Brian Foster wrote:
> > > > > > On Wed, Feb 13, 2019 at 07:21:51AM +1100, Dave Chinner wrote:
> > > > > > > On Tue, Feb 12, 2019 at 06:46:31AM -0500, Brian Foster wrote:
> > > > > > > > On Mon, Feb 11, 2019 at 05:13:33PM -0800, Darrick J. Wong wrote:
> > > > > > > > > On Fri, Feb 08, 2019 at 07:34:33AM -0500, Brian Foster wrote:
> > > > > > > > For example, extent size hints just happen to skip delayed allocation.
> > > > > > > > I don't recall the exact history, but I don't think this was always the
> > > > > > > > case for extsz hints.
> > > > > > > 
> > > > > > > It wasn't, but extent size hints + delalloc never played nicely and
> > > > > > > could corrupt or expose stale data and caused all sorts of problems
> > > > > > > at ENOSPC because delalloc reservations are unaware of alignment
> > > > > > > requirements for extent size hints. Hence to make extent size hints
> > > > > > > work for buffered writes, I simply made them work the same way as
> > > > > > > direct writes (i.e. immediate allocation w/ unwritten extents).
> > > > > > > 
> > > > > > > > So would the close time eofb trim be as
> > > > > > > > problematic as for extsz hint files if the behavior of the latter
> > > > > > > > changed back to using delayed allocation?
> > > > > > > 
> > > > > > > Yes, but if it's a write-once file that doesn't matter. If it's
> > > > > > > write-many, then we'd retain the post-eof blocks...
> > > > > > > 
> > > > > > > > I think a patch for that was
> > > > > > > > proposed fairly recently, but it depended on delalloc -> unwritten
> > > > > > > > functionality which still had unresolved issues (IIRC).
> > > > > > > 
> > > > > > > *nod*
> > > > > > > 
> > > > > > > > From another angle, would a system that held files open for a
> > > > > > > > significant amount of time relative to a one-time write such that close
> > > > > > > > consistently occurred after writeback (and thus delalloc conversion) be
> > > > > > > > susceptible to the same level of free space fragmentation as shown
> > > > > > > > above?
> > > > > > > 
> > > > > > > If the file is held open for writing for a long time, we have to
> > > > > > > assume that they are going to write again (and again) so we should
> > > > > > > leave the EOF blocks there. If they are writing slower than the eofb
> > > > > > > gc, then there's nothing more we can really do in that case...
> > > > > > > 
> > > > > > 
> > > > > > I'm not necessarily sure that this condition is always a matter of
> > > > > > writing too slow. It very well may be true, but I'm curious if there are
> > > > > > parallel copy scenarios (perhaps under particular cpu/RAM configs)
> > > > > > where we could end up doing a large number of one time file writes and
> > > > > > not doing the release time trim until an underlying extent (with
> > > > > > post-eof blocks) has been converted in more cases than not.
> > > > > 
> > > > > I'm not sure I follow what sort of workload and situation you are
> > > > > describing here. Are you talking about the effect of an EOFB gc pass
> > > > > during ongoing writes?
> > > > > 
> > > > 
> > > > I'm not sure if it's an actual reproducible situation.. I'm just
> > > > wondering out loud if there are normal workloads that might still defeat
> > > > a one-time trim at release time. For example, copy enough files in
> > > > parallel such that writeback touches most of them before the copies
> > > > complete and we end up trimming physical blocks rather than delalloc
> > > > blocks.
> > > > 
> > > > This is not so much of a problem if those files are large, I think,
> > > > because then the preallocs and the resulting trimmed free space is on
> > > > the larger side as well. If we're copying a bunch of little files with
> > > > small preallocs, however, then we put ourselves in the pathological
> > > > situation shown in Darrick's test.
> > > > 
> > > > I was originally thinking about whether this could happen or not on a
> > > > highly parallel small file copy workload, but having thought about it a
> > > > bit more I think there is a more simple example. What about an untar
> > > > like workload that creates small files and calls fsync() before each fd
> > > > is released?
> > > 
> > > Which is the same as an O_SYNC write if it's the same fd, which
> > > means we'll trim allocated blocks on close. i.e. it's no different
> > > to the current behaviour.  If such files are written in parallel then,
> > > again, it is no different to the existing behaviour. i.e. it
> > > largely depends on the timing of allocation in writeback and EOF
> > > block clearing in close(). If close happens before the next
> > > allocation in that AG, then they'll pack because there's no EOF
> > > blocks that push out the new allocation.  If it's the other way
> > > around, we get some level of freespace fragmentation.
> > > 
> > 
> > I know it's the same as the current behavior. ;P I think we're talking
> > past eachother on this.
> 
> Probably :P
> 
> > What I'm saying is that the downside to the
> > current behavior is that a simple copy file -> fsync -> copy next file
> > workload fragments free space.
> 
> Yes. But it's also one of the cases that "always release on first
> close" fixes.
> 
> > Darrick demonstrated this better in his random size test with the
> > release time trim removed, but a simple loop to write one thousand 100k
> > files (xfs_io -fc "pwrite 0 100k" -c fsync ...) demonstrates similar
> > behavior:
> > 
> > # xfs_db -c "freesp -s" /dev/fedora_rhs-srv-19/tmp
> >    from      to extents  blocks    pct
> >       1       1      18      18   0.00
> >      16      31       1      25   0.00
> >      32      63       1      58   0.00
> >  131072  262143     924 242197739  24.97
> >  262144  524287       1  365696   0.04
> > 134217728 242588672       3 727292183  74.99
> 
> That should not be leaving freespace fragments behind - it should be
> trimming the EOF blocks on close after fsync() and the next
> allocation should pack tightly.
> 
> /me goes off to trace it because it's not doing what he knows it
> should be doing.
> 
> Ngggh. Busy extent handling.
> 
> Basically, the extent we trimmed is busy because it is a user data
> extent that has been freed and not yet committed (even though it was
> not used), so it gets trimmed out of the free space range that is
> allocated.
> 
> IOWs, how we handle busy extents results in this behaviour, not the
> speculative prealloc which has already been removed and returned to
> the free space pool....
> 
> > vs. the same test without the fsync:
> > 
> > # xfs_db -c "freesp -s" /dev/fedora_rhs-srv-19/tmp 
> >    from      to extents  blocks    pct
> >       1       1      16      16   0.00
> >      16      31       1      20   0.00
> > 4194304 8388607       2 16752060   1.73
> > 134217728 242588672       4 953103627  98.27
> > 
> > Clearly there is an advantage to trimming before delalloc conversion.
> 
> The advantage is in avoiding busy extents by trimming before
> physical allocation occurs. I think we need to fix the busy extent
> handling here, not the speculative prealloc...
> 

Ok, that might be a reasonable approach for this particular pattern. It
might not help for other (probably less common) patterns. In any event,
I hope this at least shows why I'm fishing for further improvements..

> > Random thought: perhaps a one time trim at writeback (where writeback
> > would convert delaloc across eof) _or_ release time, whichever happens
> > first on an inode with preallocation, might help mitigate this problem.
> 
> Not sure how you'd do that reliably - there's no serialisation with
> incoming writes, and no context as to what is changing EOF. Hence I
> don't know how we'd decide that trimming was required or not...
> 

That's not that difficult to work around. If writeback can't reliably
add/remove blocks, it can make decisions about how many blocks to
convert in particular situations. A writeback time trim could be
implemented as a trimmed allocation/conversion that would also allow (or
refuse) a subsequent release to still perform the actual post-eof trim.
IOW, consider the approach as more of having a smarter post-eof
writeback delalloc conversion policy rather than exclusively attempting
to address post-eof blocks at release time.

A simple example could be something like not converting post-eof blocks
if the current writeback cycle is attempting to convert the only
delalloc extent in the file and/or if the extent extends from offset
zero to i_size (or whatever heuristic best describes a write once file),
otherwise behave exactly as we do today. That filters out smallish,
write-once files without requiring any changes to the buffered write
time speculative prealloc algorithm. It also could eliminate the need
for a release time trim because unused post-eof blocks are unlikely to
ever turn into physical blocks for small write once files, but I'd have
to think about that angle a bit more.

A tradeoff would be potential for higher fragmentation in cases where
writeback occurs on a single delalloc extent file before the file
finishes being copied, but we're only talking an extra extent or so if
it's a one time "writeback allocation trim" and it's probably likely the
file is large for that to occur in the first place. IOW, the extra
extent should be sized at or around the amount of data we were able
ingest into pagecache before writeback touched the inode.

This is of course just an idea and still subject to prototyping and
testing/experimentation and whatnot...

> > > I'm not looking for perfect here, just "better with no obvious
> > > regressions". We can't predict every situation, so if it deals with
> > > all the problems we've had reported and a few similar cases we don't
> > > curently handle as well, then we should run with that and not really
> > > worry about the cases that it (or the existing code) does not
> > > solve until we have evidence that those workloads exist and are
> > > causing real world problems. It's a difficult enough issue to reason
> > > about without making it more complex by playing "what about" games..
> > > 
> > 
> > That's fair, but we have had users run into this situation. The whole
> > sparse inodes thing is partially a workaround for side effects of this
> > problem (free space fragmentation being so bad we can't allocate
> > inodes). Granted, some of those users may have also been able to avoid
> > that problem with better fs usage/configuration.
> 
> I think systems that required sparse inodes is orthogonal - those
> issues could be caused just with well packed small files and large
> inodes, and had nothing in common with the workload we've recently
> seen. Indeed, in the cases other than the specific small file
> workload gluster used to fragment free space to prevent inode
> allocation, we never got to the bottom of what caused the free space
> fragmentation. All we could do is make the fs more tolerant of
> freespace fragmentation.
> 
> This time, we have direct evidence of what caused freespace
> fragmentation on this specific system. It was caused by the app
> doing something bizarre and we can extrapolate several similar
> behaviours from that workload.
> 
> But beyond that, we're well into "whatabout" and "whatif" territory.
> 
> > > > We still would trim it. The one time write case is essentially
> > > > unaffected because the only advantage of that hueristic is to trim eof
> > > > blocks before they are converted. If the eof blocks are real, the
> > > > release time heuristic has already failed (i.e., it hasn't provided any
> > > > benefit that background trim doesn't already provide).
> > > 
> > > No, all it means is that the blocks were allocated before the fd was
> > > closed, not that the release time heuristic failed. The release time
> > > heuristic is deciding what to do /after/ the writes have been
> > > completed, whatever the post-eof situation is. It /can't fail/ if it
> > > hasn't been triggered before physical allocation has been done, it
> > > can only decide what to do about those extents once it is called...
> > > 
> > 
> > Confused. By "failed," I mean we physically allocated blocks that were
> > never intended to be used.
> 
> How can we know that are never intended to be used at writeback
> time?
> 

We never really know if the blocks will be used or not. That's not the
point. I'm using the term "failed" simply to refer to the case where
post-eof blocks are unused and end up converted to physical blocks
before they are trimmed. I chose the term because that's the scenario
where the current heuristic contributes to free space fragmentation.
This has been demonstrated by Darrick's test and my more simplistic test
above. Feel free to choose a different term for that scenario, but it's
clearly a case that could stand to improve in XFS (whether it be via
something like the writeback time trim, busy extent fixes, etc.).

> > This is basically referring to the negative
> > effect of delalloc conversion -> eof trim behavior on once written files
> > demonstrated above. If this negative effect didn't exist, we wouldn't
> > need the release time trim at all and could just rely on background
> > trim.
> 
> We also cannot predict what the application intends. Hence we have
> heuristics that trigger once the application signals that it is
> "done with this file". i.e. it has closed the fd.
> 

Of course, that doesn't mean we can't try to make it smarter or dampen
negative side effects of the "failure" case.

> > > > I eventually realized that this
> > > > had other effects (i.e., one copy doing size updates vs. the other not
> > > > doing so) and just compared a fixed, full size (1G) preallocation with a
> > > > fixed 4k preallocation to reproduce the boost provided by the former.
> > > 
> > > That only matters for *writeback overhead*, not ingest efficiency.
> > > Indeed, using a preallocated extent:
> > > 
> > 
> > Not sure how we got into physical preallocation here. Assume any
> > reference to "preallocation" in this thread by me refers to post-eof
> > speculative preallocation. The above preallocation tweaks were
> > controlled in my tests via the allocsize mount option, not physical
> > block preallocation.
> 
> I'm just using it to demonstrate the difference is in continually
> extending the delalloc extent in memory. I could have just done an
> overwrite - it's the same thing.
> 
> > > > FWIW, much of this
> > > > discussion also makes me wonder how appropriate the current size limit
> > > > (64k) on preallocation is for today's filesystems and systems (e.g. RAM
> > > > availability), as opposed to something larger (on the order of hundreds
> > > > of MBs for example, perhaps 256-512MB).
> > > 
> > > RAM size is irrelevant. What matters is file size and the impact
> > > of allocation patterns on writeback IO patterns. i.e. the size limit
> > > is about optimising writeback, not preventing fragmentation or
> > > making more efficient use of memory, etc.
> > 
> > I'm just suggesting that the more RAM that is available, the more we're
> > able to write into cache before writeback starts and thus the larger
> > physical extents we're able to allocate independent of speculative
> > preallocation (perf issues notwithstanding).
> 
> ISTR I looked at that years ago and couldn't get it to work
> reliably. It works well for initial ingest, but once the writes go
> on for long enough dirty throttling starts chopping ingest up in
> smaller and smaller chunks as it rotors writeback bandwidth around
> all the processes dirtying the page cache. This chunking happens
> regardless of the size of the file being written. And so the more
> processes that are dirtying the page cache, the smaller the file
> fragments get because each file gets a smaller amount of the overall
> writeback bandwidth each time it writeback occurs. i.e.
> fragmentation increases as memory pressure, load and concurrency
> increases, which are exactly the conditions we want to be avoiding
> fragmentation as much as possible...
> 

Ok, well that suggests less aggressive preallocation is at least worth
considering/investigating.

> The only way I found to prevent this in fair and predictable
> manner is the auto-grow algorithm we have now.  There's very few
> real world corner cases where it break down, so we do not need
> fundamental changes here. We've found one corner case where it is
> defeated, so let's address that corner case with the minimal change
> that is necessary but otherwise leave the underlying algorithm
> alone so we can observe the loner term effects of the tweak we
> need to make....
> 

I agree that an incremental fix is fine for now. I don't agree that the
current implementation is only defeated by corner cases. The write+fsync
example above is a pretty straightforward usage pattern. Userspace
filesystems are also increasingly common and may implement things like
open file caches that distort the filesystems perception of how it's
being used, and thus could defeat a release time trim heuristic in
exactly the same manner. I recall that gluster had something like this,
but I'd have to dig into it to see exactly if it applies here..

> > > i.e. when we have lots of small files, we want writeback to pack
> > > them so we get multiple-file sequentialisation of the write stream -
> > > this makes things like untarring a kernel tarball (which is a large
> > > number of small files) a sequential write workload rather than a
> > > seek-per-individual-file-write workload. That make a massive
> > > difference to performance on spinning disks, and that's what the 64k
> > > threshold (and post-EOF block removal on close for larger files)
> > > tries to preserve.
> > 
> > Sure, but what's the downside to increasing that threshold to even
> > something on the order of MBs? Wouldn't that at least help us leave
> > larger free extents around in those workloads/patterns that do fragment
> > free space?
> 
> Because even for files in th the "few MB" size, worst case
> fragmentation is thousands of extents and IO performance that
> absolutely sucks. Especially on RAID5/6 devices. We have to ensure
> file fragmentation at it's worst does not affect filesystem
> throughput and that means in the general case less than ~1MB sized
> extents is just not acceptible even for smallish files....
> 

Sure, fragmentation is bad. That doesn't answer my question though.
Under what conditions would you expect less aggressive speculative
preallocation in the form of a say 1MB threshold to manifest in a level
of fragmentation "where performance absolutely sucks?" Highly parallel
small file (<1MB) copies in a low memory environment perhaps? If so, how
much is low memory? I would think that if we had gobs of RAM, a good
number of 1MB file copies would make it cache completely before files
currently being written start ever being affected by writeback, but I
could be mistaken about reclaim/writeback behavior..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
