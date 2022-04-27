Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815C3C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 17:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244082AbiD0RfS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 13:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244322AbiD0RfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 13:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33C120A400
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 10:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F485B826BD
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 17:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB2CC385AF;
        Wed, 27 Apr 2022 17:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651080706;
        bh=IVj8WXNwduUgVWXc4WCujJmEclktk3zVNLJ65zdHI+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SdFYmcwAgk2v14/8ZhxWyXsdwhiVq1+ZVZ6rXTvcnzqRk6D868wMSZNLp+xc8pfcP
         Ebj6sTZqmCVBC3RkNmIXPpeHraj0iX1OwIrXAbzNyQb61foBtOswRCPg6XGmAeSzUi
         sO+oRVw1+uHKnIZx+AQhOFJ3a3HNtU6BBGnqvs2T2B7x1qqluPVGi6YSOZb9zyCK5J
         5AHpbkZ4gQ4J0M9WXA8PJ0YTB9+EZ6PKYDj+H33LjyMsqSFoUL7mCZVlmOLLAQU+Bd
         xgUAm3gaNv1dcStg3/y/2EbEQc6a9gTp5LCUKIl8pwHtOQ8DhK1iisYaobf/6SGgwJ
         F8WxRFCWTSaMQ==
Date:   Wed, 27 Apr 2022 10:31:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: intent item whiteouts
Message-ID: <20220427173145.GK17059@magnolia>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-9-david@fromorbit.com>
 <20220427033252.GH17025@magnolia>
 <20220427054757.GO1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427054757.GO1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 03:47:57PM +1000, Dave Chinner wrote:
> On Tue, Apr 26, 2022 at 08:32:52PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 27, 2022 at 12:22:59PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When we log modifications based on intents, we add both intent
> > > and intent done items to the modification being made. These get
> > > written to the log to ensure that the operation is re-run if the
> > > intent done is not found in the log.
> > > 
> > > However, for operations that complete wholly within a single
> > > checkpoint, the change in the checkpoint is atomic and will never
> > > need replay. In this case, we don't need to actually write the
> > > intent and intent done items to the journal because log recovery
> > > will never need to manually restart this modification.
> > > 
> > > Log recovery currently handles intent/intent done matching by
> > > inserting the intent into the AIL, then removing it when a matching
> > > intent done item is found. Hence for all the intent-based operations
> > > that complete within a checkpoint, we spend all that time parsing
> > > the intent/intent done items just to cancel them and do nothing with
> > > them.
> > > 
> > > Hence it follows that the only time we actually need intents in the
> > > log is when the modification crosses checkpoint boundaries in the
> > > log and so may only be partially complete in the journal. Hence if
> > > we commit and intent done item to the CIL and the intent item is in
> > > the same checkpoint, we don't actually have to write them to the
> > > journal because log recovery will always cancel the intents.
> > > 
> > > We've never really worried about the overhead of logging intents
> > > unnecessarily like this because the intents we log are generally
> > > very much smaller than the change being made. e.g. freeing an extent
> > > involves modifying at lease two freespace btree blocks and the AGF,
> > > so the EFI/EFD overhead is only a small increase in space and
> > > processing time compared to the overall cost of freeing an extent.
> > 
> > Question: If we whiteout enough intent items, does that make it possible
> > to cram more updates into a checkpoint?
> 
> Yes - we release the space the cancelled intent pair used from the
> ctx->space_used counter that tracks the size of the CIL checkpoint.

<nod> Good, that's what I was thinking.

> > Are changes required to the existing intent item code to support
> > whiteouts, or does the log code autodetect an *I/*D pair in the same
> > checkpoint and elide them automatically?
> 
> The log code automagically detects it. That's what the ->iop_intent
> op is for - when a done intent committed, it looks up it's intent
> pair via ->iop_intent and then checks if it is in the current
> checkpoint via xlog_item_in_current_chkpt() and if that returns true
> then we place a whiteout on the intent and release the space it
> consumes.
> 
> We don't cull the intent from the CIL until the context checkpoint
> commits - we could remove it immediately, but then when the CIL
> scalability code gets placed on top of this we can't remove log
> items from the per-cpu CIL in transaction commit context and so we
> have to use whiteouts to delay removal to the push context. So I
> just implemented it that way to start with....

<nod> Sounds reasonable to me.

> > (I might be fishing here for "Does this make generic/447 faster when it
> > deletes the million extents?")
> 
> I think it knocks it down a little - maybe 10%? One machine would
> appear to drop 126->116s, another it is 52->48s.
> 
> The intents are generally tiny compared to the rest of the changes
> being (re-)logged, so I'm not expecting miracles for the
> rmap/reflink code. The big wins come when intents contain large
> chunks of data...

I'll take a 10% win. :)

> > > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > > index 59aa5f9bf769..670d074a71cc 100644
> > > --- a/fs/xfs/xfs_bmap_item.c
> > > +++ b/fs/xfs/xfs_bmap_item.c
> > > @@ -39,6 +39,7 @@ STATIC void
> > >  xfs_bui_item_free(
> > >  	struct xfs_bui_log_item	*buip)
> > >  {
> > > +	kmem_free(buip->bui_item.li_lv_shadow);
> > 
> > Why is it necessary for log items to free their own shadow buffer?
> 
> Twisty unpin passages...
> 
> Intents with whiteouts on them were leaking them when they
> were unpinned from the whiteout list in xlog_cil_push_work(). The
> log vectors no longer get attached to the CIL context and freed
> via xlog_cil_committed()->xlog_cil_free_logvec(), and so when they
> are unpinned by xlog_cil_push_work() the last reference is released
> and we have to free the log vector attached to the item as it is
> still attached.
> 
> The reason we can't do it directly from ->iop_unpin() is that we
> also call ->iop_unpin from xlog_cil_committed()->
> xfs_trans_committed_bulk(), and if we are aborting there we do not
> want to free the shadow buffer because it is still linked into the
> lv chain attached to the CIL ctx and will get freed once
> xfs_trans_committed_bulk() returns....

Huh.  So now that I'm more awake, I noticed that you didn't patch
xfs_extfree_item.c to free the shadow buffers because the
xfs_ef[id]_item_free functions already have code to free the shadow
buffer.  git blame says that was added in:

b1c5ebb21301 ("xfs: allocate log vector buffers outside CIL context lock")

This commit was added in 4.8-rc1, and just prior to merging the rmap
patches.

When do log intent items get shadow buffers, since they should only be
committed once?  Looking at that old commit, I think what's going on is
that we preallocate the shadow buffers for every log item at commit time
to avoid a memory allocation when we have the ctx lock, so now it's
necessary for all log intent items to free them?

Does that mean RUI/CUI/BUI log items could have been leaking shadow
buffers since the beginning, and we just haven't noticed because the CIL
has freed them for us?  Which means that the changes to xfs_*_item.c
could, in theory, be a separate patch that fixes a theoretical memory
leak?

(I'm not asking for you to separate the changes; I'm checking my
understanding of something that caused me to go "Eh???" on first
reading.)

> > > @@ -1393,7 +1463,11 @@ xlog_cil_commit(
> > >  	/* lock out background commit */
> > >  	down_read(&cil->xc_ctx_lock);
> > >  
> > > -	xlog_cil_insert_items(log, tp);
> > > +	if (tp->t_flags & XFS_TRANS_HAS_INTENT_DONE)
> > > +		released_space = xlog_cil_process_intents(cil, tp);
> > > +
> > > +	xlog_cil_insert_items(log, tp, released_space);
> > > +	tp->t_ticket->t_curr_res += released_space;
> > 
> > I'm a little tired, so why isn't this adjustment a part of
> > xlog_cil_insert_items?  A similar adjustment is made to
> > ctx->space_used to release the unused space back to the committing tx,
> > right?
> 
> Probably because it was a bug fix I added at some point and not
> original code....
> 
> I'm not fussed where it ends up - I can move it if you want.

Yes please, since xlog_cil_insert_items already adjusts
tp->t_ticket->t_curr_res and it would seem to make more sense to keep
all those adjustments together.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
