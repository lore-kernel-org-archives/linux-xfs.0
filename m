Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB3917F3F
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 09:27:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B71918F8033
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 07:27:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9BDnC2x9YQwxYKMh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2015 07:27:35 -0700 (PDT)
Date: Thu, 29 Oct 2015 10:27:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/6] xfs: fix inode size update overflow in
	xfs_map_direct()
Message-ID: <20151029142732.GC11663@bfoster.bfoster>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1445225238-30413-2-git-send-email-david@fromorbit.com>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Mon, Oct 19, 2015 at 02:27:13PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Both direct IO and DAX pass an offset and count into get_blocks that
> will overflow a s64 variable when an IO goes into the last supported
> block in a file (i.e. at offset 2^63 - 1FSB bytes). This can be seen
> from the tracing:
> 
> xfs_get_blocks_alloc: [...] offset 0x7ffffffffffff000 count 4096
> xfs_gbmap_direct:     [...] offset 0x7ffffffffffff000 count 4096
> xfs_gbmap_direct_none:[...] offset 0x7ffffffffffff000 count 4096
> 
> 0x7ffffffffffff000 + 4096 = 0x8000000000000000, and hence that
> overflows the s64 offset and we fail to detect the need for a
> filesize update and an ioend is not allocated.
> 
> This is *mostly* avoided for direct IO because such extending IOs
> occur with full block allocation, and so the "IS_UNWRITTEN()" check
> still evaluates as true and we get an ioend that way. However, doing
> single sector extending IOs to this last block will expose the fact
> that file size updates will not occur after the first allocating
> direct IO as the overflow will then be exposed.
> 
> There is one further complexity: the DAX page fault path also
> exposes the same issue in block allocation. However, page faults
> cannot extend the file size, so in this case we want to allocate the
> block but do not want to allocate an ioend to enable file size
> update at IO completion. Hence we now need to distinguish between
> the direct IO patch allocation and dax fault path allocation to
> avoid leaking ioend structures.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c | 50 ++++++++++++++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_aops.h |  2 ++
>  fs/xfs/xfs_file.c |  6 +++---
>  3 files changed, 49 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index e4fff58..366e41eb 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1259,13 +1259,28 @@ xfs_vm_releasepage(
>   * the DIO. There is only going to be one reference to the ioend and its life
>   * cycle is constrained by the DIO completion code. hence we don't need
>   * reference counting here.
> + *
> + * Note that for DIO, an IO to the highest supported file block offset (i.e.
> + * 2^63 - 1FSB bytes) will result in the offset + count overflowing a signed 64
> + * bit variable. Hence if we see this overflow, we have to assume that the IO is
> + * extending the file size. We won't know for sure until IO completion is run
> + * and the actual max write offset is communicated to the IO completion
> + * routine.
> + *
> + * For DAX page faults, we are preparing to never see unwritten extents here,
> + * nor should we ever extend the inode size. Hence we will soon have nothing to
> + * do here for this case, ensuring we don't have to provide an IO completion
> + * callback to free an ioend that we don't actually need for a fault into the
> + * page at offset (2^63 - 1FSB) bytes.
>   */
> +
>  static void
>  xfs_map_direct(
>  	struct inode		*inode,
>  	struct buffer_head	*bh_result,
>  	struct xfs_bmbt_irec	*imap,
> -	xfs_off_t		offset)
> +	xfs_off_t		offset,
> +	bool			dax_fault)
>  {
>  	struct xfs_ioend	*ioend;
>  	xfs_off_t		size = bh_result->b_size;
> @@ -1278,6 +1293,16 @@ xfs_map_direct(
>  
>  	trace_xfs_gbmap_direct(XFS_I(inode), offset, size, type, imap);
>  
> +	/* XXX: preparation for removing unwritten extents in DAX */
> +#if 0
> +	if (dax_fault) {
> +		ASSERT(type == XFS_IO_OVERWRITE);
> +		trace_xfs_gbmap_direct_none(XFS_I(inode), offset, size, type,
> +					    imap);
> +		return;
> +	}
> +#endif
> +
>  	if (bh_result->b_private) {
>  		ioend = bh_result->b_private;
>  		ASSERT(ioend->io_size > 0);
> @@ -1292,7 +1317,8 @@ xfs_map_direct(
>  					      ioend->io_size, ioend->io_type,
>  					      imap);
>  	} else if (type == XFS_IO_UNWRITTEN ||
> -		   offset + size > i_size_read(inode)) {
> +		   offset + size > i_size_read(inode) ||
> +		   offset + size < 0) {
>  		ioend = xfs_alloc_ioend(inode, type);
>  		ioend->io_offset = offset;
>  		ioend->io_size = size;
> @@ -1354,7 +1380,8 @@ __xfs_get_blocks(
>  	sector_t		iblock,
>  	struct buffer_head	*bh_result,
>  	int			create,
> -	bool			direct)
> +	bool			direct,
> +	bool			dax_fault)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -1467,7 +1494,8 @@ __xfs_get_blocks(
>  			set_buffer_unwritten(bh_result);
>  		/* direct IO needs special help */
>  		if (create && direct)
> -			xfs_map_direct(inode, bh_result, &imap, offset);
> +			xfs_map_direct(inode, bh_result, &imap, offset,
> +				       dax_fault);
>  	}
>  
>  	/*
> @@ -1514,7 +1542,7 @@ xfs_get_blocks(
>  	struct buffer_head	*bh_result,
>  	int			create)
>  {
> -	return __xfs_get_blocks(inode, iblock, bh_result, create, false);
> +	return __xfs_get_blocks(inode, iblock, bh_result, create, false, false);
>  }
>  
>  int
> @@ -1524,7 +1552,17 @@ xfs_get_blocks_direct(
>  	struct buffer_head	*bh_result,
>  	int			create)
>  {
> -	return __xfs_get_blocks(inode, iblock, bh_result, create, true);
> +	return __xfs_get_blocks(inode, iblock, bh_result, create, true, false);
> +}
> +
> +int
> +xfs_get_blocks_dax_fault(
> +	struct inode		*inode,
> +	sector_t		iblock,
> +	struct buffer_head	*bh_result,
> +	int			create)
> +{
> +	return __xfs_get_blocks(inode, iblock, bh_result, create, true, true);
>  }
>  
>  static void
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 86afd1a..d39ba25 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -58,6 +58,8 @@ int	xfs_get_blocks(struct inode *inode, sector_t offset,
>  		       struct buffer_head *map_bh, int create);
>  int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
>  			      struct buffer_head *map_bh, int create);
> +int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
> +			         struct buffer_head *map_bh, int create);
>  void	xfs_end_io_dax_write(struct buffer_head *bh, int uptodate);
>  
>  extern void xfs_count_page_state(struct page *, int *, int *);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 2f7b6bd..7f873bc 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1508,7 +1508,7 @@ xfs_filemap_page_mkwrite(
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  
>  	if (IS_DAX(inode)) {
> -		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_direct,
> +		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault,
>  				    xfs_end_io_dax_write);
>  	} else {
>  		ret = __block_page_mkwrite(vma, vmf, xfs_get_blocks);
> @@ -1543,7 +1543,7 @@ xfs_filemap_fault(
>  		 * changes to xfs_get_blocks_direct() to map unwritten extent
>  		 * ioend for conversion on read-only mappings.
>  		 */
> -		ret = __dax_fault(vma, vmf, xfs_get_blocks_direct, NULL);
> +		ret = __dax_fault(vma, vmf, xfs_get_blocks_dax_fault, NULL);
>  	} else
>  		ret = filemap_fault(vma, vmf);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> @@ -1570,7 +1570,7 @@ xfs_filemap_pmd_fault(
>  	sb_start_pagefault(inode->i_sb);
>  	file_update_time(vma->vm_file);
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_direct,
> +	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault,
>  				    xfs_end_io_dax_write);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  	sb_end_pagefault(inode->i_sb);
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
