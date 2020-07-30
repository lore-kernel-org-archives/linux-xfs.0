Return-Path: <SRS0=myhp=BJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE463C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 13:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B54802074B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 13:50:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CsDQY/BJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgG3Nuv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jul 2020 09:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgG3Nuu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jul 2020 09:50:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C79CC061574
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2020 06:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=t3GSpKHlsq/+mbghOOSDihtSkWYDc7y7KHKRSA+tr0M=; b=CsDQY/BJ81GXZQ1TY8A5W6Z0jZ
        hAVA3lkg62yZUJNhxPgV4UPw1rJdhdBJG28OSH9J0aOB+KVEV8+zYjspAthHD8QnuTXVZPFnRDZix
        XbjOJpnpNEYSI7FkM/gUgSyQJZOl8qzm9/AW4gIUEMBgogUZ55qTo3/+impgIViPAy0wVkWLapPBP
        Q2ZoaeGFnNvrbTawQKs1pNDfFwZCzhE+KkUSl+1q/uTwoyavolSiku9M1y/p326LJpL6z8RjcqIXj
        Aa2EuP9LGOwIslxksi8wrklpBdcykUBQDH1ptqfHaFRXzhgyG4hUPmjNEqY/17LyqiT4TJr7Ec3R8
        yNjDsOAA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k18xE-0000j5-4E; Thu, 30 Jul 2020 13:50:40 +0000
Date:   Thu, 30 Jul 2020 14:50:40 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200730135040.GD23808@casper.infradead.org>
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
 <20200728153453.GC3151642@magnolia>
 <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
 <20200729021231.GV23808@casper.infradead.org>
 <20200729051923.GZ2005@dread.disaster.area>
 <20200729185035.GX23808@casper.infradead.org>
 <20200729230503.GA2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729230503.GA2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 30, 2020 at 09:05:03AM +1000, Dave Chinner wrote:
> On Wed, Jul 29, 2020 at 07:50:35PM +0100, Matthew Wilcox wrote:
> > I had a bit of a misunderstanding.  Let's discard that proposal
> > and discuss what we want to optimise for, ignoring THPs.  We don't
> > need to track any per-block state, of course.  We could implement
> > __iomap_write_begin() by reading in the entire page (skipping the last
> > few blocks if they lie outside i_size, of course) and then marking the
> > entire page Uptodate.
> 
> __iomap_write_begin() already does read-around for sub-page writes.
> And, if necessary, it does zeroing of unwritten extents, newly
> allocated ranges and ranges beyond EOF and marks them uptodate
> appropriately.

But it doesn't read in the entire page, just the blocks in the page which
will be touched by the write.

> > Buffer heads track several bits of information about each block:
> >  - Uptodate (contents of cache at least as recent as storage)
> >  - Dirty (contents of cache more recent than storage)
> >  - ... er, I think all the rest are irrelevant for iomap
> 
> 
> Yes, it is. And we optimised out the dirty tracking by just using
> the single dirty bit in the page.
> 
> > I think I just talked myself into what you were arguing for -- that we
> > change the ->uptodate bit array into a ->dirty bit array.
> > 
> > That implies that we lose the current optimisation that we can write at
> > a blocksize alignment into the page cache and not read from storage.
> 
> iomap does not do that. It always reads the entire page in, even for
> block aligned sub-page writes. IIRC, we even allocate on page
> granularity for sub-page block size filesystems so taht we fill
> holes and can do full page writes in writeback because this tends to
> significantly reduce worst case file fragmentation for random sparse
> writes...

That isn't what __iomap_write_begin() does today.

Consider a 1kB block size filesystem and a 4kB page size host.  Trace through
writing 1kB at a 2kB offset into the file.
We call iomap_write_begin() with pos of 2048, len 1024.
Allocate a new page
Call __iomap_write_begin(2048, 1024)
block_start = 2048
block_end = 3072
iomap_adjust_read_range() sets poff and plen to 2048 & 1024
from == 2048, to == 3072, so we continue
block_start + plen == block_end so the loop terminates.
We didn't read anything.

> Modern really SSDs don't care about runs of zeros being written.
> They compress and/or deduplicate such things on the fly as part of
> their internal write-amplification reduction strategies. Pretty much
> all SSDs on the market these days - consumer or enterprise - do this
> sort of thing in their FTLs and so writing more than the exact
> changed data really doesn't make a difference.

You're clearly talking to different SSD people than I am.

