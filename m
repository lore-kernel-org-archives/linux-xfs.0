Return-Path: <SRS0=I2eC=74=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0D4C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Jun 2020 01:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD42B20714
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Jun 2020 01:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgFOBCA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Jun 2020 21:02:00 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34712 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728044AbgFOBCA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Jun 2020 21:02:00 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id A402C1AA1AC;
        Mon, 15 Jun 2020 11:01:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jkdVY-0001ct-DR; Mon, 15 Jun 2020 11:01:52 +1000
Date:   Mon, 15 Jun 2020 11:01:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/30] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200615010152.GT2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-29-david@fromorbit.com>
 <20200609131155.GB40899@bfoster>
 <20200609220139.GJ2040@dread.disaster.area>
 <20200610130628.GA50747@bfoster>
 <20200610234008.GM2040@dread.disaster.area>
 <20200611135618.GA56572@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611135618.GA56572@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=yCEOIxuBJ3uHWac5EHMA:9 a=Vmy44Yii2WrfnYrA:21 a=s-LYg-QiPpOSoSil:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 11, 2020 at 09:56:18AM -0400, Brian Foster wrote:
> On Thu, Jun 11, 2020 at 09:40:08AM +1000, Dave Chinner wrote:
> > On Wed, Jun 10, 2020 at 09:06:28AM -0400, Brian Foster wrote:
> > > On Wed, Jun 10, 2020 at 08:01:39AM +1000, Dave Chinner wrote:
> > > > On Tue, Jun 09, 2020 at 09:11:55AM -0400, Brian Foster wrote:
> > > > > On Thu, Jun 04, 2020 at 05:46:04PM +1000, Dave Chinner wrote:
> > > > > > -		 * check is not sufficient.
> > > > > > +		 * If we are shut down, unpin and abort the inode now as there
> > > > > > +		 * is no point in flushing it to the buffer just to get an IO
> > > > > > +		 * completion to abort the buffer and remove it from the AIL.
> > > > > >  		 */
> > > > > > -		if (!cip->i_ino) {
> > > > > > -			xfs_ifunlock(cip);
> > > > > > -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> > > > > > +		if (XFS_FORCED_SHUTDOWN(mp)) {
> > > > > > +			xfs_iunpin_wait(ip);
> > > > > 
> > > > > Note that we have an unlocked check above that skips pinned inodes.
> > > > 
> > > > Right, but we could be racing with a transaction commit that pinned
> > > > the inode and a shutdown. As the comment says: it's a quick and
> > > > dirty check to avoid trying to get locks when we know that it is
> > > > unlikely we can flush the inode without blocking. We still have to
> > > > recheck that state once we have the ILOCK....
> > > > 
> > > 
> > > Right, but that means we can just as easily skip the shutdown processing
> > > (which waits for unpin) if a particular inode is pinned. So which is
> > > supposed to happen in the shutdown case?
> > >
> > > ISTM that either could happen. As a result this kind of looks like
> > > random logic to me.
> > 
> > Yes, shutdown is racy, so it could be either. However, I'm not
> > changing the shutdown logic or handling here. If the shutdown race
> > could happen before this patchset (and it can), it can still happen
> > after the patchset, and this patchset does not change the way we
> > handle the shutdown race at all.
> > 
> > IOWs, while this shutdown logic may appear "random", that's not a
> > result of this patchset - it a result of design decisions made in
> > the last major shutdown rework/cleanup that required checks to be
> > added to places that could hang waiting for an event that would
> > never occur because shutdown state prevented it from occurring.
> 
> It's not so much the shutdown check that I find random as much as how it
> intends to handle pinned inodes.

I can change that, but that's the shutdown was handled by similar
code in the past, so it seemed appropriate here because this code
was hanging on shutdowns during development.

> > There's already enough complexity in this patchset that adding
> > shutdown logic changes is just too much to ask for.  If we want to
> > change how various shutdown logics work, lets do it as a separate
> > set of changes so all the subtle bugs that result from the changes
> > bisect to the isolated shutdown logic changes...
> > 
> 
> The fact that shutdown is racy is just background context. My point is
> that this patch appears to introduce special shutdown handling for a
> condition where it 1.) didn't previously exist and 2.) doesn't appear to
> be necessary.

The random shutdown failures I kept seeing in shutdown tests says
otherwise.

> The current push/flush code only incorporates a shutdown check
> indirectly via mapping the buffer, which simulates an I/O failure and
> causes us to abort the flush (and shutdown if the I/O failure happened
> for some other reason). If the shutdown happened sometime after we
> acquired the buffer, then there's no real impact on this code path. We
> flush the inode(s) and return success. The shutdown will be handled
> appropriately when xfsaild attempts to submit the buffer.

The long-standing rule of thumb is "shutdown == abort in-progress IO
immediately", which is what I followed here when it became apparent
there was some kind of subtle shutdown issue occurring. That made
the shutdown problem go away.

It may be that changes I've been making to other parts of this
writeback code make the shutdown check here unnecessary. My testing
said otherwise, but maybe that's all been cleared up. Hence if the
shutdown check is truly unnecessary, let's clean it up in a future
patchset where that assertion can be bisected down cleanly.  I
needed this to get fstests to pass, and for this patchset which is
entirely unrelated to shutdown architecture, that's all the
justification that should be necessary.

> The new code no longer maps the buffer because that is done much
> earlier, but for some reason incorporates a new check to abort the flush
> if the fs is already shutdown. The problem I have with this is that
> these checks tend to be brittle, untested and a maintenance burden.

Shutdown has *always* been brittle. You've seen it go from being
completely fucking awful to actually being somewhat reliable because
your experience with XFS matches to roughly when we first added
substantial shutdown validation to fstests.  We had a huge mountain
of technical debt around shutdown, but the importance of addressing
it has historically been pretty low because -shutdown is extremely
rare- in production systems.

> As
> such, I don't think we should ever add new shutdown checks for cases
> that aren't required for functional correctness.

I think the burden of proof is the wrong way around for the current
shutdown architecture. If you want to make a rule like this, you
need to fix define how the shutdown architecture is going to allow
this sort of rule to be applied without placing unreasonable demands
on the patch author.

> That way we hopefully
> move to a state where we have the minimum number of shutdown checks with
> broadest coverage to ensure everything unwinds correctly, but don't have
> to constantly battle with insufficiently tested logic in obscure
> contexts that silently break as surrounding code changes over time and
> leads to random fstests hangs and shutdown logic cleanouts every couple
> of years.

Yes, I think this is an admirable goal, but I think you've got how
to get there completely backward.  First work out the architecture
and logic that allows us to remove/avoid "randomly" placed checks,
then work towards cleaning up the code. We don't get there by saying
"no new checks!" and then ignoring the underlying problems those
checks are trying to avoid.

If you can come up with a shutdown mechanism that:

	a) prevents all IO the moment a shutdown is triggered, and
	b) avoids shutdown detection ordering hangs between
	   different objects and subsystems,

then you have grounds for saying "nobody should need to add new
shutdown checks". But right now, that's not even close to being the
reality. There needs to be lots more cleanup and rework to the
shutdown code to be done before we get anywhere near this...

> So my question for any newly added shutdown check is: what problem does
> this check solve?

Repeated fstests hangs on various shutdown tests while developing
this code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
