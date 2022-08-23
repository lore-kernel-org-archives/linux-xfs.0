Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20ED5C28D13
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 01:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbiHWBwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 21:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239263AbiHWBwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 21:52:00 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3EEA5A8A9
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 18:51:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-4-169.pa.nsw.optusnet.com.au [49.195.4.169])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0FE4862D6EF;
        Tue, 23 Aug 2022 11:51:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oQJ5A-00GNvm-Pa; Tue, 23 Aug 2022 11:51:56 +1000
Date:   Tue, 23 Aug 2022 11:51:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: AIL doesn't need manual pushing
Message-ID: <20220823015156.GM3600936@dread.disaster.area>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-3-david@fromorbit.com>
 <YwO39Kp9QUBBoeaF@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwO39Kp9QUBBoeaF@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=630432be
        a=FOdsZBbW/tHyAhIVFJ0pRA==:117 a=FOdsZBbW/tHyAhIVFJ0pRA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=cRQSjbr0UCvtYV5TuYwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 22, 2022 at 10:08:04AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 10, 2022 at 09:03:46AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We have a mechanism that checks the amount of log space remaining
> > available every time we make a transaction reservation. If the
> > amount of space is below a threshold (25% free) we push on the AIL
> > to tell it to do more work. To do this, we end up calculating the
> > LSN that the AIL needs to push to on every reservation and updating
> > the push target for the AIL with that new target LSN.
> > 
> > This is silly and expensive. The AIL is perfectly capable of
> > calculating the push target itself, and it will always be running
> > when the AIL contains objects.
> > 
> > Modify the AIL to calculate it's 25% push target before it starts a
> > push using the same reserve grant head based calculation as is
> > currently used, and remove all the places where we ask the AIL to
> > push to a new 25% free target.
.....
> > @@ -414,6 +395,57 @@ xfsaild_push_item(
> >  	return lip->li_ops->iop_push(lip, &ailp->ail_buf_list);
> >  }
> >  
> > +/*
> > + * Compute the LSN that we'd need to push the log tail towards in order to have
> > + * at least 25% of the log space free.  If the log free space already meets this
> > + * threshold, this function returns NULLCOMMITLSN.
> > + */
> > +xfs_lsn_t
> > +__xfs_ail_push_target(
> > +	struct xfs_ail		*ailp)
> > +{
> > +	struct xlog	*log = ailp->ail_log;
> > +	xfs_lsn_t	threshold_lsn = 0;
> > +	xfs_lsn_t	last_sync_lsn;
> > +	int		free_blocks;
> > +	int		free_bytes;
> > +	int		threshold_block;
> > +	int		threshold_cycle;
> > +	int		free_threshold;
> > +
> > +	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
> > +	free_blocks = BTOBBT(free_bytes);
> > +
> > +	/*
> > +	 * Set the threshold for the minimum number of free blocks in the
> > +	 * log to the maximum of what the caller needs, one quarter of the
> > +	 * log, and 256 blocks.
> > +	 */
> > +	free_threshold = log->l_logBBsize >> 2;
> > +	if (free_blocks >= free_threshold)
> 
> What happened to the "free_threshold = max(free_threshold, 256);" from
> the old code?  Or is the documented 256 block minimum no longer
> necessary?

Oh, I must have dropped the comment change when fixing the last
round of rebase conflicts. The minimum of 256 blocks is largely
useless because the even the smallest logs we create on tiny
filesystems are around 1000 filesystem blocks in size. So a minimum
free threshold of 128kB (256 BBs) is always going to be less than
one quarter the size of the journal....


> > @@ -454,21 +486,24 @@ xfsaild_push(
> >  	 * capture updates that occur after the sync push waiter has gone to
> >  	 * sleep.
> >  	 */
> > -	if (waitqueue_active(&ailp->ail_empty)) {
> > +	if (test_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate) ||
> > +	    waitqueue_active(&ailp->ail_empty)) {
> >  		lip = xfs_ail_max(ailp);
> >  		if (lip)
> >  			target = lip->li_lsn;
> > +		else
> > +			clear_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate);
> >  	} else {
> > -		/* barrier matches the ail_target update in xfs_ail_push() */
> > -		smp_rmb();
> > -		target = ailp->ail_target;
> > -		ailp->ail_target_prev = target;
> > +		target = __xfs_ail_push_target(ailp);
> 
> Hmm.  So now the AIL decides how far it ought to push itself: until 25%
> of the log is free if nobody's watching, or all the way to the end if
> there are xfs_ail_push_all_sync waiters or OPSTATE_PUSH_ALL is set
> because someone needs grant space?

Kind of. What the target does is determine if the AIL needs to do
any work before it goes back to sleep. If we haven't run out of
reservation space or memory (or some other push all trigger), it
will simply go back to sleep for a while if there is more than 25%
of the journal space free without doing anything.

If there are items in the AIL at a lower LSN than the target, it
will try to push up to the target or to the point of getting stuck
before going back to sleep and trying again soon after.

If the OPSTATE_PUSH_ALL flag is set, it will keep updating the
push target until the log is empty every time it loops. THis is
slightly different behaviour to the existing "push all" code which
selects a LSN to push towards and it doesn't try to push beyond that
even if new items are inserted into the AIL after the push_all has
been triggered.

However, because push_all_sync() effectly waits until the AIL is
empty (i.e. keep looping updating the push target until the AIL is
empty), and async pushes never wait for it to complete, there is no
practical difference between the current implementation and this
one.

> So the xlog*grant* callers now merely wake up the AIL and let push
> whatever it will, instead of telling the AIL how far to push itself?

Yes.

> Does that mean that those grant callers might have to wait until the AIL
> empties itself?

No. The moment the log tail moves forward because of a removal from
the tail of the AIL via xfs_ail_update_finish(), we call
xlog_assign_tail_lsn_locked() to move the l_tail_lsn forwards and
make grant space available, then we call xfs_log_space_wake() to
wake up any grant waiters that are waiting on the space to be made
available.

The reason for using the "push all" when grant space runs out is
that we can run out of grant space when there is more than 25% of
the log free. Small logs are notorious for this, and we have a hack
in the log callback code (xlog_state_set_callback()) where we push
the AIL because the *head* moved) to ensure that we kick the AIL
when we consume space in it because that can push us over the "less
than 25% available" available that starts tail pushing back up
again.

Hence when we run out of grant space and are going to sleep, we have
to consider that the grant space may be consuming almost all the log
space and there is almost nothing in the AIL. In this situation, the
AIL pins the tail and moving the tail forwards is the only way the
grant space will come available, so we have to force the AIL to push
everything to guarantee grant space will eventually be returned.
Hence triggering a "push all" just before sleeping removes all the
nasty corner cases we have in other parts of the code that work
around the "we didn't ask the AIL to push enough to free grant
space" condition that leads to log space hangs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
