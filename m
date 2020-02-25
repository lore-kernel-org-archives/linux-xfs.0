Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE62C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC5132051A
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hHbVTXkX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbgBYRYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:24:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56522 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729817AbgBYRYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:24:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=PzdWayaxS6ayq9I+GkTSYuRWsVr4frP3oUwE87uVxck=; b=hHbVTXkXRk3PcCDaPTh9IKMWxz
        ZWG4/etkfs/l3Yyl7CjagY0OGswy+deg8oR1z5BDNr85jBysEF70Zp/jVrLTwx9SJp5WeexC7oPc1
        BBvEZ6HaYg/EO5ordvZHuMLRrpmm24UofPpLfadu3nFsePrNqV06tm0+YpFU+i30aksAiM7I18Z7r
        SgUrZdCVon9Sz+WXXBaTArY/M2ju0gGoYljVRrSw0m67gtkpdT50KEOl94ctyLICmR/XqCsj1LNWp
        wvJMeW9XXMyJnJQLEN4ai6VODt8JytcaxB2wLC8fgHLvAFXNe9B4gQ4Wc8P+RRZPd3ICpxANQHfCD
        bkJCyVxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6dwI-00039E-Ud; Tue, 25 Feb 2020 17:24:10 +0000
Date:   Tue, 25 Feb 2020 09:24:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: remove the agfl_bno member from struct xfs_agfl
Message-ID: <20200225172410.GB2937@infradead.org>
References: <20200130133343.225818-1-hch@lst.de>
 <20200130133343.225818-2-hch@lst.de>
 <20200224220256.GA3446@infradead.org>
 <75eb13f6-8f96-a07d-f6ee-c648f8a3b38e@sandeen.net>
 <20200224223034.GA14361@infradead.org>
 <61713cad-ea6c-6a0c-79eb-cf01105e1222@sandeen.net>
 <20200224224648.GB25075@infradead.org>
 <477af5b7-9973-1e4e-a8b4-8458e516f686@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <477af5b7-9973-1e4e-a8b4-8458e516f686@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

So actually I think I was confused.  The BUILD_BUG_ON is what we had
before adding the __packed.  What we fix here іs just a really silly
warning from new gcc, which in fact only happens in xfsprogs as the
kernel decided that the warning is so damn stupid that we won't enable
it.  So no need for urgent treatment or a new commit message, sorry for
the noise.

I'll just resend the whole series with the review comments addressed.
