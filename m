Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DD3C3F2CD
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 556C22074D
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CGgK+Y6j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgCWNzA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:55:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42310 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbgCWNzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 09:55:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+IPEuQxAJlWeSJk7MI1TKodD51fkSrsNex2SKZ9lECs=; b=CGgK+Y6jK6kdhuMF6PumrSRrwx
        Zox+FHdubYJuUv9nr0C7Qj0ZgyMfVH6hzspwi1drhxU40+dQwmzyjstGKNgm1NWlQk3qruQbzvety
        RCd9Iz77j21XuRwwduM3n3DQw28hsJOCYgi+i9K6ASnK00GRZCiPmCff2E4mzYCP0RmckAunFH7ba
        FBUceit7HYkIYnxM7Ty9lit8t04LuQGfmgOfdXD8sff9gmWlRdDUyn66hfTzqQJgTsW5n7XpIpazh
        lSaB+ueXz4gNOf2RVEViBZpyFo474BvO2MzOyhpGXzjIFg/YHWbfW0d++/bgrkkpeQ3pgCwwYLpA1
        kCNBIDbA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGNXg-0004ks-Bm; Mon, 23 Mar 2020 13:55:00 +0000
Date:   Mon, 23 Mar 2020 06:55:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: Do not use GFP_NORETRY to allocate BIOs
Message-ID: <20200323135500.GA14335@infradead.org>
References: <20200323131244.29435-1-willy@infradead.org>
 <20200323132052.GA7683@infradead.org>
 <20200323134032.GH4971@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323134032.GH4971@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 23, 2020 at 06:40:32AM -0700, Matthew Wilcox wrote:
> Oh, I see that now.  It uses readahead_gfp_mask(), and I was grepping for
> GFP_NORETRY so I didn't spot it.  It falls back to block_read_full_page()
> which we can't do.  That will allocate smaller BIOs, so there's an argument
> that we should do the same.  How about this:

That looks silly to me.  This just means we'll keep iterating over
small bios for readahead..  Either we just ignore the different gfp
mask, or we need to go all the way and handle errors, although that
doesn't really look nice.
