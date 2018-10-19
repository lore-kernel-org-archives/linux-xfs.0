Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:62008 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725934AbeJSJTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Oct 2018 05:19:15 -0400
Date: Fri, 19 Oct 2018 12:15:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENSOPC on a 10% used disk
Message-ID: <20181019011526.GJ6311@dastard>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 18, 2018 at 02:00:19PM +0300, Avi Kivity wrote:
> On 18/10/2018 13.05, Dave Chinner wrote:
> >On Thu, Oct 18, 2018 at 10:55:18AM +0300, Avi Kivity wrote:
> >>On 18/10/2018 04.37, Dave Chinner wrote:
> >>>On Wed, Oct 17, 2018 at 10:52:48AM +0300, Avi Kivity wrote:
> >>>>I have a user running a 1.7TB filesystem with ~10% usage (as shown
> >>>>by df), getting sporadic ENOSPC errors. The disk is mounted with
> >>>>inode64 and has a relatively small number of large files. The disk
> >>>>is a single-member RAID0 array, with 1MB chunk size. There are 32
> >Ok, now I need to know what "single member RAID0 array" means,
> >becuase this is clearly related to allocation alignment and I need
> >to know why the FS was configured the way it was.
> 
> 
> It's a Linux RAID device, /dev/md0.
> 
> 
> We configure it this way so that it's easy to add storage (okay, the
> real reason is probably to avoid special casing one drive).

As a stripe? That requires resilvering to expand, which is a slow,
messy operation. There's also been too many horror stories about
crashes during rsilvering causing unrecoverable corruptions for my
liking...

> One disk, organized into a Linux RAID device with just one member.

So there's no realy need for IO alignment at all. Unaligned writes
to RAID0 don't require RMW cycles, so alignment is really onl used
to avoid hotspotting a disk in the stripe. Which isn't an issue
here, either.

> >>meta-data=/dev/loop2		isize=512 agcount=32, agsize=14494720 blks
> >>          =                    sectsz=512 attr=2, projid32bit=1
> >>          =                    crc=1 finobt=0 spinodes=0 rmapbt=0
> >>          =                    reflink=0
> >>data     =                    bsize=4096 blocks=463831040, imaxpct=5
> >>          =                    sunit=256 swidth=256 blks
> >sunit=swidth is unusual for a RAID0 array, unless it's hardware RAID
> >and the array only reports one number to mkfs. What this chosen by
> >mkfs, or specifically configured by the user? If specifically
> >configured, why?
> 
> 
> I'm guessing it's because it has one member? I'm guessing the usual
> is swidth=sunit*nmembers?

*nod*. Which is unusual for a RAID0 device.

> >What is important is that it means aligned allocations will be used
> >for any allocation that is over sunit (1MB) and that's where all the
> >problems seem to come from.
> 
> Do these aligned allocations not fall back to non-aligned
> allocations if they fail?

They do, but extent size hints change the fallback behaviour...

> >See how we lost a large aligned 2MB freespace @ 9 when the small
> >file "nn" was laid down? repeat this fill and free pattern over and
> >over again, and eventually it fragments the free space until there's
> >no large contiguous free spaces left, and large aligned extents can
> >no longer be allocated.
> >
> >For this to trigger you need the small files to be larger than 1
> >stripe unit, but still much smaller than the extent size hint, and
> >the small files need to hang around as the large files come and go.
> 
> 
> This can happen, and indeed I see our default hint is 1MB, so our
> small files use a 1MB hint.

Ok, which forces all allocations to be at least stripe unit (1MB)
aligned. 

>
> Looks like we should remove that 1MB
> hint since it's reducing allocation flexibility for XFS without a
> good return. On the other hand, I worry that because we bypass the
> page cache, XFS doesn't get to see the entire file at one time and
> so it will get fragmented.

Yes. Your other option is to use an extent size hint that is smaller
than the sunit. That should not align to 1MB because the initial
data allocation size is not large enough to trigger stripe
alignment.

> Suppose I write a 4k file with a 1MB hint. How is that trailing
> (1MB-4k) marked? Free extent, free extent with extra annotation, or
> allocated extent? We may need to deallocate those extents? (will
> FALLOC_FL_PUNCH_HOLE do the trick?)

It's an unwritten extent beyond EOF, and how that is treated when
the file is last closed depends on how that extent was allocated.
But, yes, punching the range beyond EOF will definitely free it.

> >>>>Is this a known issue?
> >The effect and symptom is - it's a generic large aligned extent vs small unaligned extent
> >issue, but I've never seen it manifest in a user workload outside of
> >a very constrained multistream realtime video ingest/playout
> >workload (i.e. the workload the filestreams allocator was written
> >for). And before you ask, no, the filestreams allocator does not
> >solve this problem.
> >
> >The most common manifestation of this problem has been inode
> >allocation on filesystems full of small files - inodes are allocated
> >in large aligned extents compared to small files, and so eventually
> >the filesystem runs out of large contigouous freespace and inodes
> >can't be allocated. The sparse inodes mkfs option fixed this by
> >allowing inodes to be allocated as sparse chunks so they could
> >interleave into any free space available....
> 
> Shouldn't XFS fall back to a non-aligned allocation rather that
> returning ENOSPC on a filesystem with 90% free space?

The filesystem does fall back to unaligned allocation - there's ~5
spearate, progressively less strict allocation attempts on failure.

The problem is that the extent size hint is asking to allocate a
contiguous 32MB extent and there's no contiguous 32MB free space
extent available, aligned or not.  That's what I think is generating
the ENOSPC error, but it's not clear to me from the code whether it
is supposed to ignore the extent size hint on failure and allocate a
set of shorter unaligned extents or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
