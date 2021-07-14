Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D1AC12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33543613C2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhGNWrn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229983AbhGNWrn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 18:47:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED122613B2;
        Wed, 14 Jul 2021 22:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626302691;
        bh=PL0xvptAUH+uAD6LIxRe7m4zpYdhsj5rlyIqikLfjLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cp0Vj8BjF2IWSijVZ0v9fDo2/pUgudxm5S93PnQcA5kAYAWGRUOQEfHDxnRtxM8qV
         NA9X822MqyFRoDnq533Coj9O3ugy84WUx6ELLn3C7y47K4uG1Go4oEaixI1gjJbKa8
         XKCU/pgqPdx8mvv3VBcllPJYfzFmWqy67/iolijrBt7dmwMhLFh2wUcoQagdwDN4e2
         +YwJDhH7ueTOl8FFPfdG6HPs/QxGCDcLMW1mwGBJhENNfegZ+YE4r0CTrxkJ2EkQB/
         wDT7wsrH/vHkHnXWo+R7E3BErexDbumNk/F0xlwXtHzdmgssDjS/fnRwuq0tGovp5Z
         PPJvd0LK+nl2Q==
Date:   Wed, 14 Jul 2021 15:44:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: sb verifier doesn't handle uncached sb buffer
Message-ID: <20210714224450.GT22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:18:57PM +1000, Dave Chinner wrote:
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
> ---
>  fs/xfs/libxfs/xfs_sb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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

I did not know that b_bn only applies to cached buffers.

Would you mind ... I dunno, updating the comment in the struct xfs_buf
declaration to make this clearer?

	/*
	 * Block number of buffer, when this buffer is cached.  For
	 * uncached buffers, only the buffer map (i.e. b_maps[0].bm_bn)
	 * contains the block number.
	 */
	xfs_daddr_t		b_bn;

With that changed, this looks reasonable to me.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  			    xfs_sb_version_hascrc(&mp->m_sb)) {
>  				error = -EFSBADCRC;
>  				goto out_error;
> -- 
> 2.31.1
> 
