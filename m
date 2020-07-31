Return-Path: <SRS0=R26v=BK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF664C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 02:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9DE721744
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 02:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GkheAAm0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbgGaChl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jul 2020 22:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgGaChk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jul 2020 22:37:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B98C061574
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2020 19:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oIoBbFsFydxkUJZM8OEQBwsorfgORvpUD6iTZwQTHvU=; b=GkheAAm06l/l++R13wxxvS49Sz
        BkRlJ++gNS+Kq++/Znt0Gw9RmxLj862D46quF8Q/V3nnwQ6GOlmPV7qJghGhFWQE/CjsZaPv5Z+9l
        cvte19gh/jjgDuM3g7n3PDtOQfa6ryjzO1v5mLm4F5o34NZc/FTxxvqpY7UE8ERkc8E8ew/CsxbGQ
        RyOeNRbs2PQlp3J3ODS5hNdQS9g73BGImnF0I/46sDsKrU0iMWy+nbg88NpvESoHfgiX5fgSrdafO
        k7sjat6Uc72VxlhZz8xmSr0m/0yN8RAEIi3JAI48Z829QmM5tbFKPnLrK6KerlFLGrhdMvWVahYq8
        wcW553aQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1KvJ-0002nD-Vj; Fri, 31 Jul 2020 02:37:30 +0000
Date:   Fri, 31 Jul 2020 03:37:29 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200731023729.GN23808@casper.infradead.org>
References: <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
 <20200729021231.GV23808@casper.infradead.org>
 <20200729051923.GZ2005@dread.disaster.area>
 <20200729185035.GX23808@casper.infradead.org>
 <20200729230503.GA2005@dread.disaster.area>
 <20200730135040.GD23808@casper.infradead.org>
 <20200730220857.GD2005@dread.disaster.area>
 <20200730234517.GM23808@casper.infradead.org>
 <20200731020558.GE2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731020558.GE2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 31, 2020 at 12:05:58PM +1000, Dave Chinner wrote:
> On Fri, Jul 31, 2020 at 12:45:17AM +0100, Matthew Wilcox wrote:
> > Essentially, we do as you thought
> > it worked, we read the entire page (or at least the portion of it that
> > isn't going to be overwritten.  Once all the bytes have been transferred,
> > we can mark the page Uptodate.  We'll need to wait for the transfer to
> > happen if the write overlaps a block boundary, but we do that right now.
> 
> Right, we can do that, but it would be an entire page read, I think,
> because I see little point int doing two small IOs with a seek in
> between them when a single IO will do the entire thing much faster
> that two small IOs and put less IOP load on the disk. We still have
> to think about impact of IOs on spinning disks, unfortunately...

Heh, maybe don't read the existing code because we actually do that today
if, say, you have a write that spans bytes 800-3000 of a 4kB page.  Worse,
we wait for each one individually before submitting the next, so the
drive doesn't even get the chance to see that we're doing read-seek-read.

I think we can profitably skip reading portions of the page if the write
overlaps either the beginning or end of the page, but it's not worth
breaking up an I/O for skipping reading 2-3kB.

The readahead window expands up to 256kB, so clearly we are comfortable
with doing potentially-unnecessary reads of at least that much.  I start
to wonder about whether it might be worth skipping part of the page if
you do a 1MB write to the middle of a 2MB page, but the THP patchset
doesn't even try to allocate large pages in the write path yet, so the
question remains moot today.

