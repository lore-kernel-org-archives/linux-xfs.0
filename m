Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F1DC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 03:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C44613F7
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 03:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhEMDud (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 23:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhEMDud (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 23:50:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 664A261177;
        Thu, 13 May 2021 03:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620877762;
        bh=RDeR35u9L48H0t5JnywbCkXN9f7+o0Mul9Q7+MXvUQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bD7hLF4OAQHZP5BrqYb0xddZf/MYe2ddKqgnOIK/ShbOMwxIEQ8QvwtATt/XhQj5N
         nzb20Hs86YeoTgPCg4RhIhVQ/27BI/v1YiMCKObo8kgqNLHKnoyUqO1U44yJola9n7
         Mo0+g2fDNwT7XgFAZfX9jsGex+d2qBvMHBtLIip/iSM2Wo0sQJQBNd95mecg9bLyHP
         +eiB5E3PkfTUtWzofq1KLuqJsCmR63GtHuiTTBKlhbZ1SoUukhipNJhA7H7RLA7FZM
         zN2C2EHMyDLochqUKaplXeRa8rbanmd5wKQSACd8S1JfyDmmM8nwVUpbku3aXUr7yl
         UDFIhtvkbk7ag==
Date:   Wed, 12 May 2021 20:49:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/22] xfs: add a perag to the btree cursor
Message-ID: <20210513034921.GQ8582@magnolia>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-12-david@fromorbit.com>
 <20210512224006.GG8582@magnolia>
 <20210513001216.GA2893@dread.disaster.area>
 <20210513005508.GP8582@magnolia>
 <20210513010750.GC2893@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513010750.GC2893@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 13, 2021 at 11:07:50AM +1000, Dave Chinner wrote:
> On Wed, May 12, 2021 at 05:55:08PM -0700, Darrick J. Wong wrote:
> > On Thu, May 13, 2021 at 10:12:16AM +1000, Dave Chinner wrote:
> > > On Wed, May 12, 2021 at 03:40:06PM -0700, Darrick J. Wong wrote:
> > > > On Thu, May 06, 2021 at 05:20:43PM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > Which will eventually completely replace the agno in it.
> > > > > 
> > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_alloc.c          | 25 +++++++++++++++----------
> > > > >  fs/xfs/libxfs/xfs_alloc_btree.c    | 13 ++++++++++---
> > > > >  fs/xfs/libxfs/xfs_alloc_btree.h    |  3 ++-
> > > > >  fs/xfs/libxfs/xfs_btree.c          |  2 ++
> > > > >  fs/xfs/libxfs/xfs_btree.h          |  4 +++-
> > > > >  fs/xfs/libxfs/xfs_ialloc.c         | 16 ++++++++--------
> > > > >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 15 +++++++++++----
> > > > >  fs/xfs/libxfs/xfs_ialloc_btree.h   |  7 ++++---
> > > > >  fs/xfs/libxfs/xfs_refcount.c       |  4 ++--
> > > > >  fs/xfs/libxfs/xfs_refcount_btree.c | 17 ++++++++++++-----
> > > > >  fs/xfs/libxfs/xfs_refcount_btree.h |  2 +-
> > > > >  fs/xfs/libxfs/xfs_rmap.c           |  6 +++---
> > > > >  fs/xfs/libxfs/xfs_rmap_btree.c     | 17 ++++++++++++-----
> > > > >  fs/xfs/libxfs/xfs_rmap_btree.h     |  2 +-
> > > > >  fs/xfs/scrub/agheader_repair.c     | 20 +++++++++++---------
> > > > >  fs/xfs/scrub/bmap.c                |  2 +-
> > > > >  fs/xfs/scrub/common.c              | 12 ++++++------
> > > > >  fs/xfs/scrub/repair.c              |  5 +++--
> > > > >  fs/xfs/xfs_discard.c               |  2 +-
> > > > >  fs/xfs/xfs_fsmap.c                 |  6 +++---
> > > > >  fs/xfs/xfs_reflink.c               |  2 +-
> > > > >  21 files changed, 112 insertions(+), 70 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > > > index ce31c00dbf6f..7ec4af6bf494 100644
> > > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > > > @@ -776,7 +776,8 @@ xfs_alloc_cur_setup(
> > > > >  	 */
> > > > >  	if (!acur->cnt)
> > > > >  		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
> > > > > -					args->agbp, args->agno, XFS_BTNUM_CNT);
> > > > > +						args->agbp, args->agno,
> > > > > +						args->pag, XFS_BTNUM_CNT);
> > > > 
> > > > If we still have to pass the AG[FI] buffer into the _init_cursor
> > > > functions, why not get the perag reference from the xfs_buf and
> > > > eliminate the agno/pag parameter?  It looks like cursors get their own
> > > > active reference to the perag, so I think only the _stage_cursor
> > > > function needs to be passed a perag structure, right?
> > > 
> > > Because when I convert this to active/passive perag references, the
> > > buffers only have a passive reference and they can't be converted to
> > > active references.
> > >
> > > Active references provide the barrier that prevents high
> > > level code from accessing/entering the AG while a shrink (or other
> > > offline type event) is in the process of tearing down that AG. The
> > > process of tearing down the AG still may require the ability to
> > > read/write to the AG metadata (e.g. checking the AG is fully
> > > empty), so we still need the buffer cache to work while in this
> > > transient offline state. Hence we need passive reference counts for
> > > the buffers, because having cached buffers should not impact on the
> > > functioning of the high level "don't use this AG anymore" barrier.
> > 
> > Agreed; it's past time to shift the world towards the idea that one
> > grabs the incore object and only then starts grabbing buffers.  But even
> > if you've done it correctly:
> > 
> > 	pag = xfs_perag_get_active(agno);
> > 	xfs_alloc_read_agf(tp, ..., &agfbp);
> > 
> > Why not pass in just the buffer?
> > 
> > 	cur = xfs_rmapbt_init_cursor(tp, agfbp, pag);
> > 
> > Is the idea here simply that we don't want to give people the idea that
> > they can just read the agf and pass it to xfs_rmapbt_init_cursor?  In
> > other words, the third parameter is there to give the people the
> > impression that pag and agfbp are both equally important tokens, and
> > that callers must obtain both and pass them in?
> 
> I'm angling to hide the agfbp entirely here - move the allocation
> serialisation to the perag using a mutex rwsem, not the AGF buffer.
> We don't actually need the AGF until we have to modify it, so it's
> lock hold time during allocation can be cut way down if it is not
> used to serialise the entire allocation operation. This would also
> get us lockdep coverage for agi/agf locking, etc.

Hmmm.  Recently I've been wrangling with a concurrency problem between
scrub and io threads running a series of different AG btree updates
(e.g. bunmap, which runs a deferred rmap-delete and then a deferred
refcount-decrease).  Because the only way we serialize access to the AGs
is through the AG buffer locks and we don't maintain that lock across
the transaction roll between defer items, it's possible that scrub can
step in and grab the buffer lock between items, which it then marks as
cross-reference corruption because the number of rmaps for a given block
doesn't match the number of references in the refcount btree.  The log
intent items guarantee consistency (and the defer items are queue in the
correct order to avoid accidental freeing) but this is suboptimal.

Right now I've "fixed" it by adding a per-ag counter of pending intents
and adapting scrub to lock the AG buffers, check the counter, and if
it's nonzero, it'll cycle the buffers and try again.  This works, but
it's a little silly.  Depending on how the AG mutex works, this could
fix that problem for scrub.

> Also, I'm intending that the perag init functions which currently
> take a agno and then do a lookup for the perag to initialise it will
> take a perag, not a agno. We almost always already have the perag
> when we do a buffer read to initialise the perag...

<nod>

> > No monkeying around
> > with the buffer's passive reference by higher level code, at all, ever?
> 
> Except in the buffer cache itself or callouts directly from the
> buffer cache that operation under the buffer's existence guarantee
> for the perag.

Got it.

> > I guess I can live with that.  I might just be micro-optimising function
> > call parameter counts.  :P
> 
> Oh, I'm planning on chopping them down, but going the other way.
> Cache the ag bps in the perag so we don't ahve to do buffer cache
> lookups to find them, nor do we have to pass them around anywhere
> that we pass a perag....

That's gonna hurt on explodefs filesystems with a million AGs... ;)

Ok, I'm satisfied.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
