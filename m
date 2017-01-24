Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750713AbdAXOGu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 09:06:50 -0500
Date: Tue, 24 Jan 2017 09:06:49 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: use per-AG reservations for the finobt
Message-ID: <20170124140649.GC60234@bfoster.bfoster>
References: <1485194742-23185-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485194742-23185-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 23, 2017 at 07:05:42PM +0100, Christoph Hellwig wrote:
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
> 
> ---
> 
> Changes since V1:
>  - reduce the size of the reservation
>  - warn and fall back to the old somewhat buggy code if we can't
>    get the reservation at mount time
>  - read the AGF before asserting based on values in it
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c      | 47 ++++++++++++++++++---
>  fs/xfs/libxfs/xfs_ialloc.h       |  1 -
>  fs/xfs/libxfs/xfs_ialloc_btree.c | 90 ++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_ialloc_btree.h |  3 ++
>  fs/xfs/xfs_inode.c               | 23 +++++-----
>  fs/xfs/xfs_mount.h               |  1 +
>  6 files changed, 144 insertions(+), 21 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 0bb8966..3f24725 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
...
> @@ -480,3 +503,64 @@ xfs_inobt_rec_check_count(
...
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

Darrick called out in the previous version that this requires traversal
of the entire tree at mount time. Do you have any test results on what
kind of worst case mount delays we could be looking at here?

As mentioned in the previous version, I don't think we can just assume
that the finobt is always going to be small. The purpose of the feature
is to facilitate constant time lookups for free inode records in
filesystems with extremely large inode counts. The number of free inodes
at any particular time is probably just a question of allocation
patterns. We can hope that the inode frees are not fragmented across
records, but even then we still have to take the ikeep mount option into
consideration (which is probably an easy way to test this, btw).

Brian

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
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b955779..de32f0f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1792,22 +1792,23 @@ xfs_inactive_ifree(
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
> +	 * We try to use a per-AG reservation for any block needed by the finobt
> +	 * tree, but as the finobt feature predates the per-AG reservation
> +	 * support a degraded file system might not have enough space for the
> +	 * reservation at mount time.  In that case try to dip into the reserved
> +	 * pool and pray.
>  	 *
>  	 * Send a warning if the reservation does happen to fail, as the inode
>  	 * now remains allocated and sits on the unlinked list until the fs is
>  	 * repaired.
>  	 */
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree,
> -			XFS_IFREE_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> +	if (unlikely(mp->m_inotbt_nores)) {
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree,
> +				XFS_IFREE_SPACE_RES(mp), 0, XFS_TRANS_RESERVE,
> +				&tp);
> +	} else {
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree, 0, 0, 0, &tp);
> +	}
>  	if (error) {
>  		if (error == -ENOSPC) {
>  			xfs_warn_ratelimited(mp,
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 84f7852..7f351f7 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -140,6 +140,7 @@ typedef struct xfs_mount {
>  	int			m_fixedfsid[2];	/* unchanged for life of FS */
>  	uint			m_dmevmask;	/* DMI events for this FS */
>  	__uint64_t		m_flags;	/* global mount flags */
> +	bool			m_inotbt_nores; /* no per-AG finobt resv. */
>  	int			m_ialloc_inos;	/* inodes in inode allocation */
>  	int			m_ialloc_blks;	/* blocks in inode allocation */
>  	int			m_ialloc_min_blks;/* min blocks in sparse inode
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
