Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F143AC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4BDF64F06
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbhBYILo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbhBYILn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:11:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C11C061786
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=gb3ympcED/TWvZZiv++irKehB3
        M5lVw1C8htSpMDrDMt9xUAYejxN3yV/UTZtSPtNSZI8odrwHJY8M8va9Z48vqQS/CjeOmyVzTT5sw
        IiY2sW+3lWTk+SGltqfl58h8SnkXKnUiZ0kORZNIpoJdrcCnSxCBwPFgQoILKjK6iNI0jFgWFHB+L
        4UwibMHNs01LO77O8hYl1aYDUGxo47i9hSZXljL1TH5JiA3pDFsWo7vMo+eH5bad006GKVlru6p3i
        v18JDsI3wWMqD17yHkNvEWFQ89Rq4ZCWPxLkMw0tD87/coxvBEliFhIHhYrYcjdmlbM6NzqZ6d9lT
        y7f+3qMA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBjJ-00ARx3-QR; Thu, 25 Feb 2021 08:10:42 +0000
Date:   Thu, 25 Feb 2021 08:10:37 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: use current->journal_info for detecting
 transaction recursion
Message-ID: <20210225081037.GI2483198@infradead.org>
References: <20210222233107.3233795-1-david@fromorbit.com>
 <20210223021557.GF7272@magnolia>
 <20210223032837.GS4662@dread.disaster.area>
 <20210223045105.GH7272@magnolia>
 <20210223055326.GU4662@dread.disaster.area>
 <20210223060840.GV4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223060840.GV4662@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
