Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29284 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753813AbdJSWsp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 18:48:45 -0400
Date: Thu, 19 Oct 2017 15:48:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/15] xfs: add a xfs_bmap_fork_to_state helper
Message-ID: <20171019224839.GQ4755@magnolia>
References: <20171019065942.18813-1-hch@lst.de>
 <20171019065942.18813-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019065942.18813-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 08:59:28AM +0200, Christoph Hellwig wrote:
> This creates the right initial bmap state from the passed in inode
> fork enum.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 45 +++++++++------------------------------------
>  fs/xfs/libxfs/xfs_bmap.h | 12 ++++++++++++
>  2 files changed, 21 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6c2ae3011964..676fc8aed67f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -499,12 +499,7 @@ xfs_bmap_trace_exlist(
>  {
>  	xfs_extnum_t	idx;		/* extent record index */
>  	xfs_ifork_t	*ifp;		/* inode fork pointer */
> -	int		state = 0;
> -
> -	if (whichfork == XFS_ATTR_FORK)
> -		state |= BMAP_ATTRFORK;
> -	else if (whichfork == XFS_COW_FORK)
> -		state |= BMAP_COWFORK;
> +	int		state = xfs_bmap_fork_to_state(whichfork);
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	ASSERT(cnt == xfs_iext_count(ifp));
> @@ -925,8 +920,7 @@ xfs_bmap_local_to_extents(
>  	rec.br_state = XFS_EXT_NORM;
>  	xfs_iext_insert(ip, 0, 1, &rec, 0);
>  
> -	trace_xfs_bmap_post_update(ip, 0,
> -			whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0,
> +	trace_xfs_bmap_post_update(ip, 0, xfs_bmap_fork_to_state(whichfork),
>  			_THIS_IP_);
>  	XFS_IFORK_NEXT_SET(ip, whichfork, 1);
>  	ip->i_d.di_nblocks = 1;
> @@ -1571,7 +1565,7 @@ xfs_bmap_add_extent_delay_real(
>  	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
>  					/* left is 0, right is 1, prev is 2 */
>  	int			rval=0;	/* return value (logging flags) */
> -	int			state = 0;/* state bits, accessed thru macros */
> +	int			state = xfs_bmap_fork_to_state(whichfork);
>  	xfs_filblks_t		da_new; /* new count del alloc blocks used */
>  	xfs_filblks_t		da_old; /* old count del alloc blocks used */
>  	xfs_filblks_t		temp=0;	/* value for da_new calculations */
> @@ -1598,9 +1592,6 @@ xfs_bmap_add_extent_delay_real(
>  #define	RIGHT		r[1]
>  #define	PREV		r[2]
>  
> -	if (whichfork == XFS_COW_FORK)
> -		state |= BMAP_COWFORK;
> -
>  	/*
>  	 * Set up a bunch of variables to make the tests simpler.
>  	 */
> @@ -2108,7 +2099,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
>  					/* left is 0, right is 1, prev is 2 */
>  	int			rval=0;	/* return value (logging flags) */
> -	int			state = 0;/* state bits, accessed thru macros */
> +	int			state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_bmbt_irec	old;
>  
> @@ -2116,8 +2107,6 @@ xfs_bmap_add_extent_unwritten_real(
>  
>  	cur = *curp;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	if (whichfork == XFS_COW_FORK)
> -		state |= BMAP_COWFORK;
>  
>  	ASSERT(*idx >= 0);
>  	ASSERT(*idx <= xfs_iext_count(ifp));
> @@ -2601,13 +2590,10 @@ xfs_bmap_add_extent_hole_delay(
>  	xfs_filblks_t		newlen=0;	/* new indirect size */
>  	xfs_filblks_t		oldlen=0;	/* old indirect size */
>  	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
> -	int			state;  /* state bits, accessed thru macros */
> +	int			state = xfs_bmap_fork_to_state(whichfork);
>  	xfs_filblks_t		temp;	 /* temp for indirect calculations */
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	state = 0;
> -	if (whichfork == XFS_COW_FORK)
> -		state |= BMAP_COWFORK;
>  	ASSERT(isnullstartblock(new->br_startblock));
>  
>  	/*
> @@ -2760,7 +2746,7 @@ xfs_bmap_add_extent_hole_real(
>  	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
>  	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
>  	int			rval=0;	/* return value (logging flags) */
> -	int			state;	/* state bits, accessed thru macros */
> +	int			state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_bmbt_irec	old;
>  
>  	ASSERT(*idx >= 0);
> @@ -2770,12 +2756,6 @@ xfs_bmap_add_extent_hole_real(
>  
>  	XFS_STATS_INC(mp, xs_add_exlist);
>  
> -	state = 0;
> -	if (whichfork == XFS_ATTR_FORK)
> -		state |= BMAP_ATTRFORK;
> -	if (whichfork == XFS_COW_FORK)
> -		state |= BMAP_COWFORK;
> -
>  	/*
>  	 * Check and set flags if this segment has a left neighbor.
>  	 */
> @@ -4737,7 +4717,8 @@ xfs_bmap_del_extent_delay(
>  	int64_t			da_old, da_new, da_diff = 0;
>  	xfs_fileoff_t		del_endoff, got_endoff;
>  	xfs_filblks_t		got_indlen, new_indlen, stolen;
> -	int			error = 0, state = 0;
> +	int			state = xfs_bmap_fork_to_state(whichfork);
> +	int			error = 0;
>  	bool			isrt;
>  
>  	XFS_STATS_INC(mp, xs_del_exlist);
> @@ -4773,9 +4754,6 @@ xfs_bmap_del_extent_delay(
>  		return error;
>  	ip->i_delayed_blks -= del->br_blockcount;
>  
> -	if (whichfork == XFS_COW_FORK)
> -		state |= BMAP_COWFORK;
> -
>  	if (got->br_startoff == del->br_startoff)
>  		state |= BMAP_LEFT_FILLING;
>  	if (got_endoff == del_endoff)
> @@ -4969,17 +4947,12 @@ xfs_bmap_del_extent_real(
>  	xfs_bmbt_irec_t		new;	/* new record to be inserted */
>  	/* REFERENCED */
>  	uint			qfield;	/* quota field to update */
> -	int			state = 0;
> +	int			state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_bmbt_irec	old;
>  
>  	mp = ip->i_mount;
>  	XFS_STATS_INC(mp, xs_del_exlist);
>  
> -	if (whichfork == XFS_ATTR_FORK)
> -		state |= BMAP_ATTRFORK;
> -	else if (whichfork == XFS_COW_FORK)
> -		state |= BMAP_COWFORK;
> -
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	ASSERT((*idx >= 0) && (*idx < xfs_iext_count(ifp)));
>  	ASSERT(del->br_blockcount > 0);
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 851982a5dfbc..a61c5480b6ad 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -277,4 +277,16 @@ int	xfs_bmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
>  int	xfs_bmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
>  		struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
>  
> +static inline int xfs_bmap_fork_to_state(int whichfork)
> +{
> +	switch (whichfork) {
> +	case XFS_ATTR_FORK:
> +		return BMAP_ATTRFORK;
> +	case XFS_COW_FORK:
> +		return BMAP_COWFORK;
> +	default:
> +		return 0;
> +	}
> +}
> +
>  #endif	/* __XFS_BMAP_H__ */
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
