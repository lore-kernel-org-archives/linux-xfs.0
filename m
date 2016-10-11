Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42811 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753342AbcJKSnj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Oct 2016 14:43:39 -0400
Date: Tue, 11 Oct 2016 09:23:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 14/17] dax: move RADIX_DAX_* defines to dax.h
Message-ID: <20161011072327.GF6952@quack2.suse.cz>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-15-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475874544-24842-15-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Fri 07-10-16 15:09:01, Ross Zwisler wrote:
> The RADIX_DAX_* defines currently mostly live in fs/dax.c, with just
> RADIX_DAX_ENTRY_LOCK being in include/linux/dax.h so it can be used in
> mm/filemap.c.  When we add PMD support, though, mm/filemap.c will also need
> access to the RADIX_DAX_PTE type so it can properly construct a 4k sized
> empty entry.
> 
> Instead of shifting the defines between dax.c and dax.h as they are
> individually used in other code, just move them wholesale to dax.h so
> they'll be available when we need them.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c            | 14 --------------
>  include/linux/dax.h | 15 ++++++++++++++-
>  2 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5e8febe..ac3cd05 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -34,20 +34,6 @@
>  #include <linux/iomap.h>
>  #include "internal.h"
>  
> -/*
> - * We use lowest available bit in exceptional entry for locking, other two
> - * bits to determine entry type. In total 3 special bits.
> - */
> -#define RADIX_DAX_SHIFT	(RADIX_TREE_EXCEPTIONAL_SHIFT + 3)
> -#define RADIX_DAX_PTE (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 1))
> -#define RADIX_DAX_PMD (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
> -#define RADIX_DAX_TYPE_MASK (RADIX_DAX_PTE | RADIX_DAX_PMD)
> -#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_TYPE_MASK)
> -#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
> -#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
> -		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE) | \
> -		RADIX_TREE_EXCEPTIONAL_ENTRY))
> -
>  /* We choose 4096 entries - same as per-zone page wait tables */
>  #define DAX_WAIT_TABLE_BITS 12
>  #define DAX_WAIT_TABLE_ENTRIES (1 << DAX_WAIT_TABLE_BITS)
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index a3dfee4..e9ea78c 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -8,8 +8,21 @@
>  
>  struct iomap_ops;
>  
> -/* We use lowest available exceptional entry bit for locking */
> +/*
> + * We use lowest available bit in exceptional entry for locking, other two
> + * bits to determine entry type. In total 3 special bits.
> + */
> +#define RADIX_DAX_SHIFT	(RADIX_TREE_EXCEPTIONAL_SHIFT + 3)
>  #define RADIX_DAX_ENTRY_LOCK (1 << RADIX_TREE_EXCEPTIONAL_SHIFT)
> +#define RADIX_DAX_PTE (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 1))
> +#define RADIX_DAX_PMD (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
> +#define RADIX_DAX_TYPE_MASK (RADIX_DAX_PTE | RADIX_DAX_PMD)
> +#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_TYPE_MASK)
> +#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
> +#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
> +		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE) | \
> +		RADIX_TREE_EXCEPTIONAL_ENTRY))
> +
>  
>  ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		struct iomap_ops *ops);
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
