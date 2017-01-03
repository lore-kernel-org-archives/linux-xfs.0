Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51681 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935599AbdACTYf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jan 2017 14:24:35 -0500
Date: Tue, 3 Jan 2017 11:24:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH, RFC] xfs: use per-AG reservations for the finobt
Message-ID: <20170103192426.GA14031@birch.djwong.org>
References: <1483107598-6779-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483107598-6779-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Fri, Dec 30, 2016 at 03:19:58PM +0100, Christoph Hellwig wrote:
> Currently we try to rely on the global reserved block pool for block
> allocations for the free inode btree, but I have customer reports
> (fairly complex workload, need to find an easier reproducer) where that
> is not enough as the AG where we free an inode that requires a new
> finobt block is entirely full.  This causes us to cancel a dirty
> transaction and thus a file system shutdown.
> 
> I think the right way to guard against this is to treat the finot the same
> way as the refcount btree and have a per-AG reservations for the possible
> worst case size of it, and the patch below implements that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c      |  6 +++
>  fs/xfs/libxfs/xfs_ialloc.h       |  1 -
>  fs/xfs/libxfs/xfs_ialloc_btree.c | 96 ++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_ialloc_btree.h |  3 ++
>  fs/xfs/libxfs/xfs_trans_space.h  |  3 --
>  fs/xfs/xfs_inode.c               | 25 ++---------
>  6 files changed, 105 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index e5ebc37..592754b 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -39,6 +39,7 @@
>  #include "xfs_rmap_btree.h"
>  #include "xfs_btree.h"
>  #include "xfs_refcount_btree.h"
> +#include "xfs_ialloc_btree.h"
>  
>  /*
>   * Per-AG Block Reservations
> @@ -236,6 +237,11 @@ xfs_ag_resv_init(
>  		if (error)
>  			goto out;
>  
> +		error = xfs_finobt_calc_reserves(pag->pag_mount,
> +				pag->pag_agno, &ask, &used);
> +		if (error)
> +			goto out;
> +
>  		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_METADATA,
>  				ask, used);
>  		if (error)
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 0bb8966..3f24725 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -168,5 +168,4 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
>  int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
>  		xfs_agnumber_t agno, struct xfs_buf **bpp);
>  
> -
>  #endif	/* __XFS_IALLOC_H__ */
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 0fd086d..3aba153 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -82,11 +82,12 @@ xfs_finobt_set_root(
>  }
>  
>  STATIC int
> -xfs_inobt_alloc_block(
> +__xfs_inobt_alloc_block(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_ptr	*start,
>  	union xfs_btree_ptr	*new,
> -	int			*stat)
> +	int			*stat,
> +	enum xfs_ag_resv_type	resv)
>  {
>  	xfs_alloc_arg_t		args;		/* block allocation args */
>  	int			error;		/* error return value */
> @@ -103,6 +104,7 @@ xfs_inobt_alloc_block(
>  	args.maxlen = 1;
>  	args.prod = 1;
>  	args.type = XFS_ALLOCTYPE_NEAR_BNO;
> +	args.resv = resv;
>  
>  	error = xfs_alloc_vextent(&args);
>  	if (error) {
> @@ -123,6 +125,27 @@ xfs_inobt_alloc_block(
>  }
>  
>  STATIC int
> +xfs_inobt_alloc_block(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*start,
> +	union xfs_btree_ptr	*new,
> +	int			*stat)
> +{
> +	return __xfs_inobt_alloc_block(cur, start, new, stat, XFS_AG_RESV_NONE);
> +}
> +
> +STATIC int
> +xfs_finobt_alloc_block(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*start,
> +	union xfs_btree_ptr	*new,
> +	int			*stat)
> +{
> +	return __xfs_inobt_alloc_block(cur, start, new, stat,
> +			XFS_AG_RESV_METADATA);
> +}
> +
> +STATIC int
>  xfs_inobt_free_block(
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_buf		*bp)
> @@ -328,7 +351,7 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
>  
>  	.dup_cursor		= xfs_inobt_dup_cursor,
>  	.set_root		= xfs_finobt_set_root,
> -	.alloc_block		= xfs_inobt_alloc_block,
> +	.alloc_block		= xfs_finobt_alloc_block,
>  	.free_block		= xfs_inobt_free_block,
>  	.get_minrecs		= xfs_inobt_get_minrecs,
>  	.get_maxrecs		= xfs_inobt_get_maxrecs,
> @@ -480,3 +503,70 @@ xfs_inobt_rec_check_count(
>  	return 0;
>  }
>  #endif	/* DEBUG */
> +
> +static xfs_extlen_t
> +xfs_inobt_calc_size(
> +	struct xfs_mount	*mp,
> +	unsigned long long	len)
> +{
> +	return xfs_btree_calc_size(mp, mp->m_inobt_mnr, len);

This call figures out worst-case how many blocks we need to store a
given number of records...

> +}
> +
> +static xfs_extlen_t
> +xfs_inobt_max_size(
> +	struct xfs_mount	*mp)
> +{
> +	/* Bail out if we're uninitialized, which can happen in mkfs. */
> +	if (mp->m_inobt_mxr[0] == 0)
> +		return 0;
> +
> +	return xfs_inobt_calc_size(mp, mp->m_sb.sb_agblocks);

...and so here we calculate the number of blocks needed to store the
maximum number of finobt records possible for an AG.  IIRC, each *inobt
record refers to a single chunk of 64 inodes (or at least a theoretical
chunk in the spinodes=1 case), so I think we can reduce the reservation
to...

nr = m_sb.sb_agblocks * m_sb.sb_inopblock / XFS_INODES_PER_CHUNK;
return xfs_inobt_calc_size(mp, nr);

...right?  For rmap/refcount the maximum number of records is the number
of blocks in the AG.

> +}
> +
> +static int
> +xfs_inobt_count_blocks(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_btnum_t		btnum,
> +	xfs_extlen_t		*tree_blocks)
> +{
> +	struct xfs_buf		*agbp;
> +	struct xfs_btree_cur	*cur;
> +	int			error;
> +
> +	error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
> +	if (error)
> +		return error;
> +
> +	cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno, btnum);
> +	error = xfs_btree_count_blocks(cur, tree_blocks);
> +	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_buf_relse(agbp);
> +
> +	return error;
> +}
> +
> +/*
> + * Figure out how many blocks to reserve and how many are used by this btree.
> + */
> +int
> +xfs_finobt_calc_reserves(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_extlen_t		*ask,
> +	xfs_extlen_t		*used)
> +{
> +	xfs_extlen_t		tree_len = 0;
> +	int			error;
> +
> +	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
> +		return 0;
> +
> +	error = xfs_inobt_count_blocks(mp, agno, XFS_BTNUM_FINO, &tree_len);

This requires us to traverse all the blocks in the finobt at mount time,
which isn't necessarily quick.  For refcount/rmap we cache the number of
tree blocks in the AGF to speed this up... but it was easy to sneak that
into the disk format. :)

For finobt I wonder if one could defer the block counting work to a
separate thread if the AG has enough free blocks to cover, say, 10x the
maximum reservation?  Though that could be racy and maybe finobts are
small enough that the impact on mount time is low anyway?


There's also the unsolved problem of what happens if we mount and find
agf_freeblks < (sum(ask) - sum(used)) -- right now we eat that state and
hope that we don't later ENOSPC and crash.  For reflink and rmap we will
have always had the AG reservation and therefore it should never happen
that we have fewer free blocks than reserved blocks.  (Unless the user
does something pathological like using CoW to create many billions of
separate rmap records...)

But as for retroactively adding AG reservations for an existing tree, I
guess we'll have to come up with a strategy for dealing with
insufficient free blocks.  I suppose one could try to use xfs_fsr to
move large contiguous extents to a less full AG, if there are any...

(I actually hit the "insufficient freeblks for AG reservation" case over
the holiday when I "upgraded" an XFS to rmap+reflink the foolish way and
neglected to ensure the free space...)

--D

> +	if (error)
> +		return error;
> +
> +	*ask += xfs_inobt_max_size(mp);
> +	*used += tree_len;
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
> index bd88453..aa81e2e 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
> @@ -72,4 +72,7 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
>  #define xfs_inobt_rec_check_count(mp, rec)	0
>  #endif	/* DEBUG */
>  
> +int xfs_finobt_calc_reserves(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		xfs_extlen_t *ask, xfs_extlen_t *used);
> +
>  #endif	/* __XFS_IALLOC_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index 7917f6e..6db3e2d 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -94,8 +94,5 @@
>  	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
>  #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
>  	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
> -#define XFS_IFREE_SPACE_RES(mp)		\
> -	(xfs_sb_version_hasfinobt(&mp->m_sb) ? (mp)->m_in_maxlevels : 0)
> -
>  
>  #endif	/* __XFS_TRANS_SPACE_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b955779..0283ab6 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1792,30 +1792,11 @@ xfs_inactive_ifree(
>  	int			error;
>  
>  	/*
> -	 * The ifree transaction might need to allocate blocks for record
> -	 * insertion to the finobt. We don't want to fail here at ENOSPC, so
> -	 * allow ifree to dip into the reserved block pool if necessary.
> -	 *
> -	 * Freeing large sets of inodes generally means freeing inode chunks,
> -	 * directory and file data blocks, so this should be relatively safe.
> -	 * Only under severe circumstances should it be possible to free enough
> -	 * inodes to exhaust the reserve block pool via finobt expansion while
> -	 * at the same time not creating free space in the filesystem.
> -	 *
> -	 * Send a warning if the reservation does happen to fail, as the inode
> -	 * now remains allocated and sits on the unlinked list until the fs is
> -	 * repaired.
> +	 * We use a per-AG reservation for any block needed by the finobt tree.
>  	 */
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree,
> -			XFS_IFREE_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree, 0, 0, 0, &tp);
>  	if (error) {
> -		if (error == -ENOSPC) {
> -			xfs_warn_ratelimited(mp,
> -			"Failed to remove inode(s) from unlinked list. "
> -			"Please free space, unmount and run xfs_repair.");
> -		} else {
> -			ASSERT(XFS_FORCED_SHUTDOWN(mp));
> -		}
> +		ASSERT(XFS_FORCED_SHUTDOWN(mp));
>  		return error;
>  	}
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
