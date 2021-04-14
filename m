Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B85BC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DCF3611C9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbhDNGMu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 02:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhDNGMu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:12:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CFBC061574;
        Tue, 13 Apr 2021 23:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=G+Bu/gkyxr7pUGcLh1x5uT17KO
        z0kkRdgdGU17tgKNqJe5r7qnkTJMC4PablhlyzVCdCWr936v4yjmyvmOvmPkeGAxosiGxUv8w892z
        2388ENzhlGeJrTzSMQXdRYVDRX431tFnqnsvX4BWfLGSGs+v4zJ/H9vULM/+cabIsbzEE19gbtSL5
        dGp1RmJJHfQojJh5/8USMdV0Op93kSsn+4DNbCrHlMnPJxXq7Ey2ip/P91tsq4xr4yk/4uYF6JBYp
        7pG8HwMMIfP2mt/7TANHkFQw51atVAs/FyoHd2aFsArNnF5Ill6TibSH2aN/fCq5vipD9DlaWODI8
        W8S8yuzQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYl8-006j5e-Pk; Wed, 14 Apr 2021 06:12:19 +0000
Date:   Wed, 14 Apr 2021 07:12:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/9] xfs/506: fix regression on freshly quotachecked
 filesystem
Message-ID: <20210414061218.GC1602505@infradead.org>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836227616.2754991.13243990456152675669.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836227616.2754991.13243990456152675669.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
