Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41213C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B0A1613D8
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhE0XFT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 19:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236461AbhE0XFT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 19:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5EF3613D4;
        Thu, 27 May 2021 23:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622156626;
        bh=4Kfdjbpdpv62CLY++2ioLellH+WlXZ/0JJKlh7SexnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pxkT1JO8I2e+AKLAnuA3ZUV5JDFqJSrnPHHU/LMNJuOVafDfQHTthcMBsxltC1/an
         J4k4+m96TfyzZ1ZdgJQCbZQID1e7BlqCxEbKnnee7kiBtwqM6CV5mCkCC/rTK1IQtm
         WBOb4L/PQe/WmHvhPUmtSTHF+iTGfWvh2w+NPlNdo/riazm7LEi9qJU8f2v2MEs1li
         8btc8K3pAVrDSEa/t2tiPRSd0pNfwlxVmDboHbuJltl36WCj9vbYYAcQ95OHqTuDIS
         XvQsZWe3nZE+yxHcO3T4O8SY3uD84fIEyv7zb9TwVI6da/StK3WzAOnbOYv4LMPRJM
         sAkoonxQdQB9A==
Date:   Thu, 27 May 2021 16:03:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/10] xfs: move page freeing into _xfs_buf_free_pages()
Message-ID: <20210527230345.GF2402049@locust>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526224722.1111377-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 08:47:17AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rather than open coding it just before we call
> _xfs_buf_free_pages(). Also, rename the function to
> xfs_buf_free_pages() as the leading underscore has no useful
> meaning.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks pretty straightforward.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 61 ++++++++++++++++++------------------------------
>  1 file changed, 23 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index aa978111c01f..d15999c41885 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -272,25 +272,30 @@ _xfs_buf_alloc(
>  	return 0;
>  }
>  
> -/*
> - *	Frees b_pages if it was allocated.
> - */
> -STATIC void
> -_xfs_buf_free_pages(
> +static void
> +xfs_buf_free_pages(
>  	struct xfs_buf	*bp)
>  {
> +	uint		i;
> +
> +	ASSERT(bp->b_flags & _XBF_PAGES);
> +
> +	if (xfs_buf_is_vmapped(bp))
> +		vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
> +
> +	for (i = 0; i < bp->b_page_count; i++) {
> +		if (bp->b_pages[i])
> +			__free_page(bp->b_pages[i]);
> +	}
> +	if (current->reclaim_state)
> +		current->reclaim_state->reclaimed_slab += bp->b_page_count;
> +
>  	if (bp->b_pages != bp->b_page_array)
>  		kmem_free(bp->b_pages);
>  	bp->b_pages = NULL;
> +	bp->b_flags &= ~_XBF_PAGES;
>  }
>  
> -/*
> - *	Releases the specified buffer.
> - *
> - * 	The modification state of any associated pages is left unchanged.
> - * 	The buffer must not be on any hash - use xfs_buf_rele instead for
> - * 	hashed and refcounted buffers
> - */
>  static void
>  xfs_buf_free(
>  	struct xfs_buf		*bp)
> @@ -299,24 +304,11 @@ xfs_buf_free(
>  
>  	ASSERT(list_empty(&bp->b_lru));
>  
> -	if (bp->b_flags & _XBF_PAGES) {
> -		uint		i;
> -
> -		if (xfs_buf_is_vmapped(bp))
> -			vm_unmap_ram(bp->b_addr - bp->b_offset,
> -					bp->b_page_count);
> -
> -		for (i = 0; i < bp->b_page_count; i++) {
> -			struct page	*page = bp->b_pages[i];
> -
> -			__free_page(page);
> -		}
> -		if (current->reclaim_state)
> -			current->reclaim_state->reclaimed_slab +=
> -							bp->b_page_count;
> -	} else if (bp->b_flags & _XBF_KMEM)
> +	if (bp->b_flags & _XBF_PAGES)
> +		xfs_buf_free_pages(bp);
> +	else if (bp->b_flags & _XBF_KMEM)
>  		kmem_free(bp->b_addr);
> -	_xfs_buf_free_pages(bp);
> +
>  	xfs_buf_free_maps(bp);
>  	kmem_cache_free(xfs_buf_zone, bp);
>  }
> @@ -361,7 +353,6 @@ xfs_buf_alloc_pages(
>  {
>  	gfp_t		gfp_mask = xb_to_gfp(flags);
>  	long		filled = 0;
> -	int		error;
>  
>  	/* Make sure that we have a page list */
>  	bp->b_page_count = page_count;
> @@ -398,20 +389,14 @@ xfs_buf_alloc_pages(
>  			continue;
>  
>  		if (flags & XBF_READ_AHEAD) {
> -			error = -ENOMEM;
> -			goto out_free_pages;
> +			xfs_buf_free_pages(bp);
> +			return -ENOMEM;
>  		}
>  
>  		XFS_STATS_INC(bp->b_mount, xb_page_retries);
>  		congestion_wait(BLK_RW_ASYNC, HZ/50);
>  	}
>  	return 0;
> -
> -out_free_pages:
> -	while (--filled >= 0)
> -		__free_page(bp->b_pages[filled]);
> -	bp->b_flags &= ~_XBF_PAGES;
> -	return error;
>  }
>  
>  
> -- 
> 2.31.1
> 
