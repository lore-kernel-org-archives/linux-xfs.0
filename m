Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCB4C47404
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 09:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 733C321D71
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 09:42:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Eic02bz3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfJKJmr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 05:42:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43728 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfJKJmr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 05:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Eic02bz3wsWMdxLROiOCRsYno
        52Ve7wWgkuks0g+16BKMM9z/0zerb4gsMM9/m4kpSw5E3L2VOx7ZEz29M6L2OBm0JMzAwYOIPBrVb
        pkVzgULu+b8ZfIH6vuN9An/wozem2nC7poEyTNWKNmFto43/HQ9qk2ko7MX7zL25sNBRp2IjV7gRm
        i4WC2FsSwWUOM3Z43a56cRhsVgvTPqFHppn4+8S22i4rMHxxVHZbBQ0ALY0Hi/sIjogckW+sg0uur
        tx6jeHFDq9CKcdgyJmP+mHw2q4DCdNu2dohrJ+c9iywDZhwiH1Vl02derqoaQHhqq8fGkr3oRWiHB
        DbFYPxo8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIrRf-0005tz-5L; Fri, 11 Oct 2019 09:42:47 +0000
Date:   Fri, 11 Oct 2019 02:42:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/26] xfs: synchronous AIL pushing
Message-ID: <20191011094247.GB5787@infradead.org>
References: <20191009032124.10541-1-david@fromorbit.com>
 <20191009032124.10541-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009032124.10541-7-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
