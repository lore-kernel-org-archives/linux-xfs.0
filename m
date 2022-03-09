Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F50DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 01:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiCIBkd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Mar 2022 20:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiCIBkb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Mar 2022 20:40:31 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A97ABD555E
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 17:39:24 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 46A99530D32;
        Wed,  9 Mar 2022 12:12:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRks5-003Cbv-H9; Wed, 09 Mar 2022 12:12:09 +1100
Date:   Wed, 9 Mar 2022 12:12:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reserve quota for directory expansion when
 hardlinking files
Message-ID: <20220309011209.GD661808@dread.disaster.area>
References: <20220301025118.GG117732@magnolia>
 <20220308221855.GC661808@dread.disaster.area>
 <20220308231742.GA8241@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308231742.GA8241@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6227feea
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=az-4o-Us2ieqQ9VoH0MA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 08, 2022 at 03:17:42PM -0800, Darrick J. Wong wrote:
> On Wed, Mar 09, 2022 at 09:18:55AM +1100, Dave Chinner wrote:
> > On Mon, Feb 28, 2022 at 06:51:18PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > The XFS implementation of the linkat call does not reserve quota for the
> > > potential directory expansion.  This means that we don't reject the
> > > expansion with EDQUOT when we're at or near a hard limit, which means
> > > that one can use linkat() to exceed quota.  Fix this by adding a quota
> > > reservation.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_inode.c |    4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 04bf467b1090..6e556c9069e8 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -1249,6 +1249,10 @@ xfs_link(
> > >  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> > >  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> > >  
> > > +	error = xfs_trans_reserve_quota_nblks(tp, tdp, resblks, 0, false);
> > > +	if (error)
> > > +		goto error_return;
> > > +

Hmmm - I just noticed that trans_alloc_icreate and trans_alloc_inode
also run a blockgc pass on EDQUOT or ENOSPC when they fail to
reserve quota to try to free up some space before retrying. Do we
need that here, too?

> > >  	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> > >  			XFS_IEXT_DIR_MANIP_CNT(mp));
> > >  	if (error)
> > 
> > Yup, ok, but doesn't xfs_remove have exactly the same problem? i.e.
> 
> Yes, it does, however, the reason I don't have a fix for that ready is
> that...
> 
> > removing a directory entry can punch a hole in the bmbt and require
> > new allocations for a BMBT split, thereby increasing the number of
> 
> ...rejecting a directory unlink with EDQUOT creates the situation where
> a user who's gone over the soft limit cannot rm a file to get themselves
> back under quota because the removal asked for enough bmbt-expansion
> quota reservation to push the quota over the hard limit...

Both link and remove already have "zero reservation" paths for
ENOSPC - if they are to be made quota aware they'll end up with
resblks = 0 and so xfs_trans_reserve_quota_nblks() is a no-op at
ENOSPC. So ....

> 
> > blocks allocated to the directory? e.g. remove a single data block,
> > need to then allocate half a dozen BMBT blocks for the shape change.
> 
> ...and while the next thing that occurred to me was to retry the quota
> reservation with FORCE_RES, having such a path means that one can still
> overrun the hard limit (albeit slowly) by creating a fragmented
> directory and selectively removing entries to cause bmbt splits.

> I /think/ I'm ok with the "retry with FORCE_QUOTA" solution for
> xfs_remove, but I'm hanging onto it for now for further consideration
> and QA testing.

... yes, I think this would be just fine. I don't think we really
care in any way about people trying to grow their quota beyond the
hard limit by a few blocks by intentionally fragmenting really large
directories. If their quota allows them directories and inode counts
large enough for this to be an avenue to exceeding hard quota limits
by a block or two, nobody is going to notice about a block or two or
extra space usage.

> > If so, then both xfs_link() and xfs_remove() have exactly the same
> > dquot, inode locking and transaction setup code and requirements,
> > and probably should be factored out into xfs_trans_alloc_dir() (i.e.
> > equivalent of xfs_trans_alloc_icreate() used by all the inode create
> > functions).  That way we only have one copy of this preamble and
> > only need to fix the bug in one place?
> 
> They're not the same problem -- adding hardlinks is not a known strategy
> for reducing quota usage below the limits, whereas unlinking files is.
> 
> > Alternatively, fix the bug in both places first and add a followup
> > patch that factors out this code as per above.
> 
> I sent a patch for the link situation because I thought it looked like
> an obvious fix, and left the unlink() problem until a full solution is
> presented or proved impossible.

Ok. None of this was mentioned in the patch, so I had no idea about
any of the things you are doing behind the scenes. I simply saw the
same problem in other places....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
