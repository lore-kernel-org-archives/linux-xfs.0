Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311F4C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 02:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E2362076E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 02:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KhG4or5l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbgG2CMj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 22:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730524AbgG2CMj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 22:12:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26670C061794
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 19:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G1kTjZ4oNhLptn1qQiryzVYql6Cw0spy6N3NeCdaFik=; b=KhG4or5lxawKd7VMNKBuqfOjCV
        rrb61p8mGs0G/PQN7SX9wtvum0w8xWjvH8338PgKimTVV8hkU06RT5I7A5spvQ/Myhu0/w4aIlYXr
        zNUwbmEtezjcjhTmFGDiPyWehouGbbXMcH8TU5Fn2ABzY2UrPSZ7Vv/KxG3G0jwaa6spVxVeibPIx
        THxXPiY64InVOe3vOysyRotFbpRMQ7acuWZ6arOwqKcIiQyrP00ujdNiVLbbgnjuhVIhJgj6YZqrC
        SJ7kAJPd2SwVWQnEdIjdeaE9CqFRAXFt3TQthD3z8XvysQew/T1YeEmBHdw8ol5VTgOJqKlXbrcVz
        5gAOcvNw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0ba3-0001Za-W2; Wed, 29 Jul 2020 02:12:32 +0000
Date:   Wed, 29 Jul 2020 03:12:31 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200729021231.GV23808@casper.infradead.org>
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
 <20200728153453.GC3151642@magnolia>
 <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729015458.GY2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 29, 2020 at 11:54:58AM +1000, Dave Chinner wrote:
> On Tue, Jul 28, 2020 at 04:47:53PM +0100, Matthew Wilcox wrote:
> > I propose we do away with the 'uptodate' bit-array and replace it with an
> > 'writeback' bit-array.  We set the page uptodate bit whenever the reads to
> 
> That's just per-block dirty state tracking. But when we set a single
> bit, we still need to set the page dirty flag.

It's not exactly dirty, though.  It's 'present' (ie the opposite
of hole).  I'm not attached to the name.  So it can be used to
implement iomap_is_partially_uptodate.  If the page is dirty, the chunks
corresponding to the present bits get written back, but we don't track
a per-block dirty state.

> > fill the page have completed rather than checking the 'writeback' array.
> > In page_mkwrite, we fill the writeback bit-array on the grounds that we
> > have no way to track a block's non-dirtiness and we don't want to scan
> > each block at writeback time to see if it's been written to.
> 
> You're talking about mmap() access to the file here, not
> read/write() syscall access. If page_mkwrite() sets all the
> blocks in a page as "needing writeback", how is that different in
> any way to just using a single dirty bit? So why wouldn't we just do
> this in iomap_set_page_dirty()?

iomap_set_page_dirty() is called from iomap_page_mkwrite_actor(), so
sure!

> The only place we wouldn't want to set the entire page dirty is
> the call from __iomap_write_end() which knows the exact range of the
> page that was dirtied. In which case, iomap_set_page_dirty_range()
> would be appropriate, right? i.e. we still have to do all the same
> page/page cache/inode dirtying, but only that would set a sub-page
> range of dirty bits in the iomap_page?
> 
> /me doesn't see the point of calling dirty tracking "writeback bits"
> when "writeback" is a specific page state that comes between the
> "dirty" and "clean" states...

I don't want to get it confused with page states.  This is a different
thing.  It's just tracking which blocks are holes (and have definitely
not been written to), so those blocks can remain as holes when the page
gets written back.
