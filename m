Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDF6C3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 07:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B408214DA
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 07:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbfHVHYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 03:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57698 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbfHVHYP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Aug 2019 03:24:15 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 329B781F13;
        Thu, 22 Aug 2019 07:24:14 +0000 (UTC)
Received: from ming.t460p (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26A6560605;
        Thu, 22 Aug 2019 07:24:03 +0000 (UTC)
Date:   Thu, 22 Aug 2019 15:23:58 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Ming Lei <tom.leiming@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190822072351.GA5414@ming.t460p>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821232945.GC24904@infradead.org>
 <CACVXFVN93h7QrFvZNVQQwYZg_n0wGXwn=XZztMJrNbdjzzSpKQ@mail.gmail.com>
 <20190822044905.GU1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822044905.GU1119@dread.disaster.area>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 22 Aug 2019 07:24:14 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 02:49:05PM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2019 at 10:50:02AM +0800, Ming Lei wrote:
> > On Thu, Aug 22, 2019 at 8:06 AM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > On Wed, Aug 21, 2019 at 06:38:20PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > >
> > > > Add memory buffer alignment validation checks to bios built in XFS
> > > > to catch bugs that will result in silent data corruption in block
> > > > drivers that cannot handle unaligned memory buffers but don't
> > > > validate the incoming buffer alignment is correct.
> > > >
> > > > Known drivers with these issues are xenblk, brd and pmem.
> > > >
> > > > Despite there being nothing XFS specific to xfs_bio_add_page(), this
> > > > function was created to do the required validation because the block
> > > > layer developers that keep telling us that is not possible to
> > > > validate buffer alignment in bio_add_page(), and even if it was
> > > > possible it would be too much overhead to do at runtime.
> > >
> > > I really don't think we should life this to XFS, but instead fix it
> > > in the block layer.  And that is not only because I have a pending
> > > series lifting bits you are touching to the block layer..
> > >
> > > > +int
> > > > +xfs_bio_add_page(
> > > > +     struct bio      *bio,
> > > > +     struct page     *page,
> > > > +     unsigned int    len,
> > > > +     unsigned int    offset)
> > > > +{
> > > > +     struct request_queue    *q = bio->bi_disk->queue;
> > > > +     bool            same_page = false;
> > > > +
> > > > +     if (WARN_ON_ONCE(!blk_rq_aligned(q, len, offset)))
> > > > +             return -EIO;
> > > > +
> > > > +     if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
> > > > +             if (bio_full(bio, len))
> > > > +                     return 0;
> > > > +             __bio_add_page(bio, page, len, offset);
> > > > +     }
> > > > +     return len;
> > >
> > > I know Jens disagree, but with the amount of bugs we've been hitting
> > > thangs to slub (and I'm pretty sure we have a more hiding outside of
> > > XFS) I think we need to add the blk_rq_aligned check to bio_add_page.
> > 
> > It isn't correct to blk_rq_aligned() here because 'len' has to be logical block
> > size aligned, instead of DMA aligned only.
> 
> News to me.
> 
> AFAIA, the overall _IO_ that is being built needs to be a multiple
> of the logical block size in total size (i.e. bio->bi_iter.size)

Right.

> because sub sector IO is not allowed. But queue DMA limits are not
> defined in sectors - they define the scatter/gather DMA capability
> of the hardware, and that's what individual segments (bvecs) need to
> align to.  That's what blk_rq_aligned() checks here - that the bvec

Segment isn't same with bvec. We build segment via scatterlist interface
from bvecs in case that driver needs segment for DMA between CPU and
HBA. The built segment has to respect every kinds of queue limits.

Now there are two kinds of bio, one is called fs bio, the other one is
bio for doing IO from/to the device. Block layer splits fs bio into
bios with proper size for doing IO.

If one bvec is added with un-aligned length to fs bio, and if this bvec
can't be merged with the following ones, how can block layer handle that?
For example, this bvec is un-aligned with virt boundary, then one single
bio is allocated for doing IO of this bvec, then sub-sector IO is
generated.

> segment aligns to what the underlying driver(s) requires, not that
> the entire IO is sector sized and aligned.

Not every drivers need to handle segment, some drivers simply handle
single-page bvec(pmem, brd, zram, ...) or multi-page bvec(loop).

Then un-aligned bvec may cause trouble for drivers which single-page bvec.

> 
> Also, think about multipage bvecs - the pages we are spanning here
> are contiguous pages, so this should end up merging them and turning
> it into a single multipage bvec whose length is sector size
> aligned...

This way works for drivers which use segment, and most of drivers
belong to this type.

> 
> > Also not sure all users may setup bio->bi_disk well before adding page to bio,
> > since it is allowed to do that now.
> 
> XFS does, so I just don't care about random users of bio_add_page()
> in this patch. Somebody else can run the block layer gauntlet to get
> these checks moved into generic code and they've already been
> rejected twice as unnecessary.

If the check is to be added on bio_add_page(), every users have to be
audited.

> 
> > If slub buffer crosses two pages, block layer may not handle it at all
> > even though
> > un-aligned 'offset' issue is solved.
> 
> A slub buffer crossing two _contiguous_ pages should end up merged
> as a multipage bvec. But I'm curious, what does adding multiple
> contiguous pages to a bio actually break?

Some drivers don't or can't handle multi-page bvec, we have to split
it into single-page bvec, then un-aligned bvec is seen by this drivers.

thanks,
Ming
