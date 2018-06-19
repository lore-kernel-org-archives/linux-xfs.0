Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:52272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966267AbeFSQwN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 12:52:13 -0400
Date: Tue, 19 Jun 2018 12:52:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 23/24] iomap: add support for sub-pagesize buffered I/O
 without buffer heads
Message-ID: <20180619165211.GD2806@bfoster>
References: <20180615130209.1970-1-hch@lst.de>
 <20180615130209.1970-24-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615130209.1970-24-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Jun 15, 2018 at 03:02:08PM +0200, Christoph Hellwig wrote:
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
>  fs/iomap.c            | 262 ++++++++++++++++++++++++++++++++++++++----
>  include/linux/iomap.h |  31 +++++
>  2 files changed, 272 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index a504077bb38f..c59d1922991d 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
...
> @@ -197,7 +322,13 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  
>  	__bio_add_page(ctx->bio, page, plen, poff);
>  done:
> -	return plen;
> +	/*
> +	 * Move the caller beyond our range so that it keeps making progress.
> +	 * For that we have to include any leading non-uptodate ranges, but

Do you mean "leading uptodate ranges" here? E.g., pos is pushed forward
past those ranges we don't have to read, so (pos - orig_pos) reflects
the initial uptodate range while plen reflects the length we have to
read..?

> +	 * we can skip trailing ones as they will be handled in the next
> +	 * iteration.
> +	 */
> +	return pos - orig_pos + plen;
>  }
>  
>  int
...
> @@ -373,21 +581,33 @@ static int
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

Kind of a nit, but this catches my eye and manages to confuse me every
time I look at it. A comment along the lines of:

                /*
		 * Pass in the block aligned start/end so we get back block
		 * aligned/adjusted poff/plen and can compare with unaligned
		 * from/to below.
                 */

... would be nice here, IMO.

> +		iomap_adjust_read_range(inode, iop, &block_start,
> +				block_end - block_start, &poff, &plen);
> +		if (plen == 0)
> +			break;
> +
> +		if ((from > poff && from < poff + plen) ||
> +		    (to > poff && to < poff + plen)) {
> +			status = iomap_read_page_sync(inode, block_start, page,
> +					poff, plen, from, to, iomap);

After taking another look at the buffer head path, it does look like we
have slightly different behavior here. IIUC, the former reads only the
!uptodate blocks that fall along the from/to boundaries. Here, if say
from = 1, to = PAGE_SIZE and the page is fully !uptodate, it looks like
we'd read the entire page worth of blocks (assuming contiguous 512b
blocks, for example). Intentional? Doesn't seem like a big deal, but
could be worth a followup fix.

Brian

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
> @@ -470,7 +690,7 @@ __iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
>  	if (unlikely(copied < len && !PageUptodate(page))) {
>  		copied = 0;
>  	} else {
> -		SetPageUptodate(page);
> +		iomap_set_range_uptodate(page, pos & (PAGE_SIZE - 1), len);
>  		iomap_set_page_dirty(page);
>  	}
>  	return __generic_write_end(inode, pos, copied, page);
> @@ -806,7 +1026,7 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
>  		block_commit_write(page, 0, length);
>  	} else {
>  		WARN_ON_ONCE(!PageUptodate(page));
> -		WARN_ON_ONCE(i_blocksize(inode) < PAGE_SIZE);
> +		iomap_page_create(inode, page);
>  	}
>  
>  	return length;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index c2706cfb27c7..60b196c54dd6 100644
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
> @@ -99,12 +102,40 @@ struct iomap_ops {
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
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
