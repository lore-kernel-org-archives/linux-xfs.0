Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC80C64EC7
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Feb 2023 20:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjB1UI2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 15:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjB1UI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 15:08:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C9B1ADFA
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 12:08:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32721B80E1C
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 20:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1E2C433D2;
        Tue, 28 Feb 2023 20:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677614900;
        bh=8qrBArx3jvbR826aEsghr74+vxo6c84egUO0zvxV3gg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DDhDCKAGTaBXeihMWcqtr8/eSFjSHOZQW9+QQefNPTmo0KfvpJBJE2TpVjfk7k0Gu
         VqIZntmi82Aa6axTEPGtf39oIWTvICyV5WNtyNA14RXjZ8mvmL4hFpeQNAWfImCiDh
         ZoIp8GB8DEv8hOthadAxb/XTdo2Rf91nCsdNK2hBgUzF8btELM/8Gs03X+o/j6zkb9
         D91OnZ9glCwARCXCwo+DPqlTm7jYdck58ByD44Rfj10YcLirBXTENus7VtELAr3zUR
         ZN243WxS7KT+SvoigAxjhgbVM4v9UZzeSPMx/EQWD5AUmndgNhniJ6ZSt0BCuzyUc2
         GYTqm7GtgQdQg==
Date:   Tue, 28 Feb 2023 12:08:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: recheck appropriateness of map_shared lock
Message-ID: <Y/5fNHhdMgv21R3l@magnolia>
References: <Y8ib6ls32e/pJezE@magnolia>
 <20230119051411.GJ360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119051411.GJ360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 04:14:11PM +1100, Dave Chinner wrote:
> On Wed, Jan 18, 2023 at 05:24:58PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While fuzzing the data fork extent count on a btree-format directory
> > with xfs/375, I observed the following (excerpted) splat:
> > 
> > XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 1208
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 43192 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
> > Call Trace:
> >  <TASK>
> >  xfs_iread_extents+0x1af/0x210 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
> >  xchk_dir_walk+0xb8/0x190 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
> >  xchk_parent_count_parent_dentries+0x41/0x80 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
> >  xchk_parent_validate+0x199/0x2e0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
> >  xchk_parent+0xdf/0x130 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
> >  xfs_scrub_metadata+0x2b8/0x730 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
> >  xfs_scrubv_metadata+0x38b/0x4d0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
> >  xfs_ioc_scrubv_metadata+0x111/0x160 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
> >  xfs_file_ioctl+0x367/0xf50 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
> >  __x64_sys_ioctl+0x82/0xa0
> >  do_syscall_64+0x2b/0x80
> >  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > 
> > The cause of this is a race condition in xfs_ilock_data_map_shared,
> > which performs an unlocked access to the data fork to guess which lock
> > mode it needs:
> > 
> > Thread 0                          Thread 1
> > 
> > xfs_need_iread_extents
> > <observe no iext tree>
> > xfs_ilock(..., ILOCK_EXCL)
> > xfs_iread_extents
> > <observe no iext tree>
> > <check ILOCK_EXCL>
> > <load bmbt extents into iext>
> > <notice iext size doesn't
> >  match nextents>
> >                                   xfs_need_iread_extents
> >                                   <observe iext tree>
> >                                   xfs_ilock(..., ILOCK_SHARED)
> > <tear down iext tree>
> > xfs_iunlock(..., ILOCK_EXCL)
> >                                   xfs_iread_extents
> >                                   <observe no iext tree>
> >                                   <check ILOCK_EXCL>
> >                                   *BOOM*
> > 
> > mitigate this race by having thread 1 to recheck xfs_need_iread_extents
> > after taking the shared ILOCK.  If the iext tree isn't present, then we
> > need to upgrade to the exclusive ILOCK to try to load the bmbt.
> 
> Yup, I see the problem - this check is failing:
> 
>         if (XFS_IS_CORRUPT(mp, ir.loaded != ifp->if_nextents)) {
>                 error = -EFSCORRUPTED;
>                 goto out;
>         }
> 
> and that results in calling xfs_iext_destroy() to tear down the
> extent tree.
> 
> But we know the BMBT is corrupted and the extent list cannot be read
> until the corruption is fixed. IOWs, we can't access any data in the
> inode no matter how we lock it until the corruption is repaired.
> 
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_inode.c |   29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index d354ea2b74f9..6ce1e0e9f256 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -117,6 +117,20 @@ xfs_ilock_data_map_shared(
> >  	if (xfs_need_iread_extents(&ip->i_df))
> >  		lock_mode = XFS_ILOCK_EXCL;
> >  	xfs_ilock(ip, lock_mode);
> > +
> > +	/*
> > +	 * It's possible that the unlocked access of the data fork to determine
> > +	 * the lock mode could have raced with another thread that was failing
> > +	 * to load the bmbt but hadn't yet torn down the iext tree.  Recheck
> > +	 * the lock mode and upgrade to an exclusive lock if we need to.
> > +	 */
> > +	if (lock_mode == XFS_ILOCK_SHARED &&
> > +	    xfs_need_iread_extents(&ip->i_df)) {
> > +		xfs_iunlock(ip, lock_mode);
> > +		lock_mode = XFS_ILOCK_EXCL;
> > +		xfs_ilock(ip, lock_mode);
> > +	}
> 
> .... and this makes me cringe. :/
> 
> If we hit this race condition, re-reading the extent list from disk
> isn't going to fix the corruption, so I don't see much point in
> papering over the problem just by changing the locking and failing
> to read in the extent list again and returning -EFSCORRUPTED to the
> operation.

Doing it this (suboptimal way) means that we can backport the race fix
to older kernels without having to push the API change as well.  Threads
will continue to (pointlessly) try to load the iext tree from the
corrupt btree, but at least they won't be doing it while holding
ILOCK_SHARED.

> So.... shouldn't we mark the inode as sick when we detect the extent
> list corruption issue? i.e. before destroying the iext tree, calling
> xfs_inode_mark_sick(XFS_SICK_INO_BMBTD) (or BMBTA, depending on the
> fork being read) so that there is a record of the BMBT being
> corrupt?

Yes, we should, but the codebase is not yet ready to use
XFS_SICK_INO_BMBTD to detect bmbt corruption.  Notice this other
function call in xfs_iread_extents:

	error = xfs_btree_visit_blocks(cur, xfs_iread_bmbt_block,
			XFS_BTREE_VISIT_RECORDS, &ir);

Corruption errors in the btree code also trigger the xfs_iext_destroy
call, but the generic btree code hasn't yet been outfitted with the
appropriate _mark_sick calls to set the XFS_SICK state.

Patches to add that have been out for review since November 2019.  In
the past 39 months, only one reviewer (Brian) came forth:

https://lore.kernel.org/linux-xfs/157375555426.3692735.1357467392517392169.stgit@magnolia/

That review ended on the suggestion that callers of xfs_buf_read should
push the necessary context information through struct xfs_buf so that
verifiers themselves can trigger the health state updates.

In other words, Brian wanted me to explore capturing local variables
from the caller's state and passing the captured information to a
caller-supplied callback function.  Many other languages provide this in
the form of closures and lambda functions, but C is not one of them.  I
concluded that this approach was not feasible and moved on.

Since then, the patchset has been reposted for review in December 2019,
December 2020, December 2021, and December 2022.  Nobody has reviewed
it:

https://lore.kernel.org/linux-xfs/?q=report+corruption+to+the+health+trackers

*After* we merge online repair, it should be possible to base our
behavior off of XFS_SICK_INO_BMBTD.  However, this race affects current
kernels, which is why I sent it separately as a bug fix, keyed off of a
second call to _need_iread_extents.

--D

> That would mean that this path simply becomes:
> 
> 	if (ip->i_sick & XFS_SICK_INO_BMBTD) {
> 		xfs_iunlock(ip, lock_mode);
> 		return -EFSCORRUPTED;
> 	}
> 
> Which is now pretty clear that we there's no point continuing
> because we can't read in the extent list, and in doing so we've
> removed the race condition caused by temporarily filling the in-core
> extent list.
> 
> > +
> >  	return lock_mode;
> >  }
> >  
> > @@ -129,6 +143,21 @@ xfs_ilock_attr_map_shared(
> >  	if (xfs_inode_has_attr_fork(ip) && xfs_need_iread_extents(&ip->i_af))
> >  		lock_mode = XFS_ILOCK_EXCL;
> >  	xfs_ilock(ip, lock_mode);
> > +
> > +	/*
> > +	 * It's possible that the unlocked access of the attr fork to determine
> > +	 * the lock mode could have raced with another thread that was failing
> > +	 * to load the bmbt but hadn't yet torn down the iext tree.  Recheck
> > +	 * the lock mode and upgrade to an exclusive lock if we need to.
> > +	 */
> > +	if (lock_mode == XFS_ILOCK_SHARED &&
> > +	    xfs_inode_has_attr_fork(ip) &&
> > +	    xfs_need_iread_extents(&ip->i_af)) {
> > +		xfs_iunlock(ip, lock_mode);
> > +		lock_mode = XFS_ILOCK_EXCL;
> > +		xfs_ilock(ip, lock_mode);
> > +	}
> 
> And this can just check for XFS_SICK_INO_BMBTA instead...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
