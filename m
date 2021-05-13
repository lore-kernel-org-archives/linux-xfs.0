Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA2BC433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 00:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F6F613DF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 00:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhEMAPh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 20:15:37 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:51256 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231146AbhEMANc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 20:13:32 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5AC6480B220;
        Thu, 13 May 2021 10:12:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lgyxc-000JU7-FT; Thu, 13 May 2021 10:12:16 +1000
Date:   Thu, 13 May 2021 10:12:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/22] xfs: add a perag to the btree cursor
Message-ID: <20210513001216.GA2893@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-12-david@fromorbit.com>
 <20210512224006.GG8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512224006.GG8582@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=J43fAXQCTMVOTEh2Xd0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 03:40:06PM -0700, Darrick J. Wong wrote:
> On Thu, May 06, 2021 at 05:20:43PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Which will eventually completely replace the agno in it.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c          | 25 +++++++++++++++----------
> >  fs/xfs/libxfs/xfs_alloc_btree.c    | 13 ++++++++++---
> >  fs/xfs/libxfs/xfs_alloc_btree.h    |  3 ++-
> >  fs/xfs/libxfs/xfs_btree.c          |  2 ++
> >  fs/xfs/libxfs/xfs_btree.h          |  4 +++-
> >  fs/xfs/libxfs/xfs_ialloc.c         | 16 ++++++++--------
> >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 15 +++++++++++----
> >  fs/xfs/libxfs/xfs_ialloc_btree.h   |  7 ++++---
> >  fs/xfs/libxfs/xfs_refcount.c       |  4 ++--
> >  fs/xfs/libxfs/xfs_refcount_btree.c | 17 ++++++++++++-----
> >  fs/xfs/libxfs/xfs_refcount_btree.h |  2 +-
> >  fs/xfs/libxfs/xfs_rmap.c           |  6 +++---
> >  fs/xfs/libxfs/xfs_rmap_btree.c     | 17 ++++++++++++-----
> >  fs/xfs/libxfs/xfs_rmap_btree.h     |  2 +-
> >  fs/xfs/scrub/agheader_repair.c     | 20 +++++++++++---------
> >  fs/xfs/scrub/bmap.c                |  2 +-
> >  fs/xfs/scrub/common.c              | 12 ++++++------
> >  fs/xfs/scrub/repair.c              |  5 +++--
> >  fs/xfs/xfs_discard.c               |  2 +-
> >  fs/xfs/xfs_fsmap.c                 |  6 +++---
> >  fs/xfs/xfs_reflink.c               |  2 +-
> >  21 files changed, 112 insertions(+), 70 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index ce31c00dbf6f..7ec4af6bf494 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -776,7 +776,8 @@ xfs_alloc_cur_setup(
> >  	 */
> >  	if (!acur->cnt)
> >  		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
> > -					args->agbp, args->agno, XFS_BTNUM_CNT);
> > +						args->agbp, args->agno,
> > +						args->pag, XFS_BTNUM_CNT);
> 
> If we still have to pass the AG[FI] buffer into the _init_cursor
> functions, why not get the perag reference from the xfs_buf and
> eliminate the agno/pag parameter?  It looks like cursors get their own
> active reference to the perag, so I think only the _stage_cursor
> function needs to be passed a perag structure, right?

Because when I convert this to active/passive perag references, the
buffers only have a passive reference and they can't be converted to
active references.

Active references provide the barrier that prevents high
level code from accessing/entering the AG while a shrink (or other
offline type event) is in the process of tearing down that AG. The
process of tearing down the AG still may require the ability to
read/write to the AG metadata (e.g. checking the AG is fully
empty), so we still need the buffer cache to work while in this
transient offline state. Hence we need passive reference counts for
the buffers, because having cached buffers should not impact on the
functioning of the high level "don't use this AG anymore" barrier.

And when we finally got to tear down the perag, we have to tear down
the buffer cache for that AG, which means we have to wait until all
the buffers have been reclaimed. Which will release all the
references the buffers have on the perag, and so we know it is safe
to tear down the perag because both the active reference count and
the passive reference counts are zero.

IOWs, high level code needs an active reference for part of it's
operation, it needs an active reference that covers the entire
operation and this active reference has to be gained at a place
where it can fail safely (e.g. where AGs are iterated). If we try to
take an active reference from a buffer at random points in time,
we'll end up with failures to get active references in spots were we
cannot cleanly fail.

The example of xfs_allocbt_init_cursor() is that if could fail to
get an active reference from the agbp inside a transaction that has
already dirtied the AGFL. That then leads to an allocation failure
with a dirty transaction and a shutdown.....

Basically, we take an active reference when we start the high level
operation in an AG to protect it, and every other active reference
that the operation takes must be derived from that same perag
instance. Pulling the perag from the bp->b_pag pointer in high level
code is a layering vioaltion - the only time this should ever happen
is in IO verifiers where the passive buffer reference guarantees the
validity of the perag for the buffer cache callouts.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
