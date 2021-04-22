Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52FEC433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 806E061445
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243049AbhDVACQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 20:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234886AbhDVACQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 20:02:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FF93601FD;
        Thu, 22 Apr 2021 00:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619049702;
        bh=dGH02YA5b1Ui7XvNQ1uvUMyU4Dq7HEbapM+uZ+VeB5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jeB5U9kEiUUqb2VHfxmFhYc/8y/DCFrA9AR5bh3K0KlRDkdASvtCyDaWX7ielL6U9
         xQrN8b1eZCsdPwMbIvLL0M/aYNIB/ESrAsvCWGVxkq7u5A2fab42zSSSwxspUYv5vG
         96UUxGhCEeqFRpvhKwuNh/m7Jf7/UwPLCYr7ObaD3JXv7wjjPKoen+kvVtrd3bregC
         1HIOhMZY910fHCa6MX+RmS/Mmc7hh8RsN2ZMR+JMjFL1M9f+UHTzHkmPenE0j9zK6U
         /duhCK0IQvE6il7MwZP+ZdCqzuby8la13buIFWBOyP7ybCH1ly9E8Wfhx6mxVJbPFg
         lwBKyzGHHdkqg==
Date:   Wed, 21 Apr 2021 17:01:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/2] xfs: turn on lazysbcount unconditionally
Message-ID: <20210422000140.GU3122264@magnolia>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
 <20210420110855.2961626-2-hsiangkao@redhat.com>
 <20210420162250.GE3122264@magnolia>
 <20210420200029.GA3028214@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420200029.GA3028214@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 04:00:29AM +0800, Gao Xiang wrote:
> Hi Darrick,
> 
> On Tue, Apr 20, 2021 at 09:22:50AM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 20, 2021 at 07:08:55PM +0800, Gao Xiang wrote:
> > > As Dave mentioned [1], "/me is now wondering why we even bother
> > > with !lazy-count anymore.
> > > 
> > > We've updated the agr btree block accounting unconditionally since
> > > lazy-count was added, and scrub will always report a mismatch in
> > > counts if they exist regardless of lazy-count. So why don't we just
> > > start ignoring the on-disk value and always use lazy-count based
> > > updates? "
> > > 
> > > Therefore, turn on lazy sb counters if it's still disabled at the
> > > mount time, or at remount_rw if fs was mounted as read-only.
> > > xfs_initialize_perag_data() is reused here since no need to scan
> > > agf/agi once more again.
> > > 
> > > After this patch, we could get rid of this whole set of subtle
> > > conditional behaviours in the codebase.
> > > 
> > > [1] https://lore.kernel.org/r/20210417223201.GU63242@dread.disaster.area
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > > Enabling lazysbcount is only addressed in this patch, I'll send
> > > out a seperated following patch to cleanup all unused conditions
> > > later.
> > > 
> > > Also tr_sb is reused here since only agf is modified for each ag,
> > > and before lazysbcount sb feature is enabled (m_update_sb = true),
> > > agf_btreeblks field shouldn't matter for such AGs.
> > > 
> > >  fs/xfs/libxfs/xfs_format.h |  6 +++
> > >  fs/xfs/libxfs/xfs_sb.c     | 93 +++++++++++++++++++++++++++++++++++---
> > >  fs/xfs/xfs_mount.c         |  2 +-
> > >  fs/xfs/xfs_super.c         |  5 ++
> > >  4 files changed, 98 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index 76e2461b9e66..9081d7876d66 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -385,6 +385,12 @@ static inline bool xfs_sb_version_haslazysbcount(struct xfs_sb *sbp)
> > >  		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
> > >  }
> > >  
> > > +static inline void xfs_sb_version_addlazysbcount(struct xfs_sb *sbp)
> > > +{
> > > +	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
> > > +	sbp->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
> > > +}
> > > +
> > >  static inline bool xfs_sb_version_hasattr2(struct xfs_sb *sbp)
> > >  {
> > >  	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 423dada3f64c..6353e0d4cab1 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -18,6 +18,7 @@
> > >  #include "xfs_trace.h"
> > >  #include "xfs_trans.h"
> > >  #include "xfs_buf_item.h"
> > > +#include "xfs_btree.h"
> > >  #include "xfs_bmap_btree.h"
> > >  #include "xfs_alloc_btree.h"
> > >  #include "xfs_log.h"
> > > @@ -841,6 +842,55 @@ xfs_sb_mount_common(
> > >  	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
> > >  }
> > >  
> > > +static int
> > > +xfs_fixup_agf_btreeblks(
> > > +	struct xfs_mount	*mp,
> > > +	struct xfs_trans	*tp,
> > > +	struct xfs_buf		*agfbp,
> > > +	xfs_agnumber_t		agno)
> > > +{
> > > +	struct xfs_btree_cur	*cur;
> > > +	struct xfs_perag	*pag = agfbp->b_pag;
> > > +	struct xfs_agf		*agf = agfbp->b_addr;
> > > +	xfs_agblock_t		btreeblks, blocks;
> > > +	int			error;
> > > +
> > > +	cur = xfs_allocbt_init_cursor(mp, tp, agfbp, agno, XFS_BTNUM_BNO);
> > > +	error = xfs_btree_count_blocks(cur, &blocks);
> > > +	if (error)
> > > +		goto err;
> > > +	xfs_btree_del_cursor(cur, error);
> > > +	btreeblks = blocks - 1;
> > > +
> > > +	cur = xfs_allocbt_init_cursor(mp, tp, agfbp, agno, XFS_BTNUM_CNT);
> > > +	error = xfs_btree_count_blocks(cur, &blocks);
> > > +	if (error)
> > > +		goto err;
> > > +	xfs_btree_del_cursor(cur, error);
> > > +	btreeblks += blocks - 1;
> > > +
> > > +	/*
> > > +	 * although rmapbt doesn't exist in v4 fses, but it'd be better
> > > +	 * to turn it as a generic helper.
> > > +	 */
> > > +	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > > +		cur = xfs_rmapbt_init_cursor(mp, tp, agfbp, agno);
> > > +		error = xfs_btree_count_blocks(cur, &blocks);
> > > +		if (error)
> > > +			goto err;
> > > +		xfs_btree_del_cursor(cur, error);
> > > +		btreeblks += blocks - 1;
> > > +	}
> > > +
> > > +	agf->agf_btreeblks = cpu_to_be32(btreeblks);
> > > +	pag->pagf_btreeblks = btreeblks;
> > > +	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_BTREEBLKS);
> > > +	return 0;
> > > +err:
> > > +	xfs_btree_del_cursor(cur, error);
> > > +	return error;
> > > +}
> > > +
> > >  /*
> > >   * xfs_initialize_perag_data
> > >   *
> > > @@ -864,27 +914,51 @@ xfs_initialize_perag_data(
> > >  	uint64_t	btree = 0;
> > >  	uint64_t	fdblocks;
> > >  	int		error = 0;
> > > +	bool		conv = !(mp->m_flags & XFS_MOUNT_RDONLY) &&
> > > +				!xfs_sb_version_haslazysbcount(sbp);
> > > +
> > > +	if (conv)
> > > +		xfs_warn(mp, "enabling lazy-counters...");
> > >  
> > >  	for (index = 0; index < agcount; index++) {
> > > +		struct xfs_trans	*tp = NULL;
> > > +		struct xfs_buf		*agfbp;
> > > +
> > > +		if (conv) {
> > > +			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb,
> > > +					0, 0, 0, &tp);
> > > +			if (error)
> > > +				return error;
> > > +		}
> > > +
> > >  		/*
> > > -		 * read the agf, then the agi. This gets us
> > > +		 * read the agi, then the agf. This gets us
> > >  		 * all the information we need and populates the
> > >  		 * per-ag structures for us.
> > >  		 */
> > > -		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
> > > -		if (error)
> > > +		error = xfs_ialloc_pagi_init(mp, tp, index);
> > > +		if (error) {
> > > +err_out:
> > > +			if (tp)
> > > +				xfs_trans_cancel(tp);
> > >  			return error;
> > > +		}
> > >  
> > > -		error = xfs_ialloc_pagi_init(mp, NULL, index);
> > > +		error = xfs_alloc_read_agf(mp, tp, index, 0, &agfbp);
> > >  		if (error)
> > > -			return error;
> > > -		pag = xfs_perag_get(mp, index);
> > > +			goto err_out;
> > > +		pag = agfbp->b_pag;
> > >  		ifree += pag->pagi_freecount;
> > >  		ialloc += pag->pagi_count;
> > >  		bfree += pag->pagf_freeblks;
> > >  		bfreelst += pag->pagf_flcount;
> > > +		if (tp) {
> > > +			error = xfs_fixup_agf_btreeblks(mp, tp, agfbp, index);
> > 
> > Lazysbcount upgrades should be done from a separate function, not mixed
> > in with perag initialization. 
> 
> I've seen some previous discussion about multiple AG total scan time cost.
> Yeah, if another extra scan really accepts here, I could update instead.
> 
> > Also, why is it necessary to walk all the space btrees to set agf_btreeblks?
> 
> If my understanding is correct, I think because without lazysbcount,
> even pagf_btreeblks is updated unconditionally now, but that counter
> is unreliable for quite ancient kernels which don't have such update
> logic.
> 
> Kindly correct me if I'm wrong here.

Ah, you're right.  The agf_btreeblks field in the AGF only exists if
lazysbcount is enabled, which means that adding the feature means that
we have to scan every AG to compute the correct value.

Still, we only need to do this walk once per filesystem, so I'd prefer
not to clutter up the xfs_initialize_perag_data code for the sake of a
onetime upgrade for a deprecated ondisk format.

In my mind it's a feature to be able to do:

#if IS_ENABLED(CONFIG_XFS_V4)
int
xfs_fs_set_lazycount(...)
{
	/* walk AGs, fix AGF... */
	/* lock super */
	/* set lazysbcount */
	/* bwrite super */
	/* log super changes */
	/* commit the whole mess */
}
#else
# define xfs_fs_set_lazycount(..)	(-ENOSYS)
#endif

Because then we know that this is all XFSv4 code and can easily make it
go away.

The other question I have is: Do we /really/ want to QA and support
this in the kernel?  Considering that we already have xfs_admin -c1?

> > 
> > > +			xfs_trans_commit(tp);
> > > +		} else {
> > > +			xfs_buf_relse(agfbp);
> > > +		}
> > >  		btree += pag->pagf_btreeblks;
> > > -		xfs_perag_put(pag);
> > >  	}
> > >  	fdblocks = bfree + bfreelst + btree;
> > >  
> > > @@ -900,6 +974,11 @@ xfs_initialize_perag_data(
> > >  		goto out;
> > >  	}
> > >  
> > > +	if (conv) {
> > > +		xfs_sb_version_addlazysbcount(sbp);
> > > +		mp->m_update_sb = true;
> > > +		xfs_warn(mp, "lazy-counters has been enabled.");
> > 
> > But we don't log the sb update?
> > 
> > As far as the feature upgrade goes, is it necessary to bwrite the
> > primary super to disk (and then log the change)[1] to prevent a truly
> > ancient kernel that doesn't support lazysbcount from trying to recover
> > the log and ending up with an unsupported feature set?
> 
> Not quite sure if it does harm to ancient kernels with such
> unsupported feature. may I ask for more details? :)

1. Walk AG to update btreeblks.
2. Commit feature flag update in superblock.
3. Log flushes to disk before the superblock update gets written to
   sector 0.
<crash>
4. Boot ancient kernel that doesn't understand lazysbcount
   (from USB recovery stick).
5. Mount begins, because sector 0 doesn't have the lazysbcount bit set.
6. Log recovery replays the primary super update over sector 0, and the
   new contents of sector 0 say lazysbcount is enabled.
7. Superblock now says it has lazysbcount, what does the kernel do?

> 
> but yeah, if any issues here, I should follow
>  1) bwrite sb block first;
>  2) log sb
> 
> > 
> > [1] https://lore.kernel.org/linux-xfs/161723934343.3149451.16679733325094950568.stgit@magnolia/
> > 
> > > +	}
> > >  	/* Overwrite incore superblock counters with just-read data */
> > >  	spin_lock(&mp->m_sb_lock);
> > >  	sbp->sb_ifree = ifree;
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index cb1e2c4702c3..b3b13acd45d6 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -626,7 +626,7 @@ xfs_check_summary_counts(
> > >  	 * superblock to be correct and we don't need to do anything here.
> > >  	 * Otherwise, recalculate the summary counters.
> > >  	 */
> > > -	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
> > > +	if ((xfs_sb_version_haslazysbcount(&mp->m_sb) &&
> > 
> > Not clear why the logic here inverts?
> 
> .. thus xfs_initialize_perag_data() below can be called then.

That seems like all the more reason to make it a separate function, TBH.

--D

> 
> Thanks,
> Gao Xiang
> 
> > 
> > --D
> > 
> > >  	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
> > >  	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
> > >  		return 0;
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index a2dab05332ac..16197a890c15 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -1678,6 +1678,11 @@ xfs_remount_rw(
> > >  	}
> > >  
> > >  	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > > +	if (!xfs_sb_version_haslazysbcount(sbp)) {
> > > +		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
> > > +		if (error)
> > > +			return error;
> > > +	}
> > >  
> > >  	/*
> > >  	 * If this is the first remount to writeable state we might have some
> > > -- 
> > > 2.27.0
> > > 
> > 
> 
