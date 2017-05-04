Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751136AbdEDMZi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 May 2017 08:25:38 -0400
Date: Thu, 4 May 2017 08:25:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes minutes to complete
Message-ID: <20170504122535.GB3248@bfoster.bfoster>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, May 04, 2017 at 11:07:45AM +0300, Alex Lyakas wrote:
> Hello Brian, Cristoph,
> 
> Thank you for your responses.
> 
> > The search overhead could be high due to either fragmented free space or
> > perhaps waiting on busy extents (since you have enabled online discard).
> > Do you have any threads freeing space and waiting on discard operations
> > when this occurs? Also, what does 'xfs_db -c "freesp -s" <dev>' show for
> > this filesystem?
> I disabled the discard, but the problem still happens. Output of the freesp
> command is at [1]. To my understanding this means that 60% of the free space
> is 16-31 continuous blocks, i.e., 64kb-124kb. Does this count as a
> fragmented free space?
> 

Ok. Note that the discard implementation from kernels that old is known
to produce similar stalls, so may want to consider using fstrim going
forward independent from this problem.

That aside, free space does appear to be fairly fragmented to me. You do
have some larger extents available, but doing locality-based allocations
certainly seems like it could drop into a range where a time consuming
search is required.

> I debugged the issue further, profiling the xfs_alloc_ag_vextent_near() call
> and what it does. Some results:
> 
> # it appears to not be triggering any READs of xfs_buf, i.e., no calls to
> xfs_buf_ioapply_map() with rw==READ or rw==READA in the same thread
> # most of the time (about 95%) is spent in xfs_buf_lock() waiting in
> "down(&bp->b_sema)" call
> # the average time to lock an xfs_buf is about 10-12 ms
> 
> For example, in one test it took 45778 ms to complete the
> xfs_alloc_ag_vextent_near()  execution. During this time, 6240 xfs_buf were
> locked, totalling to 42810 ms spent in locking the buffers, which is about
> 93%. On average 7 ms to lock a buffer.
> 

This is probably dropping into the fallback allocation algorithm in
xfs_alloc_ag_vextent_near(), explained by the following comment:

        /*
         * Second algorithm.
         * Search in the by-bno tree to the left and to the right
         * simultaneously, until in each case we find a space big enough,
         * or run into the edge of the tree.  When we run into the edge,
         * we deallocate that cursor.
         * If both searches succeed, we compare the two spaces and pick
         * the better one.
         * With alignment, it's possible for both to fail; the upper
         * level algorithm that picks allocation groups for allocations
         * is not supposed to do this.
         */

So what is happening here is that the algorithm is starting at a point
in an AG based on a starting blockno (e.g., such as the inode block) and
searching left and right from there for a suitable range of free blocks.
Depending on the size of the tree, fragmentation of free space, size of
the allocation request, etc., it can certainly take a while to seek/read
all of the btree blocks required to satisfy the allocation.

I suspect this is ultimately caused by the sync mount option, presumably
converting smallish chunks of delalloc blocks to real blocks repeatedly
and in parallel with other allocations, and fragmenting free space over
time. I don't think there is any easy way out of the current state of
the fs outside of reformatting and migrating data to a new fs without
using the sync mount option.

Brian

> # it is still not clear who is holding the lock
> 
> Cristoph, I understand that kernel 3.18 is EOL at the moment, but it used to
> be a long-term kernel, so there is an expectation of stability, but perhaps
> not community support at this point.
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
>     32      63 1484214 72838775   1.09
>     64     127 9799130 876068428  13.12
>    128     255 1929928 310722786   4.65
>    256     511  150035 49779357   0.75
>    512    1023   26496 19658529   0.29
>   1024    2047   27800 41418636   0.62
>   2048    4095   26369 77587481   1.16
>   4096    8191   13872 80270202   1.20
>   8192   16383    6653 77527746   1.16
>  16384   32767    4384 100576452   1.51
>  32768   65535    3967 200958816   3.01
>  65536  131071    1346 127613203   1.91
> 131072  262143     753 141530959   2.12
> 262144  524287     473 168900109   2.53
> 524288 1048575     202 147607986   2.21
> 1048576 2097151      65 95394305   1.43
> 2097152 4194303      16 42998164   0.64
> 4194304 8388607       5 26710209   0.40
> total free extents 157425510
> total free blocks 6679263646
> average free extent size 42.4281
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
