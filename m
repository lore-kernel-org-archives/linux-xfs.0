Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F78C43381
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FFE464DA1
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhBIJYD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhBIJU2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:20:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8389C06178B
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JICusPuiJELB6kW0aLAeGHw2BxiQRpcIc3oLGA0/Zss=; b=COy9sbZ3phFumsbjsPz0CXnMfp
        0rRLboMfICtMfOLeGKWI/o+b+M5hoCxbDWrkZVPCYpwYSHQSLyTb39ppS9gyfPTlF3gGoYS2EeNL5
        1jAEQKoD552SYZJQXjwRU+uIKPSCiKEP+Mf7qxq7UaA0tQzj36g7eh7oFaDkowh+t7nKAh18mHJiM
        VXGQV84ENAIJQFlMnLLS6wYoYcV40VNLm5UIveZtRm9GxydybVHBDk8S0bKaZSsrNvv2lwwx7Lf20
        xUmxWKnrTS/XiTYhFwTGPCnu8utha9IekbTtTp9ppShWNERSYgBkFmf95qsscR9xTDhPilnp+39p8
        lNhpBZWg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9PBI-007Dqd-T3; Tue, 09 Feb 2021 09:19:40 +0000
Date:   Tue, 9 Feb 2021 09:19:36 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Chandan Babu R <chandanrlinux@gmail.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] misc: fix valgrind complaints
Message-ID: <20210209091936.GM1718132@infradead.org>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
 <161284388183.3058224.7213452888406393105.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284388183.3058224.7213452888406393105.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We could also use the "= {}" method for hbuf, but otherwise this looks
good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
