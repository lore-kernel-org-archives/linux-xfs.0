Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750779AbeCNN55 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Mar 2018 09:57:57 -0400
Date: Wed, 14 Mar 2018 14:57:52 +0100
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: XFS crash consistency bug : Loss of fsynced metadata operation
Message-ID: <20180314135752.5a2vmjr7cuavusiw@rh_laptop>
References: <CA+EzBbCtp9wKC=KeN+N1iZDa2+TsWxVho3aUkeXJXguVswkChA@mail.gmail.com>
 <20180313042126.GB18129@dastard>
 <CA+EzBbC9yQyxqiPOTCymrbL=cW-KZq2b8hunf7KEpiNZ9f3s4Q@mail.gmail.com>
 <20180313224522.GZ7000@dastard>
 <20180314131659.wnmt5zxfhrfsld7n@rh_laptop>
 <20180314133258.GB7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180314133258.GB7000@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jayashree Mohan <jayashree2912@gmail.com>, linux-xfs@vger.kernel.org, Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>, Ashlie Martinez <ashmrtn@utexas.edu>, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

On Thu, Mar 15, 2018 at 12:32:58AM +1100, Dave Chinner wrote:
> On Wed, Mar 14, 2018 at 02:16:59PM +0100, Lukas Czerner wrote:
> > On Wed, Mar 14, 2018 at 09:45:22AM +1100, Dave Chinner wrote:
> > > On Tue, Mar 13, 2018 at 11:57:21AM -0500, Jayashree Mohan wrote:
> > > > Hi Dave,
> > > > 
> > > > Thanks for the response. CrashMonkey assumes the following behavior of
> > > > disk cache. Let me know if any of this sounds unreasonable.
> > > > 
> > > > Whenever the underlying storage device has an associated cache, the IO
> > > > is marked completed the moment it reaches the disk cache. This does
> > > > not guarantee that the disk cache would persist them in the same
> > > > order, unless there is a Flush/FUA. The order of completed writes as
> > > > seen by the user could be A, B, C, *Flush* D, E. However the disk
> > > > cache could write these back to the persistent storage in the order
> > > > say B, A, C, E, D. The only invariant it ensures is that writing in an
> > > > order like  A, C, E, B, D is
> > > > not possible because, writes A,B,C have to strictly happen before D
> > > > and E. However you cannot ensure that (A, B, C) is written to the
> > > > persistent storage in the same order.
> > > > 
> > > > CrashMonkey reorders bios in conformance to the guarantees provided by
> > > > disk cache; we do not make any extra assumptions and we respect the
> > > > barrier operations.
> > > 
> > > I think your model is wrong. caches do not randomly re-order
> > > completed IO operations to the *same LBA*. When a block is overwritten
> > > the cache contains the overwrite data and the previous data is
> > > discarded. THe previous data may be on disk, but it's no longer in
> > > the cache.
> > > 
> > > e.g. take a dependent filesystem read-modify-write cycle (I'm
> > > choosing this because that's the problem this fzero/fsync
> > > "bug" is apparently demonstrating) where we write data to disk,
> > > invalidate the kernel cache, read the data back off disk, zero it
> > > in memory, then write it back to disk, all in the one LBA:
> > > 
> > > 	<flush>
> > > 	write A to disk, invalidate kernel cache
> > > 	......
> > > 	read A from disk into kernel cache
> > > 	A' = <modify A>
> > > 	write A' to disk
> > > 	......
> > > 	<flush>
> > > 
> > > The disk cache model you are describing allows writes
> > > to be reordered anywhere in the flush window regardless of their
> > > inter-IO completion dependencies. Hence you're allowing temporally
> > > ordered filesystem IO to the same LBA be reorded like so:
> > > 
> > > 
> > > 	<flush>
> > > 	......
> > > 	write A'
> > > 	......
> > > 	read A
> > > 	A' = <modify A>
> > > 	......
> > > 	write A
> > > 	......
> > > 	<flush>
> > > 
> > > This violates causality. it's simply *not possible for the disk
> > > cache to contain A' before either "write A", "read A" or the
> > > in-memory modification of A has been completed by the OS. Hence
> > > there is no way for a crash situation to have the disk cache or the
> > > physical storage medium to contain corruption that indicates it
> > > stored A' on disk before stored A.
> > > 
> > > > CrashMonkey therefore respects the guarantees provided by the disk
> > > > cache, and assumes nothing more than that. I hope this provides more
> > > > clarity on what
> > > > CrashMonkey is trying to do, and why we think it is reasonable to do so.
> > > 
> > > It clearly demonstrates to me where CrashMonkey is broken and needs
> > > fixing - it needs to respect the ordering of temporally separate IO
> > > to the same LBA and not violate causality. Simulators that assume
> > > time travel is possible are not useful to us.
> > > 
> > > Cheers,
> > 
> > Hi Dave,
> > 
> > just FYI the 042 xfstest does fail on xfs with what I think is stale
> > data exposure. It might not be related at all to what crashmonkey is
> > reporting but there is something wrong nevertheless.
> 
> generic/042 is unreliable and certain operations result in a
> non-zero length file because of metadata commits/writeback that
> occur as a result of the fallocate operations. It got removed from
> the auto group because it isn't a reliable test about 3 years ago:

Sure, I just that it clearly exposes stale data on xfs. That is, the
resulting file contains data that was previously written to the
underlying image file to catch the exposure. I am aware of the non-zero
length file problem, that's not what I am pointing out though.

-Lukas

> 
> commit 7721b85016081cf6651d139e8af26267eceb23d3
> Author: Jeff Moyer <jmoyer@redhat.com>
> Date:   Mon Dec 21 18:01:47 2015 +1100
> 
>     generic/042: remove from the 'auto' group
>     
>     This test fails 100% of the time for me on xfs and current git head, and
>     is not run for ext4 since ext4 does not support shutdown.  After talking
>     with bfoster, it isn't expected to succeed right now.  Since the auto
>     group is for tests that *are* expected to succeed, let's move this one
>     out.
>     
>     Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>     Reviewed-by: Brian Foster <bfoster@redhat.com>
>     Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> This is what it used to be testing - it was an XFS only test:
> 
> commit cf1438248c0f62f3b64013d23e9e6d6bc23ca24b
> Author: Brian Foster <bfoster@redhat.com>
> Date:   Tue Oct 14 22:59:39 2014 +1100
> 
>     xfs/053: test for stale data exposure via falloc/writeback interaction
>     
>     XFS buffered I/O writeback has a subtle race condition that leads to
>     stale data exposure if the filesystem happens to crash after delayed
>     allocation blocks are converted on disk and before data is written back
>     to said blocks.
>     
>     Use file allocation commands to attempt to reproduce a related, but
>     slightly different variant of this problem. The associated falloc
>     commands can lead to partial writeback that converts an extent larger
>     than the range affected by falloc. If the filesystem crashes after the
>     extent conversion but before all other cached data is written to the
>     extent, stale data can be exposed.
>     
>     Signed-off-by: Brian Foster <bfoster@redhat.com>
>     Reviewed-by: Dave Chinner <dchinner@redhat.com>
>     Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> So, generic/042 was written to expose unwritten extent conversion
> issues in the XFS writeback path and has nothing to do with mutliple
> writes being reordered. It's failure detection is unreliable and not
> indicative of an actual failure or data corruption, and that's why
> it was removed from the auto group....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
