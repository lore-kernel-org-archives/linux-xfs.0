Return-Path: <SRS0=2Dxs=CH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CAAC433E7
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Aug 2020 14:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7325820791
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Aug 2020 14:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L4h7n0OB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgH2Oyb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 10:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbgH2Oya (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Aug 2020 10:54:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE33C061236;
        Sat, 29 Aug 2020 07:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=syK03Q4xXEA+proHGQgPtI7XNxH7nklSo+/fI2tk1Lg=; b=L4h7n0OBMl1O11DSPJ1oqOBPs+
        P7AjbVhlfitS+eORwFs7L7+y5XHNfj17uhWgRVLDQydbz/Pvs2M89SIM20IzkCdlQiGfHhbabIo0f
        Ewd/PWS3YnToUrCZ/yX17vN1hiblN8YVFw6cES3zgKhWxtxOyaKtT4YCQ/jy+EqLZlzSUz74xbs9Q
        5Q8CP+A5IJIx7uB8d/5c3uHEuSYgHSqsnn4+52xv4+OZS67L/hZmoOl+u8WxFPDpdmB2EnMnQAe7y
        MQ+GjMGbE1g5zPlbrlg8vmbB3EWL4FOSIp+Tmg6TPgC+eXesdeCRqTbYRDOPQEs+x5mxesAxavLuI
        y9j8ycFg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kC2FJ-0003Nh-7c; Sat, 29 Aug 2020 14:54:21 +0000
Date:   Sat, 29 Aug 2020 15:54:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] mm/gup: introduce pin_user_page()
Message-ID: <20200829145421.GA12470@infradead.org>
References: <20200829080853.20337-1-jhubbard@nvidia.com>
 <20200829080853.20337-2-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829080853.20337-2-jhubbard@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 29, 2020 at 01:08:51AM -0700, John Hubbard wrote:
> pin_user_page() is the FOLL_PIN equivalent of get_page().
> 
> This was always a missing piece of the pin/unpin API calls (early
> reviewers of pin_user_pages() asked about it, in fact), but until now,
> it just wasn't needed. Finally though, now that the Direct IO pieces in
> block/bio are about to be converted to use FOLL_PIN, it turns out that
> there are some cases in which get_page() and get_user_pages_fast() were
> both used. Converting those sites requires a drop-in replacement for
> get_page(), which this patch supplies.

I find the name really confusing vs pin_user_pages*, as it suggests as
single version of the same.  It also seems partially wrong, at least
in the direct I/O case as the only thing pinned here is the zero page.

So maybe pin_kernel_page is a better name together with an explanation?
Or just pin_page?
