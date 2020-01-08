Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89428C33CA1
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 603072070E
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FmG22ueo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgAHIN0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:13:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43740 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgAHINZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 03:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=f0JyQAkLrOl4tgLCR2Tpwy3YQOM8CUhJqBcEyeJNHIM=; b=FmG22ueoZp1ipkuzHSAJkManS
        ASXkTYkcPZRY9U4NUMkJ1S71JZzPofLau44ZevNIBa5O/cPBNGOmKpDxTOpPAfbKLGFJaZgw3OQiu
        9b3Ojr/LCnzD1SIsx1HKwqxAQri8rGbRXQk9OjVQjpTtY7IeSc0ULfReOSR2J9YF0Pi5hPXAztwEZ
        9mXsGC/r0B2ooeZx4HKuzZsm6ZO4ZPW3AlS7SFV62sosNFMK/QI3YkCd3T6qHG2TIzo7VHMJ8eJjC
        zqR4RkWQxLQc0g8+/x4Vy/ugGS4VL2CJbO2x+R3v5+5wxjuBM28O27RE9p5LcGuFUr7OzgiXrC2bm
        2dAq4cjPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip6Sz-0000Jx-HT; Wed, 08 Jan 2020 08:13:25 +0000
Date:   Wed, 8 Jan 2020 00:13:25 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 1/1] xfs: remove bogus assertion when online repair isn't
 enabled
Message-ID: <20200108081325.GD25201@infradead.org>
References: <157845707353.83042.7437302554308223031.stgit@magnolia>
 <157845707964.83042.11399554567794736343.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157845707964.83042.11399554567794736343.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 08:17:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't need to assert on !REPAIR in the stub version of
> xrep_calc_ag_resblks that is called when online repair hasn't been
> compiled into the kernel because none of the repair code will ever run.
> 
> Reported-by: Eryu Guan <guaneryu@gmail.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
