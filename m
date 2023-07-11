Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E40EB64DD
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 06:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjGKGaM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 02:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjGKGaL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 02:30:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D27B8;
        Mon, 10 Jul 2023 23:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lFP3rgOn7NEch88O0k+vopVx4m1GtYy2wPvp9EA4ohQ=; b=KCsRglCO7mfF0p0Zodj13YJDZD
        mD70/L31nV6SkP4KvBm6DWdm0dxZFeQ8QG3m1BzEaQe15K3mmR3KKu29BQ6caM2SMkWXCCGErGG2p
        uY8mjAIrd7vbIsOUgMxBayIOz1XQ1XpvpYd341RFSBU6uJ3fItwGQV3cncoCpcJOHfku3BEz9hnj4
        3ukESNww+mUwdBJMV3nha4Lz+r0osuGM6XoQ21cA4yAN4puN6NOE8HoNS7SkhpccAE5cDPm3zBVho
        sdz6nJ6BgBHtoMQGfjpAXUHgeH1WBez5wC8WJEjI4XzMRhlYrgODqi+kwtcTPWjHZQIWz902aNQTV
        f534Ri5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qJ6sx-00Dsk8-2D;
        Tue, 11 Jul 2023 06:30:07 +0000
Date:   Mon, 10 Jul 2023 23:30:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH v4 1/9] iov_iter: Handle compound highmem pages in
 copy_page_from_iter_atomic()
Message-ID: <ZKz27+roXRiVyUjH@infradead.org>
References: <20230710130253.3484695-1-willy@infradead.org>
 <20230710130253.3484695-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710130253.3484695-2-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 10, 2023 at 02:02:45PM +0100, Matthew Wilcox (Oracle) wrote:
> +size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
> +		size_t bytes, struct iov_iter *i)
>  {
> -	char *kaddr = kmap_atomic(page), *p = kaddr + offset;
> -	if (!page_copy_sane(page, offset, bytes)) {
> -		kunmap_atomic(kaddr);
> +	size_t n, copied = 0;
> +
> +	if (!page_copy_sane(page, offset, bytes))
>  		return 0;
> -	}
> -	if (WARN_ON_ONCE(!i->data_source)) {
> -		kunmap_atomic(kaddr);
> +	if (WARN_ON_ONCE(!i->data_source))
>  		return 0;
> -	iterate_and_advance(i, bytes, base, len, off,
> -		copyin(p + off, base, len),
> -		memcpy_from_iter(i, p + off, base, len)
> -	)
> -	kunmap_atomic(kaddr);

I have to agree with Luis that just moving the odd early kmap in
the existing code is probably worth it's own patch just to keep
the thing readable.  I'm not going to ask for a resend just because
of that, but if we need a respin it would be nice to split it out.

> +
> +	do {
> +		char *p;
> +
> +		n = bytes - copied;
> +		if (PageHighMem(page)) {
> +			page += offset / PAGE_SIZE;
> +			offset %= PAGE_SIZE;
> +			n = min_t(size_t, n, PAGE_SIZE - offset);
> +		}
> +
> +		p = kmap_atomic(page) + offset;
> +		iterate_and_advance(i, n, base, len, off,
> +			copyin(p + off, base, len),
> +			memcpy_from_iter(i, p + off, base, len)
> +		)
> +		kunmap_atomic(p);
> +		copied += n;
> +		offset += n;
> +	} while (PageHighMem(page) && copied != bytes && n > 0);

This first read a little odd to me, but doing arithmetics on the page
should never move it from highmem to non-highmem so I think it's fine.
Would be a lot more readable if it was passed a folio, but I guess we
can do that later.

Otherwise looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
