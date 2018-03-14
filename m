Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751302AbeCNNRD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Mar 2018 09:17:03 -0400
Date: Wed, 14 Mar 2018 14:16:59 +0100
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: XFS crash consistency bug : Loss of fsynced metadata operation
Message-ID: <20180314131659.wnmt5zxfhrfsld7n@rh_laptop>
References: <CA+EzBbCtp9wKC=KeN+N1iZDa2+TsWxVho3aUkeXJXguVswkChA@mail.gmail.com>
 <20180313042126.GB18129@dastard>
 <CA+EzBbC9yQyxqiPOTCymrbL=cW-KZq2b8hunf7KEpiNZ9f3s4Q@mail.gmail.com>
 <20180313224522.GZ7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313224522.GZ7000@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jayashree Mohan <jayashree2912@gmail.com>, linux-xfs@vger.kernel.org, Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>, Ashlie Martinez <ashmrtn@utexas.edu>, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

On Wed, Mar 14, 2018 at 09:45:22AM +1100, Dave Chinner wrote:
> On Tue, Mar 13, 2018 at 11:57:21AM -0500, Jayashree Mohan wrote:
> > Hi Dave,
> > 
> > Thanks for the response. CrashMonkey assumes the following behavior of
> > disk cache. Let me know if any of this sounds unreasonable.
> > 
> > Whenever the underlying storage device has an associated cache, the IO
> > is marked completed the moment it reaches the disk cache. This does
> > not guarantee that the disk cache would persist them in the same
> > order, unless there is a Flush/FUA. The order of completed writes as
> > seen by the user could be A, B, C, *Flush* D, E. However the disk
> > cache could write these back to the persistent storage in the order
> > say B, A, C, E, D. The only invariant it ensures is that writing in an
> > order like  A, C, E, B, D is
> > not possible because, writes A,B,C have to strictly happen before D
> > and E. However you cannot ensure that (A, B, C) is written to the
> > persistent storage in the same order.
> > 
> > CrashMonkey reorders bios in conformance to the guarantees provided by
> > disk cache; we do not make any extra assumptions and we respect the
> > barrier operations.
> 
> I think your model is wrong. caches do not randomly re-order
> completed IO operations to the *same LBA*. When a block is overwritten
> the cache contains the overwrite data and the previous data is
> discarded. THe previous data may be on disk, but it's no longer in
> the cache.
> 
> e.g. take a dependent filesystem read-modify-write cycle (I'm
> choosing this because that's the problem this fzero/fsync
> "bug" is apparently demonstrating) where we write data to disk,
> invalidate the kernel cache, read the data back off disk, zero it
> in memory, then write it back to disk, all in the one LBA:
> 
> 	<flush>
> 	write A to disk, invalidate kernel cache
> 	......
> 	read A from disk into kernel cache
> 	A' = <modify A>
> 	write A' to disk
> 	......
> 	<flush>
> 
> The disk cache model you are describing allows writes
> to be reordered anywhere in the flush window regardless of their
> inter-IO completion dependencies. Hence you're allowing temporally
> ordered filesystem IO to the same LBA be reorded like so:
> 
> 
> 	<flush>
> 	......
> 	write A'
> 	......
> 	read A
> 	A' = <modify A>
> 	......
> 	write A
> 	......
> 	<flush>
> 
> This violates causality. it's simply *not possible for the disk
> cache to contain A' before either "write A", "read A" or the
> in-memory modification of A has been completed by the OS. Hence
> there is no way for a crash situation to have the disk cache or the
> physical storage medium to contain corruption that indicates it
> stored A' on disk before stored A.
> 
> > CrashMonkey therefore respects the guarantees provided by the disk
> > cache, and assumes nothing more than that. I hope this provides more
> > clarity on what
> > CrashMonkey is trying to do, and why we think it is reasonable to do so.
> 
> It clearly demonstrates to me where CrashMonkey is broken and needs
> fixing - it needs to respect the ordering of temporally separate IO
> to the same LBA and not violate causality. Simulators that assume
> time travel is possible are not useful to us.
> 
> Cheers,

Hi Dave,

just FYI the 042 xfstest does fail on xfs with what I think is stale
data exposure. It might not be related at all to what crashmonkey is
reporting but there is something wrong nevertheless.

SECTION       -- ext4
RECREATING    -- xfs on /dev/vdc1
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 rhel7 4.16.0-rc5+
MKFS_OPTIONS  -- -f -f /dev/vdb1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vdb1 /mnt/test1

generic/042	 - output mismatch (see /root/Projects/xfstests-dev/results//ext4/generic/042.out.bad)
    --- tests/generic/042.out	2018-03-14 05:56:38.619124060 -0400
    +++ /root/Projects/xfstests-dev/results//ext4/generic/042.out.bad	2018-03-14 09:14:54.825969765 -0400
    @@ -5,6 +5,16 @@
     fpunch
     wrote 65536/65536 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    +0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
    +*
    +000f000 0000 0000 0000 0000 0000 0000 0000 0000
    +*
    ...
    (Run 'diff -u tests/generic/042.out /root/Projects/xfstests-dev/results//ext4/generic/042.out.bad'  to see the entire diff)
Ran: generic/042
Failures: generic/042
Failed 1 of 1 tests


ext4 fails as well, however it looks to be a problem with the test
itself where it is expecting the file to remain of a zero length which
it might not be the case.

-Lukas

> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
