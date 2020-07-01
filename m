Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116CEC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4ED3206A1
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:07:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cvTLCrrl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgGAIH1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbgGAIH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:07:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9BAC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n91j5OMpP5pPUnszZvKH9WDZDdW072L82F5oYWSmyuc=; b=cvTLCrrl3UBhl/sDaESB03fufg
        2q8ZI8oMAYrTvfkGSk8osQPaIfZfMYsvBvA7BSKWYP1tpOW2hF2xv57NetPi5WD1sQsgJAK6D0wRk
        /q3XbLXb32ryBHjx+vbOliPh0m3nEAgfq64Fzzt8AbDFP4x51t76bMRzmxOwKzMa1jLRUmXVozFlW
        LSBL57L8tGbWCMibqfVGCtpMl2pA2P2SySL0xAHrFlFMT5CUz8s0R7zCVADTacCeGn0bBh0QH8Cxt
        IYuXx8mxSCoAoSLq+J43W5qtXrhtK/gruDukMdiKTxMe9p0TqWZrV/68yQJt1ExJ0ZSzE+fYBZbBT
        Q6yLk4bw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqXm9-0005LF-4u; Wed, 01 Jul 2020 08:07:25 +0000
Date:   Wed, 1 Jul 2020 09:07:25 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 1/9] xfs: fix reflink quota reservation accounting error
Message-ID: <20200701080725.GA20101@infradead.org>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304786592.874036.13697964290841630094.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304786592.874036.13697964290841630094.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:17:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Quota reservations are supposed to account for the blocks that might be
> allocated due to a bmap btree split.  Reflink doesn't do this, so fix
> this to make the quota accounting more accurate before we start
> rearranging things.
> 
> Fixes: 862bb360ef56 ("xfs: reflink extents from one file to another")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
