Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32267 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdJaWhS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 18:37:18 -0400
Date: Tue, 31 Oct 2017 15:37:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/18] xfs: remove the nr_extents argument to
 xfs_iext_remove
Message-ID: <20171031223714.GA4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-19-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:30PM +0200, Christoph Hellwig wrote:
> We only have two places that remove 2 extents at the same time, so unroll
> the loop there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 31 ++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_iext_tree.c  | 40 ++++++++++++----------------------------
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
>  3 files changed, 27 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b832dc402f40..ce3cedd3f636 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1196,11 +1196,6 @@ xfs_iread_extents(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	ifp->if_bytes = 0;
> -	ifp->if_real_bytes = 0;
> -	ifp->if_u1.if_root = NULL;
> -	ifp->if_height = 0;

Landed in the wrong patch?

Other than that,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> -
>  	/*
>  	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
>  	 */
> @@ -1649,7 +1644,8 @@ xfs_bmap_add_extent_delay_real(
>  		 */
>  		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
>  
> -		xfs_iext_remove(bma->ip, &bma->ext, 2, state);
> +		xfs_iext_remove(bma->ip, &bma->ext, state);
> +		xfs_iext_remove(bma->ip, &bma->ext, state);
>  		xfs_iext_prev(ifp, &bma->ext);
>  		xfs_iext_update_extent(bma->ip, state, &bma->ext, &LEFT);
>  		(*nextents)--;
> @@ -1684,7 +1680,7 @@ xfs_bmap_add_extent_delay_real(
>  		old = LEFT;
>  		LEFT.br_blockcount += PREV.br_blockcount;
>  
> -		xfs_iext_remove(bma->ip, &bma->ext, 1, state);
> +		xfs_iext_remove(bma->ip, &bma->ext, state);
>  		xfs_iext_prev(ifp, &bma->ext);
>  		xfs_iext_update_extent(bma->ip, state, &bma->ext, &LEFT);
>  
> @@ -1711,7 +1707,7 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_blockcount += RIGHT.br_blockcount;
>  
>  		xfs_iext_next(ifp, &bma->ext);
> -		xfs_iext_remove(bma->ip, &bma->ext, 1, state);
> +		xfs_iext_remove(bma->ip, &bma->ext, state);
>  		xfs_iext_prev(ifp, &bma->ext);
>  		xfs_iext_update_extent(bma->ip, state, &bma->ext, &PREV);
>  
> @@ -2148,7 +2144,8 @@ xfs_bmap_add_extent_unwritten_real(
>  		 */
>  		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
>  
> -		xfs_iext_remove(ip, ext, 2, state);
> +		xfs_iext_remove(ip, ext, state);
> +		xfs_iext_remove(ip, ext, state);
>  		xfs_iext_prev(ifp, ext);
>  		xfs_iext_update_extent(ip, state, ext, &LEFT);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
> @@ -2186,7 +2183,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		 */
>  		LEFT.br_blockcount += PREV.br_blockcount;
>  
> -		xfs_iext_remove(ip, ext, 1, state);
> +		xfs_iext_remove(ip, ext, state);
>  		xfs_iext_prev(ifp, ext);
>  		xfs_iext_update_extent(ip, state, ext, &LEFT);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
> @@ -2220,7 +2217,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		PREV.br_state = new->br_state;
>  
>  		xfs_iext_next(ifp, ext);
> -		xfs_iext_remove(ip, ext, 1, state);
> +		xfs_iext_remove(ip, ext, state);
>  		xfs_iext_prev(ifp, ext);
>  		xfs_iext_update_extent(ip, state, ext, &PREV);
>  
> @@ -2587,7 +2584,7 @@ xfs_bmap_add_extent_hole_delay(
>  		left.br_startblock = nullstartblock(newlen);
>  		left.br_blockcount = temp;
>  
> -		xfs_iext_remove(ip, ext, 1, state);
> +		xfs_iext_remove(ip, ext, state);
>  		xfs_iext_prev(ifp, ext);
>  		xfs_iext_update_extent(ip, state, ext, &left);
>  		break;
> @@ -2732,7 +2729,7 @@ xfs_bmap_add_extent_hole_real(
>  		 */
>  		left.br_blockcount += new->br_blockcount + right.br_blockcount;
>  
> -		xfs_iext_remove(ip, ext, 1, state);
> +		xfs_iext_remove(ip, ext, state);
>  		xfs_iext_prev(ifp, ext);
>  		xfs_iext_update_extent(ip, state, ext, &left);
>  
> @@ -4690,7 +4687,7 @@ xfs_bmap_del_extent_delay(
>  		/*
>  		 * Matches the whole extent.  Delete the entry.
>  		 */
> -		xfs_iext_remove(ip, ext, 1, state);
> +		xfs_iext_remove(ip, ext, state);
>  		xfs_iext_prev(ifp, ext);
>  		break;
>  	case BMAP_LEFT_FILLING:
> @@ -4791,7 +4788,7 @@ xfs_bmap_del_extent_cow(
>  		/*
>  		 * Matches the whole extent.  Delete the entry.
>  		 */
> -		xfs_iext_remove(ip, ext, 1, state);
> +		xfs_iext_remove(ip, ext, state);
>  		xfs_iext_prev(ifp, ext);
>  		break;
>  	case BMAP_LEFT_FILLING:
> @@ -4931,7 +4928,7 @@ xfs_bmap_del_extent_real(
>  		/*
>  		 * Matches the whole extent.  Delete the entry.
>  		 */
> -		xfs_iext_remove(ip, ext, 1, state);
> +		xfs_iext_remove(ip, ext, state);
>  		xfs_iext_prev(ifp, ext);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> @@ -5557,7 +5554,7 @@ xfs_bmse_merge(
>  		return error;
>  
>  done:
> -	xfs_iext_remove(ip, ext, 1, 0);
> +	xfs_iext_remove(ip, ext, 0);
>  	xfs_iext_prev(XFS_IFORK_PTR(ip, whichfork), ext);
>  	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), ext,
>  			&new);
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index c109526e52c5..c18d344d46cd 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -162,12 +162,10 @@ static inline struct xfs_iext_rec *cur_rec(struct xfs_iext_cursor *cur)
>  static noinline bool xfs_iext_valid(struct xfs_ifork *ifp,
>  		struct xfs_iext_cursor *cur)
>  {
> -	if (cur->pos < 0)
> -		return false;
> -	if (cur->pos >= xfs_iext_max_recs(ifp))
> -		return false;
>  	if (!cur->leaf)
>  		return false;
> +	if (cur->pos < 0 || cur->pos >= xfs_iext_max_recs(ifp))
> +		return false;
>  	if (xfs_iext_rec_is_empty(cur_rec(cur)))
>  		return false;
>  	return true;
> @@ -256,8 +254,8 @@ xfs_iext_next(
>  	ASSERT(cur->pos < xfs_iext_max_recs(ifp));
>  
>  	cur->pos++;
> -	if (!xfs_iext_valid(ifp, cur) && ifp->if_height > 1 &&
> -	    cur->leaf && cur->leaf->next) {
> +	if (ifp->if_height > 1 && !xfs_iext_valid(ifp, cur) &&
> +	    cur->leaf->next) {
>  		cur->leaf = cur->leaf->next;
>  		cur->pos = 0;
>  	}
> @@ -826,15 +824,19 @@ xfs_iext_free_last_leaf(
>  	kmem_free(ifp->if_u1.if_root);
>  }
>  
> -static void
> -__xfs_iext_remove(
> -	struct xfs_ifork	*ifp,
> -	struct xfs_iext_cursor	*cur)
> +void
> +xfs_iext_remove(
> +	struct xfs_inode	*ip,
> +	struct xfs_iext_cursor	*cur,
> +	int			state)
>  {
> +	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
>  	struct xfs_iext_leaf	*leaf = cur->leaf;
>  	xfs_fileoff_t		offset = xfs_iext_leaf_key(leaf, 0);
>  	int			i, nr_entries;
>  
> +	trace_xfs_iext_remove(ip, cur, state, _RET_IP_);
> +
>  	ASSERT(ifp->if_height > 0);
>  	ASSERT(ifp->if_u1.if_root != NULL);
>  	ASSERT(xfs_iext_valid(ifp, cur));
> @@ -866,24 +868,6 @@ __xfs_iext_remove(
>  		xfs_iext_free_last_leaf(ifp);
>  }
>  
> -void
> -xfs_iext_remove(
> -	struct xfs_inode	*ip,
> -	struct xfs_iext_cursor	*cur,
> -	int			nr_extents,
> -	int			state)
> -{
> -	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
> -	int			i;
> -
> -	ASSERT(nr_extents > 0);
> -
> -	for (i = 0; i < nr_extents; i++) {
> -		trace_xfs_iext_remove(ip, cur, state, _RET_IP_);
> -		__xfs_iext_remove(ifp, cur);
> -	}
> -}
> -
>  /*
>   * Lookup the extent covering bno.
>   *
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index cc73fea4e37e..58da2ec262e3 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -116,7 +116,7 @@ xfs_extnum_t	xfs_iext_count(struct xfs_ifork *ifp);
>  void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
>  			struct xfs_bmbt_irec *, int);
>  void		xfs_iext_remove(struct xfs_inode *, struct xfs_iext_cursor *,
> -			int, int);
> +			int);
>  void		xfs_iext_destroy(struct xfs_ifork *);
>  
>  bool		xfs_iext_lookup_extent(struct xfs_inode *ip,
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
