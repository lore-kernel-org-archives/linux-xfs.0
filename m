Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47158 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751483AbdITVpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 17:45:12 -0400
Date: Wed, 20 Sep 2017 14:45:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/19] xfs: refactor xfs_bmap_add_extent_hole_real
Message-ID: <20170920214509.GR7112@magnolia>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918152422.24345-12-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 08:24:14AM -0700, Christoph Hellwig wrote:
> Use xfs_iext_update_extent to update entries in the in-core extent list.
> This isolates the function from the detailed layout of the extent list,
> and generally makes the code a lot more readable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 48 +++++++++++++++++++++---------------------------
>  1 file changed, 21 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 833c76084f38..4fb73c0aca05 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -2860,6 +2860,7 @@ xfs_bmap_add_extent_hole_real(
>  	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
>  	int			rval=0;	/* return value (logging flags) */
>  	int			state;	/* state bits, accessed thru macros */
> +	struct xfs_bmbt_irec	old;
>  
>  	ASSERT(*idx >= 0);
>  	ASSERT(*idx <= xfs_iext_count(ifp));
> @@ -2929,9 +2930,8 @@ xfs_bmap_add_extent_hole_real(
>  		 */
>  		--*idx;
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
> -			left.br_blockcount + new->br_blockcount +
> -			right.br_blockcount);
> +		left.br_blockcount += new->br_blockcount + right.br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx, &left);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		xfs_iext_remove(ip, *idx + 1, 1, state);
> @@ -2958,10 +2958,7 @@ xfs_bmap_add_extent_hole_real(
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			error = xfs_bmbt_update(cur, left.br_startoff,
>  					left.br_startblock,
> -					left.br_blockcount +
> -						new->br_blockcount +
> -						right.br_blockcount,
> -					left.br_state);
> +					left.br_blockcount, left.br_state);
>  			if (error)
>  				goto done;
>  		}
> @@ -2974,26 +2971,25 @@ xfs_bmap_add_extent_hole_real(
>  		 * Merge the new allocation with the left neighbor.
>  		 */
>  		--*idx;
> +		old = left;
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
> -			left.br_blockcount + new->br_blockcount);
> +		left.br_blockcount += new->br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx, &left);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		if (cur == NULL) {
>  			rval = xfs_ilog_fext(whichfork);
>  		} else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(cur, left.br_startoff,
> -					left.br_startblock, left.br_blockcount,
> +			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> +					old.br_startblock, old.br_blockcount,
>  					&i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			error = xfs_bmbt_update(cur, left.br_startoff,
>  					left.br_startblock,
> -					left.br_blockcount +
> -						new->br_blockcount,
> -					left.br_state);
> +					left.br_blockcount, left.br_state);
>  			if (error)
>  				goto done;
>  		}
> @@ -3005,29 +3001,27 @@ xfs_bmap_add_extent_hole_real(
>  		 * on the right.
>  		 * Merge the new allocation with the right neighbor.
>  		 */
> +		old = right;
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
> -			new->br_startoff, new->br_startblock,
> -			new->br_blockcount + right.br_blockcount,
> -			right.br_state);
> +		right.br_startoff = new->br_startoff;
> +		right.br_startblock = new->br_startblock;
> +		right.br_blockcount += new->br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx, &right);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		if (cur == NULL) {
>  			rval = xfs_ilog_fext(whichfork);
>  		} else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(cur,
> -					right.br_startoff,
> -					right.br_startblock,
> -					right.br_blockcount, &i);
> +			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> +					old.br_startblock, old.br_blockcount,
> +					&i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, new->br_startoff,
> -					new->br_startblock,
> -					new->br_blockcount +
> -						right.br_blockcount,
> -					right.br_state);
> +			error = xfs_bmbt_update(cur, right.br_startoff,
> +					right.br_startblock,
> +					right.br_blockcount, right.br_state);
>  			if (error)
>  				goto done;
>  		}
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
