Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53558 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfAaX2Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 18:28:24 -0500
Date: Thu, 31 Jan 2019 15:28:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: get/put the page in iomap_page_create/release()
Message-ID: <20190131232816.GF5761@magnolia>
References: <20190121151702.28863-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121151702.28863-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Piotr Jaroszynski <pjaroszynski@nvidia.com>

On Mon, Jan 21, 2019 at 04:17:02PM +0100, Christoph Hellwig wrote:
> From: Piotr Jaroszynski <pjaroszynski@nvidia.com>
> 
> migrate_page_move_mapping() expects pages with private data set to have
> a page_count elevated by 1.  This is what used to happen for xfs through
> the buffer_heads code before the switch to iomap in commit 82cb14175e7d
> ("xfs: add support for sub-pagesize writeback without buffer_heads").
> Not having the count elevated causes move_pages() to fail on memory
> mapped files coming from xfs.
> 
> Make iomap compatible with the migrate_page_move_mapping() assumption by
> elevating the page count as part of iomap_page_create() and lowering it
> in iomap_page_release().
> 
> It causes the move_pages() syscall to misbehave on memory mapped files
> from xfs.  It does not not move any pages, which I suppose is "just" a
> perf issue, but it also ends up returning a positive number which is out
> of spec for the syscall.  Talking to Michal Hocko, it sounds like
> returning positive numbers might be a necessary update to move_pages()
> anyway though.
> 
> Fixes: 82cb14175e7d ("xfs: add support for sub-pagesize writeback without buffer_heads")
> Signed-off-by: Piotr Jaroszynski <pjaroszynski@nvidia.com>
> [hch: actually get/put the page iomap_migrate_page() to make it work
>       properly]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok (apparently I forgot to ack this explicitly...)
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 987fefc054b4..47362397cb82 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -116,6 +116,12 @@ iomap_page_create(struct inode *inode, struct page *page)
>  	atomic_set(&iop->read_count, 0);
>  	atomic_set(&iop->write_count, 0);
>  	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
> +
> +	/*
> +	 * migrate_page_move_mapping() assumes that pages with private data have
> +	 * their count elevated by 1.
> +	 */
> +	get_page(page);
>  	set_page_private(page, (unsigned long)iop);
>  	SetPagePrivate(page);
>  	return iop;
> @@ -132,6 +138,7 @@ iomap_page_release(struct page *page)
>  	WARN_ON_ONCE(atomic_read(&iop->write_count));
>  	ClearPagePrivate(page);
>  	set_page_private(page, 0);
> +	put_page(page);
>  	kfree(iop);
>  }
>  
> @@ -569,8 +576,10 @@ iomap_migrate_page(struct address_space *mapping, struct page *newpage,
>  
>  	if (page_has_private(page)) {
>  		ClearPagePrivate(page);
> +		get_page(newpage);
>  		set_page_private(newpage, page_private(page));
>  		set_page_private(page, 0);
> +		put_page(page);
>  		SetPagePrivate(newpage);
>  	}
>  
> -- 
> 2.20.1
> 
