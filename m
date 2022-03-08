Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB87C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Mar 2022 23:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiCHXUY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Mar 2022 18:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiCHXUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Mar 2022 18:20:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B149F3AB
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 15:19:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D96CD612C6
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 23:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEDAC340EB;
        Tue,  8 Mar 2022 23:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646781463;
        bh=HMuCHHW57jhYfBvCDogcsmwi71l6tmStgBSWI3apJgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SZxitsCD/gWwjFEKTloiy4UJ+t8hty2sWRxLVpwibFcyxDRZMF0oAmYGGUrM2awr1
         zkk5QZFuS1t516bmcDt1906K5it9MnYYdBHD7yPkVFdqEcJ1ANoJfozEkzVX3JTWdL
         Ee5DhSi9GiFMrI3IMDk2pYPUCBFbSMRRz/mN5NBzPvyeN/FdIcKU8GJe/sUf+gw1e4
         b9VNYBAkAXe60HsyL8df56M/U7RJ5vg65iR1/fbvfpbbD9ysFjdCg4YLTq+3tboDRf
         OTTiWZlSlpBX/74fX83SIVdwzeX4uWS6lnNDH/uxDJW5OCYzLMKquPuWhwbR5xEttD
         4bmlchpohWg5Q==
Date:   Tue, 8 Mar 2022 15:17:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reserve quota for directory expansion when
 hardlinking files
Message-ID: <20220308231742.GA8241@magnolia>
References: <20220301025118.GG117732@magnolia>
 <20220308221855.GC661808@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308221855.GC661808@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 09:18:55AM +1100, Dave Chinner wrote:
> On Mon, Feb 28, 2022 at 06:51:18PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The XFS implementation of the linkat call does not reserve quota for the
> > potential directory expansion.  This means that we don't reject the
> > expansion with EDQUOT when we're at or near a hard limit, which means
> > that one can use linkat() to exceed quota.  Fix this by adding a quota
> > reservation.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_inode.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 04bf467b1090..6e556c9069e8 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1249,6 +1249,10 @@ xfs_link(
> >  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> >  
> > +	error = xfs_trans_reserve_quota_nblks(tp, tdp, resblks, 0, false);
> > +	if (error)
> > +		goto error_return;
> > +
> >  	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> >  			XFS_IEXT_DIR_MANIP_CNT(mp));
> >  	if (error)
> 
> Yup, ok, but doesn't xfs_remove have exactly the same problem? i.e.

Yes, it does, however, the reason I don't have a fix for that ready is
that...

> removing a directory entry can punch a hole in the bmbt and require
> new allocations for a BMBT split, thereby increasing the number of

...rejecting a directory unlink with EDQUOT creates the situation where
a user who's gone over the soft limit cannot rm a file to get themselves
back under quota because the removal asked for enough bmbt-expansion
quota reservation to push the quota over the hard limit...

> blocks allocated to the directory? e.g. remove a single data block,
> need to then allocate half a dozen BMBT blocks for the shape change.

...and while the next thing that occurred to me was to retry the quota
reservation with FORCE_RES, having such a path means that one can still
overrun the hard limit (albeit slowly) by creating a fragmented
directory and selectively removing entries to cause bmbt splits.

I /think/ I'm ok with the "retry with FORCE_QUOTA" solution for
xfs_remove, but I'm hanging onto it for now for further consideration
and QA testing.

> If so, then both xfs_link() and xfs_remove() have exactly the same
> dquot, inode locking and transaction setup code and requirements,
> and probably should be factored out into xfs_trans_alloc_dir() (i.e.
> equivalent of xfs_trans_alloc_icreate() used by all the inode create
> functions).  That way we only have one copy of this preamble and
> only need to fix the bug in one place?

They're not the same problem -- adding hardlinks is not a known strategy
for reducing quota usage below the limits, whereas unlinking files is.

> Alternatively, fix the bug in both places first and add a followup
> patch that factors out this code as per above.

I sent a patch for the link situation because I thought it looked like
an obvious fix, and left the unlink() problem until a full solution is
presented or proved impossible.

> Hmmm - looking further a callers of xfs_lock_two_inodes(), it would
> appear that xfs_swap_extents() needs the same quota reservation
> and also largely has the same transaction setup and inode locking
> preamble as link and remove...

Yes, I know about that problem.  I've *solved* that problem with the
atomic extent swap rewrite that's been hanging out in djwong-dev since
late 2019 as part of the online fsck series.  Perhaps I will have time
to send that in late 2022.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
