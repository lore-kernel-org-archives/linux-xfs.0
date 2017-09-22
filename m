Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54294 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751923AbdIVPbr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Sep 2017 11:31:47 -0400
Date: Fri, 22 Sep 2017 11:31:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/19] xfs: refactor xfs_bmap_add_extent_delay_real
Message-ID: <20170922153144.GB63820@bfoster.bfoster>
References: <20170922135945.31574-1-hch@lst.de>
 <20170922135945.31574-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922135945.31574-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 22, 2017 at 06:59:38AM -0700, Christoph Hellwig wrote:
> Use xfs_iext_get_extent to find, and xfs_iext_update_extent to update
> entries in the in-core extent list.  This isolates the function from
> the detailed layout of the extent list, and generally makes the code
> a lot more readable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 181 +++++++++++++++++++++++++----------------------
>  1 file changed, 95 insertions(+), 86 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4fb73c0aca05..e74e2d74cd36 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1588,7 +1588,6 @@ xfs_bmap_add_extent_delay_real(
>  {
>  	struct xfs_bmbt_irec	*new = &bma->got;
>  	int			diff;	/* temp value */
> -	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
>  	int			error;	/* error return value */
>  	int			i;	/* temp state */
>  	xfs_ifork_t		*ifp;	/* inode fork pointer */
> @@ -1600,10 +1599,10 @@ xfs_bmap_add_extent_delay_real(
>  	xfs_filblks_t		da_new; /* new count del alloc blocks used */
>  	xfs_filblks_t		da_old; /* old count del alloc blocks used */
>  	xfs_filblks_t		temp=0;	/* value for da_new calculations */
> -	xfs_filblks_t		temp2=0;/* value for da_new calculations */
>  	int			tmp_rval;	/* partial logging flags */
>  	struct xfs_mount	*mp;
>  	xfs_extnum_t		*nextents;
> +	struct xfs_bmbt_irec	old;
>  
>  	mp = bma->ip->i_mount;
>  	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
> @@ -1629,9 +1628,9 @@ xfs_bmap_add_extent_delay_real(
>  	/*
>  	 * Set up a bunch of variables to make the tests simpler.
>  	 */
> -	ep = xfs_iext_get_ext(ifp, bma->idx);
> -	xfs_bmbt_get_all(ep, &PREV);
> +	xfs_iext_get_extent(ifp, bma->idx, &PREV);
>  	new_endoff = new->br_startoff + new->br_blockcount;
> +	ASSERT(isnullstartblock(PREV.br_startblock));
>  	ASSERT(PREV.br_startoff <= new->br_startoff);
>  	ASSERT(PREV.br_startoff + PREV.br_blockcount >= new_endoff);
>  
> @@ -1706,9 +1705,8 @@ xfs_bmap_add_extent_delay_real(
>  		 */
>  		bma->idx--;
>  		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx),
> -			LEFT.br_blockcount + PREV.br_blockcount +
> -			RIGHT.br_blockcount);
> +		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
> +		xfs_iext_update_extent(ifp, bma->idx, &LEFT);
>  		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
>  
>  		xfs_iext_remove(bma->ip, bma->idx + 1, 2, state);
> @@ -1733,9 +1731,7 @@ xfs_bmap_add_extent_delay_real(
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
>  					LEFT.br_startblock,
> -					LEFT.br_blockcount +
> -					PREV.br_blockcount +
> -					RIGHT.br_blockcount, LEFT.br_state);
> +					LEFT.br_blockcount, LEFT.br_state);
>  			if (error)
>  				goto done;
>  		}
> @@ -1748,9 +1744,10 @@ xfs_bmap_add_extent_delay_real(
>  		 */
>  		bma->idx--;
>  
> +		old = LEFT;
>  		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx),
> -			LEFT.br_blockcount + PREV.br_blockcount);
> +		LEFT.br_blockcount += PREV.br_blockcount;
> +		xfs_iext_update_extent(ifp, bma->idx, &LEFT);
>  		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
>  
>  		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
> @@ -1758,16 +1755,15 @@ xfs_bmap_add_extent_delay_real(
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
>  					LEFT.br_startblock,
> -					LEFT.br_blockcount +
> -					PREV.br_blockcount, LEFT.br_state);
> +					LEFT.br_blockcount, LEFT.br_state);
>  			if (error)
>  				goto done;
>  		}
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
>  		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
>  
>  		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
> @@ -1796,9 +1792,8 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			error = xfs_bmbt_update(bma->cur, PREV.br_startoff,
> -					new->br_startblock,
> -					PREV.br_blockcount +
> -					RIGHT.br_blockcount, PREV.br_state);
> +					PREV.br_startblock,
> +					PREV.br_blockcount, PREV.br_state);
>  			if (error)
>  				goto done;
>  		}
> @@ -1811,8 +1806,9 @@ xfs_bmap_add_extent_delay_real(
>  		 * the new one.
>  		 */
>  		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		xfs_bmbt_set_startblock(ep, new->br_startblock);
> -		xfs_bmbt_set_state(ep, new->br_state);
> +		PREV.br_startblock = new->br_startblock;
> +		PREV.br_state = new->br_state;
> +		xfs_iext_update_extent(ifp, bma->idx, &PREV);
>  		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
>  
>  		(*nextents)++;
> @@ -1839,38 +1835,39 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the first part of a previous delayed allocation.
>  		 * The left neighbor is contiguous.
>  		 */
> +		old = LEFT;
> +		temp = PREV.br_blockcount - new->br_blockcount;
> +		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
> +				startblockval(PREV.br_startblock));
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
>  		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep, temp);
> +		PREV.br_blockcount = temp = PREV.br_blockcount - new->br_blockcount;
> +		PREV.br_startoff += new->br_blockcount;
> +		PREV.br_startblock = nullstartblock(da_new);
> +		xfs_iext_update_extent(ifp, bma->idx, &PREV);
> +		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
> +
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
> -		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
> -			startblockval(PREV.br_startblock));
> -		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
> -		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
>  
>  		bma->idx--;
>  		break;
> @@ -1880,10 +1877,6 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the first part of a previous delayed allocation.
>  		 * The left neighbor is not contiguous.
>  		 */
> -		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		xfs_bmbt_set_startoff(ep, new_endoff);
> -		temp = PREV.br_blockcount - new->br_blockcount;
> -		xfs_bmbt_set_blockcount(ep, temp);
>  		xfs_iext_insert(bma->ip, bma->idx, 1, new, state);
>  		(*nextents)++;
>  		if (bma->cur == NULL)
> @@ -1911,12 +1904,19 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +
> +		temp = PREV.br_blockcount - new->br_blockcount;
>  		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
>  			startblockval(PREV.br_startblock) -
>  			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
> -		ep = xfs_iext_get_ext(ifp, bma->idx + 1);
> -		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
> +
> +		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
> +		PREV.br_startoff = new_endoff;
> +		PREV.br_blockcount = temp;
> +		PREV.br_startblock = nullstartblock(da_new);
> +		xfs_iext_update_extent(ifp, bma->idx + 1, &PREV);
>  		trace_xfs_bmap_post_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
> +
>  		break;
>  
>  	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
> @@ -1924,37 +1924,39 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the last part of a previous delayed allocation.
>  		 * The right neighbor is contiguous with the new allocation.
>  		 */
> -		temp = PREV.br_blockcount - new->br_blockcount;
> +		old = RIGHT;
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
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(bma->cur, RIGHT.br_startoff,
> -					RIGHT.br_startblock,
> -					RIGHT.br_blockcount, &i);
> +			error = xfs_bmbt_lookup_eq(bma->cur, old.br_startoff,
> +					old.br_startblock,
> +					old.br_blockcount, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(bma->cur, new->br_startoff,
> -					new->br_startblock,
> -					new->br_blockcount +
> -					RIGHT.br_blockcount,
> +			error = xfs_bmbt_update(bma->cur, RIGHT.br_startoff,
> +					RIGHT.br_startblock, RIGHT.br_blockcount,
>  					RIGHT.br_state);
>  			if (error)
>  				goto done;
>  		}
>  
> +		temp = PREV.br_blockcount - new->br_blockcount;
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
> @@ -1965,9 +1967,6 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the last part of a previous delayed allocation.
>  		 * The right neighbor is not contiguous.
>  		 */
> -		temp = PREV.br_blockcount - new->br_blockcount;
> -		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep, temp);
>  		xfs_iext_insert(bma->ip, bma->idx + 1, 1, new, state);
>  		(*nextents)++;
>  		if (bma->cur == NULL)
> @@ -1995,11 +1994,16 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +
> +		temp = PREV.br_blockcount - new->br_blockcount;
>  		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
>  			startblockval(PREV.br_startblock) -
>  			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
> -		ep = xfs_iext_get_ext(ifp, bma->idx);
> -		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
> +
> +		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
> +		PREV.br_startblock = nullstartblock(da_new);
> +		PREV.br_blockcount = temp;
> +		xfs_iext_update_extent(ifp, bma->idx, &PREV);
>  		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
>  
>  		bma->idx++;
> @@ -2026,19 +2030,33 @@ xfs_bmap_add_extent_delay_real(
>  		 *  PREV @ idx          LEFT              RIGHT
>  		 *                      inserted at idx + 1
>  		 */
> -		temp = new->br_startoff - PREV.br_startoff;
> -		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
> -		trace_xfs_bmap_pre_update(bma->ip, bma->idx, 0, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep, temp);	/* truncate PREV */
> +		old = PREV;
> +
> +		/* LEFT is the new middle */
>  		LEFT = *new;
> +
> +		/* RIGHT is the new right */
>  		RIGHT.br_state = PREV.br_state;
> -		RIGHT.br_startblock = nullstartblock(
> -				(int)xfs_bmap_worst_indlen(bma->ip, temp2));
>  		RIGHT.br_startoff = new_endoff;
> -		RIGHT.br_blockcount = temp2;
> +		RIGHT.br_blockcount =
> +			PREV.br_startoff + PREV.br_blockcount - new_endoff;
> +		RIGHT.br_startblock =
> +			nullstartblock(xfs_bmap_worst_indlen(bma->ip,
> +					RIGHT.br_blockcount));
> +
> +		/* truncate PREV */
> +		trace_xfs_bmap_pre_update(bma->ip, bma->idx, 0, _THIS_IP_);
> +		PREV.br_blockcount = new->br_startoff - PREV.br_startoff;
> +		PREV.br_startblock =
> +			nullstartblock(xfs_bmap_worst_indlen(bma->ip,
> +					PREV.br_blockcount));
> +		xfs_iext_update_extent(ifp, bma->idx, &PREV);
> +		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
> +
>  		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
>  		xfs_iext_insert(bma->ip, bma->idx + 1, 2, &LEFT, state);
>  		(*nextents)++;
> +
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
> @@ -2064,12 +2082,12 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> -		temp = xfs_bmap_worst_indlen(bma->ip, temp);
> -		temp2 = xfs_bmap_worst_indlen(bma->ip, temp2);
> -		diff = (int)(temp + temp2 -
> -			     (startblockval(PREV.br_startblock) -
> -			      (bma->cur ?
> -			       bma->cur->bc_private.b.allocated : 0)));
> +
> +		da_new = startblockval(PREV.br_startblock) +
> +			 startblockval(RIGHT.br_startblock);
> +		diff = da_new - startblockval(old.br_startblock);
> +		if (bma->cur)
> +			diff += bma->cur->bc_private.b.allocated;
>  		if (diff > 0) {
>  			error = xfs_mod_fdblocks(bma->ip->i_mount,
>  						 -((int64_t)diff), false);
> @@ -2078,16 +2096,7 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  		}
>  
> -		ep = xfs_iext_get_ext(ifp, bma->idx);
> -		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
> -		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
> -		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, bma->idx + 2),
> -			nullstartblock((int)temp2));
> -		trace_xfs_bmap_post_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
> -
>  		bma->idx++;
> -		da_new = temp + temp2;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
