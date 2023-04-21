Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AD2C7618E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 15:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbjDUPcV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 11:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbjDUPcU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 11:32:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E5B2682
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 08:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FD6260ED0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 15:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89E5C433D2;
        Fri, 21 Apr 2023 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682091136;
        bh=irVb/SHt04/wVlG+A4swJLQK41tx8X6PwhbzC13siro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QuLXpoQVrE/jedZATL9litJ4yJrbk0waptPxjtNZ6R5DxzFOGX4yiGssrx0xPVecS
         iaeK/11Kw9rDy3uliKOcyi+fOio+rqcc4C5i9NT7GfUha+juiFGykyQXqg9OFpU76J
         EUKr8CvIUbpLzD9YH4GXXEuKaJSPpXywef81gtgzaaQmPso+pYUDhs8HvhOrHfco8U
         T0OypXeqP/82saiSHUXJN7jbEwgVt12i2YIqcYaDNg5Vjv6r8cJRMw4nceawhAmDig
         tSqbdVSxZlAILjR5WkvMDje/GQmq7WcGlX+b+8RL0x8QVFjbv8lHfTYRl7w+A4E9rw
         ItmqEXeDZpgvQ==
Date:   Fri, 21 Apr 2023 08:32:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Guo Xuenan <guoxuenan@huawei.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, sandeen@redhat.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH 1/3] xfs: fix leak memory when xfs_attr_inactive fails
Message-ID: <20230421153216.GI360889@frogsfrogsfrogs>
References: <20230421033142.1656296-1-guoxuenan@huawei.com>
 <20230421033142.1656296-2-guoxuenan@huawei.com>
 <20230421074932.GD3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421074932.GD3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 05:49:32PM +1000, Dave Chinner wrote:
> On Fri, Apr 21, 2023 at 11:31:40AM +0800, Guo Xuenan wrote:
> > I observed the following evidence of a leak while xfs_inactive failed.
> > Especially in Debug mode, when xfs_attr_inactive failed, current exception
> > path handling rudely clear inode attr fork, and if the inode is recycled
> > then assertion will accur, if not, which may also lead to memory leak.
> > 
> > Since xfs_attr_inactive is supposed to clean up the attribute fork when
> > the inode is being freed. While it removes the in-memory attribute fork
> > even in the event of truncate attribute fork extents failure, then some
> > attr data may left in memory and never be released. By avoiding this kind
> > of clean up and readding the inode to the gclist, this type of problems can
> > be solved to some extent.
> > 
> > The following script reliably replays the bug described above.
> > ```
> > #!/bin/bash
> > DISK=vdb
> > MP=/mnt/$DISK
> > DEV=/dev/$DISK
> > nfiles=10
> > xattr_val="this is xattr value."
> > ## prepare and mount
> > while true
> > do
> > 	pidof fsstress | xargs kill -9
> > 	umount $MP
> > 	df | grep $MP || break
> > 	sleep 2
> > done
> > 
> > mkdir -p ${MP} && mkfs.xfs -f $DEV && mount $DEV $MP
> > echo 0 > /sys/fs/xfs/$DISK/errortag/bmapifmt
> > 
> > ## create files, setxattr, remove files
> > cd $MP; touch $(seq 1 $nfiles); cd $OLDPWD
> > for n in `seq 1 $nfiles`; do
> > 	for j in `seq 1 20`; do
> > 		setfattr -n user.${j} -v "$xattr_val" $MP/$n
> > 	done
> > done
> 
> OK, so 20 xattrs of about 40 bytes on disk each in each file. That's
> enough to put them in extent format.
> 
> > ## inject fault & trigger fails
> > fsstress -d $MP -z -f bulkstat=200 -S c -l 1000 -p 8 &
> > /usr/bin/rm $MP/*
> 
> Queue everything up for inodegc
> 
> > echo 3 > /sys/fs/xfs/$DISK/errortag/bmapifmt
> 
> And inject random xfs_bmapi_read() errors into inodegc processing.
> 
> > ```
> > 
> > Assertion in the kernel log as follows:
> > 
> > XFS (vdb): Mounting V5 Filesystem bd1b6c38-599a-43b3-8194-a584bebec4ca
> > XFS (vdb): Ending clean mount
> > xfs filesystem being mounted at /mnt/vdb supports timestamps until 2038 (0x7fffffff)
> > XFS (vdb): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3887, on filesystem "vdb"
> > XFS: Assertion failed: ip->i_nblocks == 0, file: fs/xfs/xfs_inode.c, line: 2277
> 
> Ok, so the error injection has caused xfs_bmapi_read() when
> truncating the attr fork to return -EFSCORRUPTED, which
> xfs_inactive() has completely dropped on the ground and then failed
> to free the inode before marking if valid for reclaim.
> 
> The the inode freeing code has asserted that the inode is not clean
> and we're freeing an inode that still references filesystem blocks.
> The ASSERT() is certainly valid and should have triggered, but I
> don't think that it needs fixing. I'll get to that later.
> 
> > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > index 5db87b34fb6e..a7379beb355a 100644
> > --- a/fs/xfs/xfs_attr_inactive.c
> > +++ b/fs/xfs/xfs_attr_inactive.c
> > @@ -336,21 +336,25 @@ xfs_attr_inactive(
> >  	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
> >  
> >  	xfs_ilock(dp, lock_mode);
> > -	if (!xfs_inode_has_attr_fork(dp))
> > -		goto out_destroy_fork;
> > +	if (!xfs_inode_has_attr_fork(dp)) {
> > +		xfs_ifork_zap_attr(dp);
> > +		goto out_unlock;
> > +	}
> >  	xfs_iunlock(dp, lock_mode);
> 
> Why do we even need the lock here for this check? The inode cannot
> be found by a VFS lookup, and we are in XFS_INACTIVATING state which
> means internal inode looks will skip it too.  So nothing other than
> the inodegc code can be referencing the inode attr fork here. So
> what's the lock for?
> 
> I'd just replace this with:
> 
> 	if (!xfs_inode_has_attr_fork(dp))
> 		return 0;
> 
> >  	lock_mode = 0;
> >  
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrinval, 0, 0, 0, &trans);
> >  	if (error)
> > -		goto out_destroy_fork;
> > +		goto out_unlock;
> 
> We have nothing locked here.
> 
> 	if (error)
> 		return error;
> 
> >  	lock_mode = XFS_ILOCK_EXCL;
> >  	xfs_ilock(dp, lock_mode);
> >  
> > -	if (!xfs_inode_has_attr_fork(dp))
> > +	if (!xfs_inode_has_attr_fork(dp)) {
> > +		xfs_ifork_zap_attr(dp);
> >  		goto out_cancel;
> > +	}
> >  
> >  	/*
> >  	 * No need to make quota reservations here. We expect to release some
> > @@ -383,9 +387,7 @@ xfs_attr_inactive(
> >  
> >  out_cancel:
> >  	xfs_trans_cancel(trans);
> > -out_destroy_fork:
> > -	/* kill the in-core attr fork before we drop the inode lock */
> > -	xfs_ifork_zap_attr(dp);
> > +out_unlock:
> >  	if (lock_mode)
> >  		xfs_iunlock(dp, lock_mode);
> >  	return error;
> 
> Hmmmm. No, I don't think this is right - the existing code is doing
> the right thing.
> 
> We just got an -EFSCORRUPTED from xfs_itruncate_extents(), and we
> are in the process of freeing the inode. The inode is unlinked,
> unrefered and corrupt, so we need to leak the blocks we cannot
> access in the attr fork to be able to successfully free the inode
> and continue on without shutting down the filesystem.
> 
> In this situation, we need to zap the in-memory attr fork so that
> the memory associated with the extents we just decided to leak is
> freed correctly and not leaked. Essentially, any error in this path
> should be zapping the attr fork on error here.
> 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 351849fc18ff..4afa7fec4a2f 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -48,6 +48,7 @@ static int xfs_icwalk(struct xfs_mount *mp,
> >  		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
> >  static int xfs_icwalk_ag(struct xfs_perag *pag,
> >  		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
> > +static void xfs_inodegc_queue(struct xfs_inode	*ip);
> >  
> >  /*
> >   * Private inode cache walk flags for struct xfs_icwalk.  Must not
> > @@ -1843,7 +1844,10 @@ xfs_inodegc_inactivate(
> >  {
> >  	trace_xfs_inode_inactivating(ip);
> >  	xfs_inactive(ip);
> > -	xfs_inodegc_set_reclaimable(ip);
> > +	if (VFS_I(ip)->i_mode != 0)
> > +		xfs_inodegc_queue(ip);
> > +	else
> > +		xfs_inodegc_set_reclaimable(ip);
> >  }
> 
> I don't think this works the way you think it does.
> 
> Firstly, xfs_inodegc_queue() may try to flush the work
> queue (i.e. wait for pending work to be completed) so queuing
> inodegc work from an inodegc workqueue worker could deadlock the
> inodegc workqueue.
> 
> Secondly, inodes with i_mode != 0  that aren't being unlinked are
> also pushed through this path to remove blocks beyond EOF, etc. This
> change means those inodes get permanently stuck on the inodegc queue
> as they always get readded to the queue and never marked as
> reclaimable.  See xfs_inode_mark_reclaimable() and
> xfs_inode_needs_inactive().
> 
> Thirdly, pushing an inode that failed inactivation due to corruption
> through xfs_inactive again will just result in the same corruption
> error occurring again. Hence they'll also get stuck forever in the
> inodegc loop.
> 
> Ah.
> 
> Yeah.
> 
> Except for your test case.
> 
> Error injection is random/transient, and you gave it a 33% chance of
> injecting an error. Hence it will continue looping through
> inactivation until it doesn't trigger the xfs_bmapi_read() error
> injection. Because you also changed it not to trash the attr fork on
> truncation error, the extent list remains present until every extent
> gets freed successfully.  Hence ip->i_nblocks gets reduced to zero
> before we try to free the inode and the specific failure your error
> injection test tripped over goes away.
> 
> Now I understand - this fixes a transient corruption error
> caused by error injection, but in doing so will break production
> systems that encounter persistent corruption in inode inactivation.
> 
> ---
> 
> Yes, I agree the way xfs_inactive() and inodegc handles errors and
> cleanup needs improvement, but we've known this for a while now. But
> this doesn't change the fact that we currently need to be able to
> leak resources we can't access so we can continue to operate. It's
> fine for ASSERTs to fire on debug kernels in these situations - as
> developers we need to understand when these situations occur - but
> that doesn't mean the behaviour they are warning about needs to be
> fixed. It's just telling us that we are leaking stuff, it just
> doesn't know why.

...and should probably be logging the fact that the bad inode was
dropped on the floor and the sysadmin should go run a fsck tool of some
kind to fix the problems.

> We have be waiting on having fine grained health infomration for
> inodes to be able to handle situations like this more gracefully.
> That code is being merged in 6.4, and it means that we know the

It is?

I didn't send you a pull request for
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting

for 6.4.  At some point I want to talk to you about the rest of online
fsck, but I'm taking a breather for the last week or two until LSFMM.

--D

> inode is corrupt. Hence we can tailor the debug assert to only fire
> if the inode has not encountered corruption, do smarter things in
> inodegc/reclaim when dealing with inodes that are corrupt, etc.
> 
> However, that doesn't mean the inactivation behaviour that triggered
> the assert is wrong.  That assert ioften picks up code bugs, but a
> corruption error in freeing an inode is one of the situations where
> the "leak resources we can't access to free" behaviour is
> intentional. That's what we want production machines to do, whilst
> on debug machines we want to understand why that situation happened
> and determine if there's something better we can do with it.
> 
> Hence I'd suggest looking at the inode health code in the current
> linux-xfs/for-next tree and checking that the error injection you
> are using marks the inode as unhealthy and work from there...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
