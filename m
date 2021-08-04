Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696ECC4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 21:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 465216105A
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 21:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhHDVt0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 17:49:26 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54871 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234785AbhHDVtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Aug 2021 17:49:16 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 23A231047842;
        Thu,  5 Aug 2021 07:49:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBOl1-00EZ0q-LI; Thu, 05 Aug 2021 07:48:59 +1000
Date:   Thu, 5 Aug 2021 07:48:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH, post-03/20 1/1] xfs: hook up inodegc to CPU dead
 notification
Message-ID: <20210804214859.GT2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
 <20210804115225.GP2757197@dread.disaster.area>
 <20210804161918.GU3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804161918.GU3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=9fj9NPbgXuutkcrZkfgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 09:19:18AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 04, 2021 at 09:52:25PM +1000, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > So we don't leave queued inodes on a CPU we won't ever flush.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_icache.h |  1 +
> >  fs/xfs/xfs_super.c  |  2 +-
> >  3 files changed, 38 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index f772f2a67a8b..9e2c95903c68 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1966,6 +1966,42 @@ xfs_inodegc_start(
> >  	}
> >  }
> >  
> > +/*
> > + * Fold the dead CPU inodegc queue into the current CPUs queue.
> > + */
> > +void
> > +xfs_inodegc_cpu_dead(
> > +	struct xfs_mount	*mp,
> > +	int			dead_cpu)
> 
> unsigned int, since that's the caller's type.

*nod*

> > +{
> > +	struct xfs_inodegc	*dead_gc, *gc;
> > +	struct llist_node	*first, *last;
> > +	int			count = 0;
> > +
> > +	dead_gc = per_cpu_ptr(mp->m_inodegc, dead_cpu);
> > +	cancel_work_sync(&dead_gc->work);
> > +
> > +	if (llist_empty(&dead_gc->list))
> > +		return;
> > +
> > +	first = dead_gc->list.first;
> > +	last = first;
> > +	while (last->next) {
> > +		last = last->next;
> > +		count++;
> > +	}
> > +	dead_gc->list.first = NULL;
> > +	dead_gc->items = 0;
> > +
> > +	/* Add pending work to current CPU */
> > +	gc = get_cpu_ptr(mp->m_inodegc);
> > +	llist_add_batch(first, last, &gc->list);
> > +	count += READ_ONCE(gc->items);
> > +	WRITE_ONCE(gc->items, count);
> 
> I was wondering about the READ/WRITE_ONCE pattern for gc->items: it's
> meant to be an accurate count of the list items, right?  But there's no
> hard synchronization (e.g. spinlock) around them, which means that the
> only CPU that can access that variable at all is the one that the percpu
> structure belongs to, right?  And I think that's ok here, because the
> only accessors are _queue() and _worker(), which both are supposed to
> run on the same CPU since they're percpu lists, right?

For items that are per-cpu, we only need to guarantee that the
normal case is access by that CPU only and that dependent accesses
within an algorithm occur within a preempt disabled region. THe use
of get_cpu_ptr()/put_cpu_ptr() creates a critital region where
preemption is disabled on that CPU. Hence we can read, modify and
write a per-cpu variable without locking, knowing that nothing else
will be attempting to run the same modification at the same time on
a different CPU, because they will be accessing percpu stuff local
to that CPU, not this one.

The reason for using READ_ONCE/WRITE_ONCE is largely to ensure that
we fetch and store the variable appropriately, as the work that
zeros the count can sometimes run on a different CPU. And it will
shut up the data race detector thing...

As it is, the count of items is rough, and doesn't need to be
accurate. If we race with a zeroing of the count, we'll set the
count to be higher (as if the zeroing didn't occur) and that just
causes the work to be rescheduled sooner than it otherwise would. A
race with zeroing is not the end of the world...

> In which case: why can't we just say count = dead_gc->items;?  @dead_cpu
> is being offlined, which implies that nothing will get scheduled on it,
> right?

The local CPU might already have items queued, so the count should
include them, too.

> > +	put_cpu_ptr(gc);
> > +	queue_work(mp->m_inodegc_wq, &gc->work);
> 
> Should this be thresholded like we do for _inodegc_queue?

I thought about that, then thought "this is slow path stuff, we just
want to clear out the backlog so we don't care about batching.."

> In the old days I would have imagined that cpu offlining should be rare
> enough <cough> that it probably doesn't make any real difference.  OTOH
> my cloudic colleague reminds me that they aggressively offline cpus to
> reduce licensing cost(!).

Yeah, CPU hotplug is very rare, except in those rare environments
where it is very common....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
