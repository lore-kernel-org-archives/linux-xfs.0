Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B9C3B7F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 06:52:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51401AC003
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 04:52:59 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id G0SEBEYBv7a5aRlf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 04:52:56 -0800 (PST)
Date: Mon, 23 Feb 2015 13:52:50 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: + ext4-add-dax-functionality.patch added to -mm tree
Message-ID: <20150223125250.GB2682@quack.suse.cz>
References: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org>
	<20150115124106.GF12739@quack.suse.cz>
	<100D68C7BA14664A8938383216E40DE040853440@FMSMSX114.amr.corp.intel.com>
	<20150119141858.GF5662@quack.suse.cz>
	<20150217085200.GA23192@quack.suse.cz>
	<20150217133745.GG3364@wil.cx>
	<20150218104009.GB4614@quack.suse.cz>
	<20150220221551.GB2780@wil.cx>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150220221551.GB2780@wil.cx>
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
To: Matthew Wilcox <willy@linux.intel.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "boaz@plexistor.com" <boaz@plexistor.com>, xfs@oss.sgi.com, "Dilger, Andreas" <andreas.dilger@intel.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "hch@lst.de" <hch@lst.de>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, Jan Kara <jack@suse.cz>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>

On Fri 20-02-15 17:15:51, Matthew Wilcox wrote:
> > So to handle this it can start transaction in ext4_dax_fault() /
> > ext4_dax_mkwrite() if write is requested and call ext4_jbd2_file_inode()
> > after dax_fault() / dax_mkwrite() returns. Complete function will look
> > something like follows:
> 
> How about this?  I tried to encompass both the unwritten extent conversion
> as well as starting the journal at the right point in the locking hierarchy.
> 
> If we're going to expose do_dax_fault(), I think it needs to be called
> __dax_fault().
> 
> I decided to return VM_FAULT_RETRY and a new flag VM_FAULT_UNWRITTEN from
> __dax_fault(), rather than convert it to return an errno.
  I don't like using VM_FAULT_RETRY for ENOSPC. Different filesystems may
want different things on this condition. In particular, if a filesystem
decides to use dax_fault(), VM_FAULT_RETRY will get propagated up into mm
code which just retries the fault (or gets confused if FAULT_FLAG_ALLOW_RETRY
wasn't set).

If you want to stay with VM_FAULT_XXX return values (which makes some sense),
then I guess you need something like VM_FAULT_ENOSPC and convert that to
VM_FAULT_SIGBUS in dax_fault().

Otherwise the patch looks good.

								Honza

> P.S. I love patches which touch *both* fs.h *and* mm.h.  In case there
> were any files that weren't already being rebuilt.
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 556238f..81dbdaa 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -316,7 +316,7 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
>  	return error;
>  }
>  
> -static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> +int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  			get_block_t get_block)
>  {
>  	struct file *file = vma->vm_file;
> @@ -329,7 +329,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	sector_t block;
>  	pgoff_t size;
>  	int error;
> -	int major = 0;
> +	int ret = 0;
>  
>  	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	if (vmf->pgoff >= size)
> @@ -367,13 +367,15 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		error = -EIO;		/* fs corruption? */
>  	if (error)
>  		goto unlock_page;
> +	if (buffer_unwritten(&bh))
> +		ret |= VM_FAULT_UNWRITTEN;
>  
>  	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
>  		if (vmf->flags & FAULT_FLAG_WRITE) {
>  			error = get_block(inode, block, &bh, 1);
>  			count_vm_event(PGMAJFAULT);
>  			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> -			major = VM_FAULT_MAJOR;
> +			ret = VM_FAULT_MAJOR;
>  			if (!error && (bh.b_size < PAGE_SIZE))
>  				error = -EIO;
>  			if (error)
> @@ -407,7 +409,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	}
>  
>  	/* Check we didn't race with a read fault installing a new page */
> -	if (!page && major)
> +	if (!page && (ret & VM_FAULT_MAJOR))
>  		page = find_lock_page(mapping, vmf->pgoff);
>  
>  	if (page) {
> @@ -421,12 +423,14 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	error = dax_insert_mapping(inode, &bh, vma, vmf);
>  
>   out:
> +	if (error == -ENOSPC)
> +		return VM_FAULT_RETRY | ret;
>  	if (error == -ENOMEM)
> -		return VM_FAULT_OOM | major;
> +		return VM_FAULT_OOM | ret;
>  	/* -EBUSY is fine, somebody else faulted on the same PTE */
>  	if ((error < 0) && (error != -EBUSY))
> -		return VM_FAULT_SIGBUS | major;
> -	return VM_FAULT_NOPAGE | major;
> +		return VM_FAULT_SIGBUS | ret;
> +	return VM_FAULT_NOPAGE | ret;
>  
>   unlock_page:
>  	if (page) {
> @@ -435,6 +439,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	}
>  	goto out;
>  }
> +EXPORT_SYMBOL_GPL(__dax_fault);
>  
>  /**
>   * dax_fault - handle a page fault on a DAX file
> @@ -455,7 +460,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		sb_start_pagefault(sb);
>  		file_update_time(vma->vm_file);
>  	}
> -	result = do_dax_fault(vma, vmf, get_block);
> +	result = __dax_fault(vma, vmf, get_block);
>  	if (vmf->flags & FAULT_FLAG_WRITE)
>  		sb_end_pagefault(sb);
>  
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 4340e38..84b4f1c 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -194,7 +194,58 @@ errout:
>  #ifdef CONFIG_FS_DAX
>  static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> -	return dax_fault(vma, vmf, ext4_get_block_write);
> +	handle_t *handle;
> +	int create = (vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page;
> +	struct inode *inode = file_inode(vma->vm_file);
> +	int ret, err = 0;
> +	int retries = 0;
> +
> +	if (create) {
> +		sb_start_pagefault(inode->i_sb);
> +		file_update_time(vma->vm_file);
> + retry_alloc:
> +		handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
> +					ext4_writepage_trans_blocks(inode));
> +		if (IS_ERR(handle)) {
> +			err = PTR_ERR(handle);
> +			goto err;
> +		}
> +	}
> +
> +	ret = __dax_fault(vma, vmf, ext4_get_block);
> +
> +	if (create) {
> +		if (ret & VM_FAULT_UNWRITTEN) {
> +			loff_t offset = (loff_t)vmf->pgoff << PAGE_SHIFT;
> +			err = ext4_convert_unwritten_extents(NULL, inode,
> +							offset, PAGE_SIZE);
> +			ret &= ~VM_FAULT_UNWRITTEN;
> +		}
> +		if (!err &&
> +		    ext4_test_inode_state(inode, EXT4_STATE_ORDERED_MODE))
> +			err = ext4_jbd2_file_inode(handle, inode);
> +
> +		if (err == -ENOSPC) {
> +			ret |= VM_FAULT_RETRY;
> +			err = 0;
> +		}
> +
> +		ext4_journal_stop(handle);
> +		if (err < 0)
> +			goto err;
> +		if ((ret & VM_FAULT_RETRY) &&
> +		    ext4_should_retry_alloc(inode->i_sb, &retries))
> +			goto retry_alloc;
> +		ret &= ~VM_FAULT_RETRY;
> +	}
> +
> + out:
> +	if (create)
> +		sb_end_pagefault(inode->i_sb);
> +	return ret;
> + err:
> +	ret = block_page_mkwrite_return(err);
> +	goto out;
>  }
>  
>  static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 85404f1..8f1ea7d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -657,18 +657,6 @@ has_zeroout:
>  	return retval;
>  }
>  
> -static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
> -{
> -	struct inode *inode = bh->b_assoc_map->host;
> -	/* XXX: breaks on 32-bit > 16GB. Is that even supported? */
> -	loff_t offset = (loff_t)(uintptr_t)bh->b_private << inode->i_blkbits;
> -	int err;
> -	if (!uptodate)
> -		return;
> -	WARN_ON(!buffer_unwritten(bh));
> -	err = ext4_convert_unwritten_extents(NULL, inode, offset, bh->b_size);
> -}
> -
>  /* Maximum number of blocks we map for direct IO at once. */
>  #define DIO_MAX_BLOCKS 4096
>  
> @@ -706,11 +694,6 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
>  
>  		map_bh(bh, inode->i_sb, map.m_pblk);
>  		bh->b_state = (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
> -		if (IS_DAX(inode) && buffer_unwritten(bh) && !io_end) {
> -			bh->b_assoc_map = inode->i_mapping;
> -			bh->b_private = (void *)(unsigned long)iblock;
> -			bh->b_end_io = ext4_end_io_unwritten;
> -		}
>  		if (io_end && io_end->flag & EXT4_IO_END_UNWRITTEN)
>  			set_buffer_defer_completion(bh);
>  		bh->b_size = inode->i_sb->s_blocksize * map.m_len;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 239c89c..2af5050 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2597,6 +2597,7 @@ int dax_clear_blocks(struct inode *, sector_t block, long size);
>  int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
>  int dax_truncate_page(struct inode *, loff_t from, get_block_t);
>  int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
> +int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
>  int dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
>  					unsigned int flags, get_block_t);
>  #define dax_mkwrite(vma, vmf, gb)	dax_fault(vma, vmf, gb)
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ceb50ec..ffc9947 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1100,7 +1100,7 @@ static inline int page_mapped(struct page *page)
>  #define VM_FAULT_HWPOISON 0x0010	/* Hit poisoned small page */
>  #define VM_FAULT_HWPOISON_LARGE 0x0020  /* Hit poisoned large page. Index encoded in upper bits */
>  #define VM_FAULT_SIGSEGV 0x0040
> -
> +#define VM_FAULT_UNWRITTEN 0x0080	/* Unwritten extent needs conversion */
>  #define VM_FAULT_NOPAGE	0x0100	/* ->fault installed the pte, not return page */
>  #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
>  #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
