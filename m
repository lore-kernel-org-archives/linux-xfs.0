Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A039DC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 23:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241279AbiEXXDS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 19:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239226AbiEXXDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 19:03:17 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14928703EC
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 16:03:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0225E10E705D;
        Wed, 25 May 2022 09:03:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntdYX-00G0SD-0M; Wed, 25 May 2022 09:03:13 +1000
Date:   Wed, 25 May 2022 09:03:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chris@onthe.net.au
Subject: Re: [PATCH 1/2] xfs: bound maximum wait time for inodegc work
Message-ID: <20220524230312.GB1098723@dread.disaster.area>
References: <20220524063802.1938505-1-david@fromorbit.com>
 <20220524063802.1938505-2-david@fromorbit.com>
 <Yo0N234hm98uULNP@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo0N234hm98uULNP@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=628d6433
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=JGA_wsmaz2XTebO_VLoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 09:54:51AM -0700, Darrick J. Wong wrote:
> On Tue, May 24, 2022 at 04:38:01PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently inodegc work can sit queued on the per-cpu queue until
> > the workqueue is either flushed of the queue reaches a depth that
> > triggers work queuing (and later throttling). This means that we
> > could queue work that waits for a long time for some other event to
> > trigger flushing.
> > 
> > Hence instead of just queueing work at a specific depth, use a
> > delayed work that queues the work at a bound time. We can still
> > schedule the work immediately at a given depth, but we no long need
> 
> Nit: "no longer need..."
> 
> > to worry about leaving a number of items on the list that won't get
> > processed until external events prevail.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++--------------
> >  fs/xfs/xfs_mount.h  |  2 +-
> >  fs/xfs/xfs_super.c  |  2 +-
> >  3 files changed, 24 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 5269354b1b69..786702273621 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -440,7 +440,7 @@ xfs_inodegc_queue_all(
> >  	for_each_online_cpu(cpu) {
> >  		gc = per_cpu_ptr(mp->m_inodegc, cpu);
> >  		if (!llist_empty(&gc->list))
> > -			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
> > +			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
> >  	}
> >  }
> >  
> > @@ -1841,8 +1841,8 @@ void
> >  xfs_inodegc_worker(
> >  	struct work_struct	*work)
> >  {
> > -	struct xfs_inodegc	*gc = container_of(work, struct xfs_inodegc,
> > -							work);
> > +	struct xfs_inodegc	*gc = container_of(to_delayed_work(work),
> > +						struct xfs_inodegc, work);
> >  	struct llist_node	*node = llist_del_all(&gc->list);
> >  	struct xfs_inode	*ip, *n;
> >  
> > @@ -2014,6 +2014,7 @@ xfs_inodegc_queue(
> >  	struct xfs_inodegc	*gc;
> >  	int			items;
> >  	unsigned int		shrinker_hits;
> > +	unsigned long		queue_delay = 1;
> 
> A default delay of one clock tick, correct?
> 
> Just out of curiosity, how does this shake out wrt fstests that do a
> thing and then measure free space?

No regressions on a 5.18+for-next kernel on the two machines (one
ramdisk, one SSD) I ran it on yesterday. The runs were clean, which
is why I posted it for comments.

> I have a dim recollection of a bug that I found in one of the
> preproduction iterations of inodegc back when I used delayed_work to
> schedule the background gc.  If memory serves, calling mod_delayed_work
> on a delayed_work object that is currently running does /not/ cause the
> delayed_work object to be requeued, even if delay==0.

I don't think that is correct - I actually went through the code to
check this because I wanted to be certain that it behaved the way I
needed it to. Indeed, the documented behaviour of
mod_delayed_work_on() is:

 * If @dwork is idle, equivalent to queue_delayed_work_on(); otherwise,
 * modify @dwork's timer so that it expires after @delay.  If @delay is
 * zero, @work is guaranteed to be scheduled immediately regardless of its
 * current state.

In terms of the implementation, try_to_grab_pending() will grab the
delayed work and set/steal the WORK_STRUCT_PENDING_BIT, and
mod_delayed_work_on() will loop until it owns the bit or the dwork
is cancelled. Once it owns the PENDING bit, it will call
__queue_delayed_work(), which either queues the work immediately
(delay = 0) or sets up a timer to expire in delay ticks. 

The PENDING bit is cleared by the kworker thread before it calls the
work->current_func() to execute the work, so if the work is
currenlty running, try_to_grab_pending() will be able to set/steal
the WORK_STRUCT_PENDING_BIT without issues, and so even if the work
is currently running, we should be able queue it again via
mod_delayed_work_on().

So, AFAICT, the comment and behaviour match, and mod_delayed_work()
will result in queuing of the dwork even if it is currently running.

> Aha, I found a description in my notes.  I've adapted them to the
> current patchset, since in those days inodegc used a radix tree tag
> and per-AG workers instead of a locklesslist and per-cpu workers.
> If the following occurs:
> 
> Worker 1			Thread 2
> 
> xfs_inodegc_worker
> <starts up>
> node = llist_del_all()
> <start processing inodes>
> <block on something, yield>
> 				xfs_irele
> 				xfs_inode_mark_reclaimable
> 				llist_add
> 				mod_delayed_work()
> 				<exit>
> <process the rest of nodelist>
> return
> 
> Then at the end of this sequence, we'll end up with thread 2's inode
> queued to the gc list but the delayed work is /not/ queued.  That inode
> remains on the gc list (and unprocessed) until someone comes along to
> push that CPU's gc list, whether it's a statfs, or an unmount, or
> someone hitting ENOSPC and triggering blockgc.

Right, if mod_delayed_work() didn't queue the work then this would
be an issue, but AFAICT mod_delayed_work() will requeue in this
case and it will not get hung up in this case. I certainly haven't
seen any evidence that it's not working as I expected (so far).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
