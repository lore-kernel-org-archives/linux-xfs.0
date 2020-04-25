Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685D9C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F39720714
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:24:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="es4kHSDa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgDYSYR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 14:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYSYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 14:24:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958FBC09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 11:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y//olI5FMM7XnsuwQxhVkcl73dfqRfXN2jn42DWVVCA=; b=es4kHSDanAShcyrlteFPOM9qiY
        3tuQDs1Nznnab6oDujQtKglmwKctC7opnvSTROVYQG8MlBiV4G5B6lcyJ3k5sacMquWO0XSePDfGB
        8ah/0HKWENHCZsgmXCjA4ZOkRGEs2tu3Mp+RK8cBv06y3yp5LPNOcifey6kRjcvP99qMlXu24aufI
        Gc0FTJqgRkmbaj34Xq0IxVJEY9RgTcOK1KgQtNhMlisOXsceyOJC0nMWoQcWH2mWpS6NxdIiJF5Tg
        xl/6ubU5PU9snmwTJmx7mQf35d49vB7Xwy3xleJhxdFwk3nnfl+w9QMoZkLc6DyZBSTTfnmPrSJ52
        HABtM/tw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSPTN-0001YE-Cr; Sat, 25 Apr 2020 18:24:17 +0000
Date:   Sat, 25 Apr 2020 11:24:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/19] xfs: refactor log recovery intent item dispatch
 for pass2 commit functions
Message-ID: <20200425182417.GD16698@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752120800.2140829.455621202654717367.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752120800.2140829.455621202654717367.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:06:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the log intent item pass2 commit code into the per-item source code
> files and use the dispatch function to call it.  We do these one at a
> time because there's a lot of code to move.  No functional changes.

This commit log doesn't really match what is going on, as no move
beween files happens.  And the changes themselves look pretty odd
as well.
