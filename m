Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C867C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D80EB20747
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L64r6uL4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgGAIrS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgGAIrQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:47:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4957FC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MlBbBFXMKtG6d1uYi2h6zfQHrI1Q2WZFczqnYMxfX+8=; b=L64r6uL4frasjQRghXDaLqIreC
        MJ2Ku4HO/SMQ9CkC8D4/l3boBcKgCH1p/kZ8LTQdXMZ+c5oM0HYn7o0drTGa60K4e73iP5x8Vb2sO
        QJlMd7bw6lY5MRAdn50vn/5fspR/7MuTQA+2UonTYfRxC7sgbABdJ31++ARcuD7Ugulq2tCgM6mpO
        HjhbWJp9lu3MeKYI6JYkwb2njYPXO+dJ/9VTRqfVXeBcT126oLXIzHSaW+6UFkXo2AbzIfdIvFpRf
        KCR4sVHhTrJge9LeOZm25bd1uLMlZJPrOlFbzaEgoc129PPy1wpH5bNX+k4yfr4cxzomvRCe7Dh5e
        SwfX1Tvw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYOh-0007Ry-0B; Wed, 01 Jul 2020 08:47:15 +0000
Date:   Wed, 1 Jul 2020 09:47:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] xfs: stop using q_core.d_flags in the quota code
Message-ID: <20200701084714.GD25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353173676.2864738.5361850443664572160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353173676.2864738.5361850443664572160.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
>  
> +#define XFS_DQ_ONDISK		(XFS_DQ_ALLTYPES)
> +

I really wonder if we should split the on-disk type and the in-core
flags properly instead.

That is propagate the u8 flags from the on-disk field directly,
and use a separate field for the in-memory flags dirty and freeing
flags, as that this kind of mixing up is bound to eventually create
problems.
