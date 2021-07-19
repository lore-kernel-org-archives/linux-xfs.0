Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB3AC636C9
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 09:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 511146101E
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 09:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbhGSI24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 04:28:56 -0400
Received: from casper.infradead.org ([90.155.50.34]:45340 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbhGSI2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jul 2021 04:28:55 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jul 2021 04:26:50 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cc8WxTp9u8HYpKx7zXqvjDzDZErsRxFk/MMnyKkMLQg=; b=A9Xm6YNlWN+nzI/dpgXm0abe3A
        luJ1k4KEHp2gDhChrg4AiKI+M2OZ0q+Ux0kqutpjRVUORh32sJIEUA+Arf7sYFFaUVusZPNRER6MD
        CIUar6CD9U4dE5V1h8tVC37BNxgzxwnM/1BgOaC7jyW6/R0TZUEFnMOI14yYCIXgRb5qxTiR/Ynmz
        m+2Elq52B126zZr+Kcytn4Xq7rRrlOSxTV9yGflhkk80X3rJV9CFp961ly+zL1kf8P0jwmQ0nyT8L
        hyQSQLKZuF5VKo7Ixfq8omp22OV4030nCh9yUdu2buSXncSp7cIZh+LLeDgFHGRAo0wIZPqXZggjM
        xKgjAg0Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5Oo1-006f6U-0s; Mon, 19 Jul 2021 08:39:22 +0000
Date:   Mon, 19 Jul 2021 09:39:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
        linux-erofs@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH] iomap: Add missing flush_dcache_page
Message-ID: <YPU6NVlfIh4PfbPl@infradead.org>
References: <20210716150032.1089982-1-willy@infradead.org>
 <YPGf8o7vo6/9iTE5@infradead.org>
 <YPHBqlLJQKQgRHqH@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPHBqlLJQKQgRHqH@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 16, 2021 at 06:28:10PM +0100, Matthew Wilcox wrote:
> > >  	memcpy(addr, iomap->inline_data, size);
> > >  	memset(addr + size, 0, PAGE_SIZE - size);
> > >  	kunmap_atomic(addr);
> > > +	flush_dcache_page(page);
> > 
> > .. and all writes into a kmap also need such a flush, so this needs to
> > move a line up.  My plan was to add a memcpy_to_page_and_pad helper
> > ala memcpy_to_page to get various file systems and drivers out of the
> > business of cache flushing as much as we can.
> 
> hm?  It's absolutely allowed to flush the page after calling kunmap.
> Look at zero_user_segments(), for example.

Documentation/core-api/cachetlb.rst states that any user page obtained
using kmap needs a flush_kernel_dcache_page after modification.
flush_dcache_page is a strict superset of flush_kernel_dcache_page.
That beeing said flushing after kmap updates is a complete mess.
arm as probably the poster child for dcache challenged plus highmem
architectures always flushed caches from kunmap and, and arc has
a flush_dcache_page that doesn't work at all on a highmem page that
is not kmapped (where kmap_atomic and kmap_local_page don't count as
kmapped as they don't set page->virtual).
