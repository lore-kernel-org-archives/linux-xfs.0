Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756600AbdIHRTC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 13:19:02 -0400
Date: Fri, 8 Sep 2017 13:19:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/17] xfs: refactor xfs_bmap_add_extent_unwritten_real
Message-ID: <20170908171900.GB905@bfoster.bfoster>
References: <20170903072956.3175-1-hch@lst.de>
 <20170903072956.3175-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903072956.3175-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 09:29:51AM +0200, Christoph Hellwig wrote:
> Use xfs_iext_get_extent to find, and xfs_iext_update_extent to update
> entries in the in-core extent list.  This isolates the function from
> the detailed layout of the extent list, and generally makes the code
> a lot more readable.
> 
> Also get rid of the oldext and newext variables as using the extent
> records is a lot more descriptive.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 208 +++++++++++++++++++++++------------------------
>  1 file changed, 104 insertions(+), 104 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index edea670a3f74..bc41fc18cceb 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -2171,18 +2171,16 @@ xfs_bmap_add_extent_unwritten_real(
>  	int			*logflagsp) /* inode logging flags */
>  {
>  	xfs_btree_cur_t		*cur;	/* btree cursor */
> -	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
>  	int			error;	/* error return value */
>  	int			i;	/* temp state */
>  	xfs_ifork_t		*ifp;	/* inode fork pointer */
>  	xfs_fileoff_t		new_endoff;	/* end offset of new entry */
> -	xfs_exntst_t		newext;	/* new extent state */
> -	xfs_exntst_t		oldext;	/* old extent state */
>  	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
>  					/* left is 0, right is 1, prev is 2 */
>  	int			rval=0;	/* return value (logging flags) */
>  	int			state = 0;/* state bits, accessed thru macros */
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_bmbt_irec	old;
>  
>  	*logflagsp = 0;
>  
> @@ -2205,12 +2203,8 @@ xfs_bmap_add_extent_unwritten_real(
>  	 * Set up a bunch of variables to make the tests simpler.
>  	 */
>  	error = 0;
> -	ep = xfs_iext_get_ext(ifp, *idx);
> -	xfs_bmbt_get_all(ep, &PREV);
> -	newext = new->br_state;
> -	oldext = (newext == XFS_EXT_UNWRITTEN) ?
> -		XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
> -	ASSERT(PREV.br_state == oldext);
> +	xfs_iext_get_extent(ifp, *idx, &PREV);
> +	ASSERT(new->br_state != PREV.br_state);
>  	new_endoff = new->br_startoff + new->br_blockcount;
>  	ASSERT(PREV.br_startoff <= new->br_startoff);
>  	ASSERT(PREV.br_startoff + PREV.br_blockcount >= new_endoff);
> @@ -2239,7 +2233,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
>  	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
>  	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
> -	    LEFT.br_state == newext &&
> +	    LEFT.br_state == new->br_state &&
>  	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
>  		state |= BMAP_LEFT_CONTIG;
>  
> @@ -2258,7 +2252,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
>  	    new_endoff == RIGHT.br_startoff &&
>  	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
> -	    newext == RIGHT.br_state &&
> +	    new->br_state == RIGHT.br_state &&
>  	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
>  	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
>  		       BMAP_RIGHT_FILLING)) !=
> @@ -2282,9 +2276,8 @@ xfs_bmap_add_extent_unwritten_real(
>  		--*idx;
>  
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
> -			LEFT.br_blockcount + PREV.br_blockcount +
> -			RIGHT.br_blockcount);
> +		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx, &LEFT);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		xfs_iext_remove(ip, *idx + 1, 2, state);
> @@ -2311,10 +2304,10 @@ xfs_bmap_add_extent_unwritten_real(
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
> -				LEFT.br_startblock,
> -				LEFT.br_blockcount + PREV.br_blockcount +
> -				RIGHT.br_blockcount, LEFT.br_state)))
> +			error = xfs_bmbt_update(cur, LEFT.br_startoff,
> +					LEFT.br_startblock, LEFT.br_blockcount,
> +					LEFT.br_state);
> +			if (error)
>  				goto done;
>  		}
>  		break;
> @@ -2327,8 +2320,8 @@ xfs_bmap_add_extent_unwritten_real(
>  		--*idx;
>  
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
> -			LEFT.br_blockcount + PREV.br_blockcount);
> +		LEFT.br_blockcount += PREV.br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx, &LEFT);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		xfs_iext_remove(ip, *idx + 1, 1, state);
> @@ -2349,10 +2342,10 @@ xfs_bmap_add_extent_unwritten_real(
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
> -				LEFT.br_startblock,
> -				LEFT.br_blockcount + PREV.br_blockcount,
> -				LEFT.br_state)))
> +			error = xfs_bmbt_update(cur, LEFT.br_startoff,
> +					LEFT.br_startblock, LEFT.br_blockcount,
> +					LEFT.br_state);
> +			if (error)
>  				goto done;
>  		}
>  		break;
> @@ -2363,10 +2356,11 @@ xfs_bmap_add_extent_unwritten_real(
>  		 * The right neighbor is contiguous, the left is not.
>  		 */
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep,
> -			PREV.br_blockcount + RIGHT.br_blockcount);
> -		xfs_bmbt_set_state(ep, newext);
> +		PREV.br_blockcount += RIGHT.br_blockcount;
> +		PREV.br_state = new->br_state;
> +		xfs_iext_update_extent(ifp, *idx, &PREV);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> +
>  		xfs_iext_remove(ip, *idx + 1, 1, state);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> @@ -2385,10 +2379,10 @@ xfs_bmap_add_extent_unwritten_real(
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			if ((error = xfs_bmbt_update(cur, new->br_startoff,
> -				new->br_startblock,
> -				new->br_blockcount + RIGHT.br_blockcount,
> -				newext)))
> +			error = xfs_bmbt_update(cur, PREV.br_startoff,
> +					PREV.br_startblock, PREV.br_blockcount,
> +					PREV.br_state);
> +			if (error)
>  				goto done;
>  		}
>  		break;
> @@ -2400,7 +2394,8 @@ xfs_bmap_add_extent_unwritten_real(
>  		 * the new one.
>  		 */
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_state(ep, newext);
> +		PREV.br_state = new->br_state;
> +		xfs_iext_update_extent(ifp, *idx, &PREV);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		if (cur == NULL)
> @@ -2412,9 +2407,10 @@ xfs_bmap_add_extent_unwritten_real(
>  					&i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			if ((error = xfs_bmbt_update(cur, new->br_startoff,
> -				new->br_startblock, new->br_blockcount,
> -				newext)))
> +			error = xfs_bmbt_update(cur, PREV.br_startoff,
> +					PREV.br_startblock, PREV.br_blockcount,
> +					PREV.br_state);
> +			if (error)
>  				goto done;
>  		}
>  		break;
> @@ -2425,17 +2421,16 @@ xfs_bmap_add_extent_unwritten_real(
>  		 * The left neighbor is contiguous.
>  		 */
>  		trace_xfs_bmap_pre_update(ip, *idx - 1, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx - 1),
> -			LEFT.br_blockcount + new->br_blockcount);
> -		xfs_bmbt_set_startoff(ep,
> -			PREV.br_startoff + new->br_blockcount);
> +		LEFT.br_blockcount += new->br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx - 1, &LEFT);
>  		trace_xfs_bmap_post_update(ip, *idx - 1, state, _THIS_IP_);
>  
> +		old = PREV;
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_startblock(ep,
> -			new->br_startblock + new->br_blockcount);
> -		xfs_bmbt_set_blockcount(ep,
> -			PREV.br_blockcount - new->br_blockcount);
> +		PREV.br_startoff += new->br_blockcount;
> +		PREV.br_startblock += new->br_blockcount;
> +		PREV.br_blockcount -= new->br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx, &PREV);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		--*idx;
> @@ -2444,23 +2439,23 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_DEXT;
>  		else {
>  			rval = 0;
> -			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					&i)))
> +			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> +					old.br_startblock, old.br_blockcount,
> +					&i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			if ((error = xfs_bmbt_update(cur,
> -				PREV.br_startoff + new->br_blockcount,
> -				PREV.br_startblock + new->br_blockcount,
> -				PREV.br_blockcount - new->br_blockcount,
> -				oldext)))
> +			error = xfs_bmbt_update(cur, PREV.br_startoff,
> +					PREV.br_startblock, PREV.br_blockcount,
> +					PREV.br_state);
> +			if (error)
>  				goto done;
> -			if ((error = xfs_btree_decrement(cur, 0, &i)))
> +			error = xfs_btree_decrement(cur, 0, &i);
> +			if (error)
>  				goto done;
>  			error = xfs_bmbt_update(cur, LEFT.br_startoff,
> -				LEFT.br_startblock,
> -				LEFT.br_blockcount + new->br_blockcount,
> -				LEFT.br_state);
> +					LEFT.br_startblock, LEFT.br_blockcount,
> +					LEFT.br_state);
>  			if (error)
>  				goto done;
>  		}
> @@ -2471,13 +2466,12 @@ xfs_bmap_add_extent_unwritten_real(
>  		 * Setting the first part of a previous oldext extent to newext.
>  		 * The left neighbor is not contiguous.
>  		 */
> +		old = PREV;
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		ASSERT(ep && xfs_bmbt_get_state(ep) == oldext);
> -		xfs_bmbt_set_startoff(ep, new_endoff);
> -		xfs_bmbt_set_blockcount(ep,
> -			PREV.br_blockcount - new->br_blockcount);
> -		xfs_bmbt_set_startblock(ep,
> -			new->br_startblock + new->br_blockcount);
> +		PREV.br_startoff += new->br_blockcount;
> +		PREV.br_startblock += new->br_blockcount;
> +		PREV.br_blockcount -= new->br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx, &PREV);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		xfs_iext_insert(ip, *idx, 1, new, state);
> @@ -2487,16 +2481,16 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					&i)))
> +			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> +					old.br_startblock, old.br_blockcount,
> +					&i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			if ((error = xfs_bmbt_update(cur,
> -				PREV.br_startoff + new->br_blockcount,
> -				PREV.br_startblock + new->br_blockcount,
> -				PREV.br_blockcount - new->br_blockcount,
> -				oldext)))
> +			error = xfs_bmbt_update(cur, PREV.br_startoff,
> +					PREV.br_startblock, PREV.br_blockcount,
> +					PREV.br_state);
> +			if (error)
>  				goto done;
>  			cur->bc_rec.b = *new;
>  			if ((error = xfs_btree_insert(cur, &i)))
> @@ -2510,39 +2504,43 @@ xfs_bmap_add_extent_unwritten_real(
>  		 * Setting the last part of a previous oldext extent to newext.
>  		 * The right neighbor is contiguous with the new allocation.
>  		 */
> +		old = PREV;
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep,
> -			PREV.br_blockcount - new->br_blockcount);
> +		PREV.br_blockcount -= new->br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx, &PREV);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		++*idx;
>  
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
> -			new->br_startoff, new->br_startblock,
> -			new->br_blockcount + RIGHT.br_blockcount, newext);
> +		RIGHT.br_startoff = new->br_startoff;
> +		RIGHT.br_startblock = new->br_startblock;
> +		RIGHT.br_blockcount += new->br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx, &RIGHT);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		if (cur == NULL)
>  			rval = XFS_ILOG_DEXT;
>  		else {
>  			rval = 0;
> -			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
> -					PREV.br_startblock,
> -					PREV.br_blockcount, &i)))
> +			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> +					old.br_startblock, old.br_blockcount,
> +					&i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			if ((error = xfs_bmbt_update(cur, PREV.br_startoff,
> -				PREV.br_startblock,
> -				PREV.br_blockcount - new->br_blockcount,
> -				oldext)))
> +			error = xfs_bmbt_update(cur, PREV.br_startoff,
> +					PREV.br_startblock, PREV.br_blockcount,
> +					PREV.br_state);
> +			if (error)
>  				goto done;
> -			if ((error = xfs_btree_increment(cur, 0, &i)))
> +			error = xfs_btree_increment(cur, 0, &i);
> +			if (error)
>  				goto done;
> -			if ((error = xfs_bmbt_update(cur, new->br_startoff,
> -				new->br_startblock,
> -				new->br_blockcount + RIGHT.br_blockcount,
> -				newext)))
> +			error = xfs_bmbt_update(cur, RIGHT.br_startoff,
> +					RIGHT.br_startblock,
> +					RIGHT.br_blockcount, RIGHT.br_state);
> +			if (error)
>  				goto done;
>  		}
>  		break;
> @@ -2552,9 +2550,10 @@ xfs_bmap_add_extent_unwritten_real(
>  		 * Setting the last part of a previous oldext extent to newext.
>  		 * The right neighbor is not contiguous.
>  		 */
> +		old = PREV;
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep,
> -			PREV.br_blockcount - new->br_blockcount);
> +		PREV.br_blockcount -= new->br_blockcount;
> +		xfs_iext_update_extent(ifp, *idx, &PREV);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		++*idx;
> @@ -2566,15 +2565,16 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					&i)))
> +			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> +					old.br_startblock, old.br_blockcount,
> +					&i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			if ((error = xfs_bmbt_update(cur, PREV.br_startoff,
> -				PREV.br_startblock,
> -				PREV.br_blockcount - new->br_blockcount,
> -				oldext)))
> +			error = xfs_bmbt_update(cur, PREV.br_startoff,
> +					PREV.br_startblock, PREV.br_blockcount,
> +					PREV.br_state);
> +			if (error)
>  				goto done;
>  			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
>  					new->br_startblock, new->br_blockcount,
> @@ -2594,17 +2594,18 @@ xfs_bmap_add_extent_unwritten_real(
>  		 * newext.  Contiguity is impossible here.
>  		 * One extent becomes three extents.
>  		 */
> +		old = PREV;
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep,
> -			new->br_startoff - PREV.br_startoff);
> +		PREV.br_blockcount = new->br_startoff - PREV.br_startoff;
> +		xfs_iext_update_extent(ifp, *idx, &PREV);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		r[0] = *new;
>  		r[1].br_startoff = new_endoff;
>  		r[1].br_blockcount =
> -			PREV.br_startoff + PREV.br_blockcount - new_endoff;
> +			old.br_startoff + old.br_blockcount - new_endoff;
>  		r[1].br_startblock = new->br_startblock + new->br_blockcount;
> -		r[1].br_state = oldext;
> +		r[1].br_state = PREV.br_state;
>  
>  		++*idx;
>  		xfs_iext_insert(ip, *idx, 2, &r[0], state);
> @@ -2615,9 +2616,10 @@ xfs_bmap_add_extent_unwritten_real(
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
>  			rval = XFS_ILOG_CORE;
> -			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					&i)))
> +			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
> +					old.br_startblock, old.br_blockcount,
> +					&i);
> +			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			/* new right extent - oldext */
> @@ -2627,8 +2629,6 @@ xfs_bmap_add_extent_unwritten_real(
>  				goto done;
>  			/* new left extent - oldext */
>  			cur->bc_rec.b = PREV;
> -			cur->bc_rec.b.br_blockcount =
> -				new->br_startoff - PREV.br_startoff;
>  			if ((error = xfs_btree_insert(cur, &i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
