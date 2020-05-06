Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE53C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BD022076D
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FHrHR0Rj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgEFPM6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728784AbgEFPM6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:12:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61449C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vc1+gDbm3Y2j5MDf22Gv+Hx4+3O5yn2APInO6UoLBSQ=; b=FHrHR0RjdCUssb2c5uLThpPVeX
        ekfb9nbRBkpr6MDmkuAg752pucQ37Xbh+R8tvpjX0opr5S4wmkzVUsxwFpNMyexK58Rcg923bVze0
        8UoARRJpUw3zSL4Iak4a91uGVW/oWk8jBZTymj43baey6nrwKrP4nRPZzE02pRQFxa6SEpzhxG6u9
        nyoI68Mk+M0EFE96XRpO1l8oSKJ87+vC3jm9UQy+aOF8a8FvfSt9kC/7zHA/zKryhWHz0946yKZAN
        DDE5UlhDdbUBlW54LMTD3O0r7vGSDPM/+uM2nrYVRgSWUxAElyPH0LLM4CYY9BxosljWM9lgo/d8f
        paHgShIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLjG-0008Gx-8R; Wed, 06 May 2020 15:12:58 +0000
Date:   Wed, 6 May 2020 08:12:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/28] xfs: refactor log recovery RUI item dispatch for
 pass2 commit functions
Message-ID: <20200506151258.GM7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864109518.182683.10374774193978011328.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864109518.182683.10374774193978011328.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:11:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the rmap update intent and intent-done pass2 commit code into the
> per-item source code files and use dispatch functions to call them.  We
> do these one at a time because there's a lot of code to move.  No
> functional changes.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
