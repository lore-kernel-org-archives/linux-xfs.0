Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC50C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB82613D8
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhE0XLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 19:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233726AbhE0XLd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 19:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 419AA61176;
        Thu, 27 May 2021 23:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622156999;
        bh=ozv62m6+abCCQ6Q0TOzx10PK7EGAxHMBn//PtQqK9mQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PnwQjJxupOpft1GYbsqCmUeyX347UDGfBUxf0YHPPGmdDg2r4CdcXiOntYWZQ1UDC
         qBIvcSKnTfHJyH+AT7h47Tozsen+Km66XCyk7h6kRUP6xdGBbb06pyuE0DXDxZX0HZ
         ROK2osLqx+lMuiyVfyhE/NQZOK0lUjab9kmkryIC3AOhoawLpbrHz1+EF5h1VqGQNc
         AIcjVM+jn2lm9AZnLEtA5p3eyQqgp19JNu6J83mAorzBO95Yf36QEoYbUZ7uEzNcr/
         LKcYR8olxS6yt5C94aUpLnSuAHkiJifY1asAPxSBL5rePLa3ou7xG9gtp5odmvyB2T
         U/B2ea2a9vF0Q==
Date:   Thu, 27 May 2021 16:09:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 06/10] xfs: remove ->b_offset handling for page backed
 buffers
Message-ID: <20210527230958.GG2402049@locust>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526224722.1111377-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 08:47:18AM +1000, Dave Chinner wrote:
> From : Christoph Hellwig <hch@lst.de>
> 
> ->b_offset can only be non-zero for _XBF_KMEM backed buffers, so
> remove all code dealing with it for page backed buffers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [dgc: modified to fit this patchset]
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I think it's the case that the only time we'd end up with a nonzero
b_offset is if the kmem_alloc returns a slab object in the middle of a
page, right?  i.e. vmalloc is supposed to give us full pages, and we
hope that nobody ever sells a device with a 64k dma alignment...?

Assuming that's right,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 8 +++-----
>  fs/xfs/xfs_buf.h | 3 ++-
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d15999c41885..87151d78a0d8 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -79,7 +79,7 @@ static inline int
>  xfs_buf_vmap_len(
>  	struct xfs_buf	*bp)
>  {
> -	return (bp->b_page_count * PAGE_SIZE) - bp->b_offset;
> +	return (bp->b_page_count * PAGE_SIZE);
>  }
>  
>  /*
> @@ -281,7 +281,7 @@ xfs_buf_free_pages(
>  	ASSERT(bp->b_flags & _XBF_PAGES);
>  
>  	if (xfs_buf_is_vmapped(bp))
> -		vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
> +		vm_unmap_ram(bp->b_addr, bp->b_page_count);
>  
>  	for (i = 0; i < bp->b_page_count; i++) {
>  		if (bp->b_pages[i])
> @@ -442,7 +442,7 @@ _xfs_buf_map_pages(
>  	ASSERT(bp->b_flags & _XBF_PAGES);
>  	if (bp->b_page_count == 1) {
>  		/* A single page buffer is always mappable */
> -		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
> +		bp->b_addr = page_address(bp->b_pages[0]);
>  	} else if (flags & XBF_UNMAPPED) {
>  		bp->b_addr = NULL;
>  	} else {
> @@ -469,7 +469,6 @@ _xfs_buf_map_pages(
>  
>  		if (!bp->b_addr)
>  			return -ENOMEM;
> -		bp->b_addr += bp->b_offset;
>  	}
>  
>  	return 0;
> @@ -1680,7 +1679,6 @@ xfs_buf_offset(
>  	if (bp->b_addr)
>  		return bp->b_addr + offset;
>  
> -	offset += bp->b_offset;
>  	page = bp->b_pages[offset >> PAGE_SHIFT];
>  	return page_address(page) + (offset & (PAGE_SIZE-1));
>  }
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 459ca34f26f5..464dc548fa23 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -167,7 +167,8 @@ struct xfs_buf {
>  	atomic_t		b_pin_count;	/* pin count */
>  	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
>  	unsigned int		b_page_count;	/* size of page array */
> -	unsigned int		b_offset;	/* page offset in first page */
> +	unsigned int		b_offset;	/* page offset of b_addr,
> +						   only for _XBF_KMEM buffers */
>  	int			b_error;	/* error code on I/O */
>  
>  	/*
> -- 
> 2.31.1
> 
