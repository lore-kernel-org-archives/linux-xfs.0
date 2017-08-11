Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47302 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753538AbdHKQFO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 12:05:14 -0400
Date: Fri, 11 Aug 2017 09:04:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: fix integer truncation issues in the zeroing and
 dirtying helpers
Message-ID: <20170811160443.GA24087@magnolia>
References: <20170811151805.22896-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811151805.22896-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, pmenzel@molgen.mpg.de, stockhausen@collogia.de

On Fri, Aug 11, 2017 at 05:18:05PM +0200, Christoph Hellwig wrote:
> Fix the min_t calls in the zeroing and dirtying helpers to perform the
> comparisms on 64-bit types, which prevents them from incorrectly
> being truncated, and larger zeroing operations being stuck in a never
> ending loop.
> 
> Special thanks to Markus Stockhausen for spotting the bug.
> 
> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>

Looks fine to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(Are you going to push this to Al yourself, or do you want me to drag it
through the xfs tree?)

> ---
>  fs/iomap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 039266128b7f..59cc98ad7577 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -278,7 +278,7 @@ iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		unsigned long bytes;	/* Bytes to write to page */
>  
>  		offset = (pos & (PAGE_SIZE - 1));
> -		bytes = min_t(unsigned long, PAGE_SIZE - offset, length);
> +		bytes = min_t(loff_t, PAGE_SIZE - offset, length);
>  
>  		rpage = __iomap_read_page(inode, pos);
>  		if (IS_ERR(rpage))
> @@ -373,7 +373,7 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
>  		unsigned offset, bytes;
>  
>  		offset = pos & (PAGE_SIZE - 1); /* Within page */
> -		bytes = min_t(unsigned, PAGE_SIZE - offset, count);
> +		bytes = min_t(loff_t, PAGE_SIZE - offset, count);
>  
>  		if (IS_DAX(inode))
>  			status = iomap_dax_zero(pos, offset, bytes, iomap);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
