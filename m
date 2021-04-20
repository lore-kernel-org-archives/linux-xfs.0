Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B10C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B02D6613CD
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhDTRLK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhDTRLI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 13:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 121E961076;
        Tue, 20 Apr 2021 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618938637;
        bh=NWqsz2NcKc7FCI4eofDE6H/oLs6Uuv0dLkcnijmIJiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iSKQGaCdyRSuyahjfFKmu7At99Xsn8nFIjG7gkT9luOjpxsXFgARjkzIp2sMsryBr
         1KjO0r0JQK4C90NUYBZJlt4TxEK3p+4k+ps0ZXYjttzP4A0NmmLtAR/+LNxT2T4tNQ
         SskH68BT76mhtORQaykViQnmSbgc3lQnlNtiBcVLz0FEJ7JbIY7pp7PbMr1OA8/8Af
         4k6Lm9Qims7ELFn5eed4nzKHPmnDFoptoxCu4C3mk8wdEWlt9TuZk6gRZR0z7E+6cN
         upalCX2xhg86AGwJKB0tpiVnkgLoTlybDPalRQ45OPufv3HCHwVAhlrobiZ9/TJ/Dv
         APTM5HGnPbzrg==
Date:   Tue, 20 Apr 2021 10:10:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 4/7]  xfs: pass a xfs_efd_log_item to xfs_efd_item_sizeof
Message-ID: <20210420171036.GJ3122264@magnolia>
References: <20210419082804.2076124-1-hch@lst.de>
 <20210419082804.2076124-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419082804.2076124-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 19, 2021 at 10:28:01AM +0200, Christoph Hellwig wrote:
> xfs_efd_log_item only looks at the embedded xfs_efd_log_item structure,
> so pass that directly and rename the function to xfs_efd_log_item_sizeof.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_extfree_item.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 7ae570d1944590..f15d6cfca6e2f1 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -195,11 +195,11 @@ xfs_efd_item_free(struct xfs_efd_log_item *efdp)
>   * structure.
>   */
>  static inline int
> -xfs_efd_item_sizeof(
> -	struct xfs_efd_log_item *efdp)
> +xfs_efd_log_item_sizeof(

Same naming complaint as the last patch, though the code changes
themselves look fine to me.

--D

> +	struct xfs_efd_log_format *elf)
>  {
>  	return sizeof(struct xfs_efd_log_format) +
> -	       (efdp->efd_format.efd_nextents - 1) * sizeof(struct xfs_extent);
> +	       (elf->efd_nextents - 1) * sizeof(struct xfs_extent);
>  }
>  
>  STATIC void
> @@ -209,7 +209,7 @@ xfs_efd_item_size(
>  	int			*nbytes)
>  {
>  	*nvecs += 1;
> -	*nbytes += xfs_efd_item_sizeof(EFD_ITEM(lip));
> +	*nbytes += xfs_efd_log_item_sizeof(&EFD_ITEM(lip)->efd_format);
>  }
>  
>  /*
> @@ -234,7 +234,7 @@ xfs_efd_item_format(
>  
>  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFD_FORMAT,
>  			&efdp->efd_format,
> -			xfs_efd_item_sizeof(efdp));
> +			xfs_efd_log_item_sizeof(&efdp->efd_format));
>  }
>  
>  /*
> -- 
> 2.30.1
> 
