Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:53858 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751600AbdG0W5k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 18:57:40 -0400
Date: Thu, 27 Jul 2017 16:57:39 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 7/7] ext4: Support for synchronous DAX faults
Message-ID: <20170727225739.GH22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-8-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170727131245.28279-8-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

On Thu, Jul 27, 2017 at 03:12:45PM +0200, Jan Kara wrote:
> We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin() for a
> synchronous write fault when inode has some uncommitted metadata
> changes. In the fault handler ext4_dax_fault() we then detect this case,
> call vfs_fsync_range() to make sure all metadata is committed, and call
> dax_pfn_mkwrite() to mark PTE as writeable. Note that this will also
> dirty corresponding radix tree entry which is what we want - fsync(2)
> will still provide data integrity guarantees for applications not using
> userspace flushing. And applications using userspace flushing can avoid
> calling fsync(2) and thus avoid the performance overhead.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c       | 35 +++++++++++++++++++++++++++++------
>  fs/ext4/inode.c      |  4 ++++
>  fs/jbd2/journal.c    | 16 ++++++++++++++++
>  include/linux/jbd2.h |  1 +
>  4 files changed, 50 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index d401403e5095..b221d0b546b0 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -287,16 +287,39 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
>  		down_read(&EXT4_I(inode)->i_mmap_sem);
>  		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
>  					       EXT4_DATA_TRANS_BLOCKS(sb));
> +		if (IS_ERR(handle)) {
> +			up_read(&EXT4_I(inode)->i_mmap_sem);
> +			sb_end_pagefault(sb);
> +			return VM_FAULT_SIGBUS;
> +		}

Yay, this error handling seems cleaner to me anyway.

>  	} else {
>  		down_read(&EXT4_I(inode)->i_mmap_sem);
>  	}
> -	if (!IS_ERR(handle))
> -		result = dax_iomap_fault(vmf, pe_size, false, &ext4_iomap_ops);
> -	else
> -		result = VM_FAULT_SIGBUS;
> +	result = dax_iomap_fault(vmf, pe_size, IS_SYNC(inode), &ext4_iomap_ops);
>  	if (write) {
> -		if (!IS_ERR(handle))
> -			ext4_journal_stop(handle);
> +		ext4_journal_stop(handle);
> +		/* Write fault but PFN mapped only RO? */
> +		if (result & VM_FAULT_RO) {
> +			int err;
> +			loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
> +			size_t len = 0;
> +
> +			if (pe_size == PE_SIZE_PTE)
> +				len = PAGE_SIZE;
> +#ifdef CONFIG_FS_DAX_PMD
> +			else if (pe_size == PE_SIZE_PMD)
> +				len = HPAGE_PMD_SIZE;
> +			else
> +				WARN_ON_ONCE(1);

I think this "else WARN_ON_ONCE(1);" should live outside of the
CONFIG_FS_DAX_PMD so that we get warned in all configs if we get an
unsupported pe_size.

> +#endif
> +			WARN_ON_ONCE(!IS_SYNC(inode));
> +			err = vfs_fsync_range(vmf->vma->vm_file, start,
> +					      start + len - 1, 1);
> +			if (err)
> +				result = VM_FAULT_SIGBUS;
> +			else
> +				result = dax_pfn_mkwrite(vmf, pe_size);
> +		}
>  		up_read(&EXT4_I(inode)->i_mmap_sem);
>  		sb_end_pagefault(sb);
>  	} else {
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3c600f02673f..e68231bb227c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3429,6 +3429,10 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	}
>  
>  	iomap->flags = 0;
> +	if ((flags & IOMAP_FAULT) && (flags & IOMAP_WRITE) && IS_SYNC(inode) &&
> +	    !jbd2_transaction_committed(EXT4_SB(inode->i_sb)->s_journal,
> +					EXT4_I(inode)->i_datasync_tid))
> +		iomap->flags |= IOMAP_F_NEEDDSYNC;

Do we need to check for (flags & IOMAP_FAULT), or can we rely on the fact that
we are in ext4_iomap_begin()?
