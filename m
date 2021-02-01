Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2638C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 550F664E9E
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhBAMk2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 07:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhBAMkZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 07:40:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A8AC061573
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Vj/x/DoyoHrN2NnvHz1+IOKTAnDvELrYn/a8XmbjITM=; b=Np98N+rssNZ2Sx0qRbCgi82499
        eyP15FIJRpnr7YejES0P/nq+zz/aZerZvRT+Im2K/B2IQMCx+hyiqIy8DsOcOIpy4vqIuO9k2JnB7
        ZsLf8xQ+xtXpK3BfbNgieXgV8+qvKK5A+1t1jGbPMy01O3Jp249wGsncocUpU4wRP0EnhFGP41LyM
        XgdmwyUXVrOm7TUT31KQPE+Rxff7EF+G5rE2VOl9nONVnz8fpU246VeF5qfYcjJVhUOWBilPe2P3V
        CKgkH7magUsPZWzQl8LMrlT53PsW6KP2fAFzaLaGlBXbQkKDIzaKMCl1BFPnDf36DSsnDARY2B19q
        na9xnMbA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6YUZ-00DlmN-10; Mon, 01 Feb 2021 12:39:43 +0000
Date:   Mon, 1 Feb 2021 12:39:43 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5] xfs: various log stuff...
Message-ID: <20210201123943.GA3281245@infradead.org>
References: <20210128044154.806715-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128044154.806715-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 03:41:49PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> Quick patch dump for y'all. A couple of minor cleanups to the
> log behaviour, a fix for the CIL throttle hang and a couple of
> patches to rework the cache flushing that journal IO does to reduce
> the number of cache flushes by a couple of orders of magnitude.
> 
> All passes fstests with no regressions, no performance regressions
> from fsmark, dbench and various fio workloads, some big gains even
> on fast storage.

Can you elaborate on the big gains?  Workloads for one, but also
what kind of storage.  For less FUA/flush to matter the device needs
to have a write cache, which none of the really fast SSDs even has.

So I'd only really expect gains from that on consumer grade SSDs and
hard drives.
