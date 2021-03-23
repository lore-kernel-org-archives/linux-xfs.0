Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB268C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 01:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 919DB61994
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 01:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhCWBo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 21:44:28 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:55891 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231289AbhCWBoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 21:44:21 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id DACA363647;
        Tue, 23 Mar 2021 12:44:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOW5h-005epf-R2; Tue, 23 Mar 2021 12:44:17 +1100
Date:   Tue, 23 Mar 2021 12:44:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210323014417.GC63242@dread.disaster.area>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543197372.1947934.1230576164438094965.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=imzlHlUe82VZfqyO5HQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 07:06:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Instead of calling xfs_inactive directly from xfs_fs_destroy_inode,
> defer the inactivation phase to a separate workqueue.  With this we
> avoid blocking memory reclaim on filesystem metadata updates that are
> necessary to free an in-core inode, such as post-eof block freeing, COW
> staging extent freeing, and truncating and freeing unlinked inodes.  Now
> that work is deferred to a workqueue where we can do the freeing in
> batches.
> 
> We introduce two new inode flags -- NEEDS_INACTIVE and INACTIVATING.
> The first flag helps our worker find inodes needing inactivation, and
> the second flag marks inodes that are in the process of being
> inactivated.  A concurrent xfs_iget on the inode can still resurrect the
> inode by clearing NEEDS_INACTIVE (or bailing if INACTIVATING is set).
> 
> Unfortunately, deferring the inactivation has one huge downside --
> eventual consistency.  Since all the freeing is deferred to a worker
> thread, one can rm a file but the space doesn't come back immediately.
> This can cause some odd side effects with quota accounting and statfs,
> so we also force inactivation scans in order to maintain the existing
> behaviors, at least outwardly.
> 
> For this patch we'll set the delay to zero to mimic the old timing as
> much as possible; in the next patch we'll play with different delay
> settings.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
....
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index a2a407039227..3a3baf56198b 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -19,6 +19,8 @@
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
> +#include "xfs_inode.h"
> +#include "xfs_icache.h"
>  
>  /*
>   * growfs operations
> @@ -290,6 +292,13 @@ xfs_fs_counts(
>  	xfs_mount_t		*mp,
>  	xfs_fsop_counts_t	*cnt)
>  {
> +	/*
> +	 * Process all the queued file and speculative preallocation cleanup so
> +	 * that the counter values we report here do not incorporate any
> +	 * resources that were previously deleted.
> +	 */
> +	xfs_inodegc_force(mp);

xfs_fs_counts() is supposed to be a quick, non-blocking summary of
the state - it can never supply userspace with accurate values
because they are wrong even before the ioctl returns to userspace.
Hence we do not attempt to make them correct, just use a fast, point
in time sample of the current counter values.

So this seems like an unnecessarily heavyweight operation
to add to this function....

Also, I don't like the word "force" in functions like this: force it
to do what, exactly? If you want a queue flush, then
xfs_inodegc_flush() matches with how flush_workqueue() works...

>  	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
>  	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
>  	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e6a62f765422..1b7652af5ee5 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -195,6 +195,18 @@ xfs_perag_clear_reclaim_tag(
>  	trace_xfs_perag_clear_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
>  }
>  
> +static void
> +__xfs_inode_set_reclaim_tag(
> +	struct xfs_perag	*pag,
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +			   XFS_ICI_RECLAIM_TAG);
> +	xfs_perag_set_reclaim_tag(pag);
> +	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
> +}
>  
>  /*
>   * We set the inode flag atomically with the radix tree tag.
> @@ -212,10 +224,7 @@ xfs_inode_set_reclaim_tag(
>  	spin_lock(&pag->pag_ici_lock);
>  	spin_lock(&ip->i_flags_lock);
>  
> -	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
> -			   XFS_ICI_RECLAIM_TAG);
> -	xfs_perag_set_reclaim_tag(pag);
> -	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
> +	__xfs_inode_set_reclaim_tag(pag, ip);
>  
>  	spin_unlock(&ip->i_flags_lock);
>  	spin_unlock(&pag->pag_ici_lock);

First thought: rename xfs_inode_set_reclaim_tag() to
xfs_inode_set_reclaim_tag_locked(), leave the guts as
xfs_inode_set_reclaim_tag().

> @@ -233,6 +242,94 @@ xfs_inode_clear_reclaim_tag(
>  	xfs_perag_clear_reclaim_tag(pag);
>  }
>  
> +/* Queue a new inode gc pass if there are inodes needing inactivation. */
> +static void
> +xfs_inodegc_queue(
> +	struct xfs_mount        *mp)
> +{
> +	rcu_read_lock();
> +	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INACTIVE_TAG))
> +		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
> +				2 * HZ);
> +	rcu_read_unlock();
> +}

Why half a second and not something referenced against the inode
reclaim/sync period?

> +/* Remember that an AG has one more inode to inactivate. */
> +static void
> +xfs_perag_set_inactive_tag(
> +	struct xfs_perag	*pag)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +
> +	lockdep_assert_held(&pag->pag_ici_lock);
> +	if (pag->pag_ici_inactive++)
> +		return;
> +
> +	/* propagate the inactive tag up into the perag radix tree */
> +	spin_lock(&mp->m_perag_lock);
> +	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno,
> +			   XFS_ICI_INACTIVE_TAG);
> +	spin_unlock(&mp->m_perag_lock);
> +
> +	/* schedule periodic background inode inactivation */
> +	xfs_inodegc_queue(mp);
> +
> +	trace_xfs_perag_set_inactive(mp, pag->pag_agno, -1, _RET_IP_);
> +}
> +
> +/* Set this inode's inactive tag and set the per-AG tag. */
> +void
> +xfs_inode_set_inactive_tag(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_perag	*pag;
> +
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	spin_lock(&pag->pag_ici_lock);
> +	spin_lock(&ip->i_flags_lock);
> +
> +	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +				   XFS_ICI_INACTIVE_TAG);
> +	xfs_perag_set_inactive_tag(pag);
> +	__xfs_iflags_set(ip, XFS_NEED_INACTIVE);
> +
> +	spin_unlock(&ip->i_flags_lock);
> +	spin_unlock(&pag->pag_ici_lock);
> +	xfs_perag_put(pag);
> +}
> +
> +/* Remember that an AG has one less inode to inactivate. */
> +static void
> +xfs_perag_clear_inactive_tag(
> +	struct xfs_perag	*pag)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +
> +	lockdep_assert_held(&pag->pag_ici_lock);
> +	if (--pag->pag_ici_inactive)
> +		return;
> +
> +	/* clear the inactive tag from the perag radix tree */
> +	spin_lock(&mp->m_perag_lock);
> +	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno,
> +			     XFS_ICI_INACTIVE_TAG);
> +	spin_unlock(&mp->m_perag_lock);
> +	trace_xfs_perag_clear_inactive(mp, pag->pag_agno, -1, _RET_IP_);
> +}
> +
> +/* Clear this inode's inactive tag and try to clear the AG's. */
> +STATIC void

static

> +xfs_inode_clear_inactive_tag(
> +	struct xfs_perag	*pag,
> +	xfs_ino_t		ino)
> +{
> +	radix_tree_tag_clear(&pag->pag_ici_root,
> +			     XFS_INO_TO_AGINO(pag->pag_mount, ino),
> +			     XFS_ICI_INACTIVE_TAG);
> +	xfs_perag_clear_inactive_tag(pag);
> +}

These are just straight copies of the reclaim tag code. Do you have
a plan for factoring these into a single implementation to clean
this up? Something like this:

static void
xfs_inode_clear_tag(
	struct xfs_perag	*pag,
	xfs_ino_t		ino,
	int			tag)
{
	struct xfs_mount	*mp = pag->pag_mount;

	lockdep_assert_held(&pag->pag_ici_lock);
	radix_tree_tag_clear(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ino),
				tag);
	switch(tag) {
	case XFS_ICI_INACTIVE_TAG:
		if (--pag->pag_ici_inactive)
			return;
		break;
	case XFS_ICI_RECLAIM_TAG:
		if (--pag->pag_ici_reclaim)
			return;
		break;
	default:
		ASSERT(0);
		return;
	}

	spin_lock(&mp->m_perag_lock);
	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno, tag);
	spin_unlock(&mp->m_perag_lock);
}

As a followup patch? The set tag case looks similarly easy to make
generic...

> +
>  static void
>  xfs_inew_wait(
>  	struct xfs_inode	*ip)
> @@ -298,6 +395,13 @@ xfs_iget_check_free_state(
>  	struct xfs_inode	*ip,
>  	int			flags)
>  {
> +	/*
> +	 * Unlinked inodes awaiting inactivation must not be reused until we
> +	 * have a chance to clear the on-disk metadata.
> +	 */
> +	if (VFS_I(ip)->i_nlink == 0 && (ip->i_flags & XFS_NEED_INACTIVE))
> +		return -ENOENT;
> +
>  	if (flags & XFS_IGET_CREATE) {
>  		/* should be a free inode */
>  		if (VFS_I(ip)->i_mode != 0) {

How do we get here with an XFS_NEED_INACTIVE inode?
xfs_iget_check_free_state() is only called from the cache miss path,
but we should never get here with a cached inode that is awaiting
inactivation...

> @@ -323,6 +427,67 @@ xfs_iget_check_free_state(
>  	return 0;
>  }
>  
> +/*
> + * We've torn down the VFS part of this NEED_INACTIVE inode, so we need to get
> + * it back into working state.
> + */
> +static int
> +xfs_iget_inactive(
> +	struct xfs_perag	*pag,
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct inode		*inode = VFS_I(ip);
> +	int			error;
> +
> +	error = xfs_reinit_inode(mp, inode);
> +	if (error) {
> +		bool wake;
> +		/*
> +		 * Re-initializing the inode failed, and we are in deep
> +		 * trouble.  Try to re-add it to the inactive list.
> +		 */
> +		rcu_read_lock();
> +		spin_lock(&ip->i_flags_lock);
> +		wake = !!__xfs_iflags_test(ip, XFS_INEW);
> +		ip->i_flags &= ~(XFS_INEW | XFS_INACTIVATING);
> +		if (wake)
> +			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
> +		ASSERT(ip->i_flags & XFS_NEED_INACTIVE);
> +		trace_xfs_iget_inactive_fail(ip);
> +		spin_unlock(&ip->i_flags_lock);
> +		rcu_read_unlock();
> +		return error;
> +	}
> +
> +	spin_lock(&pag->pag_ici_lock);
> +	spin_lock(&ip->i_flags_lock);
> +
> +	/*
> +	 * Clear the per-lifetime state in the inode as we are now effectively
> +	 * a new inode and need to return to the initial state before reuse
> +	 * occurs.
> +	 */
> +	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
> +	ip->i_flags |= XFS_INEW;
> +	xfs_inode_clear_inactive_tag(pag, ip->i_ino);
> +	inode->i_state = I_NEW;
> +	ip->i_sick = 0;
> +	ip->i_checked = 0;
> +
> +	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> +	init_rwsem(&inode->i_rwsem);
> +
> +	spin_unlock(&ip->i_flags_lock);
> +	spin_unlock(&pag->pag_ici_lock);
> +
> +	/*
> +	 * Reattach dquots since we might have removed them when we put this
> +	 * inode on the inactivation list.
> +	 */
> +	return xfs_qm_dqattach(ip);
> +}

Ah, we don't actually perform any of the inactivation stuff here, so
we could be returning a unlinked inode that hasn't had it's data or
attribute forks truncated away at this point. That seems... wrong.

Also, this is largely a copy/paste of the XFS_IRECLAIMABLE reuse
code path...

.....

> @@ -713,6 +904,43 @@ xfs_icache_inode_is_allocated(
>  	return 0;
>  }
>  
> +/*
> + * Grab the inode for inactivation exclusively.
> + * Return true if we grabbed it.
> + */
> +static bool
> +xfs_inactive_grab(
> +	struct xfs_inode	*ip)
> +{
> +	ASSERT(rcu_read_lock_held());
> +
> +	/* quick check for stale RCU freed inode */
> +	if (!ip->i_ino)
> +		return false;
> +
> +	/*
> +	 * The radix tree lock here protects a thread in xfs_iget from racing
> +	 * with us starting reclaim on the inode.
> +	 *
> +	 * Due to RCU lookup, we may find inodes that have been freed and only
> +	 * have XFS_IRECLAIM set.  Indeed, we may see reallocated inodes that
> +	 * aren't candidates for reclaim at all, so we must check the
> +	 * XFS_IRECLAIMABLE is set first before proceeding to reclaim.
> +	 * Obviously if XFS_NEED_INACTIVE isn't set then we ignore this inode.
> +	 */
> +	spin_lock(&ip->i_flags_lock);
> +	if (!(ip->i_flags & XFS_NEED_INACTIVE) ||
> +	    (ip->i_flags & XFS_INACTIVATING)) {
> +		/* not a inactivation candidate. */
> +		spin_unlock(&ip->i_flags_lock);
> +		return false;
> +	}
> +
> +	ip->i_flags |= XFS_INACTIVATING;
> +	spin_unlock(&ip->i_flags_lock);
> +	return true;
> +}
> +
>  /*
>   * The inode lookup is done in batches to keep the amount of lock traffic and
>   * radix tree lookups to a minimum. The batch size is a trade off between
> @@ -736,6 +964,9 @@ xfs_inode_walk_ag_grab(
>  
>  	ASSERT(rcu_read_lock_held());
>  
> +	if (flags & XFS_INODE_WALK_INACTIVE)
> +		return xfs_inactive_grab(ip);
> +

Hmmm. This doesn't actually grab the inode. It's an unreferenced
inode walk, in a function that assumes that the grab() call returns
a referenced inode. Why isn't this using the inode reclaim walk
which is intended to walk unreferenced inodes?

>  	/* Check for stale RCU freed inode */
>  	spin_lock(&ip->i_flags_lock);
>  	if (!ip->i_ino)
> @@ -743,7 +974,8 @@ xfs_inode_walk_ag_grab(
>  
>  	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
>  	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
> -	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
> +	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM |
> +				  XFS_NEED_INACTIVE | XFS_INACTIVATING))

Comment needs updating. Also need a mask define here...

>  		goto out_unlock_noent;
>  	spin_unlock(&ip->i_flags_lock);
>  
> @@ -848,7 +1080,8 @@ xfs_inode_walk_ag(
>  			    xfs_iflags_test(batch[i], XFS_INEW))
>  				xfs_inew_wait(batch[i]);
>  			error = execute(batch[i], args);
> -			xfs_irele(batch[i]);
> +			if (!(iter_flags & XFS_INODE_WALK_INACTIVE))
> +				xfs_irele(batch[i]);
>  			if (error == -EAGAIN) {
>  				skipped++;
>  				continue;

Hmmmm.

> +
> +/*
> + * Deferred Inode Inactivation
> + * ===========================
> + *
> + * Sometimes, inodes need to have work done on them once the last program has
> + * closed the file.  Typically this means cleaning out any leftover post-eof or
> + * CoW staging blocks for linked files.  For inodes that have been totally
> + * unlinked, this means unmapping data/attr/cow blocks, removing the inode
> + * from the unlinked buckets, and marking it free in the inobt and inode table.
> + *
> + * This process can generate many metadata updates, which shows up as close()
> + * and unlink() calls that take a long time.  We defer all that work to a
> + * per-AG workqueue which means that we can batch a lot of work and do it in
> + * inode order for better performance.  Furthermore, we can control the
> + * workqueue, which means that we can avoid doing inactivation work at a bad
> + * time, such as when the fs is frozen.
> + *
> + * Deferred inactivation introduces new inode flag states (NEED_INACTIVE and
> + * INACTIVATING) and adds a new INACTIVE radix tree tag for fast access.  We
> + * maintain separate perag counters for both types, and move counts as inodes
> + * wander the state machine, which now works as follows:
> + *
> + * If the inode needs inactivation, we:
> + *   - Set the NEED_INACTIVE inode flag
> + *   - Increment the per-AG inactive count
> + *   - Set the INACTIVE tag in the per-AG inode tree
> + *   - Set the INACTIVE tag in the per-fs AG tree
> + *   - Schedule background inode inactivation
> + *
> + * If the inode does not need inactivation, we:
> + *   - Set the RECLAIMABLE inode flag
> + *   - Increment the per-AG reclaim count
> + *   - Set the RECLAIM tag in the per-AG inode tree
> + *   - Set the RECLAIM tag in the per-fs AG tree
> + *   - Schedule background inode reclamation
> + *
> + * When it is time for background inode inactivation, we:
> + *   - Set the INACTIVATING inode flag
> + *   - Make all the on-disk updates
> + *   - Clear both INACTIVATING and NEED_INACTIVE inode flags
> + *   - Decrement the per-AG inactive count
> + *   - Clear the INACTIVE tag in the per-AG inode tree
> + *   - Clear the INACTIVE tag in the per-fs AG tree if that was the last one
> + *   - Kick the inode into reclamation per the previous paragraph.

I suspect this needs to set the IRECLAIMABLE flag before it clears
the INACTIVE flags so that inode_ag_walk() doesn't find it in a
transient state. Hmmm - that may be why you factored the reclaim
flag setting functions?

> + *
> + * When it is time for background inode reclamation, we:
> + *   - Set the IRECLAIM inode flag
> + *   - Detach all the resources and remove the inode from the per-AG inode tree
> + *   - Clear both IRECLAIM and RECLAIMABLE inode flags
> + *   - Decrement the per-AG reclaim count
> + *   - Clear the RECLAIM tag from the per-AG inode tree
> + *   - Clear the RECLAIM tag from the per-fs AG tree if there are no more
> + *     inodes waiting for reclamation or inactivation
> + *
> + * Note that xfs_inodegc_queue and xfs_inactive_grab are further up in
> + * the source code so that we avoid static function declarations.
> + */
> +
> +/* Inactivate this inode. */
> +STATIC int

static

> +xfs_inactive_inode(
> +	struct xfs_inode	*ip,
> +	void			*args)
> +{
> +	struct xfs_eofblocks	*eofb = args;
> +	struct xfs_perag	*pag;
> +
> +	ASSERT(ip->i_mount->m_super->s_writers.frozen < SB_FREEZE_FS);

What condition is this trying to catch? It's something to do with
freeze, but you haven't documented what happens to inodes with
pending inactivation when a freeze is started....

> +
> +	/*
> +	 * Not a match for our passed in scan filter?  Put it back on the shelf
> +	 * and move on.
> +	 */
> +	spin_lock(&ip->i_flags_lock);
> +	if (!xfs_inode_matches_eofb(ip, eofb)) {
> +		ip->i_flags &= ~XFS_INACTIVATING;
> +		spin_unlock(&ip->i_flags_lock);
> +		return 0;
> +	}
> +	spin_unlock(&ip->i_flags_lock);

IDGI. What do EOF blocks have to do with running inode inactivation
on this inode?

> +
> +	trace_xfs_inode_inactivating(ip);
> +
> +	xfs_inactive(ip);
> +	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
> +
> +	/*
> +	 * Clear the inactive state flags and schedule a reclaim run once
> +	 * we're done with the inactivations.  We must ensure that the inode
> +	 * smoothly transitions from inactivating to reclaimable so that iget
> +	 * cannot see either data structure midway through the transition.
> +	 */
> +	pag = xfs_perag_get(ip->i_mount,
> +			XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino));
> +	spin_lock(&pag->pag_ici_lock);
> +	spin_lock(&ip->i_flags_lock);
> +
> +	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
> +	xfs_inode_clear_inactive_tag(pag, ip->i_ino);
> +
> +	__xfs_inode_set_reclaim_tag(pag, ip);
> +
> +	spin_unlock(&ip->i_flags_lock);
> +	spin_unlock(&pag->pag_ici_lock);
> +	xfs_perag_put(pag);
> +
> +	return 0;
> +}

/me wonders if we really need a separate radix tree tag for
inactivation.

> +/*
> + * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
> + * corrupted, we still need to clear the INACTIVE iflag so that we can move
> + * on to reclaiming the inode.
> + */
> +static int
> +xfs_inodegc_free_space(
> +	struct xfs_mount	*mp,
> +	struct xfs_eofblocks	*eofb)
> +{
> +	return xfs_inode_walk(mp, XFS_INODE_WALK_INACTIVE,
> +			xfs_inactive_inode, eofb, XFS_ICI_INACTIVE_TAG);
> +}

This could call the unreferenced reclaim AG walker now that all the reclaim
throttling stuff has been removed from it...

> +/* Try to get inode inactivation moving. */
> +void
> +xfs_inodegc_worker(
> +	struct work_struct	*work)
> +{
> +	struct xfs_mount	*mp = container_of(to_delayed_work(work),
> +					struct xfs_mount, m_inodegc_work);
> +	int			error;
> +
> +	/*
> +	 * We want to skip inode inactivation while the filesystem is frozen
> +	 * because we don't want the inactivation thread to block while taking
> +	 * sb_intwrite.  Therefore, we try to take sb_write for the duration
> +	 * of the inactive scan -- a freeze attempt will block until we're
> +	 * done here, and if the fs is past stage 1 freeze we'll bounce out
> +	 * until things unfreeze.  If the fs goes down while frozen we'll
> +	 * still have log recovery to clean up after us.
> +	 */
> +	if (!sb_start_write_trylock(mp->m_super))
> +		return;
> +
> +	error = xfs_inodegc_free_space(mp, NULL);
> +	if (error && error != -EAGAIN)
> +		xfs_err(mp, "inode inactivation failed, error %d", error);
> +
> +	sb_end_write(mp->m_super);
> +	xfs_inodegc_queue(mp);

Ok....

The way we've done this with other workqueue based background work
is that the freeze flushes and stops the workqueue, then restarts it
once the filesystem is thawed. This takes all the need for the
background work to have to run the freeze gaunlet....

> +}
> +
> +/* Force all queued inode inactivation work to run immediately. */
> +void
> +xfs_inodegc_force(
> +	struct xfs_mount	*mp)
> +{
> +	/*
> +	 * In order to reset the delay timer to run immediately, we have to
> +	 * cancel the work item and requeue it with a zero timer value.  We
> +	 * don't care if the worker races with our requeue, because at worst
> +	 * we iterate the radix tree and find no inodes to inactivate.
> +	 */
> +	if (!cancel_delayed_work(&mp->m_inodegc_work))
> +		return;

We do? I thought we could mod the timer. Yeah:

	mod_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);

will trigger the delayed work to run immediately...

> +
> +	queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
> +	flush_delayed_work(&mp->m_inodegc_work);
> +}

Yeah, that's a flush operation, not a force :)

> +/* Stop all queued inactivation work. */
> +void
> +xfs_inodegc_stop(
> +	struct xfs_mount	*mp)
> +{
> +	cancel_delayed_work_sync(&mp->m_inodegc_work);
> +}

Should this flush first? i.e. it will cancel pending work, but if
there is work running, it will wait for it to complete. Do we want
the queued work run before stopping, or just kill it dead?

> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 65897cb0cf2a..f20694f220c8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1665,6 +1665,35 @@ xfs_inactive_ifree(
>  	return 0;
>  }
>  
> +/* Prepare inode for inactivation. */
> +void
> +xfs_inode_inactivation_prep(
> +	struct xfs_inode	*ip)
> +{
> +	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> +		return;
> +
> +	/*
> +	 * If this inode is unlinked (and now unreferenced) we need to dispose
> +	 * of it in the on disk metadata.
> +	 *
> +	 * Change the generation so that the inode can't be opened by handle
> +	 * now that the last external references has dropped.  Bulkstat won't
> +	 * return inodes with zero nlink so nobody will ever find this inode
> +	 * again.  Then add this inode & blocks to the counts of things that
> +	 * will be freed during the next inactivation run.
> +	 */
> +	if (VFS_I(ip)->i_nlink == 0)
> +		VFS_I(ip)->i_generation = prandom_u32();

open by handle interfaces should not be able to open inodes that
have a zero nlink, hence I'm not sure what changing the generation
number actually buys us here...

If we can open nlink = 0 files via handles, then I think we've got
a bug or two to fix....

> +	/*
> +	 * Detach dquots just in case someone tries a quotaoff while the inode
> +	 * is waiting on the inactive list.  We'll reattach them (if needed)
> +	 * when inactivating the inode.
> +	 */
> +	xfs_qm_dqdetach(ip);
> +}

I think the dquot handling needs better documentation as it impacts
on the life cycle and interactions of dquots...

> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 97f31308de03..b03b127e34cc 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2792,6 +2792,13 @@ xlog_recover_process_iunlinks(
>  		}
>  		xfs_buf_rele(agibp);
>  	}
> +
> +	/*
> +	 * Now that we've put all the iunlink inodes on the lru, let's make
> +	 * sure that we perform all the on-disk metadata updates to actually
> +	 * free those inodes.
> +	 */

What LRU are we putting these inodes on? They are evicted from cache
immediately. A comment simply to say:

	/*
	 * Flush the pending unlinked inodes to ensure they are
	 * fully completed on disk and can be reclaimed before we
	 * signal that recovery is complete.
	 */
> +	xfs_inodegc_force(mp);
>  }
>  
>  STATIC void

.....
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 1c97b155a8ee..cd015e3d72fc 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -640,6 +640,10 @@ xfs_check_summary_counts(
>   * so we need to unpin them, write them back and/or reclaim them before unmount
>   * can proceed.
>   *
> + * Start the process by pushing all inodes through the inactivation process
> + * so that all file updates to on-disk metadata can be flushed with the log.
> + * After the AIL push, all inodes should be ready for reclamation.
> + *
>   * An inode cluster that has been freed can have its buffer still pinned in
>   * memory because the transaction is still sitting in a iclog. The stale inodes
>   * on that buffer will be pinned to the buffer until the transaction hits the
> @@ -663,6 +667,7 @@ static void
>  xfs_unmount_flush_inodes(
>  	struct xfs_mount	*mp)
>  {
> +	xfs_inodegc_force(mp);
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  	xfs_extent_busy_wait_all(mp);
>  	flush_workqueue(xfs_discard_wq);
> @@ -670,6 +675,7 @@ xfs_unmount_flush_inodes(
>  	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
>  
>  	xfs_ail_push_all_sync(mp->m_ail);
> +	xfs_inodegc_stop(mp);

That looks wrong. Stopping the background inactivation should be
done before we flush the AIL because bacground inactivation dirties
inodes. So we should be stopping the inodegc the moment we've
finished flushing out all the pending inactivations...

Hmm. xfs_unmount_flush_inodes() doesn't ring a bell with me, and
it's not in the current tree. Did I miss this in an earlier patch in
this patchset, or something else?

>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
>  	xfs_reclaim_inodes(mp);
>  	xfs_health_unmount(mp);
> @@ -1095,6 +1101,13 @@ xfs_unmountfs(
>  	uint64_t		resblks;
>  	int			error;
>  
> +	/*
> +	 * Perform all on-disk metadata updates required to inactivate inodes.
> +	 * Since this can involve finobt updates, do it now before we lose the
> +	 * per-AG space reservations.
> +	 */
> +	xfs_inodegc_force(mp);
> +

I can't tell why this is necessary given what
xfs_unmount_flush_inodes() does. Or, alternatively, why
xfs_unmount_flush_inodes() can do what it does without caring about
per-ag space reservations....

> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index ca1b57d291dc..0f9a1450fe0e 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -104,6 +104,12 @@ xfs_qm_scall_quotaoff(
>  	uint			inactivate_flags;
>  	struct xfs_qoff_logitem	*qoffstart = NULL;
>  
> +	/*
> +	 * Clean up the inactive list before we turn quota off, to reduce the
> +	 * amount of quotaoff work we have to do with the mutex held.
> +	 */
> +	xfs_inodegc_force(mp);
> +

Hmmm. why not just stop background inactivation altogether while
quotaoff runs? i.e. just do normal, inline inactivation when
quotaoff is running, and then we can get rid of the whole "drop
dquot references" issue that background inactivation has...

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e774358383d6..8d0142487fc7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -637,28 +637,34 @@ xfs_fs_destroy_inode(
>  	struct inode		*inode)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	bool			need_inactive;
>  
>  	trace_xfs_destroy_inode(ip);
>  
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> -	XFS_STATS_INC(ip->i_mount, vn_rele);
> -	XFS_STATS_INC(ip->i_mount, vn_remove);
> +	XFS_STATS_INC(mp, vn_rele);
> +	XFS_STATS_INC(mp, vn_remove);
>  
> -	xfs_inactive(ip);
> -
> -	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
> +	need_inactive = xfs_inode_needs_inactivation(ip);
> +	if (need_inactive) {
> +		trace_xfs_inode_set_need_inactive(ip);
> +		xfs_inode_inactivation_prep(ip);
> +	} else if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
>  		xfs_check_delalloc(ip, XFS_DATA_FORK);
>  		xfs_check_delalloc(ip, XFS_COW_FORK);
>  		ASSERT(0);
>  	}

Isn't this i_delayed_blks check still valid even for indoes that
need background invalidation? i.e. all dirty data has been flushed
at this point, and so i_delayed_blks should be zero for all
inodes regardless of whether then need inactivation or not....

> -
> -	XFS_STATS_INC(ip->i_mount, vn_reclaim);
> +	XFS_STATS_INC(mp, vn_reclaim);
> +	trace_xfs_inode_set_reclaimable(ip);
>  
>  	/*
>  	 * We should never get here with one of the reclaim flags already set.
>  	 */
>  	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
>  	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
> +	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_NEED_INACTIVE));
> +	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_INACTIVATING));

This should probably be opencoded instead of taking the flags
spinlock 4 times...

>  
>  	/*
>  	 * We always use background reclaim here because even if the inode is
> @@ -667,7 +673,10 @@ xfs_fs_destroy_inode(
>  	 * reclaim path handles this more efficiently than we can here, so
>  	 * simply let background reclaim tear down all inodes.
>  	 */
> -	xfs_inode_set_reclaim_tag(ip);
> +	if (need_inactive)
> +		xfs_inode_set_inactive_tag(ip);
> +	else
> +		xfs_inode_set_reclaim_tag(ip);
>  }
>  
>  static void
> @@ -797,6 +806,13 @@ xfs_fs_statfs(
>  	xfs_extlen_t		lsize;
>  	int64_t			ffree;
>  
> +	/*
> +	 * Process all the queued file and speculative preallocation cleanup so
> +	 * that the counter values we report here do not incorporate any
> +	 * resources that were previously deleted.
> +	 */
> +	xfs_inodegc_force(mp);

Same comment as for xfs_fs_counts()....
> +
>  	statp->f_type = XFS_SUPER_MAGIC;
>  	statp->f_namelen = MAXNAMELEN - 1;
>  
> @@ -911,6 +927,18 @@ xfs_fs_unfreeze(
>  	return 0;
>  }
>  
> +/*
> + * Before we get to stage 1 of a freeze, force all the inactivation work so
> + * that there's less work to do if we crash during the freeze.
> + */
> +STATIC int
> +xfs_fs_freeze_super(
> +	struct super_block	*sb)
> +{
> +	xfs_inodegc_force(XFS_M(sb));
> +	return freeze_super(sb);
> +}

Yeah, definitely need a description of freeze interactions...

> @@ -1720,6 +1749,13 @@ xfs_remount_ro(
>  		return error;
>  	}
>  
> +	/*
> +	 * Perform all on-disk metadata updates required to inactivate inodes.
> +	 * Since this can involve finobt updates, do it now before we lose the
> +	 * per-AG space reservations.
> +	 */
> +	xfs_inodegc_force(mp);

Should we stop background inactivation, because we can't make
modifications anymore and hence background inactication makes little
sense...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
