Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7726EC3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 04:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 530C7233A0
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 04:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730948AbfHVEuQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 00:50:16 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34734 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729695AbfHVEuQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 00:50:16 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C567B43F2FB;
        Thu, 22 Aug 2019 14:50:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0f21-0005zK-Gf; Thu, 22 Aug 2019 14:49:05 +1000
Date:   Thu, 22 Aug 2019 14:49:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190822044905.GU1119@dread.disaster.area>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821232945.GC24904@infradead.org>
 <CACVXFVN93h7QrFvZNVQQwYZg_n0wGXwn=XZztMJrNbdjzzSpKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVN93h7QrFvZNVQQwYZg_n0wGXwn=XZztMJrNbdjzzSpKQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=c6poJhFP8yU8P8LWmo4A:9
        a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 10:50:02AM +0800, Ming Lei wrote:
> On Thu, Aug 22, 2019 at 8:06 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Wed, Aug 21, 2019 at 06:38:20PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > Add memory buffer alignment validation checks to bios built in XFS
> > > to catch bugs that will result in silent data corruption in block
> > > drivers that cannot handle unaligned memory buffers but don't
> > > validate the incoming buffer alignment is correct.
> > >
> > > Known drivers with these issues are xenblk, brd and pmem.
> > >
> > > Despite there being nothing XFS specific to xfs_bio_add_page(), this
> > > function was created to do the required validation because the block
> > > layer developers that keep telling us that is not possible to
> > > validate buffer alignment in bio_add_page(), and even if it was
> > > possible it would be too much overhead to do at runtime.
> >
> > I really don't think we should life this to XFS, but instead fix it
> > in the block layer.  And that is not only because I have a pending
> > series lifting bits you are touching to the block layer..
> >
> > > +int
> > > +xfs_bio_add_page(
> > > +     struct bio      *bio,
> > > +     struct page     *page,
> > > +     unsigned int    len,
> > > +     unsigned int    offset)
> > > +{
> > > +     struct request_queue    *q = bio->bi_disk->queue;
> > > +     bool            same_page = false;
> > > +
> > > +     if (WARN_ON_ONCE(!blk_rq_aligned(q, len, offset)))
> > > +             return -EIO;
> > > +
> > > +     if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
> > > +             if (bio_full(bio, len))
> > > +                     return 0;
> > > +             __bio_add_page(bio, page, len, offset);
> > > +     }
> > > +     return len;
> >
> > I know Jens disagree, but with the amount of bugs we've been hitting
> > thangs to slub (and I'm pretty sure we have a more hiding outside of
> > XFS) I think we need to add the blk_rq_aligned check to bio_add_page.
> 
> It isn't correct to blk_rq_aligned() here because 'len' has to be logical block
> size aligned, instead of DMA aligned only.

News to me.

AFAIA, the overall _IO_ that is being built needs to be a multiple
of the logical block size in total size (i.e. bio->bi_iter.size)
because sub sector IO is not allowed. But queue DMA limits are not
defined in sectors - they define the scatter/gather DMA capability
of the hardware, and that's what individual segments (bvecs) need to
align to.  That's what blk_rq_aligned() checks here - that the bvec
segment aligns to what the underlying driver(s) requires, not that
the entire IO is sector sized and aligned.

Also, think about multipage bvecs - the pages we are spanning here
are contiguous pages, so this should end up merging them and turning
it into a single multipage bvec whose length is sector size
aligned...

> Also not sure all users may setup bio->bi_disk well before adding page to bio,
> since it is allowed to do that now.

XFS does, so I just don't care about random users of bio_add_page()
in this patch. Somebody else can run the block layer gauntlet to get
these checks moved into generic code and they've already been
rejected twice as unnecessary.

> If slub buffer crosses two pages, block layer may not handle it at all
> even though
> un-aligned 'offset' issue is solved.

A slub buffer crossing two _contiguous_ pages should end up merged
as a multipage bvec. But I'm curious, what does adding multiple
contiguous pages to a bio actually break?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
