Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 364BB7F47
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 07:08:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2092B8F8050
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:08:42 -0700 (PDT)
Received: from mail-we0-f180.google.com (mail-we0-f180.google.com
	[74.125.82.180]) by cuda.sgi.com with ESMTP id H3rLHrnTYESKHC3q
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:08:39 -0700 (PDT)
Received: by wegp1 with SMTP id p1so161520534weg.1
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:08:38 -0700 (PDT)
Message-ID: <551153C4.6000808@plexistor.com>
Date: Tue, 24 Mar 2015 14:08:36 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/8] xfs: add DAX file operations support
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194266-2885-6-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

On 03/24/2015 12:51 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add the initial support for DAX file operations to XFS. This
> includes the necessary block allocation and mmap page fault hooks
> for DAX to function.
> 
> Note: we specifically have to disable splice_read/write from

It looks from below code that splice_read is perfectly supportable
through the call to default_file_splice_read() so you might
want to change the comment here.

Regarding splice_write:
It looks to me like you left the vector at iter_file_splice_write().
If I understand correctly I think you need to call default_file_splice_write()
that uses memcpy, just as it was at the previous patches when you left
the vector NULL. So I think you need the same switch for write
as you do below for read.

I'm doing the exact same code for ext4/2 right now and testing.
(Thanks for the loop pointer).

Otherwise I have stared at this very carefully and it looks good
Did not test yet.

Thanks
Boaz

> occurring because they are dependent on usingthe page cache for
> correct operation. We have no page cache for DAX, so we need to
> disable them completely on DAX inodes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c |  73 ++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_aops.h |   7 +++-
>  fs/xfs/xfs_file.c | 116 ++++++++++++++++++++++++++++++++----------------------
>  3 files changed, 143 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 3a9b7a1..3fc5052 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1233,13 +1233,64 @@ xfs_vm_releasepage(
>  	return try_to_free_buffers(page);
>  }
>  
> +/*
> + * For DAX we need a mapping buffer callback for unwritten extent conversion
> + * when page faults allocation blocks and then zero them.
> + */
> +#ifdef CONFIG_FS_DAX
> +static struct xfs_ioend *
> +xfs_dax_alloc_ioend(
> +	struct inode	*inode,
> +	xfs_off_t	offset,
> +	ssize_t		size)
> +{
> +	struct xfs_ioend *ioend;
> +
> +	ASSERT(IS_DAX(inode));
> +	ioend = xfs_alloc_ioend(inode, XFS_IO_UNWRITTEN);
> +	ioend->io_offset = offset;
> +	ioend->io_size = size;
> +	return ioend;
> +}
> +
> +void
> +xfs_get_blocks_dax_complete(
> +	struct buffer_head	*bh,
> +	int			uptodate)
> +{
> +	struct xfs_ioend	*ioend = bh->b_private;
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	int			error;
> +
> +	ASSERT(IS_DAX(ioend->io_inode));
> +
> +	/* if there was an error zeroing, then don't convert it */
> +	if (!uptodate)
> +		goto out_free;
> +
> +	error = xfs_iomap_write_unwritten(ip, ioend->io_offset, ioend->io_size);
> +	if (error)
> +		xfs_warn(ip->i_mount,
> +"%s: conversion failed, ino 0x%llx, offset 0x%llx, len 0x%lx, error %d\n",
> +			__func__, ip->i_ino, ioend->io_offset,
> +			ioend->io_size, error);
> +out_free:
> +	mempool_free(ioend, xfs_ioend_pool);
> +
> +}
> +#else
> +#define xfs_dax_alloc_ioend(i,o,s)	NULL
> +void xfs_get_blocks_dax_complete(struct buffer_head *bh, int uptodate) { }
> +#endif
> +
>  STATIC int
>  __xfs_get_blocks(
>  	struct inode		*inode,
>  	sector_t		iblock,
>  	struct buffer_head	*bh_result,
>  	int			create,
> -	int			direct)
> +	bool			direct,
> +	bool			clear)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -1304,6 +1355,7 @@ __xfs_get_blocks(
>  			if (error)
>  				return error;
>  			new = 1;
> +
>  		} else {
>  			/*
>  			 * Delalloc reservations do not require a transaction,
> @@ -1340,7 +1392,10 @@ __xfs_get_blocks(
>  		if (create || !ISUNWRITTEN(&imap))
>  			xfs_map_buffer(inode, bh_result, &imap, offset);
>  		if (create && ISUNWRITTEN(&imap)) {
> -			if (direct) {
> +			if (clear) {
> +				bh_result->b_private = xfs_dax_alloc_ioend(
> +							inode, offset, size);
> +			} else if (direct) {
>  				bh_result->b_private = inode;
>  				set_buffer_defer_completion(bh_result);
>  			}
> @@ -1425,7 +1480,7 @@ xfs_get_blocks(
>  	struct buffer_head	*bh_result,
>  	int			create)
>  {
> -	return __xfs_get_blocks(inode, iblock, bh_result, create, 0);
> +	return __xfs_get_blocks(inode, iblock, bh_result, create, false, false);
>  }
>  
>  STATIC int
> @@ -1435,7 +1490,17 @@ xfs_get_blocks_direct(
>  	struct buffer_head	*bh_result,
>  	int			create)
>  {
> -	return __xfs_get_blocks(inode, iblock, bh_result, create, 1);
> +	return __xfs_get_blocks(inode, iblock, bh_result, create, true, false);
> +}
> +
> +int
> +xfs_get_blocks_dax(
> +	struct inode		*inode,
> +	sector_t		iblock,
> +	struct buffer_head	*bh_result,
> +	int			create)
> +{
> +	return __xfs_get_blocks(inode, iblock, bh_result, create, true, true);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index ac644e0..7c6fb3f 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -53,7 +53,12 @@ typedef struct xfs_ioend {
>  } xfs_ioend_t;
>  
>  extern const struct address_space_operations xfs_address_space_operations;
> -extern int xfs_get_blocks(struct inode *, sector_t, struct buffer_head *, int);
> +
> +int	xfs_get_blocks(struct inode *inode, sector_t offset,
> +		       struct buffer_head *map_bh, int create);
> +int	xfs_get_blocks_dax(struct inode *inode, sector_t offset,
> +			   struct buffer_head *map_bh, int create);
> +void	xfs_get_blocks_dax_complete(struct buffer_head *bh, int uptodate);
>  
>  extern void xfs_count_page_state(struct page *, int *, int *);
>  
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 94713c2..8017175 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -385,7 +385,11 @@ xfs_file_splice_read(
>  
>  	trace_xfs_file_splice_read(ip, count, *ppos, ioflags);
>  
> -	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
> +	/* for dax, we need to avoid the page cache */
> +	if (IS_DAX(VFS_I(ip)))
> +		ret = default_file_splice_read(infilp, ppos, pipe, count, flags);
> +	else
> +		ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
>  	if (ret > 0)
>  		XFS_STATS_ADD(xs_read_bytes, ret);
>  
> @@ -654,7 +658,7 @@ xfs_file_dio_aio_write(
>  					mp->m_rtdev_targp : mp->m_ddev_targp;
>  
>  	/* DIO must be aligned to device logical sector size */
> -	if ((pos | count) & target->bt_logical_sectormask)
> +	if (!IS_DAX(inode) && (pos | count) & target->bt_logical_sectormask)
>  		return -EINVAL;
>  
>  	/* "unaligned" here means not aligned to a filesystem block */
> @@ -724,8 +728,11 @@ xfs_file_dio_aio_write(
>  out:
>  	xfs_rw_iunlock(ip, iolock);
>  
> -	/* No fallback to buffered IO on errors for XFS. */
> -	ASSERT(ret < 0 || ret == count);
> +	/*
> +	 * No fallback to buffered IO on errors for XFS. DAX can result in
> +	 * partial writes, but direct IO will either complete fully or fail.
> +	 */
> +	ASSERT(ret < 0 || ret == count || IS_DAX(VFS_I(ip)));
>  	return ret;
>  }
>  
> @@ -810,7 +817,7 @@ xfs_file_write_iter(
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> -	if (unlikely(file->f_flags & O_DIRECT))
> +	if ((file->f_flags & O_DIRECT) || IS_DAX(inode))
>  		ret = xfs_file_dio_aio_write(iocb, from);
>  	else
>  		ret = xfs_file_buffered_aio_write(iocb, from);
> @@ -1031,17 +1038,6 @@ xfs_file_readdir(
>  	return xfs_readdir(ip, ctx, bufsize);
>  }
>  
> -STATIC int
> -xfs_file_mmap(
> -	struct file	*filp,
> -	struct vm_area_struct *vma)
> -{
> -	vma->vm_ops = &xfs_file_vm_ops;
> -
> -	file_accessed(filp);
> -	return 0;
> -}
> -
>  /*
>   * This type is designed to indicate the type of offset we would like
>   * to search from page cache for xfs_seek_hole_data().
> @@ -1422,26 +1418,11 @@ xfs_file_llseek(
>   * ordering of:
>   *
>   * mmap_sem (MM)
> - *   i_mmap_lock (XFS - truncate serialisation)
> - *     page_lock (MM)
> - *       i_lock (XFS - extent map serialisation)
> + *   sb_start_pagefault(vfs, freeze)
> + *     i_mmap_lock (XFS - truncate serialisation)
> + *       page_lock (MM)
> + *         i_lock (XFS - extent map serialisation)
>   */
> -STATIC int
> -xfs_filemap_fault(
> -	struct vm_area_struct	*vma,
> -	struct vm_fault		*vmf)
> -{
> -	struct xfs_inode	*ip = XFS_I(vma->vm_file->f_mapping->host);
> -	int			error;
> -
> -	trace_xfs_filemap_fault(ip);
> -
> -	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> -	error = filemap_fault(vma, vmf);
> -	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> -
> -	return error;
> -}
>  
>  /*
>   * mmap()d file has taken write protection fault and is being made writable. We
> @@ -1454,21 +1435,66 @@ xfs_filemap_page_mkwrite(
>  	struct vm_area_struct	*vma,
>  	struct vm_fault		*vmf)
>  {
> -	struct xfs_inode	*ip = XFS_I(vma->vm_file->f_mapping->host);
> +	struct inode		*inode = file_inode(vma->vm_file);
>  	int			ret;
>  
> -	trace_xfs_filemap_page_mkwrite(ip);
> +	trace_xfs_filemap_page_mkwrite(XFS_I(inode));
>  
> -	sb_start_pagefault(VFS_I(ip)->i_sb);
> +	sb_start_pagefault(inode->i_sb);
>  	file_update_time(vma->vm_file);
> -	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> +	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +
> +	if (IS_DAX(inode)) {
> +		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax,
> +				    xfs_get_blocks_dax_complete);
> +	} else {
> +		ret = __block_page_mkwrite(vma, vmf, xfs_get_blocks);
> +		ret = block_page_mkwrite_return(ret);
> +	}
> +
> +	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +	sb_end_pagefault(inode->i_sb);
> +
> +	return ret;
> +}
> +
> +STATIC int
> +xfs_filemap_fault(
> +	struct vm_area_struct	*vma,
> +	struct vm_fault		*vmf)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(vma->vm_file));
> +	int			ret;
>  
> -	ret = __block_page_mkwrite(vma, vmf, xfs_get_blocks);
> +	trace_xfs_filemap_fault(ip);
> +
> +	/* DAX can shortcut the normal fault path on write faults! */
> +	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(VFS_I(ip)))
> +		return xfs_filemap_page_mkwrite(vma, vmf);
>  
> +	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> +	ret = filemap_fault(vma, vmf);
>  	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> -	sb_end_pagefault(VFS_I(ip)->i_sb);
>  
> -	return block_page_mkwrite_return(ret);
> +	return ret;
> +}
> +
> +static const struct vm_operations_struct xfs_file_vm_ops = {
> +	.fault		= xfs_filemap_fault,
> +	.map_pages	= filemap_map_pages,
> +	.page_mkwrite	= xfs_filemap_page_mkwrite,
> +};
> +
> +STATIC int
> +xfs_file_mmap(
> +	struct file	*filp,
> +	struct vm_area_struct *vma)
> +{
> +	file_accessed(filp);
> +	vma->vm_ops = &xfs_file_vm_ops;
> +	if (IS_DAX(file_inode(filp)))
> +		vma->vm_flags |= VM_MIXEDMAP;
> +	return 0;
>  }
>  
>  const struct file_operations xfs_file_operations = {
> @@ -1501,9 +1527,3 @@ const struct file_operations xfs_dir_file_operations = {
>  #endif
>  	.fsync		= xfs_dir_fsync,
>  };
> -
> -static const struct vm_operations_struct xfs_file_vm_ops = {
> -	.fault		= xfs_filemap_fault,
> -	.map_pages	= filemap_map_pages,
> -	.page_mkwrite	= xfs_filemap_page_mkwrite,
> -};
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
