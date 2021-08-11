Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BF8C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 00:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 079A060EE9
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 00:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbhHKAfW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 20:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231423AbhHKAfW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Aug 2021 20:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C1C260EE9;
        Wed, 11 Aug 2021 00:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628642099;
        bh=xXJPDSb62mVY78+SOZGI0wx4FferoH74tQ0wUIQlFs0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MC61dMBUx4C7dMR1TL6pIQDuDDxXEvRwz+M/YrC04pYCcS0KjJYB9W1jSY+GbVbmJ
         xkLA4x//ObE8+09/e/eQlwSFM9AN9JvXeYJ0ewnfIYvlmKDRZyJE1XPnmtHoqCOW/A
         pHcVwrqIWzlmMxoQ3RNC/kWyO5Nlm3pHbIY4kJluMuoN7vRmG0Pfz6AlHYQwpD7XjC
         Ja3towTFWkU0qRYl9JF7NR4afEo2yTyWrkz63Tm5aSygQJP8UFLueQ4DkLGzutt2Bh
         zVwbl2Q9jxagwr2h/M8L5I32BVXUF4K3vpAa8NiwNMY0EIGpWyv+4I+433eCGLRWT9
         aymoJ0J7ZWBOA==
Date:   Tue, 10 Aug 2021 17:34:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: sb verifier doesn't handle uncached sb buffer
Message-ID: <20210811003458.GV3601443@magnolia>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052451.41578-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 10, 2021 at 03:24:36PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The verifier checks explicitly for bp->b_bn == XFS_SB_DADDR to match
> the primary superblock buffer, but the primary superblock is an
> uncached buffer and so bp->b_bn is always -1ULL. Hence this never
> matches and the CRC error reporting is wholly dependent on the
> mount superblock already being populated so CRC feature checks pass
> and allow CRC errors to be reported.
> 
> Fix this so that the primary superblock CRC error reporting is not
> dependent on already having read the superblock into memory.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Not sure why this isn't in the series with xfs_buf_daddr and the other
cleanups, but the changes look correct to me.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_sb.c | 2 +-
>  fs/xfs/xfs_buf.h       | 7 ++++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 04f5386446db..4a4586bd2ba2 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -636,7 +636,7 @@ xfs_sb_read_verify(
>  
>  		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
>  			/* Only fail bad secondaries on a known V5 filesystem */
> -			if (bp->b_bn == XFS_SB_DADDR ||
> +			if (bp->b_maps[0].bm_bn == XFS_SB_DADDR ||
>  			    xfs_sb_version_hascrc(&mp->m_sb)) {
>  				error = -EFSBADCRC;
>  				goto out_error;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index cfbe37d73293..37c9004f11de 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -133,7 +133,12 @@ struct xfs_buf {
>  	 * fast-path on locking.
>  	 */
>  	struct rhash_head	b_rhash_head;	/* pag buffer hash node */
> -	xfs_daddr_t		b_bn;		/* block number of buffer */
> +
> +	/*
> +	 * b_bn is the cache index. Do not use directly, use b_maps[0].bm_bn
> +	 * for the buffer disk address instead.
> +	 */
> +	xfs_daddr_t		b_bn;
>  	int			b_length;	/* size of buffer in BBs */
>  	atomic_t		b_hold;		/* reference count */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
> -- 
> 2.31.1
> 
