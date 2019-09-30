Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025E1C4360C
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C97DD21855
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lakjuqFo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfI3HzH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:55:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42268 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbfI3HzH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=J8ZpJ7IEUIssWYiGn4JUZV8YSFiAwMHHgkpgEGYWdV8=; b=lakjuqFoYcKklFuFpSrE2DGrA
        ErlmOojN49D1dxsYhjAr1F9JLYeB3ibsH5CnIvsj2kihYL/GH0UxUrTbaSthYq5XcfPJQrVTMyNC5
        oiH4kZaBLCYRqUx7QKDRJLf6wklUqo4TUR0C0BEPJVYz3ZyeKCxE82BbLepqinljpUzolR6BJtQPv
        8ECRXcfsfdGzfu0dm6tvipbeIIJrLYx8QqftLRfsPOBuRHRufSXW6dffGWO7nrHeG6kHHDKSbZjb9
        dDOCQni0tajmD0tsaGViG/USBgz5WcEsfhg9sqLAUnijvydAB8mM9cjLqNWb3NVgX7vUWfG3AsNsp
        m+QrPdCJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqWQ-0003JP-8v; Mon, 30 Sep 2019 07:55:06 +0000
Date:   Mon, 30 Sep 2019 00:55:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] libfrog: convert workqueue.c functions to negative
 error codes
Message-ID: <20190930075506.GI27886@infradead.org>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
 <156944764443.302827.9383849728654952037.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944764443.302827.9383849728654952037.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
