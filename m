Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86200ECE596
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 09:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D8B321D7F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 09:35:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FQkridFL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfJKJfD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 05:35:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41914 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfJKJfD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 05:35:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=FQkridFLI+p4QBvXGx2pAvktA
        Ql8yqvZpOdhZ4E948Uj7KIujdBHxhfrDpxDamMG05fTTQQiAH/w98KADO4lgIX+mG6HXVTvP2McMt
        wk3zpxhMS+Desx+tbk3SHpxswihhoQAPCX0k/fceVBZlLATipqA9Z244zldAcxvC+k9IDKgSGyxMe
        R7LZXkZ8eH+el37QSyTonLnHrqZEo6xDiSBcdw1KoDC2olhxQcGoXnmc1XHBV9ha8LPQTMBzJAyZD
        rJTq2/CBcRefKT+zVlvOlaIgvYN8PwFXR/i0Ck0Feh9cFtGn6+Kek+fHhhnLkQiZ7fhtCOwJ85y6r
        gyrjZ+2BA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIrKA-0002pW-JS; Fri, 11 Oct 2019 09:35:02 +0000
Date:   Fri, 11 Oct 2019 02:35:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/26] xfs: don't allow log IO to be throttled
Message-ID: <20191011093502.GA5787@infradead.org>
References: <20191009032124.10541-1-david@fromorbit.com>
 <20191009032124.10541-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009032124.10541-4-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
