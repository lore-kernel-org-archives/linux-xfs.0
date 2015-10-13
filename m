Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 564607F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 12:53:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 146C7304039
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 10:53:18 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id o6BN9gJj8B4IudDO (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2015 10:53:16 -0700 (PDT)
Date: Tue, 13 Oct 2015 19:53:10 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] vfs: remove unused wrapper block_page_mkwrite()
Message-ID: <20151013175310.GB13268@quack.suse.cz>
References: <1444753180-27993-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444753180-27993-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: linux-nilfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue 13-10-15 10:19:40, Ross Zwisler wrote:
> The function currently called "__block_page_mkwrite()" used to be called
> "block_page_mkwrite()" until a wrapper for this function was added by:
> 
> commit 24da4fab5a61 ("vfs: Create __block_page_mkwrite() helper passing
> 	error values back")
> 
> This wrapper, the current "block_page_mkwrite()", is currently unused.
> __block_page_mkwrite() is used directly by ext4, nilfs2 and xfs.
> 
> Remove the unused wrapper and rename __block_page_mkwrite() back to
> block_page_mkwrite().
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>

Looks good. But can you please fix up comment before new
block_page_mkwrite() to state sb_start_pagefault() - sb_end_pagefault()
instead of sb_start_write() - sb_end_write? Thanks! You can add:

Reviewed-by: Jan Kara <jack@suse.com>

								Honza

> ---
>  fs/buffer.c                 | 22 +---------------------
>  fs/ext4/inode.c             |  4 ++--
>  fs/nilfs2/file.c            |  2 +-
>  fs/xfs/xfs_file.c           |  2 +-
>  include/linux/buffer_head.h |  2 --
>  5 files changed, 5 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 82283ab..7e496dc 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2422,7 +2422,7 @@ EXPORT_SYMBOL(block_commit_write);
>   * Direct callers of this function should protect against filesystem freezing
>   * using sb_start_write() - sb_end_write() functions.
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
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
