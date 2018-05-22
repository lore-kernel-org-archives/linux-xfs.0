Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60917 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbeEVOw2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 10:52:28 -0400
Date: Tue, 22 May 2018 10:52:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/34] mm: split ->readpages calls to avoid
 non-contiguous pages lists
Message-ID: <20180522145226.GA25251@bfoster.bfoster>
References: <20180518164830.1552-1-hch@lst.de>
 <20180518164830.1552-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518164830.1552-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Fri, May 18, 2018 at 06:48:04PM +0200, Christoph Hellwig wrote:
> That way file systems don't have to go spotting for non-contiguous pages
> and work around them.  It also kicks off I/O earlier, allowing it to
> finish earlier and reduce latency.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/readahead.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index fa4d4b767130..044ab0c137cc 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -177,8 +177,18 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
>  		rcu_read_lock();
>  		page = radix_tree_lookup(&mapping->i_pages, page_offset);
>  		rcu_read_unlock();
> -		if (page && !radix_tree_exceptional_entry(page))
> +		if (page && !radix_tree_exceptional_entry(page)) {
> +			/*
> +			 * Page already present?  Kick off the current batch of
> +			 * contiguous pages before continuing with the next
> +			 * batch.
> +			 */
> +			if (nr_pages)
> +				read_pages(mapping, filp, &page_pool, nr_pages,
> +						gfp_mask);
> +			nr_pages = 0;
>  			continue;
> +		}

The comment at the top of this function explicitly states that we don't
submit I/Os before all of the pages are allocated. That probably needs
an update, at least.

That aside, couldn't this introduce that kind of problematic read/write
behavior if the mapping was sparsely populated for whatever reason
(every other page, for example)? Perhaps that's just too unlikely to
matter.

Brian

>  
>  		page = __page_cache_alloc(gfp_mask);
>  		if (!page)
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
