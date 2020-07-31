Return-Path: <SRS0=R26v=BK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB44CC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 22:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F732087C
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 22:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgGaWNY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 18:13:24 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:56009 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgGaWNX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Jul 2020 18:13:23 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id D93631ABBD5;
        Sat,  1 Aug 2020 08:13:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k1dH7-00011M-QW; Sat, 01 Aug 2020 08:13:13 +1000
Date:   Sat, 1 Aug 2020 08:13:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200731221313.GF2005@dread.disaster.area>
References: <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
 <20200729021231.GV23808@casper.infradead.org>
 <20200729051923.GZ2005@dread.disaster.area>
 <20200729185035.GX23808@casper.infradead.org>
 <20200729230503.GA2005@dread.disaster.area>
 <20200730135040.GD23808@casper.infradead.org>
 <20200730220857.GD2005@dread.disaster.area>
 <20200730234517.GM23808@casper.infradead.org>
 <20200731204713.GA24067@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731204713.GA24067@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=t-KYFEqMqR_OQX7d4T8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 31, 2020 at 09:47:13PM +0100, Matthew Wilcox wrote:
> On Fri, Jul 31, 2020 at 12:45:17AM +0100, Matthew Wilcox wrote:
> > On Fri, Jul 31, 2020 at 08:08:57AM +1000, Dave Chinner wrote:
> > > On Thu, Jul 30, 2020 at 02:50:40PM +0100, Matthew Wilcox wrote:
> > > > On Thu, Jul 30, 2020 at 09:05:03AM +1000, Dave Chinner wrote:
> > > > > On Wed, Jul 29, 2020 at 07:50:35PM +0100, Matthew Wilcox wrote:
> > > > > > I had a bit of a misunderstanding.  Let's discard that proposal
> > > > > > and discuss what we want to optimise for, ignoring THPs.  We don't
> > > > > > need to track any per-block state, of course.  We could implement
> > > > > > __iomap_write_begin() by reading in the entire page (skipping the last
> > > > > > few blocks if they lie outside i_size, of course) and then marking the
> > > > > > entire page Uptodate.
> > > > > 
> > > > > __iomap_write_begin() already does read-around for sub-page writes.
> > > > > And, if necessary, it does zeroing of unwritten extents, newly
> > > > > allocated ranges and ranges beyond EOF and marks them uptodate
> > > > > appropriately.
> > > > 
> > > > But it doesn't read in the entire page, just the blocks in the page which
> > > > will be touched by the write.
> > > 
> > > Ah, you are right, I got my page/offset macros mixed up.
> > > 
> > > In which case, you just identified why the uptodate array is
> > > necessary and can't be removed. If we do a sub-page write() the page
> > > is not fully initialised, and so if we then mmap it readpage needs
> > > to know what part of the page requires initialisation to bring the
> > > page uptodate before it is exposed to userspace.
> > 
> > You snipped the part of my mail where I explained how we could handle
> > that without the uptodate array ;-(  Essentially, we do as you thought
> > it worked, we read the entire page (or at least the portion of it that
> > isn't going to be overwritten.  Once all the bytes have been transferred,
> > we can mark the page Uptodate.  We'll need to wait for the transfer to
> > happen if the write overlaps a block boundary, but we do that right now.
> 
> OK, so this turns out to be Hard.  We enter the iomap code with
> 
> iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *iter,
>                 const struct iomap_ops *ops)
> 
> which does:
>                 ret = iomap_apply(inode, pos, iov_iter_count(iter),
>                                 IOMAP_WRITE, ops, iter, iomap_write_actor);
> 
> so iomap_write_actor doesn't get told about the blocks in the page before
> the starting pos.  They might be a hole or mapped; we have no idea.

So this is a kind of the same problem block size > page size has to
deal with for block allocation - the zero-around issue. THat is,
when a sub block write triggers a new allocation, it actually has to
zero the entire block in the page cache first, which means it needs
to expand the IO range in iomap_write_actor()....

https://lore.kernel.org/linux-xfs/20181107063127.3902-10-david@fromorbit.com/
https://lore.kernel.org/linux-xfs/20181107063127.3902-14-david@fromorbit.com/

> We could allocate pages _here_ and call iomap_readpage() for the pages
> which overlap the beginning and end of the I/O,

FWIW, this is effective what calling iomap_zero() from
iomap_write_actor() does - it allocates pages outside the write
range via iomap_begin_write(), then zeroes them in memory and marks
them dirty....

> but I'm not entirely
> convinced that the iomap_ops being passed in will appreciate being
> called for a read that has no intent to write the portions of the page
> outside pos.

I don't think it should matter what the range of the read being done
is - it has the same constraints whether it's to populate the
partial block or whole blocks just before the write. Especially as
we are in the buffered write path and so the filesystem has
guaranteed us exclusive access to the inode and it's mapping
here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
