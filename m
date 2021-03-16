Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A555C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 08:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CDA964FFC
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 08:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbhCPIkq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbhCPIkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 04:40:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAEEC06174A
        for <linux-xfs@vger.kernel.org>; Tue, 16 Mar 2021 01:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/fkjGi1pghR2wxtZ0OC5+xpxHiXyt/i0Vc9pPSOulS4=; b=u3vBuxg8KbO8KsdX62oG97Cu9W
        afjj0CCt8nkGRDaKhRM4Wz8d88A/n5qQQ5TdfP0DybW3RFMwCMSUdS0y7DLZz8lombtibrglQs9pR
        2WHIXjH8mI6fdEUKW9OKBGENSz4gR359816jEnZwS5lNpYvVwNwZUfs79efHML0/FShk/Sn1Q+Jk6
        reCH2CZYeV/YF5RLuJV+ZCqybZi57/X9m8YNvGG0z/suX6SVWPQVqkewL7TIOMx+UGdS00/GNlZ4e
        hUm+6lKZz7l3F0/tlcXJVleG4afSJvwoRa/syAtQNR7CjikI9X7YISOVilkXqChcASj7eqjwmrhsP
        jxVAyQNg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lM5Fc-001fww-LB; Tue, 16 Mar 2021 08:40:31 +0000
Date:   Tue, 16 Mar 2021 08:40:28 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/45] xfs: separate CIL commit record IO
Message-ID: <20210316084028.GB398013@infradead.org>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'm still worried that we add a pessimisation for devices that do not
require cache flushes here, and even more so that this tradeoff isn't
even documented in the commit log.

The actual code change using xlog_wait_on_iclog and the intent for
devices with a write cache looks fine to me.
