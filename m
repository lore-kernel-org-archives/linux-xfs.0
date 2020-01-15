Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A68CC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 19:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45D26207E0
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 19:14:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uvu2S3gc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgAOTOh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 14:14:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54294 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgAOTOh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 14:14:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NyZyust3M7UW4Hp/Kv4gfjVNpfDDCCCi6eBDKF/2kn4=; b=uvu2S3gcA77R0if4tjbVmBz8I
        BOvnuvWY6sft43Q/KbcTeZ22+tGCy3j0THYQXNb812dPKaOHq0Y7yCQZf5wLgmzgnVYH2m5Qr9alK
        34qmHTj1Wlzhrk+C8ekL/PsliesMcxwy0h7H+AKsOqklxGLZvrcW4WhDgMnY9hkBfAJ2wyDH06LOs
        S0MjzO6RfP2cXFH5rauAMuAKYo7IxQ+R7xIAmMspBkhVyHG+XY3UWUBVdY2JVf2fzviqAyuZXJdCx
        +X2iJj+5TZm7aRlGj7F84m97tQW2vW7gZNgP52+UOEkK7Y/WsAJbPrLeYJfCHWSb4KFFUAS9c4/Sj
        ULq+GJgrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iro7h-0002hD-Eh; Wed, 15 Jan 2020 19:14:37 +0000
Date:   Wed, 15 Jan 2020 11:14:37 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/7] xfs: streamline xfs_attr3_leaf_inactive
Message-ID: <20200115191437.GB29741@infradead.org>
References: <157910777330.2028015.5017943601641757827.stgit@magnolia>
 <157910779242.2028015.12106623745208393495.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910779242.2028015.12106623745208393495.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -	xfs_dablk_t		blkno,
> -	int			blkcnt)
> +	xfs_dablk_t		tblkno,
> +	int			tblkcnt)

Nit: I would keep the names without the t, presuming it means temporary.
In fact the hunks touching this function seems to be unrelated to the
rest of the patch.

> +	struct xfs_mount	*mp = bp->b_mount;
> +	struct xfs_attr_leafblock *leaf;
>  	struct xfs_attr_leaf_entry *entry;
>  	struct xfs_attr_leaf_name_remote *name_rmt;
> -	struct xfs_attr_inactive_list *list;
> -	struct xfs_attr_inactive_list *lp;
>  	int			error;
> -	int			count;
> -	int			size;
> -	int			tmp;
>  	int			i;
> -	struct xfs_mount	*mp = bp->b_mount;
>  
>  	leaf = bp->b_addr;

Maybe move this to the declaration line when you touch that area anyway?

>  	entry = xfs_attr3_leaf_entryp(leaf);
>  	for (i = 0; i < ichdr.count; entry++, i++) {
> +		int		blkcnt;
>  
> +		if (!be16_to_cpu(entry->nameidx) ||

While we touch this: the be16_to_cpu is superflous, given that the value
is used in boolean context.

Otherwise this looks good to me.

