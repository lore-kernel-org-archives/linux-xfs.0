Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43473 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932222AbeCMWpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 18:45:34 -0400
Date: Wed, 14 Mar 2018 09:45:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS crash consistency bug : Loss of fsynced metadata operation
Message-ID: <20180313224522.GZ7000@dastard>
References: <CA+EzBbCtp9wKC=KeN+N1iZDa2+TsWxVho3aUkeXJXguVswkChA@mail.gmail.com>
 <20180313042126.GB18129@dastard>
 <CA+EzBbC9yQyxqiPOTCymrbL=cW-KZq2b8hunf7KEpiNZ9f3s4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EzBbC9yQyxqiPOTCymrbL=cW-KZq2b8hunf7KEpiNZ9f3s4Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jayashree Mohan <jayashree2912@gmail.com>
Cc: linux-xfs@vger.kernel.org, Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>, Ashlie Martinez <ashmrtn@utexas.edu>, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

On Tue, Mar 13, 2018 at 11:57:21AM -0500, Jayashree Mohan wrote:
> Hi Dave,
> 
> Thanks for the response. CrashMonkey assumes the following behavior of
> disk cache. Let me know if any of this sounds unreasonable.
> 
> Whenever the underlying storage device has an associated cache, the IO
> is marked completed the moment it reaches the disk cache. This does
> not guarantee that the disk cache would persist them in the same
> order, unless there is a Flush/FUA. The order of completed writes as
> seen by the user could be A, B, C, *Flush* D, E. However the disk
> cache could write these back to the persistent storage in the order
> say B, A, C, E, D. The only invariant it ensures is that writing in an
> order like  A, C, E, B, D is
> not possible because, writes A,B,C have to strictly happen before D
> and E. However you cannot ensure that (A, B, C) is written to the
> persistent storage in the same order.
> 
> CrashMonkey reorders bios in conformance to the guarantees provided by
> disk cache; we do not make any extra assumptions and we respect the
> barrier operations.

I think your model is wrong. caches do not randomly re-order
completed IO operations to the *same LBA*. When a block is overwritten
the cache contains the overwrite data and the previous data is
discarded. THe previous data may be on disk, but it's no longer in
the cache.

e.g. take a dependent filesystem read-modify-write cycle (I'm
choosing this because that's the problem this fzero/fsync
"bug" is apparently demonstrating) where we write data to disk,
invalidate the kernel cache, read the data back off disk, zero it
in memory, then write it back to disk, all in the one LBA:

	<flush>
	write A to disk, invalidate kernel cache
	......
	read A from disk into kernel cache
	A' = <modify A>
	write A' to disk
	......
	<flush>

The disk cache model you are describing allows writes
to be reordered anywhere in the flush window regardless of their
inter-IO completion dependencies. Hence you're allowing temporally
ordered filesystem IO to the same LBA be reorded like so:


	<flush>
	......
	write A'
	......
	read A
	A' = <modify A>
	......
	write A
	......
	<flush>

This violates causality. it's simply *not possible for the disk
cache to contain A' before either "write A", "read A" or the
in-memory modification of A has been completed by the OS. Hence
there is no way for a crash situation to have the disk cache or the
physical storage medium to contain corruption that indicates it
stored A' on disk before stored A.

> CrashMonkey therefore respects the guarantees provided by the disk
> cache, and assumes nothing more than that. I hope this provides more
> clarity on what
> CrashMonkey is trying to do, and why we think it is reasonable to do so.

It clearly demonstrates to me where CrashMonkey is broken and needs
fixing - it needs to respect the ordering of temporally separate IO
to the same LBA and not violate causality. Simulators that assume
time travel is possible are not useful to us.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
