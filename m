Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD71C2D0A7
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 16:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 871502087C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 16:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jtteioPS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731648AbgIHQ4U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 12:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731896AbgIHQWx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 12:22:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB910C09B046
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N3QgkPgqHsWmO7HM4ruCbCvu8lIjCz58DRGd5JW/7nc=; b=jtteioPS7aOFuglI6V+aXpefyf
        DCABCPQqtxigOwSpUtUg1pwu+j6QoxjsJ7WLNkzhy3kpye+D1e99r7GfRvwFpI+hUKTmOX2myPGxv
        0tjGFR2FeOvvk0PWm13+jV86ShQMpVBpdppAUWlk/CR+VxjoJym13Jt9IKFMundPsOijYqOtkcrsQ
        3lDG30SgtUUBU62fy0U8BuHXuMm7BiFYcHB3dLv6gdd3CwLsZbjQcwgO3JFlccgj30KBlyzbfVJq2
        CEDSu6LT+eza11HEu5f9iV9mVuAfd8lradRLp0mlWRBDa3WY+L1HQ3Yjq8angFLoauppQSiElN6gu
        h0tXQE9g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFenZ-0002FB-0b; Tue, 08 Sep 2020 14:40:41 +0000
Date:   Tue, 8 Sep 2020 15:40:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: set required parts of the realtime geometry
 before computing log geometry
Message-ID: <20200908144040.GE6039@infradead.org>
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
 <159950111530.567664.7302518339658104292.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950111530.567664.7302518339658104292.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:51:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The minimum log size depends on the transaction reservation sizes, which
> in turn depend on the realtime device geometry.  Therefore, we need to
> set up some of the rt geometry before we can compute the real minimum
> log size.
> 
> This fixes a problem where mkfs, given a small data device and a
> realtime volume, formats a filesystem with a log that is too small to
> pass the mount time log size checks.

Do we have a test for that?

Othewise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
