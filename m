Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597EDC4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31DAE613D1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbhE0XRT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 19:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234964AbhE0XRS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 19:17:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1440D613BF;
        Thu, 27 May 2021 23:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622157345;
        bh=Z1HkGMfWys10Nam6OoUBDaLZk7WCWgwzpzStqrxeLTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aBpvi5SNm67C9zm8NS2XZRNQzu/B7OocQhxUNFMBKA87FbRSeweF5Q3OPmTfEZlpu
         HP3Rz5+tbwKxaacsxkFZa5hqeqZiET0kcgaQdp3vVNZQAS55oDwOshArLs5+chi5/I
         GU0Av+nCnNp9FkDrdQ1mmlLeSJCKV3o9nz+3mKQuBikAj54cpLVNMyCLUtJqNsy/HQ
         1FMQ7hXSjwqOvA3otVUTOzNVQ4c6Q7Mgvnd3x4XNInb0VGaTquwL6Xf/a5LNaL8btw
         y6w/GZ/Da8zlIGdSBnLdqFrrjkmH7kp/WFjZgW/JWaTjKo7gfgiiuEQDXVwo9vX1dj
         OMsVplW8hqUHw==
Date:   Thu, 27 May 2021 16:15:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/10] xfs: simplify the b_page_count calculation
Message-ID: <20210527231544.GJ2402049@locust>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526224722.1111377-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 08:47:19AM +1000, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Ever since we stopped using the Linux page cache

The premise of /that/ is unsettling.  Um... did b_pages[] point to
pagecache pages, and that's why all that offset shifting was necessary?

> to back XFS buffes

s/buffes/buffers/

> there is no need to take the start sector into account for
> calculating the number of pages in a buffer, as the data always
> start from the beginning of the buffer.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [dgc: modified to suit this series]
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 87151d78a0d8..1500a9c63432 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -348,14 +348,13 @@ xfs_buf_alloc_kmem(
>  static int
>  xfs_buf_alloc_pages(
>  	struct xfs_buf	*bp,
> -	uint		page_count,
>  	xfs_buf_flags_t	flags)
>  {
>  	gfp_t		gfp_mask = xb_to_gfp(flags);
>  	long		filled = 0;
>  
>  	/* Make sure that we have a page list */
> -	bp->b_page_count = page_count;
> +	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
>  	if (bp->b_page_count <= XB_PAGES) {
>  		bp->b_pages = bp->b_page_array;
>  	} else {
> @@ -409,7 +408,6 @@ xfs_buf_allocate_memory(
>  	uint			flags)
>  {
>  	size_t			size;
> -	xfs_off_t		start, end;
>  	int			error;
>  
>  	/*
> @@ -424,11 +422,7 @@ xfs_buf_allocate_memory(
>  		if (!error)
>  			return 0;
>  	}
> -
> -	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
> -	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
> -								>> PAGE_SHIFT;
> -	return xfs_buf_alloc_pages(bp, end - start, flags);
> +	return xfs_buf_alloc_pages(bp, flags);
>  }
>  
>  /*
> @@ -922,7 +916,6 @@ xfs_buf_get_uncached(
>  	int			flags,
>  	struct xfs_buf		**bpp)
>  {
> -	unsigned long		page_count;
>  	int			error;
>  	struct xfs_buf		*bp;
>  	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
> @@ -934,8 +927,7 @@ xfs_buf_get_uncached(
>  	if (error)
>  		return error;
>  
> -	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;
> -	error = xfs_buf_alloc_pages(bp, page_count, flags);
> +	error = xfs_buf_alloc_pages(bp, flags);
>  	if (error)
>  		goto fail_free_buf;
>  
> -- 
> 2.31.1
> 
