Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6979C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 00:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351013AbiFWAZm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 20:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357243AbiFWAZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 20:25:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1AA6580
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 17:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0533DB8216E
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 00:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF097C34114;
        Thu, 23 Jun 2022 00:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655943936;
        bh=vYUUU2u9vHUjQspr3vazq6sPuWVT6tjYrSZO4kG6A8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qqAIbta1NEG11fzg0HQ9vxD0PcdXH78dOrxnvWb1uf4HQkIKe+65ROQ30xKwdkQbh
         TQpWBfH6Rcw63WMQ4KlNkfLxKxuBMpVpnxTSaTjQcbTtFOIWv+J7KeFpsASYogS2w/
         H+dz1ZXGxsbeuf3pzovrURcnEZVq72LfGt0rxoFnjVjqCn+fOg3xxwun4ai563jU5Q
         1f+kQyWRFbIDyJ7lLbeWm3qw8zt5pNJqQj6KqM2Dn8TAFquQxnK0c2dw4X4rdGPbhO
         km2EVBlvZQcuScyYFHjGRbFPRt2izMUjIVIiABeadaIUJ1ZC0zgMDR02ra/oiCjewL
         L/nmlHmKTWtCg==
Date:   Wed, 22 Jun 2022 17:25:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: bound maximum wait time for inodegc work
Message-ID: <YrOzAPXCcDY9DnCj@magnolia>
References: <20220615220416.3681870-1-david@fromorbit.com>
 <20220615220416.3681870-2-david@fromorbit.com>
 <YqytHuc/sJprFn0K@bfoster>
 <20220617215245.GH227878@dread.disaster.area>
 <YrKmrgJh9+SzT0Gz@magnolia>
 <YrM/woFhObNYQx3b@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrM/woFhObNYQx3b@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 12:13:54PM -0400, Brian Foster wrote:
> On Tue, Jun 21, 2022 at 10:20:46PM -0700, Darrick J. Wong wrote:
> > On Sat, Jun 18, 2022 at 07:52:45AM +1000, Dave Chinner wrote:
> > > On Fri, Jun 17, 2022 at 12:34:38PM -0400, Brian Foster wrote:
> > > > On Thu, Jun 16, 2022 at 08:04:15AM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > Currently inodegc work can sit queued on the per-cpu queue until
> > > > > the workqueue is either flushed of the queue reaches a depth that
> > > > > triggers work queuing (and later throttling). This means that we
> > > > > could queue work that waits for a long time for some other event to
> > > > > trigger flushing.
> > > > > 
> > > > > Hence instead of just queueing work at a specific depth, use a
> > > > > delayed work that queues the work at a bound time. We can still
> > > > > schedule the work immediately at a given depth, but we no long need
> > > > > to worry about leaving a number of items on the list that won't get
> > > > > processed until external events prevail.
> > > > > 
> > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > ---
> > > > >  fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++--------------
> > > > >  fs/xfs/xfs_mount.h  |  2 +-
> > > > >  fs/xfs/xfs_super.c  |  2 +-
> > > > >  3 files changed, 24 insertions(+), 16 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > > index 374b3bafaeb0..46b30ecf498c 100644
> > > > > --- a/fs/xfs/xfs_icache.c
> > > > > +++ b/fs/xfs/xfs_icache.c
> > > > ...
> > > > > @@ -2176,7 +2184,7 @@ xfs_inodegc_shrinker_scan(
> > > > >  			unsigned int	h = READ_ONCE(gc->shrinker_hits);
> > > > >  
> > > > >  			WRITE_ONCE(gc->shrinker_hits, h + 1);
> > > > > -			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
> > > > > +			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
> > > > >  			no_items = false;
> > > > >  		}
> > > > 
> > > > This all seems reasonable to me, but is there much practical benefit to
> > > > shrinker infra/feedback just to expedite a delayed work item by one
> > > > jiffy? Maybe there's a use case to continue to trigger throttling..?
> > > 
> > > I haven't really considered doing anything other than fixing the
> > > reported bug. That just requires an API conversion for the existing
> > > "queue immediately" semantics and is the safest minimum change
> > > to fix the issue at hand.
> > > 
> > > So, yes, the shrinker code may (or may not) be superfluous now, but
> > > I haven't looked at it and done analysis of the behaviour without
> > > the shrinkers enabled. I'll do that in a completely separate
> > > patchset if it turns out that it is not needed now.
> > 
> > I think the shrinker part is still necessary -- bulkstat and xfs_scrub
> > on a very low memory machine (~560M RAM) opening and closing tens of
> > millions of files can still OOM the machine if one doesn't have a means
> > to slow down ->destroy_inode (and hence the next open()) when reclaim
> > really starts to dig in.  Without the shrinker bits, it's even easier to
> > trigger OOM storms when xfs has timer-delayed inactivation... which is
> > something that Brian pointed out a year ago when we were reviewing the
> > initial inodegc patchset.
> > 
> 
> It wouldn't surprise me if the infrastructure is still necessary for the
> throttling use case. In that case, I'm more curious about things like
> whether it's still as effective as intended with such a small scheduling
> delay, or whether it still might be worth simplifying in various ways
> (i.e., does the scheduling delay actually make a difference? do we still
> need a per cpu granular throttle? etc.).

It can still be useful for certain g*dawful scenarios --

Let's say you have a horribly misconfigured cloudy system with a tiny
log, hundreds of CPUs, a memory hogging process, another process with
many hundreds of threads that are performing small appending synchronous
writes to a large number of files, and some other process repeatedly
opens and closes files.  Background writeback completion will create
enough workers to tie up the log such that writeback and inodegc contend
for log grant space and make slow progress.  If memory is also tight,
we want to slow down the file scanning process so that it doesn't shove
/more/ inodes into the cache and push the system towards OOM behavior.

Back in the old days when inodegc was a radix tree tag it was fairly
easy to get OOMs when the delay interval was long (5 seconds).  The
OOM probability went down pretty sharply as the interval approached
zero, but even at 1 jiffy I could still occasionally trip it, whereas
the pre-deferred-inactivation kernels would never OOM.

I haven't tested it all that rigorously with Dave's fancy new per-cpu
list design, but I did throw on my silly test setup (see below) and
still got it to OOM once in 3 runs with the shrinker bits turned off.

> > > > If
> > > > so, it looks like decent enough overhead to cycle through every cpu in
> > > > both callbacks that it might be worth spelling out more clearly in the
> > > > top-level comment.
> > > 
> > > I'm not sure what you are asking here - mod_delayed_work_on() has
> > > pretty much the same overhead and behaviour as queue_work() in this
> > > case, so... ?
> > 
> 
> I'm just pointing out that the comment around the shrinker
> infrastructure isn't very informative if the shrinker turns out to still
> be necessary for reasons other than making the workers run sooner.

<nod> That comment /does/ need to be updated to note the subtlety that a
lot of shrinker activity can slow down close()ing a file by making user
tasks wait for the inodegc workers to clear the backlog.

> > <shrug> Looks ok to me, since djwong-dev has had some variant of timer
> > delayed inactivation in it longer than it hasn't:
> > 
> 
> Was that with a correspondingly small delay or something larger (on the
> order of seconds or so)? Either way, it sounds like you have a
> predictable enough workload that can actually test this continues to
> work as expected..?

Yeah.  I snapshot /home (which has ~20 million inodes) then race
fsstress and xfs_scrub -n in a VM with 560MB of RAM.

--D

> Brian
> 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > --D
> > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > 
> 
