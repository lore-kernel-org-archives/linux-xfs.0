Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbeAWMFf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jan 2018 07:05:35 -0500
Date: Tue, 23 Jan 2018 07:05:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfs: only grab shared inode locks for source file
 during reflink
Message-ID: <20180123120533.GB31825@bfoster.bfoster>
References: <151651282961.28390.17944517354130397779.stgit@magnolia>
 <151651284391.28390.6456958202076195269.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151651284391.28390.6456958202076195269.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Jan 20, 2018 at 09:34:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reflink and dedupe operations remap blocks from a source file into a
> destination file.  The destination file needs exclusive locks on all
> levels because we're updating its block map, but the source file isn't
> undergoing any block map changes so we can use a shared lock.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   50 +++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 37 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index ce523dd..5d1ff5a 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1202,13 +1202,16 @@ xfs_reflink_remap_blocks(
>  
>  	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
>  	while (len) {
> +		uint		lock_mode;
> +
>  		trace_xfs_reflink_remap_blocks_loop(src, srcoff, len,
>  				dest, destoff);
> +
>  		/* Read extent from the source file */
>  		nimaps = 1;
> -		xfs_ilock(src, XFS_ILOCK_EXCL);
> +		lock_mode = xfs_ilock_data_map_shared(src);
>  		error = xfs_bmapi_read(src, srcoff, len, &imap, &nimaps, 0);
> -		xfs_iunlock(src, XFS_ILOCK_EXCL);
> +		xfs_iunlock(src, lock_mode);
>  		if (error)
>  			goto err;
>  		ASSERT(nimaps == 1);
> @@ -1260,7 +1263,7 @@ xfs_iolock_two_inodes_and_break_layout(
>  
>  retry:
>  	if (src_first) {
> -		inode_lock(src);
> +		inode_lock_shared(src);

Hm, I guess this could make my comment on the previous patch more
difficult. Oh well.

>  		inode_lock_nested(dest, I_MUTEX_NONDIR2);
>  	} else {
>  		inode_lock(dest);
> @@ -1270,7 +1273,7 @@ xfs_iolock_two_inodes_and_break_layout(
>  	if (error == -EWOULDBLOCK) {
>  		inode_unlock(dest);
>  		if (src_first)
> -			inode_unlock(src);
> +			inode_unlock_shared(src);
>  		error = break_layout(dest, true);
>  		if (error)
>  			return error;
> @@ -1278,14 +1281,36 @@ xfs_iolock_two_inodes_and_break_layout(
>  	} else if (error) {
>  		inode_unlock(dest);
>  		if (src_first)
> -			inode_unlock(src);
> +			inode_unlock_shared(src);
>  		return error;
>  	}
>  	if (src_last)
> -		inode_lock_nested(src, I_MUTEX_NONDIR2);
> +		down_read_nested(&src->i_rwsem, I_MUTEX_NONDIR2);
>  	return 0;
>  }
>  
> +static void
> +xfs_reflink_mmaplock_two(
> +	struct xfs_inode	*src,
> +	struct xfs_inode	*dest)
> +{
> +	int			i = 0;
> +
> +	if (src->i_ino == dest->i_ino) {
> +		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
> +		return;
> +	}
> +
> +	if (src->i_ino < dest->i_ino) {
> +		xfs_ilock(src, XFS_MMAPLOCK_SHARED);
> +		i++;
> +	}
> +	xfs_ilock(dest, XFS_MMAPLOCK_EXCL + (i << XFS_MMAPLOCK_SHIFT));
> +	i++;
> +	if (src->i_ino > dest->i_ino)
> +		xfs_ilock(src, XFS_MMAPLOCK_SHARED + (i << XFS_MMAPLOCK_SHIFT));
> +}
> +

I am kind of wondering if this one could be replaced with a refactor of
xfs_lock_two_inodes() to take two sets of lock flags (then create a
wrapper to preserve the current signature that just passes the same set
of flags for both inodes).

Brian

>  /*
>   * Link a range of blocks from one file to another.
>   */
> @@ -1319,10 +1344,7 @@ xfs_reflink_remap_range(
>  	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
>  	if (ret)
>  		return ret;
> -	if (same_inode)
> -		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
> -	else
> -		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
> +	xfs_reflink_mmaplock_two(src, dest);
>  
>  	/* Check file eligibility and prepare for block sharing. */
>  	ret = -EINVAL;
> @@ -1385,10 +1407,12 @@ xfs_reflink_remap_range(
>  			is_dedupe);
>  
>  out_unlock:
> -	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
> +	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
> +	if (!same_inode)
> +		xfs_iunlock(src, XFS_MMAPLOCK_SHARED);
> +	inode_unlock(inode_out);
>  	if (!same_inode)
> -		xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
> -	unlock_two_nondirectories(inode_in, inode_out);
> +		inode_unlock_shared(inode_in);
>  	if (ret)
>  		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
>  	return ret;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
