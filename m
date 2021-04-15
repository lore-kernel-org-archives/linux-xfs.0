Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2496C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 17:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B59B561184
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 17:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbhDORBH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 13:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233343AbhDORBH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Apr 2021 13:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0708C611AC;
        Thu, 15 Apr 2021 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618506044;
        bh=nuxQB8pEhetbPvLrP/ZS0cGbtYaZluRzHH2M21d6aDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ypyb7GvWAwKa26w/GxipdwUwmlZ93KKKnLReDCRbzNl0w+hrMiOtwQK+wfw0VuOnd
         6XhB4HcPTq0ZvmkrpzzV31M5pHeU77MGrq9j5AEu+f1hlYbtHGQcOcB7B0WkM6w21a
         noEEu/CE/AggIzHyW8jrFRFk9WCgFL7gWHd6ba6CFE9na3HIkawkHuwJcnNjytlb1o
         qQ4+dZVkYwUoeIFBbFOlzQCP3zucNIVcxbWUXOYueVtlY9l3N4Tc6GT4H6oF2uEAor
         LGP7pQun7kAmlrmcXgWLZUNn8PnPXRAKjK5vkPgIMqvyE4zunCJQfMal25j9xc4eAS
         K7oLYZyhynmZg==
Date:   Thu, 15 Apr 2021 10:00:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] xfs: support shrinking empty AGs
Message-ID: <20210415170039.GA3122264@magnolia>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-5-hsiangkao@redhat.com>
 <20210415042549.GM63242@dread.disaster.area>
 <20210415052226.GC1864610@xiangao.remote.csb>
 <20210415083312.GO63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415083312.GO63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 15, 2021 at 06:33:12PM +1000, Dave Chinner wrote:
> On Thu, Apr 15, 2021 at 01:22:26PM +0800, Gao Xiang wrote:
> > On Thu, Apr 15, 2021 at 02:25:49PM +1000, Dave Chinner wrote:
> > > On Thu, Apr 15, 2021 at 03:52:40AM +0800, Gao Xiang wrote:
> > > > +static int
> > > > +xfs_shrinkfs_deactivate_ags(
> > > > +	struct xfs_mount        *mp,
> > > > +	xfs_agnumber_t		oagcount,
> > > > +	xfs_agnumber_t		nagcount)
> > > > +{
> > > > +	xfs_agnumber_t		agno;
> > > > +	int			error;
> > > > +
> > > > +	/* confirm AGs pending for shrinking are all inactive */
> > > > +	for (agno = nagcount; agno < oagcount; ++agno) {
> > > > +		struct xfs_buf *agfbp, *agibp;
> > > > +		struct xfs_perag *pag = xfs_perag_get(mp, agno);
> > > > +
> > > > +		down_write(&pag->pag_inactive_rwsem);
> > > > +		/* need to lock agi, agf buffers here to close all races */
> > > > +		error = xfs_read_agi(mp, NULL, agno, &agibp);
> > > > +		if (!error) {
> > > > +			error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agfbp);
> > > > +			if (!error) {
> > > > +				pag->pag_inactive = true;
> > > > +				xfs_buf_relse(agfbp);
> > > > +			}
> > > > +			xfs_buf_relse(agibp);
> > > > +		}
> > > > +		up_write(&pag->pag_inactive_rwsem);
> > > > +		xfs_perag_put(pag);
> > > > +		if (error)
> > > > +			break;
> > > > +	}
> > > > +	return error;
> > > > +}
> > > 
> > > Hmmmm. Ok, that's why the first patch had the specific locking
> > > pattern it had, because once the AGI is locked under the
> > > inactive_rwsem. This seems ... fragile. It relies on the code
> > > looking up the perag to check the pag->pag_inactive flag before it
> > > takes an AGF or AGI lock, but does not allow a caller than has
> > > an AGI or AGF locked to take the inactive_sem to check if the per-ag
> > > is inactive or not. It's a one-way locking mechanism...
> > 
> > It guarantees that when AGF, AGI locked, pag_inactive won't be
> > switched, and before taking AGF or AGI, pag_inactive_sem should
> > be taken to confirm AGF, AGI can be read. That is the way that
> > I can think out with much less invasion than touch more XFS
> > codebase....
> 
> Yes, I understand how this works, and I simply don't think it is
> necessary to lock AG buffers to mark an AG as inactive in
> preparation for shrink. AFAICT you need to do it this way because
> there's no way to wait for a perag reference to go away once it's
> been taken, and hence you have to ensure that this code locks the AG
> headers before setting the inactive flag so that it can be checked
> before attempting to access the AG header that might be being torn
> down or already beyond EOF due to a lookup race...
> 
> As it is, holding the buffers locked does nothing to serialise loops
> that walk the perags without taking AG header buffer locks. This is
> the situation we might find ourselves in with lockless inode cache
> lookups through xfs_iget(), xfs_iwalk_ag() and
> xfs_reclaim_inodes_ag().
> 
> Functions like these doing direct perag walks via calls to
> xfs_perag_get{_tag}() need to be converted to hold active references
> to the perag so that the work these functions do is synchronised
> against filesystem shrink making the AGs go away. ANd by using
> active references, shrink can also synchronise against them simply
> by waiting for active references to drain. i.e. we don't need locks
> at all....
> 
> Active/passive reference counting results in a much simpler, less
> invasive and much easier to validate solution compared to taking
> locks and checking state after every lookup.
> 
> > > > +		xfs_buf_relse(agfbp);
> > > > +		if (error)
> > > > +			goto err_out;
> > > > +	}
> > > > +	xfs_log_force(mp, XFS_LOG_SYNC);
> > > 
> > > What does this do,
> > 
> > It just makes sure that no ongoing write transactions before tearing
> > down AGs. The reason it was here about AGFL drain, but since it's a
> > sync transaction, so I think it should be raised up.
> 
> xfs_log_force() does not do this. It just writes the committed
> metadata to the journal. It does not stop transactions that are in
> flight from running, nor stop new transactions from starting.
> 
> > > and why is it not needed before we try to free
> > > reservations and determine if the AG is empty?
> > 
> > Yeah, but it can only cause false nagative, anyway, I will raise it
> > up.
> > 
> > > 
> > > > +	/*
> > > > +	 * Wait for all busy extents to be freed, including completion of
> > > > +	 * any discard operation.
> > > > +	 */
> > > > +	xfs_extent_busy_wait_all(mp);
> > > > +	flush_workqueue(xfs_discard_wq);
> > > 
> > > Shouldn't this happen before we start trying to tear down the AGs?
> > 
> > May I ask what's your suggestted place? since the AGs are already
> > inactive here.
> 
> 
> See, this is where your approach to perag lookups is all
> inconsistent. Look at how xfs_extent_busy_wait_all() is actually
> implemented:
> 
> void
> xfs_extent_busy_wait_all(
>         struct xfs_mount        *mp)
> {
>         DEFINE_WAIT             (wait);
>         xfs_agnumber_t          agno;
> 
>         for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>                 struct xfs_perag *pag = xfs_perag_get(mp, agno);
> 
>                 do {
>                         prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
>                         if  (RB_EMPTY_ROOT(&pag->pagb_tree))
>                                 break;
>                         schedule();
>                 } while (1);
>                 finish_wait(&pag->pagb_wait, &wait);
> 
>                 xfs_perag_put(pag);
>         }
> }
> 
> Yup, it's a perag walk across the entire filesystem. What you are
> doing is creating certain places where xfs_perag_get() must ignore
> that perags are being torn down/inactivated, wherein other places it
> is absolutely necessary to pay attention to the inactive flag. ANd
> it's absolutely not clear what code falls under which rules.
> 
> What should happen here is a call to xfs_extent_busy_flush() after
> After we wait for all the active references to go to zero when
> inactivating the perag. And, similarly, we should probably also be
> flushing all the dirty metadata still in the AG before we start,
> too.
> 
> That is, we really need to bring the AG down to a fully idle,
> empty and stable state on disk before we start pulling anything in
> memory down.
> 
> > 
> > > 
> > > > +
> > > > +	/*
> > > > +	 * Also need to drain out all related cached buffers, at least,
> > > > +	 * in case of growfs back later (which uses uncached buffers.)
> > > > +	 */
> > > > +	xfs_ail_push_all_sync(mp->m_ail);
> > > > +	xfs_buftarg_drain(mp->m_ddev_targp);
> > > 
> > > Urk, no, this can livelock on active filesystems.
> > > 
> > > What you want to do is drain the per-ag buffer cache, not the global
> > > filesystem LRU. Given that, at this point, all the buffers still
> > > cached in the per-ag should have zero references to them, a walk of
> > > the rbtree taking a reference to each buffer, marking it stale and
> > > then calling xfs_buf_rele() on it should be sufficient to free all
> > > the buffers in the AG and release all the remaining passive
> > > references to the struct perag for the AG.
> > > 
> > 
> > I understand the issue, yeah, it'd be much better to use
> > xfs_buftarg_drain() here. Thanks for your suggestion about this.
> > 
> > > At this point, we can remove the perag from the m_perag radix tree,
> > > do the final teardown on it, and free if via call_rcu()....
> > 
> > I still think active/passive reference approach causes a lot of
> > random modification all over the whole XFS codebase since it
> > assumes current perag won't be removed/freed even reference count
> > reaches zero, adding new active reference counts in principle
> > sounds better yet a bit far away from the current XFS codebase
> > status.
> 
> I disagree. I think it's relatively trivial to switch over to active
> references in all the places it makes sense to do so right away as
> it greatly simplifies what needs to be done to make shrink safe.
> It still won't be perfect and need refinement especially around the
> allocator to pass a single active pag reference right through the
> allocation context, but even just doing the obvious conversions
> if much more complete and less invasive than the approach of using
> locks and state flags.
> 
> Rather wasting time on hypotheticals, the patch below is the last
> half hour of work I've done: it's a conversion to active reference
> counting for most of the perag lookups in XFS.  Those I didn't
> convert are commented as to why I didn't convert them.  I've used
> xfs_perag_grab() and xfs_perag_drop() as the API; "grab" is the same
> semantics as igrab() for inodes - if a reference can ben taken,
> it'll return the perag, if not it will return NULL.
> 
> It compiles and it's smoke testing right now - it's not firing off
> asserts at unmount, so that indicates that I the get/put and
> grab/drops are at least balanced.
> 
> It's pretty simple, and covers most of the lookup cases that run
> independently with no external protection against races with
> grow/shrink.
> 
> (yup, active reference also allows grow to initialise perags and
> insert them into the perag tree and then do metadata IO through the
> buffer cache whilst still preventing external code from accessing
> the AGs until grow is ready to allow it...)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: active perag reference counting

Wheee, a patch! :)

> From: Dave Chinner <dchinner@redhat.com>
> 
> For shrink to be able to offline AGs and logic that walks AGs to
> detect this safely. Also allows shrink to wait for code holding
> active references to drop those references.
> 
> Introduce xfs_perag_grab()/xfs_perag_drop() as the API for this
> active reference functionality.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.h |  6 +++--
>  fs/xfs/libxfs/xfs_alloc.c   | 21 ++++++++++-----
>  fs/xfs/libxfs/xfs_bmap.c    |  6 +++--
>  fs/xfs/libxfs/xfs_ialloc.c  | 22 ++++++++--------
>  fs/xfs/libxfs/xfs_sb.c      | 63 ++++++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_sb.h      | 15 +++++++----
>  fs/xfs/scrub/agheader.c     | 16 +++++++++---
>  fs/xfs/scrub/common.c       |  4 ++-
>  fs/xfs/scrub/fscounters.c   | 17 +++++++-----
>  fs/xfs/scrub/health.c       |  6 +++--
>  fs/xfs/scrub/repair.c       |  6 +++--
>  fs/xfs/xfs_buf.c            |  5 ++++
>  fs/xfs/xfs_discard.c        |  6 +++--
>  fs/xfs/xfs_extent_busy.c    | 30 ++++++++++++++++-----
>  fs/xfs/xfs_filestream.c     | 35 ++++++++++++++-----------
>  fs/xfs/xfs_fsops.c          | 16 ++++++++----
>  fs/xfs/xfs_health.c         |  6 +++--
>  fs/xfs/xfs_icache.c         | 41 ++++++++++++++++++-----------
>  fs/xfs/xfs_mount.c          | 10 +++++--
>  fs/xfs/xfs_mount.h          |  4 ++-
>  fs/xfs/xfs_reflink.c        |  6 +++--
>  fs/xfs/xfs_super.c          |  6 +++--
>  22 files changed, 249 insertions(+), 98 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index 8a8eb4bc48bb..c589a7551c3e 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -32,9 +32,11 @@ xfs_ag_resv_rmapbt_alloc(
>  	struct xfs_perag	*pag;
>  
>  	args.len = 1;
> -	pag = xfs_perag_get(mp, agno);
> +	pag = xfs_perag_grab(mp, agno);
> +	if (!pag)
> +		return;
>  	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  }
>  
>  #endif	/* __XFS_AG_RESV_H__ */
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index aaa19101bb2a..fe79f962d1e9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3135,7 +3135,11 @@ xfs_alloc_vextent(
>  		 * These three force us into a single a.g.
>  		 */
>  		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
> -		args->pag = xfs_perag_get(mp, args->agno);
> +		args->pag = xfs_perag_grab(mp, args->agno);
> +		if (!args->pag) {
> +			error = -ENOSPC;
> +			goto error0;
> +		}
>  		error = xfs_alloc_fix_freelist(args, 0);
>  		if (error) {
>  			trace_xfs_alloc_vextent_nofix(args);
> @@ -3188,7 +3192,9 @@ xfs_alloc_vextent(
>  		 * trylock set, second time without.
>  		 */
>  		for (;;) {
> -			args->pag = xfs_perag_get(mp, args->agno);
> +			args->pag = xfs_perag_grab(mp, args->agno);
> +			if (!args->pag)
> +				goto next_ag;
>  			error = xfs_alloc_fix_freelist(args, flags);
>  			if (error) {
>  				trace_xfs_alloc_vextent_nofix(args);
> @@ -3218,6 +3224,7 @@ xfs_alloc_vextent(
>  			* sagno. Otherwise, we may end up with out-of-order
>  			* locking of AGF, which might cause deadlock.
>  			*/
> +next_ag:
>  			if (++(args->agno) == mp->m_sb.sb_agcount) {
>  				if (args->tp->t_firstblock != NULLFSBLOCK)
>  					args->agno = sagno;
> @@ -3242,7 +3249,7 @@ xfs_alloc_vextent(
>  					args->type = XFS_ALLOCTYPE_NEAR_BNO;
>  				}
>  			}
> -			xfs_perag_put(args->pag);
> +			xfs_perag_drop(args->pag);
>  		}
>  		if (bump_rotor) {
>  			if (args->agno == sagno)
> @@ -3270,10 +3277,10 @@ xfs_alloc_vextent(
>  #endif
>  
>  	}
> -	xfs_perag_put(args->pag);
> +	xfs_perag_drop(args->pag);
>  	return 0;
>  error0:
> -	xfs_perag_put(args->pag);
> +	xfs_perag_drop(args->pag);
>  	return error;
>  }
>  
> @@ -3299,7 +3306,7 @@ xfs_free_extent_fix_freelist(
>  	if (args.agno >= args.mp->m_sb.sb_agcount)
>  		return -EFSCORRUPTED;
>  
> -	args.pag = xfs_perag_get(args.mp, args.agno);
> +	args.pag = xfs_perag_grab(args.mp, args.agno);
>  	ASSERT(args.pag);
>  
>  	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
> @@ -3308,7 +3315,7 @@ xfs_free_extent_fix_freelist(
>  
>  	*agbp = args.agbp;
>  out:
> -	xfs_perag_put(args.pag);
> +	xfs_perag_drop(args.pag);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 402ecd610360..fc24a4227311 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3283,7 +3283,9 @@ xfs_bmap_longest_free_extent(
>  	xfs_extlen_t		longest;
>  	int			error = 0;
>  
> -	pag = xfs_perag_get(mp, ag);
> +	pag = xfs_perag_grab(mp, ag);
> +	if (!pag)
> +		return -ENOSPC;
>  	if (!pag->pagf_init) {
>  		error = xfs_alloc_pagf_init(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK);
>  		if (error) {
> @@ -3303,7 +3305,7 @@ xfs_bmap_longest_free_extent(
>  		*blen = longest;
>  
>  out:
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index eefdb518fe64..ff1059192f94 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -968,8 +968,8 @@ xfs_ialloc_ag_select(
>  	agno = pagno;
>  	flags = XFS_ALLOC_FLAG_TRYLOCK;
>  	for (;;) {
> -		pag = xfs_perag_get(mp, agno);
> -		if (!pag->pagi_inodeok) {
> +		pag = xfs_perag_grab(mp, agno);
> +		if (!pag || !pag->pagi_inodeok) {
>  			xfs_ialloc_next_ag(mp);
>  			goto nextag;
>  		}
> @@ -981,7 +981,7 @@ xfs_ialloc_ag_select(
>  		}
>  
>  		if (pag->pagi_freecount) {
> -			xfs_perag_put(pag);
> +			xfs_perag_drop(pag);
>  			return agno;
>  		}
>  
> @@ -1016,11 +1016,11 @@ xfs_ialloc_ag_select(
>  
>  		if (pag->pagf_freeblks >= needspace + ineed &&
>  		    longest >= ineed) {
> -			xfs_perag_put(pag);
> +			xfs_perag_drop(pag);
>  			return agno;
>  		}
>  nextag:
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  		/*
>  		 * No point in iterating over the rest, if we're shutting
>  		 * down.
> @@ -1775,8 +1775,8 @@ xfs_dialloc_select_ag(
>  	 */
>  	agno = start_agno;
>  	for (;;) {
> -		pag = xfs_perag_get(mp, agno);
> -		if (!pag->pagi_inodeok) {
> +		pag = xfs_perag_grab(mp, agno);
> +		if (!pag || !pag->pagi_inodeok) {
>  			xfs_ialloc_next_ag(mp);
>  			goto nextag;
>  		}
> @@ -1802,7 +1802,7 @@ xfs_dialloc_select_ag(
>  			break;
>  
>  		if (pag->pagi_freecount) {
> -			xfs_perag_put(pag);
> +			xfs_perag_drop(pag);
>  			goto found_ag;
>  		}
>  
> @@ -1825,7 +1825,7 @@ xfs_dialloc_select_ag(
>  			 * allocate one of the new inodes.
>  			 */
>  			ASSERT(pag->pagi_freecount > 0);
> -			xfs_perag_put(pag);
> +			xfs_perag_drop(pag);
>  
>  			error = xfs_dialloc_roll(tpp, agbp);
>  			if (error) {
> @@ -1838,14 +1838,14 @@ xfs_dialloc_select_ag(
>  nextag_relse_buffer:
>  		xfs_trans_brelse(*tpp, agbp);
>  nextag:
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  		if (++agno == mp->m_sb.sb_agcount)
>  			agno = 0;
>  		if (agno == start_agno)
>  			return noroom ? -ENOSPC : 0;
>  	}
>  
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  	return error;
>  found_ag:
>  	*IO_agbp = agbp;
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 60e6d255e5e2..ce08473c5b75 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -31,9 +31,10 @@
>   */
>  
>  /*
> - * Reference counting access wrappers to the perag structures.
> - * Because we never free per-ag structures, the only thing we
> - * have to protect against changes is the tree structure itself.
> + * Passive reference counting access wrappers to the perag structures.  If the
> + * per-ag structure is to be freed, the freeing code is responsible for cleaning
> + * up objects with passive references before freeing the structure. This is
> + * things like cached buffers.
>   */
>  struct xfs_perag *
>  xfs_perag_get(
> @@ -91,6 +92,62 @@ xfs_perag_put(
>  	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
>  }
>  
> +/*
> + * Active references for perag structures. This is for short term access to the
> + * per ag structures for walking trees or accessing state. If an AG is being
> + * shrunk or is offline, then this will fail to find that AG and return NULL
> + * instead.
> + */
> +struct xfs_perag *
> +xfs_perag_grab(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_perag	*pag;
> +
> +	rcu_read_lock();
> +	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> +	if (pag) {
> +		if (!atomic_inc_not_zero(&pag->pag_active_ref))
> +			pag = NULL;
> +	}
> +	rcu_read_unlock();
> +	return pag;
> +}
> +
> +/*
> + * search from @first to find the next perag with the given tag set.
> + */
> +struct xfs_perag *
> +xfs_perag_grab_tag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		first,
> +	int			tag)
> +{
> +	struct xfs_perag	*pag;
> +	int			found;
> +
> +	rcu_read_lock();
> +	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> +					(void **)&pag, first, 1, tag);
> +	if (found <= 0) {
> +		rcu_read_unlock();
> +		return NULL;
> +	}
> +	if (!atomic_inc_not_zero(&pag->pag_active_ref))
> +		pag = NULL;
> +	rcu_read_unlock();
> +	return pag;
> +}
> +
> +void
> +xfs_perag_drop(

Naming bikeshed: should this be xfs_perag_rele to match igrab/irele?

> +	struct xfs_perag	*pag)
> +{
> +	if (atomic_dec_and_test(&pag->pag_active_ref))
> +		wake_up(&pag->pag_active_wq);
> +}
> +
>  /* Check all the superblock fields we care about when reading one in. */
>  STATIC int
>  xfs_validate_sb_read(
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index f79f9dc632b6..bd3a0b910395 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -16,11 +16,16 @@ struct xfs_perag;
>  /*
>   * perag get/put wrappers for ref counting
>   */
> -extern struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
> -extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
> -					   int tag);
> -extern void	xfs_perag_put(struct xfs_perag *pag);
> -extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
> +int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
> +struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
> +struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
> +				   int tag);
> +void	xfs_perag_put(struct xfs_perag *pag);
> +
> +struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
> +struct xfs_perag *xfs_perag_grab_tag(struct xfs_mount *, xfs_agnumber_t,
> +				   int tag);
> +void	xfs_perag_drop(struct xfs_perag *pag);
>  
>  extern void	xfs_log_sb(struct xfs_trans *tp);
>  extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 749faa17f8e2..a08f4253d5da 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -576,14 +576,18 @@ xchk_agf(
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  
>  	/* Do the incore counters match? */
> -	pag = xfs_perag_get(mp, agno);
> +	pag = xfs_perag_grab(mp, agno);
> +	if (!pag) {
> +		error = -ENOSPC;
> +		goto out;

This should be ENOENT, since that's the error code that scrub uses to
indicate that the resource doesn't exist and can't be checked.

> +	}
>  	if (pag->pagf_freeblks != be32_to_cpu(agf->agf_freeblks))
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  	if (pag->pagf_flcount != be32_to_cpu(agf->agf_flcount))
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  	if (pag->pagf_btreeblks != be32_to_cpu(agf->agf_btreeblks))
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  
>  	xchk_agf_xref(sc);
>  out:
> @@ -902,12 +906,16 @@ xchk_agi(
>  		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  
>  	/* Do the incore counters match? */
> -	pag = xfs_perag_get(mp, agno);
> +	pag = xfs_perag_grab(mp, agno);
> +	if (!pag) {
> +		error = -ENOSPC;

Same here.

> +		goto out;
> +	}
>  	if (pag->pagi_count != be32_to_cpu(agi->agi_count))
>  		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  	if (pag->pagi_freecount != be32_to_cpu(agi->agi_freecount))
>  		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  
>  	xchk_agi_xref(sc);
>  out:
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index aa874607618a..d2e3cf63d237 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -554,8 +554,10 @@ xchk_ag_init(
>  }
>  
>  /*
> - * Grab the per-ag structure if we haven't already gotten it.  Teardown of the
> + * Get the per-ag structure if we haven't already gotten it.  Teardown of the
>   * xchk_ag will release it for us.
> + *
> + * XXX: does this need to be a grab?

If owning the buffer lock on the AGI/AGF isn't sufficient to guarantee
that we can get an active reference to the perag structure, then yes.

>   */
>  void
>  xchk_perag_get(
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 7b4386c78fbf..3bb23b38874f 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -71,9 +71,9 @@ xchk_fscount_warmup(
>  	int			error = 0;
>  
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xfs_perag_get(mp, agno);
> +		pag = xfs_perag_grab(mp, agno);
>  
> -		if (pag->pagi_init && pag->pagf_init)
> +		if (!pag || (pag->pagi_init && pag->pagf_init))
>  			goto next_loop_perag;
>  
>  		/* Lock both AG headers. */
> @@ -97,7 +97,8 @@ xchk_fscount_warmup(
>  		xfs_buf_relse(agi_bp);
>  		agi_bp = NULL;
>  next_loop_perag:
> -		xfs_perag_put(pag);
> +		if (pag)
> +			xfs_perag_drop(pag);
>  		pag = NULL;
>  		error = 0;
>  
> @@ -110,7 +111,7 @@ xchk_fscount_warmup(
>  	if (agi_bp)
>  		xfs_buf_relse(agi_bp);
>  	if (pag)
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  	return error;
>  }
>  
> @@ -167,11 +168,13 @@ xchk_fscount_aggregate_agcounts(
>  	fsc->fdblocks = 0;
>  
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xfs_perag_get(mp, agno);
> +		pag = xfs_perag_grab(mp, agno);
> +		if (!pag)
> +			return -ENOSPC;

Hmmm, not sure what the proper errno is for this case.  If !pag, we know
the AG is being torn down, but do we know if the free space counters
have been updated?

IOWS, should we be serializing this scrubber against shrink operations?
The usual idiom in scrub is that you'd return EDEADLOCK here, and then
xfs_scrub_metadata will re-setup and re-run with the TRY_HARDER flag set
so that xchk_setup_fscounters can lock the world before trying again.

--D

>  
>  		/* This somehow got unset since the warmup? */
>  		if (!pag->pagi_init || !pag->pagf_init) {
> -			xfs_perag_put(pag);
> +			xfs_perag_drop(pag);
>  			return -EFSCORRUPTED;
>  		}
>  
> @@ -191,7 +194,7 @@ xchk_fscount_aggregate_agcounts(
>  		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
>  		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
>  
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  
>  		if (xchk_should_terminate(sc, &error))
>  			break;
> diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> index 3de59b5c2ce6..adf1596bc663 100644
> --- a/fs/xfs/scrub/health.c
> +++ b/fs/xfs/scrub/health.c
> @@ -137,12 +137,14 @@ xchk_update_health(
>  				   XFS_SCRUB_OFLAG_XCORRUPT));
>  	switch (type_to_health_flag[sc->sm->sm_type].group) {
>  	case XHG_AG:
> -		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
> +		pag = xfs_perag_grab(sc->mp, sc->sm->sm_agno);
> +		if (!pag)
> +			break;
>  		if (bad)
>  			xfs_ag_mark_sick(pag, sc->sick_mask);
>  		else
>  			xfs_ag_mark_healthy(pag, sc->sick_mask);
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  		break;
>  	case XHG_INO:
>  		if (!sc->ip)
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index c2857d854c83..25f7a112bb96 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -191,7 +191,9 @@ xrep_calc_ag_resblks(
>  	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
>  		return 0;
>  
> -	pag = xfs_perag_get(mp, sm->sm_agno);
> +	pag = xfs_perag_grab(mp, sm->sm_agno);
> +	if (!pag)
> +		return 0;
>  	if (pag->pagi_init) {
>  		/* Use in-core icount if possible. */
>  		icount = pag->pagi_count;
> @@ -218,7 +220,7 @@ xrep_calc_ag_resblks(
>  		usedlen = aglen - freelen;
>  		xfs_buf_relse(bp);
>  	}
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  
>  	/* If the icount is impossible, make some worst-case assumptions. */
>  	if (icount == NULLAGINO ||
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 37a1d12762d8..1f48007572e6 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -617,6 +617,11 @@ xfs_buf_find(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	/*
> +	 * Get a passive reference to the perag for the buffer. This needs to
> +	 * work even when the AG is offline or in the process of being removed
> +	 * by shrink, so active references cannot be used here.
> +	 */
>  	pag = xfs_perag_get(btp->bt_mount,
>  			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
>  
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index f979d0d7e6cd..9c7a15952bbe 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -36,7 +36,9 @@ xfs_trim_extents(
>  	int			error;
>  	int			i;
>  
> -	pag = xfs_perag_get(mp, agno);
> +	pag = xfs_perag_grab(mp, agno);
> +	if (!pag)
> +		return -ENOSPC;
>  
>  	/*
>  	 * Force out the log.  This means any transactions that might have freed
> @@ -134,7 +136,7 @@ xfs_trim_extents(
>  	xfs_btree_del_cursor(cur, error);
>  	xfs_buf_relse(agbp);
>  out_put_perag:
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index ef17c1f6db32..db68a24eda49 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -43,7 +43,11 @@ xfs_extent_busy_insert(
>  	/* trace before insert to be able to see failed inserts */
>  	trace_xfs_extent_busy(tp->t_mountp, agno, bno, len);
>  
> -	pag = xfs_perag_get(tp->t_mountp, new->agno);
> +	pag = xfs_perag_grab(tp->t_mountp, new->agno);
> +	if (!pag) {
> +		kfree(new);
> +		return;
> +	}
>  	spin_lock(&pag->pagb_lock);
>  	rbp = &pag->pagb_tree.rb_node;
>  	while (*rbp) {
> @@ -66,7 +70,7 @@ xfs_extent_busy_insert(
>  
>  	list_add(&new->list, &tp->t_busy);
>  	spin_unlock(&pag->pagb_lock);
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  }
>  
>  /*
> @@ -90,6 +94,11 @@ xfs_extent_busy_search(
>  	struct xfs_extent_busy	*busyp;
>  	int			match = 0;
>  
> +	/*
> +	 * passive reference is fine here as we are deep inside the allocator
> +	 * with AGF buffers locked. Should really be passed the pag from the
> +	 * allocation args.
> +	 */
>  	pag = xfs_perag_get(mp, agno);
>  	spin_lock(&pag->pagb_lock);
>  
> @@ -291,6 +300,11 @@ xfs_extent_busy_reuse(
>  
>  	ASSERT(flen > 0);
>  
> +	/*
> +	 * Passive reference is fine here as we are deep inside the allocator
> +	 * with AGF buffers locked. Should really be passed the pag from the
> +	 * allocation args.
> +	 */
>  	pag = xfs_perag_get(mp, agno);
>  	spin_lock(&pag->pagb_lock);
>  restart:
> @@ -533,7 +547,7 @@ xfs_extent_busy_put_pag(
>  	}
>  
>  	spin_unlock(&pag->pagb_lock);
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  }
>  
>  /*
> @@ -557,7 +571,8 @@ xfs_extent_busy_clear(
>  			if (pag)
>  				xfs_extent_busy_put_pag(pag, wakeup);
>  			agno = busyp->agno;
> -			pag = xfs_perag_get(mp, agno);
> +			pag = xfs_perag_grab(mp, agno);
> +			ASSERT(pag);
>  			spin_lock(&pag->pagb_lock);
>  			wakeup = false;
>  		}
> @@ -609,7 +624,10 @@ xfs_extent_busy_wait_all(
>  	xfs_agnumber_t		agno;
>  
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		struct xfs_perag *pag = xfs_perag_get(mp, agno);
> +		struct xfs_perag *pag = xfs_perag_grab(mp, agno);
> +
> +		if (!pag)
> +			continue;
>  
>  		do {
>  			prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
> @@ -619,7 +637,7 @@ xfs_extent_busy_wait_all(
>  		} while (1);
>  		finish_wait(&pag->pagb_wait, &wait);
>  
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index db23e455eb91..4785bfbe353b 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -41,11 +41,12 @@ xfs_filestream_peek_ag(
>  	xfs_agnumber_t	agno)
>  {
>  	struct xfs_perag *pag;
> -	int		ret;
> +	int		ret = NULLAGNUMBER;
>  
> -	pag = xfs_perag_get(mp, agno);
> -	ret = atomic_read(&pag->pagf_fstrms);
> -	xfs_perag_put(pag);
> +	pag = xfs_perag_grab(mp, agno);
> +	if (pag)
> +		ret = atomic_read(&pag->pagf_fstrms);
> +	xfs_perag_drop(pag);
>  	return ret;
>  }
>  
> @@ -55,11 +56,12 @@ xfs_filestream_get_ag(
>  	xfs_agnumber_t	agno)
>  {
>  	struct xfs_perag *pag;
> -	int		ret;
> +	int		ret = NULLAGNUMBER;
>  
> -	pag = xfs_perag_get(mp, agno);
> -	ret = atomic_inc_return(&pag->pagf_fstrms);
> -	xfs_perag_put(pag);
> +	pag = xfs_perag_grab(mp, agno);
> +	if (pag)
> +		ret = atomic_inc_return(&pag->pagf_fstrms);
> +	xfs_perag_drop(pag);
>  	return ret;
>  }
>  
> @@ -70,9 +72,10 @@ xfs_filestream_put_ag(
>  {
>  	struct xfs_perag *pag;
>  
> -	pag = xfs_perag_get(mp, agno);
> -	atomic_dec(&pag->pagf_fstrms);
> -	xfs_perag_put(pag);
> +	pag = xfs_perag_grab(mp, agno);
> +	if (pag)
> +		atomic_dec(&pag->pagf_fstrms);
> +	xfs_perag_drop(pag);
>  }
>  
>  static void
> @@ -123,12 +126,14 @@ xfs_filestream_pick_ag(
>  	for (nscan = 0; 1; nscan++) {
>  		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
>  
> -		pag = xfs_perag_get(mp, ag);
> +		pag = xfs_perag_grab(mp, ag);
> +		if (!pag)
> +			continue;
>  
>  		if (!pag->pagf_init) {
>  			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
>  			if (err) {
> -				xfs_perag_put(pag);
> +				xfs_perag_drop(pag);
>  				if (err != -EAGAIN)
>  					return err;
>  				/* Couldn't lock the AGF, skip this AG. */
> @@ -163,7 +168,7 @@ xfs_filestream_pick_ag(
>  
>  			/* Break out, retaining the reference on the AG. */
>  			free = pag->pagf_freeblks;
> -			xfs_perag_put(pag);
> +			xfs_perag_drop(pag);
>  			*agp = ag;
>  			break;
>  		}
> @@ -171,7 +176,7 @@ xfs_filestream_pick_ag(
>  		/* Drop the reference on this AG, it's not usable. */
>  		xfs_filestream_put_ag(mp, ag);
>  next_ag:
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  		/* Move to the next AG, wrapping to AG 0 if necessary. */
>  		if (++ag >= mp->m_sb.sb_agcount)
>  			ag = 0;
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index b33c894b6cf3..a72aa8a8774c 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -196,7 +196,9 @@ xfs_growfs_data_private(
>  	if (delta > 0) {
>  		/*
>  		 * If we expanded the last AG, free the per-AG reservation
> -		 * so we can reinitialize it with the new size.
> +		 * so we can reinitialize it with the new size. Passive
> +		 * reference to perag is fine because we know the AG exists
> +		 * right now.
>  		 */
>  		if (lastag_extended) {
>  			struct xfs_perag	*pag;
> @@ -579,9 +581,11 @@ xfs_fs_reserve_ag_blocks(
>  
>  	mp->m_finobt_nores = false;
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xfs_perag_get(mp, agno);
> +		pag = xfs_perag_grab(mp, agno);
> +		if (!pag)
> +			continue;
>  		err2 = xfs_ag_resv_init(pag, NULL);
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  		if (err2 && !error)
>  			error = err2;
>  	}
> @@ -608,9 +612,11 @@ xfs_fs_unreserve_ag_blocks(
>  	int			err2;
>  
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xfs_perag_get(mp, agno);
> +		pag = xfs_perag_grab(mp, agno);
> +		if (!pag)
> +			continue;
>  		err2 = xfs_ag_resv_free(pag);
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  		if (err2 && !error)
>  			error = err2;
>  	}
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 8e0cb05a7142..c48f7b29a46b 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -35,13 +35,15 @@ xfs_health_unmount(
>  
>  	/* Measure AG corruption levels. */
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xfs_perag_get(mp, agno);
> +		pag = xfs_perag_grab(mp, agno);
> +		if (!pag)
> +			continue;
>  		xfs_ag_measure_sickness(pag, &sick, &checked);
>  		if (sick) {
>  			trace_xfs_ag_unfixed_corruption(mp, agno, sick);
>  			warn = true;
>  		}
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  	}
>  
>  	/* Measure realtime volume corruption levels. */
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 3c81daca0e9a..c794b93b8fbf 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -200,8 +200,9 @@ xfs_perag_clear_reclaim_tag(
>  
>  /*
>   * We set the inode flag atomically with the radix tree tag.
> - * Once we get tag lookups on the radix tree, this inode flag
> - * can go away.
> + *
> + * Passive perag lookups are OK here be we are guaranteed the existence of the
> + * perag at least until the inode is fully reclaimed.
>   */
>  void
>  xfs_inode_set_reclaim_tag(
> @@ -631,7 +632,9 @@ xfs_iget(
>  	XFS_STATS_INC(mp, xs_ig_attempts);
>  
>  	/* get the perag structure and ensure that it's inode capable */
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
> +	pag = xfs_perag_grab(mp, XFS_INO_TO_AGNO(mp, ino));
> +	if (!pag)
> +		return -EINVAL;
>  	agino = XFS_INO_TO_AGINO(mp, ino);
>  
>  again:
> @@ -656,7 +659,7 @@ xfs_iget(
>  		if (error)
>  			goto out_error_or_again;
>  	}
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  
>  	*ipp = ip;
>  
> @@ -673,7 +676,7 @@ xfs_iget(
>  		delay(1);
>  		goto again;
>  	}
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  	return error;
>  }
>  
> @@ -882,8 +885,8 @@ xfs_inode_walk_get_perag(
>  	int			tag)
>  {
>  	if (tag == XFS_ICI_NO_TAG)
> -		return xfs_perag_get(mp, agno);
> -	return xfs_perag_get_tag(mp, agno, tag);
> +		return xfs_perag_grab(mp, agno);
> +	return xfs_perag_grab_tag(mp, agno, tag);
>  }
>  
>  /*
> @@ -907,7 +910,7 @@ xfs_inode_walk(
>  	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
>  		ag = pag->pag_agno + 1;
>  		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  		if (error) {
>  			last_error = error;
>  			if (error == -EFSCORRUPTED)
> @@ -1063,7 +1066,7 @@ xfs_reclaim_inodes_ag(
>  	struct xfs_perag	*pag;
>  	xfs_agnumber_t		ag = 0;
>  
> -	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
> +	while ((pag = xfs_perag_grab_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
>  		unsigned long	first_index = 0;
>  		int		done = 0;
>  		int		nr_found = 0;
> @@ -1134,7 +1137,7 @@ xfs_reclaim_inodes_ag(
>  		if (done)
>  			first_index = 0;
>  		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  	}
>  }
>  
> @@ -1182,10 +1185,10 @@ xfs_reclaim_inodes_count(
>  	xfs_agnumber_t		ag = 0;
>  	int			reclaimable = 0;
>  
> -	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
> +	while ((pag = xfs_perag_grab_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
>  		ag = pag->pag_agno + 1;
>  		reclaimable += pag->pag_ici_reclaimable;
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  	}
>  	return reclaimable;
>  }
> @@ -1363,6 +1366,10 @@ xfs_blockgc_set_iflag(
>  	ip->i_flags |= iflag;
>  	spin_unlock(&ip->i_flags_lock);
>  
> +	/*
> +	 * Passive reference is fine because inode existence guarantees perag is
> +	 * accessible.
> +	 */
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  	spin_lock(&pag->pag_ici_lock);
>  
> @@ -1416,6 +1423,10 @@ xfs_blockgc_clear_iflag(
>  	if (!clear_tag)
>  		return;
>  
> +	/*
> +	 * Passive reference is fine because inode existence guarantees perag is
> +	 * accessible.
> +	 */
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  	spin_lock(&pag->pag_ici_lock);
>  
> @@ -1555,11 +1566,11 @@ xfs_inode_clear_cowblocks_tag(
>  }
>  
>  #define for_each_perag_tag(mp, next_agno, pag, tag) \
> -	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
> +	for ((next_agno) = 0, (pag) = xfs_perag_grab_tag((mp), 0, (tag)); \
>  		(pag) != NULL; \
>  		(next_agno) = (pag)->pag_agno + 1, \
> -		xfs_perag_put(pag), \
> -		(pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
> +		xfs_perag_drop(pag), \
> +		(pag) = xfs_perag_grab_tag((mp), (next_agno), (tag)))
>  
>  
>  /* Disable post-EOF and CoW block auto-reclamation. */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index cb1e2c4702c3..b8d19df63790 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -127,6 +127,7 @@ __xfs_free_perag(
>  	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
>  
>  	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
> +	ASSERT(atomic_read(&pag->pag_active_ref) == 0);
>  	ASSERT(atomic_read(&pag->pag_ref) == 0);
>  	kmem_free(pag);
>  }
> @@ -150,6 +151,8 @@ xfs_free_perag(
>  		cancel_delayed_work_sync(&pag->pag_blockgc_work);
>  		xfs_iunlink_destroy(pag);
>  		xfs_buf_hash_destroy(pag);
> +		/* drop the mount's active reference */
> +		xfs_perag_drop(pag);
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
>  	}
>  }
> @@ -189,9 +192,9 @@ xfs_initialize_perag(
>  	 * AGs we don't find ready for initialisation.
>  	 */
>  	for (index = 0; index < agcount; index++) {
> -		pag = xfs_perag_get(mp, index);
> +		pag = xfs_perag_grab(mp, index);
>  		if (pag) {
> -			xfs_perag_put(pag);
> +			xfs_perag_drop(pag);
>  			continue;
>  		}
>  
> @@ -202,6 +205,9 @@ xfs_initialize_perag(
>  		}
>  		pag->pag_agno = index;
>  		pag->pag_mount = mp;
> +		/* active ref owned by mount indicates AG is online */
> +		atomic_set(&pag->pag_active_ref, 1);
> +		init_waitqueue_head(&pag->pag_active_wq);
>  		spin_lock_init(&pag->pag_ici_lock);
>  		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
>  		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 81829d19596e..f41abace8e34 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -308,7 +308,9 @@ struct xfs_ag_resv {
>  typedef struct xfs_perag {
>  	struct xfs_mount *pag_mount;	/* owner filesystem */
>  	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
> -	atomic_t	pag_ref;	/* perag reference count */
> +	atomic_t	pag_ref;	/* passive reference count */
> +	atomic_t	pag_active_ref;	/* active reference count */
> +	wait_queue_head_t pag_active_wq;/* woken active_ref falls to zero */
>  	char		pagf_init;	/* this agf's entry is initialized */
>  	char		pagi_init;	/* this agi's entry is initialized */
>  	char		pagf_metadata;	/* the agf is preferred to be metadata */
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 323506a6b339..932ce6238096 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -967,11 +967,13 @@ xfs_reflink_ag_has_free_space(
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return 0;
>  
> -	pag = xfs_perag_get(mp, agno);
> +	pag = xfs_perag_grab(mp, agno);
> +	if (!pag)
> +		return -ENOSPC;
>  	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_RMAPBT) ||
>  	    xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA))
>  		error = -ENOSPC;
> -	xfs_perag_put(pag);
> +	xfs_perag_drop(pag);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a2dab05332ac..4e6bfdbfcf5b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -288,7 +288,9 @@ xfs_set_inode_alloc(
>  
>  		ino = XFS_AGINO_TO_INO(mp, index, agino);
>  
> -		pag = xfs_perag_get(mp, index);
> +		pag = xfs_perag_grab(mp, index);
> +		if (!pag)
> +			continue;
>  
>  		if (mp->m_flags & XFS_MOUNT_32BITINODES) {
>  			if (ino > XFS_MAXINUMBER_32) {
> @@ -307,7 +309,7 @@ xfs_set_inode_alloc(
>  			pag->pagf_metadata = 0;
>  		}
>  
> -		xfs_perag_put(pag);
> +		xfs_perag_drop(pag);
>  	}
>  
>  	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
