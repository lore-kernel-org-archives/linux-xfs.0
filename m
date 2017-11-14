Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39204 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdKNCTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2017 21:19:54 -0500
Date: Mon, 13 Nov 2017 18:19:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/18] xfs: Implement xfs_filemap_pfn_mkwrite() using
 __xfs_filemap_fault()
Message-ID: <20171114021913.GH25227@magnolia>
References: <20171101153648.30166-1-jack@suse.cz>
 <20171101153648.30166-18-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101153648.30166-18-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Nov 01, 2017 at 04:36:46PM +0100, Jan Kara wrote:
> xfs_filemap_pfn_mkwrite() duplicates a lot of __xfs_filemap_fault().
> It will also need to handle flushing for synchronous page faults. So
> just make that function use __xfs_filemap_fault().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_file.c  | 29 ++++-------------------------
>  fs/xfs/xfs_trace.h |  2 --
>  2 files changed, 4 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7c6b8def6eed..4496b45678de 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1085,37 +1085,16 @@ xfs_filemap_page_mkwrite(
>  }
>  
>  /*
> - * pfn_mkwrite was originally inteneded to ensure we capture time stamp
> - * updates on write faults. In reality, it's need to serialise against
> - * truncate similar to page_mkwrite. Hence we cycle the XFS_MMAPLOCK_SHARED
> - * to ensure we serialise the fault barrier in place.
> + * pfn_mkwrite was originally intended to ensure we capture time stamp updates
> + * on write faults. In reality, it needs to serialise against truncate and
> + * prepare memory for writing so handle is as standard write fault.
>   */
>  static int
>  xfs_filemap_pfn_mkwrite(
>  	struct vm_fault		*vmf)
>  {
>  
> -	struct inode		*inode = file_inode(vmf->vma->vm_file);
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	int			ret = VM_FAULT_NOPAGE;
> -	loff_t			size;
> -
> -	trace_xfs_filemap_pfn_mkwrite(ip);
> -
> -	sb_start_pagefault(inode->i_sb);
> -	file_update_time(vmf->vma->vm_file);
> -
> -	/* check if the faulting page hasn't raced with truncate */
> -	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> -	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -	if (vmf->pgoff >= size)
> -		ret = VM_FAULT_SIGBUS;
> -	else if (IS_DAX(inode))
> -		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, &xfs_iomap_ops);
> -	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> -	sb_end_pagefault(inode->i_sb);
> -	return ret;
> -
> +	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
>  }
>  
>  static const struct vm_operations_struct xfs_file_vm_ops = {
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index bb5514688d47..6333ad09e0f3 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -688,8 +688,6 @@ DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
>  
> -DEFINE_INODE_EVENT(xfs_filemap_pfn_mkwrite);
> -
>  TRACE_EVENT(xfs_filemap_fault,
>  	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
>  		 bool write_fault),
> -- 
> 2.12.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
