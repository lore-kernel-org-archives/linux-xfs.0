Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53429 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932396AbdHWShP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 14:37:15 -0400
Date: Wed, 23 Aug 2017 11:37:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/13] ext4: Support for synchronous DAX faults
Message-ID: <20170823183714.GH13778@infradead.org>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-14-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-14-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org

> +	pfn_t pfn;
>  
>  	if (write) {
>  		sb_start_pagefault(sb);
> @@ -287,16 +288,39 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
>  		down_read(&EXT4_I(inode)->i_mmap_sem);
>  		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
>  					       EXT4_DATA_TRANS_BLOCKS(sb));
> +		if (IS_ERR(handle)) {
> +			up_read(&EXT4_I(inode)->i_mmap_sem);
> +			sb_end_pagefault(sb);
> +			return VM_FAULT_SIGBUS;
> +		}
>  	} else {
>  		down_read(&EXT4_I(inode)->i_mmap_sem);
>  	}
> -	if (!IS_ERR(handle))
> -		result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, NULL);
> -	else
> -		result = VM_FAULT_SIGBUS;
> +	result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, &pfn);

Maybe split the error handling refactor into a simple prep patch to
make this one more readable?

> +		/* Write fault but PFN mapped only RO? */
> +		if (result & VM_FAULT_NEEDDSYNC) {
> +			int err;
> +			loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
> +			size_t len = 0;
> +
> +			if (pe_size == PE_SIZE_PTE)
> +				len = PAGE_SIZE;
> +#ifdef CONFIG_FS_DAX_PMD
> +			else if (pe_size == PE_SIZE_PMD)
> +				len = HPAGE_PMD_SIZE;
> +#endif
> +			else
> +				WARN_ON_ONCE(1);
> +			err = vfs_fsync_range(vmf->vma->vm_file, start,
> +					      start + len - 1, 1);
> +			if (err)
> +				result = VM_FAULT_SIGBUS;
> +			else
> +				result = dax_insert_pfn_mkwrite(vmf, pe_size,
> +								pfn);
> +		}

I think this needs to become a helper exported from the DAX code,
way too much magic inside the file system as-is.
