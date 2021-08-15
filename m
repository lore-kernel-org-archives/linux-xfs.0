Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DD3C4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A716120E
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhHOPbC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 11:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhHOPbC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 11:31:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D11C061764
        for <linux-xfs@vger.kernel.org>; Sun, 15 Aug 2021 08:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=kY1NkeNhN2PiKgRcdhEUAcGwtw
        aRFUPEp926wHFbZYVvXtSCht7hMH0yVgrnOAZuj/sWDGnJhOfamQkoDR0MS5ZsXlh/I6ecrByvSaG
        sM3HExryWy3NuK8NVDFgzZHC0MB6d+3XtBM+xXddDyvniQvdKTKpRmPuiibCvwLZJdX9jKx0dovyx
        rKWeCvMQNw8wLmrJTODQE0szpzpUapKqHm2Iie9XobhEOgYZzFmzvRRQ14eBNZDSxKEde5m6/Cn/C
        MbvvRexNGlqgGuTrgVxqv5SwGfSlJ8TQuXSOYQ+WWlBMM9SZMeD2sgMGnqjFAnDznweToaqrE/vTl
        d+3zI4Tg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFI5X-000Nvc-A3; Sun, 15 Aug 2021 15:30:20 +0000
Date:   Sun, 15 Aug 2021 16:30:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: make the start pointer passed to btree
 alloc_block functions const
Message-ID: <YRkzB4QAjZCBdOtc@infradead.org>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
 <162881112756.1695493.5877305257052136774.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162881112756.1695493.5877305257052136774.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
