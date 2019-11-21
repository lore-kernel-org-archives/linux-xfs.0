Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A320C432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 06:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6557D2088F
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 06:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FBjdYX6V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfKUG4s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 01:56:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38926 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKUG4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 01:56:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MPeNAWungv26bQAwYJD7nCaq+Sl1GrBA7DY8FsKxn9M=; b=FBjdYX6V1FG6rFKCsfrm7Lq3s
        TUtSU0xAgmdjmnHN6lpOuTZyt5AuU1RkqA4hpTDc5M7zIQE9eWYV4UlZ/e1xt7BXYCGHl4M8/TV0c
        4E39VUaN3l6ToZ8bz+I/Ini3h5SGmAl6njkWhVw2apbaURgojGhjuqC6gq94R3BF/GJpaQpDM9N3N
        7SZXtL3QLv4Ci/qjJkKfhVpuCU54MbtzBDj8wVU3eDlm7X52kEMLlGjzAHUfNULH0B0MYaXVMsfxA
        LeWx7J4Adc9H8ENDHCr3CAvd7/vY8jsZfLN/J0tuH7dv5F5awLxxHFAg6hIu7xoRnj207y+Fa6bbs
        nHJHqIzeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXgOS-0004Lc-0x; Thu, 21 Nov 2019 06:56:44 +0000
Date:   Wed, 20 Nov 2019 22:56:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
Message-ID: <20191121065644.GA21798@infradead.org>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191104204909.GB4614@dread.disaster.area>
 <dc7456d6-616d-78c5-0ac6-c5ffaf721e41@hisilicon.com>
 <20191105040325.GC4614@dread.disaster.area>
 <675693c2-8600-1cbd-ce50-5696c45c6cd9@hisilicon.com>
 <20191106212041.GF4614@dread.disaster.area>
 <d627883a-850c-1ec4-e057-cf9e9b47c50e@hisilicon.com>
 <20191118081212.GT4614@dread.disaster.area>
 <20191120210825.GB4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120210825.GB4614@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +static void
>  xfs_sb_mod8(
>  	uint8_t			*field,
>  	int8_t			delta)
>  {
>  	int8_t			counter = *field;
>  
> +	if (!delta)
> +		return;
>  	counter += delta;
> +	ASSERT(counter >= 0);
>  	*field = counter;
>  }

I'd almost find it easier to keep the != 0 check in the caller, and
in fact also move the assert there and just kill these helpers, e.g.

	if (tp->t_imaxpct_delta != 0) {
		mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
		ASSERT(mp->m_sb.sb_imax_pct >= 0);
	}
	if (tp->t_rextsize_delta != 0) {
		mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
		ASSERT(mp->m_sb.sb_rextsize >= 0);
	}

While this is 2 more lines per counter it is a lot more explicit and
easier to follow.

>  	if (idelta) {
> -		error = xfs_mod_icount(mp, idelta);
> -		if (error)
> -			goto out_undo_fdblocks;
> +		percpu_counter_add_batch(&mp->m_icount, idelta,
> +					 XFS_ICOUNT_BATCH);
> +		if (idelta < 0)
> +			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
> +							XFS_ICOUNT_BATCH) >= 0)

And here I wonder if keeping single use helpers wouldn't have been a
little nicer.  Not that it really matters.
