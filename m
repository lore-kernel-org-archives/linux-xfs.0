Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D67D36A358;
	Mon, 27 Jul 2026 22:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785191628; cv=none; b=BhWZhGXeYWobOqHTidK+bl/x7WtbjhD4akyt8uKtWoI0+l0J50WduGVW3jy3LI8Gl8GTsa2DzMNYVg67lVu4ofIk+RtiJfvNz3MrPLZkyH4cpxwBd0dVP97NO7LIZXOEao4xygbX9RUHwnQqwQqbsOkUlgmRfFonKVjqSsk4zDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785191628; c=relaxed/simple;
	bh=boQ3wvigkRkQuI/DIXVvxl4mP1YudHOq6hGwPQn07jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZrwF51VGE+WJUk44b0aRw5qXIkCmqSEinz/mA8sZhtyYYjKf2rmQzju+IlUMnmLBMXgZjQDqR2J6O6/rpLPGnO/fgDkwxcpGrK33PJZPxI8gh8dQ85sj4tnZWN0VjSjCsIA/MPM/LqxNhZyxvg+Sq/JgVCdij27Kf/VPX9nSks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/fbSOu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/fbSOu1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F20A51F000E9;
	Mon, 27 Jul 2026 22:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785191626;
	bh=hkPkgX83I80bxWsTzLeVbgEQ2XZC0ownCjz2jE4zYO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b/fbSOu1Jq918mCzffSULnMg4ht1hzzU1/yMmo8HA258q7mWDKpEG9BDjbmA2c5+K
	 aFh6EnG82b+keLK7TtzewOJDFT/HxYrCbBeQFI0As/VnSTgxjTdbS6obK4Jg8CpSXc
	 DVwzqtDp4lZeVESld7LqDnQNGT20xGDsQ85ryKUgGPDJOxVZ+MJ38/QuQNTlmWtzxI
	 Oa56gt7i2njSAJyWfWZUUnygadnqWD5fcICUGkeZ2hwywIrJTgyB/QYieSTfNSuZ9w
	 7XxMTkj8QhwLKfIH5C7cINUhOH2g3djHTSaaNmk6EmfKYqeusw8b9pDcLSQP95nFMp
	 xYw4VBK9YCJIA==
Date: Mon, 27 Jul 2026 15:33:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, hch@lst.de,
	linux-fsdevel@vger.kernel.org, changfengnan@bytedance.com,
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>, tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 20/21] iomap: pass iomap_iter_next_fn directly instead
 of struct iomap_ops
Message-ID: <20260727223345.GI2901224@frogsfrogsfrogs>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
 <20260727211758.1116539-21-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727211758.1116539-21-joannelkoong@gmail.com>

On Mon, Jul 27, 2026 at 02:17:57PM -0700, Joanne Koong wrote:
> Now that all filesystems implement ->iomap_next() and the legacy
> ->iomap_begin()/->iomap_end() fallback is gone, struct iomap_ops only
> wraps a single iomap_next function pointer. Drop the struct entirely and
> pass the iomap_iter_next_fn directly to iomap_iter() and all the
> iomap/dax entry points. Filesystems pass their iomap_iter_next_fn
> callback directly instead of an ops struct. Several iomap_iter_next_fn
> callbacks become non-static and gain header declarations since callers
> now reference them directly.
> 
> The iomap_iter tracepoint's ops field is renamed to next to match. These
> tracepoints are explicitly not stable ABI (see the note in iomap/trace.h).
> 
> No functional change intended other than the tracepoint field rename
> noted above.
> 
> Acked-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  block/fops.c           | 10 +++-----
>  fs/btrfs/direct-io.c   |  8 ++----
>  fs/dax.c               | 48 ++++++++++++++++++------------------
>  fs/erofs/data.c        | 28 +++++++++------------
>  fs/erofs/internal.h    |  3 ++-
>  fs/erofs/zmap.c        |  7 +-----
>  fs/exfat/file.c        | 18 +++++++-------
>  fs/exfat/inode.c       |  6 ++---
>  fs/exfat/iomap.c       | 16 +++---------
>  fs/exfat/iomap.h       |  6 +++--
>  fs/ext2/ext2.h         |  3 ++-
>  fs/ext2/file.c         |  4 +--
>  fs/ext2/inode.c        |  9 ++-----
>  fs/ext4/ext4.h         |  6 +++--
>  fs/ext4/extents.c      |  8 ++----
>  fs/ext4/file.c         | 14 +++++------
>  fs/ext4/inode.c        | 18 ++++----------
>  fs/f2fs/data.c         |  6 +----
>  fs/f2fs/f2fs.h         |  3 ++-
>  fs/f2fs/file.c         |  4 +--
>  fs/fuse/dax.c          | 10 +++-----
>  fs/fuse/file.c         | 10 +++-----
>  fs/gfs2/aops.c         |  6 ++---
>  fs/gfs2/bmap.c         |  9 ++-----
>  fs/gfs2/bmap.h         |  3 ++-
>  fs/gfs2/file.c         |  6 ++---
>  fs/gfs2/inode.c        |  6 ++---
>  fs/hpfs/file.c         |  6 +----
>  fs/internal.h          |  1 -
>  fs/iomap/buffered-io.c | 40 +++++++++++++++---------------
>  fs/iomap/direct-io.c   |  8 +++---
>  fs/iomap/fiemap.c      |  8 +++---
>  fs/iomap/iter.c        |  9 +++----
>  fs/iomap/seek.c        |  8 +++---
>  fs/iomap/swapfile.c    |  4 +--
>  fs/iomap/trace.h       | 12 ++++-----
>  fs/ntfs/aops.c         |  6 ++---
>  fs/ntfs/file.c         | 24 +++++++++---------
>  fs/ntfs/inode.c        |  2 +-
>  fs/ntfs/iomap.c        | 40 ++++++------------------------
>  fs/ntfs/iomap.h        | 15 ++++++++----
>  fs/ntfs3/file.c        | 16 ++++++------
>  fs/ntfs3/inode.c       | 13 +++-------
>  fs/ntfs3/ntfs_fs.h     |  3 ++-
>  fs/remap_range.c       |  6 ++---
>  fs/xfs/xfs_aops.c      |  8 +++---
>  fs/xfs/xfs_file.c      | 44 ++++++++++++++++-----------------
>  fs/xfs/xfs_iomap.c     | 55 +++++++++---------------------------------
>  fs/xfs/xfs_iomap.h     | 24 ++++++++++++------
>  fs/xfs/xfs_iops.c      |  4 +--
>  fs/xfs/xfs_reflink.c   |  6 ++---
>  fs/zonefs/file.c       | 22 ++++++-----------
>  include/linux/dax.h    | 18 ++++++--------
>  include/linux/fs.h     |  7 ++++--
>  include/linux/iomap.h  | 54 +++++++++++++++++++----------------------
>  55 files changed, 313 insertions(+), 425 deletions(-)
> 

<skip to xfs>

> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index cffcec532ea6..d2d3c84d93f9 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -53,14 +53,22 @@ int xfs_read_iomap_begin(struct inode *inode, loff_t offset,
>  		loff_t length, unsigned flags, struct iomap *iomap,
>  		struct iomap *srcmap);
>  
> -extern const struct iomap_ops xfs_buffered_write_iomap_ops;
> -extern const struct iomap_ops xfs_direct_write_iomap_ops;
> -extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
> -extern const struct iomap_ops xfs_read_iomap_ops;
> -extern const struct iomap_ops xfs_seek_iomap_ops;
> -extern const struct iomap_ops xfs_xattr_iomap_ops;
> -extern const struct iomap_ops xfs_dax_write_iomap_ops;
> -extern const struct iomap_ops xfs_atomic_write_cow_iomap_ops;
> +int xfs_buffered_write_iomap_next(const struct iomap_iter *iter,
> +		struct iomap *iomap, struct iomap *srcmap);

I wonder, would it make more sense to have a macro to define the forward
declaration?  e.g.

#define DECLARE_IOMAP_NEXT(name) \
	int name(...)

DECLARE_IOMAP_NEXT(xfs_buffered_write_iomap_next);

Hm?

Though feel free to say "declaration macros suck!" because they do.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +int xfs_direct_write_iomap_next(const struct iomap_iter *iter,
> +		struct iomap *iomap, struct iomap *srcmap);
> +int xfs_zoned_direct_write_iomap_next(const struct iomap_iter *iter,
> +		struct iomap *iomap, struct iomap *srcmap);
> +int xfs_read_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
> +		struct iomap *srcmap);
> +int xfs_seek_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
> +		struct iomap *srcmap);
> +int xfs_xattr_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
> +		struct iomap *srcmap);
> +int xfs_dax_write_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
> +		struct iomap *srcmap);
> +int xfs_atomic_write_cow_iomap_next(const struct iomap_iter *iter,
> +		struct iomap *iomap, struct iomap *srcmap);
>  extern const struct iomap_write_ops xfs_iomap_write_ops;
>  
>  #endif /* __XFS_IOMAP_H__*/
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 6339f4956ecb..5c3d9a365f93 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1239,10 +1239,10 @@ xfs_vn_fiemap(
>  	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
>  		fieinfo->fi_flags &= ~FIEMAP_FLAG_XATTR;
>  		error = iomap_fiemap(inode, fieinfo, start, length,
> -				&xfs_xattr_iomap_ops);
> +				xfs_xattr_iomap_next);
>  	} else {
>  		error = iomap_fiemap(inode, fieinfo, start, length,
> -				&xfs_read_iomap_ops);
> +				xfs_read_iomap_next);
>  	}
>  	xfs_iunlock(XFS_I(inode), XFS_IOLOCK_SHARED);
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index a5c188b78138..2b9792626bab 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1683,7 +1683,7 @@ xfs_reflink_remap_prep(
>  				pos_out, len, remap_flags);
>  	else
>  		ret = dax_remap_file_range_prep(file_in, pos_in, file_out,
> -				pos_out, len, remap_flags, &xfs_read_iomap_ops);
> +				pos_out, len, remap_flags, xfs_read_iomap_next);
>  	if (ret || *len == 0)
>  		goto out_unlock;
>  
> @@ -1878,10 +1878,10 @@ xfs_reflink_unshare(
>  
>  	if (IS_DAX(inode))
>  		error = dax_file_unshare(inode, offset, len,
> -				&xfs_dax_write_iomap_ops);
> +				xfs_dax_write_iomap_next);
>  	else
>  		error = iomap_file_unshare(inode, offset, len,
> -				&xfs_buffered_write_iomap_ops,
> +				xfs_buffered_write_iomap_next,
>  				&xfs_iomap_write_ops);
>  	if (error)
>  		goto out;
> diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
> index 5b34849be7a2..319d9502ba56 100644
> --- a/fs/zonefs/file.c
> +++ b/fs/zonefs/file.c
> @@ -59,10 +59,6 @@ static int zonefs_read_iomap_begin(struct inode *inode, loff_t offset,
>  
>  static DEFINE_IOMAP_ITER_NEXT(zonefs_read_iomap_next, zonefs_read_iomap_begin);
>  
> -static const struct iomap_ops zonefs_read_iomap_ops = {
> -	.iomap_next	= zonefs_read_iomap_next,
> -};
> -
>  static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
>  				    loff_t length, unsigned int flags,
>  				    struct iomap *iomap, struct iomap *srcmap)
> @@ -111,19 +107,15 @@ static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
>  static DEFINE_IOMAP_ITER_NEXT(zonefs_write_iomap_next,
>  			      zonefs_write_iomap_begin);
>  
> -static const struct iomap_ops zonefs_write_iomap_ops = {
> -	.iomap_next	= zonefs_write_iomap_next,
> -};
> -
>  static int zonefs_read_folio(struct file *unused, struct folio *folio)
>  {
> -	iomap_bio_read_folio(folio, &zonefs_read_iomap_ops);
> +	iomap_bio_read_folio(folio, zonefs_read_iomap_next);
>  	return 0;
>  }
>  
>  static void zonefs_readahead(struct readahead_control *rac)
>  {
> -	iomap_bio_readahead(rac, &zonefs_read_iomap_ops);
> +	iomap_bio_readahead(rac, zonefs_read_iomap_next);
>  }
>  
>  /*
> @@ -184,7 +176,7 @@ static int zonefs_swap_activate(struct swap_info_struct *sis,
>  	}
>  
>  	return iomap_swapfile_activate(sis, swap_file, span,
> -				       &zonefs_read_iomap_ops);
> +				       zonefs_read_iomap_next);
>  }
>  
>  const struct address_space_operations zonefs_file_aops = {
> @@ -314,7 +306,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
>  
>  	/* Serialize against truncates */
>  	filemap_invalidate_lock_shared(inode->i_mapping);
> -	ret = iomap_page_mkwrite(vmf, &zonefs_write_iomap_ops, NULL);
> +	ret = iomap_page_mkwrite(vmf, zonefs_write_iomap_next, NULL);
>  	filemap_invalidate_unlock_shared(inode->i_mapping);
>  
>  	sb_end_pagefault(inode->i_sb);
> @@ -530,7 +522,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
>  	 * page invalidation. Overwrite that error code with EBUSY so that
>  	 * the user can make sense of the error.
>  	 */
> -	ret = iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
> +	ret = iomap_dio_rw(iocb, from, zonefs_write_iomap_next,
>  			   &zonefs_write_dio_ops, 0, NULL, 0);
>  	if (ret == -ENOTBLK)
>  		ret = -EBUSY;
> @@ -580,7 +572,7 @@ static ssize_t zonefs_file_buffered_write(struct kiocb *iocb,
>  	if (ret <= 0)
>  		goto inode_unlock;
>  
> -	ret = iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops,
> +	ret = iomap_file_buffered_write(iocb, from, zonefs_write_iomap_next,
>  			NULL, NULL);
>  	if (ret == -EIO)
>  		zonefs_io_error(inode, true);
> @@ -675,7 +667,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  			goto inode_unlock;
>  		}
>  		file_accessed(iocb->ki_filp);
> -		ret = iomap_dio_rw(iocb, to, &zonefs_read_iomap_ops,
> +		ret = iomap_dio_rw(iocb, to, zonefs_read_iomap_next,
>  				   &zonefs_read_dio_ops, 0, NULL, 0);
>  	} else {
>  		ret = generic_file_read_iter(iocb, to);
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index fe6c3ded1b50..e0bc653ffe9f 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_DAX_H
>  
>  #include <linux/fs.h>
> +#include <linux/iomap.h>
>  #include <linux/mm.h>
>  #include <linux/radix-tree.h>
>  
> @@ -10,9 +11,6 @@ typedef unsigned long dax_entry_t;
>  
>  struct dax_device;
>  struct gendisk;
> -struct iomap_ops;
> -struct iomap_iter;
> -struct iomap;
>  
>  enum dax_access_mode {
>  	DAX_ACCESS,
> @@ -213,11 +211,11 @@ static inline void dax_unlock_mapping_entry(struct address_space *mapping,
>  #endif
>  
>  int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
> -		const struct iomap_ops *ops);
> +		iomap_iter_next_fn next);
>  int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
> -		const struct iomap_ops *ops);
> +		iomap_iter_next_fn next);
>  int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
> -		const struct iomap_ops *ops);
> +		iomap_iter_next_fn next);
>  
>  static inline bool dax_page_is_idle(struct page *page)
>  {
> @@ -266,10 +264,10 @@ int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off, u64 len,
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
>  
>  ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
> -		const struct iomap_ops *ops);
> +		iomap_iter_next_fn next);
>  vm_fault_t dax_iomap_fault(struct vm_fault *vmf, unsigned int order,
>  			unsigned long *pfnp, int *errp,
> -			const struct iomap_ops *ops);
> +			iomap_iter_next_fn next);
>  vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
>  		unsigned int order, unsigned long pfn);
>  int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
> @@ -288,11 +286,11 @@ void dax_break_layout_final(struct inode *inode);
>  int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  				  struct inode *dest, loff_t destoff,
>  				  loff_t len, bool *is_same,
> -				  const struct iomap_ops *ops);
> +				  iomap_iter_next_fn next);
>  int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  			      struct file *file_out, loff_t pos_out,
>  			      loff_t *len, unsigned int remap_flags,
> -			      const struct iomap_ops *ops);
> +			      iomap_iter_next_fn next);
>  static inline bool dax_mapping(struct address_space *mapping)
>  {
>  	return mapping->host && IS_DAX(mapping->host);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index d10897b3a1e3..2eb063438a3b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -70,7 +70,8 @@ struct fsnotify_mark_connector;
>  struct fs_context;
>  struct fs_parameter_spec;
>  struct file_kattr;
> -struct iomap_ops;
> +struct iomap_iter;
> +struct iomap;
>  struct delegated_inode;
>  
>  extern void __init inode_init(void);
> @@ -2079,7 +2080,9 @@ int remap_verify_area(struct file *file, loff_t pos, loff_t len, bool write);
>  int __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  				    struct file *file_out, loff_t pos_out,
>  				    loff_t *len, unsigned int remap_flags,
> -				    const struct iomap_ops *dax_read_ops);
> +				    int (*dax_read_next)(const struct iomap_iter *iter,
> +							 struct iomap *iomap,
> +							 struct iomap *srcmap));
>  int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  				  struct file *file_out, loff_t pos_out,
>  				  loff_t *count, unsigned int remap_flags);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 0bc1beb47a09..1875e21ce164 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -239,10 +239,6 @@ typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
>  typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
>  		struct iomap *iomap, struct iomap *srcmap);
>  
> -struct iomap_ops {
> -	iomap_iter_next_fn iomap_next;
> -};
> -
>  /**
>   * struct iomap_iter - Iterate through a range of a file
>   * @inode: Set at the start of the iteration and should not change.
> @@ -254,7 +250,7 @@ struct iomap_ops {
>   *	incremental iter advance.
>   * @status: Status of the most recent iteration. Zero on success or a negative
>   *	errno on error.
> - * @flags: Zero or more of the iomap_next flags above.
> + * @flags: Zero or more of the iomap_iter_next flags above.
>   * @iomap: Map describing the I/O iteration
>   * @srcmap: Source map for COW operations
>   */
> @@ -271,7 +267,7 @@ struct iomap_iter {
>  	void *private;
>  };
>  
> -int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops);
> +int iomap_iter(struct iomap_iter *iter, iomap_iter_next_fn next);
>  int iomap_iter_advance(struct iomap_iter *iter, u64 count);
>  
>  /**
> @@ -339,7 +335,7 @@ int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
>   * @begin: callback that produces a mapping for the current position
>   * @end: optional callback that finishes the previous mapping, or NULL
>   *
> - * Inline helper that implements the common body of an ->iomap_next()
> + * Inline helper that implements the common body of an iomap_iter_next_fn
>   * callback: it finishes the previous mapping via @end (if present), decides
>   * via iomap_iter_continue() whether to keep going, and obtains the next
>   * mapping via @begin.
> @@ -427,15 +423,15 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
>  }
>  
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
> -		const struct iomap_ops *ops,
> +		iomap_iter_next_fn next,
>  		const struct iomap_write_ops *write_ops, void *private);
>  int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
> -		const void *buf, const struct iomap_ops *ops,
> +		const void *buf, iomap_iter_next_fn next,
>  		const struct iomap_write_ops *write_ops);
> -void iomap_read_folio(const struct iomap_ops *ops,
> -		struct iomap_read_folio_ctx *ctx, void *private);
> -void iomap_readahead(const struct iomap_ops *ops,
> -		struct iomap_read_folio_ctx *ctx, void *private);
> +void iomap_read_folio(iomap_iter_next_fn next, struct iomap_read_folio_ctx *ctx,
> +		void *private);
> +void iomap_readahead(iomap_iter_next_fn next, struct iomap_read_folio_ctx *ctx,
> +		void *private);
>  bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
>  struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len);
>  bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
> @@ -443,17 +439,17 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
>  bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
>  void iomap_folio_mark_uptodate(struct folio *folio);
>  int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
> -		const struct iomap_ops *ops,
> +		iomap_iter_next_fn next,
>  		const struct iomap_write_ops *write_ops);
>  unsigned int iomap_fill_dirty_folios(struct iomap_iter *iter, loff_t *start,
>  		loff_t end, unsigned int *iomap_flags);
>  int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
> -		bool *did_zero, const struct iomap_ops *ops,
> +		bool *did_zero, iomap_iter_next_fn next,
>  		const struct iomap_write_ops *write_ops, void *private);
>  int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
> -		const struct iomap_ops *ops,
> +		iomap_iter_next_fn next,
>  		const struct iomap_write_ops *write_ops, void *private);
> -vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops,
> +vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, iomap_iter_next_fn next,
>  		void *private);
>  typedef void (*iomap_punch_t)(struct inode *inode, loff_t offset, loff_t length,
>  		struct iomap *iomap);
> @@ -462,13 +458,13 @@ void iomap_write_delalloc_release(struct inode *inode, loff_t start_byte,
>  		iomap_punch_t punch);
>  
>  int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> -		u64 start, u64 len, const struct iomap_ops *ops);
> +		u64 start, u64 len, iomap_iter_next_fn next);
>  loff_t iomap_seek_hole(struct inode *inode, loff_t offset,
> -		const struct iomap_ops *ops);
> +		iomap_iter_next_fn next);
>  loff_t iomap_seek_data(struct inode *inode, loff_t offset,
> -		const struct iomap_ops *ops);
> +		iomap_iter_next_fn next);
>  sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
> -		const struct iomap_ops *ops);
> +		iomap_iter_next_fn next);
>  
>  /*
>   * Flags for iomap_ioend->io_flags.
> @@ -675,10 +671,10 @@ struct iomap_dio_ops {
>  #define IOMAP_DIO_BOUNCE		(1 << 4)
>  
>  ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> -		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
> +		iomap_iter_next_fn next, const struct iomap_dio_ops *dops,
>  		unsigned int dio_flags, void *private, size_t done_before);
>  struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> -		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
> +		iomap_iter_next_fn next, const struct iomap_dio_ops *dops,
>  		unsigned int dio_flags, void *private, size_t done_before);
>  ssize_t iomap_dio_complete(struct iomap_dio *dio);
>  void iomap_dio_bio_end_io(struct bio *bio);
> @@ -754,9 +750,9 @@ struct swap_info_struct;
>  
>  int iomap_swapfile_activate(struct swap_info_struct *sis,
>  		struct file *swap_file, sector_t *pagespan,
> -		const struct iomap_ops *ops);
> +		iomap_iter_next_fn next);
>  #else
> -# define iomap_swapfile_activate(sis, swapfile, pagespan, ops)	(-EIO)
> +# define iomap_swapfile_activate(sis, swapfile, pagespan, next) (-EIO)
>  #endif /* CONFIG_SWAP */
>  
>  extern struct bio_set iomap_ioend_bioset;
> @@ -768,25 +764,25 @@ int iomap_bio_read_folio_range(const struct iomap_iter *iter,
>  extern const struct iomap_read_ops iomap_bio_read_ops;
>  
>  static inline void iomap_bio_read_folio(struct folio *folio,
> -		const struct iomap_ops *ops)
> +		iomap_iter_next_fn next)
>  {
>  	struct iomap_read_folio_ctx ctx = {
>  		.ops		= &iomap_bio_read_ops,
>  		.cur_folio	= folio,
>  	};
>  
> -	iomap_read_folio(ops, &ctx, NULL);
> +	iomap_read_folio(next, &ctx, NULL);
>  }
>  
>  static inline void iomap_bio_readahead(struct readahead_control *rac,
> -		const struct iomap_ops *ops)
> +		iomap_iter_next_fn next)
>  {
>  	struct iomap_read_folio_ctx ctx = {
>  		.ops		= &iomap_bio_read_ops,
>  		.rac		= rac,
>  	};
>  
> -	iomap_readahead(ops, &ctx, NULL);
> +	iomap_readahead(next, &ctx, NULL);
>  }
>  #endif /* CONFIG_BLOCK */
>  
> -- 
> 2.52.0
> 
> 
