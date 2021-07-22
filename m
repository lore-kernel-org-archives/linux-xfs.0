Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5043C6377D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AED0B61279
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhGVGfj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhGVGfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:35:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8605C061575
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jul 2021 00:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=d8g1zlNTx0MJf6u8rH2yxJXkdF
        MOWjzFpD7J+SpwA35RTWLqoO9dcmUlHfCdb1EGQsCZcTNqFWA8+5uZnfVk5M+I6CUw1cO4N8CL9WI
        Tn6TXX4BUYOM9XjcxCNuf5IZ/MwTAEuXnDiF04PpHXgscn43j9TDIgZoFFcmyAaaI/X28msY21Zmu
        pKXVAytwMZqa5OYh8vNOUfpHQgYKiCxUvpQf+Nu9U7WdcdOSUbatvNsq2SJ9VbJHimKFEaBTw34HV
        EHXq8ogfSuFterje3EtsbA0bRJyCC1R23NoSFTsjk8Nj23EnzrwLWC127KrP+7oEWnh9UcGjp5B/t
        aCwkil/g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6Sw2-009zLa-Q2; Thu, 22 Jul 2021 07:16:04 +0000
Date:   Thu, 22 Jul 2021 08:15:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: avoid unnecessary waits in xfs_log_force_lsn()
Message-ID: <YPkbLncYt4Gld7hf@infradead.org>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722015335.3063274-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
