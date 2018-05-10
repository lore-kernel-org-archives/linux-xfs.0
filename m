Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59752 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965017AbeEJQil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 12:38:41 -0400
Date: Thu, 10 May 2018 09:38:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: factor out nodiscard helpers
Message-ID: <20180510163820.GE11261@magnolia>
References: <20180510125223.77364-1-bfoster@redhat.com>
 <20180510140732.82824-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510140732.82824-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 10, 2018 at 10:07:32AM -0400, Brian Foster wrote:
> The changes to skip discards of speculative preallocation and
> unwritten extents introduced several new wrapper functions through
> the bunmapi -> extent free codepath to reduce churn in all of the
> associated callers. In several cases, these wrappers simply toggle a
> single flag to skip or not skip discards for the resulting blocks.
> 
> The explicit _nodiscard() wrappers for such an isolated set of
> callers is a bit overkill. Kill off these wrappers and replace with
> the calls to the underlying functions in the contexts that need to
> control discard behavior. Retain the wrappers that preserve the
> original calling conventions to serve the original purpose of
> reducing code churn.
> 
> This is a refactoring patch and does not change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> v2:
> - Clean up xfs_bmap_del_extent_real().
> v1: https://marc.info/?l=linux-xfs&m=152595674924579&w=2
> 
>  fs/xfs/libxfs/xfs_alloc.h  | 11 -----------
>  fs/xfs/libxfs/xfs_bmap.c   | 13 ++++---------
>  fs/xfs/libxfs/xfs_bmap.h   | 11 -----------
>  fs/xfs/xfs_bmap_util.c     |  4 ++--
>  fs/xfs/xfs_inode.c         |  9 +++------
>  fs/xfs/xfs_inode.h         | 16 +++-------------
>  fs/xfs/xfs_trans_extfree.c |  9 ++-------
>  7 files changed, 14 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 4a8e8dcaf352..21e5c0662a92 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -210,17 +210,6 @@ xfs_free_extent(
>  	return __xfs_free_extent(tp, bno, len, oinfo, type, false);
>  }
>  
> -static inline int
> -xfs_free_extent_nodiscard(
> -	struct xfs_trans	*tp,
> -	xfs_fsblock_t		bno,
> -	xfs_extlen_t		len,
> -	struct xfs_owner_info	*oinfo,
> -	enum xfs_ag_resv_type	type)
> -{
> -	return __xfs_free_extent(tp, bno, len, oinfo, type, true);
> -}
> -
>  int				/* error */
>  xfs_alloc_lookup_le(
>  	struct xfs_btree_cur	*cur,	/* btree cursor */
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 24f60ee810e4..91659dfe93ee 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5107,15 +5107,10 @@ xfs_bmap_del_extent_real(
>  			if (error)
>  				goto done;
>  		} else {
> -			if ((bflags & XFS_BMAPI_NODISCARD) ||
> -			    (del->br_state == XFS_EXT_UNWRITTEN)) {
> -				xfs_bmap_add_free_nodiscard(mp, dfops,
> -					del->br_startblock, del->br_blockcount,
> -					NULL);
> -			} else {
> -				xfs_bmap_add_free(mp, dfops, del->br_startblock,
> -					del->br_blockcount, NULL);
> -			}
> +			__xfs_bmap_add_free(mp, dfops, del->br_startblock,
> +					del->br_blockcount, NULL,
> +					(bflags & XFS_BMAPI_NODISCARD) ||
> +					del->br_state == XFS_EXT_UNWRITTEN);
>  		}
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 8d8946bfdd8c..8affd3915a11 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -256,17 +256,6 @@ xfs_bmap_add_free(
>  	__xfs_bmap_add_free(mp, dfops, bno, len, oinfo, false);
>  }
>  
> -static inline void
> -xfs_bmap_add_free_nodiscard(
> -	struct xfs_mount		*mp,
> -	struct xfs_defer_ops		*dfops,
> -	xfs_fsblock_t			bno,
> -	xfs_filblks_t			len,
> -	struct xfs_owner_info		*oinfo)
> -{
> -	__xfs_bmap_add_free(mp, dfops, bno, len, oinfo, true);
> -}
> -
>  enum xfs_bmap_intent_type {
>  	XFS_BMAP_MAP = 1,
>  	XFS_BMAP_UNMAP,
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 696c3b6bd2c9..11058459ea98 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -871,8 +871,8 @@ xfs_free_eofblocks(
>  		 * contents of the file are flushed to disk then the files
>  		 * may be full of holes (ie NULL files bug).
>  		 */
> -		error = xfs_itruncate_extents_nodiscard(&tp, ip, XFS_DATA_FORK,
> -							XFS_ISIZE(ip));
> +		error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
> +					XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
>  		if (error) {
>  			/*
>  			 * If we get an error at this point we simply don't
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d63ddd806074..3c54f09fee4e 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1534,12 +1534,12 @@ xfs_itruncate_clear_reflink_flags(
>   * dirty on error so that transactions can be easily aborted if possible.
>   */
>  int
> -__xfs_itruncate_extents(
> +xfs_itruncate_extents_flags(
>  	struct xfs_trans	**tpp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
>  	xfs_fsize_t		new_size,
> -	bool			skip_discard)
> +	int			flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp = *tpp;
> @@ -1550,7 +1550,6 @@ __xfs_itruncate_extents(
>  	xfs_filblks_t		unmap_len;
>  	int			error = 0;
>  	int			done = 0;
> -	int			flags;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
> @@ -1563,9 +1562,7 @@ __xfs_itruncate_extents(
>  
>  	trace_xfs_itruncate_extents_start(ip, new_size);
>  
> -	flags = xfs_bmapi_aflag(whichfork);
> -	if (skip_discard)
> -		flags |= XFS_BMAPI_NODISCARD;
> +	flags |= xfs_bmapi_aflag(whichfork);
>  
>  	/*
>  	 * Since it is possible for space to become allocated beyond
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 3dd3201f4409..00fee6824745 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -415,8 +415,8 @@ uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
>  uint		xfs_ip2xflags(struct xfs_inode *);
>  int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
>  			   struct xfs_defer_ops *);
> -int		__xfs_itruncate_extents(struct xfs_trans **, struct xfs_inode *,
> -				        int, xfs_fsize_t, bool);
> +int		xfs_itruncate_extents_flags(struct xfs_trans **,
> +				struct xfs_inode *, int, xfs_fsize_t, int);
>  void		xfs_iext_realloc(xfs_inode_t *, int, int);
>  
>  void		xfs_iunpin_wait(xfs_inode_t *);
> @@ -440,17 +440,7 @@ xfs_itruncate_extents(
>  	int			whichfork,
>  	xfs_fsize_t		new_size)
>  {
> -	return __xfs_itruncate_extents(tpp, ip, whichfork, new_size, false);
> -}
> -
> -static inline int
> -xfs_itruncate_extents_nodiscard(
> -	struct xfs_trans	**tpp,
> -	struct xfs_inode	*ip,
> -	int			whichfork,
> -	xfs_fsize_t		new_size)
> -{
> -	return __xfs_itruncate_extents(tpp, ip, whichfork, new_size, true);
> +	return xfs_itruncate_extents_flags(tpp, ip, whichfork, new_size, 0);
>  }
>  
>  /* from xfs_file.c */
> diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> index dab8b3b7a9b8..5e137ee826ff 100644
> --- a/fs/xfs/xfs_trans_extfree.c
> +++ b/fs/xfs/xfs_trans_extfree.c
> @@ -80,13 +80,8 @@ xfs_trans_free_extent(
>  
>  	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno, ext_len);
>  
> -	if (skip_discard)
> -		error = xfs_free_extent_nodiscard(tp, start_block, ext_len,
> -						  oinfo, XFS_AG_RESV_NONE);
> -	else
> -		error = xfs_free_extent(tp, start_block, ext_len, oinfo,
> -					XFS_AG_RESV_NONE);
> -
> +	error = __xfs_free_extent(tp, start_block, ext_len,
> +				  oinfo, XFS_AG_RESV_NONE, skip_discard);
>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the
>  	 * transaction is aborted, which:
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
