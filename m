Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8361BC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 21:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiFQVwy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 17:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbiFQVwx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 17:52:53 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B07CBF6E
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 14:52:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7C9AD10EAD10;
        Sat, 18 Jun 2022 07:52:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o2JtV-007soa-KL; Sat, 18 Jun 2022 07:52:45 +1000
Date:   Sat, 18 Jun 2022 07:52:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: bound maximum wait time for inodegc work
Message-ID: <20220617215245.GH227878@dread.disaster.area>
References: <20220615220416.3681870-1-david@fromorbit.com>
 <20220615220416.3681870-2-david@fromorbit.com>
 <YqytHuc/sJprFn0K@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqytHuc/sJprFn0K@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62acf7b0
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=l_nrN3-mEc9ojCNHlu0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 12:34:38PM -0400, Brian Foster wrote:
> On Thu, Jun 16, 2022 at 08:04:15AM +1000, Dave Chinner wrote:
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
> > index 374b3bafaeb0..46b30ecf498c 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> ...
> > @@ -2176,7 +2184,7 @@ xfs_inodegc_shrinker_scan(
> >  			unsigned int	h = READ_ONCE(gc->shrinker_hits);
> >  
> >  			WRITE_ONCE(gc->shrinker_hits, h + 1);
> > -			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
> > +			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
> >  			no_items = false;
> >  		}
> 
> This all seems reasonable to me, but is there much practical benefit to
> shrinker infra/feedback just to expedite a delayed work item by one
> jiffy? Maybe there's a use case to continue to trigger throttling..?

I haven't really considered doing anything other than fixing the
reported bug. That just requires an API conversion for the existing
"queue immediately" semantics and is the safest minimum change
to fix the issue at hand.

So, yes, the shrinker code may (or may not) be superfluous now, but
I haven't looked at it and done analysis of the behaviour without
the shrinkers enabled. I'll do that in a completely separate
patchset if it turns out that it is not needed now.

> If
> so, it looks like decent enough overhead to cycle through every cpu in
> both callbacks that it might be worth spelling out more clearly in the
> top-level comment.

I'm not sure what you are asking here - mod_delayed_work_on() has
pretty much the same overhead and behaviour as queue_work() in this
case, so... ?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
