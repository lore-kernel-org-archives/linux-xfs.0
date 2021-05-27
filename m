Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07170C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 22:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD691613BF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 22:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhE0WwX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 18:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhE0WwX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 18:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 951CF61184;
        Thu, 27 May 2021 22:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622155849;
        bh=gYslBLFKy6UV8nKpC8Pv+uKhxfhzAqcJ5zpfUa/PK2E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uhCmm7SbbNeKC/UTD4LjzF7kdoX9ig9Nnwm45SEPa9gyQEI6/vDf9vmUc0USQ0dB+
         yvMzjmWtrSAS0xa9umgzHRCg3FeaB0A5H4guIEANwdfkOrowmPPnck07pdKiHep7Me
         /DTEuJe1GsmNrxdFrHWJdtDu4ez6T3hykzf4q1ttpo21ptKTCk7lOUCGonlVJCDXqe
         0YZt/iQ6G+0/cyQJtKQMVzY83fnehY/6XPsmlPcUPPd8Cq9ehxW5+xqyATFfTq6yKY
         gRZ50CA1Y36c9T9zjyV2WWcl2GrqQMKWpA03JlXOuRHr9fQiW1N7YXIlpoabVOsWYF
         eZCNDQHcdXZ6Q==
Date:   Thu, 27 May 2021 15:50:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/10] xfs: use xfs_buf_alloc_pages for uncached buffers
Message-ID: <20210527225049.GB2402049@locust>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526224722.1111377-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 08:47:14AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Use the newly factored out page allocation code. This adds
> automatic buffer zeroing for non-read uncached buffers.
> 
> This also allows us to greatly simply the error handling in
> xfs_buf_get_uncached(). Because xfs_buf_alloc_pages() cleans up
> partial allocation failure, we can just call xfs_buf_free() in all
> error cases now to clean up after failures.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Nice cleanup!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c |  1 -
>  fs/xfs/xfs_buf.c       | 27 ++++++---------------------
>  2 files changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index c68a36688474..be0087825ae0 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -43,7 +43,6 @@ xfs_get_aghdr_buf(
>  	if (error)
>  		return error;
>  
> -	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
>  	bp->b_bn = blkno;
>  	bp->b_maps[0].bm_bn = blkno;
>  	bp->b_ops = ops;
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 2e35d344a69b..b1610115d401 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -973,7 +973,7 @@ xfs_buf_get_uncached(
>  	struct xfs_buf		**bpp)
>  {
>  	unsigned long		page_count;
> -	int			error, i;
> +	int			error;
>  	struct xfs_buf		*bp;
>  	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
>  
> @@ -982,41 +982,26 @@ xfs_buf_get_uncached(
>  	/* flags might contain irrelevant bits, pass only what we care about */
>  	error = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT, &bp);
>  	if (error)
> -		goto fail;
> +		return error;
>  
>  	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;
> -	error = _xfs_buf_get_pages(bp, page_count);
> +	error = xfs_buf_alloc_pages(bp, page_count, flags);
>  	if (error)
>  		goto fail_free_buf;
>  
> -	for (i = 0; i < page_count; i++) {
> -		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
> -		if (!bp->b_pages[i]) {
> -			error = -ENOMEM;
> -			goto fail_free_mem;
> -		}
> -	}
> -	bp->b_flags |= _XBF_PAGES;
> -
>  	error = _xfs_buf_map_pages(bp, 0);
>  	if (unlikely(error)) {
>  		xfs_warn(target->bt_mount,
>  			"%s: failed to map pages", __func__);
> -		goto fail_free_mem;
> +		goto fail_free_buf;
>  	}
>  
>  	trace_xfs_buf_get_uncached(bp, _RET_IP_);
>  	*bpp = bp;
>  	return 0;
>  
> - fail_free_mem:
> -	while (--i >= 0)
> -		__free_page(bp->b_pages[i]);
> -	_xfs_buf_free_pages(bp);
> - fail_free_buf:
> -	xfs_buf_free_maps(bp);
> -	kmem_cache_free(xfs_buf_zone, bp);
> - fail:
> +fail_free_buf:
> +	xfs_buf_free(bp);
>  	return error;
>  }
>  
> -- 
> 2.31.1
> 
