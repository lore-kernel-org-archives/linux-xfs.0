Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907B0C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 22:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbiD0WIc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 18:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbiD0WIX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 18:08:23 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C035D617A
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 15:05:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B5BBB538C46;
        Thu, 28 Apr 2022 08:05:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njpmW-005JHZ-Cb; Thu, 28 Apr 2022 08:05:08 +1000
Date:   Thu, 28 Apr 2022 08:05:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: intent item whiteouts
Message-ID: <20220427220508.GQ1098723@dread.disaster.area>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-9-david@fromorbit.com>
 <20220427033252.GH17025@magnolia>
 <20220427054757.GO1098723@dread.disaster.area>
 <20220427173145.GK17059@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427173145.GK17059@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6269be16
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=zJvIgNVzU3aL44b28H4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 10:31:45AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 27, 2022 at 03:47:57PM +1000, Dave Chinner wrote:
> > > > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > > > index 59aa5f9bf769..670d074a71cc 100644
> > > > --- a/fs/xfs/xfs_bmap_item.c
> > > > +++ b/fs/xfs/xfs_bmap_item.c
> > > > @@ -39,6 +39,7 @@ STATIC void
> > > >  xfs_bui_item_free(
> > > >  	struct xfs_bui_log_item	*buip)
> > > >  {
> > > > +	kmem_free(buip->bui_item.li_lv_shadow);
> > > 
> > > Why is it necessary for log items to free their own shadow buffer?
> > 
> > Twisty unpin passages...
> > 
> > Intents with whiteouts on them were leaking them when they
> > were unpinned from the whiteout list in xlog_cil_push_work(). The
> > log vectors no longer get attached to the CIL context and freed
> > via xlog_cil_committed()->xlog_cil_free_logvec(), and so when they
> > are unpinned by xlog_cil_push_work() the last reference is released
> > and we have to free the log vector attached to the item as it is
> > still attached.
> > 
> > The reason we can't do it directly from ->iop_unpin() is that we
> > also call ->iop_unpin from xlog_cil_committed()->
> > xfs_trans_committed_bulk(), and if we are aborting there we do not
> > want to free the shadow buffer because it is still linked into the
> > lv chain attached to the CIL ctx and will get freed once
> > xfs_trans_committed_bulk() returns....
> 
> Huh.  So now that I'm more awake, I noticed that you didn't patch
> xfs_extfree_item.c to free the shadow buffers because the
> xfs_ef[id]_item_free functions already have code to free the shadow
> buffer.  git blame says that was added in:
> 
> b1c5ebb21301 ("xfs: allocate log vector buffers outside CIL context lock")
> 
> This commit was added in 4.8-rc1, and just prior to merging the rmap
> patches.

Right - that was the commit that introduced the shadow buffers...

> When do log intent items get shadow buffers, since they should only be
> committed once?  Looking at that old commit, I think what's going on is
> that we preallocate the shadow buffers for every log item at commit time
> to avoid a memory allocation when we have the ctx lock,

Yes.

> so now it's
> necessary for all log intent items to free them?

Ever since commit b1c5ebb21301 it's been necessary in certain
situations. Not just for intents, but for all log items that are
logged to the journal. i.e. inode, dquot and buffer log items free
li_lv_shadow in their destroy routines.

Essentially, until the last reference to the log item goes away, we
don't know if the CIL holds the other reference to the log item and
so may be actively using the shadow buffer. Hence the only time it
is actually safe to free the shadow buffer is when there are no
remaining references to the log item.

> Does that mean RUI/CUI/BUI log items could have been leaking shadow
> buffers since the beginning, and we just haven't noticed because the CIL
> has freed them for us?  Which means that the changes to xfs_*_item.c
> could, in theory, be a separate patch that fixes a theoretical memory
> leak?

Thinking on it, in theory you are right. In practice, I think this
risk is very low, and KASAN certainly tells us it pretty much isn't
occuring during testing.

AFAICT the only likely time it was occurring is during forced
shutdowns when transactions are being cancelled between intent
commit and done-intent create/link. Once the done-intent is linked
to the intent, cleanup on shutdown seems to works correctly and we
don't have leaks occurring.

However, whiteouts effectively release the done-intent during commit
whilst leaving the whiteout intent as the sole reference to the log
item in the CIL, which then unpin-aborts it to clean it up rather
than chains it and frees it on checkpoint completion. Hence whiteouts
effectively drive a bulldozer through this window and so it was
leaking a BUI/RUI/CUI on every whiteout cancellation as the
CIL wasn't chaining and freeing the log vector that was built for
the commit.

> (I'm not asking for you to separate the changes; I'm checking my
> understanding of something that caused me to go "Eh???" on first
> reading.)
> 
> > > > @@ -1393,7 +1463,11 @@ xlog_cil_commit(
> > > >  	/* lock out background commit */
> > > >  	down_read(&cil->xc_ctx_lock);
> > > >  
> > > > -	xlog_cil_insert_items(log, tp);
> > > > +	if (tp->t_flags & XFS_TRANS_HAS_INTENT_DONE)
> > > > +		released_space = xlog_cil_process_intents(cil, tp);
> > > > +
> > > > +	xlog_cil_insert_items(log, tp, released_space);
> > > > +	tp->t_ticket->t_curr_res += released_space;
> > > 
> > > I'm a little tired, so why isn't this adjustment a part of
> > > xlog_cil_insert_items?  A similar adjustment is made to
> > > ctx->space_used to release the unused space back to the committing tx,
> > > right?
> > 
> > Probably because it was a bug fix I added at some point and not
> > original code....
> > 
> > I'm not fussed where it ends up - I can move it if you want.
> 
> Yes please, since xlog_cil_insert_items already adjusts
> tp->t_ticket->t_curr_res and it would seem to make more sense to keep
> all those adjustments together.

Ok, will do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
