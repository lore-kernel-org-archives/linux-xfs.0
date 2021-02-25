Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A96C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 18:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB3C564F27
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 18:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhBYSfO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbhBYSdj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 13:33:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE6BC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 10:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EFoM/6Fkbvmddf+mJK+8ECtiyOZ63sHphu467UaAoFw=; b=eBcnzk/9OUWPCSvsbYRqOAT5iq
        dIqskpq3k5tIw564kyYi4L3C9PDqSfXzINXTlv+Q52FTMIqvwy19AAJ6+/BMdWa7OeWx1TVrJrNZ2
        ULN8FJBP0DxaJdDleOL9ZK2o5jdGs4Jg8jiok2LRL8nun998CZVHNyUqyS7eS0B1dZxSeBfE1jrnt
        CMUp0poOqyAyW204c3pC7RoDX6B/X2KaFBUEnes2O0BDMUcjY79frVpchCRWwaJ32TU9CrOI3tfP7
        IkeAU8qReouOu87c0v7DXKB0twJxWfybWNeyXPTQ2O0A32qLIk6VxN9ie2YNHL5KxLLa4qkqIh8w9
        TB5V2Dsg==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFLRf-00B1nD-Gd; Thu, 25 Feb 2021 18:33:09 +0000
Date:   Thu, 25 Feb 2021 19:30:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: pass lv chain length and size into
 xlog_write()
Message-ID: <YDfs3YKePQNjd12j@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The patch itself only passes a single total length argument, so
the subject and the commit message seem a little strange.

The change itself looks fine to me, though.
