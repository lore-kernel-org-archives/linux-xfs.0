Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33460 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbeCFK5S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 05:57:18 -0500
Date: Tue, 6 Mar 2018 11:57:16 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] inode: don't memset the inode address space twice
Message-ID: <20180306105716.rqi2solaa6lkbqyt@quack2.suse.cz>
References: <20180301223402.26897-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180301223402.26897-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri 02-03-18 09:34:02, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Noticed when looking at why cycling 600k inodes/s through the inode
> cache was taking a total of 8% cpu in memset() during inode
> initialisation.  There is no need to zero the inode.i_data structure
> twice.
> 
> This increases single threaded bulkstat throughput from ~200,000
> inodes/s to ~220,000 inodes/s, so we save a substantial amount of
> CPU time per inode init by doing this.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Nice and the patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 6295f1415761..b153aeaa61ea 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -346,9 +346,8 @@ void inc_nlink(struct inode *inode)
>  }
>  EXPORT_SYMBOL(inc_nlink);
>  
> -void address_space_init_once(struct address_space *mapping)
> +static void __address_space_init_once(struct address_space *mapping)
>  {
> -	memset(mapping, 0, sizeof(*mapping));
>  	INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC | __GFP_ACCOUNT);
>  	spin_lock_init(&mapping->tree_lock);
>  	init_rwsem(&mapping->i_mmap_rwsem);
> @@ -356,6 +355,12 @@ void address_space_init_once(struct address_space *mapping)
>  	spin_lock_init(&mapping->private_lock);
>  	mapping->i_mmap = RB_ROOT_CACHED;
>  }
> +
> +void address_space_init_once(struct address_space *mapping)
> +{
> +	memset(mapping, 0, sizeof(*mapping));
> +	__address_space_init_once(mapping);
> +}
>  EXPORT_SYMBOL(address_space_init_once);
>  
>  /*
> @@ -371,7 +376,7 @@ void inode_init_once(struct inode *inode)
>  	INIT_LIST_HEAD(&inode->i_io_list);
>  	INIT_LIST_HEAD(&inode->i_wb_list);
>  	INIT_LIST_HEAD(&inode->i_lru);
> -	address_space_init_once(&inode->i_data);
> +	__address_space_init_once(&inode->i_data);
>  	i_size_ordered_init(inode);
>  }
>  EXPORT_SYMBOL(inode_init_once);
> -- 
> 2.16.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
