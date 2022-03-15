Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915F9C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 21:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343959AbiCOVbG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 17:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbiCOVbG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 17:31:06 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 593D95BD33
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 14:29:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8BAC653333A;
        Wed, 16 Mar 2022 08:29:52 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUEjn-005tyj-U8; Wed, 16 Mar 2022 08:29:51 +1100
Date:   Wed, 16 Mar 2022 08:29:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: xfs_ail_push_all_sync() stalls when racing with
 updates
Message-ID: <20220315212951.GL3927073@dread.disaster.area>
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-4-david@fromorbit.com>
 <20220315191735.GO8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315191735.GO8224@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62310550
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=abbQHklSwuk2MhYrdsEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 12:17:35PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 15, 2022 at 05:42:37PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_ail_push_all_sync() has a loop like this:
> > 
> > while max_ail_lsn {
> > 	prepare_to_wait(ail_empty)
> > 	target = max_ail_lsn
> > 	wake_up(ail_task);
> > 	schedule()
> > }
> > 
> > Which is designed to sleep until the AIL is emptied. When
> > xfs_ail_finish_update() moves the tail of the log, it does:
> > 
> > 	if (list_empty(&ailp->ail_head))
> > 		wake_up_all(&ailp->ail_empty);
> > 
> > So it will only wake up the sync push waiter when the AIL goes
> > empty. If, by the time the push waiter has woken, the AIL has more
> > in it, it will reset the target, wake the push task and go back to
> > sleep.
> > 
> > The problem here is that if the AIL is having items added to it
> > when xfs_ail_push_all_sync() is called, then they may get inserted
> > into the AIL at a LSN higher than the target LSN. At this point,
> > xfsaild_push() will see that the target is X, the item LSNs are
> > (X+N) and skip over them, hence never pushing the out.
> > 
> > The result of this the AIL will not get emptied by the AIL push
> > thread, hence xfs_ail_finish_update() will never see the AIL being
> > empty even if it moves the tail. Hence xfs_ail_push_all_sync() never
> > gets woken and hence cannot update the push target to capture the
> > items beyond the current target on the LSN.
> > 
> > This is a TOCTOU type of issue so the way to avoid it is to not
> > use the push target at all for sync pushes. We know that a sync push
> > is being requested by the fact the ail_empty wait queue is active,
> > hence the xfsaild can just set the target to max_ail_lsn on every
> > push that we see the wait queue active. Hence we no longer will
> > leave items on the AIL that are beyond the LSN sampled at the start
> > of a sync push.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_trans_ail.c | 21 ++++++++++++++++-----
> >  1 file changed, 16 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 2a8c8dc54c95..1b52952097c1 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -448,10 +448,22 @@ xfsaild_push(
> >  
> >  	spin_lock(&ailp->ail_lock);
> >  
> > -	/* barrier matches the ail_target update in xfs_ail_push() */
> > -	smp_rmb();
> > -	target = ailp->ail_target;
> > -	ailp->ail_target_prev = target;
> > +	/*
> > +	 * If we have a sync push waiter, we always have to push till the AIL is
> > +	 * empty. Update the target to point to the end of the AIL so that
> > +	 * capture updates that occur after the sync push waiter has gone to
> > +	 * sleep.
> > +	 */
> > +	if (waitqueue_active(&ailp->ail_empty)) {
> > +		lip = xfs_ail_max(ailp);
> > +		if (lip)
> > +			target = lip->li_lsn;
> > +	} else {
> > +		/* barrier matches the ail_target update in xfs_ail_push() */
> > +		smp_rmb();
> 
> Doesn't the spin_lock provide the required rmb?  I think it's
> unnecessary given that, but I also don't think it hurts anything, so:

No. xfs_ail_push() does not take the ail_lock to update
ail->ail_target on 64 bit systems(*). Spin locks only provide memory
barriers between critical sections within the lock/unlock calls, and
even then the barrier is in the unlock -> lock direction only.  i.e.
what is written before the unlock in one critical section is
guaranteed to be read after the lock that starts the next critical
section.

Instead, xfs_ail_push() has smp_wmb() calls around setting the
target to ensure that all ail state updates done -before the wmb- are
seen by reads done -after the rmb- above. These memory barriers
could probably be replaced with a smp_store_release() and
smp_load_acquire() pair, because that is effectively what they are
implementing but the implementation predates those primitives.

OTOH, we don't need a rmb before the new waitqueue_active check
because all the waitqueue manipulations are done under the ail_lock.
Hence the ail_lock provides the memory barriers for that branch.

IOWs, the smp_rmb() is still necessary for the lockless
xfs_ail_push() update path, just like it was before this patch.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
