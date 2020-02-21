Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B7FC35646
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47AFB20656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gdGL05B+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgBUOqL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:46:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46732 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgBUOqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:46:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/XTakS3y39rha4jsW4iz09cXuvoWbNteC3VknSTMGbw=; b=gdGL05B+DsqsuSiISFxbBHBcZQ
        InSd4eG2Gt/kGAIF+kiZmlQn/2ArDnRhrbbqezHqUZYsGDkPxVPxEmFmCA8iW6ZoVR5Ut38iyKN4V
        nO5Iyai0+FMH0VcB6FswFrOrC9yMNEmpt8YC33qms74rS4cG9jr1Azbh4dzNhaFLXg4sPhiISZHzE
        gYCqutZg3nBeofEedgEnAW9nYImzLqKlHjcM4nJl8tZ1k3FTvHFnxM5RVY4PEegCAzQJ4lj0suVYE
        7FO9Zl4fo4/4Zgvk6EnPr5h4iHIe2Lx2eTHbVagc3tLOVANbjJLVq/O/qf8PGVq6CuN0g+tdMpRiN
        OPfQ1Zrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59ZC-00089Y-Vs; Fri, 21 Feb 2020 14:46:10 +0000
Date:   Fri, 21 Feb 2020 06:46:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/18] libxfs: make libxfs_readbuf_verify return an error
 code
Message-ID: <20200221144610.GF15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216300534.602314.4013285592257885758.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216300534.602314.4013285592257885758.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Return the bp->b_error from libxfs_readbuf_verify instead of making
> callers check it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
