Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66136C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 05:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiFVFUv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 01:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiFVFUu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 01:20:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521AD3616F
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jun 2022 22:20:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11475B81A94
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 05:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AFDC34114;
        Wed, 22 Jun 2022 05:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655875246;
        bh=Br6Bi292GZpzqiFDeGCteqNs1GbQDVlUBbIB1wy+85U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SsQAD65o/neJKqERrAqmG5YIe39/PpoEOV67D/DcrTLiS6MsOAAX5a8BKd+lSDBva
         qWcNXZalpxQN71oxHLfi8ZEg2AfoZei3rwXxIzWT1L62wbLoL3n3D39J24r8+aZBoA
         N6b/h7TyC3F0s9jODKC6qWrnEEzDnC9Pxy4VtSmlklHbqS9Fwk2vW2vQY7M1Jn+ant
         w3uRzVVMOhKou2vJU8rJs8k6BLLGb4AejsLCsJibBRtUsm/xvTqI2l47pKTtCYSmF2
         hq5aLqM0MYEel1q+H3Cpil2p5bpMa9sO0NeKF0WYSJ15VSdInwxh2RWkTe4QSZ+1FE
         rCLVGZKQzVRXg==
Date:   Tue, 21 Jun 2022 22:20:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: bound maximum wait time for inodegc work
Message-ID: <YrKmrgJh9+SzT0Gz@magnolia>
References: <20220615220416.3681870-1-david@fromorbit.com>
 <20220615220416.3681870-2-david@fromorbit.com>
 <YqytHuc/sJprFn0K@bfoster>
 <20220617215245.GH227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617215245.GH227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 18, 2022 at 07:52:45AM +1000, Dave Chinner wrote:
> On Fri, Jun 17, 2022 at 12:34:38PM -0400, Brian Foster wrote:
> > On Thu, Jun 16, 2022 at 08:04:15AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Currently inodegc work can sit queued on the per-cpu queue until
> > > the workqueue is either flushed of the queue reaches a depth that
> > > triggers work queuing (and later throttling). This means that we
> > > could queue work that waits for a long time for some other event to
> > > trigger flushing.
> > > 
> > > Hence instead of just queueing work at a specific depth, use a
> > > delayed work that queues the work at a bound time. We can still
> > > schedule the work immediately at a given depth, but we no long need
> > > to worry about leaving a number of items on the list that won't get
> > > processed until external events prevail.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++--------------
> > >  fs/xfs/xfs_mount.h  |  2 +-
> > >  fs/xfs/xfs_super.c  |  2 +-
> > >  3 files changed, 24 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index 374b3bafaeb0..46b30ecf498c 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > ...
> > > @@ -2176,7 +2184,7 @@ xfs_inodegc_shrinker_scan(
> > >  			unsigned int	h = READ_ONCE(gc->shrinker_hits);
> > >  
> > >  			WRITE_ONCE(gc->shrinker_hits, h + 1);
> > > -			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
> > > +			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
> > >  			no_items = false;
> > >  		}
> > 
> > This all seems reasonable to me, but is there much practical benefit to
> > shrinker infra/feedback just to expedite a delayed work item by one
> > jiffy? Maybe there's a use case to continue to trigger throttling..?
> 
> I haven't really considered doing anything other than fixing the
> reported bug. That just requires an API conversion for the existing
> "queue immediately" semantics and is the safest minimum change
> to fix the issue at hand.
> 
> So, yes, the shrinker code may (or may not) be superfluous now, but
> I haven't looked at it and done analysis of the behaviour without
> the shrinkers enabled. I'll do that in a completely separate
> patchset if it turns out that it is not needed now.

I think the shrinker part is still necessary -- bulkstat and xfs_scrub
on a very low memory machine (~560M RAM) opening and closing tens of
millions of files can still OOM the machine if one doesn't have a means
to slow down ->destroy_inode (and hence the next open()) when reclaim
really starts to dig in.  Without the shrinker bits, it's even easier to
trigger OOM storms when xfs has timer-delayed inactivation... which is
something that Brian pointed out a year ago when we were reviewing the
initial inodegc patchset.

> > If
> > so, it looks like decent enough overhead to cycle through every cpu in
> > both callbacks that it might be worth spelling out more clearly in the
> > top-level comment.
> 
> I'm not sure what you are asking here - mod_delayed_work_on() has
> pretty much the same overhead and behaviour as queue_work() in this
> case, so... ?

<shrug> Looks ok to me, since djwong-dev has had some variant of timer
delayed inactivation in it longer than it hasn't:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
