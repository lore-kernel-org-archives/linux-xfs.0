Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BACC4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 09:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ED5F61038
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 09:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbhHOJIH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 05:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhHOJIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 05:08:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4569AC061764
        for <linux-xfs@vger.kernel.org>; Sun, 15 Aug 2021 02:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=jKN/cjsoJiw6+er38Ut9fIhopA
        GtTd2wRMayGYbTkoAq2UNcvxWgJaPe/CS8D9/+pvPrkJDkvel8qQso3iyKnAyaN7j3E/M1MHA+l7i
        7MB254Qu1lKjim4ytoHL9M623wCzmZnJlwvbQhLG11UQc3XGyaDBbePJdJ8AK9ziyk+I32rjrH4tE
        Evl4N+LElJ4m34PTiUtAoaUGxSoZfSXKBsQTT+W9UoLVUR2BamJ2+HEYCXq03fZ7eOQKRRjw3xjky
        joiQGnXr4qjB7OBOvBGfBQgV52tVqAM47/jGNlrfKT9YO18yv6lcwVyMb5lH+8HQzvsfZW6USk0rb
        yogBvjFQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFC68-00HZha-8h; Sun, 15 Aug 2021 09:07:03 +0000
Date:   Sun, 15 Aug 2021 10:06:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: make the record pointer passed to query_range
 functions const
Message-ID: <YRjZFNnS6cjk43q1@infradead.org>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
 <162881109994.1695493.15186624863084945329.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162881109994.1695493.15186624863084945329.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
