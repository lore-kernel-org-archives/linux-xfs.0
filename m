Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22867C64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0276206E3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LfNnSxZf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgLAKIa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 05:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgLAKIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:08:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D093CC0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OqqcPhVvCCVWL5JJ2xTPdr1Vbe+PmIfEir8Lxi7AHQU=; b=LfNnSxZfBteSiJHRyP3XgeYV4A
        cAI2yaFkL39+0LGCEX/h5Rr8PC2ub5l10MaGDNMZJctVgUHZ9NwmIs79EA1clPCF7TlZxWbRB5F9y
        nyxqKplkzMyemZNVz0PNFKCscWYqghNYI7gl11/8e+2hXuHSqtUC9w7MfKyeF10BM8clUIFUiG9IA
        GL9ZsrgL4W4sbwCkcEHpWSlmO4ogsuYgjF5GddequmihdauoGLF+Vu9LZdgenY1Zp7utw6Bv+HDWy
        QBygwyqIzGZlwywA68HeDdxTbJowK9zDoFeHlFMKEeS3SZL9lWF1q+Tb1hrElXMw0NyBnd+pWXE5V
        0ToLKcsQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2ZY-0003JC-J9; Tue, 01 Dec 2020 10:07:48 +0000
Date:   Tue, 1 Dec 2020 10:07:48 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: trace log intent item recovery failures
Message-ID: <20201201100748.GK10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679392189.447963.17675817137470359966.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679392189.447963.17675817137470359966.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:38:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a trace point so that we can capture when a recovered log intent
> item fails to recover.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
