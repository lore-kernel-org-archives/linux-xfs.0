Return-Path: <SRS0=myhp=BJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9C7C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 22:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B7BA20829
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 22:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgG3WJE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jul 2020 18:09:04 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:42894 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727110AbgG3WJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jul 2020 18:09:04 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 2C3905AC9D1;
        Fri, 31 Jul 2020 08:08:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k1GjR-00013P-BP; Fri, 31 Jul 2020 08:08:57 +1000
Date:   Fri, 31 Jul 2020 08:08:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200730220857.GD2005@dread.disaster.area>
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
 <20200728153453.GC3151642@magnolia>
 <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
 <20200729021231.GV23808@casper.infradead.org>
 <20200729051923.GZ2005@dread.disaster.area>
 <20200729185035.GX23808@casper.infradead.org>
 <20200729230503.GA2005@dread.disaster.area>
 <20200730135040.GD23808@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730135040.GD23808@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=DAImFp6meiqXFIPQ0UsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 30, 2020 at 02:50:40PM +0100, Matthew Wilcox wrote:
> On Thu, Jul 30, 2020 at 09:05:03AM +1000, Dave Chinner wrote:
> > On Wed, Jul 29, 2020 at 07:50:35PM +0100, Matthew Wilcox wrote:
> > > I had a bit of a misunderstanding.  Let's discard that proposal
> > > and discuss what we want to optimise for, ignoring THPs.  We don't
> > > need to track any per-block state, of course.  We could implement
> > > __iomap_write_begin() by reading in the entire page (skipping the last
> > > few blocks if they lie outside i_size, of course) and then marking the
> > > entire page Uptodate.
> > 
> > __iomap_write_begin() already does read-around for sub-page writes.
> > And, if necessary, it does zeroing of unwritten extents, newly
> > allocated ranges and ranges beyond EOF and marks them uptodate
> > appropriately.
> 
> But it doesn't read in the entire page, just the blocks in the page which
> will be touched by the write.

Ah, you are right, I got my page/offset macros mixed up.

In which case, you just identified why the uptodate array is
necessary and can't be removed. If we do a sub-page write() the page
is not fully initialised, and so if we then mmap it readpage needs
to know what part of the page requires initialisation to bring the
page uptodate before it is exposed to userspace.

But that also means the behaviour of the 4kB write on 64kB page size
benchmark is unexplained, because that should only be marking the
written pages of the page up to date, and so it should be behaving
exactly like ext4 and only writing back individual uptodate chunks
on the dirty page....

So, we need to the iostat output from that test workload to
determine if XFS is doing page size IO or something different. I
suspect it's spewing huge numbers of 4-16kB writes, not PAGE_SIZEd
writes...

> > Modern really SSDs don't care about runs of zeros being written.
> > They compress and/or deduplicate such things on the fly as part of
> > their internal write-amplification reduction strategies. Pretty much
> > all SSDs on the market these days - consumer or enterprise - do this
> > sort of thing in their FTLs and so writing more than the exact
> > changed data really doesn't make a difference.
> 
> You're clearly talking to different SSD people than I am.

Perhaps so.

But it was pretty clear way back in the days of early sandforce SSD
controllers that compression and zero detection at the FTL level
resulted in massive reductions in write amplification right down at
the hardware level. The next generation of controllers all did this
so they could compete on performance. They still do this, which is
why industry benchmarks test performance with incompressible data so
that they expose the flash write perofrmance, not just the rate at
which the drive can detect and elide runs of zeros...

Note: I'm not saying that we shouldn't reduce the write bandwidth
being consumed here, just that arguments that about write
amplification are really not that convincing. We've *never* cared
about write amplification in XFS (indeed, we've never really cared
about SSD characteristics at all), yet it's consistently the fastest
filesystem on high end SSD storage because stuff like concurrency
and efficient dispatch of IO and deterministic behaviour matter far
more than write amplification.

IOWs, showing that even high end devices end up bandwidth limited
under common workloads using default configurations is a much more
convincing argument...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
