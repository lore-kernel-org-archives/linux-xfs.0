Return-Path: <SRS0=ihlG=7Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4385CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 00:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24E262078D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 00:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgFKAQf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 20:16:35 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:45853 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgFKAQf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jun 2020 20:16:35 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id E70F9D7CB2E;
        Thu, 11 Jun 2020 10:16:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jjAtK-0001Ya-Rj; Thu, 11 Jun 2020 10:16:22 +1000
Date:   Thu, 11 Jun 2020 10:16:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/30] xfs: factor xfs_iflush_done
Message-ID: <20200611001622.GN2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-30-david@fromorbit.com>
 <20200609131249.GC40899@bfoster>
 <20200609221431.GK2040@dread.disaster.area>
 <20200610130833.GB50747@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610130833.GB50747@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=Jrg-JWUTNLOELscTFNEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 10, 2020 at 09:08:33AM -0400, Brian Foster wrote:
> On Wed, Jun 10, 2020 at 08:14:31AM +1000, Dave Chinner wrote:
> > On Tue, Jun 09, 2020 at 09:12:49AM -0400, Brian Foster wrote:
> > > On Thu, Jun 04, 2020 at 05:46:05PM +1000, Dave Chinner wrote:
> > > > -		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> > > > -			xfs_iflush_abort(iip->ili_inode);
> > > > +		if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn) {
> > > > +			clear_bit(XFS_LI_FAILED, &lip->li_flags);
> > > >  			continue;
> > > >  		}
> > > 
> > > That seems like strange logic. Shouldn't we clear LI_FAILED regardless?
> > 
> > It's the same logic as before this patch series:
> > 
> >                        if (INODE_ITEM(blip)->ili_logged &&
> >                             blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
> >                                 /*
> >                                  * xfs_ail_update_finish() only cares about the
> >                                  * lsn of the first tail item removed, any
> >                                  * others will be at the same or higher lsn so
> >                                  * we just ignore them.
> >                                  */
> >                                 xfs_lsn_t lsn = xfs_ail_delete_one(ailp, blip);
> >                                 if (!tail_lsn && lsn)
> >                                         tail_lsn = lsn;
> >                         } else {
> >                                 xfs_clear_li_failed(blip);
> >                         }
> > 
> > I've just re-ordered it to check for relogged inodes first instead
> > of handling that in the else branch.
> 
> Hmm.. I guess I'm confused why the logic seems to be swizzled around. An
> earlier patch lifted the bit clear outside of this check, then we seem
> to put it back in place in a different order for some reason..?

Oh, you're right - xfs_ail_delete_one() doesn't do that anymore - it
got pulled up into xfs_trans_ail_delete() instead. So much stuff
has changed in this patchset and I've largely moved on to all the
followup stuff now, I'm starting to lose track of what this patchset
does and the reasons why I did stuff a couple of months ago...

I'll fix that up.

> > > > + * Inode buffer IO completion routine.  It is responsible for removing inodes
> > > > + * attached to the buffer from the AIL if they have not been re-logged, as well
> > > > + * as completing the flush and unlocking the inode.
> > > > + */
> > > > +void
> > > > +xfs_iflush_done(
> > > > +	struct xfs_buf		*bp)
> > > > +{
> > > > +	struct xfs_log_item	*lip, *n;
> > > > +	LIST_HEAD(flushed_inodes);
> > > > +	LIST_HEAD(ail_updates);
> > > > +
> > > > +	/*
> > > > +	 * Pull the attached inodes from the buffer one at a time and take the
> > > > +	 * appropriate action on them.
> > > > +	 */
> > > > +	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> > > > +		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> > > > +
> > > > +		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> > > > +			xfs_iflush_abort(iip->ili_inode);
> > > > +			continue;
> > > > +		}
> > > > +		if (!iip->ili_last_fields)
> > > > +			continue;
> > > > +
> > > > +		/* Do an unlocked check for needing the AIL lock. */
> > > > +		if (iip->ili_flush_lsn == lip->li_lsn ||
> > > > +		    test_bit(XFS_LI_FAILED, &lip->li_flags))
> > > > +			list_move_tail(&lip->li_bio_list, &ail_updates);
> > > > +		else
> > > > +			list_move_tail(&lip->li_bio_list, &flushed_inodes);
> > > 
> > > Not sure I see the point of having two lists here, particularly since
> > > this is all based on lockless logic.
> > 
> > It's not lockless - it's all done under the buffer lock which
> > protects the buffer log item list...
> > 
> > > At the very least it's a subtle
> > > change in AIL processing logic and I don't think that should be buried
> > > in a refactoring patch.
> > 
> > I don't think it changes logic at all - what am I missing?
> > 
> 
> I'm referring to the fact that we no longer check the lsn of each
> (flushed) log item attached to the buffer under the ail lock.

That whole loop in xfs_iflush_ail_updates() runs under the AIL
lock, so it does the right thing for anything that is moved to the
"ail_updates" list.

If we win the unlocked race (li_lsn does not change) then we move
the inode to the ail update list and it gets rechecked under the AIL
lock and does the right thing. If we lose the race (li_lsn changes)
then the inode has been redirtied and we *don't need to check it
under the AIL* - all we need to do is leave it attached to the
buffer.

This is the same as the old code: win the race, need_ail is
incremented and we recheck under the AIL lock. Lose the race and
we don't recheck under the AIL because we don't need to. This
happened less under the old code, because it typically only happened
with single dirty inodes on a cluster buffer (think directory inode
under long running large directory modification operations), but
that race most definitely existed and the code most definitely
handled it correctly.

Keep in mind that this inode redirtying/AIL repositioning race can
even occur /after/ we've locked and removed items from the AIL but
before we've run xfs_iflush_finish(). i.e. we can remove it from the
AIL but by the time xfs_iflush_finish() runs it's back in the AIL.

> Note that
> I am not saying it's necessarily wrong, but rather that IMO it's too
> subtle a change to silently squash into a refactoring patch.

Except it isn't a change at all. The same subtle issue exists in the
code before this patch. It's just that this refactoring makes subtle
race conditions that were previously unknown to reviewers so much
more obvious they can now see them clearly. That tells me the code
is much improved by this refactoring, not that there's a problem
that needs reworking....

> > FWIW, I untangled the function this way because the "track dirty
> > inodes by ordered buffers" patchset completely removes the AIL stuff
> > - the ail_updates list and the xfs_iflush_ail_updates() function go
> > away completely and the rest of the refactoring remains unchanged.
> > i.e.  as the commit messages says, this change makes follow-on
> > patches much easier to understand...
> > 
> 
> The general function breakdown seems fine to me. I find the multiple
> list processing to be a bit overdone, particularly if it doesn't serve a
> current functional purpose. If the purpose is to support a future patch
> series, I'd suggest to continue using the existing logic of moving all
> flushed inodes to a single list and leave the separate list bits to the
> start of the series where it's useful so it's possible to review with
> the associated context (or alternatively just defer the entire patch).

That's how I originally did it, and it was a mess. it didn't
separate cleanly at all, and didn't make future patches much easier
at all. Hence I don't think reworking the patch just to look
different gains us anything at this point...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
