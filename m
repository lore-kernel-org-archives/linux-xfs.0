Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53112 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbeHJVQq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Aug 2018 17:16:46 -0400
Date: Fri, 10 Aug 2018 11:45:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: Switch to offset_in_page for clarity
Message-ID: <20180810184534.GG12194@magnolia>
References: <20180810145627.12266-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180810145627.12266-1-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

[add linux-xfs to cc]

On Fri, Aug 10, 2018 at 04:56:27PM +0200, Andreas Gruenbacher wrote:
> Instead of open-coding pos & (PAGE_SIZE - 1) and pos & ~PAGE_MASK, use
> the offset_in_page macro.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 13cdcf33e6c0..ae317ac7e925 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -150,7 +150,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  {
>  	struct iomap_readpage_ctx *ctx = data;
>  	struct page *page = ctx->cur_page;
> -	unsigned poff = pos & (PAGE_SIZE - 1);
> +	unsigned poff = offset_in_page(pos);
>  	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, length);
>  	bool is_contig = false;
>  	sector_t sector;
> @@ -280,7 +280,7 @@ iomap_readpages_actor(struct inode *inode, loff_t pos, loff_t length,
>  	loff_t done, ret;
>  
>  	for (done = 0; done < length; done += ret) {
> -		if (ctx->cur_page && ((pos + done) & (PAGE_SIZE - 1)) == 0) {
> +		if (ctx->cur_page && offset_in_page(pos + done) == 0) {
>  			if (!ctx->cur_page_in_bio)
>  				unlock_page(ctx->cur_page);
>  			put_page(ctx->cur_page);
> @@ -382,9 +382,9 @@ __iomap_write_begin(struct inode *inode, loff_t pos, unsigned len,
>  	loff_t block_size = i_blocksize(inode);
>  	loff_t block_start = pos & ~(block_size - 1);
>  	loff_t block_end = (pos + len + block_size - 1) & ~(block_size - 1);
> -	unsigned poff = block_start & (PAGE_SIZE - 1);
> +	unsigned poff = offset_in_page(block_start);
>  	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, block_end - block_start);
> -	unsigned from = pos & (PAGE_SIZE - 1), to = from + len;
> +	unsigned from = offset_in_page(pos), to = from + len;
>  
>  	WARN_ON_ONCE(i_blocksize(inode) < PAGE_SIZE);
>  
> @@ -538,7 +538,7 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		unsigned long bytes;	/* Bytes to write to page */
>  		size_t copied;		/* Bytes copied from user */
>  
> -		offset = (pos & (PAGE_SIZE - 1));
> +		offset = offset_in_page(pos);
>  		bytes = min_t(unsigned long, PAGE_SIZE - offset,
>  						iov_iter_count(i));
>  again:
> @@ -652,7 +652,7 @@ iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		unsigned long offset;	/* Offset into pagecache page */
>  		unsigned long bytes;	/* Bytes to write to page */
>  
> -		offset = (pos & (PAGE_SIZE - 1));
> +		offset = offset_in_page(pos);
>  		bytes = min_t(loff_t, PAGE_SIZE - offset, length);
>  
>  		rpage = __iomap_read_page(inode, pos);
> @@ -744,7 +744,7 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
>  	do {
>  		unsigned offset, bytes;
>  
> -		offset = pos & (PAGE_SIZE - 1); /* Within page */
> +		offset = offset_in_page(pos);
>  		bytes = min_t(loff_t, PAGE_SIZE - offset, count);
>  
>  		if (IS_DAX(inode))
> @@ -837,7 +837,7 @@ int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
>  
>  	/* page is wholly or partially inside EOF */
>  	if (((page->index + 1) << PAGE_SHIFT) > size)
> -		length = size & ~PAGE_MASK;
> +		length = offset_in_page(size);
>  	else
>  		length = PAGE_SIZE;
>  
> @@ -1000,7 +1000,7 @@ page_seek_hole_data(struct inode *inode, struct page *page, loff_t *lastoff,
>  		goto out_unlock_not_found;
>  
>  	for (off = 0; off < PAGE_SIZE; off += bsize) {
> -		if ((*lastoff & ~PAGE_MASK) >= off + bsize)
> +		if (offset_in_page(*lastoff) >= off + bsize)
>  			continue;
>  		if (ops->is_partially_uptodate(page, off, bsize) == seek_data) {
>  			unlock_page(page);
> -- 
> 2.17.1
> 
