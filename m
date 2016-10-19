Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26691 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941062AbcJSPyG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Oct 2016 11:54:06 -0400
Date: Wed, 19 Oct 2016 08:53:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] xfs: merge xfs_reflink_remap_range and
 xfs_file_share_range
Message-ID: <20161019155359.GJ26485@birch.djwong.org>
References: <1476881248-18669-1-git-send-email-hch@lst.de>
 <1476881248-18669-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476881248-18669-6-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 19, 2016 at 02:47:28PM +0200, Christoph Hellwig wrote:
> There is no clear division of responsibility between those functions, so
> just merge them into one to keep the code simple.  Also move
> xfs_file_wait_for_io to xfs_reflink.c together with its only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine and passed all the reflink tests...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_file.c    | 132 +-------------------------------------
>  fs/xfs/xfs_reflink.c | 178 +++++++++++++++++++++++++++++++++++++++------------
>  fs/xfs/xfs_reflink.h |   7 +-
>  3 files changed, 143 insertions(+), 174 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a61be33..5cca5de 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -947,132 +947,6 @@ xfs_file_fallocate(
>  	return error;
>  }
>  
> -/* Hook up to the VFS reflink function */
> -STATIC int
> -xfs_file_share_range(
> -	struct file	*file_in,
> -	loff_t		pos_in,
> -	struct file	*file_out,
> -	loff_t		pos_out,
> -	u64		len,
> -	bool		is_dedupe)
> -{
> -	struct inode	*inode_in;
> -	struct inode	*inode_out;
> -	ssize_t		ret;
> -	loff_t		bs;
> -	loff_t		isize;
> -	int		same_inode;
> -	loff_t		blen;
> -	unsigned int	flags = 0;
> -
> -	inode_in = file_inode(file_in);
> -	inode_out = file_inode(file_out);
> -	bs = inode_out->i_sb->s_blocksize;
> -
> -	/* Lock both files against IO */
> -	same_inode = (inode_in == inode_out);
> -	if (same_inode) {
> -		xfs_ilock(XFS_I(inode_in), XFS_IOLOCK_EXCL);
> -		xfs_ilock(XFS_I(inode_in), XFS_MMAPLOCK_EXCL);
> -	} else {
> -		xfs_lock_two_inodes(XFS_I(inode_in), XFS_I(inode_out),
> -				XFS_IOLOCK_EXCL);
> -		xfs_lock_two_inodes(XFS_I(inode_in), XFS_I(inode_out),
> -				XFS_MMAPLOCK_EXCL);
> -	}
> -
> -	/* Don't touch certain kinds of inodes */
> -	ret = -EPERM;
> -	if (IS_IMMUTABLE(inode_out))
> -		goto out_unlock;
> -	ret = -ETXTBSY;
> -	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
> -		goto out_unlock;
> -
> -	/* Don't reflink dirs, pipes, sockets... */
> -	ret = -EISDIR;
> -	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> -		goto out_unlock;
> -	ret = -EINVAL;
> -	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
> -		goto out_unlock;
> -	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> -		goto out_unlock;
> -
> -	/* Don't share DAX file data for now. */
> -	if (IS_DAX(inode_in) || IS_DAX(inode_out))
> -		goto out_unlock;
> -
> -	/* Are we going all the way to the end? */
> -	isize = i_size_read(inode_in);
> -	if (isize == 0) {
> -		ret = 0;
> -		goto out_unlock;
> -	}
> -
> -	if (len == 0)
> -		len = isize - pos_in;
> -
> -	/* Ensure offsets don't wrap and the input is inside i_size */
> -	if (pos_in + len < pos_in || pos_out + len < pos_out ||
> -	    pos_in + len > isize)
> -		goto out_unlock;
> -
> -	/* Don't allow dedupe past EOF in the dest file */
> -	if (is_dedupe) {
> -		loff_t	disize;
> -
> -		disize = i_size_read(inode_out);
> -		if (pos_out >= disize || pos_out + len > disize)
> -			goto out_unlock;
> -	}
> -
> -	/* If we're linking to EOF, continue to the block boundary. */
> -	if (pos_in + len == isize)
> -		blen = ALIGN(isize, bs) - pos_in;
> -	else
> -		blen = len;
> -
> -	/* Only reflink if we're aligned to block boundaries */
> -	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_in + blen, bs) ||
> -	    !IS_ALIGNED(pos_out, bs) || !IS_ALIGNED(pos_out + blen, bs))
> -		goto out_unlock;
> -
> -	/* Don't allow overlapped reflink within the same file */
> -	if (same_inode && pos_out + blen > pos_in && pos_out < pos_in + blen)
> -		goto out_unlock;
> -
> -	/* Wait for the completion of any pending IOs on both files */
> -	inode_dio_wait(inode_in);
> -	if (!same_inode)
> -		inode_dio_wait(inode_out);
> -
> -	ret = filemap_write_and_wait_range(inode_in->i_mapping,
> -			pos_in, pos_in + len - 1);
> -	if (ret)
> -		goto out_unlock;
> -
> -	ret = filemap_write_and_wait_range(inode_out->i_mapping,
> -			pos_out, pos_out + len - 1);
> -	if (ret)
> -		goto out_unlock;
> -
> -	if (is_dedupe)
> -		flags |= XFS_REFLINK_DEDUPE;
> -	ret = xfs_reflink_remap_range(XFS_I(inode_in), pos_in, XFS_I(inode_out),
> -			pos_out, len, flags);
> -
> -out_unlock:
> -	xfs_iunlock(XFS_I(inode_in), XFS_MMAPLOCK_EXCL);
> -	xfs_iunlock(XFS_I(inode_in), XFS_IOLOCK_EXCL);
> -	if (!same_inode) {
> -		xfs_iunlock(XFS_I(inode_out), XFS_MMAPLOCK_EXCL);
> -		xfs_iunlock(XFS_I(inode_out), XFS_IOLOCK_EXCL);
> -	}
> -	return ret;
> -}
> -
>  STATIC ssize_t
>  xfs_file_copy_range(
>  	struct file	*file_in,
> @@ -1084,7 +958,7 @@ xfs_file_copy_range(
>  {
>  	int		error;
>  
> -	error = xfs_file_share_range(file_in, pos_in, file_out, pos_out,
> +	error = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
>  				     len, false);
>  	if (error)
>  		return error;
> @@ -1099,7 +973,7 @@ xfs_file_clone_range(
>  	loff_t		pos_out,
>  	u64		len)
>  {
> -	return xfs_file_share_range(file_in, pos_in, file_out, pos_out,
> +	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
>  				     len, false);
>  }
>  
> @@ -1122,7 +996,7 @@ xfs_file_dedupe_range(
>  	if (len > XFS_MAX_DEDUPE_LEN)
>  		len = XFS_MAX_DEDUPE_LEN;
>  
> -	error = xfs_file_share_range(src_file, loff, dst_file, dst_loff,
> +	error = xfs_reflink_remap_range(src_file, loff, dst_file, dst_loff,
>  				     len, true);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index d012746..6044a49 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1312,19 +1312,26 @@ xfs_compare_extents(
>   */
>  int
>  xfs_reflink_remap_range(
> -	struct xfs_inode	*src,
> -	xfs_off_t		srcoff,
> -	struct xfs_inode	*dest,
> -	xfs_off_t		destoff,
> -	xfs_off_t		len,
> -	unsigned int		flags)
> +	struct file		*file_in,
> +	loff_t			pos_in,
> +	struct file		*file_out,
> +	loff_t			pos_out,
> +	u64			len,
> +	bool			is_dedupe)
>  {
> +	struct inode		*inode_in = file_inode(file_in);
> +	struct xfs_inode	*src = XFS_I(inode_in);
> +	struct inode		*inode_out = file_inode(file_out);
> +	struct xfs_inode	*dest = XFS_I(inode_out);
>  	struct xfs_mount	*mp = src->i_mount;
> +	loff_t			bs = inode_out->i_sb->s_blocksize;
> +	bool			same_inode = (inode_in == inode_out);
>  	xfs_fileoff_t		sfsbno, dfsbno;
>  	xfs_filblks_t		fsblen;
> -	int			error;
>  	xfs_extlen_t		cowextsize;
> -	bool			is_same;
> +	loff_t			isize;
> +	ssize_t			ret;
> +	loff_t			blen;
>  
>  	if (!xfs_sb_version_hasreflink(&mp->m_sb))
>  		return -EOPNOTSUPP;
> @@ -1332,48 +1339,135 @@ xfs_reflink_remap_range(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	/* Lock both files against IO */
> +	if (same_inode) {
> +		xfs_ilock(src, XFS_IOLOCK_EXCL);
> +		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
> +	} else {
> +		xfs_lock_two_inodes(src, dest, XFS_IOLOCK_EXCL);
> +		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
> +	}
> +
> +	/* Don't touch certain kinds of inodes */
> +	ret = -EPERM;
> +	if (IS_IMMUTABLE(inode_out))
> +		goto out_unlock;
> +
> +	ret = -ETXTBSY;
> +	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
> +		goto out_unlock;
> +
> +
> +	/* Don't reflink dirs, pipes, sockets... */
> +	ret = -EISDIR;
> +	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> +		goto out_unlock;
> +	ret = -EINVAL;
> +	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
> +		goto out_unlock;
> +	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> +		goto out_unlock;
> +
>  	/* Don't reflink realtime inodes */
>  	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
> -		return -EINVAL;
> +		goto out_unlock;
> +
> +	/* Don't share DAX file data for now. */
> +	if (IS_DAX(inode_in) || IS_DAX(inode_out))
> +		goto out_unlock;
> +
> +	/* Are we going all the way to the end? */
> +	isize = i_size_read(inode_in);
> +	if (isize == 0) {
> +		ret = 0;
> +		goto out_unlock;
> +	}
> +
> +	if (len == 0)
> +		len = isize - pos_in;
> +
> +	/* Ensure offsets don't wrap and the input is inside i_size */
> +	if (pos_in + len < pos_in || pos_out + len < pos_out ||
> +	    pos_in + len > isize)
> +		goto out_unlock;
>  
> -	if (flags & ~XFS_REFLINK_ALL)
> -		return -EINVAL;
> +	/* Don't allow dedupe past EOF in the dest file */
> +	if (is_dedupe) {
> +		loff_t	disize;
>  
> -	trace_xfs_reflink_remap_range(src, srcoff, len, dest, destoff);
> +		disize = i_size_read(inode_out);
> +		if (pos_out >= disize || pos_out + len > disize)
> +			goto out_unlock;
> +	}
> +
> +	/* If we're linking to EOF, continue to the block boundary. */
> +	if (pos_in + len == isize)
> +		blen = ALIGN(isize, bs) - pos_in;
> +	else
> +		blen = len;
> +
> +	/* Only reflink if we're aligned to block boundaries */
> +	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_in + blen, bs) ||
> +	    !IS_ALIGNED(pos_out, bs) || !IS_ALIGNED(pos_out + blen, bs))
> +		goto out_unlock;
> +
> +	/* Don't allow overlapped reflink within the same file */
> +	if (same_inode) {
> +		if (pos_out + blen > pos_in && pos_out < pos_in + blen)
> +			goto out_unlock;
> +	}
> +
> +	/* Wait for the completion of any pending IOs on both files */
> +	inode_dio_wait(inode_in);
> +	if (!same_inode)
> +		inode_dio_wait(inode_out);
> +
> +	ret = filemap_write_and_wait_range(inode_in->i_mapping,
> +			pos_in, pos_in + len - 1);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret = filemap_write_and_wait_range(inode_out->i_mapping,
> +			pos_out, pos_out + len - 1);
> +	if (ret)
> +		goto out_unlock;
> +
> +	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
>  
>  	/*
>  	 * Check that the extents are the same.
>  	 */
> -	if (flags & XFS_REFLINK_DEDUPE) {
> -		is_same = false;
> -		error = xfs_compare_extents(VFS_I(src), srcoff, VFS_I(dest),
> -				destoff, len, &is_same);
> -		if (error)
> -			goto out_error;
> +	if (is_dedupe) {
> +		bool		is_same = false;
> +
> +		ret = xfs_compare_extents(inode_in, pos_in, inode_out, pos_out,
> +				len, &is_same);
> +		if (ret)
> +			goto out_unlock;
>  		if (!is_same) {
> -			error = -EBADE;
> -			goto out_error;
> +			ret = -EBADE;
> +			goto out_unlock;
>  		}
>  	}
>  
> -	error = xfs_reflink_set_inode_flag(src, dest);
> -	if (error)
> -		goto out_error;
> +	ret = xfs_reflink_set_inode_flag(src, dest);
> +	if (ret)
> +		goto out_unlock;
>  
>  	/*
>  	 * Invalidate the page cache so that we can clear any CoW mappings
>  	 * in the destination file.
>  	 */
> -	truncate_inode_pages_range(&VFS_I(dest)->i_data, destoff,
> -				   PAGE_ALIGN(destoff + len) - 1);
> +	truncate_inode_pages_range(&inode_out->i_data, pos_out,
> +				   PAGE_ALIGN(pos_out + len) - 1);
>  
> -	dfsbno = XFS_B_TO_FSBT(mp, destoff);
> -	sfsbno = XFS_B_TO_FSBT(mp, srcoff);
> +	dfsbno = XFS_B_TO_FSBT(mp, pos_out);
> +	sfsbno = XFS_B_TO_FSBT(mp, pos_in);
>  	fsblen = XFS_B_TO_FSB(mp, len);
> -	error = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
> -			destoff + len);
> -	if (error)
> -		goto out_error;
> +	ret = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
> +			pos_out + len);
> +	if (ret)
> +		goto out_unlock;
>  
>  	/*
>  	 * Carry the cowextsize hint from src to dest if we're sharing the
> @@ -1381,20 +1475,24 @@ xfs_reflink_remap_range(
>  	 * has a cowextsize hint, and the destination file does not.
>  	 */
>  	cowextsize = 0;
> -	if (srcoff == 0 && len == i_size_read(VFS_I(src)) &&
> +	if (pos_in == 0 && len == i_size_read(inode_in) &&
>  	    (src->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
> -	    destoff == 0 && len >= i_size_read(VFS_I(dest)) &&
> +	    pos_out == 0 && len >= i_size_read(inode_out) &&
>  	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
>  		cowextsize = src->i_d.di_cowextsize;
>  
> -	error = xfs_reflink_update_dest(dest, destoff + len, cowextsize);
> -	if (error)
> -		goto out_error;
> +	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize);
>  
> -out_error:
> -	if (error)
> -		trace_xfs_reflink_remap_range_error(dest, error, _RET_IP_);
> -	return error;
> +out_unlock:
> +	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
> +	xfs_iunlock(src, XFS_IOLOCK_EXCL);
> +	if (src->i_ino != dest->i_ino) {
> +		xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
> +		xfs_iunlock(dest, XFS_IOLOCK_EXCL);
> +	}
> +	if (ret)
> +		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
> +	return ret;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 5dc3c8a..7ddd9f6 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -43,11 +43,8 @@ extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
>  extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t count);
>  extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
> -#define XFS_REFLINK_DEDUPE	1	/* only reflink if contents match */
> -#define XFS_REFLINK_ALL		(XFS_REFLINK_DEDUPE)
> -extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
> -		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len,
> -		unsigned int flags);
> +extern int xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
> +		struct file *file_out, loff_t pos_out, u64 len, bool is_dedupe);
>  extern int xfs_reflink_clear_inode_flag(struct xfs_inode *ip,
>  		struct xfs_trans **tpp);
>  extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
> -- 
> 2.1.4
> 
