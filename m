Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42442 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933924AbeE3Fb0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 01:31:26 -0400
Date: Tue, 29 May 2018 22:31:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/34] fs: move page_cache_seek_hole_data to iomap.c
Message-ID: <20180530053120.GR30110@magnolia>
References: <20180523144357.18985-1-hch@lst.de>
 <20180523144357.18985-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523144357.18985-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 23, 2018 at 04:43:26PM +0200, Christoph Hellwig wrote:
> This function is only used by the iomap code, depends on being called
> from it, and will soon stop poking into buffer head internals.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/buffer.c                 | 114 -----------------------------------
>  fs/iomap.c                  | 116 ++++++++++++++++++++++++++++++++++++
>  include/linux/buffer_head.h |   2 -
>  3 files changed, 116 insertions(+), 116 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index bd964b2ad99a..aba2a948b235 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3430,120 +3430,6 @@ int bh_submit_read(struct buffer_head *bh)
>  }
>  EXPORT_SYMBOL(bh_submit_read);
>  
> -/*
> - * Seek for SEEK_DATA / SEEK_HOLE within @page, starting at @lastoff.
> - *
> - * Returns the offset within the file on success, and -ENOENT otherwise.
> - */
> -static loff_t
> -page_seek_hole_data(struct page *page, loff_t lastoff, int whence)
> -{
> -	loff_t offset = page_offset(page);
> -	struct buffer_head *bh, *head;
> -	bool seek_data = whence == SEEK_DATA;
> -
> -	if (lastoff < offset)
> -		lastoff = offset;
> -
> -	bh = head = page_buffers(page);
> -	do {
> -		offset += bh->b_size;
> -		if (lastoff >= offset)
> -			continue;
> -
> -		/*
> -		 * Unwritten extents that have data in the page cache covering
> -		 * them can be identified by the BH_Unwritten state flag.
> -		 * Pages with multiple buffers might have a mix of holes, data
> -		 * and unwritten extents - any buffer with valid data in it
> -		 * should have BH_Uptodate flag set on it.
> -		 */
> -
> -		if ((buffer_unwritten(bh) || buffer_uptodate(bh)) == seek_data)
> -			return lastoff;
> -
> -		lastoff = offset;
> -	} while ((bh = bh->b_this_page) != head);
> -	return -ENOENT;
> -}
> -
> -/*
> - * Seek for SEEK_DATA / SEEK_HOLE in the page cache.
> - *
> - * Within unwritten extents, the page cache determines which parts are holes
> - * and which are data: unwritten and uptodate buffer heads count as data;
> - * everything else counts as a hole.
> - *
> - * Returns the resulting offset on successs, and -ENOENT otherwise.
> - */
> -loff_t
> -page_cache_seek_hole_data(struct inode *inode, loff_t offset, loff_t length,
> -			  int whence)
> -{
> -	pgoff_t index = offset >> PAGE_SHIFT;
> -	pgoff_t end = DIV_ROUND_UP(offset + length, PAGE_SIZE);
> -	loff_t lastoff = offset;
> -	struct pagevec pvec;
> -
> -	if (length <= 0)
> -		return -ENOENT;
> -
> -	pagevec_init(&pvec);
> -
> -	do {
> -		unsigned nr_pages, i;
> -
> -		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping, &index,
> -						end - 1);
> -		if (nr_pages == 0)
> -			break;
> -
> -		for (i = 0; i < nr_pages; i++) {
> -			struct page *page = pvec.pages[i];
> -
> -			/*
> -			 * At this point, the page may be truncated or
> -			 * invalidated (changing page->mapping to NULL), or
> -			 * even swizzled back from swapper_space to tmpfs file
> -			 * mapping.  However, page->index will not change
> -			 * because we have a reference on the page.
> -                         *
> -			 * If current page offset is beyond where we've ended,
> -			 * we've found a hole.
> -                         */
> -			if (whence == SEEK_HOLE &&
> -			    lastoff < page_offset(page))
> -				goto check_range;
> -
> -			lock_page(page);
> -			if (likely(page->mapping == inode->i_mapping) &&
> -			    page_has_buffers(page)) {
> -				lastoff = page_seek_hole_data(page, lastoff, whence);
> -				if (lastoff >= 0) {
> -					unlock_page(page);
> -					goto check_range;
> -				}
> -			}
> -			unlock_page(page);
> -			lastoff = page_offset(page) + PAGE_SIZE;
> -		}
> -		pagevec_release(&pvec);
> -	} while (index < end);
> -
> -	/* When no page at lastoff and we are not done, we found a hole. */
> -	if (whence != SEEK_HOLE)
> -		goto not_found;
> -
> -check_range:
> -	if (lastoff < offset + length)
> -		goto out;
> -not_found:
> -	lastoff = -ENOENT;
> -out:
> -	pagevec_release(&pvec);
> -	return lastoff;
> -}
> -
>  void __init buffer_init(void)
>  {
>  	unsigned long nrpages;
> diff --git a/fs/iomap.c b/fs/iomap.c
> index f2456d0d8ddd..4a01d2f4e8e9 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -20,6 +20,7 @@
>  #include <linux/mm.h>
>  #include <linux/swap.h>
>  #include <linux/pagemap.h>
> +#include <linux/pagevec.h>
>  #include <linux/file.h>
>  #include <linux/uio.h>
>  #include <linux/backing-dev.h>
> @@ -588,6 +589,121 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
>  }
>  EXPORT_SYMBOL_GPL(iomap_fiemap);
>  
> +/*
> + * Seek for SEEK_DATA / SEEK_HOLE within @page, starting at @lastoff.
> + *
> + * Returns the offset within the file on success, and -ENOENT otherwise.
> + */
> +static loff_t
> +page_seek_hole_data(struct page *page, loff_t lastoff, int whence)
> +{
> +	loff_t offset = page_offset(page);
> +	struct buffer_head *bh, *head;
> +	bool seek_data = whence == SEEK_DATA;
> +
> +	if (lastoff < offset)
> +		lastoff = offset;
> +
> +	bh = head = page_buffers(page);
> +	do {
> +		offset += bh->b_size;
> +		if (lastoff >= offset)
> +			continue;
> +
> +		/*
> +		 * Unwritten extents that have data in the page cache covering
> +		 * them can be identified by the BH_Unwritten state flag.
> +		 * Pages with multiple buffers might have a mix of holes, data
> +		 * and unwritten extents - any buffer with valid data in it
> +		 * should have BH_Uptodate flag set on it.
> +		 */
> +
> +		if ((buffer_unwritten(bh) || buffer_uptodate(bh)) == seek_data)
> +			return lastoff;
> +
> +		lastoff = offset;
> +	} while ((bh = bh->b_this_page) != head);
> +	return -ENOENT;
> +}
> +
> +/*
> + * Seek for SEEK_DATA / SEEK_HOLE in the page cache.
> + *
> + * Within unwritten extents, the page cache determines which parts are holes
> + * and which are data: unwritten and uptodate buffer heads count as data;
> + * everything else counts as a hole.
> + *
> + * Returns the resulting offset on successs, and -ENOENT otherwise.
> + */
> +static loff_t
> +page_cache_seek_hole_data(struct inode *inode, loff_t offset, loff_t length,
> +		int whence)
> +{
> +	pgoff_t index = offset >> PAGE_SHIFT;
> +	pgoff_t end = DIV_ROUND_UP(offset + length, PAGE_SIZE);
> +	loff_t lastoff = offset;
> +	struct pagevec pvec;
> +
> +	if (length <= 0)
> +		return -ENOENT;
> +
> +	pagevec_init(&pvec);
> +
> +	do {
> +		unsigned nr_pages, i;
> +
> +		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping, &index,
> +						end - 1);
> +		if (nr_pages == 0)
> +			break;
> +
> +		for (i = 0; i < nr_pages; i++) {
> +			struct page *page = pvec.pages[i];
> +
> +			/*
> +			 * At this point, the page may be truncated or
> +			 * invalidated (changing page->mapping to NULL), or
> +			 * even swizzled back from swapper_space to tmpfs file
> +			 * mapping.  However, page->index will not change
> +			 * because we have a reference on the page.
> +                         *
> +			 * If current page offset is beyond where we've ended,
> +			 * we've found a hole.
> +                         */
> +			if (whence == SEEK_HOLE &&
> +			    lastoff < page_offset(page))
> +				goto check_range;
> +
> +			lock_page(page);
> +			if (likely(page->mapping == inode->i_mapping) &&
> +			    page_has_buffers(page)) {
> +				lastoff = page_seek_hole_data(page, lastoff, whence);
> +				if (lastoff >= 0) {
> +					unlock_page(page);
> +					goto check_range;
> +				}
> +			}
> +			unlock_page(page);
> +			lastoff = page_offset(page) + PAGE_SIZE;
> +		}
> +		pagevec_release(&pvec);
> +	} while (index < end);
> +
> +	/* When no page at lastoff and we are not done, we found a hole. */
> +	if (whence != SEEK_HOLE)
> +		goto not_found;
> +
> +check_range:
> +	if (lastoff < offset + length)
> +		goto out;
> +not_found:
> +	lastoff = -ENOENT;
> +out:
> +	pagevec_release(&pvec);
> +	return lastoff;
> +}
> +
> +
>  static loff_t
>  iomap_seek_hole_actor(struct inode *inode, loff_t offset, loff_t length,
>  		      void *data, struct iomap *iomap)
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 894e5d125de6..96225a77c112 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -205,8 +205,6 @@ void write_boundary_block(struct block_device *bdev,
>  			sector_t bblock, unsigned blocksize);
>  int bh_uptodate_or_lock(struct buffer_head *bh);
>  int bh_submit_read(struct buffer_head *bh);
> -loff_t page_cache_seek_hole_data(struct inode *inode, loff_t offset,
> -				 loff_t length, int whence);
>  
>  extern int buffer_heads_over_limit;
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
