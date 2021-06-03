Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4644C47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 21:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEDF7613F8
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 21:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhFCVcU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 17:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhFCVcT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 17:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 882CD613D8;
        Thu,  3 Jun 2021 21:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622755834;
        bh=Pd5mErSnpS1CFwCQhL4yazQQnwfcBKA+DEsWmNJjQ/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tcDKbtVLOBdAKQ4JpH06MGEeWzK046oTFT+empCOhlk5BC6HopGpokPq3VHFL2Cc1
         sYp2NRJcneHFXB32Othpb2GlVsyMHCsK4rj503MNjk+KPbHK9HHyrTsAiSTzPm58by
         VIC/WJfHuUJG+mmlvOcgst0bXMs/mHXjFGdMuVDG+kHizlJCZtQrItucB9Bnugs8IU
         onAEx/aZhcuPdeEsmu9R4WGy5Y6Y2sPgK9GB1bQnR4/TzOKlHP45YlScVN9NJagaub
         U38DApoGaVquQ9GAHBa6wzbzvSpuMsjSVUrS/jPAgyOR/9dVMWBmxwxq/P+vH7Bash
         +w2ifiqClYPWg==
Date:   Thu, 3 Jun 2021 14:30:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: don't let background reclaim forget sick inodes
Message-ID: <20210603213034.GE26380@locust>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268997239.2724138.6026093150916734925.stgit@locust>
 <20210603044242.GQ664593@dread.disaster.area>
 <YLjLtfDLw89A0gbS@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLjLtfDLw89A0gbS@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 08:31:49AM -0400, Brian Foster wrote:
> On Thu, Jun 03, 2021 at 02:42:42PM +1000, Dave Chinner wrote:
> > On Wed, Jun 02, 2021 at 08:12:52PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > It's important that the filesystem retain its memory of sick inodes for
> > > a little while after problems are found so that reports can be collected
> > > about what was wrong.  Don't let background inode reclamation free sick
> > > inodes unless we're under memory pressure.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_icache.c |   21 +++++++++++++++++----
> > >  1 file changed, 17 insertions(+), 4 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index 0e2b6c05e604..54285d1ad574 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -911,7 +911,8 @@ xfs_dqrele_all_inodes(
> > >   */
> > >  static bool
> > >  xfs_reclaim_igrab(
> > > -	struct xfs_inode	*ip)
> > > +	struct xfs_inode	*ip,
> > > +	struct xfs_eofblocks	*eofb)
> > >  {
> > >  	ASSERT(rcu_read_lock_held());
> > >  
> > > @@ -922,6 +923,17 @@ xfs_reclaim_igrab(
> > >  		spin_unlock(&ip->i_flags_lock);
> > >  		return false;
> > >  	}
> > > +
> > > +	/*
> > > +	 * Don't reclaim a sick inode unless we're under memory pressure or the
> > > +	 * filesystem is unmounting.
> > > +	 */
> > > +	if (ip->i_sick && eofb == NULL &&
> > > +	    !(ip->i_mount->m_flags & XFS_MOUNT_UNMOUNTING)) {
> > > +		spin_unlock(&ip->i_flags_lock);
> > > +		return false;
> > > +	}
> > 
> > Using the "eofb == NULL" as a proxy for being under memory pressure
> > is ... a bit obtuse. If we've got a handful of sick inodes, then
> > there is no problem with just leaving the in memory regardless of
> > memory pressure. If we've got lots of sick inodes, we're likely to
> > end up in a shutdown state or be unmounted for checking real soon.
> > 
> 
> Agreed.. it would be nice to see more explicit logic here. Using the
> existence or not of an optional parameter meant to provide various
> controls is quite fragile.

Ok, I'll add a new private icwalk flag for reclaim callers to indicate
that it's ok to reclaim sick inodes:

	/* Don't reclaim a sick inode unless the caller asked for it. */
	if (ip->i_sick && icw &&
	    (icw->icw_flags & XFS_ICWALK_FLAG_RECLAIM_SICK)) {
		spin_unlock(&ip->i_flags_lock);
		return false;
	}

And then xfs_reclaim_inodes becomes:

void
xfs_reclaim_inodes(
	struct xfs_mount	*mp)
{
	struct xfs_icwalk	icw = {
		.icw_flags	= 0,
	};

	if (xfs_want_reclaim_sick(mp))
		icw.icw_flags |= XFS_ICWALK_FLAG_RECLAIM_SICK;

	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
		xfs_ail_push_all_sync(mp->m_ail);
		xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &icw);
	}
}

Similar changes apply to xfs_reclaim_inodes_nr.

> > I'd just leave sick inodes around until unmount or shutdown occurs;
> > lots of sick inodes means repair is necessary right now, so
> > shutdown+unmount is the right solution here, not memory reclaim....
> > 
> 
> That seems like a dependency on a loose correlation and rather
> dangerous.. we're either assuming action on behalf of a user before the
> built up state becomes a broader problem for the system or that somehow
> a cascade of in-core inode problems is going to lead to a shutdown. I
> don't think that is a guarantee, or even necessarily likely. I think if
> we were to do something like pin sick inodes in memory indefinitely, as
> you've pointed out in the past for other such things, we should at least
> consider breakdown conditions and potential for unbound behavior.

Yes.  The subsequent health reporting patchset that I linked a few
responses ago is intended to help with the pinning behavior.  With it,
we'll be able to save the fact that inodes within a given AG were sick
even if we're forced to give back the memory.  At a later time, the
sysadmin can download the health report and initiate a scan that will
recover the specific sick info and schedule downtime or perform repairs.

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting

The trouble is, this is a user ABI change, so I'm trying to keep it out
of the landing path of deferred inactivation.

> IOW, if scrub decides it wants to pin sick inodes until shutdown, it
> should probably implement some kind of worst case threshold where it
> actually initiates shutdown based on broad health state.

It already can.  As an example, "xfs_scrub -a 1000 -e shutdown" will
shut down the filesystem after 1,000 errors.

> If we can't
> reasonably define something like that, then to me that is a pretty clear
> indication that an indefinite pinning strategy is probably too fragile.

This might be the case anyway.  Remember how I was working on some code
to set sick flags any time we saw a corruption anywhere in the
filesystem?  If that ever gets fully implemented, we could very well end
up pinning tons of memory that will cause the system (probably) to swap
itself to death because we won't let go of the bad inodes.

> OTOH, perhaps scrub has enough knowledge to implement some kind of
> policy where a sick object is pinned until we know the state has been
> queried at least once, then reclaim can have it? I guess we still may
> want to be careful about things like how many sick objects a single
> scrub scan can produce before there's an opportunity for userspace to
> query status; it's not clear to me how much of an issue that might be..
> 
> In any event, this all seems moderately more involved to get right vs
> what the current patch proposes. I think this patch is a reasonable step
> if we can clean up the logic a bit. Perhaps define a flag that contexts
> can use to explicitly reclaim or skip unhealthy inodes?

Done.

--D

> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
