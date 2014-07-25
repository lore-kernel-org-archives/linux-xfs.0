Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3517C29DF9
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2014 11:31:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01299304032
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2014 09:31:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JdRl3PzwygeAPByY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Jul 2014 09:31:03 -0700 (PDT)
Date: Fri, 25 Jul 2014 12:30:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 00/18] xfs: sparse inode chunks
Message-ID: <20140725163056.GA3350@laptop.bfoster>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<20140724223211.GQ20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140724223211.GQ20518@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 25, 2014 at 08:32:11AM +1000, Dave Chinner wrote:
> On Thu, Jul 24, 2014 at 10:22:50AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > This is a first pass at sparse inode chunk support for XFS. Some
> > background on this work is available here:
> > 
> > http://oss.sgi.com/archives/xfs/2013-08/msg00346.html
> > 
> > The basic idea is to allow the partial allocation of inode chunks into
> > fragmented regions of free space. This is accomplished through addition
> > of a holemask field into the inobt record that defines what portion(s)
> > of an inode chunk are invalid (i.e., holes in the chunk). This work is
> > not quite complete, but is at a point where I'd like to start getting
> > feedback on the design and what direction to take for some of the known
> > gaps.
> > 
> > The basic breakdown of functionality in this set is as follows:
> > 
> > - Patches 1-2 - A couple generic cleanups that are dependencies for later
> >   patches in the series.
> > - Patches 3-5 - Basic data structure update, feature bit and minor
> >   helper introduction.
> > - Patches 6-7 - Update v5 icreate logging and recovery to handle sparse
> >   inode records.
> > - Patches 8-13 - Allocation support for sparse inode records. Physical
> >   chunk allocation and individual inode allocation.
> > - Patches 14-16 - Deallocation support for sparse inode chunks. Physical
> >   chunk deallocation, individual inode free and cluster free.
> > - Patch 17 - Fixes for bulkstat/inumbers.
> > - Patch 18 - Activate support for sparse chunk allocation and
> >   processing.
> > 
> > This work is lightly tested for regression (some xfstests failures due
> > to repair) and basic functionality. I have a new xfstests test I'll
> > forward along for demonstration purposes.
> > 
> > Some notes on gaps in the design:
> > 
> > - Sparse inode chunk allocation granularity:
> > 
> > The current minimum sparse chunk allocation granularity is the cluster
> > size.
> 
> Looking at the patchset (I got to patch 5 that first uses this),
> this is problematic. the cluster size is currently a kernel
> implementation detail, and not something defined by the on-disk
> format. We can change the cluster size in the kernel and not affect
> the format on disk. Making the cluster size a part of the disk
> format by defining it to be the resolution of sparse inode chunks
> changes that - it's now a part of the on-disk inode format, and that
> greatly limits what we can do with it.
> 

I was going off the inoalignmt bit that's set at mkfs time, but looking
at the code I think I see what you mean...

> > My initial attempts at this work tried to redefine to the minimum
> > chunk length based on the holemask granularity (a la the stale macro I
> > seemingly left in this series ;), but this involves tweaking the
> > codepaths that use the cluster size (i.e., imap) which proved rather
> > hairy.
> 
> This is where we need to head towards, though. The cluster size is
> currently the unit of inode IO, so that needs to be influenced by the
> sparse inode chunk granularity. Yes, we can define the inode chunk
> granularity to be the same as the cluster size, but that simply
> means we need to configure the cluster size appropriately at mount.
> It doesn't mean we need to change what cluster size means or it's
> implementation....
> 

I don't think I've necessarily encoded the cluster size into the disk
format explicitly, but rather used it as a heuristic for how to size the
sparse inode chunk allocations. I think what you're saying is that the
cluster size can change across a mount or code update, while the on-disk
allocation state will not. Thus we can't always go on the assumption
that the on-disk allocations will be sane with regard to the current
cluster size. For example, I suppose if the cluster size increased after
we have some existing sparse allocations we'd end up with some broken
buffer mappings for inode chunks.

> > This also means we need a solution where an imap can change if an
> > inode was initially mapped as a sparse chunk and said chunk is
> > subsequently made full. E.g., we'd perhaps need to invalidate the inode
> > buffers for sparse chunks at the time where they are made full. Given
> > that, I landed on using the cluster size and leaving those codepaths as
> > is for the time being.
> 
> Again, that's kernel inode buffer cache implementaiton details, not
> something that matters for the on-disk format. So really these need
> to be separated. Probably means we need a "sparse inode allocation
> alignment" field in the superblock to define this. Having
> the kernel reject sparse alignments it can't support from the
> initial implementation means we can improve the kernel
> implementation over time and (eventually) support sub-cluster sized
> sparse inode allocation.
> 
> i.e. initial implementation only supports sparse alignment ==
> cluster size, and rejects everything else....
> 

Yeah, that's pretty much what I was trying to accomplish, just not
encoded properly with regard to the superblock options. E.g., I
overloaded the cluster size in a fragile way. Instead, explicitly set
the sparse inode allocation granularity and let that influence the
cluster size. I suspect that means we could even still use the cluster
size heuristic to define the default alloc. granularity, but of course
we aren't married to it so can evaluate that independently. That sounds
much nicer, thanks.

> > There is a tradeoff here for v5 superblocks because we've recently made
> > a change to scale the cluster size based on the factor increase in the
> > inode size from the default (see xfsprogs commit 7b5f9801). This means
> > that effectiveness of sparse chunks is tied to whether the level of free
> > space fragmentation matches the cluster size. By that I mean effectivess
> > is good (near 100% utilization possible) if free space fragmentation
> > leaves free extents around that at least match the cluster size. If
> > fragmentation is worse than the cluster size, effectiveness is reduced.
> > This can also be demonstrated with the forthcoming xfstests test.
> 
> Exactly. We don't need to solve every problem with the initial
> implementation - we can iteratively improve the code because once
> the fields are one disk we only need to change the kernel
> implemenation to support finer grained sparse allocation to solve
> this allocation chunk < cluster size problem....
> 

Right... I didn't want to rule out fixing the imap logic and whatnot at
all by any means. I thought about it a bit, but the solution isn't yet
clear and certainly could involve some more refactoring or rethinking of
abstractions, so I think that's better suited as a follow on effort.

> > - On-disk lifecycle of the sparse inode chunks feature bit:
> > 
> > We set an incompatible feature bit once a sparse inode chunk is
> > allocated because older revisions of code will interpret the non-zero
> > holemask bits in the higher order bytes of the record freecount. The
> > feature bit must be removed once all sparse inode chunks are eliminated
> > one way or another. This series does not currently remove the feature
> > bit once set simply because I hadn't thought through the mechanism quite
> > yet. For the next version, I'm thinking about adding an inobt walk
> > mechanism that can be conditionally invoked (i.e., feature bit is
> > currently set and a sparse inode chunk has been eliminated) either via
> > workqueue on an interval or during unmount if necessary. Thoughts or
> > alternative suggestions on that appreciated.
> 
> I wouldn't bother. Let xfs_repair determine if the bit needs to be
> set or not when it does it's final superblock write after it has
> scanned and repaired the fs.
> 

That sounds good to me.

> I'm even in two minds of whether we want the sb bit added
> dynamically, because it means the same upgrade/downdgrade cycle can
> have different results simply due to filesystem freespace
> fragmentation patterns...
> 
> Perhaps an xfs-admin command to turn the feature on dynamicallyi for
> existing filesystems, kind of like what we did with lazy superblock
> counters when they were introduced?
> 

Hmm, I suppose that does create a new and interesting dynamic with
regard to the feature bit (non-deterministic backwards compatibility).
One could certainly value backwards compatibility over this particular
feature, and there is currently no way to control it. I'll look into
doing something with xfs_admin. In fact, I was thinking of adding
something to tune the cluster size bit to get around the v5 scaling
issue anyways.

Thanks for the feedback. I'm under the weather today so I'll start going
through the rest of it when my head is less foggy.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
