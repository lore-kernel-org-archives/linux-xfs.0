Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCB2C47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 04:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C8F6124B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 04:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhFHEmo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 00:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhFHEmn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 00:42:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7671661249;
        Tue,  8 Jun 2021 04:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623127251;
        bh=SxgVpX0dpD56PPChKNk8c0uaTr3zIDyGmorhtM303II=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QPb9S/s0R5A7tOUBllJiIV5eCY97byTuXR+Zoa6DZsJuPA2YfWjlhzXvd2PC5Aam+
         nDFcLWVZ6e91P/NPwiz6YT0Mpt41LnKiaAE0hr3pt11yBF3FsBvDdO0odERReoXxHa
         bt+GCeMrFo5UZ08VjweomhVWut1xx9N8tweMUR3nbAzumVd0O+ZC3CTiF55JwXj6nK
         lOusKYPlfXDOqaTwsIaowYUJZSu/gNXqbPYDb1sp7IZ6WaLV1BCeOKd5VQo4mEAwqD
         W9WqjAVAnuG9XNKmAM5HCAB2Irq6I2PBGa+1NLrh2UjR44A07u+JSWdewspND0RX5K
         Sxo7MA0GyyeHQ==
Date:   Mon, 7 Jun 2021 21:40:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/9] xfs: deferred inode inactivation
Message-ID: <20210608044051.GB2945763@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310470480.3465262.12512984715866568596.stgit@locust>
 <20210608005753.GG664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608005753.GG664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 10:57:53AM +1000, Dave Chinner wrote:
> On Mon, Jun 07, 2021 at 03:25:04PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Instead of calling xfs_inactive directly from xfs_fs_destroy_inode,
> > defer the inactivation phase to a separate workqueue.  With this we
> > avoid blocking memory reclaim on filesystem metadata updates that are
> > necessary to free an in-core inode, such as post-eof block freeing, COW
> > staging extent freeing, and truncating and freeing unlinked inodes.  Now
> > that work is deferred to a workqueue where we can do the freeing in
> > batches.
> > 
> > We introduce two new inode flags -- NEEDS_INACTIVE and INACTIVATING.
> > The first flag helps our worker find inodes needing inactivation, and
> > the second flag marks inodes that are in the process of being
> > inactivated.  A concurrent xfs_iget on the inode can still resurrect the
> > inode by clearing NEEDS_INACTIVE (or bailing if INACTIVATING is set).
> > 
> > Unfortunately, deferring the inactivation has one huge downside --
> > eventual consistency.  Since all the freeing is deferred to a worker
> > thread, one can rm a file but the space doesn't come back immediately.
> > This can cause some odd side effects with quota accounting and statfs,
> > so we also force inactivation scans in order to maintain the existing
> > behaviors, at least outwardly.
> > 
> > For this patch we'll set the delay to zero to mimic the old timing as
> > much as possible; in the next patch we'll play with different delay
> > settings.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  Documentation/admin-guide/xfs.rst |    3 
> >  fs/xfs/scrub/common.c             |    2 
> >  fs/xfs/xfs_fsops.c                |    4 
> >  fs/xfs/xfs_icache.c               |  364 +++++++++++++++++++++++++++++++++++--
> >  fs/xfs/xfs_icache.h               |   35 +++-
> >  fs/xfs/xfs_inode.c                |   60 ++++++
> >  fs/xfs/xfs_inode.h                |   15 +-
> >  fs/xfs/xfs_log_recover.c          |    7 +
> >  fs/xfs/xfs_mount.c                |   29 +++
> >  fs/xfs/xfs_mount.h                |    7 +
> >  fs/xfs/xfs_qm_syscalls.c          |    4 
> >  fs/xfs/xfs_super.c                |  120 +++++++++++-
> >  fs/xfs/xfs_trace.h                |   14 +
> >  13 files changed, 620 insertions(+), 44 deletions(-)
> 
> Big patch. Much as I don't like asking people to do this, I'd like
> you to split the "xfs_inode_needs_inactivation()" factoring out of
> this patch, just to reduce the amount of churn around the
> inactivation callout code in this patch.

Ok.  Eeeeons ago I think that /was/ split out, but fmeh, I'll yank this
out along with the early-dqdetach thing too.

> There's a couple of other changes around this that should reduce the
> churn, too...
> 
> > @@ -343,6 +345,8 @@ xfs_fs_counts(
> >  	xfs_mount_t		*mp,
> >  	xfs_fsop_counts_t	*cnt)
> >  {
> > +	xfs_inodegc_summary_flush(mp);
> 
> What does "summary flush" mean? Doesn't make much sense from here...
> 
> >  	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
> >  	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
> >  	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 4d4aa61fbd34..791202236a18 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -32,6 +32,8 @@
> >  #define XFS_ICI_RECLAIM_TAG	0
> >  /* Inode has speculative preallocations (posteof or cow) to clean. */
> >  #define XFS_ICI_BLOCKGC_TAG	1
> > +/* Inode can be inactivated. */
> > +#define XFS_ICI_INODEGC_TAG	2
> >  
> >  /*
> >   * The goal for walking incore inodes.  These can correspond with incore inode
> > @@ -44,6 +46,7 @@ enum xfs_icwalk_goal {
> >  	/* Goals directly associated with tagged inodes. */
> >  	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
> >  	XFS_ICWALK_RECLAIM	= XFS_ICI_RECLAIM_TAG,
> > +	XFS_ICWALK_INODEGC	= XFS_ICI_INODEGC_TAG,
> >  };
> >  
> >  #define XFS_ICWALK_NULL_TAG	(-1U)
> > @@ -228,6 +231,26 @@ xfs_blockgc_queue(
> >  	rcu_read_unlock();
> >  }
> >  
> > +static inline bool
> > +xfs_inodegc_running(struct xfs_mount *mp)
> > +{
> > +	return test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
> > +}
> 
> Ok, these opflags are new. Not a big fan of the naming, more on that
> later.
> 
> 
> > +/* Queue a new inode gc pass if there are inodes needing inactivation. */
> > +static void
> > +xfs_inodegc_queue(
> > +	struct xfs_mount        *mp)
> > +{
> > +	if (!xfs_inodegc_running(mp))
> > +		return;
> > +
> > +	rcu_read_lock();
> > +	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
> > +		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
> > +	rcu_read_unlock();
> > +}
> 
> I have no idea why we are checking if the gc is running here. All
> our other background stuff runs and re-queues until it is directly
> stopped or there's nothing left in the tree. Hence I'm a bit
> clueless right now about what this semantic is for...

The opflag is supposed to control whether inactivation actually runs.
As you might guess from _running calls being scattered everywhere, it's
pretty ugly code.  All this crap exists because there's no easy solution
to shutting down background threads after we commit to freezing the fs
but before an fs freeze hits SB_FREEZE_FS and we can't allocate new
transactions.

Fixing inactivation to use NO_WRITECOUNT means auditing every function
call that xfs_inactive makes to look for an xfs_trans_alloc* call and
probably modifying all of them to be able to switch between regular and
NOWRITECOUNT mode.  I tried that, it's ugly.

Another solution is to add ->freeze_super and ->thaw_super functions
to prevent a FITHAW caller from racing with a FIFREEZE caller and
accidentally rearming the inodegc while a freeze starts.

Yet a third solution is to fix the vfs to call us every time it wants to
progress to another freeze state.

A fourth solution is the fugly one you see here in syncfs.

> > +
> >  /* Set a tag on both the AG incore inode tree and the AG radix tree. */
> >  static void
> >  xfs_perag_set_inode_tag(
> > @@ -262,6 +285,9 @@ xfs_perag_set_inode_tag(
> >  	case XFS_ICI_BLOCKGC_TAG:
> >  		xfs_blockgc_queue(pag);
> >  		break;
> > +	case XFS_ICI_INODEGC_TAG:
> > +		xfs_inodegc_queue(mp);
> > +		break;
> >  	}
> 
> And there's the on-demand start...
> 
> > @@ -308,18 +334,28 @@ xfs_perag_clear_inode_tag(
> >   */
> >  void
> >  xfs_inode_mark_reclaimable(
> > -	struct xfs_inode	*ip)
> > +	struct xfs_inode	*ip,
> > +	bool			need_inactive)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_perag	*pag;
> > +	unsigned int		tag;
> >  
> >  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> >  	spin_lock(&pag->pag_ici_lock);
> >  	spin_lock(&ip->i_flags_lock);
> >  
> > -	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> > -			XFS_ICI_RECLAIM_TAG);
> > -	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
> > +	if (need_inactive) {
> > +		trace_xfs_inode_set_need_inactive(ip);
> > +		ip->i_flags |= XFS_NEED_INACTIVE;
> > +		tag = XFS_ICI_INODEGC_TAG;
> > +	} else {
> > +		trace_xfs_inode_set_reclaimable(ip);
> > +		ip->i_flags |= XFS_IRECLAIMABLE;
> > +		tag = XFS_ICI_RECLAIM_TAG;
> > +	}
> > +
> > +	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino), tag);
> 
> 
> Hmmmm. Rather than passing a boolean into this function that
> indicates what needs to be done, why not move all the inactivation
> stuff into this function? i.e. move the
> xfs_inode_needs_inactivation() check into here instead of splitting
> the inactivation and reclaim logic over xfs_fs_destroy_inode() and
> this function?

Done.

> >  
> >  	spin_unlock(&ip->i_flags_lock);
> >  	spin_unlock(&pag->pag_ici_lock);
> > @@ -383,19 +419,26 @@ xfs_reinit_inode(
> >  static int
> >  xfs_iget_recycle(
> >  	struct xfs_perag	*pag,
> > -	struct xfs_inode	*ip) __releases(&ip->i_flags_lock)
> > +	struct xfs_inode	*ip,
> > +	unsigned long		iflag) __releases(&ip->i_flags_lock)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct inode		*inode = VFS_I(ip);
> > +	unsigned int		tag;
> >  	int			error;
> >  
> > +	ASSERT(iflag == XFS_IRECLAIM || iflag == XFS_INACTIVATING);
> > +
> > +	tag = (iflag == XFS_INACTIVATING) ? XFS_ICI_INODEGC_TAG :
> > +					    XFS_ICI_RECLAIM_TAG;
> 
> I don't like ternaries in code like this - just use an if-else,
> or combine the assert into a switch:
> 
> 	switch(iflag) {
> 	case XFS_INACTIVATING:
> 		tag = XFS_ICI_INODEGC_TAG;
> 		break;
> 	case XFS_IRECLAIM:
> 		tag = XFS_ICI_RECLAIM_TAG;
> 		break;
> 	default:
> 		ASSERT(0);
> 		return -EINVAL;
> 	}

Changed.

> >  	/*
> >  	 * We need to make it look like the inode is being reclaimed to prevent
> >  	 * the actual reclaim workers from stomping over us while we recycle
> >  	 * the inode.  We can't clear the radix tree tag yet as it requires
> >  	 * pag_ici_lock to be held exclusive.
> >  	 */
> > -	ip->i_flags |= XFS_IRECLAIM;
> > +	ip->i_flags |= iflag;
> >  
> >  	spin_unlock(&ip->i_flags_lock);
> >  	rcu_read_unlock();
> > @@ -412,10 +455,13 @@ xfs_iget_recycle(
> >  		rcu_read_lock();
> >  		spin_lock(&ip->i_flags_lock);
> >  		wake = !!__xfs_iflags_test(ip, XFS_INEW);
> > -		ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
> > +		ip->i_flags &= ~(XFS_INEW | iflag);
> >  		if (wake)
> >  			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
> > -		ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
> > +		if (iflag == XFS_IRECLAIM)
> > +			ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
> > +		if (iflag == XFS_INACTIVATING)
> > +			ASSERT(ip->i_flags & XFS_NEED_INACTIVE);
> >  		spin_unlock(&ip->i_flags_lock);
> >  		rcu_read_unlock();
> >  		return error;
> > @@ -431,8 +477,7 @@ xfs_iget_recycle(
> >  	 */
> >  	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
> >  	ip->i_flags |= XFS_INEW;
> > -	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> > -			XFS_ICI_RECLAIM_TAG);
> > +	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino), tag);
> >  	inode->i_state = I_NEW;
> >  	spin_unlock(&ip->i_flags_lock);
> >  	spin_unlock(&pag->pag_ici_lock);
> > @@ -455,6 +500,13 @@ xfs_iget_check_free_state(
> >  	struct xfs_inode	*ip,
> >  	int			flags)
> >  {
> > +	/*
> > +	 * Unlinked inodes awaiting inactivation must not be reused until we
> > +	 * have a chance to clear the on-disk metadata.
> > +	 */
> > +	if (VFS_I(ip)->i_nlink == 0 && (ip->i_flags & XFS_NEED_INACTIVE))
> > +		return -ENOENT;
> 
> Hmmmm. That's messy. The actual situation here is inodes that are on
> the unlinked list but have no VFS references need to be avoided.
> This should only happen in the cache hit case, so I don't think this
> belongs in xfs_iget_check_free_state() as that gets called from the
> cache miss case, too.

Agreed.

> Indeed, I think this is a case where we need to explicitly skip the
> inode in lookup, because we cannot actually recycle or re-use these
> inodes until they've been removed from the unlinked list. i.e. it's
> a primary selection criteria for a cache hit, not some that should
> be hidden in a separate function....

Ok, I'll hoist that to the top level of _cache_hit.

> > +
> >  	if (flags & XFS_IGET_CREATE) {
> >  		/* should be a free inode */
> >  		if (VFS_I(ip)->i_mode != 0) {
> > @@ -521,7 +573,7 @@ xfs_iget_cache_hit(
> >  	 *	     wait_on_inode to wait for these flags to be cleared
> >  	 *	     instead of polling for it.
> >  	 */
> > -	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
> > +	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING)) {
> >  		trace_xfs_iget_skip(ip);
> >  		XFS_STATS_INC(mp, xs_ig_frecycle);
> >  		error = -EAGAIN;
> > @@ -549,11 +601,29 @@ xfs_iget_cache_hit(
> >  		}
> >  
> >  		/* Drops i_flags_lock and RCU read lock. */
> > -		error = xfs_iget_recycle(pag, ip);
> > +		error = xfs_iget_recycle(pag, ip, XFS_IRECLAIM);
> >  		if (error) {
> >  			trace_xfs_iget_reclaim_fail(ip);
> >  			return error;
> >  		}
> > +	} else if (ip->i_flags & XFS_NEED_INACTIVE) {
> > +		/*
> > +		 * If NEED_INACTIVE is set, we've torn down the VFS inode
> > +		 * already, and must carefully restore it to usable state.
> > +		 */
> > +		trace_xfs_iget_inactive(ip);
> > +
> > +		if (flags & XFS_IGET_INCORE) {
> > +			error = -EAGAIN;
> > +			goto out_error;
> > +		}
> 
> And that's also a primary selection criteria. :)
> 
> > +
> > +		/* Drops i_flags_lock and RCU read lock. */
> > +		error = xfs_iget_recycle(pag, ip, XFS_INACTIVATING);
> > +		if (error) {
> > +			trace_xfs_iget_inactive_fail(ip);
> > +			return error;
> > +		}
> >  	} else {
> >  		/* If the VFS inode is being torn down, pause and try again. */
> >  		if (!igrab(inode)) {
> 
> Overall, I think this is kinda messy in that it smears the logic
> boundaries in the function. The cache hit code is structured as
> 
> 	check inode validity
> 	  skip inode
> 	check inode reusuability state
> 	  skip inode
> 	check inode reclaim state
> 	  recycle inode
> 	or
> 	  grab VFS inode
> 
> 
> I think it would be better to restructure this to end up looking
> like this:
> 
> 	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING))
> 		goto out_skip;
> 
> 	if ((flags & XFS_IGET_INCORE) &&
> 	    (ip->i_flags & (XFS_IRECLAIMABLE | XFS_NEED_INACTIVE)))
> 		goto out_skip;
> 
> 	error = xfs_iget_check_free_state(ip, flags);
> 	if (error)
> 		goto out_error;
> 
> 	if (ip->i_flags & (XFS_IRECLAIMABLE | XFS_NEED_INACTIVE)) {
> 		trace_xfs_iget_recycle(ip);
> 
> 		/* Drops i_flags_lock and RCU read lock. */
> 		error = xfs_iget_recycle(pag, ip);
> 		if (error) {
> 			trace_xfs_iget_recycle_fail(ip);
> 			return error;
> 		}
> 	} else {
> 		/* igrab */
> 	}
> ....
> out_skip:
> 	trace_xfs_iget_skip(ip);
> 	error = -EAGAIN;
> out_error:
> 	....
> }
> 
> Where the details of what to do to recycle the inode is handled
> entirely within xfs_iget_recycle(), rather than splitting the logic
> over two functions. We don't need separate trace points for reclaim
> vs inactivation recycling - we've got that information in the inode
> flags that the trace point should be emitting.
> 
> The above gives us a much cleaner cache hit path, and gets all of
> the slow path stuff (recycling inodes) out of the normal lookup
> path.

<nod> Done.

> 
> 
> > @@ -845,22 +915,33 @@ xfs_dqrele_igrab(
> >  
> >  	/*
> >  	 * Skip inodes that are anywhere in the reclaim machinery because we
> > -	 * drop dquots before tagging an inode for reclamation.
> > +	 * drop dquots before tagging an inode for reclamation.  If the inode
> > +	 * is being inactivated, skip it because inactivation will drop the
> > +	 * dquots for us.
> >  	 */
> > -	if (ip->i_flags & (XFS_IRECLAIM | XFS_IRECLAIMABLE))
> > +	if (ip->i_flags & (XFS_IRECLAIM | XFS_IRECLAIMABLE | XFS_INACTIVATING))
> >  		goto out_unlock;
> >  
> >  	/*
> > -	 * The inode looks alive; try to grab a VFS reference so that it won't
> > -	 * get destroyed.  If we got the reference, return true to say that
> > -	 * we grabbed the inode.
> > +	 * If the inode is queued but not undergoing inactivation, set the
> > +	 * inactivating flag so everyone will leave it alone and return true
> > +	 * to say that we are taking ownership of it.
> > +	 *
> > +	 * Otherwise, the inode looks alive; try to grab a VFS reference so
> > +	 * that it won't get destroyed.  If we got the reference, return true
> > +	 * to say that we grabbed the inode.
> >  	 *
> >  	 * If we can't get the reference, then we know the inode had its VFS
> >  	 * state torn down and hasn't yet entered the reclaim machinery.  Since
> >  	 * we also know that dquots are detached from an inode before it enters
> >  	 * reclaim, we can skip the inode.
> >  	 */
> > -	ret = igrab(VFS_I(ip)) != NULL;
> > +	if (ip->i_flags & XFS_NEED_INACTIVE) {
> > +		ip->i_flags |= XFS_INACTIVATING;
> > +		ret = true;
> > +	} else {
> > +		ret = igrab(VFS_I(ip)) != NULL;
> > +	}
> 
> 	ret = true;
> 	if (ip->i_flags & XFS_NEED_INACTIVE)
> 		ip->i_flags |= XFS_INACTIVATING;
> 	else if (!igrab(VFS_I(ip)))
> 		ret = false;

Changed.

> >  /* Don't try to run block gc on an inode that's in any of these states. */
> >  #define XFS_BLOCKGC_NOGRAB_IFLAGS	(XFS_INEW | \
> > +					 XFS_NEED_INACTIVE | \
> > +					 XFS_INACTIVATING | \
> >  					 XFS_IRECLAIMABLE | \
> >  					 XFS_IRECLAIM)
> >  /*
> > @@ -1636,6 +1734,229 @@ xfs_blockgc_free_quota(
> >  			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), iwalk_flags);
> >  }
> >  
> > +/*
> > + * Inode Inactivation and Reclaimation
> > + * ===================================
> > + *
> > + * Sometimes, inodes need to have work done on them once the last program has
> > + * closed the file.  Typically this means cleaning out any leftover speculative
> > + * preallocations after EOF or in the CoW fork.  For inodes that have been
> > + * totally unlinked, this means unmapping data/attr/cow blocks, removing the
> > + * inode from the unlinked buckets, and marking it free in the inobt and inode
> > + * table.
> > + *
> > + * This process can generate many metadata updates, which shows up as close()
> > + * and unlink() calls that take a long time.  We defer all that work to a
> > + * workqueue which means that we can batch a lot of work and do it in inode
> > + * order for better performance.  Furthermore, we can control the workqueue,
> > + * which means that we can avoid doing inactivation work at a bad time, such as
> > + * when the fs is frozen.
> > + *
> > + * Deferred inactivation introduces new inode flag states (NEED_INACTIVE and
> > + * INACTIVATING) and adds a new INODEGC radix tree tag for fast access.  We
> > + * maintain separate perag counters for both types, and move counts as inodes
> > + * wander the state machine, which now works as follows:
> > + *
> > + * If the inode needs inactivation, we:
> > + *   - Set the NEED_INACTIVE inode flag
> > + *   - Increment the per-AG inactive count
> > + *   - Set the ICI_INODEGC tag in the per-AG inode tree
> > + *   - Set the ICI_INODEGC tag in the per-fs AG tree
> > + *   - Schedule background inode inactivation
> > + *
> > + * If the inode does not need inactivation, we:
> > + *   - Set the IRECLAIMABLE inode flag
> > + *   - Increment the per-AG reclaim count
> > + *   - Set the ICI_RECLAIM tag in the per-AG inode tree
> > + *   - Set the ICI_RECLAIM tag in the per-fs AG tree
> > + *   - Schedule background inode reclamation
> > + *
> > + * When it is time for background inode inactivation, we:
> > + *   - Set the INACTIVATING inode flag
> > + *   - Make all the on-disk updates
> > + *   - Clear both INACTIVATING and NEED_INACTIVE inode flags
> > + *   - Decrement the per-AG inactive count
> > + *   - Clear the ICI_INODEGC tag in the per-AG inode tree
> > + *   - Clear the ICI_INODEGC tag in the per-fs AG tree if we just inactivated
> > + *     the last inode in the AG
> > + *   - Kick the inode into reclamation per the previous paragraph
> > + *
> > + * When it is time for background inode reclamation, we:
> > + *   - Set the IRECLAIM inode flag
> > + *   - Detach all the resources and remove the inode from the per-AG inode tree
> > + *   - Clear both IRECLAIM and RECLAIMABLE inode flags
> 
> That's wrong - we never clear the IRECLAIM state on a reclaimed
> inode - it is carried into the slab cache when it is freed so that
> racing RCU lookups will always see the IRECLAIM state and skip the
> inode and retry.

Good catch.  I didn't notice that and it's been like 2 years.

> > + *   - Decrement the per-AG reclaim count
> > + *   - Clear the ICI_RECLAIM tag from the per-AG inode tree
> > + *   - Clear the ICI_RECLAIM tag from the per-fs AG tree if we just reclaimed
> > + *     the last inode in the AG
> > + *
> > + * When these state transitions occur, the caller must have taken the per-AG
> > + * incore inode tree lock and then the inode i_flags lock, in that order.
> > + */
> 
> While the comment is good, describing what the code does is just
> going to get out of date as we modify this in future. I'd drop all
> the description of inode/perAG tag and tracking management and just
> replace them with:
> 
>  * If the inode needs inactivation, we:
>  *   - Set the NEED_INACTIVE inode flag
>  *   - Schedule background inode inactivation
>  *
>  * If the inode does not need inactivation, we:
>  *   - Set the IRECLAIMABLE inode flag
>  *   - Schedule background inode reclamation
>  *
>  * If the inode is being inactivated, we:
>  *   - Set the INACTIVATING inode flag
>  *   - Make all the on-disk updates
>  *   - Clear the inactive state and set the IRECLAIMABLE inode flag
>  *   - Schedule background inode reclamation
>  *
>  * If the inode is being reclaimed, we:
>  *   - Set the IRECLAIM inode flag
>  *   - Reclaim the inode and RCU free it.

Changed.

> > +/*
> > + * Decide if the given @ip is eligible for inactivation, and grab it if so.
> > + * Returns true if it's ready to go or false if we should just ignore it.
> > + */
> > +static bool
> > +xfs_inodegc_igrab(
> > +	struct xfs_inode	*ip)
> > +{
> > +	ASSERT(rcu_read_lock_held());
> > +
> > +	/* Check for stale RCU freed inode */
> > +	spin_lock(&ip->i_flags_lock);
> > +	if (!ip->i_ino)
> > +		goto out_unlock_noent;
> > +
> > +	/*
> > +	 * Skip inodes that don't need inactivation or are being inactivated
> > +	 * (or reactivated) by another thread.  Inodes should not be tagged
> > +	 * for inactivation while also in INEW or any reclaim state.
> > +	 */
> > +	if (!(ip->i_flags & XFS_NEED_INACTIVE) ||
> > +	    (ip->i_flags & XFS_INACTIVATING))
> > +		goto out_unlock_noent;
> > +
> > +	/*
> > +	 * Mark this inode as being inactivated even if the fs is shut down
> > +	 * because we need xfs_inodegc_inactivate to push this inode into the
> > +	 * reclaim state.
> > +	 */
> 
> These two comments really should go at the head of the function.
> i.e. if you define what "eligible for inactivation" where it is
> stated, then you don't need these comments in the code.

Ok.

> > +	ip->i_flags |= XFS_INACTIVATING;
> > +	spin_unlock(&ip->i_flags_lock);
> > +	return true;
> > +
> > +out_unlock_noent:
> > +	spin_unlock(&ip->i_flags_lock);
> > +	return false;
> > +}
> > +
> > +/*
> > + * Free all speculative preallocations and possibly even the inode itself.
> > + * This is the last chance to make changes to an otherwise unreferenced file
> > + * before incore reclamation happens.
> > + */
> > +static int
> > +xfs_inodegc_inactivate(
> > +	struct xfs_inode	*ip,
> > +	struct xfs_perag	*pag,
> > +	struct xfs_icwalk	*icw)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> > +
> > +	/*
> > +	 * Inactivation isn't supposed to run when the fs is frozen because
> > +	 * we don't want kernel threads to block on transaction allocation.
> > +	 */
> > +	ASSERT(mp->m_super->s_writers.frozen < SB_FREEZE_FS);
> > +
> > +	/*
> > +	 * Foreground threads that have hit ENOSPC or EDQUOT are allowed to
> > +	 * pass in a icw structure to look for inodes to inactivate
> > +	 * immediately to free some resources.  If this inode isn't a match,
> > +	 * put it back on the shelf and move on.
> > +	 */
> > +	spin_lock(&ip->i_flags_lock);
> > +	if (!xfs_icwalk_match(ip, icw)) {
> > +		ip->i_flags &= ~XFS_INACTIVATING;
> > +		spin_unlock(&ip->i_flags_lock);
> > +		return 0;
> > +	}
> > +	spin_unlock(&ip->i_flags_lock);
> > +
> > +	trace_xfs_inode_inactivating(ip);
> > +
> > +	xfs_inactive(ip);
> > +	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
> > +
> > +	/*
> > +	 * Move the inode from the inactivation phase to the reclamation phase
> > +	 * by clearing both inactivation inode state flags and marking the
> > +	 * inode reclaimable.  Schedule background reclaim to run later.
> > +	 */
> 
> Don't describe the code in the comment.
> 
> 	/* Now schedule the inactivated inode for reclaim. */

Fixed, thanks.

> > +	spin_lock(&pag->pag_ici_lock);
> > +	spin_lock(&ip->i_flags_lock);
> > +
> > +	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
> > +	ip->i_flags |= XFS_IRECLAIMABLE;
> > +
> > +	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_INODEGC_TAG);
> > +	xfs_perag_set_inode_tag(pag, agino, XFS_ICI_RECLAIM_TAG);
> > +
> > +	spin_unlock(&ip->i_flags_lock);
> > +	spin_unlock(&pag->pag_ici_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Walk the fs and inactivate the inodes in them. */
> > +int
> > +xfs_inodegc_free_space(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_icwalk	*icw)
> > +{
> > +	trace_xfs_inodegc_free_space(mp, icw, _RET_IP_);
> > +
> > +	return xfs_icwalk(mp, XFS_ICWALK_INODEGC, icw);
> > +}
> > +
> > +/* Background inode inactivation worker. */
> > +void
> > +xfs_inodegc_worker(
> > +	struct work_struct	*work)
> > +{
> > +	struct xfs_mount	*mp = container_of(to_delayed_work(work),
> > +					struct xfs_mount, m_inodegc_work);
> > +	int			error;
> > +
> > +	/*
> > +	 * Queueing of this inodegc worker can race with xfs_inodegc_stop,
> > +	 * which means that we can be running after the opflag clears.  Double
> > +	 * check the flag state so that we don't trip asserts.
> > +	 */
> > +	if (!xfs_inodegc_running(mp))
> > +		return;
> > +
> > +	error = xfs_inodegc_free_space(mp, NULL);
> > +	if (error && error != -EAGAIN)
> > +		xfs_err(mp, "inode inactivation failed, error %d", error);
> > +
> > +	xfs_inodegc_queue(mp);
> > +}
> > +
> > +/* Force all currently queued inode inactivation work to run immediately. */
> > +void
> > +xfs_inodegc_flush(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (!xfs_inodegc_running(mp) ||
> > +	    !radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
> > +		return;
> > +
> > +	mod_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
> > +	flush_delayed_work(&mp->m_inodegc_work);
> 
> Doesn't flush_delayed_work() immediately schedule any delayed work?
> 
> Yup, it does:
> 
> /**                                                                              
>  * flush_delayed_work - wait for a dwork to finish executing the last queueing   
>  * @dwork: the delayed work to flush                                             
>  *                                                                               
>  * Delayed timer is cancelled and the pending work is queued for                 
>  * immediate execution.  Like flush_work(), this function only                   
>  * considers the last queueing instance of @dwork.                               
> ....
> 
> So no need for the mod_delayed_work() call here.
> 
> Also, if the gc is not running or there's nothing in the radix tree,
> there is no queued work and so just calling flush_delayed_work()
> would be a no-op, right?

Yeah, that's what the documentation says.

At some point in the last two years I encountered a bug with this
patchset where unmounts would stall forever because the
flush_delayed_work didn't actually requeue the deferred work for
immediate scheduling.  I guess I don't need it anymore.

> > +}
> > +
> > +/* Stop all queued inactivation work. */
> > +void
> > +xfs_inodegc_stop(
> > +	struct xfs_mount	*mp)
> > +{
> > +	clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
> > +	cancel_delayed_work_sync(&mp->m_inodegc_work);
> > +}
> 
> what's to stop racing invocations of stop/start? Perhaps:
> 
> 	if (test_and_clear_bit())
> 		cancel_delayed_work_sync(&mp->m_inodegc_work);

That horrible hack below.

> > +
> > +/* Schedule deferred inode inactivation work. */
> > +void
> > +xfs_inodegc_start(
> > +	struct xfs_mount	*mp)
> > +{
> > +	set_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
> > +	xfs_inodegc_queue(mp);
> > +}
> 
> 	if (test_and_set_bit())
> 		xfs_inodegc_queue(mp);
> 
> So that the running state will remain in sync with the actual queue
> operation? Though I'm still not sure why we need the running bit...

(see ugly sync_fs SB_FREEZE_PAGEFAULTS hack)

> > @@ -80,4 +80,37 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
> >  void xfs_blockgc_stop(struct xfs_mount *mp);
> >  void xfs_blockgc_start(struct xfs_mount *mp);
> >  
> > +void xfs_inodegc_worker(struct work_struct *work);
> > +void xfs_inodegc_flush(struct xfs_mount *mp);
> > +void xfs_inodegc_stop(struct xfs_mount *mp);
> > +void xfs_inodegc_start(struct xfs_mount *mp);
> > +int xfs_inodegc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icw);
> > +
> > +/*
> > + * Process all pending inode inactivations immediately (sort of) so that a
> > + * resource usage report will be mostly accurate with regards to files that
> > + * have been unlinked recently.
> > + *
> > + * It isn't practical to maintain a count of the resources used by unlinked
> > + * inodes to adjust the values reported by this function.  Resources that are
> > + * shared (e.g. reflink) when an inode is queued for inactivation cannot be
> > + * counted towards the adjustment, and cross referencing data extents with the
> > + * refcount btree is the only way to decide if a resource is shared.  Worse,
> > + * unsharing of any data blocks in the system requires either a second
> > + * consultation with the refcount btree, or training users to deal with the
> > + * free space counts possibly fluctuating upwards as inactivations occur.
> > + *
> > + * Hence we guard the inactivation flush with a ratelimiter so that the counts
> > + * are not way out of whack while ignoring workloads that hammer us with statfs
> > + * calls.  Once per clock tick seems frequent enough to avoid complaints about
> > + * inaccurate counts.
> > + */
> > +static inline void
> > +xfs_inodegc_summary_flush(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (__ratelimit(&mp->m_inodegc_ratelimit))
> > +		xfs_inodegc_flush(mp);
> > +}
> 
> ONce per clock tick is still quite fast - once a millisecond on a
> 1000Hz kernel. I'd prefer that we use a known timer base for this
> sort of thing, not something that changes with kernel config. Every
> 100ms, perhaps?

I tried a number of ratelimit values here: 1ms, 4ms, 10ms, 100ms, 500ms,
2s, and 15s.  fstests and most everything else seemed to act the same up
to 10ms.  At 100ms, the tests that delete something and immediately run
df will start to fail, and above that all hell breaks loose because many
tests (from which I extrapolate most programmers) expect that statfs
won't run until unlink has deleted everything.

> > @@ -937,9 +953,9 @@ xfs_mountfs(
> >  	/* Clean out dquots that might be in memory after quotacheck. */
> >  	xfs_qm_unmount(mp);
> >  	/*
> > -	 * Flush all inode reclamation work and flush the log.
> > -	 * We have to do this /after/ rtunmount and qm_unmount because those
> > -	 * two will have scheduled delayed reclaim for the rt/quota inodes.
> > +	 * Flush all inode reclamation work and flush inodes to the log.  Do
> > +	 * this after rtunmount and qm_unmount because those two will have
> > +	 * released the rt and quota inodes.
> >  	 *
> >  	 * This is slightly different from the unmountfs call sequence
> >  	 * because we could be tearing down a partially set up mount.  In
> > @@ -947,6 +963,7 @@ xfs_mountfs(
> >  	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
> >  	 * quota inodes.
> >  	 */
> > +	xfs_inodegc_flush(mp);
> >  	xfs_unmount_flush_inodes(mp);
> 
> Why isn't xfs_inodegc_flush() part of xfs_unmount_flush_inodes()?
> Because, really, xfs_unmount_flush_inodes() depends on all the
> inodes first being inactivated so that all transactions on inodes
> are complete....

The teardown sequence is not the same between a regular unmount and an
aborted mount...

> >   out_log_dealloc:
> >  	xfs_log_mount_cancel(mp);
> > @@ -983,6 +1000,12 @@ xfs_unmountfs(
> >  	uint64_t		resblks;
> >  	int			error;
> >  
> > +	/*
> > +	 * Flush all the queued inode inactivation work to disk before tearing
> > +	 * down rt metadata and quotas.
> > +	 */
> > +	xfs_inodegc_flush(mp);
> > +
> >  	xfs_blockgc_stop(mp);
> >  	xfs_fs_unreserve_ag_blocks(mp);
> >  	xfs_qm_unmount_quotas(mp);
> 
> FWIW, there's inconsistency in the order of operations between
> failure handling in xfs_mountfs() w.r.t. inode flushing and quotas
> vs what xfs_unmountfs() is now doing....

...because during regular unmountfs, we want to inactivate inodes while
we still have a per-ag reservation protecting finobt expansions.  During
an aborted mount, we don't necessarily have the reservation set up but
we have to clean everything out, so the inodegc flush comes much later.

It's convoluted, but do you want me to clean /that/ up too?  That's a
pretty heavy lift; I already tried to fix those two paths, ran out of
brain cells, and gave up.

> >  	uint8_t			m_rt_checked;
> >  	uint8_t			m_rt_sick;
> >  
> > +	unsigned long		m_opflags;
> > +
> >  	/*
> >  	 * End of read-mostly variables. Frequently written variables and locks
> >  	 * should be placed below this comment from now on. The first variable
> > @@ -184,6 +186,7 @@ typedef struct xfs_mount {
> >  	uint64_t		m_resblks_avail;/* available reserved blocks */
> >  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> >  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
> > +	struct delayed_work	m_inodegc_work; /* background inode inactive */
> >  	struct xfs_kobj		m_kobj;
> >  	struct xfs_kobj		m_error_kobj;
> >  	struct xfs_kobj		m_error_meta_kobj;
> > @@ -220,6 +223,7 @@ typedef struct xfs_mount {
> >  	unsigned int		*m_errortag;
> >  	struct xfs_kobj		m_errortag_kobj;
> >  #endif
> > +	struct ratelimit_state	m_inodegc_ratelimit;
> >  } xfs_mount_t;
> >  
> >  #define M_IGEO(mp)		(&(mp)->m_ino_geo)
> > @@ -258,6 +262,9 @@ typedef struct xfs_mount {
> >  #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
> >  #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
> >  
> > +#define XFS_OPFLAG_INODEGC_RUNNING_BIT	(0)	/* are we allowed to start the
> > +						   inode inactivation worker? */
> > +
> Ok, "opflags" are undocumented as to how they work, what their
> consistency model is, etc. I understand you want an atomic flag to
> indicate that something is running, and mp->m_flags is not that
> (despite being used that way historically). 
> 
> I dislike the "_BIT" annotations for a variable that is only to be
> used as an index bit field. Or maybe it's a flag field and you
> haven't defined any bitwise flags for it because you're not using it
> that way yet.
> 
> So, is m_opflags an indexed bit field or a normal flag field like
> m_flags?

It's an indexed bit field, which is why I named it _BIT.  I'll try to
add more documentation around what this thing is and how the flags work:

struct xfs_mount {
	...
	/*
	 * This atomic bitset controls flags that alter the behavior of
	 * the filesystem.  Use only the atomic bit helper functions
	 * here; see XFS_OPFLAG_* for information about the actual
	 * flags.
	 */
	unsigned long		m_opflags;
	...
};

/*
 * Operation flags -- each entry here is a bit index into m_opflags and
 * is not itself a flag value.
 */

/* Are we allowed to run the inode inactivation worker? */
#define XFS_OPFLAG_INODEGC_RUNNING_BIT	(0)

> 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 3a7fd4f02aa7..120a4426fd64 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -629,6 +629,43 @@ xfs_check_delalloc(
> >  #define xfs_check_delalloc(ip, whichfork)	do { } while (0)
> >  #endif
> >  
> > +#ifdef CONFIG_XFS_QUOTA
> > +/*
> > + * If a quota type is turned off but we still have a dquot attached to the
> > + * inode, detach it before tagging this inode for inactivation (or reclaim) to
> > + * avoid delaying quotaoff for longer than is necessary.  Because the inode has
> > + * no VFS state and has not yet been tagged for reclaim or inactivation, it is
> > + * safe to drop the dquots locklessly because iget, quotaoff, blockgc, and
> > + * reclaim will not touch the inode.
> > + */
> > +static inline void
> > +xfs_fs_dqdestroy_inode(
> > +	struct xfs_inode	*ip)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +
> > +	if (!XFS_IS_UQUOTA_ON(mp)) {
> > +		xfs_qm_dqrele(ip->i_udquot);
> > +		ip->i_udquot = NULL;
> > +	}
> > +	if (!XFS_IS_GQUOTA_ON(mp)) {
> > +		xfs_qm_dqrele(ip->i_gdquot);
> > +		ip->i_gdquot = NULL;
> > +	}
> > +	if (!XFS_IS_PQUOTA_ON(mp)) {
> > +		xfs_qm_dqrele(ip->i_pdquot);
> > +		ip->i_pdquot = NULL;
> > +	}
> > +}
> > +#else
> > +# define xfs_fs_dqdestroy_inode(ip)		((void)0)
> > +#endif
> 
> This should sit alongside xfs_qm_dqdetach() in the quota code, not
> require additional #ifdef CONFIG_XFS_QUOTA blocks in the code here.
> 
> This could also be split out into a separate patch to reduce the
> size of this one...

Done.

> > +
> > +/* iflags that we shouldn't see before scheduling reclaim or inactivation. */
> > +#define XFS_IDESTROY_BAD_IFLAGS	(XFS_IRECLAIMABLE | \
> > +				 XFS_IRECLAIM | \
> > +				 XFS_NEED_INACTIVE | \
> > +				 XFS_INACTIVATING)
> >  /*
> >   * Now that the generic code is guaranteed not to be accessing
> >   * the linux inode, we can inactivate and reclaim the inode.
> > @@ -638,28 +675,44 @@ xfs_fs_destroy_inode(
> >  	struct inode		*inode)
> >  {
> >  	struct xfs_inode	*ip = XFS_I(inode);
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	bool			need_inactive;
> >  
> >  	trace_xfs_destroy_inode(ip);
> >  
> >  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> > -	XFS_STATS_INC(ip->i_mount, vn_rele);
> > -	XFS_STATS_INC(ip->i_mount, vn_remove);
> > +	XFS_STATS_INC(mp, vn_rele);
> > +	XFS_STATS_INC(mp, vn_remove);
> >  
> > -	xfs_inactive(ip);
> > +	need_inactive = xfs_inode_needs_inactivation(ip);
> > +	if (!need_inactive) {
> > +		/*
> > +		 * If the inode doesn't need inactivation, that means we're
> > +		 * going directly into reclaim and can drop the dquots.  It
> > +		 * also means that there shouldn't be any delalloc reservations
> > +		 * or speculative CoW preallocations remaining.
> > +		 */
> > +		xfs_qm_dqdetach(ip);
> >  
> > -	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
> > -		xfs_check_delalloc(ip, XFS_DATA_FORK);
> > -		xfs_check_delalloc(ip, XFS_COW_FORK);
> > -		ASSERT(0);
> > +		if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
> > +			xfs_check_delalloc(ip, XFS_DATA_FORK);
> > +			xfs_check_delalloc(ip, XFS_COW_FORK);
> > +			ASSERT(0);
> > +		}
> 
> These checks should happen when the inode is marked IRECLAIMABLE,
> not here. This comes back to my comments about moving all the
> "need_inactive" logic into xfs_inode_mark_reclaimable() - this
> needs to be checked after inactivation, not just here where the
> inode doesn't require inactivation....

Ok.

> IOWs, xfs_fs_destroy_inode() should largely become a shell function
> with accounting and state checks, and not much else...

Done.  I've moved most of the code from xfs_fs_destroy_inode into
xfs_inode_mark_reclaimable.  The delalloc stuff is checked here if we're
moving the inode straight into reclaim, and also at the point when the
inode moves from INACTIVATING -> IRECLAIMABLE.

> >  static void
> > @@ -780,6 +833,21 @@ xfs_fs_sync_fs(
> >  		flush_delayed_work(&mp->m_log->l_work);
> >  	}
> >  
> > +	/*
> > +	 * If the fs is at FREEZE_PAGEFAULTS, that means the VFS holds the
> > +	 * umount mutex and is syncing the filesystem just before setting the
> > +	 * state to FREEZE_FS.  We are not allowed to run transactions on a
> > +	 * filesystem that is in FREEZE_FS state, so deactivate the background
> > +	 * workers before we get there, and leave them off for the duration of
> > +	 * the freeze.
> > +	 *
> > +	 * We can't do this in xfs_fs_freeze_super because freeze_super takes
> > +	 * s_umount, which means we can't lock out a concurrent thaw request
> > +	 * without adding another layer of locks to the freeze process.
> > +	 */
> > +	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT)
> > +		xfs_inodegc_stop(mp);
> 
> Damn, that's an ugly hack.

Yep.

> SO the problem is that xfs_fs_freeze() is called after SB_FREEZE_FS
> is set and so transactions won't run, hence it's too late to stop
> the inode gc from running? i.e. it might already be blocked on
> sb_start_intwrite() in xfs_trans_alloc()?
> 
> Which tends to imply that inactivation transactions should use
> XFS_TRANS_NO_WRITECOUNT and then xfs_inodegc_stop() blocks waiting
> for all the inactivation transactions to complete in xfs_fs_freeze()
> before we do anything else.

I tried that, and it got ugly pretty quickly, because xfs_inactive does
not itself create transactions, which means that xfs_qm_dqattach and
xfs_reflink_cancel_cow_range and xfs_free_eofblocks have to be taught
when they need to pass NO_WRITECOUNT.  The first one probably never
needs to run a transaction, but the other two do, and they get called
from other non-reclaim of the filesystem too.

> I'd prefer we have a formal mechanism for handling this -
> inactivation is something unknown to and hidden underneath the VFS,
> so it's not considered in the VFS freeze mechanisms. Hence I think
> it's fine to use our own mechanism in xfs_fs_freeze() to synchronise
> as we need to....

I also uncovered a bug in log recovery when someone sets up an xfs to
host some vm images, starts some work, and the host xfs goes down right
after someone unlinks an image file that shares extents.

Basically, log recovery replays transactions and all the unfinished
extents.  If log recovery also recovers the unlink operation, it'll drop
the nlink on that image file to zero and set IRECOVERY.  Once recovery
is complete, we reclaim the entire inode cache.  At that point we'll
inactivate the IRECOVERY inode, which (since it's link count is zero)
means we have to bunmapi the whole thing.  This requires us to drop
refcounts on the unlinked file, which can in turn cause a refcount btree
shape change.  The xfs_inactive() transaction doesn't reserve any blocks
and we haven't set up per-AG reservations yet, so we trip over the
blk_res_used > blk_res assertion during commit.

It's not related to this patch, but might need fixing soon.

> 
> > +
> >  	return 0;
> >  }
> >  
> > @@ -798,6 +866,8 @@ xfs_fs_statfs(
> >  	xfs_extlen_t		lsize;
> >  	int64_t			ffree;
> >  
> > +	xfs_inodegc_summary_flush(mp);
> 
> I suspect that's really going to hurt stat performance. I guess
> benchmarks are in order...

Ok, so here's the question I have: Does POSIX (or any other standard we
care to fit) actually define any behavior between the following
sequence:

unlink("/foo");	/* no sync calls of any kind */
statfs("/");

As I've mentioned in the past, the only reason we need these inodegc
flushes for summary reporting is because users expect that if they
delete an unshared 10GB file, they can immediately df and see that the
inode count went down by one and free space went up by 10GB.

I /guess/ we could modify every single fstest to sync before checking
summary counts instead of doing this, but I bet there will be some users
who will be surprised that xfs now has *trfs df logic.

> > @@ -908,10 +978,27 @@ xfs_fs_unfreeze(
> >  
> >  	xfs_restore_resvblks(mp);
> >  	xfs_log_work_queue(mp);
> > +	xfs_inodegc_start(mp);
> >  	xfs_blockgc_start(mp);
> >  	return 0;
> >  }
> >  
> > +STATIC int
> > +xfs_fs_freeze_super(
> > +	struct super_block	*sb)
> > +{
> > +	struct xfs_mount	*mp = XFS_M(sb);
> > +
> > +	/*
> > +	 * Before we take s_umount to get to FREEZE_WRITE, flush all the
> > +	 * accumulated background work so that there's less recovery work
> > +	 * to do if we crash during the freeze.
> > +	 */
> > +	xfs_inodegc_flush(mp);
> > +
> > +	return freeze_super(sb);
> > +}
> > +
> >  /*
> >   * This function fills in xfs_mount_t fields based on mount args.
> >   * Note: the superblock _has_ now been read in.
> > @@ -1090,6 +1177,7 @@ static const struct super_operations xfs_super_operations = {
> >  	.show_options		= xfs_fs_show_options,
> >  	.nr_cached_objects	= xfs_fs_nr_cached_objects,
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> > +	.freeze_super		= xfs_fs_freeze_super,
> >  };
> 
> Ugh, so we have high level freeze control, but not low level.
> Really, if we have to stop inode gc while freezing, then I'd prefer
> we either do it here or in xfs_fs_freeze() than using the hack
> you've got in place now...
> 
> >  
> >  static int
> > @@ -1737,6 +1825,13 @@ xfs_remount_ro(
> >  		return error;
> >  	}
> >  
> > +	/*
> > +	 * Perform all on-disk metadata updates required to inactivate inodes.
> > +	 * Since this can involve finobt updates, do it now before we lose the
> > +	 * per-AG space reservations to guarantee that we won't fail there.
> > +	 */
> > +	xfs_inodegc_flush(mp);
> > +
> 
> Ummm - from this point onwards there are no modifications for
> inactivation - why not just turn inodegc off completely?

Oops.  Yes, you're right, we already do that for blockgc, so we might as
well do that for inodegc too.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
