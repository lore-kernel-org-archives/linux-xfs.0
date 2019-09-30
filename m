Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C57C4360C
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8B5621855
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:54:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ltVgm0Sa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbfI3Hyn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:54:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42222 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbfI3Hym (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7YFhnj1QsxzgSf6xHBD6Y13RfAD4nmYgJ8W0IqVQS24=; b=ltVgm0Sa33GsWaCIYI5ljHXuN
        7V0cLm0EGYZh59M3zp4SkTdiCfNaH1A4u1KY4uM7Aq4jvhqpI3QRlsbgC78brtiHoGNuuoeCM/L3V
        WyoLGApjCl5aWxfITEH/NYuKVH/5ERXTn1SZhU99ucmrJPYsDSzL6Nwown4TK1uaB0SS6HjbZY55R
        1txSEgpR8M8QwHZmI5lZHRyCCogsuBOSvyBELLsTWCHrNQ4d39kMo+sUi2o5wuGvrpKjOG1t4bz6f
        3aHqHLL3erReP9/pgk4LTHwP7ea+vhjg8zZhSNhIIOm8yf/ujj7mkfvZwaws7j3NC/yNr+Hg9UMZr
        eFeSIRo5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqW1-0002eZ-W7; Mon, 30 Sep 2019 07:54:41 +0000
Date:   Mon, 30 Sep 2019 00:54:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] libfrog: convert scrub.c functions to negative error
 codes
Message-ID: <20190930075441.GH27886@infradead.org>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
 <156944763836.302827.14950651793743078704.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944763836.302827.14950651793743078704.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 25, 2019 at 02:40:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert libfrog functions to return negative error codes like libxfs
> does.

Looks fine, although in the places where you touch the whole switch
statement I wonder why we just switch those to negative errnos instead
of inverting and then checking for positive values..

Reviewed-by: Christoph Hellwig <hch@lst.de>
