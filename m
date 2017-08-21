Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41226 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754404AbdHUVJR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Aug 2017 17:09:17 -0400
Date: Mon, 21 Aug 2017 15:09:16 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 11/13] dax, iomap: Add support for synchronous faults
Message-ID: <20170821210916.GF26220@linux.intel.com>
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
> 
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
> +			if (WARN_ON_ONCE(!pfnp)) {
> +				error = -EIO;
> +				goto error_finish_iomap;
> +			}
> +			*pfnp = pfn;
> +			vmf_ret = VM_FAULT_NEEDDSYNC | major;
> +			goto finish_iomap;
> +		}

Sorry for the second reply, but I spotted this during my testing.

The radix tree entry is inserted and marked as dirty by the
dax_insert_mapping_entry() call a few lines above this newly added block.

I think that this patch should prevent the radix tree entry that we insert
from being marked as dirty, and let the dax_insert_pfn_mkwrite() handler do
that work.  Right now it is being made dirty twice, which we don't need.

Just inserting the entry as clean here and then marking it as dirty later in
dax_insert_pfn_mkwrite() keeps the radix tree entry dirty state consistent
with the PTE dirty state.  It also solves an issue we have right now where the
newly inserted dirty entry will immediately be flushed as part of the
vfs_fsync_range() call that the filesystem will do before
dax_insert_pfn_mkwrite(). 

For example, here's a trace of a PMD write fault on a completely sparse file:

  dax_pmd_fault: dev 259:0 ino 0xc shared WRITE|ALLOW_RETRY|KILLABLE|USER
  address 0x7feab8e00000 vm_start 0x7feab8e00000 vm_end 0x7feab9000000 pgoff
  0x0 max_pgoff 0x1ff 
  
  dax_pmd_fault_done: dev 259:0 ino 0xc shared WRITE|ALLOW_RETRY|KILLABLE|USER
  address 0x7feab8e00000 vm_start 0x7feab8e00000 vm_end 0x7feab9000000 pgoff
  0x0 max_pgoff 0x1ff NEEDDSYNC
  
  dax_writeback_range: dev 259:0 ino 0xc pgoff 0x0-0x1ff
  
  dax_writeback_one: dev 259:0 ino 0xc pgoff 0x0 pglen 0x200
  
  dax_writeback_range_done: dev 259:0 ino 0xc pgoff 0x1-0x1ff
  
  dax_insert_pfn_mkwrite: dev 259:0 ino 0xc shared
  WRITE|ALLOW_RETRY|KILLABLE|USER address 0x7feab8e00000 pgoff 0x0 NOPAGE

The PMD that we are writing back with dax_writeback_one() is the one that we
just made dirty via the first 1/2 of the sync fault, before we've installed a
page table entry.  This fix might speed up some of your test measurements as
well.
