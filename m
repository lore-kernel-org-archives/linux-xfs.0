Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F03FC43460
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41CC4613DF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhEUIUM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 04:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhEUIUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 May 2021 04:20:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54668C061763
        for <linux-xfs@vger.kernel.org>; Fri, 21 May 2021 01:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1S/Es08u2heJ+sYyWE9oG28BMtlaUhys/rQf1hfv1Xo=; b=DjFzQlWz01jVw0JHO88M9XcZ+S
        vOy8k9WwZsdhBQ9BqRWbv86boaLAvCjDsii/zsc0dhz2fTfBNqkiv8zhdMfk9NEM0CC7hhQSoBN1D
        KarSvPg+o7Jgy7a+w6MtTKVZekUPRHRGG1TWOb1wWuwgPzvlj8hOZ7RQklE3iKHed6OKb+zWkm5fc
        U+K6Fgw/57bDM5IZcpx5OoMo/Fj79t/KPEVA5HeCDQyEdFBjmO8ja01oNgUWlCcyJ1h5f7KWB4j9N
        xHh0ikdF9YS8zXVxCbvk/G/2vvIS34FofN1HEzMTSNTlFjdqkb/IKbW7Te6X0J7l2wo7XjCG47K7Q
        28nNvkQg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lk0Je-00Gm3V-88; Fri, 21 May 2021 08:15:44 +0000
Date:   Fri, 21 May 2021 09:15:30 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use alloc_pages_bulk_array() for buffers
Message-ID: <YKdsIEEoOpHjgY46@infradead.org>
References: <20210519010733.449999-1-david@fromorbit.com>
 <20210520234237.GC9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520234237.GC9675@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 20, 2021 at 04:42:37PM -0700, Darrick J. Wong wrote:
> > @@ -292,8 +292,8 @@ _xfs_buf_get_pages(
> >  			if (bp->b_pages == NULL)
> >  				return -ENOMEM;
> >  		}
> > -		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
> >  	}
> > +	memset(bp->b_pages, 0, sizeof(struct page *) * bp->b_page_count);
> 
> Could this kmem_alloc be converted to kmem_zalloc?

Yes.

> And isn't the xfs_buf allocated with zalloc, which means we don't need
> to zero b_page_array itself?

Yes.

> Confused about why this is needed.

My series cleans up all this mess and the rebases the allocation change
from Dave on top.  Maybe that is a better start :)

