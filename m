Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC082C43464
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 06:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57A1B21D42
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 06:39:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tUF20LCB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgISGjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 02:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgISGjK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 02:39:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEE0C0613CE;
        Fri, 18 Sep 2020 23:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N06vUgFDFMKJDgeybDJWkd+8W/Yn9aSVJk22hKSqvXw=; b=tUF20LCBBRMnhduZpJr46MxoeX
        jqrqsA6DTLHR7HszuS+HfgC6SR3MJ7yxisuw/ur+PdBGZ45jLVUD91dXZjumb6FC+GuS/x5UWEmbQ
        AJpC8LROLmDqd5mR7oOO45vGlzdWwaUVfYqiDH1QI7yHP9aKyQhKJ+mulV/mmzR+L7fcCQjBtxoo4
        rhCQGVqIRyVYa1NC3mIREmCLxaWAp86XNZIG54x0oxKsukzZl1bkwrpeGaJOJqdDygF/q5rJ/gHEz
        989hYOZ1XApbh7U6vu785/uEmEARHqw1+QuhbNaVI9AH1Zawc6w8UFBZ2LuBRIFUbIpCCnEPIaSEP
        1XlbiAQA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJWWa-0004DT-Ja; Sat, 19 Sep 2020 06:39:08 +0000
Date:   Sat, 19 Sep 2020 07:39:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/13] iomap: Make readpage synchronous
Message-ID: <20200919063908.GH13501@infradead.org>
References: <20200917151050.5363-1-willy@infradead.org>
 <20200917225647.26481-1-willy@infradead.org>
 <20200917225647.26481-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917225647.26481-3-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I think just adding the completion and status to struct
iomap_readpage_ctx would be a lot easier to follow, at the cost
of bloating the structure a bit for the readahead case.  If we
are realy concerned about that, the completion could be directly
on the iomap_readpage stack and we'd pass a pointer.
