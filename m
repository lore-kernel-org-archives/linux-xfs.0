Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3443CC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 07:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058AF2063A
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 07:48:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c157uED6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgDBHsN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 03:48:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgDBHsN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 03:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8TyXGo7ewWXIrIqOdiFbE6Pf+LyMu8/lBXFC4uZ5pt4=; b=c157uED6UdAuB3loMch1N7Gr2A
        o4UHKRxsMcHVC8dd8XAAGaVbuw7v6kytzSTemeTT6jU+LvHGktkXar6NMJQjXB97E5/fTjDyB01lm
        FWhVnO+v+PhOg/Y7OVRy1GLz+JNX2Ch2Jfno577Q2Hvrc39RIVwbLFN1w1dGyMopKXOXCbbogFMhd
        ZWzsKo+cFv4ItLiFCoykPl0Wlk+4u6oqiKYRFJuCv2tvzMS86Ej6I3hdMlw/ALjaun4+jNquJ41po
        xTzVxHde5udkbnSIxDSKcv5kufFTRVrdmuxwLSVcQpwX7sva/xMjZ3rODOM0uudsi0T5ztevFURjw
        XTjyhI7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJuaC-0004Sr-VP; Thu, 02 Apr 2020 07:48:12 +0000
Date:   Thu, 2 Apr 2020 00:48:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: Add iomap_iter API
Message-ID: <20200402074812.GA16915@infradead.org>
References: <20200401152522.20737-1-willy@infradead.org>
 <20200401152522.20737-2-willy@infradead.org>
 <20200401154248.GA2813@infradead.org>
 <20200401192038.GJ21484@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401192038.GJ21484@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 01, 2020 at 12:20:38PM -0700, Matthew Wilcox wrote:
> On Wed, Apr 01, 2020 at 08:42:48AM -0700, Christoph Hellwig wrote:
> > OTOH the len argument / return value seems like something that would
> > seems useful in the iter structure.  That would require renaming the
> > current len to something like total_len..
> 
> Ah, I remembered why I didn't do it that way.  For more complicated
> users (eg readahead ...), we want to be able to pass an errno here.
> Then iomap_iter() will call ops->iomap_end() and return the errno
> you passed in, and we can terminate the loop.

Once we have the iter struct we can and should separate the written
counter from the errno, as that is a much cleaner interface.  The prime
reason I avoided that earlier was to keep the number of arguments down,
and even that was a bad reason in retrospective.
