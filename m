Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:2860 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751454AbdG0WWb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 18:22:31 -0400
Date: Thu, 27 Jul 2017 16:22:30 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 4/7] dax: Make dax_insert_mapping() return VM_FAULT_ state
Message-ID: <20170727222230.GE22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-5-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170727131245.28279-5-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

On Thu, Jul 27, 2017 at 03:12:42PM +0200, Jan Kara wrote:
> Currently dax_insert_mapping() returns normal error code which is later
> converted to VM_FAULT_ state. Since we will need to do more state
> modifications specific to dax_insert_mapping() it does not make sense to
> push them up to the caller of dax_insert_mapping(). Instead make
> dax_insert_mapping() return VM_FAULT_ state the same way as
> dax_pmd_insert_mapping() does that.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dax.c | 45 +++++++++++++++++++++++++--------------------
>  1 file changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 0673efd72f53..9658975b926a 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -814,6 +814,15 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
>  
> +static int dax_fault_return(int error)
> +{
> +	if (error == 0)
> +		return VM_FAULT_NOPAGE;
> +	if (error == -ENOMEM)
> +		return VM_FAULT_OOM;
> +	return VM_FAULT_SIGBUS;
> +}
> +
>  static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
>  {
>  	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
> @@ -828,7 +837,7 @@ static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
>  	unsigned long vaddr = vmf->address;
>  	void *ret, *kaddr;
>  	pgoff_t pgoff;
> -	int id, rc;
> +	int id, rc, vmf_ret;
>  	pfn_t pfn;
>  
>  	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
> @@ -850,9 +859,18 @@ static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
>  
>  	trace_dax_insert_mapping(mapping->host, vmf, ret);
>  	if (vmf->flags & FAULT_FLAG_WRITE)
> -		return vm_insert_mixed_mkwrite(vma, vaddr, pfn);
> +		rc = vm_insert_mixed_mkwrite(vma, vaddr, pfn);
>  	else
> -		return vm_insert_mixed(vma, vaddr, pfn);
> +		rc = vm_insert_mixed(vma, vaddr, pfn);
> +
> +	/* -EBUSY is fine, somebody else faulted on the same PTE */
> +	if (rc == -EBUSY)
> +		rc = 0;
> +
> +	vmf_ret = dax_fault_return(rc);

Prior to this point where we convert our 'rc' (which is a normal error code
like 0, -ENOMEM, etc) to a 'vmf_ret' (which is a VM return code like
VM_FAULT_NOPAGE, VM_FAULT_SIGBUS, etc), there are several paths in
dax_insert_mapping() where we could still return a normal error code.  I think
this will confuse the fault handler because this code will get returned all
the way up to do_fault() which expects to get a VM return code.

So, I think we either need to:

a) Make sure all return paths through dax_insert_mapping() end up going
through dax_fault_return(), as we do in the PMD case, or

b) Keep allowing this function to return normal error codes, and just teach
dax_fault_return() to look for IOMAP_F_NEEDSYNC flag so it knows when to set
VM_FAULT_RO.
