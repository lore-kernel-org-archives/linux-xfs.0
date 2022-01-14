Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FC1C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jan 2022 17:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiANRfj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jan 2022 12:35:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37854 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiANRfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jan 2022 12:35:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 784E5B829D1
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jan 2022 17:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14617C36AE9;
        Fri, 14 Jan 2022 17:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642181736;
        bh=wZcGwoTC6Ga03iG5RWf8dnjKq64Fa6KlGf/pSc76GXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J/fEn9N976sTlt39IIB/TsNstfeJ6rlDt27ghivPm329/W6SH86BRWGU2qW1TZ/Er
         LeVc7QPhub4Nb0SQ1VwcKCGf7hJ0EqryRN/CGNrMJPqNkqij25qAWI9PqCZn/6YjCX
         C8qJo3DLxcpY0rOhALZLAgdDOLFIenUWSDKl3JiNBiCw0ArM32kcsICWow9UIHBPgK
         l8r1jFAaPXQT8KPp4K5M2uQvEMepCuRxbrKRbs4u28Rfp4/zz0r/PJq+ooeZvGUAPQ
         /wK/snUl3GyC2MFTFJ5Ba9Vo0JutTW/AI6jRx2DYDR2NniLdElKOV+8Svo8+bMh5vd
         m2ZeCIT+OAo8Q==
Date:   Fri, 14 Jan 2022 09:35:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20220114173535.GA90423@magnolia>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-3-bfoster@redhat.com>
 <20220113223810.GG3290465@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113223810.GG3290465@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 14, 2022 at 09:38:10AM +1100, Dave Chinner wrote:
> On Thu, Jan 13, 2022 at 08:37:01AM -0500, Brian Foster wrote:
> > We've had reports on distro (pre-deferred inactivation) kernels that
> > inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> > lock when invoked on a frozen XFS fs. This occurs because
> > drop_caches acquires the lock and then blocks in xfs_inactive() on
> > transaction alloc for an inode that requires an eofb trim. unfreeze
> > then blocks on the same lock and the fs is deadlocked.
> > 
> > With deferred inactivation, the deadlock problem is no longer
> > present because ->destroy_inode() no longer blocks whether the fs is
> > frozen or not. There is still unfortunate behavior in that lookups
> > of a pending inactive inode spin loop waiting for the pending
> > inactive state to clear, which won't happen until the fs is
> > unfrozen. This was always possible to some degree, but is
> > potentially amplified by the fact that reclaim no longer blocks on
> > the first inode that requires inactivation work. Instead, we
> > populate the inactivation queues indefinitely. The side effect can
> > be observed easily by invoking drop_caches on a frozen fs previously
> > populated with eofb and/or cowblocks inodes and then running
> > anything that relies on inode lookup (i.e., ls).
> > 
> > To mitigate this behavior, invoke internal blockgc reclaim during
> > the freeze sequence to guarantee that inode eviction doesn't lead to
> > this state due to eofb or cowblocks inodes. This is similar to
> > current behavior on read-only remount. Since the deadlock issue was
> > present for such a long time, also document the subtle
> > ->destroy_inode() constraint to avoid unintentional reintroduction
> > of the deadlock problem in the future.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_super.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index c7ac486ca5d3..1d0f87e47fa4 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -623,8 +623,13 @@ xfs_fs_alloc_inode(
> >  }
> >  
> >  /*
> > - * Now that the generic code is guaranteed not to be accessing
> > - * the linux inode, we can inactivate and reclaim the inode.
> > + * Now that the generic code is guaranteed not to be accessing the inode, we can
> > + * inactivate and reclaim it.
> > + *
> > + * NOTE: ->destroy_inode() can be called (with ->s_umount held) while the
> > + * filesystem is frozen. Therefore it is generally unsafe to attempt transaction
> > + * allocation in this context. A transaction alloc that blocks on frozen state
> > + * from a context with ->s_umount held will deadlock with unfreeze.
> >   */
> >  STATIC void
> >  xfs_fs_destroy_inode(
> > @@ -764,6 +769,16 @@ xfs_fs_sync_fs(
> >  	 * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> >  	 */
> >  	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
> > +		struct xfs_icwalk	icw = {0};
> > +
> > +		/*
> > +		 * Clear out eofb and cowblocks inodes so eviction while frozen
> > +		 * doesn't leave them sitting in the inactivation queue where
> > +		 * they cannot be processed.
> > +		 */
> > +		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> > +		xfs_blockgc_free_space(mp, &icw);
> 
> Is a SYNC walk safe to run here? I know we run
> xfs_blockgc_free_space() from XFS_IOC_FREE_EOFBLOCKS under
> SB_FREEZE_WRITE protection, but here we have both frozen writes and
> page faults we're running in a much more constrained freeze context
> here.
> 
> i.e. the SYNC walk will keep busy looping if it can't get the
> IOLOCK_EXCL on an inode that is in cache, so if we end up with an
> inode locked and blocked on SB_FREEZE_WRITE or SB_FREEZE_PAGEFAULT
> for whatever reason this will never return....

Are you referring to the case where one could be read()ing from a file
into a buffer that's really a mmap'd page from another file while the
underlying fs is being frozen?

Also, I added this second patch and fstests runtime went up by 30%.
ISTR Dave commenting that freeze time would go way up when I submitted a
patch to clean out the cow blocks a few years ago.

Also also looking through the archives[1], Brian once commented that
cleaning up all this stuff should be done /if/ one decides to mount the
frozen-snapshot writable at some later point in time.

Maybe this means we ought to find a way to remove inodes from the percpu
inactivation lists?  iget used to be able to pry inodes out of deferred
inactivation...

[1] https://lore.kernel.org/linux-xfs/20190117181406.GF37591@bfoster/

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
