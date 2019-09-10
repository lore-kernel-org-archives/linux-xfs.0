Return-Path: <SRS0=fGHA=XF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F46C3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 05:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAA9621D6C
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 05:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pCC6cloc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbfIJF4I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 01:56:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43568 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfIJF4H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Sep 2019 01:56:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XPTSgi1wQbnoYHyU0OhJehZyudOfjuQmII/QsS6+IQ0=; b=pCC6clocU6gPohrFZySTMksJl
        GQYmDePKhP0Q1Y3hzuS3/2tobX6F1ghpSECO4VGti5mXzdLEBjixBmmxaL/SISJ+oYso3SHB4nG2l
        SRhmrZkt+q2yyAhHLg9k540+GpQWxEIhXipo5DZJgDZtPEHTvlLPBL6URONa44d4l5JV3EbwgT7+y
        Aor/gFVm+f7PFMPo299qvjUH/wP0zl1eWF1yRHb3BKM8XHijigwrts/2RfCvmsBEsZ4O+PVkauZVG
        2Y+MYBPO8gwn0uxX1Km9MYbqLnC++n3RqczLAdQbeCZ9whxmkwSevabdsVyF6HQMQg1e0s8uBOGYd
        fwD8AwE8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i7Z8I-0001LM-V4; Tue, 10 Sep 2019 05:56:06 +0000
Date:   Mon, 9 Sep 2019 22:56:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 1baa2800e62d
Message-ID: <20190910055606.GA5132@infradead.org>
References: <20190831193917.GA568270@magnolia>
 <20190901073311.GA13954@infradead.org>
 <20190903234023.GJ568270@magnolia>
 <20190904050627.GA2569@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904050627.GA2569@infradead.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 10:06:27PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 03, 2019 at 04:40:24PM -0700, Darrick J. Wong wrote:
> > /me shrugs -- it's been broken for years, apparently, and we've been
> > arguing with almost no action for months.  Developers who are building
> > things off of 5.3 should probably just add the patch (or turn off slub
> > debugging)....
> 
> Well, this is a new breakage with the same old root cause.  The root
> cause is that slub with debugging enabled gives us unaligned memory.
> 
> But with my log recovery changes we may now use slub for allocations
> larger than a single page (before we only used it for smaller than
> page sizes allocations in the buffer cache), and that newly trips
> up in the pmem driver (and a few others).

Another ping.  It would be really sad to release 5.3 with a known
regression we've fixed two weeks before the release.
