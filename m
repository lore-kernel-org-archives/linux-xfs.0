Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DACEC00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64E13205F4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:12:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rOWDjM6z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgAHIMY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:12:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgAHIMX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 03:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=rOWDjM6z8p7qLK+2qtEeoTlsU
        sccIGLqA1ggwigHpLcwEzmcpVfm/zJ752NqywA7WGcfxrF1CGDkSSBI11Q7zwk6XG26tN8B+g78Ei
        0QOKgk9M6s0oKfoJ458TjUhoxXaNuhFgB/XWKt8kXie3NhUychRQ5ZHfsMLYl4FEBUtfdLwZn1Rpb
        7MH8vnTBnr4XDlWse1tURT8CVEW9rTklKhyCOS/FuGlr5X6gC99q2NJ1qxCGqJ5FyVkCO7yX38VYp
        eq27q7C5nLy4TCJ/aMKKaowb54MMf0uzgCkKMzJvABNMXYTPR17g/DB63N5y1tklFxF1eT0oaZBX7
        jt2mj46Jg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip6Rz-0008EU-9h; Wed, 08 Jan 2020 08:12:23 +0000
Date:   Wed, 8 Jan 2020 00:12:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: fix s_maxbytes computation on 32-bit kernels
Message-ID: <20200108081223.GC25201@infradead.org>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
 <157845707130.82882.12708231277663860217.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157845707130.82882.12708231277663860217.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
