Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49031C47256
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2847120936
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:19:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IxuQjkQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgEFPTB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbgEFPTB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:19:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF25C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=IxuQjkQPajq7h0B6OU/SxvEwd0
        dO7waKSpHJokGMOJcDGhl52gWe44jPPpgYKfCv9Ch7z5foOACjsQITKnwfLiPtA0yDuG4Gsm08V5n
        KnXckNWWUEMd/WeSBK+EAi70Teciz7mkwX4U4ttD7LNgN43snpbtan/izN9ajSDxUteQNWSZAPc/Z
        H7sKClOTmh5YDHIt8Ec8Jnxa3G9lRpaP3LNvEH6U/bVeDAKLIQ+aiCLD3bYKHRNK4ZVAP3Sbf0jbl
        8LC4J43L4t502EUULOGlUgN6IjUIFjZyk8XRKcSliBWnZkZC12r1WAorDoMj6rqI6dz7bxuijeF/E
        TMaNFAHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLp7-0007hf-B1; Wed, 06 May 2020 15:19:01 +0000
Date:   Wed, 6 May 2020 08:19:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/28] xfs: refactor recovered RUI log item playback
Message-ID: <20200506151901.GT7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864112778.182683.3049865779495487697.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864112778.182683.3049865779495487697.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
