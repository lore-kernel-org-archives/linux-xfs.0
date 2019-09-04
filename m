Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012CCC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC78820820
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JG5v0fxy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725267AbfIDFG2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 01:06:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfIDFG2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 01:06:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8zBiEjRQ/qm8RPivRRpE2uecnkHuPremrH3SM4ygQfA=; b=JG5v0fxyjHRAghsibb85OSwDi
        D5KUJcIc6tu2/vh3EmnUZuwSlFU2ifKvTwRvKeQPD5oFwM5el+IKdBlInABFR/nTxT7aJy3OdtTsO
        2xex60s0OQrok4eyxzRgbArtwY0OxKtImW9SertKke/PPJdYXNPo/w+u0w3TaRtuRahiIt2exjRzp
        2yKQt8Fvm4/oZfE0OzwfNSMxIucClyCHKNfU/5dXmoRh2p1IDg/HS9Qx9bh/5DywySHFglNNXxrGV
        coqym1rQpj3WgaJ+HUZReCjSVsA33/hSdO2A1za8/Q1mNdGO9DLtatbZXSoCzRbjF3FXubNTJ6gXP
        0n1RcMKyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5NUx-0001yH-PB; Wed, 04 Sep 2019 05:06:27 +0000
Date:   Tue, 3 Sep 2019 22:06:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 1baa2800e62d
Message-ID: <20190904050627.GA2569@infradead.org>
References: <20190831193917.GA568270@magnolia>
 <20190901073311.GA13954@infradead.org>
 <20190903234023.GJ568270@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903234023.GJ568270@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 04:40:24PM -0700, Darrick J. Wong wrote:
> /me shrugs -- it's been broken for years, apparently, and we've been
> arguing with almost no action for months.  Developers who are building
> things off of 5.3 should probably just add the patch (or turn off slub
> debugging)....

Well, this is a new breakage with the same old root cause.  The root
cause is that slub with debugging enabled gives us unaligned memory.

But with my log recovery changes we may now use slub for allocations
larger than a single page (before we only used it for smaller than
page sizes allocations in the buffer cache), and that newly trips
up in the pmem driver (and a few others).

> 
> --D
---end quoted text---
