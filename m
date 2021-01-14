Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6300C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 22:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABEF923A6C
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 22:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbhANWLK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 17:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbhANWLJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 17:11:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF7CA22A84;
        Thu, 14 Jan 2021 22:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610662228;
        bh=g6OYRG/3XQ2pbnf3QurNm1oUXekNcgrwkKLVoaPM1W4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lqA+6vRt27b/6NAPfj2mBXuqIAuJlWdZ/udTmVGtdqAxVOMAxwkdcyhlllsCedPsM
         eTwVH+h3yv8TFBNZUPAalyxS/qPVk00XbYb1aEX2HQ0JPSdRlvO8BGEO4m2fRalE5I
         rzTzEb/tENVwXVVhBz1eJ8oS6Dil73SnGSk7/YoJ+Xihqg3IvGfp7wAk0ccfikVJPh
         0ShzXeEg9ggYA/BlzZu1LFe9qugAoW5Msof+7eh/xOiOqVAyjoWwvA4DNLkXgQV9gh
         wFJcHzqna6U7rJ4dGb4Sd017GxT8q7kTEgoSLth17CVigvF7YxPKFAZA1wMG2/VV9Y
         CKAD/Pm4WUwmQ==
Date:   Thu, 14 Jan 2021 14:10:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: flush speculative space allocations when we run
 out of quota
Message-ID: <20210114221027.GH1164246@magnolia>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040738496.1582114.17998753962128996136.stgit@magnolia>
 <20210112012249.GP331610@dread.disaster.area>
 <20210112013126.GJ1164246@magnolia>
 <20210112014045.GQ331610@dread.disaster.area>
 <20210112021837.GO1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112021837.GO1164246@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 06:18:37PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 12, 2021 at 12:40:45PM +1100, Dave Chinner wrote:
> > On Mon, Jan 11, 2021 at 05:31:26PM -0800, Darrick J. Wong wrote:
> > > On Tue, Jan 12, 2021 at 12:22:49PM +1100, Dave Chinner wrote:
> > > > On Mon, Jan 11, 2021 at 03:23:05PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > If a fs modification (creation, file write, reflink, etc.) is unable to
> > > > > reserve enough quota to handle the modification, try clearing whatever
> > > > > space the filesystem might have been hanging onto in the hopes of
> > > > > speeding up the filesystem.  The flushing behavior will become
> > > > > particularly important when we add deferred inode inactivation because
> > > > > that will increase the amount of space that isn't actively tied to user
> > > > > data.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  fs/xfs/xfs_bmap_util.c |   16 ++++++++++++++++
> > > > >  fs/xfs/xfs_file.c      |    2 +-
> > > > >  fs/xfs/xfs_icache.c    |    9 +++++++--
> > > > >  fs/xfs/xfs_icache.h    |    2 +-
> > > > >  fs/xfs/xfs_inode.c     |   17 +++++++++++++++++
> > > > >  fs/xfs/xfs_ioctl.c     |    2 ++
> > > > >  fs/xfs/xfs_iomap.c     |   20 +++++++++++++++++++-
> > > > >  fs/xfs/xfs_reflink.c   |   40 +++++++++++++++++++++++++++++++++++++---
> > > > >  fs/xfs/xfs_trace.c     |    1 +
> > > > >  fs/xfs/xfs_trace.h     |   40 ++++++++++++++++++++++++++++++++++++++++
> > > > >  10 files changed, 141 insertions(+), 8 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > > > index 7371a7f7c652..437fdc8a8fbd 100644
> > > > > --- a/fs/xfs/xfs_bmap_util.c
> > > > > +++ b/fs/xfs/xfs_bmap_util.c
> > > > > @@ -761,6 +761,7 @@ xfs_alloc_file_space(
> > > > >  	 */
> > > > >  	while (allocatesize_fsb && !error) {
> > > > >  		xfs_fileoff_t	s, e;
> > > > > +		bool		cleared_space = false;
> > > > >  
> > > > >  		/*
> > > > >  		 * Determine space reservations for data/realtime.
> > > > > @@ -803,6 +804,7 @@ xfs_alloc_file_space(
> > > > >  		/*
> > > > >  		 * Allocate and setup the transaction.
> > > > >  		 */
> > > > > +retry:
> > > > >  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
> > > > >  				resrtextents, 0, &tp);
> > > > >  
> > > > > @@ -819,6 +821,20 @@ xfs_alloc_file_space(
> > > > >  		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > >  		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
> > > > >  						      0, quota_flag);
> > > > > +		/*
> > > > > +		 * We weren't able to reserve enough quota to handle fallocate.
> > > > > +		 * Flush any disk space that was being held in the hopes of
> > > > > +		 * speeding up the filesystem.  We hold the IOLOCK so we cannot
> > > > > +		 * do a synchronous scan.
> > > > > +		 */
> > > > > +		if ((error == -ENOSPC || error == -EDQUOT) && !cleared_space) {
> > > > > +			xfs_trans_cancel(tp);
> > > > > +			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > > +			cleared_space = xfs_inode_free_quota_blocks(ip, false);
> > > > > +			if (cleared_space)
> > > > > +				goto retry;
> > > > > +			return error;
> > > > 
> > > > Can't say I'm a fan of repeating this everywhere.  Can we move this
> > > > into xfs_trans_reserve_quota_nblks() with a "retry" flag such that
> > > > we do:
> > > > 
> > > > 	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0,
> > > > 					quota_flag, &retry);
> > > > 	if (error) {
> > > > 		/* tp already cancelled, inode unlocked */
> > > > 		return error;
> > > > 	}
> > > > 	if (retry) {
> > > > 		/* tp already cancelled, inode unlocked */
> > > > 		goto retry;
> > > > 	}
> > > 
> > > Assuming you'd be interested in the same kind of change being applied to
> > > the next patch (kick the inode reclaim from xfs_trans_reserve on ENOSPC)
> > > then yes, that seems like a nice cleanup.
> > 
> > *nod*
> > 
> > It definitely seems to me to be cleaner to put all this GC stuff
> > into the transaction setup code that does the actual space
> > reservation, and then simply have the code that is setting up the
> > transactions handle failures appropriately.
> 
> I tried converting this and it wasn't as easy as I thought.
> 
> The downside is that now we have a function that sometimes consumes the
> transaction and the ILOCK, and there's still the question of what to do
> if xfs_inode_free_quota_blocks doesn't find any space to free.
> 
> By leaving all the ugliness in the call sites, we maintain the property
> that the function that allocates the transaction and ilocks the inode
> also gets to iunlock and free the tp, and we can also skip the retry if
> the eofblocks flush doesn't clear anything.
> 
> It might be easier to rework this as a xfs_trans_alloc_quota function
> wherein you feed it a tres, the inode, the number of blocks you want,
> and whether or not this is an rt extent; and either it reserves and
> locks everything for you, or returns failure.  The downside is that
> doesn't work for reflink since it doesn't always require quota
> reservation to remap an extent.
> 
> But it's pretty late in the day and my brain is scrambled eggs so I'll
> defer until tomorrow.

...until three days later.  You were right, it wasn't so difficult to
make xfs_trans_reserve_quota_nblks cancel the transaction on all errors,
and run the scan if it hit edquot/enospc.

--D

> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
