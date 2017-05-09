Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33949 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754123AbdEIQJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 May 2017 12:09:59 -0400
Date: Tue, 9 May 2017 09:09:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix indlen accounting error on partial delalloc
 conversion
Message-ID: <20170509160948.GP5973@birch.djwong.org>
References: <1493837186-14148-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493837186-14148-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 03, 2017 at 02:46:26PM -0400, Brian Foster wrote:
> The delalloc -> real block conversion path uses an incorrect
> calculation in the case where the middle part of a delalloc extent
> is being converted. This is documented as a rare situation because
> XFS generally attempts to maximize contiguity by converting as much
> of a delalloc extent as possible.
> 
> If this situation does occur, the indlen reservation for the two new
> delalloc extents left behind by the conversion of the middle range
> is calculated and compared with the original reservation. If more
> blocks are required, the delta is allocated from the global block
> pool. This delta value can be characterized as the difference
> between the new total requirement (temp + temp2) and the currently
> available reservation minus those blocks that have already been
> allocated (startblockval(PREV.br_startblock) - allocated).
> 
> The problem is that the current code does not account for previously
> allocated blocks correctly. It subtracts the current allocation
> count from the (new - old) delta rather than the old indlen
> reservation. This means that more indlen blocks than have been
> allocated end up stashed in the remaining extents and free space
> accounting is broken as a result.
> 
> Fix up the calculation to subtract the allocated block count from
> the original extent indlen and thus correctly allocate the
> reservation delta based on the difference between the new total
> requirement and the unused blocks from the original reservation.
> Also remove a bogus assert that contradicts the fact that the new
> indlen reservation can be larger than the original indlen
> reservation.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> So while I fortunately was able to reproduce this problem and verify the
> patch, I'm not able to do so in any way that facilitates a generic test
> case. To reproduce, I had to hack up the allocation path to always do
> single physical block allocations and otherwise not attempt to convert
> whole delalloc extents, hack up an ioctl to do a
> filemap_write_and_wait_range(), and run a test that repeatedly does 1M
> buffered writes followed by fragmented, page-sized writebacks of that 1M
> extent. This forces partial (middle) extent conversions until the extent
> tree grows enough to require a bmbt block allocation. When that occurs,
> I always end up with the following free space accounting inconsistency
> reported via xfs_repair:
> 
> Phase 1 - find and verify superblock...     
> Phase 2 - using internal log
>         - zero log...               
>         - scan filesystem freespace and inode maps...
> sb_fdblocks 3929316, counted 3929314             
> ...
> 
> With this patch applied, the same test no longer reproduces the
> corruption. This otherwise survives my xfstests testing (without the
> aforementioned hacks). Thoughts, reviews, flames appreciated.
> 
> Brian
> 
>  fs/xfs/libxfs/xfs_bmap.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index f02eb76..8adb91b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -2065,8 +2065,10 @@ xfs_bmap_add_extent_delay_real(
>  		}
>  		temp = xfs_bmap_worst_indlen(bma->ip, temp);
>  		temp2 = xfs_bmap_worst_indlen(bma->ip, temp2);
> -		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
> -			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
> +		diff = (int)(temp + temp2 -
> +			     (startblockval(PREV.br_startblock) -
> +			      (bma->cur ?
> +			       bma->cur->bc_private.b.allocated : 0)));

<thinking aloud again>

Prior to this operation we made a delalloc reservation in which we
reserved a number of blocks for bmbt expansion by subtracting that
quantity from incore fdblocks; that is startblockval(PREV.br_startblock).
Then we did some bmbt magic which used up cur->bc_private.b.allocated
blocks from the reservation.  Since those blocks were already subtracted
from the incore fdblocks, we don't need to do that now.  After the magic
was over, we now have two smaller delalloc reservations (with a real
extent in the middle), each with their own reservations for bmbt shape
changing expansion.

Now we aim to make the accounting of incore fdblocks square again by
checking if we are now hanging on to more blocks than we were before and
subtracting the difference from fdblocks if so.  (We deal separately with
the possibility of hanging onto /fewer/ blocks than before.)

Ok, so first we reserved startblockval(PREV.br_startblock).

After splitting the da extent in the middle we now have two da extents;
the effective indlen reservation of the whole range we just touched is:
xfs_bmap_worst_indlen(bma->ip, temp) + xfs_bmap_worst_indlen(bma->ip, temp2);

Then we (may have) fed bma->cur->bc_private.b.allocated blocks to the bmbt.
The number of blocks we now know about is:

xfs_bmap_worst_indlen(bma->ip, temp) +
xfs_bmap_worst_indlen(bma->ip, temp2) +
bma->cur->bc_private.b.allocated

Therefore, the number of blocks we are over (if at all) is:

xfs_bmap_worst_indlen(bma->ip, temp) +
xfs_bmap_worst_indlen(bma->ip, temp2) +
bma->cur->bc_private.b.allocated -
startblockval(PREV.br_startblock)

Or, put another way:

(xfs_bmap_worst_indlen(bma->ip, temp) +
 xfs_bmap_worst_indlen(bma->ip, temp2)) -
(startblockval(PREV.br_startblock) -
 bma->cur->bc_private.b.allocated)

(Exactly what Brian wrote above.)

If that quantity is positive, we're now hanging on to more blocks than
we were before, so we subtract that many from fdblocks.  That part looks
ok, though I have one question -- why is diff an int?  temp/temp2 are
both xfs_filblks_t (__uint64_t), so the whole expression is promoted to
a 64-bit operation, then the results are squashed down into a 32-bit
int, which is then cast back to int64_t.  With our short MAXEXTLEN I
think it's impossible ever to have diff > 2^32, but the casting back and
forth caught my eye.

Aside from that, it looks ok...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  		if (diff > 0) {
>  			error = xfs_mod_fdblocks(bma->ip->i_mount,
>  						 -((int64_t)diff), false);
> @@ -2123,7 +2125,6 @@ xfs_bmap_add_extent_delay_real(
>  		temp = da_new;
>  		if (bma->cur)
>  			temp += bma->cur->bc_private.b.allocated;
> -		ASSERT(temp <= da_old);
>  		if (temp < da_old)
>  			xfs_mod_fdblocks(bma->ip->i_mount,
>  					(int64_t)(da_old - temp), false);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
