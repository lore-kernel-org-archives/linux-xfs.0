Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58919 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750835AbdH3Jes (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 05:34:48 -0400
Date: Wed, 30 Aug 2017 11:34:45 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] xfs: consolidate the various page fault handlers
Message-ID: <20170830093445.GB28354@quack2.suse.cz>
References: <20170829162613.27270-1-hch@lst.de>
 <20170829162613.27270-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829162613.27270-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, jack@suse.cz

On Tue 29-08-17 18:26:13, Christoph Hellwig wrote:
> Add a new __xfs_filemap_fault helper that implements all four page fault
> callouts, and make these methods themselves small stubs that set the
> correct write_fault flag, and exit early for the non-DAX case for the
> hugepage related ones.
> 
> Also remove the extra size checking in the pfn_fault path, which is now
> handled in the core DAX code.
> 
> Life would be so much simpler if we only had one method for all this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just I'd note that the check for IS_DAX in xfs_filemap_fault() (to set
write_fault argument) is racy wrt changing of the inode flag (as it was
before) but that's a problem to be fixed separately I guess.

								Honza

> ---
>  fs/xfs/xfs_file.c  | 96 +++++++++++++++++++-----------------------------------
>  fs/xfs/xfs_trace.h | 29 +++++++++++++++--
>  2 files changed, 60 insertions(+), 65 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 8b0181c6d2a6..0debbc7e3f03 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1011,95 +1011,67 @@ xfs_file_llseek(
>   *       page_lock (MM)
>   *         i_lock (XFS - extent map serialisation)
>   */
> -
> -/*
> - * mmap()d file has taken write protection fault and is being made writable. We
> - * can set the page state up correctly for a writable page, which means we can
> - * do correct delalloc accounting (ENOSPC checking!) and unwritten extent
> - * mapping.
> - */
> -STATIC int
> -xfs_filemap_page_mkwrite(
> -	struct vm_fault		*vmf)
> +static int
> +__xfs_filemap_fault(
> +	struct vm_fault		*vmf,
> +	enum page_entry_size	pe_size,
> +	bool			write_fault)
>  {
>  	struct inode		*inode = file_inode(vmf->vma->vm_file);
> +	struct xfs_inode	*ip = XFS_I(inode);
>  	int			ret;
>  
> -	trace_xfs_filemap_page_mkwrite(XFS_I(inode));
> +	trace_xfs_filemap_fault(ip, pe_size, write_fault);
>  
> -	sb_start_pagefault(inode->i_sb);
> -	file_update_time(vmf->vma->vm_file);
> -	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +	if (write_fault) {
> +		sb_start_pagefault(inode->i_sb);
> +		file_update_time(vmf->vma->vm_file);
> +	}
>  
> +	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  	if (IS_DAX(inode)) {
> -		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
> +		ret = dax_iomap_fault(vmf, pe_size, &xfs_iomap_ops);
>  	} else {
> -		ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
> +		if (write_fault)
> +			ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
> +		else
> +			ret = filemap_fault(vmf);
>  	}
> -
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	sb_end_pagefault(inode->i_sb);
>  
> +	if (write_fault)
> +		sb_end_pagefault(inode->i_sb);
>  	return ret;
>  }
>  
> -STATIC int
> +static int
>  xfs_filemap_fault(
>  	struct vm_fault		*vmf)
>  {
> -	struct inode		*inode = file_inode(vmf->vma->vm_file);
> -	int			ret;
> -
> -	trace_xfs_filemap_fault(XFS_I(inode));
> -
>  	/* DAX can shortcut the normal fault path on write faults! */
> -	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(inode))
> -		return xfs_filemap_page_mkwrite(vmf);
> -
> -	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	if (IS_DAX(inode))
> -		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
> -	else
> -		ret = filemap_fault(vmf);
> -	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -
> -	return ret;
> +	return __xfs_filemap_fault(vmf, PE_SIZE_PTE,
> +			IS_DAX(file_inode(vmf->vma->vm_file)) &&
> +			(vmf->flags & FAULT_FLAG_WRITE));
>  }
>  
> -/*
> - * Similar to xfs_filemap_fault(), the DAX fault path can call into here on
> - * both read and write faults. Hence we need to handle both cases. There is no
> - * ->huge_mkwrite callout for huge pages, so we have a single function here to
> - * handle both cases here. @flags carries the information on the type of fault
> - * occuring.
> - */
> -STATIC int
> +static int
>  xfs_filemap_huge_fault(
>  	struct vm_fault		*vmf,
>  	enum page_entry_size	pe_size)
>  {
> -	struct inode		*inode = file_inode(vmf->vma->vm_file);
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	int			ret;
> -
> -	if (!IS_DAX(inode))
> +	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
>  		return VM_FAULT_FALLBACK;
>  
> -	trace_xfs_filemap_huge_fault(ip);
> -
> -	if (vmf->flags & FAULT_FLAG_WRITE) {
> -		sb_start_pagefault(inode->i_sb);
> -		file_update_time(vmf->vma->vm_file);
> -	}
> -
> -	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	ret = dax_iomap_fault(vmf, pe_size, &xfs_iomap_ops);
> -	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -
> -	if (vmf->flags & FAULT_FLAG_WRITE)
> -		sb_end_pagefault(inode->i_sb);
> +	/* DAX can shortcut the normal fault path on write faults! */
> +	return __xfs_filemap_fault(vmf, pe_size,
> +			(vmf->flags & FAULT_FLAG_WRITE));
> +}
>  
> -	return ret;
> +static int
> +xfs_filemap_page_mkwrite(
> +	struct vm_fault		*vmf)
> +{
> +	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index bcc3cdf8e1c5..bae243ad7f3b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -689,11 +689,34 @@ DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
>  
> -DEFINE_INODE_EVENT(xfs_filemap_fault);
> -DEFINE_INODE_EVENT(xfs_filemap_huge_fault);
> -DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
>  DEFINE_INODE_EVENT(xfs_filemap_pfn_mkwrite);
>  
> +TRACE_EVENT(xfs_filemap_fault,
> +	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
> +		 bool write_fault),
> +	TP_ARGS(ip, pe_size, write_fault),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_ino_t, ino)
> +		__field(enum page_entry_size, pe_size)
> +		__field(bool, write_fault)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> +		__entry->ino = ip->i_ino;
> +		__entry->pe_size = pe_size;
> +		__entry->write_fault = write_fault;
> +	),
> +	TP_printk("dev %d:%d ino 0x%llx %s write_fault %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino,
> +		  __print_symbolic(__entry->pe_size,
> +			{ PE_SIZE_PTE,	"PTE" },
> +			{ PE_SIZE_PMD,	"PMD" },
> +			{ PE_SIZE_PUD,	"PUD" }),
> +		  __entry->write_fault)
> +)
> +
>  DECLARE_EVENT_CLASS(xfs_iref_class,
>  	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
>  	TP_ARGS(ip, caller_ip),
> -- 
> 2.11.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
