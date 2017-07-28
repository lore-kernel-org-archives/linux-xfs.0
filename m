Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52421 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751757AbdG1KhC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jul 2017 06:37:02 -0400
Date: Fri, 28 Jul 2017 12:37:00 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/7] dax: Implement dax_pfn_mkwrite()
Message-ID: <20170728103659.GE29433@quack2.suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-7-jack@suse.cz>
 <20170727225322.GG22000@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170727225322.GG22000@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

On Thu 27-07-17 16:53:22, Ross Zwisler wrote:
> On Thu, Jul 27, 2017 at 03:12:44PM +0200, Jan Kara wrote:
> > Implement a function that marks existing page table entry (PTE or PMD)
> > as writeable and takes care of marking it dirty in the radix tree. This
> > function will be used to finish synchronous page fault where the page
> > table entry is first inserted as read-only and then needs to be marked
> > as read-write.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/dax.c            | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/dax.h |  1 +
> >  2 files changed, 49 insertions(+)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 8a6cf158c691..90b763c86dc2 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1485,3 +1485,51 @@ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
> >  	}
> >  }
> >  EXPORT_SYMBOL_GPL(dax_iomap_fault);
> > +
> > +/**
> > + * dax_pfn_mkwrite - make page table entry writeable on a DAX file
> > + * @vmf: The description of the fault
> > + * @pe_size: size of entry to be marked writeable
> > + *
> > + * This function mark PTE or PMD entry as writeable in page tables for mmaped
> > + * DAX file. It takes care of marking corresponding radix tree entry as dirty
> > + * as well.
> > + */
> > +int dax_pfn_mkwrite(struct vm_fault *vmf, enum page_entry_size pe_size)
> 
> I wonder if this incarnation of this function should be named something other
> than *_pfn_mkwrite so that it's clear that unlike in previous versions of the
> codd, this version isn't supposed to be called via
> vm_operations_struct->pfn_mkwrite, but is instead a helper for sync faults?
> Maybe just dax_mkwrite()?

Yeah, I'll change the name.

> > +{
> > +	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> > +	void *entry, **slot;
> > +	pgoff_t index = vmf->pgoff;
> > +	pfn_t pfn = pfn_to_pfn_t(pte_pfn(vmf->orig_pte));
> > +	int vmf_ret, error;
> > +
> > +	spin_lock_irq(&mapping->tree_lock);
> > +	entry = get_unlocked_mapping_entry(mapping, index, &slot);
> > +	/* Did we race with someone splitting entry or so? */
> > +	if (!entry || (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
> > +	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {
> > +		put_unlocked_mapping_entry(mapping, index, entry);
> > +		spin_unlock_irq(&mapping->tree_lock);
> 
> The previous version of this function had tracepoints in this failure path and
> in the successful completion path.  I use this kind of tracing daily for
> debugging, so lets add it back in.

OK, I will add the tracepoints.

> > +		return VM_FAULT_NOPAGE;
> > +	}
> > +	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
> > +	entry = lock_slot(mapping, slot);
> > +	spin_unlock_irq(&mapping->tree_lock);
> > +	switch (pe_size) {
> > +	case PE_SIZE_PTE:
> > +		error = vm_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
> 
> This path goes through the 'mkwrite' branch in insert_pfn() where we validate
> that the PFN we are about to map matches the one pointed to by the existing
> PTE, but I don't see any checks in this path that validate against
> vmf->orig_pte?

Yeah, and that's deliberate. The current PTE (or PMD in PMD fault case) is
the read-only entry installed by dax_iomap_fault() a while ago. We pass the
PFN we map there in vmf->orig_pte (in a very crude way) and in this function
we extract it and pass it to vm_insert_mixed_mkwrite() to verify PFN didn't
change (which would be a bug) and make the PTE writeable. We cannot use
vmf->orig_pte directly for verification as that is just entry we
constructed for passing the PFN, not the real entry. And ultimately I want
to get rid of this hack and just pass PFN in some other way and leave
vmf->orig_pte untouched (which would then be pte_none()).

> This kind of check was done by the old
> dax_pfn_mkwrite()->finish_mkwrite_fault() path via the pte_same() check in
> finish_mkwrite_fault().

Yes, but here the situation is special - we actually know PTE has changed
from pte_none() to the read-only PTE. I was thinking about not changing the
PTE at all during the initial dax_iomap_fault() call (i.e., not mapping the
block read-only), just pass the PFN to the filesystem call handler, and
then install directly writeable PTE with that PFN in the new DAX helper.
Then we could also perform the orig_pte check.

What I dislike about this option is that dax_iomap_fault() would in some
cases not install the PTE and in other cases it would. However I guess it
is not such a huge difference from dax_iomap_fault() sometimes mapping the
entry read-only so maybe this is a cleaner way to go.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
