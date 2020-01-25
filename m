Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C772C35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5032C20674
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WNmvGWO6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgAYXQH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:16:07 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47178 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbgAYXQG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:16:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=WNmvGWO6EVoVsQeDAIosJ6Q/2
        p/srAHj/j3e/M04K/HEdZsai0miJoGUBVTSrs9aM/KGwo9s8CQrft7+fTmNquhw5+EZlC6FJjG/1r
        Pi2mMlJ+1SftIdVIcOlx/6kCSHA18FfIEy8bDfRT35l13jG9hsxScZtapLSiM00niljRFTPFNJUDU
        c8pISC9SQoDKIN4JdSHwcz7YgZgqQ6wlbPQEjkD1rB76uLBFCVIOCbzkVvAB9ltqV260jdyjvhAU2
        AYPJRuCtWRGhRim0nbhPMddPrA8Gn6DdAkWcEiFhhtvxSbupJGzrSNsPMg+zN9m8ViANqANrSu0t0
        cZSi5rkgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUeq-0006fU-CG; Sat, 25 Jan 2020 23:16:04 +0000
Date:   Sat, 25 Jan 2020 15:16:04 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] man: list xfs_io lsattr inode flag letters
Message-ID: <20200125231604.GE15222@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <157982499817.2765410.16336840066253160007.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982499817.2765410.16336840066253160007.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
