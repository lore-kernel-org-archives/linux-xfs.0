Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67188C00307
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 21:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 486442082C
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 21:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404373AbfIFVso (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Sep 2019 17:48:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404402AbfIFVso (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Sep 2019 17:48:44 -0400
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D193E36887
        for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2019 21:48:43 +0000 (UTC)
Received: by mail-oi1-f197.google.com with SMTP id 74so3565752oie.3
        for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2019 14:48:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2WJRsnFYnpcG/84+37k58Ernnh9jii5S94NsOJ3BU2I=;
        b=Nx8a76yLqOh81s6fRSHmTRxz2KbsMjLxoXWGY+L2v0BIroA+t0NFYIX67DY6haSBGb
         Qd2lkMOOPrBSXaESIJDKkLB6ICpITrXaEb0IlG01GSWhGh80T+Hxf49nroMN7/VKqxS6
         nefQqNe0Gt74MABAZYGkRlH3Cf+LV5aRb1fNeNPSOFS1Pc1irQs4LCqX2opdi7fBLVpU
         7FnTfhX2413v9PBPP4aluAdqO86bUefZGirzV9Zh26D1fw8qUTGK5LxhwQDrKW4WMK17
         wM2Er9DyPOWVxBbUWdclVgpTkrgn2enyJy77ULlgFsX2J++JcZodLde3KD5w94oO60KY
         fEGg==
X-Gm-Message-State: APjAAAWYiJf13xiI12YCgzXtPSvJwQBO92pWaH1m2c0VUUVHBaNA4/4r
        LDGmes0NSY8ZHoh2PtOVLz6+VUxN6sf0CNGAMBzQeba+DYPjZ9EYflGCT8BzcJWUlWK/jeY8aEp
        UjU4Uof4s62Rcd68cj9To9hhQPeVyDLQvt45g
X-Received: by 2002:aca:aa56:: with SMTP id t83mr8874745oie.178.1567806523101;
        Fri, 06 Sep 2019 14:48:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqye15i1gX9ZpzmamOPH9muPyVRWyZCi7G16OHNSbCrx+GNtAlQVhmii1YJoF0040MhZwNkhDvufnkahA0N59EU=
X-Received: by 2002:aca:aa56:: with SMTP id t83mr8874736oie.178.1567806522876;
 Fri, 06 Sep 2019 14:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190906205241.2292-1-agruenba@redhat.com> <20190906212758.GO1119@dread.disaster.area>
In-Reply-To: <20190906212758.GO1119@dread.disaster.area>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Fri, 6 Sep 2019 23:48:31 +0200
Message-ID: <CAHc6FU5BxOHkgHKKWTL7jFq0oL4TbAPpe49QDB6X35ndjYTWKQ@mail.gmail.com>
Subject: Re: [Q] gfs2: mmap write vs. punch_hole consistency
To:     Dave Chinner <david@fromorbit.com>
Cc:     cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Lukas Czerner <lczerner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 6, 2019 at 11:28 PM Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Sep 06, 2019 at 10:52:41PM +0200, Andreas Gruenbacher wrote:
> > Hi,
> >
> > I've just fixed a mmap write vs. truncate consistency issue on gfs on
> > filesystems with a block size smaller that the page size [1].
> >
> > It turns out that the same problem exists between mmap write and hole
> > punching, and since xfstests doesn't seem to cover that,
>
> AFAIA, fsx exercises it pretty often. Certainly it's found problems
> with XFS in the past w.r.t. these operations.
>
> > I've written a
> > new test [2].
>
> I suspect that what we really want is a test that runs
> _test_generic_punch using mmap rather than pwrite...
>
> > Ext4 and xfs both pass that test; they both apparently
> > mark the pages that have a hole punched in them as read-only so that
> > page_mkwrite is called before those pages can be written to again.
>
> XFS invalidates the range being hole punched (see
> xfs_flush_unmap_range() under XFS_MMAPLOCK_EXCL, which means any
> attempt to fault that page back in will block on the MMAPLOCK until
> the hole punch finishes.

This isn't about writes during the hole punching, this is about writes
once the hole is punched. For example, the test case I've posted
creates the following file layout with 1k blocksize:

  DDDD DDDD DDDD

Then it punches a hole like this:

  DDHH HHHH HHDD

Then it fills the hole again with mwrite:

  DDDD DDDD DDDD

As far as I can tell, that needs to trigger page faults on all three
pages. I did get these on ext4; judging from the fact that xfs works,
the also seem to occur there; but on gfs2, page_mkwrite isn't called
for the two partially mapped pages, only for the page in the middle
that's entirely within the hole. And I don't see where those pages are
marked read-only; it appears like pagecache_isize_extended isn't
called on ext4 or xfs. So how does this work there?

> > gfs2 fails that: for some reason, the partially block-mapped pages are
> > not marked read-only on gfs2, and so page_mkwrite is not called for the
> > partially block-mapped pages, and the hole is not filled in correctly.
> >
> > The attached patch fixes the problem, but this really doesn't look right
> > as neither ext4 nor xfs require this kind of hack.  So what am I
> > overlooking, how does this work on ext4 and xfs?
>
> XFS uses XFS_MMAPLOCK_* to serialise page faults against extent
> manipulations (shift, hole punch, truncate, swap, etc) and ext4 uses
> a similar locking mechanism to do the same thing. Fundamentally, the
> page cache does not provide the necessary mechanisms to detect and
> prevent invalidation races inside EOF....

Yes, but that unfortunately doesn't answer my question.

Thanks,
Andreas

> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/gfs2/bmap.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
> > index 9ef543dd38e2..e677e813be4c 100644
> > --- a/fs/gfs2/bmap.c
> > +++ b/fs/gfs2/bmap.c
> > @@ -2475,6 +2475,13 @@ int __gfs2_punch_hole(struct file *file, loff_t offset, loff_t length)
> >                       if (error)
> >                               goto out;
> >               }
> > +             /*
> > +              * If the first or last page partially lies in the hole, mark
> > +              * the page read-only so that memory-mapped writes will trigger
> > +              * page_mkwrite.
> > +              */
> > +             pagecache_isize_extended(inode, offset, inode->i_size);
> > +             pagecache_isize_extended(inode, offset + length, inode->i_size);
>
> See xfs_flush_unmap_range(), which is run under XFS_MMAPLOCK_EXCL
> to serialise against incoming page faults...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
