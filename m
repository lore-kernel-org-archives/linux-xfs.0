Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02B7C433ED
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Apr 2021 03:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77CE16136D
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Apr 2021 03:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbhDDDZf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Apr 2021 23:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236655AbhDDDZe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 3 Apr 2021 23:25:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED4306136B;
        Sun,  4 Apr 2021 03:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617506731;
        bh=0C++g0iXdES4ATjMiDvyDxtMRsAWll4D1ZgwCFDltfs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OIXuqkGbOXuikMkDowkaYuSnYmUGf8KQlqH3yLcGsQn5HdVkSGJVxnoTZ/nn0zszl
         hv6J5tfBZunkPQbYmYgkMh24ncnoUVzruNMFsLYKPleH9c0msT+AJ4inwiKW0qGv+0
         g7/b/vF8gXEa/sljNTimRf/90iYdwFjtRlOLZNJvSwBq/2AcRGpEvykZ6raiOA9pfZ
         DTfPWw0xmJ/o1kSFwsrgcUuUjYWRfKVFt+t8veOdeteZb9n0m6G/STA5i/DpVaXYUT
         hiQ7iPAMYJXC5eBXKNgwP1TgUVqtQyscY6DxUpF4VCQi++XKh+DnHqNPMBbz/V3/6f
         oauOZ4roxDp0w==
Date:   Sat, 3 Apr 2021 20:25:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: inode fork allocation depends on XFS_IFEXTENT
 flag
Message-ID: <20210404032528.GB3957620@magnolia>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-3-david@fromorbit.com>
 <20210330180617.GR4090233@magnolia>
 <20210330214007.GU63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330214007.GU63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 08:40:07AM +1100, Dave Chinner wrote:
> On Tue, Mar 30, 2021 at 11:06:17AM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 30, 2021 at 04:30:57PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > XFS_IFEXTENT has two incompatible meanings to the code. The first
> > > meaning is that the fork is in extent format, the second meaning is
> > > that the extent list has been read into memory.
> > 
> > I don't agree that IFEXTENTS has two meanings.  This is what I
> > understand of how xfs_ifork fields and surrounding code are supposed to
> > work; can you point out what's wrong?
> > 
> >  1. xfs_ifork.if_format == XFS_DINODE_FMT_EXTENTS tells us if the fork
> >     is in extent format.
> > 
> >  2. (xfs_ifork.if_flags & XFS_IFEXTENTS) tells us if the incore extent
> >     map is initialized.
> > 
> >  3. If we are creating a fork with if_format == EXTENTS, the incore map
> >     is trivially initialized, and therefore IFEXTENTS should be set
> >     because no further work is required.
> > 
> >  4. If we are reading an if_format == EXTENTS fork in from disk (during
> >     xfs_iread), we always populate the incore map and set IFEXTENTS.
> > 
> >  5. If if_format == BTREE and IFEXTENTS is not set, the incore map is
> >     *not* initialized, and we must call xfs_iread_extents to walk the
> >     ondisk btree to initialize the incore btree, and to set IFEXTENTS.
> > 
> >  6. xfs_iread_extents requires that if_format == BTREE and will return
> >     an error and log a corruption report if it sees another fork format.
> > 
> > From points 3 and 4, I conclude that (prior to xfs-5.13-merge) IFEXTENTS
> > is always set if if_format is FMT_EXTENTS.
> 
> ifp->if_flags is set to XFS_IFINLINE for local format forks,
> XFS_IFEXTENTS for extent format forks, and XFS_IFBROOT for btree
> roots in the inode fork.
> 
> THe contents of the fork are mode definitely defined by the flags
> in the fork structure.
> 
> The problem is that we've overloaded XFS_IFEXTENTS to -also- mean
> "extents loaded in memory". The in-core extent tree used to be a
> IFBROOT only feature - XFS_IFEXTENTS format forks
> held the extent data in the inode fork itself, not in the incore
> extent tree, and so always had direct access to the extent records.
> It never needed another flag to mean "extents have been read into
> memory", because they always were present in the inode fork when
> XFS_IFEXTENTS was set. 
> 
> What we used to have is another flag - XFS_IFEXTIREC - to indicate
> that the XFS_IFBROOT format root was read into the incore memory
> tree. This was removed in commit 6bdcf26ade88 ("xfs: use a b+tree
> for the in-core extent list") when the btree was added for both
> extent format and btree format forks, and it's use to indicate that
> the btree had been read was replaced with the XFS_IFEXTENTS flag.
> 
> That's when XFS_IFEXTENTS gained it's dual meaning.
> 
> IOWS:
> 
> - XFS_IFINLINE means inode fork data is inode type specific data
> - XFS_IFEXTENTS means the inode fork data is in extent format and
>   that the in-core extent btree has been populated
> - XFS_IFBROOT means the inode fork data is a btree root
> - XFS_IFBROOT|XFS_IFEXTENTS mean the inode data fork is a btree root
>   and that the in-core extent btree has been populated
> 
> Historically, that last case was XFS_IFBROOT|XFS_IFEXTIREC. What
> should have been done in 6bdcf26ade88 is the XFS_IFEXTENTS format
> fork should have become XFS_IFEXTENTS|XFS_IFEXTIREC to indicate
> "extent format, extent tree populated", rather than eliding
> XFS_IFEXTIREC and redefining XFS_IFEXTENTS to mean "extent tree
> populated".  i.e. the separate flag to indicate the difference
> between fork format and in-memory state should have been
> retained....
> 
> > From point 6, I conclude that it's not possible for IFEXTENTS not to be
> > set if if_format is FMT_EXTENTS, because if an inode fork ever ended up
> > in that state, there would not be any way to escape.
> 
> That's an implementation detail arising from always reading the
> extent list from the on-disk inode fork into in-memory extent list.
> 
> > > When the inode fork is in extent format, we automatically read the
> > > extent list into memory and indexed by the inode extent btree when
> > > the inode is brought into memory off disk.
> > 
> > Agreed, that's #4 above.
> 
> Yes, that's an implementation detail - we currently do not allow an
> inode in extent form to be read in without populating the in-core
> extent btree, whether we need to read extents or not. Hence the
> confusion over "I know btree format uses this to indicate the extent
> tree has been read" vs "this always needs to be set when in extent
> format". That's the logic landmine I tripped over here.
> 
> Realistically, we should be separating the in-memory extent tree
> initialisation from inode fork initialisation because directory traversal
> workloads that just to look at inode state does not need to populate
> the extent btree. Doing so for every inode is wasted memory and
> CPU. We should init the extent btree on the first operation that
> needs the extent list, like we do for btrees, and for that we need
> XFS_IFEXTIREC to be re-introduced to clearly separate the in-memory
> fork format from the extent tree state.
> 
> > > This fixes a scrub regression because it assumes XFS_IFEXTENT means
> > > "on disk format" and not "read into memory" and e6a688c33238 assumed
> > > it mean "read into memory". In reality, the XFS_IFEXTENT flag needs
> > > to be split up into two flags - one for the on disk fork format and
> > > one for the in-memory "extent btree has been populated" state.
> > 
> > Let's look at the relevant code in xchk_bmap(), since I wrote that
> > function:
> > 
> > 	/* Check the fork values */
> > 	switch (ifp->if_format) {
> > 	...
> > 	case XFS_DINODE_FMT_EXTENTS:
> > 		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > 			xchk_fblock_set_corrupt(sc, whichfork, 0);
> > 			goto out;
> > 		}
> > 		break;
> > 
> > The switch statement checks the format (#1), and the flag test checks
> > that the incore state (#3 and #4) hold true.  Perhaps it was unwise of
> > scrub to check *incore* state flags here, but as of the time the code
> > was written, it was always the case that FMT_EXTENTS and IFEXTENTS went
> > together.  Setting SCRUB_OFLAG_CORRUPT is how scrub signals that
> > something is wrong and administrator intervention is needed.
> > 
> > I agree with the code fix, but not with the justification.
> 
> If you take into account the history of this code, you can see that
> XFS_IFEXTIREC -> XFS_IFEXTENTS did, indeed, give XFS_IFEXTENTS two
> meanings...

Aha, so we ended up more or less agreeing on the code fix but via two
verrrry different paths (organizational knowledge vs. interpreting the
code).

> What I've written is mostly correct, yet what you've written is
> also mostly correct. So what do you want me to put in the commit
> message?

I'd be fine with pasting in both, along with a note that while we agree
on the code fix we arrived at it for different reasons ... if you think
that Christoph's RFC cleanup is a reasonable thing to bundle in right
after it.

It looks ok to me (once I cleaned up the build robot complaints) coming
from the narrower perspective of looking at iforks as they are now and
as they would become, FWIW, but since you know more about the historical
design points I'm curious what you think. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
