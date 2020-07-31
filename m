Return-Path: <SRS0=R26v=BK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD40C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 20:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7120621744
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 20:47:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XbxbKj0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgGaUrY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgGaUrX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Jul 2020 16:47:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5BAC061574
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2020 13:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wdfvVRmgCwSZMcdsOqYdy/4PPwkQ5nqJHFbndrEsSms=; b=XbxbKj0n19Tl3Qdnl6zyc3fuMZ
        b+ES3gN6RUalqjGSCZz5/S82MQdlNfG920SjobXZux8T8OXiFVHNmb3q1i29L9ydwbyJsGyulgcce
        uvVbFbyn5Q8XCNxvVrHt0+rD1GbhdUVWeIeY8vq2Wt7aEnxbUpYtmIzgL7nlOt7WdFtFf7ET6R7n/
        gzyI0bnq1cpgtgQzv6EQX1HDtSxFIyk8PTeVY4tVnw41y/3P/3jD0tKD4Z7R9KQ/O8ofFgVakK/5i
        FkxoLeo6MAm7L7YkKcXdf4sBTrhSIg+mjyWZYxy+hgxf+zDma7E45Y1Q6fduI/MnTwxFmaKpNN7TB
        HmaWtpGA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1bvt-0001xd-Gn; Fri, 31 Jul 2020 20:47:13 +0000
Date:   Fri, 31 Jul 2020 21:47:13 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200731204713.GA24067@casper.infradead.org>
References: <20200728153453.GC3151642@magnolia>
 <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
 <20200729021231.GV23808@casper.infradead.org>
 <20200729051923.GZ2005@dread.disaster.area>
 <20200729185035.GX23808@casper.infradead.org>
 <20200729230503.GA2005@dread.disaster.area>
 <20200730135040.GD23808@casper.infradead.org>
 <20200730220857.GD2005@dread.disaster.area>
 <20200730234517.GM23808@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730234517.GM23808@casper.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 31, 2020 at 12:45:17AM +0100, Matthew Wilcox wrote:
> On Fri, Jul 31, 2020 at 08:08:57AM +1000, Dave Chinner wrote:
> > On Thu, Jul 30, 2020 at 02:50:40PM +0100, Matthew Wilcox wrote:
> > > On Thu, Jul 30, 2020 at 09:05:03AM +1000, Dave Chinner wrote:
> > > > On Wed, Jul 29, 2020 at 07:50:35PM +0100, Matthew Wilcox wrote:
> > > > > I had a bit of a misunderstanding.  Let's discard that proposal
> > > > > and discuss what we want to optimise for, ignoring THPs.  We don't
> > > > > need to track any per-block state, of course.  We could implement
> > > > > __iomap_write_begin() by reading in the entire page (skipping the last
> > > > > few blocks if they lie outside i_size, of course) and then marking the
> > > > > entire page Uptodate.
> > > > 
> > > > __iomap_write_begin() already does read-around for sub-page writes.
> > > > And, if necessary, it does zeroing of unwritten extents, newly
> > > > allocated ranges and ranges beyond EOF and marks them uptodate
> > > > appropriately.
> > > 
> > > But it doesn't read in the entire page, just the blocks in the page which
> > > will be touched by the write.
> > 
> > Ah, you are right, I got my page/offset macros mixed up.
> > 
> > In which case, you just identified why the uptodate array is
> > necessary and can't be removed. If we do a sub-page write() the page
> > is not fully initialised, and so if we then mmap it readpage needs
> > to know what part of the page requires initialisation to bring the
> > page uptodate before it is exposed to userspace.
> 
> You snipped the part of my mail where I explained how we could handle
> that without the uptodate array ;-(  Essentially, we do as you thought
> it worked, we read the entire page (or at least the portion of it that
> isn't going to be overwritten.  Once all the bytes have been transferred,
> we can mark the page Uptodate.  We'll need to wait for the transfer to
> happen if the write overlaps a block boundary, but we do that right now.

OK, so this turns out to be Hard.  We enter the iomap code with

iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *iter,
                const struct iomap_ops *ops)

which does:
                ret = iomap_apply(inode, pos, iov_iter_count(iter),
                                IOMAP_WRITE, ops, iter, iomap_write_actor);

so iomap_write_actor doesn't get told about the blocks in the page before
the starting pos.  They might be a hole or mapped; we have no idea.

We could allocate pages _here_ and call iomap_readpage() for the pages
which overlap the beginning and end of the I/O, but I'm not entirely
convinced that the iomap_ops being passed in will appreciate being
called for a read that has no intent to write the portions of the page
outside pos.

Bleh.  I'm going to give up on removing the uptodate bit array and go
back to making the THP patchset better.
