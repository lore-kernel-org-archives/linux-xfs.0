Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76CCB7F3F
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 09:30:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5D2FAC001
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 07:30:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ArJaCifmHMrsMtW0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2015 07:29:59 -0700 (PDT)
Date: Thu, 29 Oct 2015 10:29:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] xfs: DAX does not use IO completion callbacks
Message-ID: <20151029142957.GF11663@bfoster.bfoster>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1445225238-30413-5-git-send-email-david@fromorbit.com>
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

On Mon, Oct 19, 2015 at 02:27:16PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For DAX, we are now doing block zeroing and
> we are updating the file size during allocation. This means we no
> longer need an IO completion callback to do these things, so remove
> the completion callbacks from the __dax_fault and __dax_mkwrite
> calls.
> 

Where do we "update the file size during allocation?"

Brian

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c | 39 ---------------------------------------
>  fs/xfs/xfs_aops.h |  1 -
>  fs/xfs/xfs_file.c |  5 ++---
>  3 files changed, 2 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 7b4f849..29e7e5d 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1666,45 +1666,6 @@ xfs_end_io_direct_write(
>  	__xfs_end_io_direct_write(inode, ioend, offset, size);
>  }
>  
> -/*
> - * For DAX we need a mapping buffer callback for unwritten extent conversion
> - * when page faults allocate blocks and then zero them. Note that in this
> - * case the mapping indicated by the ioend may extend beyond EOF. We most
> - * definitely do not want to extend EOF here, so we trim back the ioend size to
> - * EOF.
> - */
> -#ifdef CONFIG_FS_DAX
> -void
> -xfs_end_io_dax_write(
> -	struct buffer_head	*bh,
> -	int			uptodate)
> -{
> -	struct xfs_ioend	*ioend = bh->b_private;
> -	struct inode		*inode = ioend->io_inode;
> -	ssize_t			size = ioend->io_size;
> -
> -	ASSERT(IS_DAX(ioend->io_inode));
> -
> -	/* if there was an error zeroing, then don't convert it */
> -	if (!uptodate)
> -		ioend->io_error = -EIO;
> -
> -	/*
> -	 * Trim update to EOF, so we don't extend EOF during unwritten extent
> -	 * conversion of partial EOF blocks.
> -	 */
> -	spin_lock(&XFS_I(inode)->i_flags_lock);
> -	if (ioend->io_offset + size > i_size_read(inode))
> -		size = i_size_read(inode) - ioend->io_offset;
> -	spin_unlock(&XFS_I(inode)->i_flags_lock);
> -
> -	__xfs_end_io_direct_write(inode, ioend, ioend->io_offset, size);
> -
> -}
> -#else
> -void xfs_end_io_dax_write(struct buffer_head *bh, int uptodate) { }
> -#endif
> -
>  static inline ssize_t
>  xfs_vm_do_dio(
>  	struct inode		*inode,
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index d39ba25..f6ffc9a 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -60,7 +60,6 @@ int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
>  			      struct buffer_head *map_bh, int create);
>  int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
>  			         struct buffer_head *map_bh, int create);
> -void	xfs_end_io_dax_write(struct buffer_head *bh, int uptodate);
>  
>  extern void xfs_count_page_state(struct page *, int *, int *);
>  
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7f873bc..403151a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1508,8 +1508,7 @@ xfs_filemap_page_mkwrite(
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  
>  	if (IS_DAX(inode)) {
> -		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault,
> -				    xfs_end_io_dax_write);
> +		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault, NULL);
>  	} else {
>  		ret = __block_page_mkwrite(vma, vmf, xfs_get_blocks);
>  		ret = block_page_mkwrite_return(ret);
> @@ -1571,7 +1570,7 @@ xfs_filemap_pmd_fault(
>  	file_update_time(vma->vm_file);
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault,
> -				    xfs_end_io_dax_write);
> +			      NULL);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  	sb_end_pagefault(inode->i_sb);
>  
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
