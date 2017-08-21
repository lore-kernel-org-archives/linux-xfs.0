Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:10084 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753524AbdHUS6c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Aug 2017 14:58:32 -0400
Date: Mon, 21 Aug 2017 12:58:30 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 11/13] dax, iomap: Add support for synchronous faults
Message-ID: <20170821185830.GB26220@linux.intel.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-12-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-12-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Thu, Aug 17, 2017 at 06:08:13PM +0200, Jan Kara wrote:
> Add a flag to iomap interface informing the caller that inode needs
> fdstasync(2) for returned extent to become persistent and use it in DAX
> fault code so that we map such extents only read only. We propagate the
> information that the page table entry has been inserted write-protected
> from dax_iomap_fault() with a new VM_FAULT_RO flag. Filesystem fault
> handler is then responsible for calling fdatasync(2) and updating page
> tables to map pfns read-write. dax_iomap_fault() also takes care of
> updating vmf->orig_pte to match the PTE that was inserted so that we can
> safely recheck that PTE did not change while write-enabling it.

This changelog needs a little love.  s/VM_FAULT_RO/VM_FAULT_NEEDDSYNC/, the
new path doesn't do the RO mapping, but instead just does the entire RW
mapping after the fdatasync is complete, the vmf->orig_pte manipulation went
away, etc.

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dax.c              | 31 +++++++++++++++++++++++++++++++
>  include/linux/iomap.h |  2 ++
>  include/linux/mm.h    |  6 +++++-
>  3 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index bc040e654cc9..ca88fc356786 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1177,6 +1177,22 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
>  			goto error_finish_iomap;
>  		}
>  
> +		/*
> +		 * If we are doing synchronous page fault and inode needs fsync,
> +		 * we can insert PTE into page tables only after that happens.
> +		 * Skip insertion for now and return the pfn so that caller can
> +		 * insert it after fsync is done.
> +		 */
> +		if (write && (vma->vm_flags & VM_SYNC) &&
> +		    (iomap.flags & IOMAP_F_NEEDDSYNC)) {

Just a small nit, but I don't think we really need to check for 'write' here.
The fact that IOMAP_F_NEEDDSYNC is set tells us that we are doing a write.

	if ((flags & IOMAP_WRITE) &&
	    !jbd2_transaction_committed(EXT4_SB(inode->i_sb)->s_journal,
					EXT4_I(inode)->i_datasync_tid))
		iomap->flags |= IOMAP_F_NEEDDSYNC;

Ditto for the PMD case.

With that one simplification and a cleaned up changelog, you can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> +			if (WARN_ON_ONCE(!pfnp)) {
> +				error = -EIO;
> +				goto error_finish_iomap;
> +			}
> +			*pfnp = pfn;
> +			vmf_ret = VM_FAULT_NEEDDSYNC | major;
> +			goto finish_iomap;
> +		}
>  		trace_dax_insert_mapping(inode, vmf, entry);
>  		if (write)
>  			error = vm_insert_mixed_mkwrite(vma, vaddr, pfn);
