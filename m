Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C11E4C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 04:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDKETC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDKETB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 00:19:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4344610E6
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 21:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A95D561B71
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 04:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041DBC433D2;
        Tue, 11 Apr 2023 04:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681186739;
        bh=kr4NCIC4KQLmRDtNJ9YUwDXkPUQVdU+wmROZyBnM/c8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VG94+3S+Yg75G+JAgqxxXrOVYZ9j8J5HyjnW6gpUaD264WXKawCwbpPp0oH9uRtFU
         Kj48wV5BKZ4vKjVcKCoOIp2Pi3wX93xQBXsLS+/nbgBidC/hUZJ2zObrM+DRw+20cP
         iEHkQBrlWZaTLaKXDpNWy+pA6UEZ39pxFWi4wVpB4P4JtFrjN88D6JR7gDAn+ex78T
         JDewPVvA9EQFYo/CosSvj742Jwne0u5XdWaHo8116v+2mqXIcH+KR3jSk/PdvSe2p9
         +kP6FR7F5VdTB5lIkEL+X6KY/kVCBduPaGEVc7T7b7Gq3NuW+Pdpzibx+HP8zJ20Ko
         4WAqf+H5MZ1UA==
Date:   Mon, 10 Apr 2023 21:18:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: _{attr,data}_map_shared should take ILOCK_EXCL
 until iread_extents is completely done
Message-ID: <20230411041858.GB360895@frogsfrogsfrogs>
References: <20230411010638.GF360889@frogsfrogsfrogs>
 <20230411032035.GZ3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411032035.GZ3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 01:20:35PM +1000, Dave Chinner wrote:
> On Mon, Apr 10, 2023 at 06:06:38PM -0700, Darrick J. Wong wrote:
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
> > Fix this race by adding a flag to the xfs_ifork structure to indicate
> > that we have not yet read in the extent records and changing the
> > predicate to look at the flag state, not if_height.  The memory barrier
> > ensures that the flag will not be set until the very end of the
> > function.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       |    2 ++
> >  fs/xfs/libxfs/xfs_inode_fork.c |    2 ++
> >  fs/xfs/libxfs/xfs_inode_fork.h |    3 ++-
> >  3 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 34de6e6898c4..5f96e7ce7b4a 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -1171,6 +1171,8 @@ xfs_iread_extents(
> >  		goto out;
> >  	}
> >  	ASSERT(ir.loaded == xfs_iext_count(ifp));
> > +	smp_mb();
> > +	ifp->if_needextents = 0;
> 
> Hmmm - if this is to ensure that everything above is completed
> before the clearing of this flag is visible everywhere else, then we
> should be able to use load_acquire/store_release semantics? i.e. the
> above is
> 
> 	smp_store_release(ifp->if_needextents, 0);
> 
> and we use
> 
> 	smp_load_acquire(ifp->if_needextents)
> 
> when we need to read the value to ensure that all the changes made
> before the relevant stores are also visible?

I think we can; see below.

> >  	return 0;
> >  out:
> >  	xfs_iext_destroy(ifp);
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 6b21760184d9..eadae924dc42 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -174,6 +174,8 @@ xfs_iformat_btree(
> >  	int			level;
> >  
> >  	ifp = xfs_ifork_ptr(ip, whichfork);
> > +	ifp->if_needextents = 1;
> 
> Hmmm - what's the guarantee that the reader will see ifp->if_format
> set correctly if they if_needextents = 1?

At this point in the iget miss path, the only thread that can see the
xfs_inode object is the one currently running the miss path.  I think
the spin_lock call to add the inode to the radix tree is sufficient to
guarantee that both if_format and if_needextents are set consistently
when any other thread gains the ability to find the inode in the radix
tree.

That said, smp_store_release/smp_load_acquire would make that more
explicit.

How will we port this to userspace libxfs?

> Wouldn't it be better to set this at the same time we set the
> ifp->if_format value? We clear it unconditionally above in
> xfs_iread_extents(), so why not set it unconditionally there, too,
> before we start. i.e.
> 
> 	/*
> 	 * Set the format before we set needsextents with release
> 	 * semantics. This ensures that we can use acquire semantics
> 	 * on needextents in xfs_need_iread_extents() and be
> 	 * guaranteed to see a valid format value after that load.
> 	 */
> 	ifp->if_format = dip->di_format;
> 	smp_store_release(ifp->if_needextents, 1);
> 
> That then means xfs_need_iread_extents() is guaranteed to see a
> valid ifp->if_format if ifp->if_needextents is set if we do:

I think we should be smp_stor'ing needextents as appropriate for
if_format, so that...

> /* returns true if the fork has extents but they are not read in yet. */
> static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
> {
> 
> 	/* see xfs_iread_extents() for needextents semantics */
> 	return smp_load_acquire(ifp->if_needextents) &&
> 			ifp->if_format == XFS_DINODE_FMT_BTREE;

...then we don't need this FMT_BTREE check at all anymore.

--D

> }
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
