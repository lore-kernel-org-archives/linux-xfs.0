Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB72C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A24F8613BA
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhE0XSm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 19:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234964AbhE0XSm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 19:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5B56613BF;
        Thu, 27 May 2021 23:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622157428;
        bh=uxeX8fqiDh4lu3+mA7+z6yBgOFWn2fkk0cSgA821dog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NgUS204kfm4F7WpuSML2tyRsI2scMLArFPcleSAKZVHo2eF1BZxkFe4/mdKXxh0II
         QJdAWF5ng+M+uha1ePFfX+MLrXsDCwh5TA7z1ZYZtt9iQW1Ty0Lv9rw1Rv+NS1+R1f
         O0b6kuMPACIHe5yUfW4rODpB6DI2cLRQ32M92K5d7xc2+fkBEEGUhtPQG2DEAnCw+q
         DbeBvWyu4rw9ChvX2RUuS6vbDQ8xjCfTqVok2Oj9tjv6K7MySxWDTzSOfOsYltpBSG
         C7KxZRqW7P65tg55pQxwOSRHQGjY5/Pn5cPTVbmZYyM8lSaXd4w4d29gTTmoOKtqGg
         bwsBuLW2qyGCA==
Date:   Thu, 27 May 2021 16:17:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/10] xfs: merge xfs_buf_allocate_memory
Message-ID: <20210527231708.GL2402049@locust>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526224722.1111377-11-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 08:47:22AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It only has one caller and is now a simple function, so merge it
> into the caller.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Makes sense!  Nice cleanup series.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 44 +++++++++++++-------------------------------
>  1 file changed, 13 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f56a76f8a653..12f7b20727dd 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -313,11 +313,11 @@ xfs_buf_free(
>  static int
>  xfs_buf_alloc_kmem(
>  	struct xfs_buf	*bp,
> -	size_t		size,
>  	xfs_buf_flags_t	flags)
>  {
>  	int		align_mask = xfs_buftarg_dma_alignment(bp->b_target);
>  	xfs_km_flags_t	kmflag_mask = KM_NOFS;
> +	size_t		size = BBTOB(bp->b_length);
>  
>  	/* Assure zeroed buffer for non-read cases. */
>  	if (!(flags & XBF_READ))
> @@ -400,33 +400,6 @@ xfs_buf_alloc_pages(
>  	return 0;
>  }
>  
> -
> -/*
> - * Allocates all the pages for buffer in question and builds it's page list.
> - */
> -static int
> -xfs_buf_allocate_memory(
> -	struct xfs_buf		*bp,
> -	uint			flags)
> -{
> -	size_t			size;
> -	int			error;
> -
> -	/*
> -	 * For buffers that fit entirely within a single page, first attempt to
> -	 * allocate the memory from the heap to minimise memory usage. If we
> -	 * can't get heap memory for these small buffers, we fall back to using
> -	 * the page allocator.
> -	 */
> -	size = BBTOB(bp->b_length);
> -	if (size < PAGE_SIZE) {
> -		error = xfs_buf_alloc_kmem(bp, size, flags);
> -		if (!error)
> -			return 0;
> -	}
> -	return xfs_buf_alloc_pages(bp, flags);
> -}
> -
>  /*
>   *	Map buffer into kernel address-space if necessary.
>   */
> @@ -688,9 +661,18 @@ xfs_buf_get_map(
>  	if (error)
>  		return error;
>  
> -	error = xfs_buf_allocate_memory(new_bp, flags);
> -	if (error)
> -		goto out_free_buf;
> +	/*
> +	 * For buffers that fit entirely within a single page, first attempt to
> +	 * allocate the memory from the heap to minimise memory usage. If we
> +	 * can't get heap memory for these small buffers, we fall back to using
> +	 * the page allocator.
> +	 */
> +	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
> +	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
> +		error = xfs_buf_alloc_pages(new_bp, flags);
> +		if (error)
> +			goto out_free_buf;
> +	}
>  
>  	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
>  	if (error)
> -- 
> 2.31.1
> 
