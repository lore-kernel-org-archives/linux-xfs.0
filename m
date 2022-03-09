Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB631C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 16:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbiCIQ4F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 11:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiCIQvn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 11:51:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FE2199E0D
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 08:44:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 146CA61ADB
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6524FC340E8;
        Wed,  9 Mar 2022 16:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646844286;
        bh=hSNrps67nHJLL0HqxVPrBOt9xtNP0zL2N9dAOKGTAFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=liuao5QWktQZkUqRt9ll8GQpgLs0vHVsewOtk9HCokui3dzA4aHJcO/R6NoiV1yUg
         NECyJTCy03ZASB0EaaR2MB375yQIZsEgU41l6z7HBKq9evuDFYwkdVntTHUUYYN6XX
         nU7OksWRk5vjw0y8gLh1gK05cqSpAhNcbDajsbSN0Xe19AJ5uNUEx9FLstttc2o3DM
         aaphH7sSai9jLApog0xqthbsP471VsawbBg13X/ldY4awiPV70tF47ZYOEwdTi3cJv
         iNWBuey7pjLEgaRKUEeNF/OTrG2Lozl+mmBoTPW4a0dKarr8zWsPCCS5DEaeInq2ND
         kFJ/GeRRqOYUQ==
Date:   Wed, 9 Mar 2022 08:44:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reserve quota for directory expansion when
 hardlinking files
Message-ID: <20220309164445.GC8224@magnolia>
References: <20220301025118.GG117732@magnolia>
 <20220308221855.GC661808@dread.disaster.area>
 <20220308231742.GA8241@magnolia>
 <20220309011209.GD661808@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309011209.GD661808@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 12:12:09PM +1100, Dave Chinner wrote:
> On Tue, Mar 08, 2022 at 03:17:42PM -0800, Darrick J. Wong wrote:
> > On Wed, Mar 09, 2022 at 09:18:55AM +1100, Dave Chinner wrote:
> > > On Mon, Feb 28, 2022 at 06:51:18PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > The XFS implementation of the linkat call does not reserve quota for the
> > > > potential directory expansion.  This means that we don't reject the
> > > > expansion with EDQUOT when we're at or near a hard limit, which means
> > > > that one can use linkat() to exceed quota.  Fix this by adding a quota
> > > > reservation.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/xfs_inode.c |    4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > index 04bf467b1090..6e556c9069e8 100644
> > > > --- a/fs/xfs/xfs_inode.c
> > > > +++ b/fs/xfs/xfs_inode.c
> > > > @@ -1249,6 +1249,10 @@ xfs_link(
> > > >  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> > > >  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> > > >  
> > > > +	error = xfs_trans_reserve_quota_nblks(tp, tdp, resblks, 0, false);
> > > > +	if (error)
> > > > +		goto error_return;
> > > > +
> 
> Hmmm - I just noticed that trans_alloc_icreate and trans_alloc_inode
> also run a blockgc pass on EDQUOT or ENOSPC when they fail to
> reserve quota to try to free up some space before retrying. Do we
> need that here, too?

(Re)trying to clear more space sounds like a good idea.

> > > >  	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> > > >  			XFS_IEXT_DIR_MANIP_CNT(mp));
> > > >  	if (error)
> > > 
> > > Yup, ok, but doesn't xfs_remove have exactly the same problem? i.e.
> > 
> > Yes, it does, however, the reason I don't have a fix for that ready is
> > that...
> > 
> > > removing a directory entry can punch a hole in the bmbt and require
> > > new allocations for a BMBT split, thereby increasing the number of
> > 
> > ...rejecting a directory unlink with EDQUOT creates the situation where
> > a user who's gone over the soft limit cannot rm a file to get themselves
> > back under quota because the removal asked for enough bmbt-expansion
> > quota reservation to push the quota over the hard limit...
> 
> Both link and remove already have "zero reservation" paths for
> ENOSPC - if they are to be made quota aware they'll end up with
> resblks = 0 and so xfs_trans_reserve_quota_nblks() is a no-op at
> ENOSPC. So ....
> 
> > 
> > > blocks allocated to the directory? e.g. remove a single data block,
> > > need to then allocate half a dozen BMBT blocks for the shape change.
> > 
> > ...and while the next thing that occurred to me was to retry the quota
> > reservation with FORCE_RES, having such a path means that one can still
> > overrun the hard limit (albeit slowly) by creating a fragmented
> > directory and selectively removing entries to cause bmbt splits.
> 
> > I /think/ I'm ok with the "retry with FORCE_QUOTA" solution for
> > xfs_remove, but I'm hanging onto it for now for further consideration
> > and QA testing.
> 
> ... yes, I think this would be just fine. I don't think we really
> care in any way about people trying to grow their quota beyond the
> hard limit by a few blocks by intentionally fragmenting really large
> directories. If their quota allows them directories and inode counts
> large enough for this to be an avenue to exceeding hard quota limits
> by a block or two, nobody is going to notice about a block or two or
> extra space usage.

At least for the link case, you can trivially continue to expand the
directory by hardlinking the same file over and over.  Part of the
weirdness here might be related to the fact that a transaction with no
quota reservation is allowed to commit the quota usage changes, even if
that would bump them past the limit.

Hm.  Perhaps the trick here should be that we reduce resblks to zero for
ENOSPC or EDQUOT, which means that you can continue link()ing files
into a directory so long as it won't cause the dir to expand.
xfs_remove (aka unlink()) handles reservationless removals by deferring
the directory shrink operation if there isn't space, so I think it can
be ported to use the new "alloc and reserve" function too.

> > > If so, then both xfs_link() and xfs_remove() have exactly the same
> > > dquot, inode locking and transaction setup code and requirements,
> > > and probably should be factored out into xfs_trans_alloc_dir() (i.e.
> > > equivalent of xfs_trans_alloc_icreate() used by all the inode create
> > > functions).  That way we only have one copy of this preamble and
> > > only need to fix the bug in one place?
> > 
> > They're not the same problem -- adding hardlinks is not a known strategy
> > for reducing quota usage below the limits, whereas unlinking files is.
> > 
> > > Alternatively, fix the bug in both places first and add a followup
> > > patch that factors out this code as per above.
> > 
> > I sent a patch for the link situation because I thought it looked like
> > an obvious fix, and left the unlink() problem until a full solution is
> > presented or proved impossible.
> 
> Ok. None of this was mentioned in the patch, so I had no idea about
> any of the things you are doing behind the scenes. I simply saw the
> same problem in other places....

Yeah, there are more fiddly fixes for setattr coming down the line
too...

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
