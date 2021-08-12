Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74063C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 07:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 542D260FC4
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 07:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbhHLHy1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbhHLHy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 03:54:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7170FC061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 00:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Nm4PUPMJ83DtiFcob3F6pujq6N
        IZTlMHYyVZg7J698Z1ukGOtqSRNeKr1PkT/lwAgvPFhN+/rlP+zhcLe9sSqTJ3E7pqhG1pR0TbJnw
        2Q/9tEDBo37H9xenE4vJHHWLUKELgXBZxM9bEH0FGL1J2LRj17Ifn2KuqHfNgq/RkCBaAbD9HMmTL
        oiqavbBp5qJo3Zdu6bhXCYW0gUT5HZ/xg6wkwLxHsDvsxguGBUJJROxe4fYcXvkt1B/bICyqOUMEM
        4hKC8Boi3H25Cy0r5ITPHjLLwGTpj2uCPPAq+SCHSz98qk1drBfUPjZlGjlD+DY7GxSMzMBJqa6MK
        F51/kmgQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE5WJ-00EJ83-0n; Thu, 12 Aug 2021 07:53:17 +0000
Date:   Thu, 12 Aug 2021 08:52:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: sb verifier doesn't handle uncached sb buffer
Message-ID: <YRTTV9htV83Kb+EL@infradead.org>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052451.41578-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
