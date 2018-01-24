Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26639 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933648AbeAXOSX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 09:18:23 -0500
Date: Wed, 24 Jan 2018 09:18:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/11] xfs: only grab shared inode locks for source file
 during reflink
Message-ID: <20180124141820.GB37554@bfoster.bfoster>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676028976.12349.5695190502888561177.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676028976.12349.5695190502888561177.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 06:18:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reflink and dedupe operations remap blocks from a source file into a
> destination file.  The destination file needs exclusive locks on all
> levels because we're updating its block map, but the source file isn't
> undergoing any block map changes so we can use a shared lock.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c   |   49 ++++++++++++++++++++++++++++++++-----------------
>  fs/xfs/xfs_inode.h   |   12 +++++++++++-
>  fs/xfs/xfs_reflink.c |   26 ++++++++++++++++----------
>  3 files changed, 59 insertions(+), 28 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c9e40d4..4a38cfc 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -545,24 +545,37 @@ xfs_lock_inodes(
>  }
>  
>  /*
> - * xfs_lock_two_inodes() can only be used to lock one type of lock at a time -
> - * the iolock, the mmaplock or the ilock, but not more than one at a time. If we
> - * lock more than one at a time, lockdep will report false positives saying we
> - * have violated locking orders.
> + * xfs_lock_two_inodes_separately() can only be used to lock one type of lock
> + * at a time - the mmaplock or the ilock, but not more than one type at a
> + * time. If we lock more than one at a time, lockdep will report false
> + * positives saying we have violated locking orders.  The iolock must be
> + * double-locked separately since we use i_rwsem for that.  We now support
> + * taking one lock EXCL and the other SHARED.
>   */
>  void
> -xfs_lock_two_inodes(
> -	xfs_inode_t		*ip0,
> -	xfs_inode_t		*ip1,
> -	uint			lock_mode)
> +xfs_lock_two_inodes_separately(
> +	struct xfs_inode	*ip0,
> +	uint			ip0_mode,
> +	struct xfs_inode	*ip1,
> +	uint			ip1_mode)
>  {

Nit.. but "separately" doesn't really convey meaning to me. I guess
something like xfs_lock_two_inodes_mode() is more clear to me, even
though the original version still accepted a mode. Eh, I guess even
__xfs_lock_two_inodes() might be fine (and perhaps more common
practice). Code looks fine either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -	xfs_inode_t		*temp;
> +	struct xfs_inode	*temp;
> +	uint			mode_temp;
>  	int			attempts = 0;
>  	xfs_log_item_t		*lp;
>  
> -	ASSERT(!(lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)));
> -	if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL))
> -		ASSERT(!(lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
> +	ASSERT(hweight32(ip0_mode) == 1);
> +	ASSERT(hweight32(ip1_mode) == 1);
> +	ASSERT(!(ip0_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)));
> +	ASSERT(!(ip1_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)));
> +	ASSERT(!(ip0_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) ||
> +	       !(ip0_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
> +	ASSERT(!(ip1_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) ||
> +	       !(ip1_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
> +	ASSERT(!(ip1_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) ||
> +	       !(ip0_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
> +	ASSERT(!(ip0_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) ||
> +	       !(ip1_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
>  
>  	ASSERT(ip0->i_ino != ip1->i_ino);
>  
> @@ -570,10 +583,13 @@ xfs_lock_two_inodes(
>  		temp = ip0;
>  		ip0 = ip1;
>  		ip1 = temp;
> +		mode_temp = ip0_mode;
> +		ip0_mode = ip1_mode;
> +		ip1_mode = mode_temp;
>  	}
>  
>   again:
> -	xfs_ilock(ip0, xfs_lock_inumorder(lock_mode, 0));
> +	xfs_ilock(ip0, xfs_lock_inumorder(ip0_mode, 0));
>  
>  	/*
>  	 * If the first lock we have locked is in the AIL, we must TRY to get
> @@ -582,18 +598,17 @@ xfs_lock_two_inodes(
>  	 */
>  	lp = (xfs_log_item_t *)ip0->i_itemp;
>  	if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
> -		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(lock_mode, 1))) {
> -			xfs_iunlock(ip0, lock_mode);
> +		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(ip1_mode, 1))) {
> +			xfs_iunlock(ip0, ip0_mode);
>  			if ((++attempts % 5) == 0)
>  				delay(1); /* Don't just spin the CPU */
>  			goto again;
>  		}
>  	} else {
> -		xfs_ilock(ip1, xfs_lock_inumorder(lock_mode, 1));
> +		xfs_ilock(ip1, xfs_lock_inumorder(ip1_mode, 1));
>  	}
>  }
>  
> -
>  void
>  __xfs_iflock(
>  	struct xfs_inode	*ip)
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 386b0bb..ff56486 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -423,7 +423,17 @@ void		xfs_iunpin_wait(xfs_inode_t *);
>  #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
>  
>  int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
> -void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
> +void		xfs_lock_two_inodes_separately(struct xfs_inode *ip0,
> +				uint ip0_mode, struct xfs_inode *ip1,
> +				uint ip1_mode);
> +static inline void
> +xfs_lock_two_inodes(
> +	struct xfs_inode	*ip0,
> +	struct xfs_inode	*ip1,
> +	uint			lock_mode)
> +{
> +	xfs_lock_two_inodes_separately(ip0, lock_mode, ip1, lock_mode);
> +}
>  
>  xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
>  xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index f89a725..f5a43b2 100644
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
> @@ -1262,7 +1265,7 @@ xfs_iolock_two_inodes_and_break_layout(
>  
>  retry:
>  	if (src_first) {
> -		inode_lock(src);
> +		inode_lock_shared(src);
>  		inode_lock_nested(dest, I_MUTEX_NONDIR2);
>  	} else {
>  		inode_lock(dest);
> @@ -1272,7 +1275,7 @@ xfs_iolock_two_inodes_and_break_layout(
>  	if (error == -EWOULDBLOCK) {
>  		inode_unlock(dest);
>  		if (src_first)
> -			inode_unlock(src);
> +			inode_unlock_shared(src);
>  		error = break_layout(dest, true);
>  		if (error)
>  			return error;
> @@ -1280,11 +1283,11 @@ xfs_iolock_two_inodes_and_break_layout(
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
> @@ -1324,7 +1327,8 @@ xfs_reflink_remap_range(
>  	if (same_inode)
>  		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
>  	else
> -		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
> +		xfs_lock_two_inodes_separately(src, XFS_MMAPLOCK_SHARED,
> +				dest, XFS_MMAPLOCK_EXCL);
>  
>  	/* Check file eligibility and prepare for block sharing. */
>  	ret = -EINVAL;
> @@ -1387,10 +1391,12 @@ xfs_reflink_remap_range(
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
