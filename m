Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756669AbdIHRTK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 13:19:10 -0400
Date: Fri, 8 Sep 2017 13:19:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 14/17] xfs: pass a struct xfs_bmbt_irec to
 xfs_bmbt_lookup_eq
Message-ID: <20170908171908.GD905@bfoster.bfoster>
References: <20170903072956.3175-1-hch@lst.de>
 <20170903072956.3175-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903072956.3175-15-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 09:29:53AM +0200, Christoph Hellwig wrote:
> Now that we've massaged the callers into the right form we can always
> pass the actual extent record instead of the individual fields.
> 
> As an additional benefit the btree cursor will now be prepoulated with
> the correct extent state instead of having to fix it up later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 145 +++++++++++++----------------------------------
>  1 file changed, 39 insertions(+), 106 deletions(-)

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9d1e66c708f9..05c0cde3f415 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -113,14 +113,10 @@ xfs_bmap_compute_maxlevels(
>  STATIC int				/* error */
>  xfs_bmbt_lookup_eq(
>  	struct xfs_btree_cur	*cur,
> -	xfs_fileoff_t		off,
> -	xfs_fsblock_t		bno,
> -	xfs_filblks_t		len,
> +	struct xfs_bmbt_irec	*irec,
>  	int			*stat)	/* success/failure */
>  {
> -	cur->bc_rec.b.br_startoff = off;
> -	cur->bc_rec.b.br_startblock = bno;
> -	cur->bc_rec.b.br_blockcount = len;
> +	cur->bc_rec.b = *irec;
>  	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
>  }
>  
> @@ -1711,9 +1707,7 @@ xfs_bmap_add_extent_delay_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			error = xfs_bmbt_lookup_eq(bma->cur, RIGHT.br_startoff,
> -					RIGHT.br_startblock,
> -					RIGHT.br_blockcount, &i);
> +			error = xfs_bmbt_lookup_eq(bma->cur, &RIGHT, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -1749,9 +1743,7 @@ xfs_bmap_add_extent_delay_real(
>  			rval = XFS_ILOG_DEXT;
>  		else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(bma->cur, old.br_startoff,
> -					old.br_startblock, old.br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(bma->cur, &old, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -1777,9 +1769,7 @@ xfs_bmap_add_extent_delay_real(
>  			rval = XFS_ILOG_DEXT;
>  		else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(bma->cur, RIGHT.br_startoff,
> -					RIGHT.br_startblock,
> -					RIGHT.br_blockcount, &i);
> +			error = xfs_bmbt_lookup_eq(bma->cur, &RIGHT, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -1806,13 +1796,10 @@ xfs_bmap_add_extent_delay_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
> -					new->br_startblock, new->br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
> -			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
>  			error = xfs_btree_insert(bma->cur, &i);
>  			if (error)
>  				goto done;
> @@ -1836,9 +1823,7 @@ xfs_bmap_add_extent_delay_real(
>  			rval = XFS_ILOG_DEXT;
>  		else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(bma->cur, old.br_startoff,
> -					old.br_startblock, old.br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(bma->cur, &old, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -1872,13 +1857,10 @@ xfs_bmap_add_extent_delay_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
> -					new->br_startblock, new->br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
> -			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
>  			error = xfs_btree_insert(bma->cur, &i);
>  			if (error)
>  				goto done;
> @@ -1924,9 +1906,7 @@ xfs_bmap_add_extent_delay_real(
>  			rval = XFS_ILOG_DEXT;
>  		else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(bma->cur, RIGHT.br_startoff,
> -					RIGHT.br_startblock,
> -					RIGHT.br_blockcount, &i);
> +			error = xfs_bmbt_lookup_eq(bma->cur, &RIGHT, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -1959,13 +1939,10 @@ xfs_bmap_add_extent_delay_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
> -					new->br_startblock, new->br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
> -			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
>  			error = xfs_btree_insert(bma->cur, &i);
>  			if (error)
>  				goto done;
> @@ -2035,13 +2012,10 @@ xfs_bmap_add_extent_delay_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
> -					new->br_startblock, new->br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
> -			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
>  			error = xfs_btree_insert(bma->cur, &i);
>  			if (error)
>  				goto done;
> @@ -2273,9 +2247,8 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			if ((error = xfs_bmbt_lookup_eq(cur, RIGHT.br_startoff,
> -					RIGHT.br_startblock,
> -					RIGHT.br_blockcount, &i)))
> +			error = xfs_bmbt_lookup_eq(cur, &RIGHT, &i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			if ((error = xfs_btree_delete(cur, &i)))
> @@ -2315,9 +2288,8 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					&i)))
> +			error = xfs_bmbt_lookup_eq(cur, &PREV, &i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			if ((error = xfs_btree_delete(cur, &i)))
> @@ -2350,9 +2322,8 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			if ((error = xfs_bmbt_lookup_eq(cur, RIGHT.br_startoff,
> -					RIGHT.br_startblock,
> -					RIGHT.br_blockcount, &i)))
> +			error = xfs_bmbt_lookup_eq(cur, &RIGHT, &i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			if ((error = xfs_btree_delete(cur, &i)))
> @@ -2382,9 +2353,8 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_DEXT;
>  		else {
>  			rval = 0;
> -			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
> -					new->br_startblock, new->br_blockcount,
> -					&i)))
> +			error = xfs_bmbt_lookup_eq(cur, new, &i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			error = xfs_bmbt_update(cur, &PREV);
> @@ -2417,9 +2387,7 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_DEXT;
>  		else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> -					old.br_startblock, old.br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(cur, &old, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -2455,9 +2423,7 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> -					old.br_startblock, old.br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(cur, &old, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -2495,9 +2461,7 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_DEXT;
>  		else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> -					old.br_startblock, old.br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(cur, &old, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -2533,21 +2497,17 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> -					old.br_startblock, old.br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(cur, &old, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			error = xfs_bmbt_update(cur, &PREV);
>  			if (error)
>  				goto done;
> -			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
> -					new->br_startblock, new->br_blockcount,
> -					&i)))
> +			error = xfs_bmbt_lookup_eq(cur, new, &i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
> -			cur->bc_rec.b.br_state = new->br_state;
>  			if ((error = xfs_btree_insert(cur, &i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -2582,9 +2542,7 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> -					old.br_startblock, old.br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(cur, &old, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -2602,13 +2560,11 @@ xfs_bmap_add_extent_unwritten_real(
>  			 * we are about to insert as we can't trust it after
>  			 * the previous insert.
>  			 */
> -			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
> -					new->br_startblock, new->br_blockcount,
> -					&i)))
> +			error = xfs_bmbt_lookup_eq(cur, new, &i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
>  			/* new middle extent - newext */
> -			cur->bc_rec.b.br_state = new->br_state;
>  			if ((error = xfs_btree_insert(cur, &i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -2917,9 +2873,7 @@ xfs_bmap_add_extent_hole_real(
>  			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
>  		} else {
>  			rval = XFS_ILOG_CORE;
> -			error = xfs_bmbt_lookup_eq(cur, right.br_startoff,
> -					right.br_startblock, right.br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(cur, &right, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -2954,9 +2908,7 @@ xfs_bmap_add_extent_hole_real(
>  			rval = xfs_ilog_fext(whichfork);
>  		} else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> -					old.br_startblock, old.br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(cur, &old, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -2984,9 +2936,7 @@ xfs_bmap_add_extent_hole_real(
>  			rval = xfs_ilog_fext(whichfork);
>  		} else {
>  			rval = 0;
> -			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> -					old.br_startblock, old.br_blockcount,
> -					&i);
> +			error = xfs_bmbt_lookup_eq(cur, &old, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -3009,14 +2959,10 @@ xfs_bmap_add_extent_hole_real(
>  			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
>  		} else {
>  			rval = XFS_ILOG_CORE;
> -			error = xfs_bmbt_lookup_eq(cur,
> -					new->br_startoff,
> -					new->br_startblock,
> -					new->br_blockcount, &i);
> +			error = xfs_bmbt_lookup_eq(cur, new, &i);
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
> -			cur->bc_rec.b.br_state = new->br_state;
>  			error = xfs_btree_insert(cur, &i);
>  			if (error)
>  				goto done;
> @@ -5116,8 +5062,7 @@ xfs_bmap_del_extent_real(
>  
>  	del_endblock = del->br_startblock + del->br_blockcount;
>  	if (cur) {
> -		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
> -				got.br_startblock, got.br_blockcount, &i);
> +		error = xfs_bmbt_lookup_eq(cur, &got, &i);
>  		if (error)
>  			goto done;
>  		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -5220,9 +5165,7 @@ xfs_bmap_del_extent_real(
>  				 * Reset the cursor, don't trust it after any
>  				 * insert operation.
>  				 */
> -				error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
> -						got.br_startblock,
> -						got.br_blockcount, &i);
> +				error = xfs_bmbt_lookup_eq(cur, &got, &i);
>  				if (error)
>  					goto done;
>  				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> @@ -5750,8 +5693,7 @@ xfs_bmse_merge(
>  	}
>  
>  	/* lookup and remove the extent to merge */
> -	error = xfs_bmbt_lookup_eq(cur, got->br_startoff, got->br_startblock,
> -				   got->br_blockcount, &i);
> +	error = xfs_bmbt_lookup_eq(cur, got, &i);
>  	if (error)
>  		return error;
>  	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
> @@ -5762,8 +5704,7 @@ xfs_bmse_merge(
>  	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
>  
>  	/* lookup and update size of the previous extent */
> -	error = xfs_bmbt_lookup_eq(cur, left->br_startoff, left->br_startblock,
> -				   left->br_blockcount, &i);
> +	error = xfs_bmbt_lookup_eq(cur, left, &i);
>  	if (error)
>  		return error;
>  	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
> @@ -5879,8 +5820,7 @@ xfs_bmse_shift_one(
>  	new.br_startoff = startoff;
>  
>  	if (cur) {
> -		error = xfs_bmbt_lookup_eq(cur, got->br_startoff,
> -				got->br_startblock, got->br_blockcount, &i);
> +		error = xfs_bmbt_lookup_eq(cur, got, &i);
>  		if (error)
>  			return error;
>  		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
> @@ -6132,10 +6072,7 @@ xfs_bmap_split_extent_at(
>  		cur->bc_private.b.firstblock = *firstfsb;
>  		cur->bc_private.b.dfops = dfops;
>  		cur->bc_private.b.flags = 0;
> -		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
> -				got.br_startblock,
> -				got.br_blockcount,
> -				&i);
> +		error = xfs_bmbt_lookup_eq(cur, &got, &i);
>  		if (error)
>  			goto del_cursor;
>  		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, del_cursor);
> @@ -6159,14 +6096,10 @@ xfs_bmap_split_extent_at(
>  			   XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
>  
>  	if (cur) {
> -		error = xfs_bmbt_lookup_eq(cur, new.br_startoff,
> -				new.br_startblock, new.br_blockcount,
> -				&i);
> +		error = xfs_bmbt_lookup_eq(cur, &new, &i);
>  		if (error)
>  			goto del_cursor;
>  		XFS_WANT_CORRUPTED_GOTO(mp, i == 0, del_cursor);
> -		cur->bc_rec.b.br_state = new.br_state;
> -
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
>  			goto del_cursor;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
