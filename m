Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C718C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 23:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 604C86138C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 23:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhETXpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 19:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233104AbhETXpB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 19:45:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7AE360FE5;
        Thu, 20 May 2021 23:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621554219;
        bh=wr58G3YxyMXRgq91+KzClba8Oh8UiFZi9bUzxWuZi3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cKNniIeHS3gwGkfGtBbZ1Vx1Y2f3qCU+hzvA9tBUoHwwSI2sapLidW7GniBh2g2JF
         twywvbD6dqRsHitIE/x1SEhfgFCfJVqWZQiehddIJ87XS7jrOAgkmNjk/kzwJmD+1M
         92OtxTE/gqQfbvlXQiWJsQP+Z4WQLV5VZy1NRHMyX9GhtfGd4uu7seo4/YdeOV3Va9
         2UEjLsFfZRhD6XZqxqC3uexiQhtFrBOK7v9ZoVeOg5SOPJXCiKjqgHf8SUYhAf4k6J
         1XqxtZcpjqQdHcg67edlSZdbpULUz1QHeBPMv4QA/RkeGbX2fBgWVahpnIonbZSSYz
         NF+rnK/18PRwQ==
Date:   Thu, 20 May 2021 16:43:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] xfs: cleanup error handling in xfs_buf_get_map
Message-ID: <20210520234338.GD9675@magnolia>
References: <20210519190900.320044-1-hch@lst.de>
 <20210519190900.320044-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519190900.320044-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 09:08:50PM +0200, Christoph Hellwig wrote:
> Use a single goto label for freeing the buffer and returning an error.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 592800c8852f45..80be0333f077c0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -721,16 +721,12 @@ xfs_buf_get_map(
>  		return error;
>  
>  	error = xfs_buf_allocate_memory(new_bp, flags);
> -	if (error) {
> -		xfs_buf_free(new_bp);
> -		return error;
> -	}
> +	if (error)
> +		goto out_free_buf;
>  
>  	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
> -	if (error) {
> -		xfs_buf_free(new_bp);
> -		return error;
> -	}
> +	if (error)
> +		goto out_free_buf;
>  
>  	if (bp != new_bp)
>  		xfs_buf_free(new_bp);
> @@ -758,6 +754,9 @@ xfs_buf_get_map(
>  	trace_xfs_buf_get(bp, flags, _RET_IP_);
>  	*bpp = bp;
>  	return 0;
> +out_free_buf:
> +	xfs_buf_free(new_bp);
> +	return error;
>  }
>  
>  int
> -- 
> 2.30.2
> 
