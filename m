Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAE7C3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 08:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A99F321848
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 08:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HaF1Q3kC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbfHVIIy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 04:08:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfHVIIy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 04:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3luk0WZFILmulq3SzIcGIM5H4ck6s8KaJKFMwyisg1w=; b=HaF1Q3kCYcon9jUg+8bS6Hbe9
        QqhH8hL2BnaN2g91hjeAJfI7G+GxSTfmnAhquEncpWPGZF8L7iZXSwgK5i0/IUYZ7up8eQ1B7lKN8
        Xp3dZ09xYb7ZmYa9JEDpj11huGO/8edwb3kENc8P5qBxyZmpCSbT/VrH+HjzqDznrKOL03YFgEgR4
        LRSoo7A7yyjmOon1lnP35GbheXppLuiRpDKpQB4qmZzlScDKmOsWIqWKjDHyxvISmENybI+Bx0eo3
        hZzOllRfG9iJe2E9XLdd4OhBoO4Ll2dPaFQYB0G1FDCssXpy92800XQKaslMxNR9xu1W2FZQZ8Pft
        Z7gC+L0kQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0i9M-0003m8-O3; Thu, 22 Aug 2019 08:08:52 +0000
Date:   Thu, 22 Aug 2019 01:08:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Ming Lei <tom.leiming@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190822080852.GC31346@infradead.org>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821232945.GC24904@infradead.org>
 <CACVXFVN93h7QrFvZNVQQwYZg_n0wGXwn=XZztMJrNbdjzzSpKQ@mail.gmail.com>
 <20190822044905.GU1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822044905.GU1119@dread.disaster.area>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 02:49:05PM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2019 at 10:50:02AM +0800, Ming Lei wrote:
> > It isn't correct to blk_rq_aligned() here because 'len' has to be logical block
> > size aligned, instead of DMA aligned only.

Even if len would have to be a multiple of the sector size, that doesn't
mean calling blk_rq_aligned would be incorrect, just possibly not
catching all issues.

But as Dave outlined I don't think it is a problem in any way.
