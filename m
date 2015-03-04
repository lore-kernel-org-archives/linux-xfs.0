Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 58BC67F4E
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 04:09:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2846D8F8070
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 02:09:50 -0800 (PST)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id 64fsIs3eCMqNN5xR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 Mar 2015 02:09:44 -0800 (PST)
Received: by wggy19 with SMTP id y19so45409413wgg.13
	for <xfs@oss.sgi.com>; Wed, 04 Mar 2015 02:09:43 -0800 (PST)
Message-ID: <54F6D9E4.9050803@gmail.com>
Date: Wed, 04 Mar 2015 12:09:40 +0200
From: Boaz Harrosh <openosd@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/6] xfs: add DAX file operations support
References: <1425425427-16283-1-git-send-email-david@fromorbit.com>
	<1425425427-16283-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1425425427-16283-4-git-send-email-david@fromorbit.com>
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

On 03/04/2015 01:30 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add the initial support for DAX file operations to XFS. This
> includes the necessary block allocation and mmap page fault hooks
> for DAX to function.
> 
> Note that the current block allocation code abuses the mapping
> buffer head to provide a completion callback for unwritten extent
> allocation when DAX is clearing blocks. The DAX interface needs to
> be changed to provide a callback similar to get_blocks for this
> callback.

It looks like this comment is stale for this set

A question below

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c |  72 ++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_aops.h |   7 +++-
>  fs/xfs/xfs_file.c | 108 ++++++++++++++++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_iops.c |   4 ++
>  fs/xfs/xfs_iops.h |   6 +++
>  5 files changed, 173 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 3a9b7a1..22cb03a 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1233,13 +1233,63 @@ xfs_vm_releasepage(
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
> @@ -1304,6 +1354,7 @@ __xfs_get_blocks(
>  			if (error)
>  				return error;
>  			new = 1;
> +
>  		} else {
>  			/*
>  			 * Delalloc reservations do not require a transaction,
> @@ -1340,7 +1391,10 @@ __xfs_get_blocks(
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
> @@ -1425,7 +1479,7 @@ xfs_get_blocks(
>  	struct buffer_head	*bh_result,
>  	int			create)
>  {
> -	return __xfs_get_blocks(inode, iblock, bh_result, create, 0);
> +	return __xfs_get_blocks(inode, iblock, bh_result, create, false, false);
>  }
>  
>  STATIC int
> @@ -1435,7 +1489,17 @@ xfs_get_blocks_direct(
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
> index bc0008f..4bfcba0 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -654,7 +654,7 @@ xfs_file_dio_aio_write(
>  					mp->m_rtdev_targp : mp->m_ddev_targp;
>  
>  	/* DIO must be aligned to device logical sector size */
> -	if ((pos | count) & target->bt_logical_sectormask)
> +	if (!IS_DAX(inode) && (pos | count) & target->bt_logical_sectormask)
>  		return -EINVAL;
>  
>  	/* "unaligned" here means not aligned to a filesystem block */
> @@ -724,8 +724,11 @@ xfs_file_dio_aio_write(
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
> @@ -810,7 +813,7 @@ xfs_file_write_iter(
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> -	if (unlikely(file->f_flags & O_DIRECT))
> +	if ((file->f_flags & O_DIRECT) || IS_DAX(inode))
>  		ret = xfs_file_dio_aio_write(iocb, from);
>  	else
>  		ret = xfs_file_buffered_aio_write(iocb, from);
> @@ -1031,17 +1034,6 @@ xfs_file_readdir(
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
> @@ -1466,6 +1458,71 @@ xfs_filemap_page_mkwrite(
>  	return error;
>  }
>  
> +static const struct vm_operations_struct xfs_file_vm_ops = {
> +	.fault		= xfs_filemap_fault,
> +	.map_pages	= filemap_map_pages,
> +	.page_mkwrite	= xfs_filemap_page_mkwrite,
> +};
> +
> +#ifdef CONFIG_FS_DAX
> +static int
> +xfs_filemap_dax_fault(
> +	struct vm_area_struct	*vma,
> +	struct vm_fault		*vmf)
> +{
> +	struct xfs_inode	*ip = XFS_I(vma->vm_file->f_mapping->host);
> +	int			error;
> +
> +	trace_xfs_filemap_fault(ip);
> +
> +	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> +	error = dax_fault(vma, vmf, xfs_get_blocks_dax,
> +			  xfs_get_blocks_dax_complete);
> +	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> +
> +	return error;
> +}
> +
> +static int
> +xfs_filemap_dax_page_mkwrite(
> +	struct vm_area_struct	*vma,
> +	struct vm_fault		*vmf)
> +{
> +	struct xfs_inode	*ip = XFS_I(vma->vm_file->f_mapping->host);
> +	int			error;
> +
> +	trace_xfs_filemap_page_mkwrite(ip);
> +
> +	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> +	error = dax_mkwrite(vma, vmf, xfs_get_blocks_dax,
> +			    xfs_get_blocks_dax_complete);
> +	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> +
> +	return error;
> +}
> +
> +static const struct vm_operations_struct xfs_file_dax_vm_ops = {
> +	.fault		= xfs_filemap_dax_fault,
> +	.page_mkwrite	= xfs_filemap_dax_page_mkwrite,
> +};
> +#else
> +#define xfs_file_dax_vm_ops	xfs_file_vm_ops
> +#endif /* CONFIG_FS_DAX */
> +
> +STATIC int
> +xfs_file_mmap(
> +	struct file	*filp,
> +	struct vm_area_struct *vma)
> +{
> +	file_accessed(filp);
> +	if (IS_DAX(file_inode(filp))) {
> +		vma->vm_ops = &xfs_file_dax_vm_ops;
> +		vma->vm_flags |= VM_MIXEDMAP;
> +	} else
> +		vma->vm_ops = &xfs_file_vm_ops;
> +	return 0;
> +}
> +
>  const struct file_operations xfs_file_operations = {
>  	.llseek		= xfs_file_llseek,
>  	.read		= new_sync_read,
> @@ -1497,8 +1554,21 @@ const struct file_operations xfs_dir_file_operations = {
>  	.fsync		= xfs_dir_fsync,
>  };
>  
> -static const struct vm_operations_struct xfs_file_vm_ops = {
> -	.fault		= xfs_filemap_fault,
> -	.map_pages	= filemap_map_pages,
> -	.page_mkwrite	= xfs_filemap_page_mkwrite,
> +#ifdef CONFIG_FS_DAX
> +const struct file_operations xfs_file_dax_operations = {
> +	.llseek		= xfs_file_llseek,
> +	.read		= new_sync_read,
> +	.write		= new_sync_write,
> +	.read_iter	= xfs_file_read_iter,
> +	.write_iter	= xfs_file_write_iter,
> +	.unlocked_ioctl	= xfs_file_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl	= xfs_file_compat_ioctl,
> +#endif
> +	.mmap		= xfs_file_mmap,
> +	.open		= xfs_file_open,
> +	.release	= xfs_file_release,
> +	.fsync		= xfs_file_fsync,
> +	.fallocate	= xfs_file_fallocate,
>  };

sigh, The same problem was in ext4, the reason you need
a second xfs_file_operations vector is because of the minus
	.splice_read	= xfs_file_splice_read,
	.splice_write	= iter_file_splice_write,
Which do not exist for DAX

Inspecting do_splice_from && do_splice_to, if I'm reading
the code right it looks like the difference of these vectors
present is the call to default_file_splice_write/read.

[default_file_splice_read for example would go head and use
 kernel_readv() ]

Would it be cleaner to call default_file_splice_write/read
directly from xfs_file_splice_read/write in the DAX case
and only keep one vector?

I have looked through the code, nothing stands out that I
can see. Do you have a public tree I can pull for easy
testing?

Thanks
Boaz

> +#endif /* CONFIG_FS_DAX */
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 8b9e688..9f38142 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1264,6 +1264,10 @@ xfs_setup_inode(
>  	case S_IFREG:
>  		inode->i_op = &xfs_inode_operations;
>  		inode->i_fop = &xfs_file_operations;
> +		if (IS_DAX(inode))
> +			inode->i_fop = &xfs_file_dax_operations;
> +		else
> +			inode->i_fop = &xfs_file_operations;
>  		inode->i_mapping->a_ops = &xfs_address_space_operations;
>  		break;
>  	case S_IFDIR:
> diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
> index a0f84ab..c08983e 100644
> --- a/fs/xfs/xfs_iops.h
> +++ b/fs/xfs/xfs_iops.h
> @@ -23,6 +23,12 @@ struct xfs_inode;
>  extern const struct file_operations xfs_file_operations;
>  extern const struct file_operations xfs_dir_file_operations;
>  
> +#ifdef CONFIG_FS_DAX
> +extern const struct file_operations xfs_file_dax_operations;
> +#else
> +#define xfs_file_dax_operations xfs_file_operations
> +#endif
> +
>  extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
>  
>  /*
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
