Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20BAC2B9F4
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 19:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E52E61246
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 19:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhFNT3Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 15:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232877AbhFNT3Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 15:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E3F961001;
        Mon, 14 Jun 2021 19:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623698841;
        bh=d+HQ7axoeoK8g/WxMc3JlOFylAO3uF9ckZDwiGTzv8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KqpDc0N3VD8h5to4hQWG3M5DsjO8g6kdsuHOFt3wk/nS19VoTGX3zl4v2si6GUCeO
         KCqdV/+BY9/M8ncx5HlCeB6+jUW+AIpqn8dmdIq/Ev2GTnQIs+O3hr6Pp8uk8LOaqB
         fWCpCANfpGOZc0e53N6ZCA10SWFgMUbg8A67I+lVwXupyLNre9E9ee+eY/EAWIBATx
         ZtlwYBFJcb9AjXhm1sA2P10hrniZFKTxWd1TCxPEwHFOzCV2kwkwj5l/kHnxTxwzmr
         LpaLj1L1P94XxyVeeo5BICaTUwf25PUgwjB/+8LBLQdAgumVnP2ZqvpWVUS2QuIj63
         QP/7wGRcciTdQ==
Date:   Mon, 14 Jun 2021 12:27:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH 06/16] xfs: defer inode inactivation to a workqueue
Message-ID: <20210614192720.GF2945763@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360482987.1530792.9282768072804488207.stgit@locust>
 <YMeA/3nXG/bdFoMA@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMeA/3nXG/bdFoMA@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 12:17:03PM -0400, Brian Foster wrote:
> On Sun, Jun 13, 2021 at 10:20:29AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Instead of calling xfs_inactive directly from xfs_fs_destroy_inode,
> > defer the inactivation phase to a separate workqueue.  With this change,
> > we can speed up directory tree deletions by reducing the duration of
> > unlink() calls to the directory and unlinked list updates.
> > 
> > By moving the inactivation work to the background, we can reduce the
> > total cost of deleting a lot of files by performing the file deletions
> > in disk order instead of directory entry order, which can be arbitrary.
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
> > so we flush inactivation work during syncfs in order to maintain the
> > existing behaviors, at least for callers that unlink() and sync().
> > 
> > For this patch we'll set the delay to zero to mimic the old timing as
> > much as possible; in the next patch we'll play with different delay
> > settings.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Just some high level questions on a first/cursory pass..
> 
> >  Documentation/admin-guide/xfs.rst |    3 
> >  fs/xfs/scrub/common.c             |    7 +
> >  fs/xfs/xfs_icache.c               |  332 ++++++++++++++++++++++++++++++++++---
> >  fs/xfs/xfs_icache.h               |    5 +
> >  fs/xfs/xfs_inode.h                |   19 ++
> >  fs/xfs/xfs_log_recover.c          |    7 +
> >  fs/xfs/xfs_mount.c                |   26 +++
> >  fs/xfs/xfs_mount.h                |   21 ++
> >  fs/xfs/xfs_super.c                |   53 ++++++
> >  fs/xfs/xfs_trace.h                |   50 +++++-
> >  10 files changed, 490 insertions(+), 33 deletions(-)
> > 
> > 
> > diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> > index 8de008c0c5ad..f9b109bfc6a6 100644
> > --- a/Documentation/admin-guide/xfs.rst
> > +++ b/Documentation/admin-guide/xfs.rst
> > @@ -524,7 +524,8 @@ and the short name of the data device.  They all can be found in:
> >                    mount time quotacheck.
> >    xfs-gc          Background garbage collection of disk space that have been
> >                    speculatively allocated beyond EOF or for staging copy on
> > -                  write operations.
> > +                  write operations; and files that are no longer linked into
> > +                  the directory tree.
> >  ================  ===========
> >  
> >  For example, the knobs for the quotacheck workqueue for /dev/nvme0n1 would be
> ...
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 4002f0b84401..e094c16aa8c5 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> ...
> > @@ -262,6 +285,9 @@ xfs_perag_set_inode_tag(
> >  	case XFS_ICI_BLOCKGC_TAG:
> >  		xfs_blockgc_queue(pag);
> >  		break;
> > +	case XFS_ICI_INODEGC_TAG:
> > +		xfs_inodegc_queue(mp);
> > +		break;
> >  	}
> >  
> >  	trace_xfs_perag_set_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
> > @@ -338,28 +364,26 @@ xfs_inode_mark_reclaimable(
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_perag	*pag;
> > +	unsigned int		tag;
> >  	bool			need_inactive = xfs_inode_needs_inactive(ip);
> 
> Nit: I think we usually try to avoid function calls in the variable
> declarations like this..

<shrug> For boolean flags that don't change value in the function body
I'd rather they be initialized at declaration time so that code
maintainers don't have to remember if a variable is initialized or not.
need_inactive has scope and a valid value wherever you are in the
function body.

> >  
> >  	if (!need_inactive) {
> >  		/* Going straight to reclaim, so drop the dquots. */
> >  		xfs_qm_dqdetach(ip);
> > -	} else {
> > -		xfs_inactive(ip);
> > -	}
> >  
> 
> Ok, so obviously this disconnects the unlink -> destroy path from the
> historical inactive -> reclaimable sequence. Is there any concern for
> example from a memory usage standpoint or anything where we might want
> to consider waiting on outstanding work here? E.g., if we had a large
> filesystem, limited memory and enough CPUs doing unlinks where the
> background reclaim simply can't keep up.

So far in my evaluation, deferred inactivation has improved reclaim
behavior because evict_inodes can push all eligible inodes all the way
to IRECLAIMABLE without getting stuck behind xfs_inactive, and the
shrinker can free other cached inodes sooner.  I think we're still
mostly reliant on xfs_inode_alloc looping when memory is low to throttle
the size of the inode cache, since I think mass deletions are what push
the inodegc code the hardest.  If reclaim can't free inodes fast enough,
I think that means the AIL is running slowly, in which case both
frontend and background workers will block on the log.

> I suppose it's a similar situation that inode reclaim is in, but we do
> have shrinker feedback to hook back in and actually free available
> objects. Do we have or need something like that if too many objects are
> stuck waiting on inactivation?

There's no direct link between the shrinker and the inodegc worker,
which means that it can't push the inodegc worker to get even more
inodes to IRECLAIMABLE.  I've played with racing directory tree
deletions of a filesystem with 8M inodes against fsstress on VMs with
512M of memory, but so far I haven't been able to drive the system into
OOM any more easily than I could before this patch.  The unlink calls
seem to get stuck under xfs_iget, like I expect.

The VFS still has this (erroneous) notion that calling ->destroy_inode
will directly reclaim inodes from XFS, but the only difference from
today's code is that it can take longer for inodes to get to that state.
To fix that, I've also thought about making xfs_fs_free_cached_objects
requeue the inodegc worker immediately (but without waiting for it), but
so far I haven't needed to do that to avoid trouble.

> > -	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
> > -		xfs_check_delalloc(ip, XFS_DATA_FORK);
> > -		xfs_check_delalloc(ip, XFS_COW_FORK);
> > -		ASSERT(0);
> > +		if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
> > +			xfs_check_delalloc(ip, XFS_DATA_FORK);
> > +			xfs_check_delalloc(ip, XFS_COW_FORK);
> > +			ASSERT(0);
> > +		}
> >  	}
> >  
> >  	XFS_STATS_INC(mp, vn_reclaim);
> >  
> >  	/*
> > -	 * We should never get here with one of the reclaim flags already set.
> > +	 * We should never get here with any of the reclaim flags already set.
> >  	 */
> > -	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
> > -	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
> > +	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_ALL_IRECLAIM_FLAGS));
> >  
> >  	/*
> >  	 * We always use background reclaim here because even if the inode is
> ...
> > @@ -889,22 +936,32 @@ xfs_dqrele_igrab(
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
> 
> I was a little curious why we'd skip reclaimable inodes here but not
> need_inactive..
> 
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
> > +	ret = true;
> > +	if (ip->i_flags & XFS_NEED_INACTIVE)
> > +		ip->i_flags |= XFS_INACTIVATING;
> > +	else if (!igrab(VFS_I(ip)))
> > +		ret = false;
> 
> ... but I guess we process the latter (in that we release the dquots and
> revert the just added inactivating state). Is this a functional
> requirement or considered an optimization? FWIW, it would be helpful if
> the comment more explained why we did this as such as opposed to just
> reflecting what the code already does.

It's an optimization to avoid stalling quotaoff on NEEDS_INACTIVE
inodes.  This means that quotaoff can now cause the background inodegc
worker to have to loop again, but seeing as quotaoff can pin the log
tail, I decided that was a reasonable tradeoff.
How does this rewording sound to you?

	/*
	 * If the inode is queued but not currently undergoing
	 * inactivation, we want to slip in to drop the dquots ASAP
	 * because quotaoff can pin the log tail and cause log livelock.
	 * Avoiding that is worth potentially forcing the inodegc worker
	 * to make another pass.  Set INACTIVATING to prevent inodegc
	 * and iget from touching the inode.
	 *
	 * Otherwise, the inode looks alive; try to grab a VFS reference
	 * so that it won't get destroyed.  If we got the reference,
	 * return true to say that we grabbed the inode.
	 *
	 * If we can't get the reference, then we know the inode had its
	 * VFS state torn down and hasn't yet entered the reclaim
	 * machinery.  Since we also know that dquots are detached from
	 * an inode before it enters reclaim, we can skip the inode.
	 */

> >  
> >  out_unlock:
> >  	spin_unlock(&ip->i_flags_lock);
> > @@ -917,6 +974,8 @@ xfs_dqrele_inode(
> >  	struct xfs_inode	*ip,
> >  	struct xfs_icwalk	*icw)
> >  {
> > +	bool			live_inode;
> > +
> >  	if (xfs_iflags_test(ip, XFS_INEW))
> >  		xfs_inew_wait(ip);
> >  
> > @@ -934,7 +993,19 @@ xfs_dqrele_inode(
> >  		ip->i_pdquot = NULL;
> >  	}
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -	xfs_irele(ip);
> > +
> > +	/*
> > +	 * If we set INACTIVATING earlier to prevent this inode from being
> > +	 * touched, clear that state to let the inodegc claim it.  Otherwise,
> > +	 * it's a live inode and we need to release it.
> > +	 */
> > +	spin_lock(&ip->i_flags_lock);
> > +	live_inode = !(ip->i_flags & XFS_INACTIVATING);
> > +	ip->i_flags &= ~XFS_INACTIVATING;
> > +	spin_unlock(&ip->i_flags_lock);
> > +
> > +	if (live_inode)
> > +		xfs_irele(ip);
> >  }
> >  
> >  /*
> ...
> > +/*
> > + * Force all currently queued inode inactivation work to run immediately, and
> > + * wait for the work to finish.
> > + */
> > +void
> > +xfs_inodegc_flush(
> > +	struct xfs_mount	*mp)
> > +{
> > +	trace_xfs_inodegc_flush(mp, 0, _RET_IP_);
> > +	flush_delayed_work(&mp->m_inodegc_work);
> > +}
> > +
> > +/* Disable the inode inactivation background worker and wait for it to stop. */
> > +void
> > +xfs_inodegc_stop(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (!test_and_clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
> > +		return;
> > +
> > +	cancel_delayed_work_sync(&mp->m_inodegc_work);
> > +	trace_xfs_inodegc_stop(mp, 0, _RET_IP_);
> > +}
> > +
> > +/*
> > + * Enable the inode inactivation background worker and schedule deferred inode
> > + * inactivation work if there is any.
> > + */
> > +void
> > +xfs_inodegc_start(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (test_and_set_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
> > +		return;
> > +
> > +	trace_xfs_inodegc_start(mp, 0, _RET_IP_);
> > +	xfs_inodegc_queue(mp);
> > +}
> > +
> 
> This seems like a decent amount of boilerplate. Is all of this really
> necessary and/or is it worth it just for the added tracepoints?

I've gotten a lot of use out of the tracepoints to debug all sorts of
weird mis-interactions between freeze, remounts, and the inodegc worker.

> ISTM
> that the start/stop thing is already technically racy wrt to queue
> activity and the bit check in the worker might be sufficient to avoid
> transaction/freeze deadlocks or whatever the original intent was. Hm?

The bitflag isn't racy, though why isn't obvious.  There are seven
places where we change the INODEGC_RUNNING state:

- For freeze and ro remount, the VFS will take s_umount before calling
  into XFS, and XFS then calls inodegc_flush to complete all the queued
  work before changing the bit state.

  During the v6 review Dave wondered if we even needed the INODEGC
  RUNNING flag, and I concluded that we need it for freeze, since we
  allow inodes to sleep under xfs_inactive() while trying to allocate a
  transaction.  Under the new scheme, inodes can be queued for
  inactivation on a frozen fs, but we need xfs_inodegc_queue to know not
  to kick the worker without having to mess around with VFS locks to
  check the freeze state.

- For thaw and rw remount, the VFS takes s_umount and calls XFS, which
  re-enables the worker.

- Mount and unmount run in isolation (since we can't have any open files
  on the filesystem) so there won't be any other threads trying to call
  into the filesystem.

- I think xchk_{start,stop}_reaping is racy though.  That code probably
  has to sb_start_write to prevent freeze or ro remount from messing
  with the INODEGC_RUNNING state.  That would still leave a hole if
  fscounters scrub races with a rw remount and immediately files start
  getting deleted, but maybe that's just not worth worrying about.
  Scrub will try again a few times, and in djwong-dev I solve that by
  freezing the filesystem if the unlocked fscounters scrub fails.

--D

> 
> Brian
> 
> >  /* XFS Inode Cache Walking Code */
> >  
> >  /*
> > @@ -1708,6 +1979,8 @@ xfs_icwalk_igrab(
> >  		return xfs_blockgc_igrab(ip);
> >  	case XFS_ICWALK_RECLAIM:
> >  		return xfs_reclaim_igrab(ip, icw);
> > +	case XFS_ICWALK_INODEGC:
> > +		return xfs_inodegc_igrab(ip);
> >  	default:
> >  		return false;
> >  	}
> > @@ -1736,6 +2009,9 @@ xfs_icwalk_process_inode(
> >  	case XFS_ICWALK_RECLAIM:
> >  		xfs_reclaim_inode(ip, pag);
> >  		break;
> > +	case XFS_ICWALK_INODEGC:
> > +		xfs_inodegc_inactivate(ip, pag, icw);
> > +		break;
> >  	}
> >  	return error;
> >  }
> > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > index 00dc98a92835..840eac06a71b 100644
> > --- a/fs/xfs/xfs_icache.h
> > +++ b/fs/xfs/xfs_icache.h
> > @@ -80,4 +80,9 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
> >  void xfs_blockgc_stop(struct xfs_mount *mp);
> >  void xfs_blockgc_start(struct xfs_mount *mp);
> >  
> > +void xfs_inodegc_worker(struct work_struct *work);
> > +void xfs_inodegc_flush(struct xfs_mount *mp);
> > +void xfs_inodegc_stop(struct xfs_mount *mp);
> > +void xfs_inodegc_start(struct xfs_mount *mp);
> > +
> >  #endif
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index e3137bbc7b14..fa5be0d071ad 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -240,6 +240,7 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
> >  #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
> >  #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
> >  #define XFS_IEOFBLOCKS		(1 << 9) /* has the preallocblocks tag set */
> > +#define XFS_NEED_INACTIVE	(1 << 10) /* see XFS_INACTIVATING below */
> >  /*
> >   * If this unlinked inode is in the middle of recovery, don't let drop_inode
> >   * truncate and free the inode.  This can happen if we iget the inode during
> > @@ -248,6 +249,21 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
> >  #define XFS_IRECOVERY		(1 << 11)
> >  #define XFS_ICOWBLOCKS		(1 << 12)/* has the cowblocks tag set */
> >  
> > +/*
> > + * If we need to update on-disk metadata before this IRECLAIMABLE inode can be
> > + * freed, then NEED_INACTIVE will be set.  Once we start the updates, the
> > + * INACTIVATING bit will be set to keep iget away from this inode.  After the
> > + * inactivation completes, both flags will be cleared and the inode is a
> > + * plain old IRECLAIMABLE inode.
> > + */
> > +#define XFS_INACTIVATING	(1 << 13)
> > +
> > +/* All inode state flags related to inode reclaim. */
> > +#define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
> > +				 XFS_IRECLAIM | \
> > +				 XFS_NEED_INACTIVE | \
> > +				 XFS_INACTIVATING)
> > +
> >  /*
> >   * Per-lifetime flags need to be reset when re-using a reclaimable inode during
> >   * inode lookup. This prevents unintended behaviour on the new inode from
> > @@ -255,7 +271,8 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
> >   */
> >  #define XFS_IRECLAIM_RESET_FLAGS	\
> >  	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
> > -	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED)
> > +	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
> > +	 XFS_INACTIVATING)
> >  
> >  /*
> >   * Flags for inode locking.
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 1227503d2246..9d8fc85bd28d 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2784,6 +2784,13 @@ xlog_recover_process_iunlinks(
> >  		}
> >  		xfs_buf_rele(agibp);
> >  	}
> > +
> > +	/*
> > +	 * Flush the pending unlinked inodes to ensure that the inactivations
> > +	 * are fully completed on disk and the incore inodes can be reclaimed
> > +	 * before we signal that recovery is complete.
> > +	 */
> > +	xfs_inodegc_flush(mp);
> >  }
> >  
> >  STATIC void
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index c3a96fb3ad80..ab65a14e51e6 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -514,7 +514,8 @@ xfs_check_summary_counts(
> >   * Flush and reclaim dirty inodes in preparation for unmount. Inodes and
> >   * internal inode structures can be sitting in the CIL and AIL at this point,
> >   * so we need to unpin them, write them back and/or reclaim them before unmount
> > - * can proceed.
> > + * can proceed.  In other words, callers are required to have inactivated all
> > + * inodes.
> >   *
> >   * An inode cluster that has been freed can have its buffer still pinned in
> >   * memory because the transaction is still sitting in a iclog. The stale inodes
> > @@ -546,6 +547,7 @@ xfs_unmount_flush_inodes(
> >  	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
> >  
> >  	xfs_ail_push_all_sync(mp->m_ail);
> > +	xfs_inodegc_stop(mp);
> >  	cancel_delayed_work_sync(&mp->m_reclaim_work);
> >  	xfs_reclaim_inodes(mp);
> >  	xfs_health_unmount(mp);
> > @@ -782,6 +784,9 @@ xfs_mountfs(
> >  	if (error)
> >  		goto out_log_dealloc;
> >  
> > +	/* Enable background inode inactivation workers. */
> > +	xfs_inodegc_start(mp);
> > +
> >  	/*
> >  	 * Get and sanity-check the root inode.
> >  	 * Save the pointer to it in the mount structure.
> > @@ -936,6 +941,15 @@ xfs_mountfs(
> >  	xfs_irele(rip);
> >  	/* Clean out dquots that might be in memory after quotacheck. */
> >  	xfs_qm_unmount(mp);
> > +
> > +	/*
> > +	 * Inactivate all inodes that might still be in memory after a log
> > +	 * intent recovery failure so that reclaim can free them.  Metadata
> > +	 * inodes and the root directory shouldn't need inactivation, but the
> > +	 * mount failed for some reason, so pull down all the state and flee.
> > +	 */
> > +	xfs_inodegc_flush(mp);
> > +
> >  	/*
> >  	 * Flush all inode reclamation work and flush the log.
> >  	 * We have to do this /after/ rtunmount and qm_unmount because those
> > @@ -983,6 +997,16 @@ xfs_unmountfs(
> >  	uint64_t		resblks;
> >  	int			error;
> >  
> > +	/*
> > +	 * Perform all on-disk metadata updates required to inactivate inodes
> > +	 * that the VFS evicted earlier in the unmount process.  Freeing inodes
> > +	 * and discarding CoW fork preallocations can cause shape changes to
> > +	 * the free inode and refcount btrees, respectively, so we must finish
> > +	 * this before we discard the metadata space reservations.  Metadata
> > +	 * inodes and the root directory do not require inactivation.
> > +	 */
> > +	xfs_inodegc_flush(mp);
> > +
> >  	xfs_blockgc_stop(mp);
> >  	xfs_fs_unreserve_ag_blocks(mp);
> >  	xfs_qm_unmount_quotas(mp);
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index c78b63fe779a..dc906b78e24c 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -154,6 +154,13 @@ typedef struct xfs_mount {
> >  	uint8_t			m_rt_checked;
> >  	uint8_t			m_rt_sick;
> >  
> > +	/*
> > +	 * This atomic bitset controls flags that alter the behavior of the
> > +	 * filesystem.  Use only the atomic bit helper functions here; see
> > +	 * XFS_OPFLAG_* for information about the actual flags.
> > +	 */
> > +	unsigned long		m_opflags;
> > +
> >  	/*
> >  	 * End of read-mostly variables. Frequently written variables and locks
> >  	 * should be placed below this comment from now on. The first variable
> > @@ -184,6 +191,7 @@ typedef struct xfs_mount {
> >  	uint64_t		m_resblks_avail;/* available reserved blocks */
> >  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> >  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
> > +	struct delayed_work	m_inodegc_work; /* background inode inactive */
> >  	struct xfs_kobj		m_kobj;
> >  	struct xfs_kobj		m_error_kobj;
> >  	struct xfs_kobj		m_error_meta_kobj;
> > @@ -258,6 +266,19 @@ typedef struct xfs_mount {
> >  #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
> >  #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
> >  
> > +/*
> > + * Operation flags -- each entry here is a bit index into m_opflags and is
> > + * not itself a flag value.  Use the atomic bit functions to access.
> > + */
> > +enum xfs_opflag_bits {
> > +	/*
> > +	 * If set, background inactivation worker threads will be scheduled to
> > +	 * process queued inodegc work.  If not, queued inodes remain in memory
> > +	 * waiting to be processed.
> > +	 */
> > +	XFS_OPFLAG_INODEGC_RUNNING_BIT	= 0,
> > +};
> > +
> >  /*
> >   * Max and min values for mount-option defined I/O
> >   * preallocation sizes.
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index dd1ee333dcb3..0b01d9499395 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -714,6 +714,8 @@ xfs_fs_sync_fs(
> >  {
> >  	struct xfs_mount	*mp = XFS_M(sb);
> >  
> > +	trace_xfs_fs_sync_fs(mp, wait, _RET_IP_);
> > +
> >  	/*
> >  	 * Doing anything during the async pass would be counterproductive.
> >  	 */
> > @@ -730,6 +732,25 @@ xfs_fs_sync_fs(
> >  		flush_delayed_work(&mp->m_log->l_work);
> >  	}
> >  
> > +	/*
> > +	 * Flush all deferred inode inactivation work so that the free space
> > +	 * counters will reflect recent deletions.  Do not force the log again
> > +	 * because log recovery can restart the inactivation from the info that
> > +	 * we just wrote into the ondisk log.
> > +	 *
> > +	 * For regular operation this isn't strictly necessary since we aren't
> > +	 * required to guarantee that unlinking frees space immediately, but
> > +	 * that is how XFS historically behaved.
> > +	 *
> > +	 * If, however, the filesystem is at FREEZE_PAGEFAULTS, this is our
> > +	 * last chance to complete the inactivation work before the filesystem
> > +	 * freezes and the log is quiesced.  The background worker will not
> > +	 * activate again until the fs is thawed because the VFS won't evict
> > +	 * any more inodes until freeze_super drops s_umount and we disable the
> > +	 * worker in xfs_fs_freeze.
> > +	 */
> > +	xfs_inodegc_flush(mp);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -844,6 +865,17 @@ xfs_fs_freeze(
> >  	 */
> >  	flags = memalloc_nofs_save();
> >  	xfs_blockgc_stop(mp);
> > +
> > +	/*
> > +	 * Stop the inodegc background worker.  freeze_super already flushed
> > +	 * all pending inodegc work when it sync'd the filesystem after setting
> > +	 * SB_FREEZE_PAGEFAULTS, and it holds s_umount, so we know that inodes
> > +	 * cannot enter xfs_fs_destroy_inode until the freeze is complete.
> > +	 * If the filesystem is read-write, inactivated inodes will queue but
> > +	 * the worker will not run until the filesystem thaws or unmounts.
> > +	 */
> > +	xfs_inodegc_stop(mp);
> > +
> >  	xfs_save_resvblks(mp);
> >  	ret = xfs_log_quiesce(mp);
> >  	memalloc_nofs_restore(flags);
> > @@ -859,6 +891,14 @@ xfs_fs_unfreeze(
> >  	xfs_restore_resvblks(mp);
> >  	xfs_log_work_queue(mp);
> >  	xfs_blockgc_start(mp);
> > +
> > +	/*
> > +	 * Don't reactivate the inodegc worker on a readonly filesystem because
> > +	 * inodes are sent directly to reclaim.
> > +	 */
> > +	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
> > +		xfs_inodegc_start(mp);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -1665,6 +1705,9 @@ xfs_remount_rw(
> >  	if (error && error != -ENOSPC)
> >  		return error;
> >  
> > +	/* Re-enable the background inode inactivation worker. */
> > +	xfs_inodegc_start(mp);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -1687,6 +1730,15 @@ xfs_remount_ro(
> >  		return error;
> >  	}
> >  
> > +	/*
> > +	 * Stop the inodegc background worker.  xfs_fs_reconfigure already
> > +	 * flushed all pending inodegc work when it sync'd the filesystem.
> > +	 * The VFS holds s_umount, so we know that inodes cannot enter
> > +	 * xfs_fs_destroy_inode during a remount operation.  In readonly mode
> > +	 * we send inodes straight to reclaim, so no inodes will be queued.
> > +	 */
> > +	xfs_inodegc_stop(mp);
> > +
> >  	/* Free the per-AG metadata reservation pool. */
> >  	error = xfs_fs_unreserve_ag_blocks(mp);
> >  	if (error) {
> > @@ -1810,6 +1862,7 @@ static int xfs_init_fs_context(
> >  	mutex_init(&mp->m_growlock);
> >  	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
> >  	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
> > +	INIT_DELAYED_WORK(&mp->m_inodegc_work, xfs_inodegc_worker);
> >  	mp->m_kobj.kobject.kset = xfs_kset;
> >  	/*
> >  	 * We don't create the finobt per-ag space reservation until after log
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index d0b4799ad1e6..ca9bfbd28886 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -156,6 +156,45 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_put);
> >  DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
> >  DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
> >  
> > +DECLARE_EVENT_CLASS(xfs_fs_class,
> > +	TP_PROTO(struct xfs_mount *mp, int data, unsigned long caller_ip),
> > +	TP_ARGS(mp, data, caller_ip),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(unsigned long long, mflags)
> > +		__field(unsigned long, opflags)
> > +		__field(unsigned long, sbflags)
> > +		__field(int, data)
> > +		__field(unsigned long, caller_ip)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->mflags = mp->m_flags;
> > +		__entry->opflags = mp->m_opflags;
> > +		__entry->sbflags = mp->m_super->s_flags;
> > +		__entry->data = data;
> > +		__entry->caller_ip = caller_ip;
> > +	),
> > +	TP_printk("dev %d:%d flags 0x%llx opflags 0x%lx sflags 0x%lx data %d caller %pS",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->mflags,
> > +		  __entry->opflags,
> > +		  __entry->sbflags,
> > +		  __entry->data,
> > +		  (char *)__entry->caller_ip)
> > +);
> > +
> > +#define DEFINE_FS_EVENT(name)	\
> > +DEFINE_EVENT(xfs_fs_class, name,					\
> > +	TP_PROTO(struct xfs_mount *mp, int data, unsigned long caller_ip), \
> > +	TP_ARGS(mp, data, caller_ip))
> > +DEFINE_FS_EVENT(xfs_inodegc_flush);
> > +DEFINE_FS_EVENT(xfs_inodegc_start);
> > +DEFINE_FS_EVENT(xfs_inodegc_stop);
> > +DEFINE_FS_EVENT(xfs_inodegc_queue);
> > +DEFINE_FS_EVENT(xfs_inodegc_worker);
> > +DEFINE_FS_EVENT(xfs_fs_sync_fs);
> > +
> >  DECLARE_EVENT_CLASS(xfs_ag_class,
> >  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
> >  	TP_ARGS(mp, agno),
> > @@ -615,14 +654,17 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
> >  	TP_STRUCT__entry(
> >  		__field(dev_t, dev)
> >  		__field(xfs_ino_t, ino)
> > +		__field(unsigned long, iflags)
> >  	),
> >  	TP_fast_assign(
> >  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> >  		__entry->ino = ip->i_ino;
> > +		__entry->iflags = ip->i_flags;
> >  	),
> > -	TP_printk("dev %d:%d ino 0x%llx",
> > +	TP_printk("dev %d:%d ino 0x%llx iflags 0x%lx",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > -		  __entry->ino)
> > +		  __entry->ino,
> > +		  __entry->iflags)
> >  )
> >  
> >  #define DEFINE_INODE_EVENT(name) \
> > @@ -666,6 +708,10 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
> >  DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
> >  DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
> >  DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
> > +DEFINE_INODE_EVENT(xfs_inode_set_reclaimable);
> > +DEFINE_INODE_EVENT(xfs_inode_reclaiming);
> > +DEFINE_INODE_EVENT(xfs_inode_set_need_inactive);
> > +DEFINE_INODE_EVENT(xfs_inode_inactivating);
> >  
> >  /*
> >   * ftrace's __print_symbolic requires that all enum values be wrapped in the
> > 
> 
