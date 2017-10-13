Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57601 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbdJMHVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 03:21:02 -0400
Date: Fri, 13 Oct 2017 00:21:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/19] dax: Implement dax_finish_sync_fault()
Message-ID: <20171013072101.GE9105@infradead.org>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-15-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011200603.27442-15-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 10:05:58PM +0200, Jan Kara wrote:
> Implement a function that filesystems can call to finish handling of
> synchronous page faults. It takes care of syncing appropriare file range
> and insertion of page table entry.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks fine except for a few nitpicks below:

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +	spin_lock_irq(&mapping->tree_lock);
> +	entry = get_unlocked_mapping_entry(mapping, index, &slot);
> +	/* Did we race with someone splitting entry or so? */
> +	if (!entry || (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
> +	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {

Minor nitpick:

Maybe keep each of the three conditions on a separate line to make it a
little easier to read.

> + * This function calls fdatasync() on the range of file touched by the page
> + * fault and handles inserting of appropriate page table entry.

Nitpick: we don't call fdatasync, as that doesn't even exist in the
kernel, but vfs_fsync_range.  But documenting which functions we call
doesn't seem all that useful to start with, so if you really want to
document it I'd say something like:

"Ensures that the file range touched by the page fault is stored
 persistently on the media"

or similar.

> +	int err;
> +	loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
> +	size_t len = 0;
> +
> +	if (pe_size == PE_SIZE_PTE)
> +		len = PAGE_SIZE;
> +#ifdef CONFIG_FS_DAX_PMD
> +	else if (pe_size == PE_SIZE_PMD)
> +		len = PMD_SIZE;
> +#endif

Is there really any point to ifdef out this single branch?

> +	else
> +		WARN_ON_ONCE(1);
> +	err = vfs_fsync_range(vmf->vma->vm_file, start, start + len - 1, 1);

(this just reminds me that I hate the vfs_fsync_range /->fsync calling
conventions.., offset + len would be way to easy)

