Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62502C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 05:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4840820786
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 05:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgG2FTa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 01:19:30 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60080 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgG2FTa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 01:19:30 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 35D0A367CFD;
        Wed, 29 Jul 2020 15:19:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k0eUt-0003Qx-20; Wed, 29 Jul 2020 15:19:23 +1000
Date:   Wed, 29 Jul 2020 15:19:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200729051923.GZ2005@dread.disaster.area>
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
 <20200728153453.GC3151642@magnolia>
 <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
 <20200729021231.GV23808@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729021231.GV23808@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=U3rayDVxfcYZLsYnrqQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 29, 2020 at 03:12:31AM +0100, Matthew Wilcox wrote:
> On Wed, Jul 29, 2020 at 11:54:58AM +1000, Dave Chinner wrote:
> > On Tue, Jul 28, 2020 at 04:47:53PM +0100, Matthew Wilcox wrote:
> > > I propose we do away with the 'uptodate' bit-array and replace it with an
> > > 'writeback' bit-array.  We set the page uptodate bit whenever the reads to
> > 
> > That's just per-block dirty state tracking. But when we set a single
> > bit, we still need to set the page dirty flag.
> 
> It's not exactly dirty, though.  It's 'present' (ie the opposite
> of hole). 

Careful with your terminology. At the page cache level, there is no
such thing as a "hole". There is only data and whether the data is
up to date or not. The page cache may be *sparsely populated*, but
a lack of a page or a range of the page that is not up to date
does not imply there is a -hole in the file- at that point.

I'm still not sure what "present" is supposed to mean, though,
because it seems no different to "up to date". The data is present
once it's been read into the page, calling page_mkwrite() on the
page doesn't change that at all.

> I'm not attached to the name.  So it can be used to
> implement iomap_is_partially_uptodate.  If the page is dirty, the chunks
> corresponding to the present bits get written back, but we don't track
> a per-block dirty state.

iomap_is_partially_uptodate() only indicates whether data in the
page is entirely valid or not. If it isn't entirely valid, then the
caller has to ask the filesystem whether the underlying range
contains holes or data....

> > > fill the page have completed rather than checking the 'writeback' array.
> > > In page_mkwrite, we fill the writeback bit-array on the grounds that we
> > > have no way to track a block's non-dirtiness and we don't want to scan
> > > each block at writeback time to see if it's been written to.
> > 
> > You're talking about mmap() access to the file here, not
> > read/write() syscall access. If page_mkwrite() sets all the
> > blocks in a page as "needing writeback", how is that different in
> > any way to just using a single dirty bit? So why wouldn't we just do
> > this in iomap_set_page_dirty()?
> 
> iomap_set_page_dirty() is called from iomap_page_mkwrite_actor(), so
> sure!

via set_page_dirty(), which is why I mentioned this:

> > The only place we wouldn't want to set the entire page dirty is
> > the call from __iomap_write_end() which knows the exact range of the
> > page that was dirtied. In which case, iomap_set_page_dirty_range()
> > would be appropriate, right? i.e. we still have to do all the same
> > page/page cache/inode dirtying, but only that would set a sub-page
> > range of dirty bits in the iomap_page?
> > 
> > /me doesn't see the point of calling dirty tracking "writeback bits"
> > when "writeback" is a specific page state that comes between the
> > "dirty" and "clean" states...
> 
> I don't want to get it confused with page states.  This is a different
> thing.  It's just tracking which blocks are holes (and have definitely
> not been written to), so those blocks can remain as holes when the page
> gets written back.

We do not track holes at the page level. We do not want to track
anything to do with the filesystem extent mapping at the page level.
That was something that bufferheads were used for, and was something
we specifically designed iomap specifically not to require.

IOWs, iomap does page cache IO at page level granularity, not block
level granularity.  The only thing we track at block granularity is
wither the range of the page over a given block contains valid data
or not.  i.e. whether the page has been initialised with the correct
data or not.

Further, page-mkwrite() has no knoweldge of whether the backing
store has holes in it or not, nor does it care. All it does is call
into the filesystem to fill any holes that may exist in the backing
space behind the page.  This is also needed for COW to allocate the
destination of the over write, but in either case there is no
interaction with pre-existing holes - that is all done by the
read side of the page fault before page_mkwrite is called...

IOWs, if you call page_mkwrite() on a THP, the filesystem will
allocate/reserve the entire backing space behind the page because
writeback of that THP requires writing the entire page and for
backing space to be fully allocated before that write is issued.

hence I'm really not sure what you are suggesting we do here because
it doesn't make sense to me. Maybe I'm missing something that THP
does that I'm not away of, but other than that I'm completely
missing what you are trying to do here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
