Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D5FC47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20467613D1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhE0XN4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 19:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236426AbhE0XNy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 19:13:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6489613BF;
        Thu, 27 May 2021 23:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622157140;
        bh=1j89W4Zu2dD6Q/Izy9gvqk+tAOLk0rjY9PaJtxdbSXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ONTjm0a9qD9suHBCM9/KoH07MsWPr3WBtq58g+/8UpJx6OmflobBgn6Uq3L7Zt05T
         gWgypu0uME4wsdzBJKObdKlra2WjYXusfTZwQtQZFZZJiLG63r+VpwV8VURY9R4jdP
         nvcXs83fk0BvxtJn4rYuTO1TihNCHxlXknWECgiigPfaAJ0+PtuXtCL1ezAXL3aofp
         fQmZEy6k4Ebte0BPUy8QgYb70+VvS+21MvlHysNyXSBXTPizOTYT3ZbYihF/LI58Jn
         beLxeZ2ZXdojTvc+Mn29fVJM4EvCHYzpTidMWAlIX46tvzku+3wFspZheM/GLW0eES
         NG4JBmV9TerpQ==
Date:   Thu, 27 May 2021 16:12:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/10] xfs: get rid of xb_to_gfp()
Message-ID: <20210527231220.GI2402049@locust>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526224722.1111377-9-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 08:47:20AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Only used in one place, so just open code the logic in the macro.
> Based on a patch from Christoph Hellwig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1500a9c63432..701a798db7b7 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -22,9 +22,6 @@
>  
>  static kmem_zone_t *xfs_buf_zone;
>  
> -#define xb_to_gfp(flags) \
> -	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : GFP_NOFS) | __GFP_NOWARN)
> -
>  /*
>   * Locking orders
>   *
> @@ -350,9 +347,14 @@ xfs_buf_alloc_pages(
>  	struct xfs_buf	*bp,
>  	xfs_buf_flags_t	flags)
>  {
> -	gfp_t		gfp_mask = xb_to_gfp(flags);
> +	gfp_t		gfp_mask = __GFP_NOWARN;
>  	long		filled = 0;
>  
> +	if (flags & XBF_READ_AHEAD)
> +		gfp_mask |= __GFP_NORETRY;
> +	else
> +		gfp_mask |= GFP_NOFS;
> +
>  	/* Make sure that we have a page list */
>  	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
>  	if (bp->b_page_count <= XB_PAGES) {
> -- 
> 2.31.1
> 
