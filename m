Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07485C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8691613BE
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhE0XDv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 19:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhE0XDv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 19:03:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AECA461181;
        Thu, 27 May 2021 23:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622156537;
        bh=ASGYoJqwBPTSBJ6oZcfcCA3riWJQDBhsnopNyG2Zf4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jgyeu8JiXMVL2v0rd1cQ7Rwd7q9uYgTehxiJJ7tTsKOoeEkKFXtK3BtYLSMCJm3JJ
         kdOLBg/U8MJsIsq0UlQohpRLimQGPn3sBAXCxW4vSM1FPJyCpmH+nOPhvxjMH2CAG5
         BtdEjtOHBASmDJH6ZBFjDu2hN0QDQqPuEWCQj6BSq6DS5DntlSEMgCH/11dwKUGCFU
         r0ClW0uwCgUq8KzV9TM8zw9Ss1HgqpCMBL5RLL0JMZgDMWyHz5CPP7uIDBBSxz9wnd
         L2L1yo3wjmHN8CHBpHaCac22XqBT9jTFUyr/B3a0imMp4xjCHa+6++ZxrbZEOyuIqA
         BUHbratoyLYsg==
Date:   Thu, 27 May 2021 16:02:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/10] xfs: merge _xfs_buf_get_pages()
Message-ID: <20210527230217.GE2402049@locust>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526224722.1111377-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 08:47:16AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Only called from one place now, so merge it into
> xfs_buf_alloc_pages(). Because page array allocation is dependent on
> bp->b_pages being null, always ensure that when the pages array is
> freed we always set bp->b_pages to null.
> 
> Also convert the page array to use kmalloc() rather than
> kmem_alloc() so we can use the gfp flags we've already calculated
> for the allocation context instead of hard coding KM_NOFS semantics.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Yippeeeee
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 48 ++++++++++++++----------------------------------
>  1 file changed, 14 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8ca4add138c5..aa978111c01f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -272,31 +272,6 @@ _xfs_buf_alloc(
>  	return 0;
>  }
>  
> -/*
> - *	Allocate a page array capable of holding a specified number
> - *	of pages, and point the page buf at it.
> - */
> -STATIC int
> -_xfs_buf_get_pages(
> -	struct xfs_buf		*bp,
> -	int			page_count)
> -{
> -	/* Make sure that we have a page list */
> -	if (bp->b_pages == NULL) {
> -		bp->b_page_count = page_count;
> -		if (page_count <= XB_PAGES) {
> -			bp->b_pages = bp->b_page_array;
> -		} else {
> -			bp->b_pages = kmem_alloc(sizeof(struct page *) *
> -						 page_count, KM_NOFS);
> -			if (bp->b_pages == NULL)
> -				return -ENOMEM;
> -		}
> -		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
> -	}
> -	return 0;
> -}
> -
>  /*
>   *	Frees b_pages if it was allocated.
>   */
> @@ -304,10 +279,9 @@ STATIC void
>  _xfs_buf_free_pages(
>  	struct xfs_buf	*bp)
>  {
> -	if (bp->b_pages != bp->b_page_array) {
> +	if (bp->b_pages != bp->b_page_array)
>  		kmem_free(bp->b_pages);
> -		bp->b_pages = NULL;
> -	}
> +	bp->b_pages = NULL;
>  }
>  
>  /*
> @@ -389,16 +363,22 @@ xfs_buf_alloc_pages(
>  	long		filled = 0;
>  	int		error;
>  
> +	/* Make sure that we have a page list */
> +	bp->b_page_count = page_count;
> +	if (bp->b_page_count <= XB_PAGES) {
> +		bp->b_pages = bp->b_page_array;
> +	} else {
> +		bp->b_pages = kzalloc(sizeof(struct page *) * bp->b_page_count,
> +					gfp_mask);
> +		if (!bp->b_pages)
> +			return -ENOMEM;
> +	}
> +	bp->b_flags |= _XBF_PAGES;
> +
>  	/* Assure zeroed buffer for non-read cases. */
>  	if (!(flags & XBF_READ))
>  		gfp_mask |= __GFP_ZERO;
>  
> -	error = _xfs_buf_get_pages(bp, page_count);
> -	if (unlikely(error))
> -		return error;
> -
> -	bp->b_flags |= _XBF_PAGES;
> -
>  	/*
>  	 * Bulk filling of pages can take multiple calls. Not filling the entire
>  	 * array is not an allocation failure, so don't back off if we get at
> -- 
> 2.31.1
> 
