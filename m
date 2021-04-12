Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F49C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 15:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0773061246
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 15:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbhDLP32 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 11:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241183AbhDLP31 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 11:29:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50371C061574;
        Mon, 12 Apr 2021 08:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mfGd7IdvphAsvIi/1CcWLKElOLtr8R1Sz6OZc2D1oss=; b=KsckI0GV46bB3x1jMMvW2bROBW
        lvJX1Ie2dGH9u7C08dTB7bvov0Ai0xeRbpTyxj+n1Hab1wNtuA8mjVzRxWv3HUUR2TUpRorbDrkD9
        sx5+TT1VdNE5lS1mI99ou7aDhGfJxVuyfe+C8FTckZ0I0mdoHxARk7qTWylm8p6IUcbYGfVaP5F2c
        dtgfAdwUpqfbwU53LWwpf0NQ+VvPKHW3yV8U3kZm1ivwuM72yRKV3hJq5t08sD456iW/dBt03Bv9e
        1X6UQRjEzVQJA657opYmuD/O9EJiV/t4SLntWYj1pp44rviKClryCd0rV93kj5yYNA8/sVM5qibXI
        zD01kCDQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lVyUs-004WGl-OO; Mon, 12 Apr 2021 15:29:06 +0000
Date:   Mon, 12 Apr 2021 16:29:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4][next] xfs: Replace one-element arrays with
 flexible-array members
Message-ID: <20210412152906.GA1075717@infradead.org>
References: <20210412135611.GA183224@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412135611.GA183224@embeddedor>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Below are the results of running xfstests for "all" with the following
> configuration in local.config:

...

> Other tests might need to be run in order to verify everything is working
> as expected. For such tests, the intervention of the maintainers might be
> needed.

This is a little weird for a commit log.  If you want to show results
this would be something that goes into a cover letter.

> +/*
> + * Calculates the size of structure xfs_efi_log_format followed by an
> + * array of n number of efi_extents elements.
> + */
> +static inline size_t
> +sizeof_efi_log_format(size_t n)
> +{
> +	return struct_size((struct xfs_efi_log_format *)0, efi_extents, n);

These helpers are completely silly.  Just keep the existing open code
version using sizeof with the one-off removed.

> -					(sizeof(struct xfs_efd_log_item) +
> -					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
> -					sizeof(struct xfs_extent)),
> -					0, 0, NULL);
> +					 struct_size((struct xfs_efd_log_item *)0,
> +					 efd_format.efd_extents,
> +					 XFS_EFD_MAX_FAST_EXTENTS),
> +					 0, 0, NULL);
>  	if (!xfs_efd_zone)
>  		goto out_destroy_buf_item_zone;
>  
>  	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
> -					 (sizeof(struct xfs_efi_log_item) +
> -					 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
> -					 sizeof(struct xfs_extent)),
> +					 struct_size((struct xfs_efi_log_item *)0,
> +					 efi_format.efi_extents,
> +					 XFS_EFI_MAX_FAST_EXTENTS),

Same here.  And this obsfucated version also adds completely pointless
overly long lines while making the code unreadable.
