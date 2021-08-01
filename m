Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFAEC4338F
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 21:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3359960F8F
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 21:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhHAVtX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Aug 2021 17:49:23 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42056 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230146AbhHAVtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 17:49:23 -0400
Received: from dread.disaster.area (pa49-180-55-209.pa.nsw.optusnet.com.au [49.180.55.209])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 07BC1865A66;
        Mon,  2 Aug 2021 07:49:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mAJKY-00DQKE-GD; Mon, 02 Aug 2021 07:49:10 +1000
Date:   Mon, 2 Aug 2021 07:49:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 03/20] xfs: defer inode inactivation to a workqueue
Message-ID: <20210801214910.GC2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210730042400.GB2757197@dread.disaster.area>
 <20210731042112.GM3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210731042112.GM3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=1AO1UzHSPprVBI3cJdeQHw==:117 a=1AO1UzHSPprVBI3cJdeQHw==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=vfspC9WfWobHA_iNHl0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 30, 2021 at 09:21:12PM -0700, Darrick J. Wong wrote:
> On Fri, Jul 30, 2021 at 02:24:00PM +1000, Dave Chinner wrote:
> > On Thu, Jul 29, 2021 at 11:44:10AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Instead of calling xfs_inactive directly from xfs_fs_destroy_inode,
> > > defer the inactivation phase to a separate workqueue.  With this change,
> > > we can speed up directory tree deletions by reducing the duration of
> > > unlink() calls to the directory and unlinked list updates.
> > > 
> > > By moving the inactivation work to the background, we can reduce the
> > > total cost of deleting a lot of files by performing the file deletions
> > > in disk order instead of directory entry order, which can be arbitrary.
> > > 
> > > We introduce two new inode flags -- NEEDS_INACTIVE and INACTIVATING.
> > > The first flag helps our worker find inodes needing inactivation, and
> > > the second flag marks inodes that are in the process of being
> > > inactivated.  A concurrent xfs_iget on the inode can still resurrect the
> > > inode by clearing NEEDS_INACTIVE (or bailing if INACTIVATING is set).
> > > 
> > > Unfortunately, deferring the inactivation has one huge downside --
> > > eventual consistency.  Since all the freeing is deferred to a worker
> > > thread, one can rm a file but the space doesn't come back immediately.
> > > This can cause some odd side effects with quota accounting and statfs,
> > > so we flush inactivation work during syncfs in order to maintain the
> > > existing behaviors, at least for callers that unlink() and sync().
> > > 
> > > For this patch we'll set the delay to zero to mimic the old timing as
> > > much as possible; in the next patch we'll play with different delay
> > > settings.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > .....
> > > +
> > > +/* Disable the inode inactivation background worker and wait for it to stop. */
> > > +void
> > > +xfs_inodegc_stop(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	if (!test_and_clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
> > > +		return;
> > > +
> > > +	cancel_delayed_work_sync(&mp->m_inodegc_work);
> > > +	trace_xfs_inodegc_stop(mp, __return_address);
> > > +}
> > 
> > FWIW, this introduces a new mount field that does the same thing as the
> > m_opstate field I added in my feature flag cleanup series (i.e.
> > atomic operational state changes).  Personally I much prefer my
> > opstate stuff because this is state, not flags, and the namespace is
> > much less verbose...
> 
> Yes, well, is that ready to go?  Like, right /now/?  I already bolted
> the quotaoff scrapping patchset on the front, after reworking the ENOSPC
> retry loops and reworking quota apis before that...

Should be - that's why it's in my patch stack getting tested. But I
wasn't suggesting that you need to put it in first, just trying to
give you the heads up that there's a substantial conflict between
that and this patchset.

> > THere's also conflicts all over the place because of that. All the
> > RO checks are busted,
> 
> Can we focus on /this/ patchset, then?  What specifically is broken
> about the ro checking in it?

Sory, I wasn't particularly clear about that. What I meant was that
stuff like all the new RO and shutdown checks in this patchset don't
give conflicts but instead cause compilation failures. So the merge
isn't just a case of fixing conflicts, the code doesn't compile
(i.e. it is busted) after fixing all the reported merge conflicts.

> And since the shrinkers are always a source of amusement, what /is/ up
> with it?  I don't really like having to feed it magic numbers just to
> get it to do what I want, which is ... let it free some memory in the
> first round, then we'll kick the background workers when the priority
> bumps (er, decreases), and hope that's enough not to OOM the box.

Well, the shrinkers are intended as a one-shot memory pressure
notification as you are trying to use them. They are intended to be
told the amount of work that needs to be done to free memory, and
they they calculate how much of that work should be done based on
it's idea of the current level of memory pressure.

One shot shrinker triggers never tend to work well because they
treat all memory pressure the same - very light memory pressure is
dead with by the same big hammer than deals with OOM levels of
memory pressure.

As it is, I'm more concerned right now with finding out why there's
such large performance regressions in highly concurrent recursive
chmod/unlink workloads. I spend most of friday looking at it trying
to work out what behaviour was causing the regression, but I haven't
isolated it yet. I suspect that it is lockstepping between user
processes and background inactivation for the unlink - I'm seeing
the backlink rhashtable show up in the profiles which indicates the
unlinked list lengths are an issue and we're lockstepping the AGI.
It also may simply be that there is too much parallelism hammering
the transaction subsystem now....

IOWs, I'm basically going to have to pull this apart patch by patch
to tease out where the behaviours go wrong and see if there are ways
to avoid and mitigate those behaviours.  Hence I haven't even got to
the shrinker/oom considerations yet; there's a bigger performance
issue that needs to be understood first. It may be that they are
related, but right now we need to know why recursive chmod is
saw-toothing (it's not a lack of log space!) and concurrent unlinks
throughput has dropped by half...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
