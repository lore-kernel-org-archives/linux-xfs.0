Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B5DC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 22:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 896BE2072F
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 22:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgFIWOk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 18:14:40 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:56151 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726992AbgFIWOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 18:14:40 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id CE40ED79A9F;
        Wed, 10 Jun 2020 08:14:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jimVr-0000ml-I5; Wed, 10 Jun 2020 08:14:31 +1000
Date:   Wed, 10 Jun 2020 08:14:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/30] xfs: factor xfs_iflush_done
Message-ID: <20200609221431.GK2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-30-david@fromorbit.com>
 <20200609131249.GC40899@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609131249.GC40899@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=Gv1xWdiycU-gJPdY_UEA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 09, 2020 at 09:12:49AM -0400, Brian Foster wrote:
> On Thu, Jun 04, 2020 at 05:46:05PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_iflush_done() does 3 distinct operations to the inodes attached
> > to the buffer. Separate these operations out into functions so that
> > it is easier to modify these operations independently in future.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode_item.c | 154 +++++++++++++++++++++-------------------
> >  1 file changed, 81 insertions(+), 73 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index dee7385466f83..3894d190ea5b9 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -640,101 +640,64 @@ xfs_inode_item_destroy(
> >  
> >  
> >  /*
> > - * This is the inode flushing I/O completion routine.  It is called
> > - * from interrupt level when the buffer containing the inode is
> > - * flushed to disk.  It is responsible for removing the inode item
> > - * from the AIL if it has not been re-logged, and unlocking the inode's
> > - * flush lock.
> > - *
> > - * To reduce AIL lock traffic as much as possible, we scan the buffer log item
> > - * list for other inodes that will run this function. We remove them from the
> > - * buffer list so we can process all the inode IO completions in one AIL lock
> > - * traversal.
> > - *
> > - * Note: Now that we attach the log item to the buffer when we first log the
> > - * inode in memory, we can have unflushed inodes on the buffer list here. These
> > - * inodes will have a zero ili_last_fields, so skip over them here.
> > + * We only want to pull the item from the AIL if it is actually there
> > + * and its location in the log has not changed since we started the
> > + * flush.  Thus, we only bother if the inode's lsn has not changed.
> >   */
> >  void
> > -xfs_iflush_done(
> > -	struct xfs_buf		*bp)
> > +xfs_iflush_ail_updates(
> > +	struct xfs_ail		*ailp,
> > +	struct list_head	*list)
> >  {
> > -	struct xfs_inode_log_item *iip;
> > -	struct xfs_log_item	*lip, *n;
> > -	struct xfs_ail		*ailp = bp->b_mount->m_ail;
> > -	int			need_ail = 0;
> > -	LIST_HEAD(tmp);
> > +	struct xfs_log_item	*lip;
> > +	xfs_lsn_t		tail_lsn = 0;
> >  
> > -	/*
> > -	 * Pull the attached inodes from the buffer one at a time and take the
> > -	 * appropriate action on them.
> > -	 */
> > -	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> > -		iip = INODE_ITEM(lip);
> > +	/* this is an opencoded batch version of xfs_trans_ail_delete */
> > +	spin_lock(&ailp->ail_lock);
> > +	list_for_each_entry(lip, list, li_bio_list) {
> > +		xfs_lsn_t	lsn;
> >  
> > -		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> > -			xfs_iflush_abort(iip->ili_inode);
> > +		if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn) {
> > +			clear_bit(XFS_LI_FAILED, &lip->li_flags);
> >  			continue;
> >  		}
> 
> That seems like strange logic. Shouldn't we clear LI_FAILED regardless?

It's the same logic as before this patch series:

                       if (INODE_ITEM(blip)->ili_logged &&
                            blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
                                /*
                                 * xfs_ail_update_finish() only cares about the
                                 * lsn of the first tail item removed, any
                                 * others will be at the same or higher lsn so
                                 * we just ignore them.
                                 */
                                xfs_lsn_t lsn = xfs_ail_delete_one(ailp, blip);
                                if (!tail_lsn && lsn)
                                        tail_lsn = lsn;
                        } else {
                                xfs_clear_li_failed(blip);
                        }

I've just re-ordered it to check for relogged inodes first instead
of handling that in the else branch.

i.e. we do clear XFS_LI_FAILED always: xfs_ail_delete_one() does it
for the log items that are being removed from the AIL....

> > +/*
> > + * Inode buffer IO completion routine.  It is responsible for removing inodes
> > + * attached to the buffer from the AIL if they have not been re-logged, as well
> > + * as completing the flush and unlocking the inode.
> > + */
> > +void
> > +xfs_iflush_done(
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_log_item	*lip, *n;
> > +	LIST_HEAD(flushed_inodes);
> > +	LIST_HEAD(ail_updates);
> > +
> > +	/*
> > +	 * Pull the attached inodes from the buffer one at a time and take the
> > +	 * appropriate action on them.
> > +	 */
> > +	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> > +		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> > +
> > +		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> > +			xfs_iflush_abort(iip->ili_inode);
> > +			continue;
> > +		}
> > +		if (!iip->ili_last_fields)
> > +			continue;
> > +
> > +		/* Do an unlocked check for needing the AIL lock. */
> > +		if (iip->ili_flush_lsn == lip->li_lsn ||
> > +		    test_bit(XFS_LI_FAILED, &lip->li_flags))
> > +			list_move_tail(&lip->li_bio_list, &ail_updates);
> > +		else
> > +			list_move_tail(&lip->li_bio_list, &flushed_inodes);
> 
> Not sure I see the point of having two lists here, particularly since
> this is all based on lockless logic.

It's not lockless - it's all done under the buffer lock which
protects the buffer log item list...

> At the very least it's a subtle
> change in AIL processing logic and I don't think that should be buried
> in a refactoring patch.

I don't think it changes logic at all - what am I missing?

FWIW, I untangled the function this way because the "track dirty
inodes by ordered buffers" patchset completely removes the AIL stuff
- the ail_updates list and the xfs_iflush_ail_updates() function go
away completely and the rest of the refactoring remains unchanged.
i.e.  as the commit messages says, this change makes follow-on
patches much easier to understand...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
