Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08D3C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4366464F0A
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhBXVfK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231717AbhBXVfK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 16:35:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C73864F08;
        Wed, 24 Feb 2021 21:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614202469;
        bh=u3qakhSCCECT7aroazzGe5wMi81aHVfeumTT794rtZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=luuPyc9imohJ8vsS3Tec/HVPgGHbSuJWa84nWXL6b0ZXEUvG32AWSg17H0gDJXVOt
         DskKIOt331TCbQyKX/ISjIF0beaG+LtJkwwHdewHq3PhpJeGcOphDsM+S9BIPH0z3N
         9nRGS2bvf90nS/rvWiuO8//Am7ScNZVTNrATqYoOv0DNZiyiKeyMdaqOm3mNtLSmzT
         yVHq67bTP4hTqqpfzFd+I1P6COG9KsJFc6Az00CUADKWmwY7umTa6rKMBN7W8Bz8Wg
         UUpUDJwcaWV2etE+EZXF9N0/A79CsZJmvVdURHC3ult2jCH8LOaMVUWSu/MhnKiMvx
         kEadi+El0cqPA==
Date:   Wed, 24 Feb 2021 13:34:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: xfs_buf_item_size_segment() needs to pass
 segment offset
Message-ID: <20210224213428.GZ7272@magnolia>
References: <20210223044636.3280862-1-david@fromorbit.com>
 <20210223044636.3280862-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223044636.3280862-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 03:46:35PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Otherwise it doesn't correctly calculate the number of vectors
> in a logged buffer that has a contiguous map that gets split into
> multiple regions because the range spans discontigous memory.
> 
> Probably never been hit in practice - we don't log contiguous ranges
> on unmapped buffers (inode clusters).
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Subtle.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 0628a65d9c55..91dc7d8c9739 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -55,6 +55,18 @@ xfs_buf_log_format_size(
>  			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
>  }
>  
> +static inline bool
> +xfs_buf_item_straddle(
> +	struct xfs_buf		*bp,
> +	uint			offset,
> +	int			next_bit,
> +	int			last_bit)
> +{
> +	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
> +		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
> +		 XFS_BLF_CHUNK);
> +}
> +
>  /*
>   * Return the number of log iovecs and space needed to log the given buf log
>   * item segment.
> @@ -67,6 +79,7 @@ STATIC void
>  xfs_buf_item_size_segment(
>  	struct xfs_buf_log_item		*bip,
>  	struct xfs_buf_log_format	*blfp,
> +	uint				offset,
>  	int				*nvecs,
>  	int				*nbytes)
>  {
> @@ -101,12 +114,8 @@ xfs_buf_item_size_segment(
>  		 */
>  		if (next_bit == -1) {
>  			break;
> -		} else if (next_bit != last_bit + 1) {
> -			last_bit = next_bit;
> -			(*nvecs)++;
> -		} else if (xfs_buf_offset(bp, next_bit * XFS_BLF_CHUNK) !=
> -			   (xfs_buf_offset(bp, last_bit * XFS_BLF_CHUNK) +
> -			    XFS_BLF_CHUNK)) {
> +		} else if (next_bit != last_bit + 1 ||
> +		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
>  			last_bit = next_bit;
>  			(*nvecs)++;
>  		} else {
> @@ -141,8 +150,10 @@ xfs_buf_item_size(
>  	int			*nbytes)
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> +	struct xfs_buf		*bp = bip->bli_buf;
>  	int			i;
>  	int			bytes;
> +	uint			offset = 0;
>  
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  	if (bip->bli_flags & XFS_BLI_STALE) {
> @@ -184,8 +195,9 @@ xfs_buf_item_size(
>  	 */
>  	bytes = 0;
>  	for (i = 0; i < bip->bli_format_count; i++) {
> -		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
> +		xfs_buf_item_size_segment(bip, &bip->bli_formats[i], offset,
>  					  nvecs, &bytes);
> +		offset += BBTOB(bp->b_maps[i].bm_len);
>  	}
>  
>  	/*
> @@ -212,18 +224,6 @@ xfs_buf_item_copy_iovec(
>  			nbits * XFS_BLF_CHUNK);
>  }
>  
> -static inline bool
> -xfs_buf_item_straddle(
> -	struct xfs_buf		*bp,
> -	uint			offset,
> -	int			next_bit,
> -	int			last_bit)
> -{
> -	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
> -		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
> -		 XFS_BLF_CHUNK);
> -}
> -
>  static void
>  xfs_buf_item_format_segment(
>  	struct xfs_buf_log_item	*bip,
> -- 
> 2.28.0
> 
