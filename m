Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752730AbeGCMb3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 08:31:29 -0400
Date: Tue, 3 Jul 2018 08:31:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 20/22] iomap: add support for sub-pagesize buffered I/O
 without buffer heads
Message-ID: <20180703123127.GA22789@bfoster>
References: <20180702145813.22496-1-hch@lst.de>
 <20180702145813.22496-21-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702145813.22496-21-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jul 02, 2018 at 08:58:11AM -0600, Christoph Hellwig wrote:
> After already supporting a simple implementation of buffered writes for
> the blocksize == PAGE_SIZE case in the last commit this adds full support
> even for smaller block sizes.   There are three bits of per-block
> information in the buffer_head structure that really matter for the iomap
> read and write path:
> 
>  - uptodate status (BH_uptodate)
>  - marked as currently under read I/O (BH_Async_Read)
>  - marked as currently under write I/O (BH_Async_Write)
> 
> Instead of having new per-block structures this now adds a per-page
> structure called struct iomap_page to track this information in a slightly
> different form:
> 
>  - a bitmap for the per-block uptodate status.  For worst case of a 64k
>    page size system this bitmap needs to contain 128 bits.  For the
>    typical 4k page size case it only needs 8 bits, although we still
>    need a full unsigned long due to the way the atomic bitmap API works.
>  - two atomic_t counters are used to track the outstanding read and write
>    counts
> 
> There is quite a bit of boilerplate code as the buffered I/O path uses
> various helper methods, but the actual code is very straight forward.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c            | 279 ++++++++++++++++++++++++++++++++++++++----
>  include/linux/iomap.h |  31 +++++
>  2 files changed, 289 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 13cdcf33e6c0..ea1b1ba61ba3 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
...
> @@ -161,13 +295,13 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		return PAGE_SIZE;
>  	}
>  
> -	/* we don't support blocksize < PAGE_SIZE quite yet. */
> -	WARN_ON_ONCE(pos != page_offset(page));
> -	WARN_ON_ONCE(plen != PAGE_SIZE);
> +	iomap_adjust_read_range(inode, iop, &pos, length, &poff, &plen);
> +	if (plen == 0)
> +		goto done;
>  

I think the i_size check confused me in the previous go around. It's
obviously clear to me now after the iomap zeroing issue and fix, but a
one-liner comment couldn't hurt for future reference:

	/* zero post-eof blocks as the page may be mapped */

That nit aside, this looks good to me and survives my tests:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	if (iomap->type != IOMAP_MAPPED || pos >= i_size_read(inode)) {
>  		zero_user(page, poff, plen);
> -		SetPageUptodate(page);
> +		iomap_set_range_uptodate(page, poff, plen);
>  		goto done;
>  	}
>  
> @@ -183,6 +317,14 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		is_contig = true;
>  	}
>  
> +	/*
> +	 * If we start a new segment we need to increase the read count, and we
> +	 * need to do so before submitting any previous full bio to make sure
> +	 * that we don't prematurely unlock the page.
> +	 */
> +	if (iop)
> +		atomic_inc(&iop->read_count);
> +
>  	if (!ctx->bio || !is_contig || bio_full(ctx->bio)) {
>  		gfp_t gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
>  		int nr_vecs = (length + PAGE_SIZE - 1) >> PAGE_SHIFT;
> @@ -203,7 +345,13 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  
>  	__bio_add_page(ctx->bio, page, plen, poff);
>  done:
> -	return plen;
> +	/*
> +	 * Move the caller beyond our range so that it keeps making progress.
> +	 * For that we have to include any leading non-uptodate ranges, but
> +	 * we can skip trailing ones as they will be handled in the next
> +	 * iteration.
> +	 */
> +	return pos - orig_pos + plen;
>  }
>  
>  int
> @@ -214,8 +362,6 @@ iomap_readpage(struct page *page, const struct iomap_ops *ops)
>  	unsigned poff;
>  	loff_t ret;
>  
> -	WARN_ON_ONCE(page_has_buffers(page));
> -
>  	for (poff = 0; poff < PAGE_SIZE; poff += ret) {
>  		ret = iomap_apply(inode, page_offset(page) + poff,
>  				PAGE_SIZE - poff, 0, ops, &ctx,
> @@ -341,6 +487,84 @@ iomap_readpages(struct address_space *mapping, struct list_head *pages,
>  }
>  EXPORT_SYMBOL_GPL(iomap_readpages);
>  
> +int
> +iomap_is_partially_uptodate(struct page *page, unsigned long from,
> +		unsigned long count)
> +{
> +	struct iomap_page *iop = to_iomap_page(page);
> +	struct inode *inode = page->mapping->host;
> +	unsigned first = from >> inode->i_blkbits;
> +	unsigned last = (from + count - 1) >> inode->i_blkbits;
> +	unsigned i;
> +
> +	if (iop) {
> +		for (i = first; i <= last; i++)
> +			if (!test_bit(i, iop->uptodate))
> +				return 0;
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(iomap_is_partially_uptodate);
> +
> +int
> +iomap_releasepage(struct page *page, gfp_t gfp_mask)
> +{
> +	/*
> +	 * mm accommodates an old ext3 case where clean pages might not have had
> +	 * the dirty bit cleared. Thus, it can send actual dirty pages to
> +	 * ->releasepage() via shrink_active_list(), skip those here.
> +	 */
> +	if (PageDirty(page) || PageWriteback(page))
> +		return 0;
> +	iomap_page_release(page);
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(iomap_releasepage);
> +
> +void
> +iomap_invalidatepage(struct page *page, unsigned int offset, unsigned int len)
> +{
> +	/*
> +	 * If we are invalidating the entire page, clear the dirty state from it
> +	 * and release it to avoid unnecessary buildup of the LRU.
> +	 */
> +	if (offset == 0 && len == PAGE_SIZE) {
> +		WARN_ON_ONCE(PageWriteback(page));
> +		cancel_dirty_page(page);
> +		iomap_page_release(page);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(iomap_invalidatepage);
> +
> +#ifdef CONFIG_MIGRATION
> +int
> +iomap_migrate_page(struct address_space *mapping, struct page *newpage,
> +		struct page *page, enum migrate_mode mode)
> +{
> +	int ret;
> +
> +	ret = migrate_page_move_mapping(mapping, newpage, page, NULL, mode, 0);
> +	if (ret != MIGRATEPAGE_SUCCESS)
> +		return ret;
> +
> +	if (page_has_private(page)) {
> +		ClearPagePrivate(page);
> +		set_page_private(newpage, page_private(page));
> +		set_page_private(page, 0);
> +		SetPagePrivate(newpage);
> +	}
> +
> +	if (mode != MIGRATE_SYNC_NO_COPY)
> +		migrate_page_copy(newpage, page);
> +	else
> +		migrate_page_states(newpage, page);
> +	return MIGRATEPAGE_SUCCESS;
> +}
> +EXPORT_SYMBOL_GPL(iomap_migrate_page);
> +#endif /* CONFIG_MIGRATION */
> +
>  static void
>  iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
>  {
> @@ -364,6 +588,7 @@ iomap_read_page_sync(struct inode *inode, loff_t block_start, struct page *page,
>  
>  	if (iomap->type != IOMAP_MAPPED || block_start >= i_size_read(inode)) {
>  		zero_user_segments(page, poff, from, to, poff + plen);
> +		iomap_set_range_uptodate(page, poff, plen);
>  		return 0;
>  	}
>  
> @@ -379,21 +604,33 @@ static int
>  __iomap_write_begin(struct inode *inode, loff_t pos, unsigned len,
>  		struct page *page, struct iomap *iomap)
>  {
> +	struct iomap_page *iop = iomap_page_create(inode, page);
>  	loff_t block_size = i_blocksize(inode);
>  	loff_t block_start = pos & ~(block_size - 1);
>  	loff_t block_end = (pos + len + block_size - 1) & ~(block_size - 1);
> -	unsigned poff = block_start & (PAGE_SIZE - 1);
> -	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, block_end - block_start);
> -	unsigned from = pos & (PAGE_SIZE - 1), to = from + len;
> -
> -	WARN_ON_ONCE(i_blocksize(inode) < PAGE_SIZE);
> +	unsigned from = pos & (PAGE_SIZE - 1), to = from + len, poff, plen;
> +	int status = 0;
>  
>  	if (PageUptodate(page))
>  		return 0;
> -	if (from <= poff && to >= poff + plen)
> -		return 0;
> -	return iomap_read_page_sync(inode, block_start, page,
> -			poff, plen, from, to, iomap);
> +
> +	do {
> +		iomap_adjust_read_range(inode, iop, &block_start,
> +				block_end - block_start, &poff, &plen);
> +		if (plen == 0)
> +			break;
> +
> +		if ((from > poff && from < poff + plen) ||
> +		    (to > poff && to < poff + plen)) {
> +			status = iomap_read_page_sync(inode, block_start, page,
> +					poff, plen, from, to, iomap);
> +			if (status)
> +				break;
> +		}
> +
> +	} while ((block_start += plen) < block_end);
> +
> +	return status;
>  }
>  
>  static int
> @@ -476,7 +713,7 @@ __iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
>  	if (unlikely(copied < len && !PageUptodate(page))) {
>  		copied = 0;
>  	} else {
> -		SetPageUptodate(page);
> +		iomap_set_range_uptodate(page, pos & (PAGE_SIZE - 1), len);
>  		iomap_set_page_dirty(page);
>  	}
>  	return __generic_write_end(inode, pos, copied, page);
> @@ -812,7 +1049,7 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
>  		block_commit_write(page, 0, length);
>  	} else {
>  		WARN_ON_ONCE(!PageUptodate(page));
> -		WARN_ON_ONCE(i_blocksize(inode) < PAGE_SIZE);
> +		iomap_page_create(inode, page);
>  	}
>  
>  	return length;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 5eb9ca8d7ce5..3555d54bf79a 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -2,6 +2,9 @@
>  #ifndef LINUX_IOMAP_H
>  #define LINUX_IOMAP_H 1
>  
> +#include <linux/atomic.h>
> +#include <linux/bitmap.h>
> +#include <linux/mm.h>
>  #include <linux/types.h>
>  
>  struct address_space;
> @@ -98,12 +101,40 @@ struct iomap_ops {
>  			ssize_t written, unsigned flags, struct iomap *iomap);
>  };
>  
> +/*
> + * Structure allocate for each page when block size < PAGE_SIZE to track
> + * sub-page uptodate status and I/O completions.
> + */
> +struct iomap_page {
> +	atomic_t		read_count;
> +	atomic_t		write_count;
> +	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
> +};
> +
> +static inline struct iomap_page *to_iomap_page(struct page *page)
> +{
> +	if (page_has_private(page))
> +		return (struct iomap_page *)page_private(page);
> +	return NULL;
> +}
> +
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
>  		const struct iomap_ops *ops);
>  int iomap_readpage(struct page *page, const struct iomap_ops *ops);
>  int iomap_readpages(struct address_space *mapping, struct list_head *pages,
>  		unsigned nr_pages, const struct iomap_ops *ops);
>  int iomap_set_page_dirty(struct page *page);
> +int iomap_is_partially_uptodate(struct page *page, unsigned long from,
> +		unsigned long count);
> +int iomap_releasepage(struct page *page, gfp_t gfp_mask);
> +void iomap_invalidatepage(struct page *page, unsigned int offset,
> +		unsigned int len);
> +#ifdef CONFIG_MIGRATION
> +int iomap_migrate_page(struct address_space *mapping, struct page *newpage,
> +		struct page *page, enum migrate_mode mode);
> +#else
> +#define iomap_migrate_page NULL
> +#endif
>  int iomap_file_dirty(struct inode *inode, loff_t pos, loff_t len,
>  		const struct iomap_ops *ops);
>  int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
