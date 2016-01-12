Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E728B7F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 03:44:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77B31AC002
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 01:44:45 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id BUyjoGDybXl1HnK6 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 01:44:43 -0800 (PST)
Date: Tue, 12 Jan 2016 10:44:51 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v8 2/9] dax: fix conversion of holes to PMDs
Message-ID: <20160112094451.GS6262@quack.suse.cz>
References: <1452230879-18117-1-git-send-email-ross.zwisler@linux.intel.com>
	<1452230879-18117-3-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452230879-18117-3-git-send-email-ross.zwisler@linux.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Thu 07-01-16 22:27:52, Ross Zwisler wrote:
> When we get a DAX PMD fault for a write it is possible that there could be
> some number of 4k zero pages already present for the same range that were
> inserted to service reads from a hole.  These 4k zero pages need to be
> unmapped from the VMAs and removed from the struct address_space radix tree
> before the real DAX PMD entry can be inserted.
> 
> For PTE faults this same use case also exists and is handled by a
> combination of unmap_mapping_range() to unmap the VMAs and
> delete_from_page_cache() to remove the page from the address_space radix
> tree.
> 
> For PMD faults we do have a call to unmap_mapping_range() (protected by a
> buffer_new() check), but nothing clears out the radix tree entry.  The
> buffer_new() check is also incorrect as the current ext4 and XFS filesystem
> code will never return a buffer_head with BH_New set, even when allocating
> new blocks over a hole.  Instead the filesystem will zero the blocks
> manually and return a buffer_head with only BH_Mapped set.
> 
> Fix this situation by removing the buffer_new() check and adding a call to
> truncate_inode_pages_range() to clear out the radix tree entries before we
> insert the DAX PMD.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> Tested-by: Dan Williams <dan.j.williams@intel.com>

Just two nits below. Nothing serious so you can add:

Reviewed-by: Jan Kara <jack@suse.cz>

> ---
>  fs/dax.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 513bba5..5b84a46 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -589,6 +589,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  	bool write = flags & FAULT_FLAG_WRITE;
>  	struct block_device *bdev;
>  	pgoff_t size, pgoff;
> +	loff_t lstart, lend;
>  	sector_t block;
>  	int result = 0;
>  
> @@ -643,15 +644,13 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		goto fallback;
>  	}
>  
> -	/*
> -	 * If we allocated new storage, make sure no process has any
> -	 * zero pages covering this hole
> -	 */
> -	if (buffer_new(&bh)) {
> -		i_mmap_unlock_read(mapping);
> -		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
> -		i_mmap_lock_read(mapping);
> -	}
> +	/* make sure no process has any zero pages covering this hole */
> +	lstart = pgoff << PAGE_SHIFT;
> +	lend = lstart + PMD_SIZE - 1; /* inclusive */
> +	i_mmap_unlock_read(mapping);

Just a nit but is there reason why we grab i_mmap_lock_read(mapping) only
to release it a few lines below? The bh checks inside the locked region
don't seem to rely on i_mmap_lock...

> +	unmap_mapping_range(mapping, lstart, PMD_SIZE, 0);
> +	truncate_inode_pages_range(mapping, lstart, lend);

These two calls can be shortened as:

truncate_pagecache_range(inode, lstart, lend);


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
