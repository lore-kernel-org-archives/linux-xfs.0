Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbdKCPSa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Nov 2017 11:18:30 -0400
Date: Fri, 3 Nov 2017 11:18:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/21] xfs: introduce the xfs_iext_cursor abstraction
Message-ID: <20171103151827.GC20279@bfoster.bfoster>
References: <20171103144539.2187-1-hch@lst.de>
 <20171103144539.2187-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103144539.2187-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 03, 2017 at 05:45:30PM +0300, Christoph Hellwig wrote:
> Add a new xfs_iext_cursor structure to hide the direct extent map
> index manipulations. In addition to the existing lookup/get/insert/
> remove and update routines new primitives to get the first and last
> extent cursor, as well as moving up and down by one extent are
> provided.  Also new are convenience to increment/decrement the
> cursor and retreive the new extent, as well as to peek into the
> previous/next extent without updating the cursor and last but not
> least a macro to iterate over all extents in a fork.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c       | 441 ++++++++++++++++++++---------------------
>  fs/xfs/libxfs/xfs_bmap.h       |  12 +-
>  fs/xfs/libxfs/xfs_inode_fork.c |  75 +++----
>  fs/xfs/libxfs/xfs_inode_fork.h |  87 +++++++-
>  fs/xfs/libxfs/xfs_types.h      |   3 +
>  fs/xfs/scrub/bmap.c            |   6 +-
>  fs/xfs/scrub/dir.c             |  14 +-
>  fs/xfs/xfs_bmap_util.c         |  12 +-
>  fs/xfs/xfs_dir2_readdir.c      |   8 +-
>  fs/xfs/xfs_dquot.c             |   4 +-
>  fs/xfs/xfs_iomap.c             |  14 +-
>  fs/xfs/xfs_reflink.c           |  56 +++---
>  fs/xfs/xfs_trace.h             |  12 +-
>  13 files changed, 407 insertions(+), 337 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index f4d0639dc4ae..b08c4863c2af 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -672,8 +672,9 @@ xfs_bmap_extents_to_btree(
>  	xfs_bmbt_key_t		*kp;		/* root block key pointer */
>  	xfs_mount_t		*mp;		/* mount structure */
>  	xfs_bmbt_ptr_t		*pp;		/* root block address pointer */
> +	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_irec	rec;
> -	xfs_extnum_t		i = 0, cnt = 0;
> +	xfs_extnum_t		cnt = 0;
>  
>  	mp = ip->i_mount;
>  	ASSERT(whichfork != XFS_COW_FORK);
> @@ -752,7 +753,7 @@ xfs_bmap_extents_to_btree(
>  				XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
>  				XFS_BTREE_LONG_PTRS);
>  
> -	while (xfs_iext_get_extent(ifp, i++, &rec)) {
> +	for_each_iext(ifp, &icur, &rec) {
>  		if (isnullstartblock(rec.br_startblock))
>  			continue;
>  		arp = XFS_BMBT_REC_ADDR(mp, ablock, 1 + cnt);
> @@ -828,6 +829,7 @@ xfs_bmap_local_to_extents(
>  	xfs_alloc_arg_t	args;		/* allocation arguments */
>  	xfs_buf_t	*bp;		/* buffer for extent block */
>  	struct xfs_bmbt_irec rec;
> +	struct xfs_iext_cursor icur;
>  
>  	/*
>  	 * We don't want to deal with the case of keeping inode data inline yet.
> @@ -894,7 +896,8 @@ xfs_bmap_local_to_extents(
>  	rec.br_startblock = args.fsbno;
>  	rec.br_blockcount = 1;
>  	rec.br_state = XFS_EXT_NORM;
> -	xfs_iext_insert(ip, 0, 1, &rec, 0);
> +	xfs_iext_first(ifp, &icur);
> +	xfs_iext_insert(ip, &icur, 1, &rec, 0);
>  
>  	XFS_IFORK_NEXT_SET(ip, whichfork, 1);
>  	ip->i_d.di_nblocks = 1;
> @@ -1174,6 +1177,7 @@ xfs_iread_extents(
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	xfs_extnum_t		nextents = XFS_IFORK_NEXTENTS(ip, whichfork);
>  	struct xfs_btree_block	*block = ifp->if_broot;
> +	struct xfs_iext_cursor	icur;
>  	xfs_fsblock_t		bno;
>  	struct xfs_buf		*bp;
>  	xfs_extnum_t		i, j;
> @@ -1223,6 +1227,7 @@ xfs_iread_extents(
>  	 * Here with bp and block set to the leftmost leaf node in the tree.
>  	 */
>  	i = 0;
> +	xfs_iext_first(ifp, &icur);
>  
>  	/*
>  	 * Loop over all leaf nodes.  Copy information to the extent records.
> @@ -1264,7 +1269,8 @@ xfs_iread_extents(
>  			}
>  			trp->l0 = be64_to_cpu(frp->l0);
>  			trp->l1 = be64_to_cpu(frp->l1);
> -			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
> +			trace_xfs_read_extent(ip, &icur, state, _THIS_IP_);
> +			xfs_iext_next(ifp, &icur);
>  		}
>  		xfs_trans_brelse(tp, bp);
>  		bno = nextbno;
> @@ -1312,7 +1318,7 @@ xfs_bmap_first_unused(
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	struct xfs_bmbt_irec	got;
> -	xfs_extnum_t		idx = 0;
> +	struct xfs_iext_cursor	icur;
>  	xfs_fileoff_t		lastaddr = 0;
>  	xfs_fileoff_t		lowest, max;
>  	int			error;
> @@ -1333,7 +1339,7 @@ xfs_bmap_first_unused(
>  	}
>  
>  	lowest = max = *first_unused;
> -	while (xfs_iext_get_extent(ifp, idx++, &got)) {
> +	for_each_iext(ifp, &icur, &got) {
>  		/*
>  		 * See if the hole before this extent will work.
>  		 */
> @@ -1363,7 +1369,7 @@ xfs_bmap_last_before(
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	struct xfs_bmbt_irec	got;
> -	xfs_extnum_t		idx;
> +	struct xfs_iext_cursor	icur;
>  	int			error;
>  
>  	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
> @@ -1383,7 +1389,7 @@ xfs_bmap_last_before(
>  			return error;
>  	}
>  
> -	if (!xfs_iext_lookup_extent_before(ip, ifp, last_block, &idx, &got))
> +	if (!xfs_iext_lookup_extent_before(ip, ifp, last_block, &icur, &got))
>  		*last_block = 0;
>  	return 0;
>  }
> @@ -1397,8 +1403,8 @@ xfs_bmap_last_extent(
>  	int			*is_empty)
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	struct xfs_iext_cursor	icur;
>  	int			error;
> -	int			nextents;
>  
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(tp, ip, whichfork);
> @@ -1406,14 +1412,11 @@ xfs_bmap_last_extent(
>  			return error;
>  	}
>  
> -	nextents = xfs_iext_count(ifp);
> -	if (nextents == 0) {
> +	xfs_iext_last(ifp, &icur);
> +	if (!xfs_iext_get_extent(ifp, &icur, rec))
>  		*is_empty = 1;
> -		return 0;
> -	}
> -
> -	xfs_iext_get_extent(ifp, nextents - 1, rec);
> -	*is_empty = 0;
> +	else
> +		*is_empty = 0;
>  	return 0;
>  }
>  
> @@ -1501,6 +1504,7 @@ xfs_bmap_one_block(
>  	xfs_ifork_t	*ifp;		/* inode fork pointer */
>  	int		rval;		/* return value */
>  	xfs_bmbt_irec_t	s;		/* internal version of extent */
> +	struct xfs_iext_cursor icur;
>  
>  #ifndef DEBUG
>  	if (whichfork == XFS_DATA_FORK)
> @@ -1512,7 +1516,8 @@ xfs_bmap_one_block(
>  		return 0;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
> -	xfs_iext_get_extent(ifp, 0, &s);
> +	xfs_iext_first(ifp, &icur);
> +	xfs_iext_get_extent(ifp, &icur, &s);
>  	rval = s.br_startoff == 0 && s.br_blockcount == 1;
>  	if (rval && whichfork == XFS_DATA_FORK)
>  		ASSERT(XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize);
> @@ -1554,8 +1559,6 @@ xfs_bmap_add_extent_delay_real(
>  	nextents = (whichfork == XFS_COW_FORK ? &bma->ip->i_cnextents :
>  						&bma->ip->i_d.di_nextents);
>  
> -	ASSERT(bma->idx >= 0);
> -	ASSERT(bma->idx <= xfs_iext_count(ifp));
>  	ASSERT(!isnullstartblock(new->br_startblock));
>  	ASSERT(!bma->cur ||
>  	       (bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
> @@ -1569,7 +1572,7 @@ xfs_bmap_add_extent_delay_real(
>  	/*
>  	 * Set up a bunch of variables to make the tests simpler.
>  	 */
> -	xfs_iext_get_extent(ifp, bma->idx, &PREV);
> +	xfs_iext_get_extent(ifp, &bma->icur, &PREV);
>  	new_endoff = new->br_startoff + new->br_blockcount;
>  	ASSERT(isnullstartblock(PREV.br_startblock));
>  	ASSERT(PREV.br_startoff <= new->br_startoff);
> @@ -1591,10 +1594,8 @@ xfs_bmap_add_extent_delay_real(
>  	 * Check and set flags if this segment has a left neighbor.
>  	 * Don't set contiguous if the combined extent would be too large.
>  	 */
> -	if (bma->idx > 0) {
> +	if (xfs_iext_peek_prev_extent(ifp, &bma->icur, &LEFT)) {
>  		state |= BMAP_LEFT_VALID;
> -		xfs_iext_get_extent(ifp, bma->idx - 1, &LEFT);
> -
>  		if (isnullstartblock(LEFT.br_startblock))
>  			state |= BMAP_LEFT_DELAY;
>  	}
> @@ -1611,10 +1612,8 @@ xfs_bmap_add_extent_delay_real(
>  	 * Don't set contiguous if the combined extent would be too large.
>  	 * Also check for all-three-contiguous being too large.
>  	 */
> -	if (bma->idx < xfs_iext_count(ifp) - 1) {
> +	if (xfs_iext_peek_next_extent(ifp, &bma->icur, &RIGHT)) {
>  		state |= BMAP_RIGHT_VALID;
> -		xfs_iext_get_extent(ifp, bma->idx + 1, &RIGHT);
> -
>  		if (isnullstartblock(RIGHT.br_startblock))
>  			state |= BMAP_RIGHT_DELAY;
>  	}
> @@ -1646,9 +1645,9 @@ xfs_bmap_add_extent_delay_real(
>  		 */
>  		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
>  
> -		xfs_iext_remove(bma->ip, bma->idx, 2, state);
> -		bma->idx--;
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, &LEFT);
> +		xfs_iext_remove(bma->ip, &bma->icur, 2, state);
> +		xfs_iext_prev(ifp, &bma->icur);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
>  		(*nextents)--;
>  
>  		if (bma->cur == NULL)
> @@ -1681,9 +1680,9 @@ xfs_bmap_add_extent_delay_real(
>  		old = LEFT;
>  		LEFT.br_blockcount += PREV.br_blockcount;
>  
> -		xfs_iext_remove(bma->ip, bma->idx, 1, state);
> -		bma->idx--;
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, &LEFT);
> +		xfs_iext_remove(bma->ip, &bma->icur, 1, state);
> +		xfs_iext_prev(ifp, &bma->icur);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
>  
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_DEXT;
> @@ -1707,10 +1706,10 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_startblock = new->br_startblock;
>  		PREV.br_blockcount += RIGHT.br_blockcount;
>  
> -		bma->idx++;
> -		xfs_iext_remove(bma->ip, bma->idx, 1, state);
> -		bma->idx--;
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
> +		xfs_iext_next(ifp, &bma->icur);
> +		xfs_iext_remove(bma->ip, &bma->icur, 1, state);
> +		xfs_iext_prev(ifp, &bma->icur);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
>  
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_DEXT;
> @@ -1734,7 +1733,7 @@ xfs_bmap_add_extent_delay_real(
>  		 */
>  		PREV.br_startblock = new->br_startblock;
>  		PREV.br_state = new->br_state;
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
>  
>  		(*nextents)++;
>  		if (bma->cur == NULL)
> @@ -1768,9 +1767,9 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_startoff += new->br_blockcount;
>  		PREV.br_startblock = nullstartblock(da_new);
>  
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
> -		bma->idx--;
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, &LEFT);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
> +		xfs_iext_prev(ifp, &bma->icur);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
>  
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_DEXT;
> @@ -1784,7 +1783,6 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> -
>  		break;
>  
>  	case BMAP_LEFT_FILLING:
> @@ -1792,7 +1790,7 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the first part of a previous delayed allocation.
>  		 * The left neighbor is not contiguous.
>  		 */
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, new);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
>  		(*nextents)++;
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> @@ -1825,7 +1823,9 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_startoff = new_endoff;
>  		PREV.br_blockcount = temp;
>  		PREV.br_startblock = nullstartblock(da_new);
> -		xfs_iext_insert(bma->ip, bma->idx + 1, 1, &PREV, state);
> +		xfs_iext_next(ifp, &bma->icur);
> +		xfs_iext_insert(bma->ip, &bma->icur, 1, &PREV, state);
> +		xfs_iext_prev(ifp, &bma->icur);
>  		break;
>  
>  	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
> @@ -1858,9 +1858,9 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_blockcount = temp;
>  		PREV.br_startblock = nullstartblock(da_new);
>  
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
> -		bma->idx++;
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, &RIGHT);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
> +		xfs_iext_next(ifp, &bma->icur);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
>  		break;
>  
>  	case BMAP_RIGHT_FILLING:
> @@ -1868,7 +1868,7 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the last part of a previous delayed allocation.
>  		 * The right neighbor is not contiguous.
>  		 */
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, new);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
>  		(*nextents)++;
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> @@ -1900,9 +1900,8 @@ xfs_bmap_add_extent_delay_real(
>  
>  		PREV.br_startblock = nullstartblock(da_new);
>  		PREV.br_blockcount = temp;
> -		xfs_iext_insert(bma->ip, bma->idx, 1, &PREV, state);
> -
> -		bma->idx++;
> +		xfs_iext_insert(bma->ip, &bma->icur, 1, &PREV, state);
> +		xfs_iext_next(ifp, &bma->icur);
>  		break;
>  
>  	case 0:
> @@ -1945,10 +1944,11 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_startblock =
>  			nullstartblock(xfs_bmap_worst_indlen(bma->ip,
>  					PREV.br_blockcount));
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
>  
>  		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
> -		xfs_iext_insert(bma->ip, bma->idx + 1, 2, &LEFT, state);
> +		xfs_iext_next(ifp, &bma->icur);
> +		xfs_iext_insert(bma->ip, &bma->icur, 2, &LEFT, state);
>  		(*nextents)++;
>  
>  		if (bma->cur == NULL)
> @@ -1976,7 +1976,6 @@ xfs_bmap_add_extent_delay_real(
>  
>  		da_new = startblockval(PREV.br_startblock) +
>  			 startblockval(RIGHT.br_startblock);
> -		bma->idx++;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
> @@ -2040,7 +2039,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	struct xfs_trans	*tp,
>  	xfs_inode_t		*ip,	/* incore inode pointer */
>  	int			whichfork,
> -	xfs_extnum_t		*idx,	/* extent number to update/insert */
> +	struct xfs_iext_cursor	*icur,
>  	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
>  	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
>  	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
> @@ -2064,8 +2063,6 @@ xfs_bmap_add_extent_unwritten_real(
>  	cur = *curp;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  
> -	ASSERT(*idx >= 0);
> -	ASSERT(*idx <= xfs_iext_count(ifp));
>  	ASSERT(!isnullstartblock(new->br_startblock));
>  
>  	XFS_STATS_INC(mp, xs_add_exlist);
> @@ -2078,7 +2075,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	 * Set up a bunch of variables to make the tests simpler.
>  	 */
>  	error = 0;
> -	xfs_iext_get_extent(ifp, *idx, &PREV);
> +	xfs_iext_get_extent(ifp, icur, &PREV);
>  	ASSERT(new->br_state != PREV.br_state);
>  	new_endoff = new->br_startoff + new->br_blockcount;
>  	ASSERT(PREV.br_startoff <= new->br_startoff);
> @@ -2097,10 +2094,8 @@ xfs_bmap_add_extent_unwritten_real(
>  	 * Check and set flags if this segment has a left neighbor.
>  	 * Don't set contiguous if the combined extent would be too large.
>  	 */
> -	if (*idx > 0) {
> +	if (xfs_iext_peek_prev_extent(ifp, icur, &LEFT)) {
>  		state |= BMAP_LEFT_VALID;
> -		xfs_iext_get_extent(ifp, *idx - 1, &LEFT);
> -
>  		if (isnullstartblock(LEFT.br_startblock))
>  			state |= BMAP_LEFT_DELAY;
>  	}
> @@ -2117,9 +2112,8 @@ xfs_bmap_add_extent_unwritten_real(
>  	 * Don't set contiguous if the combined extent would be too large.
>  	 * Also check for all-three-contiguous being too large.
>  	 */
> -	if (*idx < xfs_iext_count(ifp) - 1) {
> +	if (xfs_iext_peek_next_extent(ifp, icur, &RIGHT)) {
>  		state |= BMAP_RIGHT_VALID;
> -		xfs_iext_get_extent(ifp, *idx + 1, &RIGHT);
>  		if (isnullstartblock(RIGHT.br_startblock))
>  			state |= BMAP_RIGHT_DELAY;
>  	}
> @@ -2150,9 +2144,9 @@ xfs_bmap_add_extent_unwritten_real(
>  		 */
>  		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
>  
> -		xfs_iext_remove(ip, *idx, 2, state);
> -		--*idx;
> -		xfs_iext_update_extent(ip, state, *idx, &LEFT);
> +		xfs_iext_remove(ip, icur, 2, state);
> +		xfs_iext_prev(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &LEFT);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  				XFS_IFORK_NEXTENTS(ip, whichfork) - 2);
>  		if (cur == NULL)
> @@ -2188,9 +2182,9 @@ xfs_bmap_add_extent_unwritten_real(
>  		 */
>  		LEFT.br_blockcount += PREV.br_blockcount;
>  
> -		xfs_iext_remove(ip, *idx, 1, state);
> -		--*idx;
> -		xfs_iext_update_extent(ip, state, *idx, &LEFT);
> +		xfs_iext_remove(ip, icur, 1, state);
> +		xfs_iext_prev(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &LEFT);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>  		if (cur == NULL)
> @@ -2221,10 +2215,10 @@ xfs_bmap_add_extent_unwritten_real(
>  		PREV.br_blockcount += RIGHT.br_blockcount;
>  		PREV.br_state = new->br_state;
>  
> -		++*idx;
> -		xfs_iext_remove(ip, *idx, 1, state);
> -		--*idx;
> -		xfs_iext_update_extent(ip, state, *idx, &PREV);
> +		xfs_iext_next(ifp, icur);
> +		xfs_iext_remove(ip, icur, 1, state);
> +		xfs_iext_prev(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &PREV);
>  
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> @@ -2255,7 +2249,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		 * the new one.
>  		 */
>  		PREV.br_state = new->br_state;
> -		xfs_iext_update_extent(ip, state, *idx, &PREV);
> +		xfs_iext_update_extent(ip, state, icur, &PREV);
>  
>  		if (cur == NULL)
>  			rval = XFS_ILOG_DEXT;
> @@ -2283,9 +2277,9 @@ xfs_bmap_add_extent_unwritten_real(
>  		PREV.br_startblock += new->br_blockcount;
>  		PREV.br_blockcount -= new->br_blockcount;
>  
> -		xfs_iext_update_extent(ip, state, *idx, &PREV);
> -		--*idx;
> -		xfs_iext_update_extent(ip, state, *idx, &LEFT);
> +		xfs_iext_update_extent(ip, state, icur, &PREV);
> +		xfs_iext_prev(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &LEFT);
>  
>  		if (cur == NULL)
>  			rval = XFS_ILOG_DEXT;
> @@ -2317,8 +2311,8 @@ xfs_bmap_add_extent_unwritten_real(
>  		PREV.br_startblock += new->br_blockcount;
>  		PREV.br_blockcount -= new->br_blockcount;
>  
> -		xfs_iext_update_extent(ip, state, *idx, &PREV);
> -		xfs_iext_insert(ip, *idx, 1, new, state);
> +		xfs_iext_update_extent(ip, state, icur, &PREV);
> +		xfs_iext_insert(ip, icur, 1, new, state);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
>  		if (cur == NULL)
> @@ -2351,9 +2345,9 @@ xfs_bmap_add_extent_unwritten_real(
>  		RIGHT.br_startblock = new->br_startblock;
>  		RIGHT.br_blockcount += new->br_blockcount;
>  
> -		xfs_iext_update_extent(ip, state, *idx, &PREV);
> -		++*idx;
> -		xfs_iext_update_extent(ip, state, *idx, &RIGHT);
> +		xfs_iext_update_extent(ip, state, icur, &PREV);
> +		xfs_iext_next(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &RIGHT);
>  
>  		if (cur == NULL)
>  			rval = XFS_ILOG_DEXT;
> @@ -2383,9 +2377,9 @@ xfs_bmap_add_extent_unwritten_real(
>  		old = PREV;
>  		PREV.br_blockcount -= new->br_blockcount;
>  
> -		xfs_iext_update_extent(ip, state, *idx, &PREV);
> -		++*idx;
> -		xfs_iext_insert(ip, *idx, 1, new, state);
> +		xfs_iext_update_extent(ip, state, icur, &PREV);
> +		xfs_iext_next(ifp, icur);
> +		xfs_iext_insert(ip, icur, 1, new, state);
>  
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
> @@ -2426,9 +2420,9 @@ xfs_bmap_add_extent_unwritten_real(
>  		r[1].br_startblock = new->br_startblock + new->br_blockcount;
>  		r[1].br_state = PREV.br_state;
>  
> -		xfs_iext_update_extent(ip, state, *idx, &PREV);
> -		++*idx;
> -		xfs_iext_insert(ip, *idx, 2, &r[0], state);
> +		xfs_iext_update_extent(ip, state, icur, &PREV);
> +		xfs_iext_next(ifp, icur);
> +		xfs_iext_insert(ip, icur, 2, &r[0], state);
>  
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  				XFS_IFORK_NEXTENTS(ip, whichfork) + 2);
> @@ -2517,7 +2511,7 @@ STATIC void
>  xfs_bmap_add_extent_hole_delay(
>  	xfs_inode_t		*ip,	/* incore inode pointer */
>  	int			whichfork,
> -	xfs_extnum_t		*idx,	/* extent number to update/insert */
> +	struct xfs_iext_cursor	*icur,
>  	xfs_bmbt_irec_t		*new)	/* new data to add to file extents */
>  {
>  	xfs_ifork_t		*ifp;	/* inode fork pointer */
> @@ -2534,10 +2528,8 @@ xfs_bmap_add_extent_hole_delay(
>  	/*
>  	 * Check and set flags if this segment has a left neighbor
>  	 */
> -	if (*idx > 0) {
> +	if (xfs_iext_peek_prev_extent(ifp, icur, &left)) {
>  		state |= BMAP_LEFT_VALID;
> -		xfs_iext_get_extent(ifp, *idx - 1, &left);
> -
>  		if (isnullstartblock(left.br_startblock))
>  			state |= BMAP_LEFT_DELAY;
>  	}
> @@ -2546,10 +2538,8 @@ xfs_bmap_add_extent_hole_delay(
>  	 * Check and set flags if the current (right) segment exists.
>  	 * If it doesn't exist, we're converting the hole at end-of-file.
>  	 */
> -	if (*idx < xfs_iext_count(ifp)) {
> +	if (xfs_iext_get_extent(ifp, icur, &right)) {
>  		state |= BMAP_RIGHT_VALID;
> -		xfs_iext_get_extent(ifp, *idx, &right);
> -
>  		if (isnullstartblock(right.br_startblock))
>  			state |= BMAP_RIGHT_DELAY;
>  	}
> @@ -2592,9 +2582,9 @@ xfs_bmap_add_extent_hole_delay(
>  		left.br_startblock = nullstartblock(newlen);
>  		left.br_blockcount = temp;
>  
> -		xfs_iext_remove(ip, *idx, 1, state);
> -		--*idx;
> -		xfs_iext_update_extent(ip, state, *idx, &left);
> +		xfs_iext_remove(ip, icur, 1, state);
> +		xfs_iext_prev(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &left);
>  		break;
>  
>  	case BMAP_LEFT_CONTIG:
> @@ -2612,8 +2602,8 @@ xfs_bmap_add_extent_hole_delay(
>  		left.br_blockcount = temp;
>  		left.br_startblock = nullstartblock(newlen);
>  
> -		--*idx;
> -		xfs_iext_update_extent(ip, state, *idx, &left);
> +		xfs_iext_prev(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &left);
>  		break;
>  
>  	case BMAP_RIGHT_CONTIG:
> @@ -2630,7 +2620,7 @@ xfs_bmap_add_extent_hole_delay(
>  		right.br_startoff = new->br_startoff;
>  		right.br_startblock = nullstartblock(newlen);
>  		right.br_blockcount = temp;
> -		xfs_iext_update_extent(ip, state, *idx, &right);
> +		xfs_iext_update_extent(ip, state, icur, &right);
>  		break;
>  
>  	case 0:
> @@ -2640,7 +2630,7 @@ xfs_bmap_add_extent_hole_delay(
>  		 * Insert a new entry.
>  		 */
>  		oldlen = newlen = 0;
> -		xfs_iext_insert(ip, *idx, 1, new, state);
> +		xfs_iext_insert(ip, icur, 1, new, state);
>  		break;
>  	}
>  	if (oldlen != newlen) {
> @@ -2661,7 +2651,7 @@ xfs_bmap_add_extent_hole_real(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
> -	xfs_extnum_t		*idx,
> +	struct xfs_iext_cursor	*icur,
>  	struct xfs_btree_cur	**curp,
>  	struct xfs_bmbt_irec	*new,
>  	xfs_fsblock_t		*first,
> @@ -2679,8 +2669,6 @@ xfs_bmap_add_extent_hole_real(
>  	int			state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_bmbt_irec	old;
>  
> -	ASSERT(*idx >= 0);
> -	ASSERT(*idx <= xfs_iext_count(ifp));
>  	ASSERT(!isnullstartblock(new->br_startblock));
>  	ASSERT(!cur || !(cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
>  
> @@ -2689,9 +2677,8 @@ xfs_bmap_add_extent_hole_real(
>  	/*
>  	 * Check and set flags if this segment has a left neighbor.
>  	 */
> -	if (*idx > 0) {
> +	if (xfs_iext_peek_prev_extent(ifp, icur, &left)) {
>  		state |= BMAP_LEFT_VALID;
> -		xfs_iext_get_extent(ifp, *idx - 1, &left);
>  		if (isnullstartblock(left.br_startblock))
>  			state |= BMAP_LEFT_DELAY;
>  	}
> @@ -2700,9 +2687,8 @@ xfs_bmap_add_extent_hole_real(
>  	 * Check and set flags if this segment has a current value.
>  	 * Not true if we're inserting into the "hole" at eof.
>  	 */
> -	if (*idx < xfs_iext_count(ifp)) {
> +	if (xfs_iext_get_extent(ifp, icur, &right)) {
>  		state |= BMAP_RIGHT_VALID;
> -		xfs_iext_get_extent(ifp, *idx, &right);
>  		if (isnullstartblock(right.br_startblock))
>  			state |= BMAP_RIGHT_DELAY;
>  	}
> @@ -2741,9 +2727,9 @@ xfs_bmap_add_extent_hole_real(
>  		 */
>  		left.br_blockcount += new->br_blockcount + right.br_blockcount;
>  
> -		xfs_iext_remove(ip, *idx, 1, state);
> -		--*idx;
> -		xfs_iext_update_extent(ip, state, *idx, &left);
> +		xfs_iext_remove(ip, icur, 1, state);
> +		xfs_iext_prev(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &left);
>  
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> @@ -2778,8 +2764,8 @@ xfs_bmap_add_extent_hole_real(
>  		old = left;
>  		left.br_blockcount += new->br_blockcount;
>  
> -		--*idx;
> -		xfs_iext_update_extent(ip, state, *idx, &left);
> +		xfs_iext_prev(ifp, icur);
> +		xfs_iext_update_extent(ip, state, icur, &left);
>  
>  		if (cur == NULL) {
>  			rval = xfs_ilog_fext(whichfork);
> @@ -2806,7 +2792,7 @@ xfs_bmap_add_extent_hole_real(
>  		right.br_startoff = new->br_startoff;
>  		right.br_startblock = new->br_startblock;
>  		right.br_blockcount += new->br_blockcount;
> -		xfs_iext_update_extent(ip, state, *idx, &right);
> +		xfs_iext_update_extent(ip, state, icur, &right);
>  
>  		if (cur == NULL) {
>  			rval = xfs_ilog_fext(whichfork);
> @@ -2828,7 +2814,7 @@ xfs_bmap_add_extent_hole_real(
>  		 * real allocation.
>  		 * Insert a new entry.
>  		 */
> -		xfs_iext_insert(ip, *idx, 1, new, state);
> +		xfs_iext_insert(ip, icur, 1, new, state);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
>  		if (cur == NULL) {
> @@ -3778,7 +3764,7 @@ xfs_bmapi_read(
>  	struct xfs_bmbt_irec	got;
>  	xfs_fileoff_t		obno;
>  	xfs_fileoff_t		end;
> -	xfs_extnum_t		idx;
> +	struct xfs_iext_cursor	icur;
>  	int			error;
>  	bool			eof = false;
>  	int			n = 0;
> @@ -3820,7 +3806,7 @@ xfs_bmapi_read(
>  			return error;
>  	}
>  
> -	if (!xfs_iext_lookup_extent(ip, ifp, bno, &idx, &got))
> +	if (!xfs_iext_lookup_extent(ip, ifp, bno, &icur, &got))
>  		eof = true;
>  	end = bno + len;
>  	obno = bno;
> @@ -3852,7 +3838,7 @@ xfs_bmapi_read(
>  			break;
>  
>  		/* Else go on to the next record. */
> -		if (!xfs_iext_get_extent(ifp, ++idx, &got))
> +		if (!xfs_iext_next_extent(ifp, &icur, &got))
>  			eof = true;
>  	}
>  	*nmap = n;
> @@ -3880,7 +3866,7 @@ xfs_bmapi_reserve_delalloc(
>  	xfs_filblks_t		len,
>  	xfs_filblks_t		prealloc,
>  	struct xfs_bmbt_irec	*got,
> -	xfs_extnum_t		*lastx,
> +	struct xfs_iext_cursor	*icur,
>  	int			eof)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -3910,7 +3896,7 @@ xfs_bmapi_reserve_delalloc(
>  	if (extsz) {
>  		struct xfs_bmbt_irec	prev;
>  
> -		if (!xfs_iext_get_extent(ifp, *lastx - 1, &prev))
> +		if (!xfs_iext_peek_prev_extent(ifp, icur, &prev))
>  			prev.br_startoff = NULLFILEOFF;
>  
>  		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, rt, eof,
> @@ -3959,7 +3945,7 @@ xfs_bmapi_reserve_delalloc(
>  	got->br_blockcount = alen;
>  	got->br_state = XFS_EXT_NORM;
>  
> -	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
> +	xfs_bmap_add_extent_hole_delay(ip, whichfork, icur, got);
>  
>  	/*
>  	 * Tag the inode if blocks were preallocated. Note that COW fork
> @@ -4004,8 +3990,7 @@ xfs_bmapi_allocate(
>  	if (bma->wasdel) {
>  		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
>  		bma->offset = bma->got.br_startoff;
> -		if (bma->idx)
> -			xfs_iext_get_extent(ifp, bma->idx - 1, &bma->prev);
> +		xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev);
>  	} else {
>  		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
>  		if (!bma->eof)
> @@ -4090,7 +4075,7 @@ xfs_bmapi_allocate(
>  		error = xfs_bmap_add_extent_delay_real(bma, whichfork);
>  	else
>  		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
> -				whichfork, &bma->idx, &bma->cur, &bma->got,
> +				whichfork, &bma->icur, &bma->cur, &bma->got,
>  				bma->firstblock, bma->dfops, &bma->logflags);
>  
>  	bma->logflags |= tmp_logflags;
> @@ -4102,7 +4087,7 @@ xfs_bmapi_allocate(
>  	 * or xfs_bmap_add_extent_hole_real might have merged it into one of
>  	 * the neighbouring ones.
>  	 */
> -	xfs_iext_get_extent(ifp, bma->idx, &bma->got);
> +	xfs_iext_get_extent(ifp, &bma->icur, &bma->got);
>  
>  	ASSERT(bma->got.br_startoff <= bma->offset);
>  	ASSERT(bma->got.br_startoff + bma->got.br_blockcount >=
> @@ -4160,8 +4145,8 @@ xfs_bmapi_convert_unwritten(
>  	}
>  
>  	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, whichfork,
> -			&bma->idx, &bma->cur, mval, bma->firstblock, bma->dfops,
> -			&tmp_logflags);
> +			&bma->icur, &bma->cur, mval, bma->firstblock,
> +			bma->dfops, &tmp_logflags);
>  	/*
>  	 * Log the inode core unconditionally in the unwritten extent conversion
>  	 * path because the conversion might not have done so (e.g., if the
> @@ -4183,7 +4168,7 @@ xfs_bmapi_convert_unwritten(
>  	 * xfs_bmap_add_extent_unwritten_real might have merged it into one
>  	 * of the neighbouring ones.
>  	 */
> -	xfs_iext_get_extent(ifp, bma->idx, &bma->got);
> +	xfs_iext_get_extent(ifp, &bma->icur, &bma->got);
>  
>  	/*
>  	 * We may have combined previously unwritten space with written space,
> @@ -4302,9 +4287,9 @@ xfs_bmapi_write(
>  	end = bno + len;
>  	obno = bno;
>  
> -	if (!xfs_iext_lookup_extent(ip, ifp, bno, &bma.idx, &bma.got))
> +	if (!xfs_iext_lookup_extent(ip, ifp, bno, &bma.icur, &bma.got))
>  		eof = true;
> -	if (!xfs_iext_get_extent(ifp, bma.idx - 1, &bma.prev))
> +	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
>  		bma.prev.br_startoff = NULLFILEOFF;
>  	bma.tp = tp;
>  	bma.ip = ip;
> @@ -4409,7 +4394,7 @@ xfs_bmapi_write(
>  
>  		/* Else go on to the next record. */
>  		bma.prev = bma.got;
> -		if (!xfs_iext_get_extent(ifp, ++bma.idx, &bma.got))
> +		if (!xfs_iext_next_extent(ifp, &bma.icur, &bma.got))
>  			eof = true;
>  	}
>  	*nmap = n;
> @@ -4482,7 +4467,7 @@ xfs_bmapi_remap(
>  	struct xfs_btree_cur	*cur = NULL;
>  	xfs_fsblock_t		firstblock = NULLFSBLOCK;
>  	struct xfs_bmbt_irec	got;
> -	xfs_extnum_t		idx;
> +	struct xfs_iext_cursor	icur;
>  	int			logflags = 0, error;
>  
>  	ASSERT(len > 0);
> @@ -4506,7 +4491,7 @@ xfs_bmapi_remap(
>  			return error;
>  	}
>  
> -	if (xfs_iext_lookup_extent(ip, ifp, bno, &idx, &got)) {
> +	if (xfs_iext_lookup_extent(ip, ifp, bno, &icur, &got)) {
>  		/* make sure we only reflink into a hole. */
>  		ASSERT(got.br_startoff > bno);
>  		ASSERT(got.br_startoff - bno >= len);
> @@ -4527,8 +4512,8 @@ xfs_bmapi_remap(
>  	got.br_blockcount = len;
>  	got.br_state = XFS_EXT_NORM;
>  
> -	error = xfs_bmap_add_extent_hole_real(tp, ip, XFS_DATA_FORK, &idx, &cur,
> -			&got, &firstblock, dfops, &logflags);
> +	error = xfs_bmap_add_extent_hole_real(tp, ip, XFS_DATA_FORK, &icur,
> +			&cur, &got, &firstblock, dfops, &logflags);
>  	if (error)
>  		goto error0;
>  
> @@ -4644,7 +4629,7 @@ int
>  xfs_bmap_del_extent_delay(
>  	struct xfs_inode	*ip,
>  	int			whichfork,
> -	xfs_extnum_t		*idx,
> +	struct xfs_iext_cursor	*icur,
>  	struct xfs_bmbt_irec	*got,
>  	struct xfs_bmbt_irec	*del)
>  {
> @@ -4666,8 +4651,6 @@ xfs_bmap_del_extent_delay(
>  	da_old = startblockval(got->br_startblock);
>  	da_new = 0;
>  
> -	ASSERT(*idx >= 0);
> -	ASSERT(*idx <= xfs_iext_count(ifp));
>  	ASSERT(del->br_blockcount > 0);
>  	ASSERT(got->br_startoff <= del->br_startoff);
>  	ASSERT(got_endoff >= del_endoff);
> @@ -4701,8 +4684,8 @@ xfs_bmap_del_extent_delay(
>  		/*
>  		 * Matches the whole extent.  Delete the entry.
>  		 */
> -		xfs_iext_remove(ip, *idx, 1, state);
> -		--*idx;
> +		xfs_iext_remove(ip, icur, 1, state);
> +		xfs_iext_prev(ifp, icur);
>  		break;
>  	case BMAP_LEFT_FILLING:
>  		/*
> @@ -4713,7 +4696,7 @@ xfs_bmap_del_extent_delay(
>  		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip,
>  				got->br_blockcount), da_old);
>  		got->br_startblock = nullstartblock((int)da_new);
> -		xfs_iext_update_extent(ip, state, *idx, got);
> +		xfs_iext_update_extent(ip, state, icur, got);
>  		break;
>  	case BMAP_RIGHT_FILLING:
>  		/*
> @@ -4723,7 +4706,7 @@ xfs_bmap_del_extent_delay(
>  		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip,
>  				got->br_blockcount), da_old);
>  		got->br_startblock = nullstartblock((int)da_new);
> -		xfs_iext_update_extent(ip, state, *idx, got);
> +		xfs_iext_update_extent(ip, state, icur, got);
>  		break;
>  	case 0:
>  		/*
> @@ -4751,9 +4734,9 @@ xfs_bmap_del_extent_delay(
>  		new.br_state = got->br_state;
>  		new.br_startblock = nullstartblock((int)new_indlen);
>  
> -		xfs_iext_update_extent(ip, state, *idx, got);
> -		++*idx;
> -		xfs_iext_insert(ip, *idx, 1, &new, state);
> +		xfs_iext_update_extent(ip, state, icur, got);
> +		xfs_iext_next(ifp, icur);
> +		xfs_iext_insert(ip, icur, 1, &new, state);
>  
>  		da_new = got_indlen + new_indlen - stolen;
>  		del->br_blockcount -= stolen;
> @@ -4772,7 +4755,7 @@ xfs_bmap_del_extent_delay(
>  void
>  xfs_bmap_del_extent_cow(
>  	struct xfs_inode	*ip,
> -	xfs_extnum_t		*idx,
> +	struct xfs_iext_cursor	*icur,
>  	struct xfs_bmbt_irec	*got,
>  	struct xfs_bmbt_irec	*del)
>  {
> @@ -4787,8 +4770,6 @@ xfs_bmap_del_extent_cow(
>  	del_endoff = del->br_startoff + del->br_blockcount;
>  	got_endoff = got->br_startoff + got->br_blockcount;
>  
> -	ASSERT(*idx >= 0);
> -	ASSERT(*idx <= xfs_iext_count(ifp));
>  	ASSERT(del->br_blockcount > 0);
>  	ASSERT(got->br_startoff <= del->br_startoff);
>  	ASSERT(got_endoff >= del_endoff);
> @@ -4804,8 +4785,8 @@ xfs_bmap_del_extent_cow(
>  		/*
>  		 * Matches the whole extent.  Delete the entry.
>  		 */
> -		xfs_iext_remove(ip, *idx, 1, state);
> -		--*idx;
> +		xfs_iext_remove(ip, icur, 1, state);
> +		xfs_iext_prev(ifp, icur);
>  		break;
>  	case BMAP_LEFT_FILLING:
>  		/*
> @@ -4814,14 +4795,14 @@ xfs_bmap_del_extent_cow(
>  		got->br_startoff = del_endoff;
>  		got->br_blockcount -= del->br_blockcount;
>  		got->br_startblock = del->br_startblock + del->br_blockcount;
> -		xfs_iext_update_extent(ip, state, *idx, got);
> +		xfs_iext_update_extent(ip, state, icur, got);
>  		break;
>  	case BMAP_RIGHT_FILLING:
>  		/*
>  		 * Deleting the last part of the extent.
>  		 */
>  		got->br_blockcount -= del->br_blockcount;
> -		xfs_iext_update_extent(ip, state, *idx, got);
> +		xfs_iext_update_extent(ip, state, icur, got);
>  		break;
>  	case 0:
>  		/*
> @@ -4834,9 +4815,9 @@ xfs_bmap_del_extent_cow(
>  		new.br_state = got->br_state;
>  		new.br_startblock = del->br_startblock + del->br_blockcount;
>  
> -		xfs_iext_update_extent(ip, state, *idx, got);
> -		++*idx;
> -		xfs_iext_insert(ip, *idx, 1, &new, state);
> +		xfs_iext_update_extent(ip, state, icur, got);
> +		xfs_iext_next(ifp, icur);
> +		xfs_iext_insert(ip, icur, 1, &new, state);
>  		break;
>  	}
>  }
> @@ -4849,7 +4830,7 @@ STATIC int				/* error */
>  xfs_bmap_del_extent_real(
>  	xfs_inode_t		*ip,	/* incore inode pointer */
>  	xfs_trans_t		*tp,	/* current transaction pointer */
> -	xfs_extnum_t		*idx,	/* extent number to update/delete */
> +	struct xfs_iext_cursor	*icur,
>  	struct xfs_defer_ops	*dfops,	/* list of extents to be freed */
>  	xfs_btree_cur_t		*cur,	/* if null, not a btree */
>  	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
> @@ -4878,9 +4859,8 @@ xfs_bmap_del_extent_real(
>  	XFS_STATS_INC(mp, xs_del_exlist);
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	ASSERT((*idx >= 0) && (*idx < xfs_iext_count(ifp)));
>  	ASSERT(del->br_blockcount > 0);
> -	xfs_iext_get_extent(ifp, *idx, &got);
> +	xfs_iext_get_extent(ifp, icur, &got);
>  	ASSERT(got.br_startoff <= del->br_startoff);
>  	del_endoff = del->br_startoff + del->br_blockcount;
>  	got_endoff = got.br_startoff + got.br_blockcount;
> @@ -4945,9 +4925,8 @@ xfs_bmap_del_extent_real(
>  		/*
>  		 * Matches the whole extent.  Delete the entry.
>  		 */
> -		xfs_iext_remove(ip, *idx, 1, state);
> -		--*idx;
> -
> +		xfs_iext_remove(ip, icur, 1, state);
> +		xfs_iext_prev(ifp, icur);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>  		flags |= XFS_ILOG_CORE;
> @@ -4966,7 +4945,7 @@ xfs_bmap_del_extent_real(
>  		got.br_startoff = del_endoff;
>  		got.br_startblock = del_endblock;
>  		got.br_blockcount -= del->br_blockcount;
> -		xfs_iext_update_extent(ip, state, *idx, &got);
> +		xfs_iext_update_extent(ip, state, icur, &got);
>  		if (!cur) {
>  			flags |= xfs_ilog_fext(whichfork);
>  			break;
> @@ -4980,7 +4959,7 @@ xfs_bmap_del_extent_real(
>  		 * Deleting the last part of the extent.
>  		 */
>  		got.br_blockcount -= del->br_blockcount;
> -		xfs_iext_update_extent(ip, state, *idx, &got);
> +		xfs_iext_update_extent(ip, state, icur, &got);
>  		if (!cur) {
>  			flags |= xfs_ilog_fext(whichfork);
>  			break;
> @@ -4996,7 +4975,7 @@ xfs_bmap_del_extent_real(
>  		old = got;
>  
>  		got.br_blockcount = del->br_startoff - got.br_startoff;
> -		xfs_iext_update_extent(ip, state, *idx, &got);
> +		xfs_iext_update_extent(ip, state, icur, &got);
>  
>  		new.br_startoff = del_endoff;
>  		new.br_blockcount = got_endoff - del_endoff;
> @@ -5040,7 +5019,7 @@ xfs_bmap_del_extent_real(
>  				 * Reset the extent record back
>  				 * to the original value.
>  				 */
> -				xfs_iext_update_extent(ip, state, *idx, &old);
> +				xfs_iext_update_extent(ip, state, icur, &old);
>  				flags = 0;
>  				error = -ENOSPC;
>  				goto done;
> @@ -5050,8 +5029,8 @@ xfs_bmap_del_extent_real(
>  			flags |= xfs_ilog_fext(whichfork);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
> -		++*idx;
> -		xfs_iext_insert(ip, *idx, 1, &new, state);
> +		xfs_iext_next(ifp, icur);
> +		xfs_iext_insert(ip, icur, 1, &new, state);
>  		break;
>  	}
>  
> @@ -5114,7 +5093,6 @@ __xfs_bunmapi(
>  	xfs_bmbt_irec_t		got;		/* current extent record */
>  	xfs_ifork_t		*ifp;		/* inode fork pointer */
>  	int			isrt;		/* freeing in rt area */
> -	xfs_extnum_t		lastx;		/* last extent index used */
>  	int			logflags;	/* transaction logging flags */
>  	xfs_extlen_t		mod;		/* rt extent offset */
>  	xfs_mount_t		*mp;		/* mount structure */
> @@ -5126,6 +5104,8 @@ __xfs_bunmapi(
>  	xfs_fileoff_t		max_len;
>  	xfs_agnumber_t		prev_agno = NULLAGNUMBER, agno;
>  	xfs_fileoff_t		end;
> +	struct xfs_iext_cursor	icur;
> +	bool			done = false;
>  
>  	trace_xfs_bunmap(ip, start, len, flags, _RET_IP_);
>  
> @@ -5168,7 +5148,7 @@ __xfs_bunmapi(
>  	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
>  	end = start + len;
>  
> -	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &lastx, &got)) {
> +	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &icur, &got)) {
>  		*rlen = 0;
>  		return 0;
>  	}
> @@ -5195,16 +5175,16 @@ __xfs_bunmapi(
>  	}
>  
>  	extno = 0;
> -	while (end != (xfs_fileoff_t)-1 && end >= start && lastx >= 0 &&
> +	while (end != (xfs_fileoff_t)-1 && end >= start &&
>  	       (nexts == 0 || extno < nexts) && max_len > 0) {
>  		/*
>  		 * Is the found extent after a hole in which end lives?
>  		 * Just back up to the previous extent, if so.
>  		 */
> -		if (got.br_startoff > end) {
> -			if (--lastx < 0)
> -				break;
> -			xfs_iext_get_extent(ifp, lastx, &got);
> +		if (got.br_startoff > end &&
> +		    !xfs_iext_prev_extent(ifp, &icur, &got)) {
> +			done = true;
> +			break;
>  		}
>  		/*
>  		 * Is the last block of this extent before the range
> @@ -5267,10 +5247,10 @@ __xfs_bunmapi(
>  				ASSERT(end >= mod);
>  				end -= mod > del.br_blockcount ?
>  					del.br_blockcount : mod;
> -				if (end < got.br_startoff) {
> -					if (--lastx >= 0)
> -						xfs_iext_get_extent(ifp, lastx,
> -								&got);
> +				if (end < got.br_startoff &&
> +				    !xfs_iext_prev_extent(ifp, &icur, &got)) {
> +					done = true;
> +					break;
>  				}
>  				continue;
>  			}
> @@ -5291,7 +5271,7 @@ __xfs_bunmapi(
>  			}
>  			del.br_state = XFS_EXT_UNWRITTEN;
>  			error = xfs_bmap_add_extent_unwritten_real(tp, ip,
> -					whichfork, &lastx, &cur, &del,
> +					whichfork, &icur, &cur, &del,
>  					firstblock, dfops, &logflags);
>  			if (error)
>  				goto error0;
> @@ -5318,8 +5298,11 @@ __xfs_bunmapi(
>  				 */
>  				ASSERT(end >= del.br_blockcount);
>  				end -= del.br_blockcount;
> -				if (got.br_startoff > end && --lastx >= 0)
> -					xfs_iext_get_extent(ifp, lastx, &got);
> +				if (got.br_startoff > end &&
> +				    !xfs_iext_prev_extent(ifp, &icur, &got)) {
> +					done = true;
> +					break;
> +				}
>  				continue;
>  			} else if (del.br_state == XFS_EXT_UNWRITTEN) {
>  				struct xfs_bmbt_irec	prev;
> @@ -5330,8 +5313,8 @@ __xfs_bunmapi(
>  				 * Unwrite the killed part of that one and
>  				 * try again.
>  				 */
> -				ASSERT(lastx > 0);
> -				xfs_iext_get_extent(ifp, lastx - 1, &prev);
> +				if (!xfs_iext_prev_extent(ifp, &icur, &prev))
> +					ASSERT(0);
>  				ASSERT(prev.br_state == XFS_EXT_NORM);
>  				ASSERT(!isnullstartblock(prev.br_startblock));
>  				ASSERT(del.br_startblock ==
> @@ -5343,9 +5326,8 @@ __xfs_bunmapi(
>  					prev.br_startoff = start;
>  				}
>  				prev.br_state = XFS_EXT_UNWRITTEN;
> -				lastx--;
>  				error = xfs_bmap_add_extent_unwritten_real(tp,
> -						ip, whichfork, &lastx, &cur,
> +						ip, whichfork, &icur, &cur,
>  						&prev, firstblock, dfops,
>  						&logflags);
>  				if (error)
> @@ -5355,7 +5337,7 @@ __xfs_bunmapi(
>  				ASSERT(del.br_state == XFS_EXT_NORM);
>  				del.br_state = XFS_EXT_UNWRITTEN;
>  				error = xfs_bmap_add_extent_unwritten_real(tp,
> -						ip, whichfork, &lastx, &cur,
> +						ip, whichfork, &icur, &cur,
>  						&del, firstblock, dfops,
>  						&logflags);
>  				if (error)
> @@ -5365,10 +5347,10 @@ __xfs_bunmapi(
>  		}
>  
>  		if (wasdel) {
> -			error = xfs_bmap_del_extent_delay(ip, whichfork, &lastx,
> +			error = xfs_bmap_del_extent_delay(ip, whichfork, &icur,
>  					&got, &del);
>  		} else {
> -			error = xfs_bmap_del_extent_real(ip, tp, &lastx, dfops,
> +			error = xfs_bmap_del_extent_real(ip, tp, &icur, dfops,
>  					cur, &del, &tmp_logflags, whichfork,
>  					flags);
>  			logflags |= tmp_logflags;
> @@ -5384,15 +5366,16 @@ __xfs_bunmapi(
>  		 * If not done go on to the next (previous) record.
>  		 */
>  		if (end != (xfs_fileoff_t)-1 && end >= start) {
> -			if (lastx >= 0) {
> -				xfs_iext_get_extent(ifp, lastx, &got);
> -				if (got.br_startoff > end && --lastx >= 0)
> -					xfs_iext_get_extent(ifp, lastx, &got);
> +			if (!xfs_iext_get_extent(ifp, &icur, &got) ||
> +			    (got.br_startoff > end &&
> +			     !xfs_iext_prev_extent(ifp, &icur, &got))) {
> +				done = true;
> +				break;
>  			}
>  			extno++;
>  		}
>  	}
> -	if (end == (xfs_fileoff_t)-1 || end < start || lastx < 0)
> +	if (done || end == (xfs_fileoff_t)-1 || end < start)
>  		*rlen = 0;
>  	else
>  		*rlen = end - start + 1;
> @@ -5513,7 +5496,7 @@ xfs_bmse_merge(
>  	struct xfs_inode		*ip,
>  	int				whichfork,
>  	xfs_fileoff_t			shift,		/* shift fsb */
> -	int				*current_ext,	/* idx of gotp */
> +	struct xfs_iext_cursor		*icur,
>  	struct xfs_bmbt_irec		*got,		/* extent to shift */
>  	struct xfs_bmbt_irec		*left,		/* preceding extent */
>  	struct xfs_btree_cur		*cur,
> @@ -5568,10 +5551,10 @@ xfs_bmse_merge(
>  		return error;
>  
>  done:
> -	xfs_iext_remove(ip, *current_ext, 1, 0);
> -	--*current_ext;
> -	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork),
> -			*current_ext, &new);
> +	xfs_iext_remove(ip, icur, 1, 0);
> +	xfs_iext_prev(XFS_IFORK_PTR(ip, whichfork), icur);
> +	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), icur,
> +			&new);
>  
>  	/* update reverse mapping. rmap functions merge the rmaps for us */
>  	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
> @@ -5586,7 +5569,7 @@ static int
>  xfs_bmap_shift_update_extent(
>  	struct xfs_inode	*ip,
>  	int			whichfork,
> -	xfs_extnum_t		idx,
> +	struct xfs_iext_cursor	*icur,
>  	struct xfs_bmbt_irec	*got,
>  	struct xfs_btree_cur	*cur,
>  	int			*logflags,
> @@ -5614,7 +5597,8 @@ xfs_bmap_shift_update_extent(
>  		*logflags |= XFS_ILOG_DEXT;
>  	}
>  
> -	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), idx, got);
> +	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), icur,
> +			got);
>  
>  	/* update reverse mapping */
>  	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, &prev);
> @@ -5639,7 +5623,7 @@ xfs_bmap_collapse_extents(
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	struct xfs_btree_cur	*cur = NULL;
>  	struct xfs_bmbt_irec	got, prev;
> -	xfs_extnum_t		current_ext;
> +	struct xfs_iext_cursor	icur;
>  	xfs_fileoff_t		new_startoff;
>  	int			error = 0;
>  	int			logflags = 0;
> @@ -5670,14 +5654,14 @@ xfs_bmap_collapse_extents(
>  		cur->bc_private.b.flags = 0;
>  	}
>  
> -	if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &current_ext, &got)) {
> +	if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &icur, &got)) {
>  		*done = true;
>  		goto del_cursor;
>  	}
>  	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
>  
>  	new_startoff = got.br_startoff - offset_shift_fsb;
> -	if (xfs_iext_get_extent(ifp, current_ext - 1, &prev)) {
> +	if (xfs_iext_peek_prev_extent(ifp, &icur, &prev)) {
>  		if (new_startoff < prev.br_startoff + prev.br_blockcount) {
>  			error = -EINVAL;
>  			goto del_cursor;
> @@ -5685,8 +5669,8 @@ xfs_bmap_collapse_extents(
>  
>  		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
>  			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> -					&current_ext, &got, &prev, cur,
> -					&logflags, dfops);
> +					&icur, &got, &prev, cur, &logflags,
> +					dfops);
>  			if (error)
>  				goto del_cursor;
>  			goto done;
> @@ -5698,15 +5682,15 @@ xfs_bmap_collapse_extents(
>  		}
>  	}
>  
> -	error = xfs_bmap_shift_update_extent(ip, whichfork, current_ext, &got,
> -			cur, &logflags, dfops, new_startoff);
> +	error = xfs_bmap_shift_update_extent(ip, whichfork, &icur, &got, cur,
> +			&logflags, dfops, new_startoff);
>  	if (error)
>  		goto del_cursor;
>  
>  done:
> -	if (!xfs_iext_get_extent(ifp, ++current_ext, &got)) {
> -		 *done = true;
> -		 goto del_cursor;
> +	if (!xfs_iext_next_extent(ifp, &icur, &got)) {
> +		*done = true;
> +		goto del_cursor;
>  	}
>  
>  	*next_fsb = got.br_startoff;
> @@ -5735,7 +5719,7 @@ xfs_bmap_insert_extents(
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	struct xfs_btree_cur	*cur = NULL;
>  	struct xfs_bmbt_irec	got, next;
> -	xfs_extnum_t		current_ext;
> +	struct xfs_iext_cursor	icur;
>  	xfs_fileoff_t		new_startoff;
>  	int			error = 0;
>  	int			logflags = 0;
> @@ -5767,15 +5751,14 @@ xfs_bmap_insert_extents(
>  	}
>  
>  	if (*next_fsb == NULLFSBLOCK) {
> -		current_ext = xfs_iext_count(ifp) - 1;
> -		if (!xfs_iext_get_extent(ifp, current_ext, &got) ||
> +		xfs_iext_last(ifp, &icur);
> +		if (!xfs_iext_get_extent(ifp, &icur, &got) ||
>  		    stop_fsb > got.br_startoff) {
>  			*done = true;
>  			goto del_cursor;
>  		}
>  	} else {
> -		if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &current_ext,
> -				&got)) {
> +		if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &icur, &got)) {
>  			*done = true;
>  			goto del_cursor;
>  		}
> @@ -5788,7 +5771,7 @@ xfs_bmap_insert_extents(
>  	}
>  
>  	new_startoff = got.br_startoff + offset_shift_fsb;
> -	if (xfs_iext_get_extent(ifp, current_ext + 1, &next)) {
> +	if (xfs_iext_peek_next_extent(ifp, &icur, &next)) {
>  		if (new_startoff + got.br_blockcount > next.br_startoff) {
>  			error = -EINVAL;
>  			goto del_cursor;
> @@ -5804,12 +5787,12 @@ xfs_bmap_insert_extents(
>  			WARN_ON_ONCE(1);
>  	}
>  
> -	error = xfs_bmap_shift_update_extent(ip, whichfork, current_ext, &got,
> -			cur, &logflags, dfops, new_startoff);
> +	error = xfs_bmap_shift_update_extent(ip, whichfork, &icur, &got, cur,
> +			&logflags, dfops, new_startoff);
>  	if (error)
>  		goto del_cursor;
>  
> -	if (!xfs_iext_get_extent(ifp, --current_ext, &got) ||
> +	if (!xfs_iext_prev_extent(ifp, &icur, &got) ||
>  	    stop_fsb >= got.br_startoff + got.br_blockcount) {
>  		*done = true;
>  		goto del_cursor;
> @@ -5826,10 +5809,10 @@ xfs_bmap_insert_extents(
>  }
>  
>  /*
> - * Splits an extent into two extents at split_fsb block such that it is
> - * the first block of the current_ext. @current_ext is a target extent
> - * to be split. @split_fsb is a block where the extents is split.
> - * If split_fsb lies in a hole or the first block of extents, just return 0.
> + * Splits an extent into two extents at split_fsb block such that it is the
> + * first block of the current_ext. @ext is a target extent to be split.
> + * @split_fsb is a block where the extents is split.  If split_fsb lies in a
> + * hole or the first block of extents, just return 0.
>   */
>  STATIC int
>  xfs_bmap_split_extent_at(
> @@ -5846,7 +5829,7 @@ xfs_bmap_split_extent_at(
>  	struct xfs_mount		*mp = ip->i_mount;
>  	struct xfs_ifork		*ifp;
>  	xfs_fsblock_t			gotblkcnt; /* new block count for got */
> -	xfs_extnum_t			current_ext;
> +	struct xfs_iext_cursor		icur;
>  	int				error = 0;
>  	int				logflags = 0;
>  	int				i = 0;
> @@ -5874,7 +5857,7 @@ xfs_bmap_split_extent_at(
>  	/*
>  	 * If there are not extents, or split_fsb lies in a hole we are done.
>  	 */
> -	if (!xfs_iext_lookup_extent(ip, ifp, split_fsb, &current_ext, &got) ||
> +	if (!xfs_iext_lookup_extent(ip, ifp, split_fsb, &icur, &got) ||
>  	    got.br_startoff >= split_fsb)
>  		return 0;
>  
> @@ -5896,8 +5879,8 @@ xfs_bmap_split_extent_at(
>  	}
>  
>  	got.br_blockcount = gotblkcnt;
> -	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork),
> -			current_ext, &got);
> +	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), &icur,
> +			&got);
>  
>  	logflags = XFS_ILOG_CORE;
>  	if (cur) {
> @@ -5908,8 +5891,8 @@ xfs_bmap_split_extent_at(
>  		logflags |= XFS_ILOG_DEXT;
>  
>  	/* Add new extent */
> -	current_ext++;
> -	xfs_iext_insert(ip, current_ext, 1, &new, 0);
> +	xfs_iext_next(ifp, &icur);
> +	xfs_iext_insert(ip, &icur, 1, &new, 0);
>  	XFS_IFORK_NEXT_SET(ip, whichfork,
>  			   XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index a8777682ba57..b6a395949d0c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -43,7 +43,7 @@ struct xfs_bmalloca {
>  	xfs_fsblock_t		blkno;	/* starting block of new extent */
>  
>  	struct xfs_btree_cur	*cur;	/* btree cursor */
> -	xfs_extnum_t		idx;	/* current extent index */
> +	struct xfs_iext_cursor	icur;	/* incore extent cursor */
>  	int			nallocs;/* number of extents alloc'd */
>  	int			logflags;/* flags for transaction logging */
>  
> @@ -216,10 +216,11 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
>  		struct xfs_defer_ops *dfops, int *done);
>  int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
> -		xfs_extnum_t *idx, struct xfs_bmbt_irec *got,
> +		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
> +		struct xfs_bmbt_irec *del);
> +void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
> +		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
>  		struct xfs_bmbt_irec *del);
> -void	xfs_bmap_del_extent_cow(struct xfs_inode *ip, xfs_extnum_t *idx,
> -		struct xfs_bmbt_irec *got, struct xfs_bmbt_irec *del);
>  uint	xfs_default_attroffset(struct xfs_inode *ip);
>  int	xfs_bmap_collapse_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
> @@ -232,7 +233,8 @@ int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
>  int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
>  		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
> -		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof);
> +		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
> +		int eof);
>  
>  enum xfs_bmap_intent_type {
>  	XFS_BMAP_MAP = 1,
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 7dd77b497fc2..1e28532ff551 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -343,6 +343,7 @@ xfs_iformat_extents(
>  	int			state = xfs_bmap_fork_to_state(whichfork);
>  	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
> +	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
>  	int			i;
>  
> @@ -369,16 +370,21 @@ xfs_iformat_extents(
>  	ifp->if_bytes = size;
>  	if (size) {
>  		dp = (xfs_bmbt_rec_t *) XFS_DFORK_PTR(dip, whichfork);
> +
> +		xfs_iext_first(ifp, &icur);
>  		for (i = 0; i < nex; i++, dp++) {
>  			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
> +
>  			if (!xfs_bmbt_validate_extent(mp, whichfork, dp)) {
>  				XFS_ERROR_REPORT("xfs_iformat_extents(2)",
>  						 XFS_ERRLEVEL_LOW, mp);
>  				return -EFSCORRUPTED;
>  			}
> +
>  			ep->l0 = get_unaligned_be64(&dp->l0);
>  			ep->l1 = get_unaligned_be64(&dp->l1);
> -			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
> +			trace_xfs_read_extent(ip, &icur, state, _THIS_IP_);
> +			xfs_iext_next(ifp, &icur);
>  		}
>  	}
>  	ifp->if_flags |= XFS_IFEXTENTS;
> @@ -739,17 +745,18 @@ xfs_iextents_copy(
>  {
>  	int			state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_irec	rec;
> -	int			copied = 0, i = 0;
> +	int			copied = 0;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  	ASSERT(ifp->if_bytes > 0);
>  
> -	while (xfs_iext_get_extent(ifp, i++, &rec)) {
> +	for_each_iext(ifp, &icur, &rec) {
>  		if (isnullstartblock(rec.br_startblock))
>  			continue;
>  		xfs_bmbt_disk_set_all(dp, &rec);
> -		trace_xfs_write_extent(ip, i, state, _RET_IP_);
> +		trace_xfs_write_extent(ip, &icur, state, _RET_IP_);
>  		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, dp));
>  		copied += sizeof(struct xfs_bmbt_rec);
>  		dp++;
> @@ -894,7 +901,7 @@ xfs_iext_state_to_fork(
>  void
>  xfs_iext_insert(
>  	xfs_inode_t	*ip,		/* incore inode pointer */
> -	xfs_extnum_t	idx,		/* starting index of new items */
> +	struct xfs_iext_cursor *cur,
>  	xfs_extnum_t	count,		/* number of inserted items */
>  	xfs_bmbt_irec_t	*new,		/* items to insert */
>  	int		state)		/* type of extent conversion */
> @@ -902,12 +909,12 @@ xfs_iext_insert(
>  	xfs_ifork_t	*ifp = xfs_iext_state_to_fork(ip, state);
>  	xfs_extnum_t	i;		/* extent record index */
>  
> -	trace_xfs_iext_insert(ip, idx, new, state, _RET_IP_);
> +	trace_xfs_iext_insert(ip, cur->idx, new, state, _RET_IP_);
>  
>  	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
> -	xfs_iext_add(ifp, idx, count);
> -	for (i = idx; i < idx + count; i++, new++)
> -		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, i), new);
> +	xfs_iext_add(ifp, cur->idx, count);
> +	for (i = 0; i < count; i++, new++)
> +		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, cur->idx + i), new);
>  }
>  
>  /*
> @@ -1145,7 +1152,7 @@ xfs_iext_add_indirect_multi(
>  void
>  xfs_iext_remove(
>  	xfs_inode_t	*ip,		/* incore inode pointer */
> -	xfs_extnum_t	idx,		/* index to begin removing exts */
> +	struct xfs_iext_cursor *cur,
>  	int		ext_diff,	/* number of extents to remove */
>  	int		state)		/* type of extent conversion */
>  {
> @@ -1153,7 +1160,7 @@ xfs_iext_remove(
>  	xfs_extnum_t	nextents;	/* number of extents in file */
>  	int		new_size;	/* size of extents after removal */
>  
> -	trace_xfs_iext_remove(ip, idx, state, _RET_IP_);
> +	trace_xfs_iext_remove(ip, cur, state, _RET_IP_);
>  
>  	ASSERT(ext_diff > 0);
>  	nextents = xfs_iext_count(ifp);
> @@ -1162,11 +1169,11 @@ xfs_iext_remove(
>  	if (new_size == 0) {
>  		xfs_iext_destroy(ifp);
>  	} else if (ifp->if_flags & XFS_IFEXTIREC) {
> -		xfs_iext_remove_indirect(ifp, idx, ext_diff);
> +		xfs_iext_remove_indirect(ifp, cur->idx, ext_diff);
>  	} else if (ifp->if_real_bytes) {
> -		xfs_iext_remove_direct(ifp, idx, ext_diff);
> +		xfs_iext_remove_direct(ifp, cur->idx, ext_diff);
>  	} else {
> -		xfs_iext_remove_inline(ifp, idx, ext_diff);
> +		xfs_iext_remove_inline(ifp, cur->idx, ext_diff);
>  	}
>  	ifp->if_bytes = new_size;
>  }
> @@ -1913,26 +1920,26 @@ xfs_ifork_init_cow(
>   * Lookup the extent covering bno.
>   *
>   * If there is an extent covering bno return the extent index, and store the
> - * expanded extent structure in *gotp, and the extent index in *idx.
> + * expanded extent structure in *gotp, and the extent cursor in *cur.
>   * If there is no extent covering bno, but there is an extent after it (e.g.
> - * it lies in a hole) return that extent in *gotp and its index in *idx
> + * it lies in a hole) return that extent in *gotp and its cursor in *cur
>   * instead.
> - * If bno is beyond the last extent return false, and return the index after
> - * the last valid index in *idxp.
> + * If bno is beyond the last extent return false, and return an invalid
> + * cursor value.
>   */
>  bool
>  xfs_iext_lookup_extent(
>  	struct xfs_inode	*ip,
>  	struct xfs_ifork	*ifp,
>  	xfs_fileoff_t		bno,
> -	xfs_extnum_t		*idxp,
> +	struct xfs_iext_cursor	*cur,
>  	struct xfs_bmbt_irec	*gotp)
>  {
>  	struct xfs_bmbt_rec_host *ep;
>  
>  	XFS_STATS_INC(ip->i_mount, xs_look_exlist);
>  
> -	ep = xfs_iext_bno_to_ext(ifp, bno, idxp);
> +	ep = xfs_iext_bno_to_ext(ifp, bno, &cur->idx);
>  	if (!ep)
>  		return false;
>  	xfs_bmbt_get_all(ep, gotp);
> @@ -1948,31 +1955,31 @@ xfs_iext_lookup_extent_before(
>  	struct xfs_inode	*ip,
>  	struct xfs_ifork	*ifp,
>  	xfs_fileoff_t		*end,
> -	xfs_extnum_t		*idxp,
> +	struct xfs_iext_cursor	*cur,
>  	struct xfs_bmbt_irec	*gotp)
>  {
> -	if (xfs_iext_lookup_extent(ip, ifp, *end - 1, idxp, gotp) &&
> +	if (xfs_iext_lookup_extent(ip, ifp, *end - 1, cur, gotp) &&
>  	    gotp->br_startoff <= *end - 1)
>  		return true;
> -	if (!xfs_iext_get_extent(ifp, --*idxp, gotp))
> +	if (!xfs_iext_prev_extent(ifp, cur, gotp))
>  		return false;
>  	*end = gotp->br_startoff + gotp->br_blockcount;
>  	return true;
>  }
>  
>  /*
> - * Return true if there is an extent at index idx, and return the expanded
> - * extent structure at idx in that case.  Else return false.
> + * Return true if the cursor points at an extent and return the extent structure
> + * in gotp.  Else return false.
>   */
>  bool
>  xfs_iext_get_extent(
>  	struct xfs_ifork	*ifp,
> -	xfs_extnum_t		idx,
> +	struct xfs_iext_cursor	*cur,
>  	struct xfs_bmbt_irec	*gotp)
>  {
> -	if (idx < 0 || idx >= xfs_iext_count(ifp))
> +	if (cur->idx < 0 || cur->idx >= xfs_iext_count(ifp))
>  		return false;
> -	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), gotp);
> +	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, cur->idx), gotp);
>  	return true;
>  }
>  
> @@ -1980,15 +1987,15 @@ void
>  xfs_iext_update_extent(
>  	struct xfs_inode	*ip,
>  	int			state,
> -	xfs_extnum_t		idx,
> +	struct xfs_iext_cursor	*cur,
>  	struct xfs_bmbt_irec	*gotp)
>  {
>  	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
>  
> -	ASSERT(idx >= 0);
> -	ASSERT(idx < xfs_iext_count(ifp));
> +	ASSERT(cur->idx >= 0);
> +	ASSERT(cur->idx < xfs_iext_count(ifp));
>  
> -	trace_xfs_bmap_pre_update(ip, idx, state, _RET_IP_);
> -	xfs_bmbt_set_all(xfs_iext_get_ext(ifp, idx), gotp);
> -	trace_xfs_bmap_post_update(ip, idx, state, _RET_IP_);
> +	trace_xfs_bmap_pre_update(ip, cur, state, _RET_IP_);
> +	xfs_bmbt_set_all(xfs_iext_get_ext(ifp, cur->idx), gotp);
> +	trace_xfs_bmap_post_update(ip, cur, state, _RET_IP_);
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 113fd42ec36d..7065544f446a 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -151,12 +151,13 @@ void		xfs_init_local_fork(struct xfs_inode *, int, const void *, int);
>  struct xfs_bmbt_rec_host *
>  		xfs_iext_get_ext(struct xfs_ifork *, xfs_extnum_t);
>  xfs_extnum_t	xfs_iext_count(struct xfs_ifork *);
> -void		xfs_iext_insert(struct xfs_inode *, xfs_extnum_t, xfs_extnum_t,
> -				struct xfs_bmbt_irec *, int);
> +void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
> +			xfs_extnum_t, struct xfs_bmbt_irec *, int);
>  void		xfs_iext_add(struct xfs_ifork *, xfs_extnum_t, int);
>  void		xfs_iext_add_indirect_multi(struct xfs_ifork *, int,
>  					    xfs_extnum_t, int);
> -void		xfs_iext_remove(struct xfs_inode *, xfs_extnum_t, int, int);
> +void		xfs_iext_remove(struct xfs_inode *, struct xfs_iext_cursor *,
> +			int, int);
>  void		xfs_iext_remove_inline(struct xfs_ifork *, xfs_extnum_t, int);
>  void		xfs_iext_remove_direct(struct xfs_ifork *, xfs_extnum_t, int);
>  void		xfs_iext_remove_indirect(struct xfs_ifork *, xfs_extnum_t, int);
> @@ -182,15 +183,85 @@ void		xfs_iext_irec_update_extoffs(struct xfs_ifork *, int, int);
>  
>  bool		xfs_iext_lookup_extent(struct xfs_inode *ip,
>  			struct xfs_ifork *ifp, xfs_fileoff_t bno,
> -			xfs_extnum_t *idxp, struct xfs_bmbt_irec *gotp);
> +			struct xfs_iext_cursor *cur,
> +			struct xfs_bmbt_irec *gotp);
>  bool		xfs_iext_lookup_extent_before(struct xfs_inode *ip,
>  			struct xfs_ifork *ifp, xfs_fileoff_t *end,
> -			xfs_extnum_t *idxp, struct xfs_bmbt_irec *gotp);
> -
> -bool		xfs_iext_get_extent(struct xfs_ifork *ifp, xfs_extnum_t idx,
> +			struct xfs_iext_cursor *cur,
> +			struct xfs_bmbt_irec *gotp);
> +bool		xfs_iext_get_extent(struct xfs_ifork *ifp,
> +			struct xfs_iext_cursor *cur,
>  			struct xfs_bmbt_irec *gotp);
>  void		xfs_iext_update_extent(struct xfs_inode *ip, int state,
> -			xfs_extnum_t idx, struct xfs_bmbt_irec *gotp);
> +			struct xfs_iext_cursor *cur,
> +			struct xfs_bmbt_irec *gotp);
> +
> +static inline void xfs_iext_first(struct xfs_ifork *ifp,
> +		struct xfs_iext_cursor *cur)
> +{
> +	cur->idx = 0;
> +}
> +
> +static inline void xfs_iext_last(struct xfs_ifork *ifp,
> +		struct xfs_iext_cursor *cur)
> +{
> +	cur->idx = xfs_iext_count(ifp) - 1;
> +}
> +
> +static inline void xfs_iext_next(struct xfs_ifork *ifp,
> +		struct xfs_iext_cursor *cur)
> +{
> +	cur->idx++;
> +}
> +
> +static inline void xfs_iext_prev(struct xfs_ifork *ifp,
> +		struct xfs_iext_cursor *cur)
> +{
> +	cur->idx--;
> +}
> +
> +static inline bool xfs_iext_next_extent(struct xfs_ifork *ifp,
> +		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *gotp)
> +{
> +	xfs_iext_next(ifp, cur);
> +	return xfs_iext_get_extent(ifp, cur, gotp);
> +}
> +
> +static inline bool xfs_iext_prev_extent(struct xfs_ifork *ifp,
> +		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *gotp)
> +{
> +	xfs_iext_prev(ifp, cur);
> +	return xfs_iext_get_extent(ifp, cur, gotp);
> +}
> +
> +/*
> + * Return the extent after cur in gotp without updating the cursor.
> + */
> +static inline bool xfs_iext_peek_next_extent(struct xfs_ifork *ifp,
> +		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *gotp)
> +{
> +	struct xfs_iext_cursor ncur = *cur;
> +
> +	xfs_iext_next(ifp, &ncur);
> +	return xfs_iext_get_extent(ifp, &ncur, gotp);
> +}
> +
> +/*
> + * Return the extent before cur in gotp without updating the cursor.
> + */
> +static inline bool xfs_iext_peek_prev_extent(struct xfs_ifork *ifp,
> +		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *gotp)
> +{
> +	struct xfs_iext_cursor ncur = *cur;
> +
> +	xfs_iext_prev(ifp, &ncur);
> +	return xfs_iext_get_extent(ifp, &ncur, gotp);
> +}
> +
> +#define for_each_iext(ifp, ext, got)			\
> +	for (xfs_iext_first((ifp), (ext));		\
> +	     xfs_iext_get_extent((ifp), (ext), (got));	\
> +	     xfs_iext_next((ifp), (ext)))
>  
>  extern struct kmem_zone	*xfs_ifork_zone;
>  
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index f04dbfb2f50d..5da6382bdaf1 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -142,5 +142,8 @@ typedef uint32_t	xfs_dqid_t;
>  #define	XFS_NBWORD	(1 << XFS_NBWORDLOG)
>  #define	XFS_WORDMASK	((1 << XFS_WORDLOG) - 1)
>  
> +struct xfs_iext_cursor {
> +	xfs_extnum_t		idx;
> +};
>  
>  #endif	/* __XFS_TYPES_H__ */
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 3c17b182616f..be0bc11b6594 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -237,7 +237,7 @@ xfs_scrub_bmap(
>  	struct xfs_inode		*ip = sc->ip;
>  	struct xfs_ifork		*ifp;
>  	xfs_fileoff_t			endoff;
> -	xfs_extnum_t			idx;
> +	struct xfs_iext_cursor		icur;
>  	bool				found;
>  	int				error = 0;
>  
> @@ -317,9 +317,9 @@ xfs_scrub_bmap(
>  	/* Scrub extent records. */
>  	info.lastoff = 0;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	for (found = xfs_iext_lookup_extent(ip, ifp, 0, &idx, &irec);
> +	for (found = xfs_iext_lookup_extent(ip, ifp, 0, &icur, &irec);
>  	     found != 0;
> -	     found = xfs_iext_get_extent(ifp, ++idx, &irec)) {
> +	     found = xfs_iext_next_extent(ifp, &icur, &irec)) {
>  		if (xfs_scrub_should_terminate(sc, &error))
>  			break;
>  		if (isnullstartblock(irec.br_startblock))
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index c61362faed4a..73ac795aa6a5 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -614,7 +614,7 @@ xfs_scrub_directory_blocks(
>  	xfs_fileoff_t			leaf_lblk;
>  	xfs_fileoff_t			free_lblk;
>  	xfs_fileoff_t			lblk;
> -	xfs_extnum_t			idx;
> +	struct xfs_iext_cursor		icur;
>  	xfs_dablk_t			dabno;
>  	bool				found;
>  	int				is_block = 0;
> @@ -639,7 +639,7 @@ xfs_scrub_directory_blocks(
>  		goto out;
>  
>  	/* Iterate all the data extents in the directory... */
> -	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
> +	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &icur, &got);
>  	while (found) {
>  		/* Block directories only have a single block at offset 0. */
>  		if (is_block &&
> @@ -676,17 +676,17 @@ xfs_scrub_directory_blocks(
>  		}
>  		dabno = got.br_startoff + got.br_blockcount;
>  		lblk = roundup(dabno, args.geo->fsbcount);
> -		found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
> +		found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &icur, &got);
>  	}
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		goto out;
>  
>  	/* Look for a leaf1 block, which has free info. */
> -	if (xfs_iext_lookup_extent(sc->ip, ifp, leaf_lblk, &idx, &got) &&
> +	if (xfs_iext_lookup_extent(sc->ip, ifp, leaf_lblk, &icur, &got) &&
>  	    got.br_startoff == leaf_lblk &&
>  	    got.br_blockcount == args.geo->fsbcount &&
> -	    !xfs_iext_get_extent(ifp, ++idx, &got)) {
> +	    !xfs_iext_next_extent(ifp, &icur, &got)) {
>  		if (is_block) {
>  			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  			goto out;
> @@ -702,7 +702,7 @@ xfs_scrub_directory_blocks(
>  
>  	/* Scan for free blocks */
>  	lblk = free_lblk;
> -	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
> +	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &icur, &got);
>  	while (found) {
>  		/*
>  		 * Dirs can't have blocks mapped above 2^32.
> @@ -740,7 +740,7 @@ xfs_scrub_directory_blocks(
>  		}
>  		dabno = got.br_startoff + got.br_blockcount;
>  		lblk = roundup(dabno, args.geo->fsbcount);
> -		found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
> +		found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &icur, &got);
>  	}
>  out:
>  	return error;
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 170b74c7f2d5..515eec004971 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -229,15 +229,17 @@ xfs_bmap_count_leaves(
>  	struct xfs_ifork	*ifp,
>  	xfs_filblks_t		*count)
>  {
> +	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_irec	got;
> -	xfs_extnum_t		numrecs = 0, i = 0;
> +	xfs_extnum_t		numrecs = 0;
>  
> -	while (xfs_iext_get_extent(ifp, i++, &got)) {
> +	for_each_iext(ifp, &icur, &got) {
>  		if (!isnullstartblock(got.br_startblock)) {
>  			*count += got.br_blockcount;
>  			numrecs++;
>  		}
>  	}
> +
>  	return numrecs;
>  }
>  
> @@ -525,7 +527,7 @@ xfs_getbmap(
>  	struct xfs_ifork	*ifp;
>  	struct xfs_bmbt_irec	got, rec;
>  	xfs_filblks_t		len;
> -	xfs_extnum_t		idx;
> +	struct xfs_iext_cursor	icur;
>  
>  	if (bmv->bmv_iflags & ~BMV_IF_VALID)
>  		return -EINVAL;
> @@ -629,7 +631,7 @@ xfs_getbmap(
>  			goto out_unlock_ilock;
>  	}
>  
> -	if (!xfs_iext_lookup_extent(ip, ifp, bno, &idx, &got)) {
> +	if (!xfs_iext_lookup_extent(ip, ifp, bno, &icur, &got)) {
>  		/*
>  		 * Report a whole-file hole if the delalloc flag is set to
>  		 * stay compatible with the old implementation.
> @@ -668,7 +670,7 @@ xfs_getbmap(
>  				goto out_unlock_ilock;
>  		} while (xfs_getbmap_next_rec(&rec, bno));
>  
> -		if (!xfs_iext_get_extent(ifp, ++idx, &got)) {
> +		if (!xfs_iext_next_extent(ifp, &icur, &got)) {
>  			xfs_fileoff_t	end = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
>  
>  			out[bmv->bmv_entries - 1].bmv_oflags |= BMV_OF_LAST;
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 238e3650a9d2..0c58918bc0ad 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -266,7 +266,7 @@ xfs_dir2_leaf_readbuf(
>  	xfs_dablk_t		next_ra;
>  	xfs_dablk_t		map_off;
>  	xfs_dablk_t		last_da;
> -	xfs_extnum_t		idx;
> +	struct xfs_iext_cursor	icur;
>  	int			ra_want;
>  	int			error = 0;
>  
> @@ -283,7 +283,7 @@ xfs_dir2_leaf_readbuf(
>  	 */
>  	last_da = xfs_dir2_byte_to_da(geo, XFS_DIR2_LEAF_OFFSET);
>  	map_off = xfs_dir2_db_to_da(geo, xfs_dir2_byte_to_db(geo, *cur_off));
> -	if (!xfs_iext_lookup_extent(dp, ifp, map_off, &idx, &map))
> +	if (!xfs_iext_lookup_extent(dp, ifp, map_off, &icur, &map))
>  		goto out;
>  	if (map.br_startoff >= last_da)
>  		goto out;
> @@ -311,7 +311,7 @@ xfs_dir2_leaf_readbuf(
>  	if (next_ra >= last_da)
>  		goto out_no_ra;
>  	if (map.br_blockcount < geo->fsbcount &&
> -	    !xfs_iext_get_extent(ifp, ++idx, &map))
> +	    !xfs_iext_next_extent(ifp, &icur, &map))
>  		goto out_no_ra;
>  	if (map.br_startoff >= last_da)
>  		goto out_no_ra;
> @@ -334,7 +334,7 @@ xfs_dir2_leaf_readbuf(
>  			ra_want -= geo->fsbcount;
>  			next_ra += geo->fsbcount;
>  		}
> -		if (!xfs_iext_get_extent(ifp, ++idx, &map)) {
> +		if (!xfs_iext_next_extent(ifp, &icur, &map)) {
>  			*ra_blk = last_da;
>  			break;
>  		}
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index cd82429d8df7..8338b894d54f 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -703,7 +703,7 @@ xfs_dq_get_next_id(
>  	xfs_dqid_t		next_id = *id + 1; /* simple advance */
>  	uint			lock_flags;
>  	struct xfs_bmbt_irec	got;
> -	xfs_extnum_t		idx;
> +	struct xfs_iext_cursor	cur;
>  	xfs_fsblock_t		start;
>  	int			error = 0;
>  
> @@ -727,7 +727,7 @@ xfs_dq_get_next_id(
>  			return error;
>  	}
>  
> -	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &idx, &got)) {
> +	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &cur, &got)) {
>  		/* contiguous chunk, bump startoff for the id calculation */
>  		if (got.br_startoff < start)
>  			got.br_startoff = start;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index da0abc8a0725..ad48e2f24699 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -390,7 +390,7 @@ xfs_iomap_prealloc_size(
>  	struct xfs_inode	*ip,
>  	loff_t			offset,
>  	loff_t			count,
> -	xfs_extnum_t		idx)
> +	struct xfs_iext_cursor	*icur)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> @@ -415,7 +415,7 @@ xfs_iomap_prealloc_size(
>  	 */
>  	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
>  	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
> -	    !xfs_iext_get_extent(ifp, idx - 1, &prev) ||
> +	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
>  	    prev.br_startoff + prev.br_blockcount < offset_fsb)
>  		return mp->m_writeio_blocks;
>  
> @@ -533,7 +533,7 @@ xfs_file_iomap_begin_delay(
>  	xfs_fileoff_t		end_fsb;
>  	int			error = 0, eof = 0;
>  	struct xfs_bmbt_irec	got;
> -	xfs_extnum_t		idx;
> +	struct xfs_iext_cursor	icur;
>  	xfs_fsblock_t		prealloc_blocks = 0;
>  
>  	ASSERT(!XFS_IS_REALTIME_INODE(ip));
> @@ -558,7 +558,7 @@ xfs_file_iomap_begin_delay(
>  			goto out_unlock;
>  	}
>  
> -	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got);
> +	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got);
>  	if (!eof && got.br_startoff <= offset_fsb) {
>  		if (xfs_is_reflink_inode(ip)) {
>  			bool		shared;
> @@ -592,7 +592,8 @@ xfs_file_iomap_begin_delay(
>  	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
>  
>  	if (eof) {
> -		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count, idx);
> +		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count,
> +				&icur);
>  		if (prealloc_blocks) {
>  			xfs_extlen_t	align;
>  			xfs_off_t	end_offset;
> @@ -614,7 +615,8 @@ xfs_file_iomap_begin_delay(
>  
>  retry:
>  	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
> -			end_fsb - offset_fsb, prealloc_blocks, &got, &idx, eof);
> +			end_fsb - offset_fsb, prealloc_blocks, &got, &icur,
> +			eof);
>  	switch (error) {
>  	case 0:
>  		break;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 1205747e1409..d86c4378facf 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -273,7 +273,7 @@ xfs_reflink_reserve_cow(
>  	struct xfs_bmbt_irec	got;
>  	int			error = 0;
>  	bool			eof = false, trimmed;
> -	xfs_extnum_t		idx;
> +	struct xfs_iext_cursor	icur;
>  
>  	/*
>  	 * Search the COW fork extent list first.  This serves two purposes:
> @@ -284,7 +284,7 @@ xfs_reflink_reserve_cow(
>  	 * tree.
>  	 */
>  
> -	if (!xfs_iext_lookup_extent(ip, ifp, imap->br_startoff, &idx, &got))
> +	if (!xfs_iext_lookup_extent(ip, ifp, imap->br_startoff, &icur, &got))
>  		eof = true;
>  	if (!eof && got.br_startoff <= imap->br_startoff) {
>  		trace_xfs_reflink_cow_found(ip, imap);
> @@ -312,7 +312,7 @@ xfs_reflink_reserve_cow(
>  		return error;
>  
>  	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
> -			imap->br_blockcount, 0, &got, &idx, eof);
> +			imap->br_blockcount, 0, &got, &icur, eof);
>  	if (error == -ENOSPC || error == -EDQUOT)
>  		trace_xfs_reflink_cow_enospc(ip, imap);
>  	if (error)
> @@ -359,16 +359,16 @@ xfs_reflink_convert_cow(
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
> -	xfs_extnum_t		idx;
> +	struct xfs_iext_cursor	icur;
>  	bool			found;
>  	int			error = 0;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
>  	/* Convert all the extents to real from unwritten. */
> -	for (found = xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got);
> +	for (found = xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got);
>  	     found && got.br_startoff < end_fsb;
> -	     found = xfs_iext_get_extent(ifp, ++idx, &got)) {
> +	     found = xfs_iext_next_extent(ifp, &icur, &got)) {
>  		error = xfs_reflink_convert_cow_extent(ip, &got, offset_fsb,
>  				end_fsb - offset_fsb, &dfops);
>  		if (error)
> @@ -399,7 +399,7 @@ xfs_reflink_allocate_cow(
>  	bool			trimmed;
>  	xfs_filblks_t		resaligned;
>  	xfs_extlen_t		resblks = 0;
> -	xfs_extnum_t		idx;
> +	struct xfs_iext_cursor	icur;
>  
>  retry:
>  	ASSERT(xfs_is_reflink_inode(ip));
> @@ -409,7 +409,7 @@ xfs_reflink_allocate_cow(
>  	 * Even if the extent is not shared we might have a preallocation for
>  	 * it in the COW fork.  If so use it.
>  	 */
> -	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &idx, &got) &&
> +	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got) &&
>  	    got.br_startoff <= offset_fsb) {
>  		*shared = true;
>  
> @@ -496,13 +496,13 @@ xfs_reflink_find_cow_mapping(
>  	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	xfs_fileoff_t			offset_fsb;
>  	struct xfs_bmbt_irec		got;
> -	xfs_extnum_t			idx;
> +	struct xfs_iext_cursor		icur;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  	ASSERT(xfs_is_reflink_inode(ip));
>  
>  	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
> -	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got))
> +	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got))
>  		return false;
>  	if (got.br_startoff > offset_fsb)
>  		return false;
> @@ -524,18 +524,18 @@ xfs_reflink_trim_irec_to_next_cow(
>  {
>  	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	struct xfs_bmbt_irec		got;
> -	xfs_extnum_t			idx;
> +	struct xfs_iext_cursor		icur;
>  
>  	if (!xfs_is_reflink_inode(ip))
>  		return;
>  
>  	/* Find the extent in the CoW fork. */
> -	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got))
> +	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got))
>  		return;
>  
>  	/* This is the extent before; try sliding up one. */
>  	if (got.br_startoff < offset_fsb) {
> -		if (!xfs_iext_get_extent(ifp, idx + 1, &got))
> +		if (!xfs_iext_next_extent(ifp, &icur, &got))
>  			return;
>  	}
>  
> @@ -562,14 +562,14 @@ xfs_reflink_cancel_cow_blocks(
>  {
>  	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	struct xfs_bmbt_irec		got, del;
> -	xfs_extnum_t			idx;
> +	struct xfs_iext_cursor		icur;
>  	xfs_fsblock_t			firstfsb;
>  	struct xfs_defer_ops		dfops;
>  	int				error = 0;
>  
>  	if (!xfs_is_reflink_inode(ip))
>  		return 0;
> -	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got))
> +	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got))
>  		return 0;
>  
>  	while (got.br_startoff < end_fsb) {
> @@ -579,7 +579,7 @@ xfs_reflink_cancel_cow_blocks(
>  
>  		if (isnullstartblock(del.br_startblock)) {
>  			error = xfs_bmap_del_extent_delay(ip, XFS_COW_FORK,
> -					&idx, &got, &del);
> +					&icur, &got, &del);
>  			if (error)
>  				break;
>  		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
> @@ -610,10 +610,10 @@ xfs_reflink_cancel_cow_blocks(
>  			}
>  
>  			/* Remove the mapping from the CoW fork. */
> -			xfs_bmap_del_extent_cow(ip, &idx, &got, &del);
> +			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
>  		}
>  
> -		if (!xfs_iext_get_extent(ifp, ++idx, &got))
> +		if (!xfs_iext_next_extent(ifp, &icur, &got))
>  			break;
>  	}
>  
> @@ -698,7 +698,7 @@ xfs_reflink_end_cow(
>  	int				error;
>  	unsigned int			resblks;
>  	xfs_filblks_t			rlen;
> -	xfs_extnum_t			idx;
> +	struct xfs_iext_cursor		icur;
>  
>  	trace_xfs_reflink_end_cow(ip, offset, count);
>  
> @@ -738,7 +738,7 @@ xfs_reflink_end_cow(
>  	 * left by the time I/O completes for the loser of the race.  In that
>  	 * case we are done.
>  	 */
> -	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &idx, &got))
> +	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
>  		goto out_cancel;
>  
>  	/* Walk backwards until we're out of the I/O range... */
> @@ -746,9 +746,9 @@ xfs_reflink_end_cow(
>  		del = got;
>  		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
>  
> -		/* Extent delete may have bumped idx forward */
> +		/* Extent delete may have bumped ext forward */
>  		if (!del.br_blockcount) {
> -			idx--;
> +			xfs_iext_prev(ifp, &icur);
>  			goto next_extent;
>  		}
>  
> @@ -760,7 +760,7 @@ xfs_reflink_end_cow(
>  		 * allocated but have not yet been involved in a write.
>  		 */
>  		if (got.br_state == XFS_EXT_UNWRITTEN) {
> -			idx--;
> +			xfs_iext_prev(ifp, &icur);
>  			goto next_extent;
>  		}
>  
> @@ -791,14 +791,14 @@ xfs_reflink_end_cow(
>  			goto out_defer;
>  
>  		/* Remove the mapping from the CoW fork. */
> -		xfs_bmap_del_extent_cow(ip, &idx, &got, &del);
> +		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
>  
>  		xfs_defer_ijoin(&dfops, ip);
>  		error = xfs_defer_finish(&tp, &dfops);
>  		if (error)
>  			goto out_defer;
>  next_extent:
> -		if (!xfs_iext_get_extent(ifp, idx, &got))
> +		if (!xfs_iext_get_extent(ifp, &icur, &got))
>  			break;
>  	}
>  
> @@ -1428,7 +1428,7 @@ xfs_reflink_inode_has_shared_extents(
>  	xfs_extlen_t			aglen;
>  	xfs_agblock_t			rbno;
>  	xfs_extlen_t			rlen;
> -	xfs_extnum_t			idx;
> +	struct xfs_iext_cursor		icur;
>  	bool				found;
>  	int				error;
>  
> @@ -1440,7 +1440,7 @@ xfs_reflink_inode_has_shared_extents(
>  	}
>  
>  	*has_shared = false;
> -	found = xfs_iext_lookup_extent(ip, ifp, 0, &idx, &got);
> +	found = xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got);
>  	while (found) {
>  		if (isnullstartblock(got.br_startblock) ||
>  		    got.br_state != XFS_EXT_NORM)
> @@ -1459,7 +1459,7 @@ xfs_reflink_inode_has_shared_extents(
>  			return 0;
>  		}
>  next:
> -		found = xfs_iext_get_extent(ifp, ++idx, &got);
> +		found = xfs_iext_next_extent(ifp, &icur, &got);
>  	}
>  
>  	return 0;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 665ef6cca90c..667bfce802cd 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -258,9 +258,9 @@ TRACE_EVENT(xfs_iext_insert,
>  );
>  
>  DECLARE_EVENT_CLASS(xfs_bmap_class,
> -	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state,
> +	TP_PROTO(struct xfs_inode *ip, struct xfs_iext_cursor *cur, int state,
>  		 unsigned long caller_ip),
> -	TP_ARGS(ip, idx, state, caller_ip),
> +	TP_ARGS(ip, cur, state, caller_ip),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> @@ -277,10 +277,10 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
>  		struct xfs_bmbt_irec	r;
>  
>  		ifp = xfs_iext_state_to_fork(ip, state);
> -		xfs_iext_get_extent(ifp, idx, &r);
> +		xfs_iext_get_extent(ifp, cur, &r);
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
> -		__entry->idx = idx;
> +		__entry->idx = cur->idx;
>  		__entry->startoff = r.br_startoff;
>  		__entry->startblock = r.br_startblock;
>  		__entry->blockcount = r.br_blockcount;
> @@ -303,9 +303,9 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
>  
>  #define DEFINE_BMAP_EVENT(name) \
>  DEFINE_EVENT(xfs_bmap_class, name, \
> -	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state, \
> +	TP_PROTO(struct xfs_inode *ip, struct xfs_iext_cursor *cur, int state, \
>  		 unsigned long caller_ip), \
> -	TP_ARGS(ip, idx, state, caller_ip))
> +	TP_ARGS(ip, cur, state, caller_ip))
>  DEFINE_BMAP_EVENT(xfs_iext_remove);
>  DEFINE_BMAP_EVENT(xfs_bmap_pre_update);
>  DEFINE_BMAP_EVENT(xfs_bmap_post_update);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
