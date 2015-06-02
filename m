Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 54E017F5E
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:02:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 427068F8064
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 09:02:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7WW9lP1WzhUCpqNg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 09:02:22 -0700 (PDT)
Date: Tue, 2 Jun 2015 12:02:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/8] xfs: add DAX file operations support
Message-ID: <20150602160217.GA14182@bfoster.bfoster>
References: <1432856755-7859-1-git-send-email-david@fromorbit.com>
	<1432856755-7859-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1432856755-7859-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, May 29, 2015 at 09:45:51AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add the initial support for DAX file operations to XFS. This
> includes the necessary block allocation and mmap page fault hooks
> for DAX to function.
> 
> Note that there are changes to the splice interfaces to ensure that
> for DAX splice avoids direct page cache manipulations and instead
> takes the DAX IO paths for read/write operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c | 116 ++++++++++++++++++++++++++++++++++++++---------------
>  fs/xfs/xfs_aops.h |   7 +++-
>  fs/xfs/xfs_file.c | 118 +++++++++++++++++++++++++++++++-----------------------
>  3 files changed, 158 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a56960d..1d195e8 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
...
> @@ -1607,6 +1588,75 @@ out_end_io:
>  	return;
>  }
>  
> +/*
> + * Complete a direct I/O write request.
> + *
> + * The ioend structure is passed from __xfs_get_blocks() to tell us what to do.
> + * If no ioend exists (i.e. @private == NULL) then the write IO is an overwrite
> + * wholly within the EOF and so there is nothing for us to do. Note that in this
> + * case the completion can be called in interrupt context, whereas if we have an
> + * ioend we will always be called in task context (i.e. from a workqueue).
> + */
> +STATIC void
> +xfs_end_io_direct_write(
> +	struct kiocb		*iocb,
> +	loff_t			offset,
> +	ssize_t			size,
> +	void			*private)
> +{
> +	struct inode		*inode = file_inode(iocb->ki_filp);
> +	struct xfs_ioend	*ioend = private;
> +
> +	trace_xfs_gbmap_direct_endio(XFS_I(inode), offset, size,
> +				     ioend ? ioend->io_type : 0, NULL);
> +
> +	if (!ioend) {
> +		ASSERT(offset + size <= i_size_read(inode));
> +		return;
> +	}
> +
> +	__xfs_end_io_direct_write(inode, ioend, offset, size);
> +}
> +
> +/*
> + * For DAX we need a mapping buffer callback for unwritten extent conversion
> + * when page faults allocate blocks and then zero them. Note that in this
> + * case the mapping indicated by the ioend may extend beyond EOF. We most
> + * definitely do not want to extend EOF here, so we trim back the ioend size to
> + * EOF.
> + */
> +#ifdef CONFIG_FS_DAX
> +void
> +xfs_end_io_dax_write(
> +	struct buffer_head	*bh,
> +	int			uptodate)
> +{
> +	struct xfs_ioend	*ioend = bh->b_private;
> +	struct inode		*inode = ioend->io_inode;
> +	ssize_t			size = ioend->io_size;
> +
> +	ASSERT(IS_DAX(ioend->io_inode));
> +

A trace_xfs_gbmap_dax_endio() might be nice here. Otherwise this looks
good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	/* if there was an error zeroing, then don't convert it */
> +	if (!uptodate)
> +		ioend->io_error = -EIO;
> +
> +	/*
> +	 * Trim update to EOF, so we don't extend EOF during unwritten extent
> +	 * conversion of partial EOF blocks.
> +	 */
> +	spin_lock(&XFS_I(inode)->i_flags_lock);
> +	if (ioend->io_offset + size > i_size_read(inode))
> +		size = i_size_read(inode) - ioend->io_offset;
> +	spin_unlock(&XFS_I(inode)->i_flags_lock);
> +
> +	__xfs_end_io_direct_write(inode, ioend, ioend->io_offset, size);
> +
> +}
> +#else
> +void xfs_end_io_dax_write(struct buffer_head *bh, int uptodate) { }
> +#endif
> +
>  STATIC ssize_t
>  xfs_vm_direct_IO(
>  	struct kiocb		*iocb,
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index ac644e0..86afd1a 100644
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
> +int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
> +			      struct buffer_head *map_bh, int create);
> +void	xfs_end_io_dax_write(struct buffer_head *bh, int uptodate);
>  
>  extern void xfs_count_page_state(struct page *, int *, int *);
>  
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4a0af89..c2af282 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -284,7 +284,7 @@ xfs_file_read_iter(
>  	if (file->f_mode & FMODE_NOCMTIME)
>  		ioflags |= XFS_IO_INVIS;
>  
> -	if (unlikely(ioflags & XFS_IO_ISDIRECT)) {
> +	if ((ioflags & XFS_IO_ISDIRECT) && !IS_DAX(inode)) {
>  		xfs_buftarg_t	*target =
>  			XFS_IS_REALTIME_INODE(ip) ?
>  				mp->m_rtdev_targp : mp->m_ddev_targp;
> @@ -378,7 +378,11 @@ xfs_file_splice_read(
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
> @@ -672,7 +676,7 @@ xfs_file_dio_aio_write(
>  					mp->m_rtdev_targp : mp->m_ddev_targp;
>  
>  	/* DIO must be aligned to device logical sector size */
> -	if ((pos | count) & target->bt_logical_sectormask)
> +	if (!IS_DAX(inode) && ((pos | count) & target->bt_logical_sectormask))
>  		return -EINVAL;
>  
>  	/* "unaligned" here means not aligned to a filesystem block */
> @@ -758,8 +762,11 @@ xfs_file_dio_aio_write(
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
> @@ -842,7 +849,7 @@ xfs_file_write_iter(
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> -	if (unlikely(iocb->ki_flags & IOCB_DIRECT))
> +	if ((iocb->ki_flags & IOCB_DIRECT) || IS_DAX(inode))
>  		ret = xfs_file_dio_aio_write(iocb, from);
>  	else
>  		ret = xfs_file_buffered_aio_write(iocb, from);
> @@ -1063,17 +1070,6 @@ xfs_file_readdir(
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
> @@ -1454,26 +1450,11 @@ xfs_file_llseek(
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
> @@ -1486,21 +1467,66 @@ xfs_filemap_page_mkwrite(
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
> +		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_direct,
> +				    xfs_end_io_dax_write);
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
> @@ -1531,9 +1557,3 @@ const struct file_operations xfs_dir_file_operations = {
>  #endif
>  	.fsync		= xfs_dir_fsync,
>  };
> -
> -static const struct vm_operations_struct xfs_file_vm_ops = {
> -	.fault		= xfs_filemap_fault,
> -	.map_pages	= filemap_map_pages,
> -	.page_mkwrite	= xfs_filemap_page_mkwrite,
> -};
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
