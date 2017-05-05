Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:57240 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752009AbdEED3R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 23:29:17 -0400
Date: Fri, 5 May 2017 13:29:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes minutes to complete
Message-ID: <20170505032905.GF17542@dastard>
References: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap>
 <20170502073501.GB6679@infradead.org>
 <DDDCF9D44B6A4D1493F62FCA5AC73CF6@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDDCF9D44B6A4D1493F62FCA5AC73CF6@alyakaslap>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, May 04, 2017 at 11:07:45AM +0300, Alex Lyakas wrote:
> Hello Brian, Cristoph,
> 
> Thank you for your responses.
> 
> >The search overhead could be high due to either fragmented free space or
> >perhaps waiting on busy extents (since you have enabled online discard).
> >Do you have any threads freeing space and waiting on discard operations
> >when this occurs? Also, what does 'xfs_db -c "freesp -s" <dev>' show for
> >this filesystem?
> I disabled the discard, but the problem still happens. Output of the
> freesp command is at [1]. To my understanding this means that 60% of
> the free space is 16-31 continuous blocks, i.e., 64kb-124kb. Does
> this count as a fragmented free space?
> 
> I debugged the issue further, profiling the
> xfs_alloc_ag_vextent_near() call and what it does. Some results:
> 
> # it appears to not be triggering any READs of xfs_buf, i.e., no
> calls to xfs_buf_ioapply_map() with rw==READ or rw==READA in the
> same thread
> # most of the time (about 95%) is spent in xfs_buf_lock() waiting in
> "down(&bp->b_sema)" call
> # the average time to lock an xfs_buf is about 10-12 ms
> 
> For example, in one test it took 45778 ms to complete the
> xfs_alloc_ag_vextent_near()  execution. During this time, 6240
> xfs_buf were locked, totalling to 42810 ms spent in locking the
> buffers, which is about 93%. On average 7 ms to lock a buffer.
> 
> # it is still not clear who is holding the lock
> 
> Cristoph, I understand that kernel 3.18 is EOL at the moment, but it
> used to be a long-term kernel, so there is an expectation of
> stability, but perhaps not community support at this point.
> 
> Thanks,
> Alex.
> 
> 
> [1]
>   from      to extents  blocks    pct
>      1       1  155759  155759   0.00
>      2       3    1319    3328   0.00
>      4       7   13153   56265   0.00
>      8      15  152663 1752813   0.03
>     16      31 143626908 4019133338  60.17

There's your problem. 143 million small free space extents totalling
4TB of free space. That's going to require (roughly speaking)
somewhere between 3-500,000 4k btree leaf blocks to index. i.e a
footprint of 10-20GB of metadata.

Even accounting for it being evenly spread across 50AGs, that's
still a 5-10k of btree blocks per free space btree per AG, and so if
that's not in cache when we end up doing a linear search for a near
block of a size that falls into this bucket, it's going to get stuck
reading btree leaf siblings from disk synchronously....

Perhaps this "near block" search needs to terminate after at a
certain search radius, similar to how the old AGI btree searches
during inode allocation were terminated after a certain radius of
allocated inode clusters were searched for free inodes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
