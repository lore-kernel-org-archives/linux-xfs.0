Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A077C07E98
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 08:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 479AE613C9
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 08:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhGEIqX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 04:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbhGEIqW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 04:46:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0294C061574
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jul 2021 01:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cVX0sdbHpwfZRXACXmkYDo6l2bVR4slZFABCpdNnteE=; b=S8kjujJJlPhbAfBjPQu0Si4D2E
        ytEcEyGsdQocKDCJhdGJsayEKKSRzdpT3HqTvIF2YlfXWaG9WTBYK/BEX5GYifqW2cOSsdQemBdCh
        uXLMFIfEfRxKKWRXsgv0B3XxJ9pRj20e+54RKicyD88xkni1NqFfA4yyRsef21tCT/kez8pOJvY/y
        DaiSaBHh2WOCn5xN9+yxR/vYNdqVArrqGM1gekbN6p1QGaTbyNSk4AXAQxCmRfcMFSE+q1JQ4sGhL
        gL2Z/6KvVxT7M2OOzNZFZs0aHOzCbdeK3Usa0VYw3aEoyL95+IJpPnqNpLyiYIjxQE321ST/aQVNn
        S91sjE7w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0KCG-00A3NL-NJ; Mon, 05 Jul 2021 08:43:29 +0000
Date:   Mon, 5 Jul 2021 09:43:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix warnings in compat_ioctl code
Message-ID: <YOLGKMyrVNMmGX7g@infradead.org>
References: <20210703030120.GB24788@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703030120.GB24788@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 08:01:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix some compiler warnings about unused variables.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

The change looks silly but otherwise ok.  What compiler gives these
stupid warnings?
