Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10128 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752348AbdK0XLV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Nov 2017 18:11:21 -0500
Date: Tue, 28 Nov 2017 10:07:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: amortize agfl block frees across multiple
 transactions
Message-ID: <20171127230734.GB5858@dastard>
References: <20171127202434.43125-1-bfoster@redhat.com>
 <20171127202434.43125-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127202434.43125-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 27, 2017 at 03:24:33PM -0500, Brian Foster wrote:
> We've had rare reports of transaction overruns in
> xfs_inactive_ifree() for quite some time. Analysis of a reproducing
> metadump has shown the problem is essentially caused by performing
> too many agfl block frees in a single transaction.
> 
> For example, an inode chunk is freed and the associated agfl fixup
> algorithm discovers it needs to free a single agfl block before the
> chunk free occurs. This single block ends up causing a space btree
> join and adds one or more blocks back onto the agfl. This causes
> xfs_alloc_fix_freelist() to free up to 3 blocks just to rectify a
> single block discrepency.
> 
> The transaction overrun occurs under several other unfortunate
> circumstances:
> 
>  - Each agfl block free is left+right contiguous. This requires 2
>    record deletions and 1 insertion for the cntbt and thus requires
>    more log reservation than normal.
>  - The associated transaction is the first in the CIL ctx and thus
>    the ctx header reservation is consumed.
>  - The transaction reservation is larger than a log buffer and thus
>    extra split header reservation is consumed.
> 
> As a result of the agfl and free space state of the filesystem, the
> agfl fixup code has dirtied more cntbt buffer space than allowed by
> the portion of the reservation allotted for block allocation. This
> is all before the real allocation even starts!
> 
> Note that the log related conditions above are correctly covered by
> the existing transaction reservation. The above demonstrates that
> the reservation allotted for the context/split headers may help
> suppress overruns in the more common case where that reservation
> goes unused for its intended purpose.
> 
> To address this problem, update xfs_alloc_fix_freelist() to amortize
> agfl block frees over multiple transactions. Free one block per
> transaction so long as the agfl is less than half free. The agfl
> minimum allocation requirement is dynamic, but is based on the
> geometry of the associated btrees (i.e., level count) and therefore
> should be easily rectified over multiple allocation transactions.
> Further, there is no real harm in leaving extraneous blocks on the
> agfl so long as there are enough free slots available for btree
> blocks freed as a result of the upcoming allocation.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 0da80019a917..d8d58e35da00 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2117,11 +2117,6 @@ xfs_alloc_fix_freelist(
>  	 * appropriately based on the recursion count and dirty state of the
>  	 * buffer.
>  	 *
> -	 * XXX (dgc): When we have lots of free space, does this buy us
> -	 * anything other than extra overhead when we need to put more blocks
> -	 * back on the free list? Maybe we should only do this when space is
> -	 * getting low or the AGFL is more than half full?
> -	 *
>  	 * The NOSHRINK flag prevents the AGFL from being shrunk if it's too
>  	 * big; the NORMAP flag prevents AGFL expand/shrink operations from
>  	 * updating the rmapbt.  Both flags are used in xfs_repair while we're
> @@ -2151,6 +2146,16 @@ xfs_alloc_fix_freelist(
>  			goto out_agbp_relse;
>  		}
>  		xfs_trans_binval(tp, bp);
> +
> +		/*
> +		 * Freeing all extra agfl blocks adds too much log reservation
> +		 * overhead to a single transaction, particularly considering
> +		 * that freeing a block can cause a btree join and put one right
> +		 * back on the agfl. Try to free one block per tx so long as
> +		 * we've left enough free slots for the upcoming modifications.
> +		 */
> +		if (pag->pagf_flcount <= (XFS_AGFL_SIZE(mp) >> 1))
> +			break;
>  	}

In /theory/, this /should/ work. However, as the comment you removed
implies, there are likely to be issues with this as we get near
ENOSPC. We know that if we don't trim the AGFL right down to the
minimum requested as we approach ENOSPC we can get premature ENOSPC
events being reported that lead to filesystem shutdowns.  (e.g. need
the very last free block for a BMBT block to complete a data extent
allocation).  Hence I'd suggest that this needs to be aware of the
low space allocation algorithm (i.e. dfops->dop_low is true) to trim
the agfl right back when we are really short of space

I'm also concerned that it doesn't take into account that freeing
a block from the AGFL could cause a freespace tree split to occur,
thereby emptying the AGFL whilst consuming the entire log
reservation for tree modifications. This leaves nothing in the log
reservation for re-growing the AGFL to the minimum required, which
we /must do/ before returning and could cause more splits/joins to
occur.

IMO, there's a lot more to be concerned about here than just trying
to work around the specific symptom observed in the given test case.
This code is, unfortunately, really tricky and intricate and history
tells us that the risk of unexpected regressions is extremely high,
especially around ENOSPC related issues. Of all the patches in this
series, this is the most dangerous and "iffy" of them and the
one we should be most concerned and conservative about....

I'm not sure what the solution to this problem is, but I'm extremely
hesitant to make changes like this without an awful lot more
analysis of it's impact.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
