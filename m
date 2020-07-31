Return-Path: <SRS0=R26v=BK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD80C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 02:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D0020829
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 02:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbgGaCGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jul 2020 22:06:10 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:44826 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730904AbgGaCGJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jul 2020 22:06:09 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id D4D4910B4E7;
        Fri, 31 Jul 2020 12:06:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k1KQo-0002P6-54; Fri, 31 Jul 2020 12:05:58 +1000
Date:   Fri, 31 Jul 2020 12:05:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200731020558.GE2005@dread.disaster.area>
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
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=L_0D_wc0AJzFsBwVMesA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
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
> that without the uptodate array ;-(

I snipped the part where you explained the way it currently avoided
reading the parts of the page that the block being dirtied didn't
cover :)

> Essentially, we do as you thought
> it worked, we read the entire page (or at least the portion of it that
> isn't going to be overwritten.  Once all the bytes have been transferred,
> we can mark the page Uptodate.  We'll need to wait for the transfer to
> happen if the write overlaps a block boundary, but we do that right now.

Right, we can do that, but it would be an entire page read, I think,
because I see little point int doing two small IOs with a seek in
between them when a single IO will do the entire thing much faster
that two small IOs and put less IOP load on the disk. We still have
to think about impact of IOs on spinning disks, unfortunately...

> > But that also means the behaviour of the 4kB write on 64kB page size
> > benchmark is unexplained, because that should only be marking the
> > written pages of the page up to date, and so it should be behaving
> > exactly like ext4 and only writing back individual uptodate chunks
> > on the dirty page....
> 
> That benchmark started by zeroing the entire page cache, so all blocks
> were marked Uptodate, so we wouldn't skip them on writeout.

Ah, I missed that bit. I thought it was just starting from a fully
allocated file and a cold cache, not a primed, hot cache...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
