Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E44C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 00:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 675DA613FC
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 00:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhEMA4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 20:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235082AbhEMA4S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 20:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D962661108;
        Thu, 13 May 2021 00:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620867310;
        bh=krY3Gty/m0WIZc9Jh+tRU8uQwY2FQ+WaFlK29F31YGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U4YnyYfrjGZ1ytsGUlYt8KHQrp23QdyGopTgmhQtM0ymWVdhwo1Z15jbZhL4r7Ily
         NzE8jLukPSk2DDdgYnv+rLPX5bHyuVqZUyBlHRfy8062S9WDAf3Gs3BZbDTvwHZQzc
         POyYUG9avIjL+fXLH5cvB1X2ROiulVZP4A5ZYEj0kpCi6zvQFbRfFjVH3IUBTLvVDK
         FpY1/oW2pcfUGmklUjuzFoGMBZa8W0DmU9g7TFr2ap8eY0XOIf93P64tdzE6nT3zIc
         c4N2c/minYtrUwp8CtJemXDy3JPCfS5+Lwq7KeE5CMTLQYtSzJThYCKFBc0i9UaJGm
         EyStJKhJZ7dHg==
Date:   Wed, 12 May 2021 17:55:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/22] xfs: add a perag to the btree cursor
Message-ID: <20210513005508.GP8582@magnolia>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-12-david@fromorbit.com>
 <20210512224006.GG8582@magnolia>
 <20210513001216.GA2893@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513001216.GA2893@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 13, 2021 at 10:12:16AM +1000, Dave Chinner wrote:
> On Wed, May 12, 2021 at 03:40:06PM -0700, Darrick J. Wong wrote:
> > On Thu, May 06, 2021 at 05:20:43PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Which will eventually completely replace the agno in it.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c          | 25 +++++++++++++++----------
> > >  fs/xfs/libxfs/xfs_alloc_btree.c    | 13 ++++++++++---
> > >  fs/xfs/libxfs/xfs_alloc_btree.h    |  3 ++-
> > >  fs/xfs/libxfs/xfs_btree.c          |  2 ++
> > >  fs/xfs/libxfs/xfs_btree.h          |  4 +++-
> > >  fs/xfs/libxfs/xfs_ialloc.c         | 16 ++++++++--------
> > >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 15 +++++++++++----
> > >  fs/xfs/libxfs/xfs_ialloc_btree.h   |  7 ++++---
> > >  fs/xfs/libxfs/xfs_refcount.c       |  4 ++--
> > >  fs/xfs/libxfs/xfs_refcount_btree.c | 17 ++++++++++++-----
> > >  fs/xfs/libxfs/xfs_refcount_btree.h |  2 +-
> > >  fs/xfs/libxfs/xfs_rmap.c           |  6 +++---
> > >  fs/xfs/libxfs/xfs_rmap_btree.c     | 17 ++++++++++++-----
> > >  fs/xfs/libxfs/xfs_rmap_btree.h     |  2 +-
> > >  fs/xfs/scrub/agheader_repair.c     | 20 +++++++++++---------
> > >  fs/xfs/scrub/bmap.c                |  2 +-
> > >  fs/xfs/scrub/common.c              | 12 ++++++------
> > >  fs/xfs/scrub/repair.c              |  5 +++--
> > >  fs/xfs/xfs_discard.c               |  2 +-
> > >  fs/xfs/xfs_fsmap.c                 |  6 +++---
> > >  fs/xfs/xfs_reflink.c               |  2 +-
> > >  21 files changed, 112 insertions(+), 70 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index ce31c00dbf6f..7ec4af6bf494 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -776,7 +776,8 @@ xfs_alloc_cur_setup(
> > >  	 */
> > >  	if (!acur->cnt)
> > >  		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
> > > -					args->agbp, args->agno, XFS_BTNUM_CNT);
> > > +						args->agbp, args->agno,
> > > +						args->pag, XFS_BTNUM_CNT);
> > 
> > If we still have to pass the AG[FI] buffer into the _init_cursor
> > functions, why not get the perag reference from the xfs_buf and
> > eliminate the agno/pag parameter?  It looks like cursors get their own
> > active reference to the perag, so I think only the _stage_cursor
> > function needs to be passed a perag structure, right?
> 
> Because when I convert this to active/passive perag references, the
> buffers only have a passive reference and they can't be converted to
> active references.
>
> Active references provide the barrier that prevents high
> level code from accessing/entering the AG while a shrink (or other
> offline type event) is in the process of tearing down that AG. The
> process of tearing down the AG still may require the ability to
> read/write to the AG metadata (e.g. checking the AG is fully
> empty), so we still need the buffer cache to work while in this
> transient offline state. Hence we need passive reference counts for
> the buffers, because having cached buffers should not impact on the
> functioning of the high level "don't use this AG anymore" barrier.

Agreed; it's past time to shift the world towards the idea that one
grabs the incore object and only then starts grabbing buffers.  But even
if you've done it correctly:

	pag = xfs_perag_get_active(agno);
	xfs_alloc_read_agf(tp, ..., &agfbp);

Why not pass in just the buffer?

	cur = xfs_rmapbt_init_cursor(tp, agfbp, pag);

Is the idea here simply that we don't want to give people the idea that
they can just read the agf and pass it to xfs_rmapbt_init_cursor?  In
other words, the third parameter is there to give the people the
impression that pag and agfbp are both equally important tokens, and
that callers must obtain both and pass them in?  No monkeying around
with the buffer's passive reference by higher level code, at all, ever?
I guess I can live with that.  I might just be micro-optimising function
call parameter counts.  :P

--D

> And when we finally got to tear down the perag, we have to tear down
> the buffer cache for that AG, which means we have to wait until all
> the buffers have been reclaimed. Which will release all the
> references the buffers have on the perag, and so we know it is safe
> to tear down the perag because both the active reference count and
> the passive reference counts are zero.
> 
> IOWs, high level code needs an active reference for part of it's
> operation, it needs an active reference that covers the entire
> operation and this active reference has to be gained at a place
> where it can fail safely (e.g. where AGs are iterated). If we try to
> take an active reference from a buffer at random points in time,
> we'll end up with failures to get active references in spots were we
> cannot cleanly fail.
> 
> The example of xfs_allocbt_init_cursor() is that if could fail to
> get an active reference from the agbp inside a transaction that has
> already dirtied the AGFL. That then leads to an allocation failure
> with a dirty transaction and a shutdown.....
> 
> Basically, we take an active reference when we start the high level
> operation in an AG to protect it, and every other active reference
> that the operation takes must be derived from that same perag
> instance. Pulling the perag from the bp->b_pag pointer in high level
> code is a layering vioaltion - the only time this should ever happen
> is in IO verifiers where the passive buffer reference guarantees the
> validity of the perag for the buffer cache callouts.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
