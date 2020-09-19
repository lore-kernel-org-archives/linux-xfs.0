Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E35C43463
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 17:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C76CD20795
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 17:10:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ks+ibHR4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgISRKk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 13:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgISRKj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 13:10:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F63C0613CE;
        Sat, 19 Sep 2020 10:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uzQhobiw0AWWw1t4GmnWwUQpgpaiiRTt3spuPQpH7sc=; b=Ks+ibHR4XtS3ijtpefAJ7l5/pS
        HXtJkkMrZalWrWbXnq5iL5ArqW3HU7fQ3Sv/2B2didMy3AKVP2Mkdk52qjYntvbcrGZaYeYCCJKnX
        5HSZLt+SLLxX02L9Wl9+mk6+KHqYgvfsXGsZiksi4NLvspvfYmCRsKFjYVANDTI5qHP2CPA7FnOlN
        Z0j0S55fQiWE3B249Y5SpDUa1pRYwzodbZfelp1JvoEfKPOnIaxPdc9HzIW6NUMi3UWHMCbIQTwsP
        QNG5FDNaVGh/GtydU+NVRzpWEdySEbvcuEDZC71BdIJmvBJTL+q0Q4LQum6ciVpgjbrnz1diVbRkJ
        tMgbf34A==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJgNh-0006cw-VA; Sat, 19 Sep 2020 17:10:38 +0000
Date:   Sat, 19 Sep 2020 18:10:37 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/13] iomap: Make readpage synchronous
Message-ID: <20200919171037.GP32101@casper.infradead.org>
References: <20200917151050.5363-1-willy@infradead.org>
 <20200917225647.26481-1-willy@infradead.org>
 <20200917225647.26481-3-willy@infradead.org>
 <20200919063908.GH13501@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919063908.GH13501@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 19, 2020 at 07:39:08AM +0100, Christoph Hellwig wrote:
> I think just adding the completion and status to struct
> iomap_readpage_ctx would be a lot easier to follow, at the cost
> of bloating the structure a bit for the readahead case.  If we
> are realy concerned about that, the completion could be directly
> on the iomap_readpage stack and we'd pass a pointer.

We could do that.  I was intending to reuse the code for the write_begin
path so that a pathological case where a page straddles multiple extents
can be handled by sending multiple BIOs and waiting on both of them at
the same time, instead of the current way of sending a BIO, waiting for
it to complete, sending a second BIO, waiting for it to complete, ...

I haven't fully got my head around how to do that effectively yet.
The iomap buffered write path assumes that extents are larger than page
size and you're going to get multiple pages per extent, when the situation
could be reversed and we might need to stitch together multiple extents
in order to bring a page Uptodate.  I also don't yet understand why
we read the current contents of a block when we're going to completely
overwrite it with data.

