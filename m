Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA904C33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 992C721734
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E51aeldK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAWWfp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:35:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53058 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgAWWfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 17:35:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QdAAaEsMwjPCknQ38pnV7NXhV/i3dhp8SkjdrHCsDkk=; b=E51aeldKIe43kWIEp2lsm+bMT
        LLdtRrJsgZzXNUfme5BcuR2jxh0rrJS4Tw5txWv/1mAcudG6SX4bAcW2oVTWfW1bQdCwHkt7ghRhL
        kVOLZ5uW4gLjJxZleXRc41l9zHsLexht0IkXtmFrv94LEDZAe9BvUdy4rraslYe+SzrFdIg9j18TE
        QeBA2xD41yproucR5kH1FJTRaVAl4a1CYNimiy/SavNMUsstZRiCz+WiabpqOHqLDNJJK/wT7KCIg
        NaG5930N1LJE75eFvejlrvz+Zu/YL2E96SW2RY7UgdlLKnUBF7OcBJsegcllgWa0poCNA0RA84Hm4
        aJqHLh0QQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iul4h-0003LD-7S; Thu, 23 Jan 2020 22:35:43 +0000
Date:   Thu, 23 Jan 2020 14:35:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 06/29] xfs: remove the name == NULL check from
 xfs_attr_args_init
Message-ID: <20200123223543.GC2669@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-7-hch@lst.de>
 <20200121175752.GG8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121175752.GG8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 09:57:52AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 14, 2020 at 09:10:28AM +0100, Christoph Hellwig wrote:
> > All callers provide a valid name pointer, remove the redundant check.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Hm.  I wondered if this should become at least an ASSERT(name != NULL)
> to catch future users screwing that up, but I think the answer is that
> we'll crash soon enough in xfs_da_hashname?

Yes, passing a NULL name would blow up instantly and also doesn't really
make sense to start with as you want to set/get something after all..
