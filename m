Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBF3C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 21:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96BAB619CA
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 21:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbhC3VkR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 17:40:17 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:46075 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232671AbhC3VkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 17:40:10 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 1452863DAC;
        Wed, 31 Mar 2021 08:40:09 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lRM5n-008cxn-7b; Wed, 31 Mar 2021 08:40:07 +1100
Date:   Wed, 31 Mar 2021 08:40:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: inode fork allocation depends on XFS_IFEXTENT
 flag
Message-ID: <20210330214007.GU63242@dread.disaster.area>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-3-david@fromorbit.com>
 <20210330180617.GR4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330180617.GR4090233@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=JEvbjDdovvT677G-KPoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 11:06:17AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 30, 2021 at 04:30:57PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > XFS_IFEXTENT has two incompatible meanings to the code. The first
> > meaning is that the fork is in extent format, the second meaning is
> > that the extent list has been read into memory.
> 
> I don't agree that IFEXTENTS has two meanings.  This is what I
> understand of how xfs_ifork fields and surrounding code are supposed to
> work; can you point out what's wrong?
> 
>  1. xfs_ifork.if_format == XFS_DINODE_FMT_EXTENTS tells us if the fork
>     is in extent format.
> 
>  2. (xfs_ifork.if_flags & XFS_IFEXTENTS) tells us if the incore extent
>     map is initialized.
> 
>  3. If we are creating a fork with if_format == EXTENTS, the incore map
>     is trivially initialized, and therefore IFEXTENTS should be set
>     because no further work is required.
> 
>  4. If we are reading an if_format == EXTENTS fork in from disk (during
>     xfs_iread), we always populate the incore map and set IFEXTENTS.
> 
>  5. If if_format == BTREE and IFEXTENTS is not set, the incore map is
>     *not* initialized, and we must call xfs_iread_extents to walk the
>     ondisk btree to initialize the incore btree, and to set IFEXTENTS.
> 
>  6. xfs_iread_extents requires that if_format == BTREE and will return
>     an error and log a corruption report if it sees another fork format.
> 
> From points 3 and 4, I conclude that (prior to xfs-5.13-merge) IFEXTENTS
> is always set if if_format is FMT_EXTENTS.

ifp->if_flags is set to XFS_IFINLINE for local format forks,
XFS_IFEXTENTS for extent format forks, and XFS_IFBROOT for btree
roots in the inode fork.

THe contents of the fork are mode definitely defined by the flags
in the fork structure.

The problem is that we've overloaded XFS_IFEXTENTS to -also- mean
"extents loaded in memory". The in-core extent tree used to be a
IFBROOT only feature - XFS_IFEXTENTS format forks
held the extent data in the inode fork itself, not in the incore
extent tree, and so always had direct access to the extent records.
It never needed another flag to mean "extents have been read into
memory", because they always were present in the inode fork when
XFS_IFEXTENTS was set. 

What we used to have is another flag - XFS_IFEXTIREC - to indicate
that the XFS_IFBROOT format root was read into the incore memory
tree. This was removed in commit 6bdcf26ade88 ("xfs: use a b+tree
for the in-core extent list") when the btree was added for both
extent format and btree format forks, and it's use to indicate that
the btree had been read was replaced with the XFS_IFEXTENTS flag.

That's when XFS_IFEXTENTS gained it's dual meaning.

IOWS:

- XFS_IFINLINE means inode fork data is inode type specific data
- XFS_IFEXTENTS means the inode fork data is in extent format and
  that the in-core extent btree has been populated
- XFS_IFBROOT means the inode fork data is a btree root
- XFS_IFBROOT|XFS_IFEXTENTS mean the inode data fork is a btree root
  and that the in-core extent btree has been populated

Historically, that last case was XFS_IFBROOT|XFS_IFEXTIREC. What
should have been done in 6bdcf26ade88 is the XFS_IFEXTENTS format
fork should have become XFS_IFEXTENTS|XFS_IFEXTIREC to indicate
"extent format, extent tree populated", rather than eliding
XFS_IFEXTIREC and redefining XFS_IFEXTENTS to mean "extent tree
populated".  i.e. the separate flag to indicate the difference
between fork format and in-memory state should have been
retained....

> From point 6, I conclude that it's not possible for IFEXTENTS not to be
> set if if_format is FMT_EXTENTS, because if an inode fork ever ended up
> in that state, there would not be any way to escape.

That's an implementation detail arising from always reading the
extent list from the on-disk inode fork into in-memory extent list.

> > When the inode fork is in extent format, we automatically read the
> > extent list into memory and indexed by the inode extent btree when
> > the inode is brought into memory off disk.
> 
> Agreed, that's #4 above.

Yes, that's an implementation detail - we currently do not allow an
inode in extent form to be read in without populating the in-core
extent btree, whether we need to read extents or not. Hence the
confusion over "I know btree format uses this to indicate the extent
tree has been read" vs "this always needs to be set when in extent
format". That's the logic landmine I tripped over here.

Realistically, we should be separating the in-memory extent tree
initialisation from inode fork initialisation because directory traversal
workloads that just to look at inode state does not need to populate
the extent btree. Doing so for every inode is wasted memory and
CPU. We should init the extent btree on the first operation that
needs the extent list, like we do for btrees, and for that we need
XFS_IFEXTIREC to be re-introduced to clearly separate the in-memory
fork format from the extent tree state.

> > This fixes a scrub regression because it assumes XFS_IFEXTENT means
> > "on disk format" and not "read into memory" and e6a688c33238 assumed
> > it mean "read into memory". In reality, the XFS_IFEXTENT flag needs
> > to be split up into two flags - one for the on disk fork format and
> > one for the in-memory "extent btree has been populated" state.
> 
> Let's look at the relevant code in xchk_bmap(), since I wrote that
> function:
> 
> 	/* Check the fork values */
> 	switch (ifp->if_format) {
> 	...
> 	case XFS_DINODE_FMT_EXTENTS:
> 		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> 			xchk_fblock_set_corrupt(sc, whichfork, 0);
> 			goto out;
> 		}
> 		break;
> 
> The switch statement checks the format (#1), and the flag test checks
> that the incore state (#3 and #4) hold true.  Perhaps it was unwise of
> scrub to check *incore* state flags here, but as of the time the code
> was written, it was always the case that FMT_EXTENTS and IFEXTENTS went
> together.  Setting SCRUB_OFLAG_CORRUPT is how scrub signals that
> something is wrong and administrator intervention is needed.
> 
> I agree with the code fix, but not with the justification.

If you take into account the history of this code, you can see that
XFS_IFEXTIREC -> XFS_IFEXTENTS did, indeed, give XFS_IFEXTENTS two
meanings...

What I've written is mostly correct, yet what you've written is
also mostly correct. So what do you want me to put in the commit
message?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
