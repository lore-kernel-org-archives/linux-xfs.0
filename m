Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22102 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934677AbdAHUge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 15:36:34 -0500
Date: Sun, 8 Jan 2017 12:36:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: constify struct iomap_ops
Message-ID: <20170108203627.GA14038@birch.djwong.org>
References: <1483901500-1728-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483901500-1728-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sun, Jan 08, 2017 at 07:51:40PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c              |  6 +++---
>  fs/ext2/ext2.h        |  2 +-
>  fs/ext2/inode.c       |  4 ++--
>  fs/ext4/ext4.h        |  2 +-
>  fs/ext4/inode.c       |  2 +-
>  fs/internal.h         |  2 +-
>  fs/iomap.c            | 18 +++++++++---------
>  fs/xfs/xfs_iomap.c    |  4 ++--
>  fs/xfs/xfs_iomap.h    |  4 ++--
>  include/linux/dax.h   |  8 ++++----
>  include/linux/iomap.h | 14 +++++++-------
>  11 files changed, 33 insertions(+), 33 deletions(-)

Looks reasonable enough to me, so
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5c74f60..d11b481 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1054,7 +1054,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>   */
>  ssize_t
>  dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
> -		struct iomap_ops *ops)
> +		const struct iomap_ops *ops)
>  {
>  	struct address_space *mapping = iocb->ki_filp->f_mapping;
>  	struct inode *inode = mapping->host;
> @@ -1098,7 +1098,7 @@ static int dax_fault_return(int error)
>   * necessary locking for the page fault to proceed successfully.
>   */
>  int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> -			struct iomap_ops *ops)
> +			const struct iomap_ops *ops)
>  {
>  	struct address_space *mapping = vma->vm_file->f_mapping;
>  	struct inode *inode = mapping->host;
> @@ -1297,7 +1297,7 @@ static int dax_pmd_load_hole(struct vm_area_struct *vma, pmd_t *pmd,
>  }
>  
>  int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> -		pmd_t *pmd, unsigned int flags, struct iomap_ops *ops)
> +		pmd_t *pmd, unsigned int flags, const struct iomap_ops *ops)
>  {
>  	struct address_space *mapping = vma->vm_file->f_mapping;
>  	unsigned long pmd_addr = address & PMD_MASK;
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 37e2be7..5e64de9 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -814,7 +814,7 @@ extern const struct file_operations ext2_file_operations;
>  /* inode.c */
>  extern const struct address_space_operations ext2_aops;
>  extern const struct address_space_operations ext2_nobh_aops;
> -extern struct iomap_ops ext2_iomap_ops;
> +extern const struct iomap_ops ext2_iomap_ops;
>  
>  /* namei.c */
>  extern const struct inode_operations ext2_dir_inode_operations;
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index f073bfc..128cce5 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -842,13 +842,13 @@ ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
>  	return 0;
>  }
>  
> -struct iomap_ops ext2_iomap_ops = {
> +const struct iomap_ops ext2_iomap_ops = {
>  	.iomap_begin		= ext2_iomap_begin,
>  	.iomap_end		= ext2_iomap_end,
>  };
>  #else
>  /* Define empty ops for !CONFIG_FS_DAX case to avoid ugly ifdefs */
> -struct iomap_ops ext2_iomap_ops;
> +const struct iomap_ops ext2_iomap_ops;
>  #endif /* CONFIG_FS_DAX */
>  
>  int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2163c1e..ce70403 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3253,7 +3253,7 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
>  	}
>  }
>  
> -extern struct iomap_ops ext4_iomap_ops;
> +extern const struct iomap_ops ext4_iomap_ops;
>  
>  #endif	/* __KERNEL__ */
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 88d57af..96c2e12 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3420,7 +3420,7 @@ static int ext4_iomap_end(struct inode *inode, loff_t offset, loff_t length,
>  	return ret;
>  }
>  
> -struct iomap_ops ext4_iomap_ops = {
> +const struct iomap_ops ext4_iomap_ops = {
>  	.iomap_begin		= ext4_iomap_begin,
>  	.iomap_end		= ext4_iomap_end,
>  };
> diff --git a/fs/internal.h b/fs/internal.h
> index b63cf3a..11c6d89 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -182,7 +182,7 @@ typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
>  		void *data, struct iomap *iomap);
>  
>  loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
> -		unsigned flags, struct iomap_ops *ops, void *data,
> +		unsigned flags, const struct iomap_ops *ops, void *data,
>  		iomap_actor_t actor);
>  
>  /* direct-io.c: */
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 354a123..7f08ca0 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -41,7 +41,7 @@
>   */
>  loff_t
>  iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
> -		struct iomap_ops *ops, void *data, iomap_actor_t actor)
> +		const struct iomap_ops *ops, void *data, iomap_actor_t actor)
>  {
>  	struct iomap iomap = { 0 };
>  	loff_t written = 0, ret;
> @@ -232,7 +232,7 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  
>  ssize_t
>  iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *iter,
> -		struct iomap_ops *ops)
> +		const struct iomap_ops *ops)
>  {
>  	struct inode *inode = iocb->ki_filp->f_mapping->host;
>  	loff_t pos = iocb->ki_pos, ret = 0, written = 0;
> @@ -315,7 +315,7 @@ iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  
>  int
>  iomap_file_dirty(struct inode *inode, loff_t pos, loff_t len,
> -		struct iomap_ops *ops)
> +		const struct iomap_ops *ops)
>  {
>  	loff_t ret;
>  
> @@ -395,7 +395,7 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
>  
>  int
>  iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
> -		struct iomap_ops *ops)
> +		const struct iomap_ops *ops)
>  {
>  	loff_t ret;
>  
> @@ -415,7 +415,7 @@ EXPORT_SYMBOL_GPL(iomap_zero_range);
>  
>  int
>  iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
> -		struct iomap_ops *ops)
> +		const struct iomap_ops *ops)
>  {
>  	unsigned blocksize = (1 << inode->i_blkbits);
>  	unsigned off = pos & (blocksize - 1);
> @@ -443,7 +443,7 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
>  }
>  
>  int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> -		struct iomap_ops *ops)
> +		const struct iomap_ops *ops)
>  {
>  	struct page *page = vmf->page;
>  	struct inode *inode = file_inode(vma->vm_file);
> @@ -542,7 +542,7 @@ iomap_fiemap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  }
>  
>  int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
> -		loff_t start, loff_t len, struct iomap_ops *ops)
> +		loff_t start, loff_t len, const struct iomap_ops *ops)
>  {
>  	struct fiemap_ctx ctx;
>  	loff_t ret;
> @@ -836,8 +836,8 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>  }
>  
>  ssize_t
> -iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter, struct iomap_ops *ops,
> -		iomap_dio_end_io_t end_io)
> +iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> +		const struct iomap_ops *ops, iomap_dio_end_io_t end_io)
>  {
>  	struct address_space *mapping = iocb->ki_filp->f_mapping;
>  	struct inode *inode = file_inode(iocb->ki_filp);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 0d14742..3ec8ff7 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1144,7 +1144,7 @@ xfs_file_iomap_end(
>  	return 0;
>  }
>  
> -struct iomap_ops xfs_iomap_ops = {
> +const struct iomap_ops xfs_iomap_ops = {
>  	.iomap_begin		= xfs_file_iomap_begin,
>  	.iomap_end		= xfs_file_iomap_end,
>  };
> @@ -1190,6 +1190,6 @@ xfs_xattr_iomap_begin(
>  	return error;
>  }
>  
> -struct iomap_ops xfs_xattr_iomap_ops = {
> +const struct iomap_ops xfs_xattr_iomap_ops = {
>  	.iomap_begin		= xfs_xattr_iomap_begin,
>  };
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index 6d45cf0..705224b 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -33,7 +33,7 @@ void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
>  		struct xfs_bmbt_irec *);
>  xfs_extlen_t xfs_eof_alignment(struct xfs_inode *ip, xfs_extlen_t extsize);
>  
> -extern struct iomap_ops xfs_iomap_ops;
> -extern struct iomap_ops xfs_xattr_iomap_ops;
> +extern const struct iomap_ops xfs_iomap_ops;
> +extern const struct iomap_ops xfs_xattr_iomap_ops;
>  
>  #endif /* __XFS_IOMAP_H__*/
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 24ad711..2983e52 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -37,9 +37,9 @@ static inline void *dax_radix_locked_entry(sector_t sector, unsigned long flags)
>  }
>  
>  ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
> -		struct iomap_ops *ops);
> +		const struct iomap_ops *ops);
>  int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> -			struct iomap_ops *ops);
> +			const struct iomap_ops *ops);
>  int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
>  int dax_invalidate_mapping_entry(struct address_space *mapping, pgoff_t index);
>  int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
> @@ -72,7 +72,7 @@ static inline unsigned int dax_radix_order(void *entry)
>  	return 0;
>  }
>  int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> -		pmd_t *pmd, unsigned int flags, struct iomap_ops *ops);
> +		pmd_t *pmd, unsigned int flags, const struct iomap_ops *ops);
>  #else
>  static inline unsigned int dax_radix_order(void *entry)
>  {
> @@ -80,7 +80,7 @@ static inline unsigned int dax_radix_order(void *entry)
>  }
>  static inline int dax_iomap_pmd_fault(struct vm_area_struct *vma,
>  		unsigned long address, pmd_t *pmd, unsigned int flags,
> -		struct iomap_ops *ops)
> +		const struct iomap_ops *ops)
>  {
>  	return VM_FAULT_FALLBACK;
>  }
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index a4c94b8..891459c 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -72,17 +72,17 @@ struct iomap_ops {
>  };
>  
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
> -		struct iomap_ops *ops);
> +		const struct iomap_ops *ops);
>  int iomap_file_dirty(struct inode *inode, loff_t pos, loff_t len,
> -		struct iomap_ops *ops);
> +		const struct iomap_ops *ops);
>  int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
> -		bool *did_zero, struct iomap_ops *ops);
> +		bool *did_zero, const struct iomap_ops *ops);
>  int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
> -		struct iomap_ops *ops);
> +		const struct iomap_ops *ops);
>  int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> -		struct iomap_ops *ops);
> +		const struct iomap_ops *ops);
>  int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> -		loff_t start, loff_t len, struct iomap_ops *ops);
> +		loff_t start, loff_t len, const struct iomap_ops *ops);
>  
>  /*
>   * Flags for direct I/O ->end_io:
> @@ -92,6 +92,6 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  typedef int (iomap_dio_end_io_t)(struct kiocb *iocb, ssize_t ret,
>  		unsigned flags);
>  ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> -		struct iomap_ops *ops, iomap_dio_end_io_t end_io);
> +		const struct iomap_ops *ops, iomap_dio_end_io_t end_io);
>  
>  #endif /* LINUX_IOMAP_H */
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
