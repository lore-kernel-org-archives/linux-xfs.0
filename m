Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74BAC4320E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 08:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A948C61075
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 08:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241529AbhIAIse (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 04:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbhIAIse (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 04:48:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B01AC061575;
        Wed,  1 Sep 2021 01:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vOmYmL0IYXCX/CzK7dAz/EVhy7Dv/PrPlF/2A7i/Pag=; b=HALF1xOrBxm1k6tPiAKxoe/KYA
        q6Eb79h9pjAEsoUb1GKkpaU+/0xS/q+KXSpgsUpAZjy2TqdlgFYKG08877T648miIeafMfxHZWWJO
        2VAUncjLOINxd/McXnCzvuQ1DLA5aBwmuN+KbQF99TbTAaL++F1+zTDNg09QVBwDgDeMmMJVT073E
        /3YZ468jeR2ns7B4LKaxmMpsA/ANqooGSeG8y/jMHghCZT8MUoTRMT+3dc7yyvTktJtyIynzdiNxO
        a1JNCrv6rx/mxspqxgPjehvulU6aV2925nFCslz4M2vsGS+Vepv10cSiluuVw6GFymMPGcluE6fBy
        AiImkJ/A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLLt5-0023dE-HH; Wed, 01 Sep 2021 08:46:41 +0000
Date:   Wed, 1 Sep 2021 09:46:27 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/5] xfs: move reflink tests into the clone group
Message-ID: <YS894/ZHkQz6f8RK@infradead.org>
References: <163045514980.771564.6282165259140399788.stgit@magnolia>
 <163045516076.771564.422157391342318386.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045516076.771564.422157391342318386.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 05:12:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> "clone" is the group for tests that exercise FICLONERANGE, so move these
> tests.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
