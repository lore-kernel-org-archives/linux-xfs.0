Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:4303 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbfA1WfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 17:35:02 -0500
Date: Tue, 29 Jan 2019 09:34:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Regular FS shutdown while rsync is running
Message-ID: <20190128223458.GT4205@dastard>
References: <1548087824.2465.9.camel@pengutronix.de>
 <20190121181151.GD14281@bfoster>
 <1548153593.2465.18.camel@pengutronix.de>
 <20190122130254.GA22901@bfoster>
 <1548242057.28802.1.camel@pengutronix.de>
 <20190123121153.GA27284@bfoster>
 <20190123130306.GB27284@bfoster>
 <20190123204528.GL4205@dastard>
 <20190124133120.GA2855@bfoster>
 <20190124191117.GA48262@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124191117.GA48262@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Lucas Stach <l.stach@pengutronix.de>, linux-xfs@vger.kernel.org

On Thu, Jan 24, 2019 at 02:11:17PM -0500, Brian Foster wrote:
> On Thu, Jan 24, 2019 at 08:31:20AM -0500, Brian Foster wrote:
> > On Thu, Jan 24, 2019 at 07:45:28AM +1100, Dave Chinner wrote:
> > > On Wed, Jan 23, 2019 at 08:03:07AM -0500, Brian Foster wrote:
> > > I don't think it has the scope and breadth of the AGFL issue - there
> > > isn't an actual fatal corruption on disk that will lead to loss or
> > > corruption of user data.  It's just the wrong magic number being
> > > placed in the btree block.
> > > 
> > 
> > Right, it's not a corruption that's going to have compound effects and
> > lead to broader inconsistencies and whatnot. We made a decision to nuke
> > the agfl at runtime to preserve behavior and allow the fs to continue
> > running (in spite of less severe corruption actually introduced by the
> > agfl reset).
> > 
> > This problem is still a fatal runtime error in some cases (and probably
> > all cases once we fix up the verifiers), however, and that's the
> > behavior I'm wondering whether we should mitigate because otherwise the
> > fs is fully capable of continuing to run (and the state may ultimately
> > clear itself).
> > 
> 
> Having looked more into this (see the RFC I sent earlier).. an explicit
> verifier magic check plus the existing mount time finobt scan pretty

I still seriously dislike that mount time scan just to count the
finobt blocks in use. That sort of thing should be maintained on the
fly like we do with the agf->agf_btreeblks for counting the number
of in-use freespace btree blocks. That needs to be fixed.

> much means anybody affected by this goes from having a fully working fs
> to an unmountable fs due to the verifier change. I don't think that's
> appropriate at all. We need to figure out some way to handle this a
> little more gracefully IMO.. thoughts?

I think that the number of people with a multi-level finobt who have
run repair can be counted on one hand. Until there's eveidence that
it's a widespread problem, we should just make the code error out.
Get the repair code fixed and released, so the people who first hit
it have a solution. If it's demonstrated as an endemic problem, then
we may need to do something different.

> > > 	b) write a xfs_db finobt traversal command that rewrites the
> > > 	magic numbers of all the blocks in the tree. Probably with
> > > 	an xfs_admin wrapper to make it nice for users who need to
> > > 	run it.
> > > 
> > 
> > Hmm, I can't really think of any time I'd suggest a user run something
> > that swizzles on-disk data like this without running xfs_repair before
> > and after.

I've done exactly this sort of thing to fix corruptions many, many
times in the past. it's one of the functions xfs_db was intended
for....

> > I certainly wouldn't ever do otherwise myself. Of course such
> > a script means those xfs_repair runs could be non-destructive, but I'm
> > not sure that's much of an advantage.

When xfs_repair takes days to run and the xfs_db script takes a few
seconds, users with limited downtime are going to want the
"just rewrite the magic numbers in the finobt tree" xfs_db script.

We know that it's just magic numbers that are wrong. We can verify
the linkage of the tree in xfs_db before rewriting anything (i.e.
walk once to verify that the tree linkages are consistent, then run
a second pass to rewrite the magic numbers) and we will have fixed
the problem without requiring the downtime of running xfs_repair
(twice!).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
