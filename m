Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14006C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiF2HfS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbiF2HfR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:35:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1396F35A9D
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5SOCTEmNfikyH9O7KvfZOuXNwHdHFawqueq3Scctw4U=; b=cCJiOphFsu65iEtwy8isM5VDGp
        VutwJigKYx/LCTJdiwWw2HuUV328ysAarpW4MalvLHc2rAww3sc85PdHenE/uStVOLo8aClUD+RUY
        2yakWATTcm5uFsYFrnyx3Ys//IAuKh4tuEch3487kKKCXDqaKt+lSAkxTvKCNUA4RJLznWCL3ojIK
        tqMWBleEH83D1JxZIseJSS+Vp2+qRQGeqKD9G6wCL2JQUuDGtIc1qXtdMUCkK/aAZjwFWkOsmLdgc
        Rk/2sfT7LeVoRGtyF4HqOsHW7ci0hZiEr1f9kc9JT/Ad6OjC9ByAFf1KOsQ0LFZUEgjoOm3UX1oOj
        LQSyTAWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6SEG-00A83n-LD; Wed, 29 Jun 2022 07:35:16 +0000
Date:   Wed, 29 Jun 2022 00:35:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: break up xfs_buf_find() into individual pieces
Message-ID: <YrwAtNZ+PQ5qVDdN@infradead.org>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627060841.244226-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +static inline struct xfs_buf *
> +xfs_buf_find_fast(

I'd probably name this xfs_buf_lookup as the _fast suffix is a little
weird.

> +/*
> + * Insert the new_bp into the hash table. This consumes the perag reference
> + * taken for the lookup.
> + */
> +static int
> +xfs_buf_find_insert(
> +	struct xfs_buftarg	*btp,
> +	struct xfs_perag	*pag,
> +	struct xfs_buf		*new_bp)
> +{
>  	/* No match found */
>  	if (!new_bp) {
>  		xfs_perag_put(pag);
> +		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
>  		return -ENOENT;
>  	}

Having this condition here vs in the caller seems a bit odd, but
I'll see what the rest of the series brings.
