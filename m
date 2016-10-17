Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34931 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754447AbcJQScY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 14:32:24 -0400
Date: Mon, 17 Oct 2016 11:32:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/9] xfs: refactor xfs_bunmapi_cow
Message-ID: <20161017183040.GI1120@birch.djwong.org>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
 <1476521554-1894-7-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476521554-1894-7-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Sat, Oct 15, 2016 at 10:52:31AM +0200, Christoph Hellwig wrote:
> Split out two helpers for deleting delayed or real extents from the COW fork.
> This allows to call them directly from xfs_reflink_cow_end_io once that
> function is refactored to iterate the extent tree.  It will also allow
> to reuse the delalloc deletion from xfs_bunmapi in the future.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 374 ++++++++++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_bmap.h |   5 +
>  fs/xfs/xfs_reflink.c     |   5 -
>  3 files changed, 225 insertions(+), 159 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 016dacc..64f82c8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4862,6 +4862,219 @@ xfs_bmap_split_indlen(
>  	return stolen;
>  }
>  
> +int
> +xfs_bmap_del_extent_delay(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	xfs_extnum_t		*idx,
> +	struct xfs_bmbt_irec	*got,
> +	struct xfs_bmbt_irec	*del)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	struct xfs_bmbt_irec	new;
> +	int64_t			da_old, da_new, da_diff = 0;
> +	xfs_fileoff_t		del_endoff, got_endoff;
> +	xfs_filblks_t		got_indlen, new_indlen, stolen;
> +	int			error = 0, state = 0;
> +	bool			isrt;
> +
> +	XFS_STATS_INC(mp, xs_del_exlist);
> +
> +	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
> +	del_endoff = del->br_startoff + del->br_blockcount;
> +	got_endoff = got->br_startoff + got->br_blockcount;
> +	da_old = startblockval(got->br_startblock);
> +	da_new = 0;
> +
> +	ASSERT(*idx >= 0);
> +	ASSERT(*idx < ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
> +	ASSERT(del->br_blockcount > 0);
> +	ASSERT(got->br_startoff <= del->br_startoff);
> +	ASSERT(got_endoff >= del_endoff);
> +
> +	if (isrt) {
> +		int64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
> +
> +		do_div(rtexts, mp->m_sb.sb_rextsize);
> +		xfs_mod_frextents(mp, rtexts);
> +	}
> +
> +	/*
> +	 * Update the inode delalloc counter now and wait to update the
> +	 * sb counters as we might have to borrow some blocks for the
> +	 * indirect block accounting.
> +	 */
> +	xfs_trans_reserve_quota_nblks(NULL, ip, -((long)del->br_blockcount), 0,
> +			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
> +	ip->i_delayed_blks -= del->br_blockcount;
> +
> +	if (whichfork == XFS_COW_FORK)
> +		state |= BMAP_COWFORK;
> +
> +	if (got->br_startoff == del->br_startoff)
> +		state |= BMAP_LEFT_CONTIG;
> +	if (got_endoff == del_endoff)
> +		state |= BMAP_RIGHT_CONTIG;
> +
> +	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
> +	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
> +		/*
> +		 * Matches the whole extent.  Delete the entry.
> +		 */
> +		xfs_iext_remove(ip, *idx, 1, state);
> +		--*idx;
> +		break;
> +	case BMAP_LEFT_CONTIG:
> +		/*
> +		 * Deleting the first part of the extent.
> +		 */
> +		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> +		got->br_startoff = del_endoff;
> +		got->br_blockcount -= del->br_blockcount;
> +		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip,
> +				got->br_blockcount), da_old);
> +		got->br_startblock = nullstartblock((int)da_new);
> +		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> +		break;
> +	case BMAP_RIGHT_CONTIG:
> +		/*
> +		 * Deleting the last part of the extent.
> +		 */
> +		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> +		got->br_blockcount = got->br_blockcount - del->br_blockcount;
> +		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip,
> +				got->br_blockcount), da_old);
> +		got->br_startblock = nullstartblock((int)da_new);
> +		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> +		break;
> +	case 0:
> +		/*
> +		 * Deleting the middle of the extent.
> +		 *
> +		 * Distribute the original indlen reservation across the two new
> +		 * extents.  Steal blocks from the deleted extent if necessary.
> +		 * Stealing blocks simply fudges the fdblocks accounting below.
> +		 * Warn if either of the new indlen reservations is zero as this
> +		 * can lead to delalloc problems.
> +		 */
> +		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> +
> +		got->br_blockcount = del->br_startoff - got->br_startoff;
> +		got_indlen = xfs_bmap_worst_indlen(ip, got->br_blockcount);
> +
> +		new.br_blockcount = got_endoff - del_endoff;
> +		new_indlen = xfs_bmap_worst_indlen(ip, new.br_blockcount);
> +
> +		WARN_ON_ONCE(!got_indlen || !new_indlen);
> +		stolen = xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen,
> +						       del->br_blockcount);
> +
> +		got->br_startblock = nullstartblock((int)got_indlen);
> +		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		trace_xfs_bmap_post_update(ip, *idx, 0, _THIS_IP_);
> +
> +		new.br_startoff = del_endoff;
> +		new.br_state = got->br_state;
> +		new.br_startblock = nullstartblock((int)new_indlen);
> +
> +		++*idx;
> +		xfs_iext_insert(ip, *idx, 1, &new, state);
> +
> +		da_new = got_indlen + new_indlen - stolen;
> +		del->br_blockcount -= stolen;
> +		break;
> +	}
> +
> +	ASSERT(da_old >= da_new);
> +	da_diff = da_old - da_new;
> +	if (!isrt)
> +		da_diff += del->br_blockcount;
> +	if (da_diff)
> +		xfs_mod_fdblocks(mp, da_diff, false);
> +	return error;
> +}
> +
> +void
> +xfs_bmap_del_extent_cow(
> +	struct xfs_inode	*ip,
> +	xfs_extnum_t		*idx,
> +	struct xfs_bmbt_irec	*got,
> +	struct xfs_bmbt_irec	*del)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> +	struct xfs_bmbt_irec	new;
> +	xfs_fileoff_t		del_endoff, got_endoff;
> +	int			state = BMAP_COWFORK;
> +
> +	XFS_STATS_INC(mp, xs_del_exlist);
> +
> +	del_endoff = del->br_startoff + del->br_blockcount;
> +	got_endoff = got->br_startoff + got->br_blockcount;
> +
> +	ASSERT(*idx >= 0);
> +	ASSERT(*idx < ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
> +	ASSERT(del->br_blockcount > 0);
> +	ASSERT(got->br_startoff <= del->br_startoff);
> +	ASSERT(got_endoff >= del_endoff);
> +	ASSERT(!isnullstartblock(got->br_startblock));
> +
> +	if (got->br_startoff == del->br_startoff)
> +		state |= BMAP_LEFT_CONTIG;
> +	if (got_endoff == del_endoff)
> +		state |= BMAP_RIGHT_CONTIG;
> +
> +	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
> +	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
> +		/*
> +		 * Matches the whole extent.  Delete the entry.
> +		 */
> +		xfs_iext_remove(ip, *idx, 1, state);
> +		--*idx;
> +		break;
> +	case BMAP_LEFT_CONTIG:
> +		/*
> +		 * Deleting the first part of the extent.
> +		 */
> +		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> +		got->br_startoff = del_endoff;
> +		got->br_blockcount -= del->br_blockcount;
> +		got->br_startblock = del->br_startblock + del->br_blockcount;
> +		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> +		break;
> +	case BMAP_RIGHT_CONTIG:
> +		/*
> +		 * Deleting the last part of the extent.
> +		 */
> +		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> +		got->br_blockcount -= del->br_blockcount;
> +		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> +		break;
> +	case 0:
> +		/*
> +		 * Deleting the middle of the extent.
> +		 */
> +		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> +		got->br_blockcount = del->br_startoff - got->br_startoff;
> +		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> +
> +		new.br_startoff = del_endoff;
> +		new.br_blockcount = got_endoff - del_endoff;
> +		new.br_state = got->br_state;
> +		new.br_startblock = del->br_startblock + del->br_blockcount;
> +
> +		++*idx;
> +		xfs_iext_insert(ip, *idx, 1, &new, state);
> +		break;
> +	}
> +}
> +
>  /*
>   * Called by xfs_bmapi to update file extent records and the btree
>   * after removing space (or undoing a delayed allocation).
> @@ -5210,167 +5423,20 @@ xfs_bunmapi_cow(
>  	struct xfs_inode		*ip,
>  	struct xfs_bmbt_irec		*del)
>  {
> -	xfs_filblks_t			da_new;
> -	xfs_filblks_t			da_old;
> -	xfs_fsblock_t			del_endblock = 0;
> -	xfs_fileoff_t			del_endoff;
> -	int				delay;
>  	struct xfs_bmbt_rec_host	*ep;
> -	int				error;
>  	struct xfs_bmbt_irec		got;
> -	xfs_fileoff_t			got_endoff;
> -	struct xfs_ifork		*ifp;
> -	struct xfs_mount		*mp;
> -	xfs_filblks_t			nblks;
>  	struct xfs_bmbt_irec		new;
> -	/* REFERENCED */
> -	uint				qfield;
> -	xfs_filblks_t			temp;
> -	xfs_filblks_t			temp2;
> -	int				state = BMAP_COWFORK;
>  	int				eof;
>  	xfs_extnum_t			eidx;
>  
> -	mp = ip->i_mount;
> -	XFS_STATS_INC(mp, xs_del_exlist);
> -
>  	ep = xfs_bmap_search_extents(ip, del->br_startoff, XFS_COW_FORK, &eof,
> -			&eidx, &got, &new);
> -
> -	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK); ifp = ifp;
> -	ASSERT((eidx >= 0) && (eidx < ifp->if_bytes /
> -		(uint)sizeof(xfs_bmbt_rec_t)));
> -	ASSERT(del->br_blockcount > 0);
> -	ASSERT(got.br_startoff <= del->br_startoff);
> -	del_endoff = del->br_startoff + del->br_blockcount;
> -	got_endoff = got.br_startoff + got.br_blockcount;
> -	ASSERT(got_endoff >= del_endoff);
> -	delay = isnullstartblock(got.br_startblock);
> -	ASSERT(isnullstartblock(del->br_startblock) == delay);
> -	qfield = 0;
> -	error = 0;
> -	/*
> -	 * If deleting a real allocation, must free up the disk space.
> -	 */
> -	if (!delay) {
> -		nblks = del->br_blockcount;
> -		qfield = XFS_TRANS_DQ_BCOUNT;
> -		/*
> -		 * Set up del_endblock and cur for later.
> -		 */
> -		del_endblock = del->br_startblock + del->br_blockcount;
> -		da_old = da_new = 0;
> -	} else {
> -		da_old = startblockval(got.br_startblock);
> -		da_new = 0;
> -		nblks = 0;
> -	}
> -	qfield = qfield;
> -	nblks = nblks;
> -
> -	/*
> -	 * Set flag value to use in switch statement.
> -	 * Left-contig is 2, right-contig is 1.
> -	 */
> -	switch (((got.br_startoff == del->br_startoff) << 1) |
> -		(got_endoff == del_endoff)) {
> -	case 3:
> -		/*
> -		 * Matches the whole extent.  Delete the entry.
> -		 */
> -		xfs_iext_remove(ip, eidx, 1, BMAP_COWFORK);
> -		--eidx;
> -		break;
> -
> -	case 2:
> -		/*
> -		 * Deleting the first part of the extent.
> -		 */
> -		trace_xfs_bmap_pre_update(ip, eidx, state, _THIS_IP_);
> -		xfs_bmbt_set_startoff(ep, del_endoff);
> -		temp = got.br_blockcount - del->br_blockcount;
> -		xfs_bmbt_set_blockcount(ep, temp);
> -		if (delay) {
> -			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> -				da_old);
> -			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
> -			trace_xfs_bmap_post_update(ip, eidx, state, _THIS_IP_);
> -			da_new = temp;
> -			break;
> -		}
> -		xfs_bmbt_set_startblock(ep, del_endblock);
> -		trace_xfs_bmap_post_update(ip, eidx, state, _THIS_IP_);
> -		break;
> -
> -	case 1:
> -		/*
> -		 * Deleting the last part of the extent.
> -		 */
> -		temp = got.br_blockcount - del->br_blockcount;
> -		trace_xfs_bmap_pre_update(ip, eidx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep, temp);
> -		if (delay) {
> -			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> -				da_old);
> -			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
> -			trace_xfs_bmap_post_update(ip, eidx, state, _THIS_IP_);
> -			da_new = temp;
> -			break;
> -		}
> -		trace_xfs_bmap_post_update(ip, eidx, state, _THIS_IP_);
> -		break;
> -
> -	case 0:
> -		/*
> -		 * Deleting the middle of the extent.
> -		 */
> -		temp = del->br_startoff - got.br_startoff;
> -		trace_xfs_bmap_pre_update(ip, eidx, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(ep, temp);
> -		new.br_startoff = del_endoff;
> -		temp2 = got_endoff - del_endoff;
> -		new.br_blockcount = temp2;
> -		new.br_state = got.br_state;
> -		if (!delay) {
> -			new.br_startblock = del_endblock;
> -		} else {
> -			temp = xfs_bmap_worst_indlen(ip, temp);
> -			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
> -			temp2 = xfs_bmap_worst_indlen(ip, temp2);
> -			new.br_startblock = nullstartblock((int)temp2);
> -			da_new = temp + temp2;
> -			while (da_new > da_old) {
> -				if (temp) {
> -					temp--;
> -					da_new--;
> -					xfs_bmbt_set_startblock(ep,
> -						nullstartblock((int)temp));
> -				}
> -				if (da_new == da_old)
> -					break;
> -				if (temp2) {
> -					temp2--;
> -					da_new--;
> -					new.br_startblock =
> -						nullstartblock((int)temp2);
> -				}
> -			}
> -		}
> -		trace_xfs_bmap_post_update(ip, eidx, state, _THIS_IP_);
> -		xfs_iext_insert(ip, eidx + 1, 1, &new, state);
> -		++eidx;
> -		break;
> -	}
> -
> -	/*
> -	 * Account for change in delayed indirect blocks.
> -	 * Nothing to do for disk quota accounting here.
> -	 */
> -	ASSERT(da_old >= da_new);
> -	if (da_old > da_new)
> -		xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new), false);
> -
> -	return error;
> +				&eidx, &got, &new);
> +	ASSERT(ep);
> +	if (isnullstartblock(got.br_startblock))
> +		xfs_bmap_del_extent_delay(ip, XFS_COW_FORK, &eidx, &got, del);
> +	else
> +		xfs_bmap_del_extent_cow(ip, &eidx, &got, del);
> +	return 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index eb86af0..5f18248 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -224,6 +224,11 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
>  		struct xfs_defer_ops *dfops, int *done);
>  int	xfs_bunmapi_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *del);
> +int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
> +		xfs_extnum_t *idx, struct xfs_bmbt_irec *got,
> +		struct xfs_bmbt_irec *del);
> +void	xfs_bmap_del_extent_cow(struct xfs_inode *ip, xfs_extnum_t *idx,
> +		struct xfs_bmbt_irec *got, struct xfs_bmbt_irec *del);
>  int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
>  		xfs_extnum_t num);
>  uint	xfs_default_attroffset(struct xfs_inode *ip);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 5d230ea..f33f737 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -535,11 +535,6 @@ xfs_reflink_cancel_cow_blocks(
>  		trace_xfs_reflink_cancel_cow(ip, &irec);
>  
>  		if (irec.br_startblock == DELAYSTARTBLOCK) {
> -			/* Free a delayed allocation. */
> -			xfs_mod_fdblocks(ip->i_mount, irec.br_blockcount,
> -					false);
> -			ip->i_delayed_blks -= irec.br_blockcount;
> -
>  			/* Remove the mapping from the CoW fork. */
>  			error = xfs_bunmapi_cow(ip, &irec);
>  			if (error)
> -- 
> 2.1.4
> 
