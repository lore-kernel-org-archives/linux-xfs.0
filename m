Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31896 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754037AbdJaWfx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 18:35:53 -0400
Date: Tue, 31 Oct 2017 15:35:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/18] xfs: remove the nr_extents argument to
 xfs_iext_insert
Message-ID: <20171031223549.GZ4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-18-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-18-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:29PM +0200, Christoph Hellwig wrote:
> We only have two places that insert 2 extents at the same time, so unroll
> the loop there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 31 ++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_iext_tree.c  | 31 ++++++++-----------------------
>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
>  4 files changed, 26 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 46bda00dca79..b832dc402f40 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -900,7 +900,7 @@ xfs_bmap_local_to_extents(
>  	rec.br_blockcount = 1;
>  	rec.br_state = XFS_EXT_NORM;
>  	xfs_iext_first(ifp, &ext);
> -	xfs_iext_insert(ip, &ext, 1, &rec, 0);
> +	xfs_iext_insert(ip, &ext, &rec, 0);
>  
>  	XFS_IFORK_NEXT_SET(ip, whichfork, 1);
>  	ip->i_d.di_nblocks = 1;
> @@ -1272,7 +1272,7 @@ xfs_iread_extents(
>  				goto out_brelse;
>  			}
>  			xfs_bmbt_disk_get_all(frp, &new);
> -			xfs_iext_insert(ip, &ext, 1, &new, state);
> +			xfs_iext_insert(ip, &ext, &new, state);
>  			trace_xfs_read_extent(ip, &ext, state, _THIS_IP_);
>  			xfs_iext_next(ifp, &ext);
>  		}
> @@ -1828,7 +1828,7 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_blockcount = temp;
>  		PREV.br_startblock = nullstartblock(da_new);
>  		xfs_iext_next(ifp, &bma->ext);
> -		xfs_iext_insert(bma->ip, &bma->ext, 1, &PREV, state);
> +		xfs_iext_insert(bma->ip, &bma->ext, &PREV, state);
>  		xfs_iext_prev(ifp, &bma->ext);
>  		break;
>  
> @@ -1904,7 +1904,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  		PREV.br_startblock = nullstartblock(da_new);
>  		PREV.br_blockcount = temp;
> -		xfs_iext_insert(bma->ip, &bma->ext, 1, &PREV, state);
> +		xfs_iext_insert(bma->ip, &bma->ext, &PREV, state);
>  		xfs_iext_next(ifp, &bma->ext);
>  		break;
>  
> @@ -1950,9 +1950,9 @@ xfs_bmap_add_extent_delay_real(
>  					PREV.br_blockcount));
>  		xfs_iext_update_extent(bma->ip, state, &bma->ext, &PREV);
>  
> -		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
>  		xfs_iext_next(ifp, &bma->ext);
> -		xfs_iext_insert(bma->ip, &bma->ext, 2, &LEFT, state);
> +		xfs_iext_insert(bma->ip, &bma->ext, &RIGHT, state);
> +		xfs_iext_insert(bma->ip, &bma->ext, &LEFT, state);
>  		(*nextents)++;
>  
>  		if (bma->cur == NULL)
> @@ -2316,7 +2316,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		PREV.br_blockcount -= new->br_blockcount;
>  
>  		xfs_iext_update_extent(ip, state, ext, &PREV);
> -		xfs_iext_insert(ip, ext, 1, new, state);
> +		xfs_iext_insert(ip, ext, new, state);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
>  		if (cur == NULL)
> @@ -2383,7 +2383,7 @@ xfs_bmap_add_extent_unwritten_real(
>  
>  		xfs_iext_update_extent(ip, state, ext, &PREV);
>  		xfs_iext_next(ifp, ext);
> -		xfs_iext_insert(ip, ext, 1, new, state);
> +		xfs_iext_insert(ip, ext, new, state);
>  
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
> @@ -2426,7 +2426,8 @@ xfs_bmap_add_extent_unwritten_real(
>  
>  		xfs_iext_update_extent(ip, state, ext, &PREV);
>  		xfs_iext_next(ifp, ext);
> -		xfs_iext_insert(ip, ext, 2, &r[0], state);
> +		xfs_iext_insert(ip, ext, &r[1], state);
> +		xfs_iext_insert(ip, ext, &r[0], state);
>  
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  				XFS_IFORK_NEXTENTS(ip, whichfork) + 2);
> @@ -2634,7 +2635,7 @@ xfs_bmap_add_extent_hole_delay(
>  		 * Insert a new entry.
>  		 */
>  		oldlen = newlen = 0;
> -		xfs_iext_insert(ip, ext, 1, new, state);
> +		xfs_iext_insert(ip, ext, new, state);
>  		break;
>  	}
>  	if (oldlen != newlen) {
> @@ -2818,7 +2819,7 @@ xfs_bmap_add_extent_hole_real(
>  		 * real allocation.
>  		 * Insert a new entry.
>  		 */
> -		xfs_iext_insert(ip, ext, 1, new, state);
> +		xfs_iext_insert(ip, ext, new, state);
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
>  		if (cur == NULL) {
> @@ -4741,7 +4742,7 @@ xfs_bmap_del_extent_delay(
>  
>  		xfs_iext_update_extent(ip, state, ext, got);
>  		xfs_iext_next(ifp, ext);
> -		xfs_iext_insert(ip, ext, 1, &new, state);
> +		xfs_iext_insert(ip, ext, &new, state);
>  
>  		da_new = got_indlen + new_indlen - stolen;
>  		del->br_blockcount -= stolen;
> @@ -4822,7 +4823,7 @@ xfs_bmap_del_extent_cow(
>  
>  		xfs_iext_update_extent(ip, state, ext, got);
>  		xfs_iext_next(ifp, ext);
> -		xfs_iext_insert(ip, ext, 1, &new, state);
> +		xfs_iext_insert(ip, ext, &new, state);
>  		break;
>  	}
>  }
> @@ -5035,7 +5036,7 @@ xfs_bmap_del_extent_real(
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
>  		xfs_iext_next(ifp, ext);
> -		xfs_iext_insert(ip, ext, 1, &new, state);
> +		xfs_iext_insert(ip, ext, &new, state);
>  		break;
>  	}
>  
> @@ -5896,7 +5897,7 @@ xfs_bmap_split_extent_at(
>  
>  	/* Add new extent */
>  	xfs_iext_next(ifp, &ext);
> -	xfs_iext_insert(ip, &ext, 1, &new, 0);
> +	xfs_iext_insert(ip, &ext, &new, 0);
>  	XFS_IFORK_NEXT_SET(ip, whichfork,
>  			   XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
>  
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index acb66c0677e7..c109526e52c5 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -627,16 +627,20 @@ xfs_iext_realloc_root(
>  	cur->leaf = new;
>  }
>  
> -static void
> -__xfs_iext_insert(
> -	struct xfs_ifork	*ifp,
> +void
> +xfs_iext_insert(
> +	struct xfs_inode	*ip,
>  	struct xfs_iext_cursor	*cur,
> -	struct xfs_bmbt_irec	*irec)
> +	struct xfs_bmbt_irec	*irec,
> +	int			state)
>  {
> +	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
>  	xfs_fileoff_t		offset = irec->br_startoff;
>  	struct xfs_iext_leaf	*new = NULL;
>  	int			nr_entries, i;
>  
> +	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
> +
>  	if (ifp->if_height == 0)
>  		xfs_iext_alloc_root(ifp, cur);
>  	else if (ifp->if_height == 1)
> @@ -664,25 +668,6 @@ __xfs_iext_insert(
>  		xfs_iext_insert_node(ifp, xfs_iext_leaf_key(new, 0), new, 2);
>  }
>  
> -void
> -xfs_iext_insert(
> -	struct xfs_inode	*ip,
> -	struct xfs_iext_cursor	*cur,
> -	xfs_extnum_t		nr_extents,
> -	struct xfs_bmbt_irec	*new,
> -	int			state)
> -{
> -	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
> -	int			i;
> -
> -	ASSERT(nr_extents > 0);
> -
> -	for (i = nr_extents - 1; i >= 0; i--) {
> -		__xfs_iext_insert(ifp, cur, new + i);
> -		trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
> -	}
> -}
> -
>  static struct xfs_iext_node *
>  xfs_iext_rebalance_node(
>  	struct xfs_iext_node	*parent,
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 2711ff6ab2b3..dca5dcec2cd4 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -362,7 +362,7 @@ xfs_iformat_extents(
>  			}
>  
>  			xfs_bmbt_disk_get_all(dp, &new);
> -			xfs_iext_insert(ip, &ext, 1, &new, state);
> +			xfs_iext_insert(ip, &ext, &new, state);
>  			trace_xfs_read_extent(ip, &ext, state, _THIS_IP_);
>  			xfs_iext_next(ifp, &ext);
>  		}
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 015872caaab4..cc73fea4e37e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -114,7 +114,7 @@ void		xfs_init_local_fork(struct xfs_inode *, int, const void *, int);
>  
>  xfs_extnum_t	xfs_iext_count(struct xfs_ifork *ifp);
>  void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
> -			xfs_extnum_t, struct xfs_bmbt_irec *, int);
> +			struct xfs_bmbt_irec *, int);
>  void		xfs_iext_remove(struct xfs_inode *, struct xfs_iext_cursor *,
>  			int, int);
>  void		xfs_iext_destroy(struct xfs_ifork *);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
