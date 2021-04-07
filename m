Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB97C433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57D146138B
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhDGPm1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 11:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233167AbhDGPmZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 11:42:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D119B61382;
        Wed,  7 Apr 2021 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617810135;
        bh=QmlI83lirVyVwTrVENSlsQFDiK3Ap3IaFZzfM3JtpSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gC3gRo9CIom4fAkw2nQgEQcM8g7tIKjZswC/uSpxPb/zZ3a1W83NR89QZDczt7I6D
         y5SSrFVHHkW4Aq1oYFi8QECMhPWUWjAEtCO8E5sSMirR1Bh39pPandrQWaunCS62tH
         zN9nC2KOpJzHKcSZC8MWUYNqCcTpqwxAljL5rNKuoG30Y18Uq9G7CkYs9K5JBmxita
         syTzYGV3h+2UW1MDBejZ/EIUaSuisWv+sRKFNUAW830A/VqVc6Ew2x+GTXWhs62hAK
         L/HS3jAYCCl7nWxajCeVdnzV8sVCVgxy8jC9IXJ1dOjWjytjsA7u6Xyny5TIc1QzQU
         Kk+zEnkwrqhOQ==
Date:   Wed, 7 Apr 2021 08:42:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: open code ioend needs workqueue helper
Message-ID: <20210407154215.GM3957620@magnolia>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405145903.629152-3-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 05, 2021 at 10:59:01AM -0400, Brian Foster wrote:
> Open code xfs_ioend_needs_workqueue() into the only remaining
> caller.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

I would have left it, but don't really care either way...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_aops.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c1951975bd6a..63ecc04de64f 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -206,13 +206,6 @@ xfs_end_io(
>  	}
>  }
>  
> -static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
> -{
> -	return xfs_ioend_is_append(ioend) ||
> -		ioend->io_type == IOMAP_UNWRITTEN ||
> -		(ioend->io_flags & IOMAP_F_SHARED);
> -}
> -
>  STATIC void
>  xfs_end_bio(
>  	struct bio		*bio)
> @@ -472,7 +465,9 @@ xfs_prepare_ioend(
>  
>  	memalloc_nofs_restore(nofs_flag);
>  
> -	if (xfs_ioend_needs_workqueue(ioend))
> +	/* send ioends that might require a transaction to the completion wq */
> +	if (xfs_ioend_is_append(ioend) || ioend->io_type == IOMAP_UNWRITTEN ||
> +	    (ioend->io_flags & IOMAP_F_SHARED))
>  		ioend->io_bio->bi_end_io = xfs_end_bio;
>  	return status;
>  }
> -- 
> 2.26.3
> 
