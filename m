Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5D137F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 21:04:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6282304059
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 19:04:01 -0700 (PDT)
Received: from mail-pa0-f42.google.com (mail-pa0-f42.google.com
	[209.85.220.42]) by cuda.sgi.com with ESMTP id pU4ubbZ3dOaBob8H
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2015 19:03:59 -0700 (PDT)
Received: by pacex6 with SMTP id ex6so38221008pac.3
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 19:03:59 -0700 (PDT)
Date: Wed, 14 Oct 2015 11:03:52 +0900 (JST)
Message-Id: <20151014.110352.146137690378248054.konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH v2] vfs: remove unused wrapper block_page_mkwrite()
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1444776662-26574-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1444776662-26574-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nilfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, 13 Oct 2015 16:51:02 -0600, Ross Zwisler wrote:
> The function currently called "__block_page_mkwrite()" used to be called
> "block_page_mkwrite()" until a wrapper for this function was added by:
> 
> commit 24da4fab5a61 ("vfs: Create __block_page_mkwrite() helper passing
> 	error values back")
> 
> This wrapper, the current "block_page_mkwrite()", is currently unused.
> __block_page_mkwrite() is used directly by ext4, nilfs2 and xfs.
> 
> Remove the unused wrapper, rename __block_page_mkwrite() back to
> block_page_mkwrite() and update the comment above block_page_mkwrite().
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Jan Kara <jack@suse.com>
> Cc: Jan Kara <jack@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Thanks,
Ryusuke Konishi

> ---
>  fs/buffer.c                 | 24 ++----------------------
>  fs/ext4/inode.c             |  4 ++--
>  fs/nilfs2/file.c            |  2 +-
>  fs/xfs/xfs_file.c           |  2 +-
>  include/linux/buffer_head.h |  2 --
>  5 files changed, 6 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 82283ab..e46c916 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2420,9 +2420,9 @@ EXPORT_SYMBOL(block_commit_write);
>   * unlock the page.
>   *
>   * Direct callers of this function should protect against filesystem freezing
> - * using sb_start_write() - sb_end_write() functions.
> + * using sb_start_pagefault() - sb_end_pagefault() functions.
>   */
> -int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> +int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  			 get_block_t get_block)
>  {
>  	struct page *page = vmf->page;
> @@ -2459,26 +2459,6 @@ out_unlock:
>  	unlock_page(page);
>  	return ret;
>  }
> -EXPORT_SYMBOL(__block_page_mkwrite);
> -
> -int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> -		   get_block_t get_block)
> -{
> -	int ret;
> -	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> -
> -	sb_start_pagefault(sb);
> -
> -	/*
> -	 * Update file times before taking page lock. We may end up failing the
> -	 * fault so this update may be superfluous but who really cares...
> -	 */
> -	file_update_time(vma->vm_file);
> -
> -	ret = __block_page_mkwrite(vma, vmf, get_block);
> -	sb_end_pagefault(sb);
> -	return block_page_mkwrite_return(ret);
> -}
>  EXPORT_SYMBOL(block_page_mkwrite);
>  
>  /*
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 612fbcf..2d1ecd2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5244,7 +5244,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	    !ext4_should_journal_data(inode) &&
>  	    !ext4_nonda_switch(inode->i_sb)) {
>  		do {
> -			ret = __block_page_mkwrite(vma, vmf,
> +			ret = block_page_mkwrite(vma, vmf,
>  						   ext4_da_get_block_prep);
>  		} while (ret == -ENOSPC &&
>  		       ext4_should_retry_alloc(inode->i_sb, &retries));
> @@ -5291,7 +5291,7 @@ retry_alloc:
>  		ret = VM_FAULT_SIGBUS;
>  		goto out;
>  	}
> -	ret = __block_page_mkwrite(vma, vmf, get_block);
> +	ret = block_page_mkwrite(vma, vmf, get_block);
>  	if (!ret && ext4_should_journal_data(inode)) {
>  		if (ext4_walk_page_buffers(handle, page_buffers(page), 0,
>  			  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index 54575e3..088ba00 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -109,7 +109,7 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  		goto out;
>  
>  	file_update_time(vma->vm_file);
> -	ret = __block_page_mkwrite(vma, vmf, nilfs_get_block);
> +	ret = block_page_mkwrite(vma, vmf, nilfs_get_block);
>  	if (ret) {
>  		nilfs_transaction_abort(inode->i_sb);
>  		goto out;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e78feb4..f80e90f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1506,7 +1506,7 @@ xfs_filemap_page_mkwrite(
>  		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_direct,
>  				    xfs_end_io_dax_write);
>  	} else {
> -		ret = __block_page_mkwrite(vma, vmf, xfs_get_blocks);
> +		ret = block_page_mkwrite(vma, vmf, xfs_get_blocks);
>  		ret = block_page_mkwrite_return(ret);
>  	}
>  
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index e6797de..89d9aa9 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -227,8 +227,6 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
>  			get_block_t *, loff_t *);
>  int generic_cont_expand_simple(struct inode *inode, loff_t size);
>  int block_commit_write(struct page *page, unsigned from, unsigned to);
> -int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> -				get_block_t get_block);
>  int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  				get_block_t get_block);
>  /* Convert errno to return value from ->page_mkwrite() call */
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
