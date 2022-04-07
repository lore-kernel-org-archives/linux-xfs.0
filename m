Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DA5C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 23:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiDGXri (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 19:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbiDGXre (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 19:47:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682D614FFFC
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 16:45:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3E1BB829B0
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 23:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8005CC385A0;
        Thu,  7 Apr 2022 23:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649375128;
        bh=9qvf2kVSUTAEfXo7e1y+KvwRBJ9GkIzZVA4SfrzK9yQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HTYzrOPMDJoYQroOiRISUq/sDCAtE+ohg1OM+sfWdcJYefuaWzOl0aN/gJaCX5zso
         Zr5ncftsIUXD6KL20YTwCRLu+zgtj/bddTLskkpLyzow40bykazc35xD26VdwQiF2k
         mnRx7+cTL4vfCl4YNFXSCmMhz+VyA4BCRd2hIiyyzrjexN7HsVyGFSaKewNN3GImxH
         jEjLVaBfjWbbK2OWPeTCB/rE07LwYtZflcmSQW5KYn2hs1ZNi99VkXapzzaaqYG9b9
         RB0L1KdvrG3KU52PDcam1SuBmyVK1BwiRV0cLcU9Vf+uA7TqtCqOAodjl75fadHA/C
         mXW+hC8OplLEg==
Date:   Thu, 7 Apr 2022 16:45:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: use a separate frextents counter for rt extent
 reservations
Message-ID: <20220407234528.GD27690@magnolia>
References: <164936441107.457511.6646449842358518774.stgit@magnolia>
 <164936442248.457511.4389675360381809144.stgit@magnolia>
 <20220407231725.GM1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407231725.GM1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 08, 2022 at 09:17:25AM +1000, Dave Chinner wrote:
> On Thu, Apr 07, 2022 at 01:47:02PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > As mentioned in the previous commit, the kernel misuses sb_frextents in
> > the incore mount to reflect both incore reservations made by running
> > transactions as well as the actual count of free rt extents on disk.
> > This results in the superblock being written to the log with an
> > underestimate of the number of rt extents that are marked free in the
> > rtbitmap.
> > 
> > Teaching XFS to recompute frextents after log recovery avoids
> > operational problems in the current mount, but it doesn't solve the
> > problem of us writing undercounted frextents which are then recovered by
> > an older kernel that doesn't have that fix.
> > 
> > Create an incore percpu counter to mirror the ondisk frextents.  This
> > new counter will track transaction reservations and the only time we
> > will touch the incore super counter (i.e the one that gets logged) is
> > when those transactions commit updates to the rt bitmap.  This is in
> > contrast to the lazysbcount counters (e.g. fdblocks), where we know that
> > log recovery will always fix any incorrect counter that we log.
> > As a bonus, we only take m_sb_lock at transaction commit time.
> 
> Again, the concept looks fine as does most of the code. Some
> comments on the implementation below.
> 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index c5f153c3693f..d5463728c305 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1183,17 +1183,37 @@ xfs_mod_frextents(
> >  	struct xfs_mount	*mp,
> >  	int64_t			delta)
> >  {
> > -	int64_t			lcounter;
> > -	int			ret = 0;
> > +	int			batch;
> >  
> > -	spin_lock(&mp->m_sb_lock);
> > -	lcounter = mp->m_sb.sb_frextents + delta;
> > -	if (lcounter < 0)
> > -		ret = -ENOSPC;
> > +	if (delta > 0) {
> > +		percpu_counter_add(&mp->m_frextents, delta);
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * Taking blocks away, need to be more accurate the closer we
> > +	 * are to zero.
> > +	 *
> > +	 * If the counter has a value of less than 2 * max batch size,
> > +	 * then make everything serialise as we are real close to
> > +	 * ENOSPC.
> > +	 */
> > +	if (__percpu_counter_compare(&mp->m_frextents, 2 * XFS_FDBLOCKS_BATCH,
> > +				     XFS_FDBLOCKS_BATCH) < 0)
> > +		batch = 1;
> >  	else
> > -		mp->m_sb.sb_frextents = lcounter;
> > -	spin_unlock(&mp->m_sb_lock);
> > -	return ret;
> > +		batch = XFS_FDBLOCKS_BATCH;
> > +
> > +	percpu_counter_add_batch(&mp->m_frextents, delta, batch);
> > +	if (__percpu_counter_compare(&mp->m_frextents, 0,
> > +				     XFS_FDBLOCKS_BATCH) >= 0) {
> > +		/* we had space! */
> > +		return 0;
> > +	}
> > +
> > +	/* oops, negative free space, put that back! */
> > +	percpu_counter_add(&mp->m_frextents, -delta);
> > +	return -ENOSPC;
> >  }
> 
> Ok, so this looks like a copy-pasta of xfs_mod_fdblocks() with the
> reservation pool stuff stripped. I'd kinda prefer to factor
> xfs_mod_fdblocks() so that we aren't blowing out the instruction
> cache footprint on this hot path - we're frequently modifying
> both RT and fd block counts in the same transaction, so having them
> run the same code would be good.
> 
> Something like:
> 
> int
> xfs_mod_blocks(
> 	struct xfs_mount	*mp,
> 	struct pcp_counter	*pccnt,
> 	int64_t			delta,
> 	bool			use_resv_pool,
> 	bool			rsvd)
> {
> 	int64_t                 lcounter;
> 	long long               res_used;
> 	s32                     batch;
> 	uint64_t                set_aside = 0;
> 
> 	if (delta > 0) {
> 	       /*
> 		* If the reserve pool is depleted, put blocks back into it
> 		* first. Most of the time the pool is full.
> 		*/
> 	       if (likely(!use_resv_pool || mp->m_resblks == mp->m_resblks_avail)) {
> 		       percpu_counter_add(pccnt, delta);
> 		       return 0;
> 	       }
> 
> 	       spin_lock(&mp->m_sb_lock);
> 	       res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
> 
> 	       if (res_used > delta) {
> 		       mp->m_resblks_avail += delta;
> 	       } else {
> 		       delta -= res_used;
> 		       mp->m_resblks_avail = mp->m_resblks;
> 		       percpu_counter_add(&mp->m_fdblocks, delta);
> 	       }
> 	       spin_unlock(&mp->m_sb_lock);
> 	       return 0;
> 	}
> 
> 	/*
> 	* Taking blocks away, need to be more accurate the closer we
> 	* are to zero.
> 	*
> 	* If the counter has a value of less than 2 * max batch size,
> 	* then make everything serialise as we are real close to
> 	* ENOSPC.
> 	*/
> 	if (__percpu_counter_compare(pccnt, 2 * XFS_FDBLOCKS_BATCH,
> 				    XFS_FDBLOCKS_BATCH) < 0)
> 	       batch = 1;
> 	else
> 	       batch = XFS_FDBLOCKS_BATCH;
> 
> 	/*
> 	* Set aside allocbt blocks because these blocks are tracked as free
> 	* space but not available for allocation. Technically this means that a
> 	* single reservation cannot consume all remaining free space, but the
> 	* ratio of allocbt blocks to usable free blocks should be rather small.
> 	* The tradeoff without this is that filesystems that maintain high
> 	* perag block reservations can over reserve physical block availability
> 	* and fail physical allocation, which leads to much more serious
> 	* problems (i.e. transaction abort, pagecache discards, etc.) than
> 	* slightly premature -ENOSPC.
> 	*/
> 	if (use_resv_pool)
> 		set_aside = xfs_fdblocks_unavailable(mp);
> 	percpu_counter_add_batch(pccnt, delta, batch);
> 	if (__percpu_counter_compare(&pccnt, set_aside,
> 				    XFS_FDBLOCKS_BATCH) >= 0) {
> 	       /* we had space! */
> 	       return 0;
> 	}
> 
> 	/*
> 	* lock up the sb for dipping into reserves before releasing the space
> 	* that took us to ENOSPC.
> 	*/
> 	spin_lock(&mp->m_sb_lock);
> 	percpu_counter_add(pccnt, -delta);
> 	if (!use_resv_pool || !rsvd)
> 	       goto fdblocks_enospc;
> 
> 	lcounter = (long long)mp->m_resblks_avail + delta;
> 	if (lcounter >= 0) {
> 	       mp->m_resblks_avail = lcounter;
> 	       spin_unlock(&mp->m_sb_lock);
> 	       return 0;
> 	}
> 	xfs_warn_once(mp,
> "Reserve blocks depleted! Consider increasing reserve pool size.");
> 
> fdblocks_enospc:
> 	spin_unlock(&mp->m_sb_lock);
> 	return -ENOSPC;
> }
> 
> And in the relevant header file:
> 
> int xfs_mod_blocks(struct xfs_mount *mp, struct pcp_counter *pccnt,
> 		int64_t delta, bool use_resv_pool, bool rsvd);
> 
> static inline int
> xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta, bool rsvd)
> {
> 	return xfs_mod_blocks(mp, &mp->m_fdblocks, delta, true, resvd);
> }
> 
> static inline int
> xfs_mod_frextents(struct xfs_mount *mp, int64_t delta)
> {
> 	return xfs_mod_blocks(mp, &mp->m_frextents, delta, false, false);
> }

Looks good to me.

> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 54be9d64093e..cc95768eb8e1 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -843,9 +843,11 @@ xfs_fs_statfs(
> >  
> >  	if (XFS_IS_REALTIME_MOUNT(mp) &&
> >  	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
> > +		s64	freertx;
> > +
> >  		statp->f_blocks = sbp->sb_rblocks;
> > -		statp->f_bavail = statp->f_bfree =
> > -			sbp->sb_frextents * sbp->sb_rextsize;
> > +		freertx = max_t(s64, 0, percpu_counter_sum(&mp->m_frextents));
> 
> percpu_counter_sum_positive()

Ok.

> >  	if (error)
> >  		goto free_fdblocks;
> >  
> > +	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
> > +	if (error)
> > +		goto free_delalloc;
> > +
> >  	return 0;
> >  
> > +free_delalloc:
> > +	percpu_counter_destroy(&mp->m_delalloc_blks);
> >  free_fdblocks:
> >  	percpu_counter_destroy(&mp->m_fdblocks);
> >  free_ifree:
> > @@ -1033,6 +1041,7 @@ xfs_reinit_percpu_counters(
> >  	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
> >  	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
> >  	percpu_counter_set(&mp->m_fdblocks, mp->m_sb.sb_fdblocks);
> > +	percpu_counter_set(&mp->m_frextents, mp->m_sb.sb_frextents);
> >  }
> >  
> >  static void
> > @@ -1045,6 +1054,7 @@ xfs_destroy_percpu_counters(
> >  	ASSERT(xfs_is_shutdown(mp) ||
> >  	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
> >  	percpu_counter_destroy(&mp->m_delalloc_blks);
> > +	percpu_counter_destroy(&mp->m_frextents);
> >  }
> >  
> >  static int
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 0ac717aad380..63a4d3a24340 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -498,10 +498,31 @@ xfs_trans_apply_sb_deltas(
> >  			be64_add_cpu(&sbp->sb_fdblocks, tp->t_res_fdblocks_delta);
> >  	}
> >  
> > -	if (tp->t_frextents_delta)
> > -		be64_add_cpu(&sbp->sb_frextents, tp->t_frextents_delta);
> > -	if (tp->t_res_frextents_delta)
> > -		be64_add_cpu(&sbp->sb_frextents, tp->t_res_frextents_delta);
> > +	/*
> > +	 * Updating frextents requires careful handling because it does not
> > +	 * behave like the lazysb counters because we cannot rely on log
> > +	 * recovery in older kenels to recompute the value from the rtbitmap.
> > +	 * This means that the ondisk frextents must be consistent with the
> > +	 * rtbitmap.
> > +	 *
> > +	 * Therefore, log the frextents change to the ondisk superblock and
> > +	 * update the incore superblock so that future calls to xfs_log_sb
> > +	 * write the correct value ondisk.
> > +	 *
> > +	 * Don't touch m_frextents because it includes incore reservations,
> > +	 * and those are handled by the unreserve function.
> > +	 */
> > +	if (tp->t_frextents_delta || tp->t_res_frextents_delta) {
> > +		struct xfs_mount	*mp = tp->t_mountp;
> > +		int64_t			rtxdelta;
> > +
> > +		rtxdelta = tp->t_frextents_delta + tp->t_res_frextents_delta;
> > +
> > +		spin_lock(&mp->m_sb_lock);
> > +		be64_add_cpu(&sbp->sb_frextents, rtxdelta);
> > +		mp->m_sb.sb_frextents += rtxdelta;
> > +		spin_unlock(&mp->m_sb_lock);
> > +	}
> 
> Hmmmm.  This wants a comment in xfs_log_sb() to explain why we
> aren't updating mp->m_sb.sb_frextents from mp->m_frextents like we
> do with all the other per-cpu counters tracking resource usage.

Ok.  How about this for xfs_log_sb:

/*
 * Do not update sb_frextents here because it is not part of the lazy sb
 * counters (despite having a percpu counter) and therefore must be
 * consistent with the ondisk rtbitmap.
 */

> >  
> >  	if (tp->t_dblocks_delta) {
> >  		be64_add_cpu(&sbp->sb_dblocks, tp->t_dblocks_delta);
> > @@ -614,7 +635,12 @@ xfs_trans_unreserve_and_mod_sb(
> >  	if (ifreedelta)
> >  		percpu_counter_add(&mp->m_ifree, ifreedelta);
> >  
> > -	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
> > +	if (rtxdelta) {
> > +		error = xfs_mod_frextents(mp, rtxdelta);
> > +		ASSERT(!error);
> > +	}
> > +
> > +	if (!(tp->t_flags & XFS_TRANS_SB_DIRTY))
> >  		return;
> >  
> >  	/* apply remaining deltas */
> > @@ -622,7 +648,6 @@ xfs_trans_unreserve_and_mod_sb(
> >  	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> >  	mp->m_sb.sb_icount += idelta;
> >  	mp->m_sb.sb_ifree += ifreedelta;
> > -	mp->m_sb.sb_frextents += rtxdelta;
> 
> This makes my head hurt trying to work out if this is necessary or
> not. (the lazy sb stuff in these functions has always strained my
> cognitive abilities, even though I wrote it in the first place!)
> 
> A comment explaining why we don't need to update
> mp->m_sb.sb_frextents when XFS_TRANS_SB_DIRTY is set would be useful
> in the above if (rtxdelta) update above.

And how about this?

/*
 * Do not touch sb_frextents here because we are dealing with incore
 * reservation.  sb_frextents is not part of the lazy sb counters so it
 * must be consistent with the ondisk rtibitmap and must never include
 * incore reservations.
 */

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
