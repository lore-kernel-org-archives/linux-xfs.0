Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42812 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753403AbcJKSnj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Oct 2016 14:43:39 -0400
Date: Tue, 11 Oct 2016 09:06:29 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 12/17] dax: add dax_iomap_sector() helper function
Message-ID: <20161011070629.GD6952@quack2.suse.cz>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-13-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475874544-24842-13-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Fri 07-10-16 15:08:59, Ross Zwisler wrote:
> To be able to correctly calculate the sector from a file position and a
> struct iomap there is a complex little bit of logic that currently happens
> in both dax_iomap_actor() and dax_iomap_fault().  This will need to be
> repeated yet again in the DAX PMD fault handler when it is added, so break
> it out into a helper function.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 982ccbb..7689ab0 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1023,6 +1023,11 @@ int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
>  EXPORT_SYMBOL_GPL(dax_truncate_page);
>  
>  #ifdef CONFIG_FS_IOMAP
> +static inline sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
> +{
> +	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
> +}
> +
>  static loff_t
>  dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		struct iomap *iomap)
> @@ -1048,8 +1053,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		struct blk_dax_ctl dax = { 0 };
>  		ssize_t map_len;
>  
> -		dax.sector = iomap->blkno +
> -			(((pos & PAGE_MASK) - iomap->offset) >> 9);
> +		dax.sector = dax_iomap_sector(iomap, pos);
>  		dax.size = (length + offset + PAGE_SIZE - 1) & PAGE_MASK;
>  		map_len = dax_map_atomic(iomap->bdev, &dax);
>  		if (map_len < 0) {
> @@ -1186,7 +1190,7 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		goto unlock_entry;
>  	}
>  
> -	sector = iomap.blkno + (((pos & PAGE_MASK) - iomap.offset) >> 9);
> +	sector = dax_iomap_sector(&iomap, pos);
>  
>  	if (vmf->cow_page) {
>  		switch (iomap.type) {
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
