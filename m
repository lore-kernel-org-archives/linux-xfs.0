Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931E8C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B6F6613D1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhE0XRy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 19:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234964AbhE0XRy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 19:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 873F6613BA;
        Thu, 27 May 2021 23:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622157380;
        bh=KrxllhtYHuqsi/tC1WbQ4NvcACi1Qr5DHEfRP7K3IzU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PYtCyGBhVB+lqi6Gqo+uiANvwSOlaYlJyGwfblwqIezeQgcRztztt27UyqF+7tPqW
         185sSt42xT4X5Xd6q6Dk1hZ5h7gVejfMS3fe5mQKKOCEfd5jB6nP6VP+Yd+lchK4S/
         h6umf0l7d/5pFR2aSTKvm7lyA0qUpWYLfnnM1y0P/nF6t9QcgjOKeELjVJupbtcWm7
         uahYQHkDWuLbs6q+gN2ikfgDQoydWl8soIp2tAf7IqxmBYsO0fmQV3gN/FAKYW0DML
         KtIjWNedtBw41a8f/W0yyPc3lHpOPkOKg28HTuJkWTtqZ3U/FSLofULRUgVJNenMGe
         Ybyy45Nj2TVRA==
Date:   Thu, 27 May 2021 16:16:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 09/10] xfs: cleanup error handling in xfs_buf_get_map
Message-ID: <20210527231620.GK2402049@locust>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526224722.1111377-10-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 08:47:21AM +1000, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Use a single goto label for freeing the buffer and returning an
> error.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Straightforward refactoring.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 701a798db7b7..f56a76f8a653 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -689,16 +689,12 @@ xfs_buf_get_map(
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
> @@ -726,6 +722,9 @@ xfs_buf_get_map(
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
> 2.31.1
> 
