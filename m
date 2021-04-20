Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDEBC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAADF613C2
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhDTRKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232473AbhDTRKY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 13:10:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2DEE613AE;
        Tue, 20 Apr 2021 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618938592;
        bh=iy4QAoYjnJYaFfYUPcFxuj6yIf5Bu0CAPllFqa8Uljk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YJsMcob9Jm42fgQaTH5Ln9AWWCVr4oe0wAXvxuTZJdpLrTc84GBAaKDufApza5bq0
         rxfgECGlV9+LNSF2xoJrrxZTGCJgBq9ypXMsctjNZI5K1TvyveKFHm92W7hMRwnw+t
         jZ7cVTMHnF4GQ+RlDSl8IbpIhaFlZ2mt1t3f4eqHpvjF4ci1OMQNyZgnKpfgLKC/HS
         e9mFYkQOuBjxL5xCsfCl/zR8piNskXmbAtOghZmtCR8K9x7PDc9OcuELJMVuKxrcm5
         DBLAndIVyp/Ziq69q7UIWhpM8VNxt/z0++z4zCeX44Hepxs7zhTeslPDn4d79yycWG
         pS7w6ZwVXsIAg==
Date:   Tue, 20 Apr 2021 10:09:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 3/7] xfs: pass a xfs_efi_log_item to xfs_efi_item_sizeof
Message-ID: <20210420170952.GI3122264@magnolia>
References: <20210419082804.2076124-1-hch@lst.de>
 <20210419082804.2076124-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419082804.2076124-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 19, 2021 at 10:28:00AM +0200, Christoph Hellwig wrote:
> xfs_efi_log_item only looks at the embedded xfs_efi_log_item structure,
> so pass that directly and rename the function to xfs_efi_log_item_sizeof.
> This allows using the helper in xlog_recover_efi_commit_pass2 as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_extfree_item.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index ed8d0790908ea7..7ae570d1944590 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -70,11 +70,11 @@ xfs_efi_release(
>   * structure.
>   */
>  static inline int
> -xfs_efi_item_sizeof(
> -	struct xfs_efi_log_item *efip)
> +xfs_efi_log_item_sizeof(

Shouldn't this be named xfs_efi_log_format_sizeof to correspond to the
name of the structure?  Two patches from now you (re)introduce
xfs_efi_item_sizeof that returns the size of a struct xfs_efi_log_item,
which is confusing.

--D


> +	struct xfs_efi_log_format *elf)
>  {
> -	return sizeof(struct xfs_efi_log_format) +
> -	       (efip->efi_format.efi_nextents - 1) * sizeof(struct xfs_extent);
> +	return sizeof(*elf) +
> +	       (elf->efi_nextents - 1) * sizeof(struct xfs_extent);
>  }
>  
>  STATIC void
> @@ -84,7 +84,7 @@ xfs_efi_item_size(
>  	int			*nbytes)
>  {
>  	*nvecs += 1;
> -	*nbytes += xfs_efi_item_sizeof(EFI_ITEM(lip));
> +	*nbytes += xfs_efi_log_item_sizeof(&EFI_ITEM(lip)->efi_format);
>  }
>  
>  /*
> @@ -110,7 +110,7 @@ xfs_efi_item_format(
>  
>  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFI_FORMAT,
>  			&efip->efi_format,
> -			xfs_efi_item_sizeof(efip));
> +			xfs_efi_log_item_sizeof(&efip->efi_format));
>  }
>  
>  
> @@ -684,8 +684,7 @@ xlog_recover_efi_commit_pass2(
>  
>  	efip = xfs_efi_init(mp, src->efi_nextents);
>  
> -	if (buf->i_len != sizeof(*src) +
> -	    (src->efi_nextents - 1) * sizeof(struct xfs_extent)) {
> +	if (buf->i_len != xfs_efi_log_item_sizeof(src)) {
>  		error = xfs_efi_copy_format_32(&efip->efi_format, buf);
>  		if (error)
>  			goto out_free_efi;
> -- 
> 2.30.1
> 
