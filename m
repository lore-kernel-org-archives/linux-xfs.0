Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29225 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751937AbdFTTv2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 15:51:28 -0400
Date: Tue, 20 Jun 2017 12:51:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: rewrite xfs_dq_get_next_id using
 xfs_iext_lookup_extent
Message-ID: <20170620195118.GD4733@birch.djwong.org>
References: <20170620090244.30876-1-hch@lst.de>
 <20170620090244.30876-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170620090244.30876-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, agruenba@redhat.com

On Tue, Jun 20, 2017 at 11:02:43AM +0200, Christoph Hellwig wrote:
> This goes straight to a single lookup in the extent list and avoids a
> roundtrip through two layers that don't add any value for the simple
> quoata file that just has data or holes and no page cache, delayed
> allocation, unwritten extent or COW fork (which btw, doesn't seem to
> be handled by the existing SEEK HOLE/DATA code).

I wrote a test case that tries to create a file with an extent in the
CoW fork that doesn't have a corresponding extent in the data fork.
This can be done by setting a large cowextsize hint on a sparse file,
reflinking the file, writing first to a shared block, and then writing
to the hole.  In theory this creates the situation:

data: DD------
cow:  dddddddd
      ^--^-------- these two blocks are dirty

(D = data, d = delalloc resv., - = no extent)

*However* due to a design feature of reflink, I preserved the rule that
any block backed by a page in the pagecache has to have a data fork
extent backing the block.  IOWs, we still make a delalloc reservation in
the data fork even if there's already a reservation for that offset in
the CoW fork, so in reality the two forks look like this:

data: DD-d----
cow:  dddddddd
      ^--^-------- these two blocks are dirty

Therefore, the redundant delalloc reservation in the data fork enable
SEEK_HOLE and SEEK_DATA work correctly.  The writeback and dio write code /do/
notice the speculative preallocation in the CoW fork and uses that to
try to fight fragmentation, so if you dirty block 2 before an fsync then
blocks 0-3 of the file become a single extent.

Ergo, in XFS it's still the case that the data fork always has an extent
to back file data, so the existing file offset iteration code should all
still work even with the pagecache in play.  We pay a price in that the
data fork delalloc reservation isn't free, but gain the benefit that
it's not necessary to complicate the code thinking about when we need to
mergesort the data and CoW fork extent lists to find all the data in a
file.

Anyway, having written the testcase I'll post it to fstests.

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_dquot.c | 66 ++++++++++++++++++------------------------------------
>  1 file changed, 22 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 9d06cc30e875..774750bb3e6b 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -695,21 +695,18 @@ xfs_qm_dqread(
>   */
>  static int
>  xfs_dq_get_next_id(
> -	xfs_mount_t		*mp,
> +	struct xfs_mount	*mp,
>  	uint			type,
> -	xfs_dqid_t		*id,
> -	loff_t			eof)
> +	xfs_dqid_t		*id)
>  {
> -	struct xfs_inode	*quotip;
> +	struct xfs_inode	*quotip = xfs_quota_inode(mp, type);
> +	xfs_dqid_t		next_id = *id + 1; /* simple advance */
> +	uint			lock_flags;
> +	struct xfs_bmbt_irec	got;
> +	xfs_extnum_t		idx;
>  	xfs_fsblock_t		start;
> -	loff_t			offset;
> -	uint			lock;
> -	xfs_dqid_t		next_id;
>  	int			error = 0;
>  
> -	/* Simple advance */
> -	next_id = *id + 1;
> -
>  	/* If we'd wrap past the max ID, stop */
>  	if (next_id < *id)
>  		return -ENOENT;
> @@ -723,23 +720,20 @@ xfs_dq_get_next_id(
>  	/* Nope, next_id is now past the current chunk, so find the next one */
>  	start = (xfs_fsblock_t)next_id / mp->m_quotainfo->qi_dqperchunk;
>  
> -	quotip = xfs_quota_inode(mp, type);
> -	lock = xfs_ilock_data_map_shared(quotip);
> -
> -	offset = __xfs_seek_hole_data(VFS_I(quotip), XFS_FSB_TO_B(mp, start),
> -				      eof, SEEK_DATA);
> -	if (offset < 0)
> -		error = offset;
> -
> -	xfs_iunlock(quotip, lock);
> +	lock_flags = xfs_ilock_data_map_shared(quotip);
> +	if (!(quotip->i_df.if_flags & XFS_IFEXTENTS)) {
> +		error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
> +		if (error)
> +			return error;
> +	}
>  
> -	/* -ENXIO is essentially "no more data" */
> -	if (error)
> -		return (error == -ENXIO ? -ENOENT: error);
> +	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &idx, &got))
> +		*id = got.br_startoff * mp->m_quotainfo->qi_dqperchunk;
> +	else
> +		error = -ENOENT;
> +	xfs_iunlock(quotip, lock_flags);
>  
> -	/* Convert next data offset back to a quota id */
> -	*id = XFS_B_TO_FSB(mp, offset) * mp->m_quotainfo->qi_dqperchunk;
> -	return 0;
> +	return error;
>  }
>  
>  /*
> @@ -762,7 +756,6 @@ xfs_qm_dqget(
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  	struct radix_tree_root *tree = xfs_dquot_tree(qi, type);
>  	struct xfs_dquot	*dqp;
> -	loff_t			eof = 0;
>  	int			error;
>  
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> @@ -790,21 +783,6 @@ xfs_qm_dqget(
>  	}
>  #endif
>  
> -	/* Get the end of the quota file if we need it */
> -	if (flags & XFS_QMOPT_DQNEXT) {
> -		struct xfs_inode	*quotip;
> -		xfs_fileoff_t		last;
> -		uint			lock_mode;
> -
> -		quotip = xfs_quota_inode(mp, type);
> -		lock_mode = xfs_ilock_data_map_shared(quotip);
> -		error = xfs_bmap_last_offset(quotip, &last, XFS_DATA_FORK);
> -		xfs_iunlock(quotip, lock_mode);
> -		if (error)
> -			return error;
> -		eof = XFS_FSB_TO_B(mp, last);
> -	}
> -
>  restart:
>  	mutex_lock(&qi->qi_tree_lock);
>  	dqp = radix_tree_lookup(tree, id);
> @@ -823,7 +801,7 @@ xfs_qm_dqget(
>  			if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
>  				xfs_dqunlock(dqp);
>  				mutex_unlock(&qi->qi_tree_lock);
> -				error = xfs_dq_get_next_id(mp, type, &id, eof);
> +				error = xfs_dq_get_next_id(mp, type, &id);
>  				if (error)
>  					return error;
>  				goto restart;
> @@ -858,7 +836,7 @@ xfs_qm_dqget(
>  
>  	/* If we are asked to find next active id, keep looking */
>  	if (error == -ENOENT && (flags & XFS_QMOPT_DQNEXT)) {
> -		error = xfs_dq_get_next_id(mp, type, &id, eof);
> +		error = xfs_dq_get_next_id(mp, type, &id);
>  		if (!error)
>  			goto restart;
>  	}
> @@ -917,7 +895,7 @@ xfs_qm_dqget(
>  	if (flags & XFS_QMOPT_DQNEXT) {
>  		if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
>  			xfs_qm_dqput(dqp);
> -			error = xfs_dq_get_next_id(mp, type, &id, eof);
> +			error = xfs_dq_get_next_id(mp, type, &id);
>  			if (error)
>  				return error;
>  			goto restart;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
