Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43901 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751231AbdHXHSW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 03:18:22 -0400
Date: Thu, 24 Aug 2017 09:18:19 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 13/13] ext4: Support for synchronous DAX faults
Message-ID: <20170824071819.GC20465@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-14-jack@suse.cz>
 <20170823183714.GH13778@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170823183714.GH13778@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, Boaz Harrosh <boazh@netapp.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org

On Wed 23-08-17 11:37:14, Christoph Hellwig wrote:
> > +	pfn_t pfn;
> >  
> >  	if (write) {
> >  		sb_start_pagefault(sb);
> > @@ -287,16 +288,39 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
> >  		down_read(&EXT4_I(inode)->i_mmap_sem);
> >  		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
> >  					       EXT4_DATA_TRANS_BLOCKS(sb));
> > +		if (IS_ERR(handle)) {
> > +			up_read(&EXT4_I(inode)->i_mmap_sem);
> > +			sb_end_pagefault(sb);
> > +			return VM_FAULT_SIGBUS;
> > +		}
> >  	} else {
> >  		down_read(&EXT4_I(inode)->i_mmap_sem);
> >  	}
> > -	if (!IS_ERR(handle))
> > -		result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, NULL);
> > -	else
> > -		result = VM_FAULT_SIGBUS;
> > +	result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, &pfn);
> 
> Maybe split the error handling refactor into a simple prep patch to
> make this one more readable?

OK, will do.

> > +		/* Write fault but PFN mapped only RO? */
> > +		if (result & VM_FAULT_NEEDDSYNC) {
> > +			int err;
> > +			loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
> > +			size_t len = 0;
> > +
> > +			if (pe_size == PE_SIZE_PTE)
> > +				len = PAGE_SIZE;
> > +#ifdef CONFIG_FS_DAX_PMD
> > +			else if (pe_size == PE_SIZE_PMD)
> > +				len = HPAGE_PMD_SIZE;
> > +#endif
> > +			else
> > +				WARN_ON_ONCE(1);
> > +			err = vfs_fsync_range(vmf->vma->vm_file, start,
> > +					      start + len - 1, 1);
> > +			if (err)
> > +				result = VM_FAULT_SIGBUS;
> > +			else
> > +				result = dax_insert_pfn_mkwrite(vmf, pe_size,
> > +								pfn);
> > +		}
> 
> I think this needs to become a helper exported from the DAX code,
> way too much magic inside the file system as-is.

Good point, there isn't anything fs specific in there.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
