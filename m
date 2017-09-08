Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756617AbdIHRS6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 13:18:58 -0400
Date: Fri, 8 Sep 2017 13:18:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/17] xfs: refactor xfs_bmap_add_extent_delay_real
Message-ID: <20170908171855.GA905@bfoster.bfoster>
References: <20170903072956.3175-1-hch@lst.de>
 <20170903072956.3175-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903072956.3175-12-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 09:29:50AM +0200, Christoph Hellwig wrote:
> Use xfs_iext_get_extent to find, and xfs_iext_update_extent to update
> entries in the in-core extent list.  This isolates the function from
> the detailed layout of the extent list, and generally makes the code
> a lot more readable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 138 +++++++++++++++++++++++++----------------------
>  1 file changed, 74 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 05d4778ce528..edea670a3f74 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
...
> @@ -1779,9 +1775,9 @@ xfs_bmap_add_extent_delay_real(
>  		 * The right neighbor is contiguous, the left is not.
>  		 */
>  		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		xfs_bmbt_set_startblock(ep, new->br_startblock);
> -		xfs_bmbt_set_blockcount(ep,
> -			PREV.br_blockcount + RIGHT.br_blockcount);
> +		PREV.br_startblock = new->br_startblock;
> +		PREV.br_blockcount += RIGHT.br_blockcount;
> +		xfs_iext_update_extent(ifp, bma->idx, &PREV);

I think using PREV without setting the state here is a bit of a landmine
because the contiguity checking logic above only verifies that the new
extent state matches the associated neighbors. This is not really a
problem introduced by the patch, nor something that is likely to result
in a real problem due to context, but it would be nice to fix up since
the overall pattern of this function seems to be copied around a bit
more nowadays.

>  		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
>  
>  		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
...
> @@ -1839,37 +1835,39 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the first part of a previous delayed allocation.
>  		 * The left neighbor is contiguous.
>  		 */
> +		old = LEFT;
> +
>  		trace_xfs_bmap_pre_update(bma->ip, bma->idx - 1, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx - 1),
> -			LEFT.br_blockcount + new->br_blockcount);
> -		xfs_bmbt_set_startoff(ep,
> -			PREV.br_startoff + new->br_blockcount);
> +		LEFT.br_blockcount += new->br_blockcount;
> +		xfs_iext_update_extent(ifp, bma->idx - 1, &LEFT);
>  		trace_xfs_bmap_post_update(bma->ip, bma->idx - 1, state, _THIS_IP_);
>  
> -		temp = PREV.br_blockcount - new->br_blockcount;
> -		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep, temp);
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_DEXT;
>  		else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(bma->cur, LEFT.br_startoff,
> -					LEFT.br_startblock, LEFT.br_blockcount,
> +			error = xfs_bmbt_lookup_eq(bma->cur, old.br_startoff,
> +					old.br_startblock, old.br_blockcount,
>  					&i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
> -					LEFT.br_startblock,
> -					LEFT.br_blockcount +
> -					new->br_blockcount,
> +					LEFT.br_startblock, LEFT.br_blockcount,
>  					LEFT.br_state);
>  			if (error)
>  				goto done;
>  		}
> +
> +		temp = PREV.br_blockcount - new->br_blockcount;
>  		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
>  			startblockval(PREV.br_startblock));
> -		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
> +
> +		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> +		PREV.br_startoff += new->br_blockcount;
> +		PREV.br_blockcount = temp;
> +		PREV.br_startblock = nullstartblock(da_new);
> +		xfs_iext_update_extent(ifp, bma->idx, &PREV);

It looks like this was shuffled around to do the updates within the
appropriate pre/post tracepoints. Any reason not to continue to keep the
in-core extent list update before the on-disk update as before, however?
(Same question for some of the hunks below as well).

>  		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
>  
>  		bma->idx--;
...
> @@ -1924,14 +1925,13 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the last part of a previous delayed allocation.
>  		 * The right neighbor is contiguous with the new allocation.
>  		 */
> -		temp = PREV.br_blockcount - new->br_blockcount;
>  		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep, temp);
> -		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, bma->idx + 1),
> -			new->br_startoff, new->br_startblock,
> -			new->br_blockcount + RIGHT.br_blockcount,
> -			RIGHT.br_state);
> +		RIGHT.br_startoff = new->br_startoff;
> +		RIGHT.br_startblock = new->br_startblock;
> +		RIGHT.br_blockcount += new->br_blockcount;
> +		xfs_iext_update_extent(ifp, bma->idx + 1, &RIGHT);
>  		trace_xfs_bmap_post_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
> +
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_DEXT;
>  		else {
> @@ -1943,18 +1943,20 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			error = xfs_bmbt_update(bma->cur, new->br_startoff,
> -					new->br_startblock,
> -					new->br_blockcount +
> -					RIGHT.br_blockcount,
> -					RIGHT.br_state);
> +					new->br_startblock, new->br_blockcount,
> +					new->br_state);

The immediately previous code (not shown) looks up RIGHT, which has
already been updated above to cover (new + RIGHT) and so does not exist
in the bmapbt. This code now attempts to update that extent to new,
which hasn't been updated to cover RIGHT.

>  			if (error)
>  				goto done;
>  		}
>  
> +		temp = PREV.br_blockcount - new->br_blockcount;

The use of temp seems unnecessary (perhaps not just here), particularly
since you could modify PREV.br_blockcount as this patch has been doing
elsewhere.

>  		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
>  			startblockval(PREV.br_startblock));
> +
>  		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
> +		PREV.br_blockcount = temp;
> +		PREV.br_startblock = nullstartblock(da_new);
> +		xfs_iext_update_extent(ifp, bma->idx, &PREV);
>  		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
>  
>  		bma->idx++;
...
> @@ -2078,12 +2084,16 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  		}
>  
> -		ep = xfs_iext_get_ext(ifp, bma->idx);
> -		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
> +		trace_xfs_bmap_pre_update(bma->ip, bma->idx, 0, _THIS_IP_);
> +		PREV.br_startblock = nullstartblock(temp);
> +		PREV.br_blockcount = temp;	/* truncate PREV */
> +		xfs_iext_update_extent(ifp, bma->idx, &PREV);
>  		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
> +
> +		/* update to the final reservation: */
>  		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
> -		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, bma->idx + 2),
> -			nullstartblock((int)temp2));
> +		RIGHT.br_startblock = nullstartblock(temp2);
> +		xfs_iext_update_extent(ifp, bma->idx + 2, &RIGHT);

I'm wondering if this last hunk can be removed. Has RIGHT.br_startblock
actually changed since set above?

Brian

>  		trace_xfs_bmap_post_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
>  
>  		bma->idx++;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
