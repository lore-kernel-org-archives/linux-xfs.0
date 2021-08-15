Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F77C4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 09:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE8AB61056
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 09:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhHOJPg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 05:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbhHOJPg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 05:15:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60E6C061764
        for <linux-xfs@vger.kernel.org>; Sun, 15 Aug 2021 02:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=IlE0nwxiZhc1wSL8Wiv1D0QsCK
        Bj9Y9Jnfuuh5sFp0NG7r2dTVREErVPtt5Qv0gn1Vzfib9s/8id9++MZY0UVE1f65yrqMS4zZL5acS
        3ky9xx3NM2eMjr2tUH1he6KAKcd3DwQ4shjl+4/YQw8Q/Bet8wNKLUc2zT+1jN6uCUln2VsJzzMKd
        +JejNfd4sWitHLsgT90BdYPnwCLRKq82mfNw+IQa2cVQlNOXQ6WGsOL/RCtpyULYimsn+Z5LC+NPq
        cP8MawAgL96BWNhmf8pVZ3KaKEJKQR/ITaR1Nrro80//527qITB0eYHgnxXqyoPu40fsbfbnRPRk5
        HlUIWaew==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFCDJ-00HZxT-5r; Sun, 15 Aug 2021 09:14:16 +0000
Date:   Sun, 15 Aug 2021 10:13:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: make the keys and records passed to btree
 inorder functions const
Message-ID: <YRja0cJFf/RyFO95@infradead.org>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
 <162881111103.1695493.15030145852356555847.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162881111103.1695493.15030145852356555847.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
