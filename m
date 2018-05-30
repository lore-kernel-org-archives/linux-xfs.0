Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbeE3FnC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 01:43:02 -0400
Date: Tue, 29 May 2018 22:42:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/34] mm: give the 'ret' variable a better name
 __do_page_cache_readahead
Message-ID: <20180530054248.GU30110@magnolia>
References: <20180523144357.18985-1-hch@lst.de>
 <20180523144357.18985-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523144357.18985-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 23, 2018 at 04:43:29PM +0200, Christoph Hellwig wrote:
> It counts the number of pages acted on, so name it nr_pages to make that
> obvious.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, so long as the mm folks don't have any strong opinions...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  mm/readahead.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 539bbb6c1fad..16d0cb1e2616 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -156,7 +156,7 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
>  	unsigned long end_index;	/* The last page we want to read */
>  	LIST_HEAD(page_pool);
>  	int page_idx;
> -	int ret = 0;
> +	int nr_pages = 0;
>  	loff_t isize = i_size_read(inode);
>  	gfp_t gfp_mask = readahead_gfp_mask(mapping);
>  
> @@ -187,7 +187,7 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
>  		list_add(&page->lru, &page_pool);
>  		if (page_idx == nr_to_read - lookahead_size)
>  			SetPageReadahead(page);
> -		ret++;
> +		nr_pages++;
>  	}
>  
>  	/*
> @@ -195,11 +195,11 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
>  	 * uptodate then the caller will launch readpage again, and
>  	 * will then handle the error.
>  	 */
> -	if (ret)
> -		read_pages(mapping, filp, &page_pool, ret, gfp_mask);
> +	if (nr_pages)
> +		read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
>  	BUG_ON(!list_empty(&page_pool));
>  out:
> -	return ret;
> +	return nr_pages;
>  }
>  
>  /*
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
