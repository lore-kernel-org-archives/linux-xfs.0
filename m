Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37678 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbeG3WZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 18:25:53 -0400
Date: Mon, 30 Jul 2018 13:49:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/15] xfs: pass transaction to xfs_defer_add()
Message-ID: <20180730204900.GN30972@magnolia>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-14-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-14-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:18PM -0400, Brian Foster wrote:
> The majority of remaining references to struct xfs_defer_ops in XFS
> are associated with xfs_defer_add(). At this point, there are no
> more external xfs_defer_ops users left. All instances of
> xfs_defer_ops are embedded in the transaction, which means we can
> safely pass the transaction down to the dfops add interface.
> 
> Update xfs_defer_add() to receive the transaction as a parameter.
> Various subsystems implement wrappers to allocate and construct the
> context specific data structures for the associated deferred
> operation type. Update these to also carry the transaction down as
> needed and clean up unused dfops parameters along the way.
> 
> This removes most of the remaining references to struct
> xfs_defer_ops throughout the code and facilitates removal of the
> structure.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c      |  9 ++--
>  fs/xfs/libxfs/xfs_bmap.c       | 75 +++++++++++++++------------------
>  fs/xfs/libxfs/xfs_bmap.h       | 19 ++++-----
>  fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
>  fs/xfs/libxfs/xfs_defer.c      |  3 +-
>  fs/xfs/libxfs/xfs_defer.h      |  2 +-
>  fs/xfs/libxfs/xfs_ialloc.c     | 25 +++++------
>  fs/xfs/libxfs/xfs_refcount.c   | 76 ++++++++++++++--------------------
>  fs/xfs/libxfs/xfs_refcount.h   | 18 ++++----
>  fs/xfs/libxfs/xfs_rmap.c       | 53 ++++++++++++------------
>  fs/xfs/libxfs/xfs_rmap.h       | 22 ++++------
>  fs/xfs/xfs_bmap_item.c         |  3 +-
>  fs/xfs/xfs_bmap_util.c         | 13 ++----
>  fs/xfs/xfs_refcount_item.c     | 14 ++-----
>  fs/xfs/xfs_reflink.c           | 21 ++++------
>  15 files changed, 156 insertions(+), 199 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3c3f2d5119ea..6bacdc31a439 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2198,12 +2198,12 @@ xfs_agfl_reset(
>   */
>  STATIC void
>  xfs_defer_agfl_block(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> +	struct xfs_trans		*tp,
>  	xfs_agnumber_t			agno,
>  	xfs_fsblock_t			agbno,
>  	struct xfs_owner_info		*oinfo)
>  {
> +	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_extent_free_item	*new;		/* new element */
>  
>  	ASSERT(xfs_bmap_free_item_zone != NULL);
> @@ -2216,7 +2216,7 @@ xfs_defer_agfl_block(
>  
>  	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
>  
> -	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
>  }
>  
>  /*
> @@ -2325,8 +2325,7 @@ xfs_alloc_fix_freelist(
>  
>  		/* defer agfl frees if dfops is provided */
>  		if (tp->t_dfops) {
> -			xfs_defer_agfl_block(mp, tp->t_dfops, args->agno,
> -					     bno, &targs.oinfo);
> +			xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
>  		} else {
>  			error = xfs_free_agfl_block(tp, args->agno, bno, agbp,
>  						    &targs.oinfo);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d20f541b7061..f5f1fc47923e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -533,13 +533,13 @@ xfs_bmap_validate_ret(
>   */
>  void
>  __xfs_bmap_add_free(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> +	struct xfs_trans		*tp,
>  	xfs_fsblock_t			bno,
>  	xfs_filblks_t			len,
>  	struct xfs_owner_info		*oinfo,
>  	bool				skip_discard)
>  {
> +	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_extent_free_item	*new;		/* new element */
>  #ifdef DEBUG
>  	xfs_agnumber_t		agno;
> @@ -568,7 +568,7 @@ __xfs_bmap_add_free(
>  	new->xefi_skip_discard = skip_discard;
>  	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
>  			XFS_FSB_TO_AGBNO(mp, bno), len);
> -	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
>  }
>  
>  /*
> @@ -624,7 +624,7 @@ xfs_bmap_btree_to_extents(
>  	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
>  		return error;
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> -	xfs_bmap_add_free(mp, cur->bc_tp->t_dfops, cbno, 1, &oinfo);
> +	xfs_bmap_add_free(cur->bc_tp, cbno, 1, &oinfo);
>  	ip->i_d.di_nblocks--;
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
>  	xfs_trans_binval(tp, cbp);
> @@ -1961,8 +1961,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  	/* add reverse mapping unless caller opted out */
>  	if (!(bma->flags & XFS_BMAPI_NORMAP)) {
> -		error = xfs_rmap_map_extent(mp, bma->tp->t_dfops, bma->ip,
> -				whichfork, new);
> +		error = xfs_rmap_map_extent(bma->tp, bma->ip, whichfork, new);
>  		if (error)
>  			goto done;
>  	}
> @@ -2026,7 +2025,6 @@ xfs_bmap_add_extent_unwritten_real(
>  	int			state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_bmbt_irec	old;
> -	struct xfs_defer_ops	*dfops = tp ? tp->t_dfops : NULL;
>  
>  	*logflagsp = 0;
>  
> @@ -2445,7 +2443,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	}
>  
>  	/* update reverse mappings */
> -	error = xfs_rmap_convert_extent(mp, dfops, ip, whichfork, new);
> +	error = xfs_rmap_convert_extent(mp, tp, ip, whichfork, new);
>  	if (error)
>  		goto done;
>  
> @@ -2806,8 +2804,7 @@ xfs_bmap_add_extent_hole_real(
>  
>  	/* add reverse mapping unless caller opted out */
>  	if (!(flags & XFS_BMAPI_NORMAP)) {
> -		error = xfs_rmap_map_extent(mp, tp->t_dfops, ip, whichfork,
> -				new);
> +		error = xfs_rmap_map_extent(tp, ip, whichfork, new);
>  		if (error)
>  			goto done;
>  	}
> @@ -4364,9 +4361,8 @@ xfs_bmapi_write(
>  			 * the refcount btree for orphan recovery.
>  			 */
>  			if (whichfork == XFS_COW_FORK) {
> -				error = xfs_refcount_alloc_cow_extent(mp,
> -						tp->t_dfops, bma.blkno,
> -						bma.length);
> +				error = xfs_refcount_alloc_cow_extent(tp,
> +						bma.blkno, bma.length);
>  				if (error)
>  					goto error0;
>  			}
> @@ -4852,7 +4848,6 @@ xfs_bmap_del_extent_real(
>  	uint			qfield;	/* quota field to update */
>  	int			state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_bmbt_irec	old;
> -	struct xfs_defer_ops	*dfops = tp ? tp->t_dfops : NULL;
>  
>  	mp = ip->i_mount;
>  	XFS_STATS_INC(mp, xs_del_exlist);
> @@ -5036,7 +5031,7 @@ xfs_bmap_del_extent_real(
>  	}
>  
>  	/* remove reverse mapping */
> -	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, del);
> +	error = xfs_rmap_unmap_extent(tp, ip, whichfork, del);
>  	if (error)
>  		goto done;
>  
> @@ -5045,11 +5040,11 @@ xfs_bmap_del_extent_real(
>  	 */
>  	if (do_fx && !(bflags & XFS_BMAPI_REMAP)) {
>  		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
> -			error = xfs_refcount_decrease_extent(mp, dfops, del);
> +			error = xfs_refcount_decrease_extent(tp, del);
>  			if (error)
>  				goto done;
>  		} else {
> -			__xfs_bmap_add_free(mp, dfops, del->br_startblock,
> +			__xfs_bmap_add_free(tp, del->br_startblock,
>  					del->br_blockcount, NULL,
>  					(bflags & XFS_BMAPI_NODISCARD) ||
>  					del->br_state == XFS_EXT_UNWRITTEN);
> @@ -5489,6 +5484,7 @@ xfs_bmse_can_merge(
>   */
>  STATIC int
>  xfs_bmse_merge(
> +	struct xfs_trans		*tp,
>  	struct xfs_inode		*ip,
>  	int				whichfork,
>  	xfs_fileoff_t			shift,		/* shift fsb */
> @@ -5496,8 +5492,7 @@ xfs_bmse_merge(
>  	struct xfs_bmbt_irec		*got,		/* extent to shift */
>  	struct xfs_bmbt_irec		*left,		/* preceding extent */
>  	struct xfs_btree_cur		*cur,
> -	int				*logflags,	/* output */
> -	struct xfs_defer_ops		*dfops)
> +	int				*logflags)	/* output */
>  {
>  	struct xfs_bmbt_irec		new;
>  	xfs_filblks_t			blockcount;
> @@ -5553,23 +5548,23 @@ xfs_bmse_merge(
>  			&new);
>  
>  	/* update reverse mapping. rmap functions merge the rmaps for us */
> -	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
> +	error = xfs_rmap_unmap_extent(tp, ip, whichfork, got);
>  	if (error)
>  		return error;
>  	memcpy(&new, got, sizeof(new));
>  	new.br_startoff = left->br_startoff + left->br_blockcount;
> -	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &new);
> +	return xfs_rmap_map_extent(tp, ip, whichfork, &new);
>  }
>  
>  static int
>  xfs_bmap_shift_update_extent(
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
>  	struct xfs_iext_cursor	*icur,
>  	struct xfs_bmbt_irec	*got,
>  	struct xfs_btree_cur	*cur,
>  	int			*logflags,
> -	struct xfs_defer_ops	*dfops,
>  	xfs_fileoff_t		startoff)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -5597,10 +5592,10 @@ xfs_bmap_shift_update_extent(
>  			got);
>  
>  	/* update reverse mapping */
> -	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, &prev);
> +	error = xfs_rmap_unmap_extent(tp, ip, whichfork, &prev);
>  	if (error)
>  		return error;
> -	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, got);
> +	return xfs_rmap_map_extent(tp, ip, whichfork, got);
>  }
>  
>  int
> @@ -5660,9 +5655,9 @@ xfs_bmap_collapse_extents(
>  		}
>  
>  		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
> -			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> -					&icur, &got, &prev, cur, &logflags,
> -					tp->t_dfops);
> +			error = xfs_bmse_merge(tp, ip, whichfork,
> +					offset_shift_fsb, &icur, &got, &prev,
> +					cur, &logflags);
>  			if (error)
>  				goto del_cursor;
>  			goto done;
> @@ -5674,8 +5669,8 @@ xfs_bmap_collapse_extents(
>  		}
>  	}
>  
> -	error = xfs_bmap_shift_update_extent(ip, whichfork, &icur, &got, cur,
> -			&logflags, tp->t_dfops, new_startoff);
> +	error = xfs_bmap_shift_update_extent(tp, ip, whichfork, &icur, &got,
> +			cur, &logflags, new_startoff);
>  	if (error)
>  		goto del_cursor;
>  
> @@ -5801,8 +5796,8 @@ xfs_bmap_insert_extents(
>  			WARN_ON_ONCE(1);
>  	}
>  
> -	error = xfs_bmap_shift_update_extent(ip, whichfork, &icur, &got, cur,
> -			&logflags, tp->t_dfops, new_startoff);
> +	error = xfs_bmap_shift_update_extent(tp, ip, whichfork, &icur, &got,
> +			cur, &logflags, new_startoff);
>  	if (error)
>  		goto del_cursor;
>  
> @@ -5979,13 +5974,13 @@ xfs_bmap_is_update_needed(
>  /* Record a bmap intent. */
>  static int
>  __xfs_bmap_add(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> +	struct xfs_trans		*tp,
>  	enum xfs_bmap_intent_type	type,
>  	struct xfs_inode		*ip,
>  	int				whichfork,
>  	struct xfs_bmbt_irec		*bmap)
>  {
> +	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_bmap_intent		*bi;
>  
>  	trace_xfs_bmap_defer(mp,
> @@ -6004,38 +5999,34 @@ __xfs_bmap_add(
>  	bi->bi_whichfork = whichfork;
>  	bi->bi_bmap = *bmap;
>  
> -	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_BMAP, &bi->bi_list);
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_BMAP, &bi->bi_list);
>  	return 0;
>  }
>  
>  /* Map an extent into a file. */
>  int
>  xfs_bmap_map_extent(
> -	struct xfs_mount	*mp,
> -	struct xfs_defer_ops	*dfops,
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*PREV)
>  {
>  	if (!xfs_bmap_is_update_needed(PREV))
>  		return 0;
>  
> -	return __xfs_bmap_add(mp, dfops, XFS_BMAP_MAP, ip,
> -			XFS_DATA_FORK, PREV);
> +	return __xfs_bmap_add(tp, XFS_BMAP_MAP, ip, XFS_DATA_FORK, PREV);
>  }
>  
>  /* Unmap an extent out of a file. */
>  int
>  xfs_bmap_unmap_extent(
> -	struct xfs_mount	*mp,
> -	struct xfs_defer_ops	*dfops,
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*PREV)
>  {
>  	if (!xfs_bmap_is_update_needed(PREV))
>  		return 0;
>  
> -	return __xfs_bmap_add(mp, dfops, XFS_BMAP_UNMAP, ip,
> -			XFS_DATA_FORK, PREV);
> +	return __xfs_bmap_add(tp, XFS_BMAP_UNMAP, ip, XFS_DATA_FORK, PREV);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 9165a878edcd..b6e9b639e731 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -184,9 +184,9 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
>  void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
>  void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
> -void	__xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> -			  xfs_fsblock_t bno, xfs_filblks_t len,
> -			  struct xfs_owner_info *oinfo, bool skip_discard);
> +void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
> +		xfs_filblks_t len, struct xfs_owner_info *oinfo,
> +		bool skip_discard);
>  void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
>  int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
> @@ -230,13 +230,12 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
>  
>  static inline void
>  xfs_bmap_add_free(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> +	struct xfs_trans		*tp,
>  	xfs_fsblock_t			bno,
>  	xfs_filblks_t			len,
>  	struct xfs_owner_info		*oinfo)
>  {
> -	__xfs_bmap_add_free(mp, dfops, bno, len, oinfo, false);
> +	__xfs_bmap_add_free(tp, bno, len, oinfo, false);
>  }
>  
>  enum xfs_bmap_intent_type {
> @@ -256,10 +255,10 @@ int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_inode *ip,
>  		enum xfs_bmap_intent_type type, int whichfork,
>  		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
>  		xfs_filblks_t *blockcount, xfs_exntst_t state);
> -int	xfs_bmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> -		struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
> -int	xfs_bmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> -		struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
> +int	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
> +		struct xfs_bmbt_irec *imap);
> +int	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
> +		struct xfs_bmbt_irec *imap);
>  
>  static inline int xfs_bmap_fork_to_state(int whichfork)
>  {
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 955e29de8cae..cdb74d2e2a43 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -289,7 +289,7 @@ xfs_bmbt_free_block(
>  	struct xfs_owner_info	oinfo;
>  
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
> -	xfs_bmap_add_free(mp, cur->bc_tp->t_dfops, fsbno, 1, &oinfo);
> +	xfs_bmap_add_free(cur->bc_tp, fsbno, 1, &oinfo);
>  	ip->i_d.di_nblocks--;
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 6bf792e2d61b..152190a69432 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -493,10 +493,11 @@ xfs_defer_cancel(
>  /* Add an item for later deferred processing. */
>  void
>  xfs_defer_add(
> -	struct xfs_defer_ops		*dop,
> +	struct xfs_trans		*tp,
>  	enum xfs_defer_ops_type		type,
>  	struct list_head		*li)
>  {
> +	struct xfs_defer_ops		*dop = tp->t_dfops;
>  	struct xfs_defer_pending	*dfp = NULL;
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 363af16328cb..295703737272 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -35,7 +35,7 @@ enum xfs_defer_ops_type {
>  	XFS_DEFER_OPS_TYPE_MAX,
>  };
>  
> -void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
> +void xfs_defer_add(struct xfs_trans *tp, enum xfs_defer_ops_type type,
>  		struct list_head *h);
>  int xfs_defer_finish_noroll(struct xfs_trans **tp);
>  int xfs_defer_finish(struct xfs_trans **tp);
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 295304ad1bc1..a8f6db735d5d 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1838,23 +1838,24 @@ xfs_dialloc(
>   */
>  STATIC void
>  xfs_difree_inode_chunk(
> -	struct xfs_mount		*mp,
> +	struct xfs_trans		*tp,
>  	xfs_agnumber_t			agno,
> -	struct xfs_inobt_rec_incore	*rec,
> -	struct xfs_defer_ops		*dfops)
> +	struct xfs_inobt_rec_incore	*rec)
>  {
> -	xfs_agblock_t	sagbno = XFS_AGINO_TO_AGBNO(mp, rec->ir_startino);
> -	int		startidx, endidx;
> -	int		nextbit;
> -	xfs_agblock_t	agbno;
> -	int		contigblk;
> -	struct xfs_owner_info	oinfo;
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	xfs_agblock_t			sagbno = XFS_AGINO_TO_AGBNO(mp,
> +							rec->ir_startino);
> +	int				startidx, endidx;
> +	int				nextbit;
> +	xfs_agblock_t			agbno;
> +	int				contigblk;
> +	struct xfs_owner_info		oinfo;
>  	DECLARE_BITMAP(holemask, XFS_INOBT_HOLEMASK_BITS);
>  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
>  
>  	if (!xfs_inobt_issparse(rec->ir_holemask)) {
>  		/* not sparse, calculate extent info directly */
> -		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, sagbno),
> +		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
>  				  mp->m_ialloc_blks, &oinfo);
>  		return;
>  	}
> @@ -1898,7 +1899,7 @@ xfs_difree_inode_chunk(
>  
>  		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
>  		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
> -		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, agbno),
> +		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
>  				  contigblk, &oinfo);
>  
>  		/* reset range to current bit and carry on... */
> @@ -2002,7 +2003,7 @@ xfs_difree_inobt(
>  			goto error0;
>  		}
>  
> -		xfs_difree_inode_chunk(mp, agno, &rec, tp->t_dfops);
> +		xfs_difree_inode_chunk(tp, agno, &rec);
>  	} else {
>  		xic->deleted = false;
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 86f297ca90cd..c713c49200d3 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -34,11 +34,9 @@ enum xfs_refc_adjust_op {
>  };
>  
>  STATIC int __xfs_refcount_cow_alloc(struct xfs_btree_cur *rcur,
> -		xfs_agblock_t agbno, xfs_extlen_t aglen,
> -		struct xfs_defer_ops *dfops);
> +		xfs_agblock_t agbno, xfs_extlen_t aglen);
>  STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
> -		xfs_agblock_t agbno, xfs_extlen_t aglen,
> -		struct xfs_defer_ops *dfops);
> +		xfs_agblock_t agbno, xfs_extlen_t aglen);
>  
>  /*
>   * Look up the first record less than or equal to [bno, len] in the btree
> @@ -870,7 +868,6 @@ xfs_refcount_adjust_extents(
>  	xfs_agblock_t		*agbno,
>  	xfs_extlen_t		*aglen,
>  	enum xfs_refc_adjust_op	adj,
> -	struct xfs_defer_ops	*dfops,
>  	struct xfs_owner_info	*oinfo)
>  {
>  	struct xfs_refcount_irec	ext, tmp;
> @@ -925,8 +922,8 @@ xfs_refcount_adjust_extents(
>  				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
>  						cur->bc_private.a.agno,
>  						tmp.rc_startblock);
> -				xfs_bmap_add_free(cur->bc_mp, dfops, fsbno,
> -						tmp.rc_blockcount, oinfo);
> +				xfs_bmap_add_free(cur->bc_tp, fsbno,
> +						  tmp.rc_blockcount, oinfo);
>  			}
>  
>  			(*agbno) += tmp.rc_blockcount;
> @@ -968,8 +965,8 @@ xfs_refcount_adjust_extents(
>  			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
>  					cur->bc_private.a.agno,
>  					ext.rc_startblock);
> -			xfs_bmap_add_free(cur->bc_mp, dfops, fsbno,
> -					ext.rc_blockcount, oinfo);
> +			xfs_bmap_add_free(cur->bc_tp, fsbno, ext.rc_blockcount,
> +					  oinfo);
>  		}
>  
>  skip:
> @@ -998,7 +995,6 @@ xfs_refcount_adjust(
>  	xfs_agblock_t		*new_agbno,
>  	xfs_extlen_t		*new_aglen,
>  	enum xfs_refc_adjust_op	adj,
> -	struct xfs_defer_ops	*dfops,
>  	struct xfs_owner_info	*oinfo)
>  {
>  	bool			shape_changed;
> @@ -1043,7 +1039,7 @@ xfs_refcount_adjust(
>  
>  	/* Now that we've taken care of the ends, adjust the middle extents */
>  	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen,
> -			adj, dfops, oinfo);
> +			adj, oinfo);
>  	if (error)
>  		goto out_error;
>  
> @@ -1090,7 +1086,6 @@ xfs_refcount_finish_one(
>  	struct xfs_btree_cur		**pcur)
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
> -	struct xfs_defer_ops		*dfops = tp->t_dfops;
>  	struct xfs_btree_cur		*rcur;
>  	struct xfs_buf			*agbp = NULL;
>  	int				error = 0;
> @@ -1145,23 +1140,23 @@ xfs_refcount_finish_one(
>  	switch (type) {
>  	case XFS_REFCOUNT_INCREASE:
>  		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
> -			new_len, XFS_REFCOUNT_ADJUST_INCREASE, dfops, NULL);
> +			new_len, XFS_REFCOUNT_ADJUST_INCREASE, NULL);
>  		*new_fsb = XFS_AGB_TO_FSB(mp, agno, new_agbno);
>  		break;
>  	case XFS_REFCOUNT_DECREASE:
>  		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
> -			new_len, XFS_REFCOUNT_ADJUST_DECREASE, dfops, NULL);
> +			new_len, XFS_REFCOUNT_ADJUST_DECREASE, NULL);
>  		*new_fsb = XFS_AGB_TO_FSB(mp, agno, new_agbno);
>  		break;
>  	case XFS_REFCOUNT_ALLOC_COW:
>  		*new_fsb = startblock + blockcount;
>  		*new_len = 0;
> -		error = __xfs_refcount_cow_alloc(rcur, bno, blockcount, dfops);
> +		error = __xfs_refcount_cow_alloc(rcur, bno, blockcount);
>  		break;
>  	case XFS_REFCOUNT_FREE_COW:
>  		*new_fsb = startblock + blockcount;
>  		*new_len = 0;
> -		error = __xfs_refcount_cow_free(rcur, bno, blockcount, dfops);
> +		error = __xfs_refcount_cow_free(rcur, bno, blockcount);
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -1183,12 +1178,12 @@ xfs_refcount_finish_one(
>   */
>  static int
>  __xfs_refcount_add(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> +	struct xfs_trans		*tp,
>  	enum xfs_refcount_intent_type	type,
>  	xfs_fsblock_t			startblock,
>  	xfs_extlen_t			blockcount)
>  {
> +	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_refcount_intent	*ri;
>  
>  	trace_xfs_refcount_defer(mp, XFS_FSB_TO_AGNO(mp, startblock),
> @@ -1202,7 +1197,7 @@ __xfs_refcount_add(
>  	ri->ri_startblock = startblock;
>  	ri->ri_blockcount = blockcount;
>  
> -	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_REFCOUNT, &ri->ri_list);
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_REFCOUNT, &ri->ri_list);
>  	return 0;
>  }
>  
> @@ -1211,14 +1206,13 @@ __xfs_refcount_add(
>   */
>  int
>  xfs_refcount_increase_extent(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> +	struct xfs_trans		*tp,
>  	struct xfs_bmbt_irec		*PREV)
>  {
> -	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> +	if (!xfs_sb_version_hasreflink(&tp->t_mountp->m_sb))
>  		return 0;
>  
> -	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_INCREASE,
> +	return __xfs_refcount_add(tp, XFS_REFCOUNT_INCREASE,
>  			PREV->br_startblock, PREV->br_blockcount);
>  }
>  
> @@ -1227,14 +1221,13 @@ xfs_refcount_increase_extent(
>   */
>  int
>  xfs_refcount_decrease_extent(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> +	struct xfs_trans		*tp,
>  	struct xfs_bmbt_irec		*PREV)
>  {
> -	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> +	if (!xfs_sb_version_hasreflink(&tp->t_mountp->m_sb))
>  		return 0;
>  
> -	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_DECREASE,
> +	return __xfs_refcount_add(tp, XFS_REFCOUNT_DECREASE,
>  			PREV->br_startblock, PREV->br_blockcount);
>  }
>  
> @@ -1522,8 +1515,7 @@ STATIC int
>  __xfs_refcount_cow_alloc(
>  	struct xfs_btree_cur	*rcur,
>  	xfs_agblock_t		agbno,
> -	xfs_extlen_t		aglen,
> -	struct xfs_defer_ops	*dfops)
> +	xfs_extlen_t		aglen)
>  {
>  	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_private.a.agno,
>  			agbno, aglen);
> @@ -1540,8 +1532,7 @@ STATIC int
>  __xfs_refcount_cow_free(
>  	struct xfs_btree_cur	*rcur,
>  	xfs_agblock_t		agbno,
> -	xfs_extlen_t		aglen,
> -	struct xfs_defer_ops	*dfops)
> +	xfs_extlen_t		aglen)
>  {
>  	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_private.a.agno,
>  			agbno, aglen);
> @@ -1554,47 +1545,45 @@ __xfs_refcount_cow_free(
>  /* Record a CoW staging extent in the refcount btree. */
>  int
>  xfs_refcount_alloc_cow_extent(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> +	struct xfs_trans		*tp,
>  	xfs_fsblock_t			fsb,
>  	xfs_extlen_t			len)
>  {
> +	struct xfs_mount		*mp = tp->t_mountp;
>  	int				error;
>  
>  	if (!xfs_sb_version_hasreflink(&mp->m_sb))
>  		return 0;
>  
> -	error = __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_ALLOC_COW,
> -			fsb, len);
> +	error = __xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
>  	if (error)
>  		return error;
>  
>  	/* Add rmap entry */
> -	return xfs_rmap_alloc_extent(mp, dfops, XFS_FSB_TO_AGNO(mp, fsb),
> +	return xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
>  			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
>  }
>  
>  /* Forget a CoW staging event in the refcount btree. */
>  int
>  xfs_refcount_free_cow_extent(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> +	struct xfs_trans		*tp,
>  	xfs_fsblock_t			fsb,
>  	xfs_extlen_t			len)
>  {
> +	struct xfs_mount		*mp = tp->t_mountp;
>  	int				error;
>  
>  	if (!xfs_sb_version_hasreflink(&mp->m_sb))
>  		return 0;
>  
>  	/* Remove rmap entry */
> -	error = xfs_rmap_free_extent(mp, dfops, XFS_FSB_TO_AGNO(mp, fsb),
> +	error = xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
>  			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
>  	if (error)
>  		return error;
>  
> -	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_FREE_COW,
> -			fsb, len);
> +	return __xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
>  }
>  
>  struct xfs_refcount_recovery {
> @@ -1692,14 +1681,13 @@ xfs_refcount_recover_cow_leftovers(
>  		/* Free the orphan record */
>  		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
>  		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
> -		error = xfs_refcount_free_cow_extent(mp, tp->t_dfops, fsb,
> +		error = xfs_refcount_free_cow_extent(tp, fsb,
>  				rr->rr_rrec.rc_blockcount);
>  		if (error)
>  			goto out_trans;
>  
>  		/* Free the block. */
> -		xfs_bmap_add_free(mp, tp->t_dfops, fsb,
> -				rr->rr_rrec.rc_blockcount, NULL);
> +		xfs_bmap_add_free(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
>  
>  		error = xfs_trans_commit(tp);
>  		if (error)
> diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> index 3b72c6dbf6ad..1d9c518575e7 100644
> --- a/fs/xfs/libxfs/xfs_refcount.h
> +++ b/fs/xfs/libxfs/xfs_refcount.h
> @@ -29,10 +29,10 @@ struct xfs_refcount_intent {
>  	xfs_extlen_t				ri_blockcount;
>  };
>  
> -extern int xfs_refcount_increase_extent(struct xfs_mount *mp,
> -		struct xfs_defer_ops *dfops, struct xfs_bmbt_irec *irec);
> -extern int xfs_refcount_decrease_extent(struct xfs_mount *mp,
> -		struct xfs_defer_ops *dfops, struct xfs_bmbt_irec *irec);
> +extern int xfs_refcount_increase_extent(struct xfs_trans *tp,
> +		struct xfs_bmbt_irec *irec);
> +extern int xfs_refcount_decrease_extent(struct xfs_trans *tp,
> +		struct xfs_bmbt_irec *irec);
>  
>  extern void xfs_refcount_finish_one_cleanup(struct xfs_trans *tp,
>  		struct xfs_btree_cur *rcur, int error);
> @@ -45,12 +45,10 @@ extern int xfs_refcount_find_shared(struct xfs_btree_cur *cur,
>  		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
>  		xfs_extlen_t *flen, bool find_end_of_shared);
>  
> -extern int xfs_refcount_alloc_cow_extent(struct xfs_mount *mp,
> -		struct xfs_defer_ops *dfops, xfs_fsblock_t fsb,
> -		xfs_extlen_t len);
> -extern int xfs_refcount_free_cow_extent(struct xfs_mount *mp,
> -		struct xfs_defer_ops *dfops, xfs_fsblock_t fsb,
> -		xfs_extlen_t len);
> +extern int xfs_refcount_alloc_cow_extent(struct xfs_trans *tp,
> +		xfs_fsblock_t fsb, xfs_extlen_t len);
> +extern int xfs_refcount_free_cow_extent(struct xfs_trans *tp,
> +		xfs_fsblock_t fsb, xfs_extlen_t len);
>  extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
>  		xfs_agnumber_t agno);
>  
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index fb266fa2cc45..aa683eda6b70 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2277,14 +2277,14 @@ xfs_rmap_update_is_needed(
>   */
>  static int
>  __xfs_rmap_add(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> +	struct xfs_trans		*tp,
>  	enum xfs_rmap_intent_type	type,
>  	uint64_t			owner,
>  	int				whichfork,
>  	struct xfs_bmbt_irec		*bmap)
>  {
> -	struct xfs_rmap_intent	*ri;
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_rmap_intent		*ri;
>  
>  	trace_xfs_rmap_defer(mp, XFS_FSB_TO_AGNO(mp, bmap->br_startblock),
>  			type,
> @@ -2301,23 +2301,22 @@ __xfs_rmap_add(
>  	ri->ri_whichfork = whichfork;
>  	ri->ri_bmap = *bmap;
>  
> -	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
>  	return 0;
>  }
>  
>  /* Map an extent into a file. */
>  int
>  xfs_rmap_map_extent(
> -	struct xfs_mount	*mp,
> -	struct xfs_defer_ops	*dfops,
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
>  	struct xfs_bmbt_irec	*PREV)
>  {
> -	if (!xfs_rmap_update_is_needed(mp, whichfork))
> +	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
>  		return 0;
>  
> -	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
> +	return __xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
>  			XFS_RMAP_MAP_SHARED : XFS_RMAP_MAP, ip->i_ino,
>  			whichfork, PREV);
>  }
> @@ -2325,25 +2324,29 @@ xfs_rmap_map_extent(
>  /* Unmap an extent out of a file. */
>  int
>  xfs_rmap_unmap_extent(
> -	struct xfs_mount	*mp,
> -	struct xfs_defer_ops	*dfops,
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
>  	struct xfs_bmbt_irec	*PREV)
>  {
> -	if (!xfs_rmap_update_is_needed(mp, whichfork))
> +	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
>  		return 0;
>  
> -	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
> +	return __xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
>  			XFS_RMAP_UNMAP_SHARED : XFS_RMAP_UNMAP, ip->i_ino,
>  			whichfork, PREV);
>  }
>  
> -/* Convert a data fork extent from unwritten to real or vice versa. */
> +/*
> + * Convert a data fork extent from unwritten to real or vice versa.
> + *
> + * Note that tp can be NULL here as no transaction is used for COW fork
> + * unwritten conversion.
> + */
>  int
>  xfs_rmap_convert_extent(
>  	struct xfs_mount	*mp,
> -	struct xfs_defer_ops	*dfops,
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
>  	struct xfs_bmbt_irec	*PREV)
> @@ -2351,7 +2354,7 @@ xfs_rmap_convert_extent(
>  	if (!xfs_rmap_update_is_needed(mp, whichfork))
>  		return 0;
>  
> -	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
> +	return __xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
>  			XFS_RMAP_CONVERT_SHARED : XFS_RMAP_CONVERT, ip->i_ino,
>  			whichfork, PREV);
>  }
> @@ -2359,8 +2362,7 @@ xfs_rmap_convert_extent(
>  /* Schedule the creation of an rmap for non-file data. */
>  int
>  xfs_rmap_alloc_extent(
> -	struct xfs_mount	*mp,
> -	struct xfs_defer_ops	*dfops,
> +	struct xfs_trans	*tp,
>  	xfs_agnumber_t		agno,
>  	xfs_agblock_t		bno,
>  	xfs_extlen_t		len,
> @@ -2368,23 +2370,21 @@ xfs_rmap_alloc_extent(
>  {
>  	struct xfs_bmbt_irec	bmap;
>  
> -	if (!xfs_rmap_update_is_needed(mp, XFS_DATA_FORK))
> +	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
>  		return 0;
>  
> -	bmap.br_startblock = XFS_AGB_TO_FSB(mp, agno, bno);
> +	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
>  	bmap.br_blockcount = len;
>  	bmap.br_startoff = 0;
>  	bmap.br_state = XFS_EXT_NORM;
>  
> -	return __xfs_rmap_add(mp, dfops, XFS_RMAP_ALLOC, owner,
> -			XFS_DATA_FORK, &bmap);
> +	return __xfs_rmap_add(tp, XFS_RMAP_ALLOC, owner, XFS_DATA_FORK, &bmap);
>  }
>  
>  /* Schedule the deletion of an rmap for non-file data. */
>  int
>  xfs_rmap_free_extent(
> -	struct xfs_mount	*mp,
> -	struct xfs_defer_ops	*dfops,
> +	struct xfs_trans	*tp,
>  	xfs_agnumber_t		agno,
>  	xfs_agblock_t		bno,
>  	xfs_extlen_t		len,
> @@ -2392,16 +2392,15 @@ xfs_rmap_free_extent(
>  {
>  	struct xfs_bmbt_irec	bmap;
>  
> -	if (!xfs_rmap_update_is_needed(mp, XFS_DATA_FORK))
> +	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
>  		return 0;
>  
> -	bmap.br_startblock = XFS_AGB_TO_FSB(mp, agno, bno);
> +	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
>  	bmap.br_blockcount = len;
>  	bmap.br_startoff = 0;
>  	bmap.br_state = XFS_EXT_NORM;
>  
> -	return __xfs_rmap_add(mp, dfops, XFS_RMAP_FREE, owner,
> -			XFS_DATA_FORK, &bmap);
> +	return __xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
>  }
>  
>  /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
> diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> index 9f19454768b2..157dc722ad35 100644
> --- a/fs/xfs/libxfs/xfs_rmap.h
> +++ b/fs/xfs/libxfs/xfs_rmap.h
> @@ -185,21 +185,17 @@ struct xfs_rmap_intent {
>  };
>  
>  /* functions for updating the rmapbt based on bmbt map/unmap operations */
> -int xfs_rmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> +int xfs_rmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
> +		int whichfork, struct xfs_bmbt_irec *imap);
> +int xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
> +		int whichfork, struct xfs_bmbt_irec *imap);
> +int xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
>  		struct xfs_inode *ip, int whichfork,
>  		struct xfs_bmbt_irec *imap);
> -int xfs_rmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> -		struct xfs_inode *ip, int whichfork,
> -		struct xfs_bmbt_irec *imap);
> -int xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> -		struct xfs_inode *ip, int whichfork,
> -		struct xfs_bmbt_irec *imap);
> -int xfs_rmap_alloc_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> -		xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
> -		uint64_t owner);
> -int xfs_rmap_free_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> -		xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
> -		uint64_t owner);
> +int xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
> +		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
> +int xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
> +		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
>  
>  void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
>  		struct xfs_btree_cur *rcur, int error);
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 328a5c60000b..ffe42147a032 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -486,8 +486,7 @@ xfs_bui_recover(
>  		irec.br_blockcount = count;
>  		irec.br_startoff = bmap->me_startoff;
>  		irec.br_state = state;
> -		error = xfs_bmap_unmap_extent(tp->t_mountp, tp->t_dfops, ip,
> -					      &irec);
> +		error = xfs_bmap_unmap_extent(tp, ip, &irec);
>  		if (error)
>  			goto err_inode;
>  	}
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index d9dad399440a..addbd74ecd8e 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1534,7 +1534,6 @@ xfs_swap_extent_rmap(
>  	struct xfs_inode		*tip)
>  {
>  	struct xfs_trans		*tp = *tpp;
> -	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_bmbt_irec		irec;
>  	struct xfs_bmbt_irec		uirec;
>  	struct xfs_bmbt_irec		tirec;
> @@ -1598,26 +1597,22 @@ xfs_swap_extent_rmap(
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
>  
>  			/* Remove the mapping from the donor file. */
> -			error = xfs_bmap_unmap_extent(mp, tp->t_dfops, tip,
> -					&uirec);
> +			error = xfs_bmap_unmap_extent(tp, tip, &uirec);
>  			if (error)
>  				goto out_defer;
>  
>  			/* Remove the mapping from the source file. */
> -			error = xfs_bmap_unmap_extent(mp, tp->t_dfops, ip,
> -					&irec);
> +			error = xfs_bmap_unmap_extent(tp, ip, &irec);
>  			if (error)
>  				goto out_defer;
>  
>  			/* Map the donor file's blocks into the source file. */
> -			error = xfs_bmap_map_extent(mp, tp->t_dfops, ip,
> -					&uirec);
> +			error = xfs_bmap_map_extent(tp, ip, &uirec);
>  			if (error)
>  				goto out_defer;
>  
>  			/* Map the source file's blocks into the donor file. */
> -			error = xfs_bmap_map_extent(mp, tp->t_dfops, tip,
> -					&irec);
> +			error = xfs_bmap_map_extent(tp, tip, &irec);
>  			if (error)
>  				goto out_defer;
>  
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index f6a3249aa2d4..c626fc5d3464 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -490,24 +490,18 @@ xfs_cui_recover(
>  			irec.br_blockcount = new_len;
>  			switch (type) {
>  			case XFS_REFCOUNT_INCREASE:
> -				error = xfs_refcount_increase_extent(
> -						tp->t_mountp, tp->t_dfops,
> -						&irec);
> +				error = xfs_refcount_increase_extent(tp, &irec);
>  				break;
>  			case XFS_REFCOUNT_DECREASE:
> -				error = xfs_refcount_decrease_extent(
> -						tp->t_mountp, tp->t_dfops,
> -						&irec);
> +				error = xfs_refcount_decrease_extent(tp, &irec);
>  				break;
>  			case XFS_REFCOUNT_ALLOC_COW:
> -				error = xfs_refcount_alloc_cow_extent(
> -						tp->t_mountp, tp->t_dfops,
> +				error = xfs_refcount_alloc_cow_extent(tp,
>  						irec.br_startblock,
>  						irec.br_blockcount);
>  				break;
>  			case XFS_REFCOUNT_FREE_COW:
> -				error = xfs_refcount_free_cow_extent(
> -						tp->t_mountp, tp->t_dfops,
> +				error = xfs_refcount_free_cow_extent(tp,
>  						irec.br_startblock,
>  						irec.br_blockcount);
>  				break;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 2ec562d75494..cbceb320a2e7 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -506,15 +506,13 @@ xfs_reflink_cancel_cow_blocks(
>  			ASSERT((*tpp)->t_firstblock == NULLFSBLOCK);
>  
>  			/* Free the CoW orphan record. */
> -			error = xfs_refcount_free_cow_extent(ip->i_mount,
> -					(*tpp)->t_dfops, del.br_startblock,
> -					del.br_blockcount);
> +			error = xfs_refcount_free_cow_extent(*tpp,
> +					del.br_startblock, del.br_blockcount);
>  			if (error)
>  				break;
>  
> -			xfs_bmap_add_free(ip->i_mount, (*tpp)->t_dfops,
> -					del.br_startblock, del.br_blockcount,
> -					NULL);
> +			xfs_bmap_add_free(*tpp, del.br_startblock,
> +					  del.br_blockcount, NULL);
>  
>  			/* Roll the transaction */
>  			error = xfs_defer_finish(tpp);
> @@ -694,14 +692,13 @@ xfs_reflink_end_cow(
>  		trace_xfs_reflink_cow_remap(ip, &del);
>  
>  		/* Free the CoW orphan record. */
> -		error = xfs_refcount_free_cow_extent(tp->t_mountp, tp->t_dfops,
> -				del.br_startblock, del.br_blockcount);
> +		error = xfs_refcount_free_cow_extent(tp, del.br_startblock,
> +				del.br_blockcount);
>  		if (error)
>  			goto out_cancel;
>  
>  		/* Map the new blocks into the data fork. */
> -		error = xfs_bmap_map_extent(tp->t_mountp, tp->t_dfops, ip,
> -					    &del);
> +		error = xfs_bmap_map_extent(tp, ip, &del);
>  		if (error)
>  			goto out_cancel;
>  
> @@ -1046,12 +1043,12 @@ xfs_reflink_remap_extent(
>  				uirec.br_blockcount, uirec.br_startblock);
>  
>  		/* Update the refcount tree */
> -		error = xfs_refcount_increase_extent(mp, tp->t_dfops, &uirec);
> +		error = xfs_refcount_increase_extent(tp, &uirec);
>  		if (error)
>  			goto out_cancel;
>  
>  		/* Map the new blocks into the data fork. */
> -		error = xfs_bmap_map_extent(mp, tp->t_dfops, ip, &uirec);
> +		error = xfs_bmap_map_extent(tp, ip, &uirec);
>  		if (error)
>  			goto out_cancel;
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
