Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8CFC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 18:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D4B02075D
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 18:50:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oMPK+N+Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgG2Sur (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2Suq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 14:50:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C4EC061794
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 11:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=quN0Ftgv4QEXOhwix+xTSiBjv0rz9kY16DXPD2tbT4s=; b=oMPK+N+YUwPEVmhrFew0baffSo
        tdqIaZnV3K3OhA6GkyrI5x45eMFpFAPB9ggxNI95cFnKvbGiqZwjzwiTBczdhYqj8gWQFDYrqd9Fe
        j4OMi6P+5lCyT1evIXGCkfPV5UzBHhkpyIKLKRWzfK7cZEyZyj17KzM+LDZC8Np7Jc8soaT3+n5+S
        cybh/Elkl342D0F7RHnBvR9fl89TEdGfMWQ+cWFhemHIGeLPVLIXaYP5RBaIkI9jQFAWLvLR8RXH+
        QkFrItp+C85fxcifz246a0e0Il66yIRb677K/FDBFmODDT9Kh9DG1OMAk5mo7j4HXDW5z5c559yAe
        kdqCez5g==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0r9v-0007LX-9N; Wed, 29 Jul 2020 18:50:35 +0000
Date:   Wed, 29 Jul 2020 19:50:35 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200729185035.GX23808@casper.infradead.org>
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
 <20200728153453.GC3151642@magnolia>
 <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
 <20200729021231.GV23808@casper.infradead.org>
 <20200729051923.GZ2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729051923.GZ2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 29, 2020 at 03:19:23PM +1000, Dave Chinner wrote:
> On Wed, Jul 29, 2020 at 03:12:31AM +0100, Matthew Wilcox wrote:
> > On Wed, Jul 29, 2020 at 11:54:58AM +1000, Dave Chinner wrote:
> > > On Tue, Jul 28, 2020 at 04:47:53PM +0100, Matthew Wilcox wrote:
> > > > I propose we do away with the 'uptodate' bit-array and replace it with an
> > > > 'writeback' bit-array.  We set the page uptodate bit whenever the reads to
> > > 
> > > That's just per-block dirty state tracking. But when we set a single
> > > bit, we still need to set the page dirty flag.
> > 
> > It's not exactly dirty, though.  It's 'present' (ie the opposite
> > of hole). 
> 
> Careful with your terminology. At the page cache level, there is no
> such thing as a "hole". There is only data and whether the data is
> up to date or not. The page cache may be *sparsely populated*, but
> a lack of a page or a range of the page that is not up to date
> does not imply there is a -hole in the file- at that point.

That's not entirely true.  The current ->uptodate array does keep
track of whether an unwritten extent is currently a hole (see
page_cache_seek_hole_data()).  I don't know how useful that is.

> I'm still not sure what "present" is supposed to mean, though,
> because it seems no different to "up to date". The data is present
> once it's been read into the page, calling page_mkwrite() on the
> page doesn't change that at all.

I had a bit of a misunderstanding.  Let's discard that proposal
and discuss what we want to optimise for, ignoring THPs.  We don't
need to track any per-block state, of course.  We could implement
__iomap_write_begin() by reading in the entire page (skipping the last
few blocks if they lie outside i_size, of course) and then marking the
entire page Uptodate.

Buffer heads track several bits of information about each block:
 - Uptodate (contents of cache at least as recent as storage)
 - Dirty (contents of cache more recent than storage)
 - ... er, I think all the rest are irrelevant for iomap

I think I just talked myself into what you were arguing for -- that we
change the ->uptodate bit array into a ->dirty bit array.

That implies that we lose the current optimisation that we can write at
a blocksize alignment into the page cache and not read from storage.
I'm personally fine with that; most workloads don't care if you read
extra bytes from storage (hence readahead), but writing unnecessarily
to storage (particularly flash) is bad.

Or we keep two bits per block.  The implementation would be a little icky,
but it could be done.

I like the idea of getting rid of partially uptodate pages.  I've never
really understood the concept.  For me, a partially dirty page makes a
lot more sense than a partially uptodate page.  Perhaps I'm just weird.

Speaking of weird, I don't understand why an unwritten extent queries
the uptodate bits.  Maybe that's a buffer_head thing and we can just
ignore it -- iomap doesn't have such a thing as a !uptodate page any
more.
