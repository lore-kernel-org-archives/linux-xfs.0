Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B62C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17C89613C8
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbhEMBJK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 21:09:10 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:50280 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238669AbhEMBJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 21:09:09 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 1666380BA2D;
        Thu, 13 May 2021 11:07:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lgzpO-000KPu-QT; Thu, 13 May 2021 11:07:50 +1000
Date:   Thu, 13 May 2021 11:07:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/22] xfs: add a perag to the btree cursor
Message-ID: <20210513010750.GC2893@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-12-david@fromorbit.com>
 <20210512224006.GG8582@magnolia>
 <20210513001216.GA2893@dread.disaster.area>
 <20210513005508.GP8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513005508.GP8582@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=TZQhTcXLIBDkBYuFwvcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 05:55:08PM -0700, Darrick J. Wong wrote:
> On Thu, May 13, 2021 at 10:12:16AM +1000, Dave Chinner wrote:
> > On Wed, May 12, 2021 at 03:40:06PM -0700, Darrick J. Wong wrote:
> > > On Thu, May 06, 2021 at 05:20:43PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Which will eventually completely replace the agno in it.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_alloc.c          | 25 +++++++++++++++----------
> > > >  fs/xfs/libxfs/xfs_alloc_btree.c    | 13 ++++++++++---
> > > >  fs/xfs/libxfs/xfs_alloc_btree.h    |  3 ++-
> > > >  fs/xfs/libxfs/xfs_btree.c          |  2 ++
> > > >  fs/xfs/libxfs/xfs_btree.h          |  4 +++-
> > > >  fs/xfs/libxfs/xfs_ialloc.c         | 16 ++++++++--------
> > > >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 15 +++++++++++----
> > > >  fs/xfs/libxfs/xfs_ialloc_btree.h   |  7 ++++---
> > > >  fs/xfs/libxfs/xfs_refcount.c       |  4 ++--
> > > >  fs/xfs/libxfs/xfs_refcount_btree.c | 17 ++++++++++++-----
> > > >  fs/xfs/libxfs/xfs_refcount_btree.h |  2 +-
> > > >  fs/xfs/libxfs/xfs_rmap.c           |  6 +++---
> > > >  fs/xfs/libxfs/xfs_rmap_btree.c     | 17 ++++++++++++-----
> > > >  fs/xfs/libxfs/xfs_rmap_btree.h     |  2 +-
> > > >  fs/xfs/scrub/agheader_repair.c     | 20 +++++++++++---------
> > > >  fs/xfs/scrub/bmap.c                |  2 +-
> > > >  fs/xfs/scrub/common.c              | 12 ++++++------
> > > >  fs/xfs/scrub/repair.c              |  5 +++--
> > > >  fs/xfs/xfs_discard.c               |  2 +-
> > > >  fs/xfs/xfs_fsmap.c                 |  6 +++---
> > > >  fs/xfs/xfs_reflink.c               |  2 +-
> > > >  21 files changed, 112 insertions(+), 70 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > > index ce31c00dbf6f..7ec4af6bf494 100644
> > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > > @@ -776,7 +776,8 @@ xfs_alloc_cur_setup(
> > > >  	 */
> > > >  	if (!acur->cnt)
> > > >  		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
> > > > -					args->agbp, args->agno, XFS_BTNUM_CNT);
> > > > +						args->agbp, args->agno,
> > > > +						args->pag, XFS_BTNUM_CNT);
> > > 
> > > If we still have to pass the AG[FI] buffer into the _init_cursor
> > > functions, why not get the perag reference from the xfs_buf and
> > > eliminate the agno/pag parameter?  It looks like cursors get their own
> > > active reference to the perag, so I think only the _stage_cursor
> > > function needs to be passed a perag structure, right?
> > 
> > Because when I convert this to active/passive perag references, the
> > buffers only have a passive reference and they can't be converted to
> > active references.
> >
> > Active references provide the barrier that prevents high
> > level code from accessing/entering the AG while a shrink (or other
> > offline type event) is in the process of tearing down that AG. The
> > process of tearing down the AG still may require the ability to
> > read/write to the AG metadata (e.g. checking the AG is fully
> > empty), so we still need the buffer cache to work while in this
> > transient offline state. Hence we need passive reference counts for
> > the buffers, because having cached buffers should not impact on the
> > functioning of the high level "don't use this AG anymore" barrier.
> 
> Agreed; it's past time to shift the world towards the idea that one
> grabs the incore object and only then starts grabbing buffers.  But even
> if you've done it correctly:
> 
> 	pag = xfs_perag_get_active(agno);
> 	xfs_alloc_read_agf(tp, ..., &agfbp);
> 
> Why not pass in just the buffer?
> 
> 	cur = xfs_rmapbt_init_cursor(tp, agfbp, pag);
> 
> Is the idea here simply that we don't want to give people the idea that
> they can just read the agf and pass it to xfs_rmapbt_init_cursor?  In
> other words, the third parameter is there to give the people the
> impression that pag and agfbp are both equally important tokens, and
> that callers must obtain both and pass them in?

I'm angling to hide the agfbp entirely here - move the allocation
serialisation to the perag using a mutex rwsem, not the AGF buffer.
We don't actually need the AGF until we have to modify it, so it's
lock hold time during allocation can be cut way down if it is not
used to serialise the entire allocation operation. This would also
get us lockdep coverage for agi/agf locking, etc.

Also, I'm intending that the perag init functions which currently
take a agno and then do a lookup for the perag to initialise it will
take a perag, not a agno. We almost always already have the perag
when we do a buffer read to initialise the perag...

> No monkeying around
> with the buffer's passive reference by higher level code, at all, ever?

Except in the buffer cache itself or callouts directly from the
buffer cache that operation under the buffer's existence guarantee
for the perag.

> I guess I can live with that.  I might just be micro-optimising function
> call parameter counts.  :P

Oh, I'm planning on chopping them down, but going the other way.
Cache the ag bps in the perag so we don't ahve to do buffer cache
lookups to find them, nor do we have to pass them around anywhere
that we pass a perag....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
