Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EDDC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 05:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357825AbiD0FvM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 01:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345102AbiD0FvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 01:51:11 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C60421804
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 22:48:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C5DFD10E5E76;
        Wed, 27 Apr 2022 15:47:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njaWr-0052WS-M6; Wed, 27 Apr 2022 15:47:57 +1000
Date:   Wed, 27 Apr 2022 15:47:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: intent item whiteouts
Message-ID: <20220427054757.GO1098723@dread.disaster.area>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-9-david@fromorbit.com>
 <20220427033252.GH17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427033252.GH17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6268d910
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ilbA9Ygaj215wBof9c4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 08:32:52PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 27, 2022 at 12:22:59PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we log modifications based on intents, we add both intent
> > and intent done items to the modification being made. These get
> > written to the log to ensure that the operation is re-run if the
> > intent done is not found in the log.
> > 
> > However, for operations that complete wholly within a single
> > checkpoint, the change in the checkpoint is atomic and will never
> > need replay. In this case, we don't need to actually write the
> > intent and intent done items to the journal because log recovery
> > will never need to manually restart this modification.
> > 
> > Log recovery currently handles intent/intent done matching by
> > inserting the intent into the AIL, then removing it when a matching
> > intent done item is found. Hence for all the intent-based operations
> > that complete within a checkpoint, we spend all that time parsing
> > the intent/intent done items just to cancel them and do nothing with
> > them.
> > 
> > Hence it follows that the only time we actually need intents in the
> > log is when the modification crosses checkpoint boundaries in the
> > log and so may only be partially complete in the journal. Hence if
> > we commit and intent done item to the CIL and the intent item is in
> > the same checkpoint, we don't actually have to write them to the
> > journal because log recovery will always cancel the intents.
> > 
> > We've never really worried about the overhead of logging intents
> > unnecessarily like this because the intents we log are generally
> > very much smaller than the change being made. e.g. freeing an extent
> > involves modifying at lease two freespace btree blocks and the AGF,
> > so the EFI/EFD overhead is only a small increase in space and
> > processing time compared to the overall cost of freeing an extent.
> 
> Question: If we whiteout enough intent items, does that make it possible
> to cram more updates into a checkpoint?

Yes - we release the space the cancelled intent pair used from the
ctx->space_used counter that tracks the size of the CIL checkpoint.

> Are changes required to the existing intent item code to support
> whiteouts, or does the log code autodetect an *I/*D pair in the same
> checkpoint and elide them automatically?

The log code automagically detects it. That's what the ->iop_intent
op is for - when a done intent committed, it looks up it's intent
pair via ->iop_intent and then checks if it is in the current
checkpoint via xlog_item_in_current_chkpt() and if that returns true
then we place a whiteout on the intent and release the space it
consumes.

We don't cull the intent from the CIL until the context checkpoint
commits - we could remove it immediately, but then when the CIL
scalability code gets placed on top of this we can't remove log
items from the per-cpu CIL in transaction commit context and so we
have to use whiteouts to delay removal to the push context. So I
just implemented it that way to start with....

> (I might be fishing here for "Does this make generic/447 faster when it
> deletes the million extents?")

I think it knocks it down a little - maybe 10%? One machine would
appear to drop 126->116s, another it is 52->48s.

The intents are generally tiny compared to the rest of the changes
being (re-)logged, so I'm not expecting miracles for the
rmap/reflink code. The big wins come when intents contain large
chunks of data...

> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 59aa5f9bf769..670d074a71cc 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -39,6 +39,7 @@ STATIC void
> >  xfs_bui_item_free(
> >  	struct xfs_bui_log_item	*buip)
> >  {
> > +	kmem_free(buip->bui_item.li_lv_shadow);
> 
> Why is it necessary for log items to free their own shadow buffer?

Twisty unpin passages...

Intents with whiteouts on them were leaking them when they
were unpinned from the whiteout list in xlog_cil_push_work(). The
log vectors no longer get attached to the CIL context and freed
via xlog_cil_committed()->xlog_cil_free_logvec(), and so when they
are unpinned by xlog_cil_push_work() the last reference is released
and we have to free the log vector attached to the item as it is
still attached.

The reason we can't do it directly from ->iop_unpin() is that we
also call ->iop_unpin from xlog_cil_committed()->
xfs_trans_committed_bulk(), and if we are aborting there we do not
want to free the shadow buffer because it is still linked into the
lv chain attached to the CIL ctx and will get freed once
xfs_trans_committed_bulk() returns....

> > @@ -1393,7 +1463,11 @@ xlog_cil_commit(
> >  	/* lock out background commit */
> >  	down_read(&cil->xc_ctx_lock);
> >  
> > -	xlog_cil_insert_items(log, tp);
> > +	if (tp->t_flags & XFS_TRANS_HAS_INTENT_DONE)
> > +		released_space = xlog_cil_process_intents(cil, tp);
> > +
> > +	xlog_cil_insert_items(log, tp, released_space);
> > +	tp->t_ticket->t_curr_res += released_space;
> 
> I'm a little tired, so why isn't this adjustment a part of
> xlog_cil_insert_items?  A similar adjustment is made to
> ctx->space_used to release the unused space back to the committing tx,
> right?

Probably because it was a bug fix I added at some point and not
original code....

I'm not fussed where it ends up - I can move it if you want.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
