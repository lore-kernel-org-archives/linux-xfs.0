Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E9CC35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DBF220704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:17:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="afM+s05m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgAYXRA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:17:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgAYXRA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WvxCZBP0Dsj5fxEa6uJ320z5/PrGk77izog0Pavzvjc=; b=afM+s05m35CNM7sJij3Kj/nNT
        DNU2hxMCg5sk6o7NenWFxbb8nnOK4h8ArEwmRNqOOrSRKGAXnj7uCsIs+RECGBg8c6AG/rUkrhY5O
        /Cn1xgV8POXjPR/57Euz3NbAr1ZWPuaXJ/Bi1P7C9hNmCTZeVhRjOJ1b/l619OSMo0TmMzoSElMGy
        FPe7dZE6Vn43jUs9GyfdWV/fZt5ueAefMThKHFK/QzJgSJDqy1BVvLqr11sRjZs08Ks1rO09mWcCS
        wnctknVb8atlsE1inKpbS37DZpIcZ7MMSLl75c8zPavaDtYqkP5rhH6qTjKHIVOc0+uiVVW7ta2a9
        WNJk6IVyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUfi-0006iE-TO; Sat, 25 Jan 2020 23:16:58 +0000
Date:   Sat, 25 Jan 2020 15:16:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] man: document some missing xfs_db commands
Message-ID: <20200125231658.GH15222@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <157982501686.2765410.2779527901724988940.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982501686.2765410.2779527901724988940.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 04:16:56PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The 'attr_set', 'attr_remove', and 'logformat' commands in xfs_db were
> not documented.  Add sections about them to the manpage.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
