Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933012AbcJMPya (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Oct 2016 11:54:30 -0400
Date: Thu, 13 Oct 2016 17:42:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v6 15/17] dax: add struct iomap based DAX PMD support
Message-ID: <20161013154224.GB30680@quack2.suse.cz>
References: <20161012225022.15507-1-ross.zwisler@linux.intel.com>
 <20161012225022.15507-16-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161012225022.15507-16-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Wed 12-10-16 16:50:20, Ross Zwisler wrote:
> DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
> locking.  This patch allows DAX PMDs to participate in the DAX radix tree
> based locking scheme so that they can be re-enabled using the new struct
> iomap based fault handlers.
> 
> There are currently three types of DAX 4k entries: 4k zero pages, 4k DAX
> mappings that have an associated block allocation, and 4k DAX empty
> entries.  The empty entries exist to provide locking for the duration of a
> given page fault.
> 
> This patch adds three equivalent 2MiB DAX entries: Huge Zero Page (HZP)
> entries, PMD DAX entries that have associated block allocations, and 2 MiB
> DAX empty entries.
> 
> Unlike the 4k case where we insert a struct page* into the radix tree for
> 4k zero pages, for HZP we insert a DAX exceptional entry with the new
> RADIX_DAX_HZP flag set.  This is because we use a single 2 MiB zero page in
> every 2MiB hole mapping, and it doesn't make sense to have that same struct
> page* with multiple entries in multiple trees.  This would cause contention
> on the single page lock for the one Huge Zero Page, and it would break the
> page->index and page->mapping associations that are assumed to be valid in
> many other places in the kernel.
> 
> One difficult use case is when one thread is trying to use 4k entries in
> radix tree for a given offset, and another thread is using 2 MiB entries
> for that same offset.  The current code handles this by making the 2 MiB
> user fall back to 4k entries for most cases.  This was done because it is
> the simplest solution, and because the use of 2MiB pages is already
> opportunistic.
> 
> If we were to try to upgrade from 4k pages to 2MiB pages for a given range,
> we run into the problem of how we lock out 4k page faults for the entire
> 2MiB range while we clean out the radix tree so we can insert the 2MiB
> entry.  We can solve this problem if we need to, but I think that the cases
> where both 2MiB entries and 4K entries are being used for the same range
> will be rare enough and the gain small enough that it probably won't be
> worth the complexity.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Just one small bug below. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

after fixing that.

>  	/* No entry for given index? Make sure radix tree is big enough. */
> -	if (!entry) {
> +	if (!entry || pmd_downgrade) {
>  		int err;
>  
> +		if (pmd_downgrade) {
> +			/*
> +			 * Make sure 'entry' remains valid while we drop
> +			 * mapping->tree_lock.
> +			 */
> +			entry = lock_slot(mapping, slot);
> +		}
> +
>  		spin_unlock_irq(&mapping->tree_lock);
>  		err = radix_tree_preload(
>  				mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
> -		if (err)
> +		if (err) {
> +			put_locked_mapping_entry(mapping, index, entry);

Better do this only in pmd_downgrade case...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
