Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CDBC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 04:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96BD361107
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 04:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhDOE0P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 00:26:15 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39737 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhDOE0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 00:26:15 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BFFD81042A07;
        Thu, 15 Apr 2021 14:25:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lWtZd-008dbY-NP; Thu, 15 Apr 2021 14:25:49 +1000
Date:   Thu, 15 Apr 2021 14:25:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] xfs: support shrinking empty AGs
Message-ID: <20210415042549.GM63242@dread.disaster.area>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-5-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414195240.1802221-5-hsiangkao@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=7tuMhrnIWQ9J17F_QpAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 15, 2021 at 03:52:40AM +0800, Gao Xiang wrote:
> Roughly, freespace can be shrinked atomicly with the following steps:
> 
>  - make sure the pending-for-discard AGs are all stablized as empty;
>  - a transaction to
>      fix up freespace btrees for the target tail AG;
>      decrease agcount to the target value.
> 
> In order to make sure such AGs are empty, first to mark them as
> inactive, then check if these AGs are all empty one-by-one. Also
> need to log force, complete all discard operations together.
> 
> Even it's needed to drain out all related cached buffers in case of
> corrupt fs if growfs again, so ail items are all needed to be pushed
> out as well.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c |   1 -
>  fs/xfs/libxfs/xfs_ag.h |   2 +-
>  fs/xfs/xfs_fsops.c     | 148 ++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_mount.c     |  87 +++++++++++++++++++-----
>  fs/xfs/xfs_trans.c     |   1 -
>  5 files changed, 210 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index ba5702e5c9ad..eb370fbae192 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -512,7 +512,6 @@ xfs_ag_shrink_space(
>  	struct xfs_agf		*agf;
>  	int			error, err2;
>  
> -	ASSERT(agno == mp->m_sb.sb_agcount - 1);
>  	error = xfs_ialloc_read_agi(mp, *tpp, agno, &agibp);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 4535de1d88ea..7031e2c7ef66 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -15,7 +15,7 @@ struct aghdr_init_data {
>  	xfs_agblock_t		agno;		/* ag to init */
>  	xfs_extlen_t		agsize;		/* new AG size */
>  	struct list_head	buffer_list;	/* buffer writeback list */
> -	xfs_rfsblock_t		nfree;		/* cumulative new free space */
> +	int64_t			nfree;		/* cumulative new free space */
>  
>  	/* per header data */
>  	xfs_daddr_t		daddr;		/* header location */
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index b33c894b6cf3..659ca1836bba 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -14,11 +14,14 @@
>  #include "xfs_trans.h"
>  #include "xfs_error.h"
>  #include "xfs_alloc.h"
> +#include "xfs_ialloc.h"
> +#include "xfs_extent_busy.h"
>  #include "xfs_fsops.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
> +#include "xfs_trans_priv.h"
>  
>  /*
>   * Write new AG headers to disk. Non-transactional, but need to be
> @@ -78,6 +81,112 @@ xfs_resizefs_init_new_ags(
>  	return error;
>  }
>  
> +static int
> +xfs_shrinkfs_deactivate_ags(
> +	struct xfs_mount        *mp,
> +	xfs_agnumber_t		oagcount,
> +	xfs_agnumber_t		nagcount)
> +{
> +	xfs_agnumber_t		agno;
> +	int			error;
> +
> +	/* confirm AGs pending for shrinking are all inactive */
> +	for (agno = nagcount; agno < oagcount; ++agno) {
> +		struct xfs_buf *agfbp, *agibp;
> +		struct xfs_perag *pag = xfs_perag_get(mp, agno);
> +
> +		down_write(&pag->pag_inactive_rwsem);
> +		/* need to lock agi, agf buffers here to close all races */
> +		error = xfs_read_agi(mp, NULL, agno, &agibp);
> +		if (!error) {
> +			error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agfbp);
> +			if (!error) {
> +				pag->pag_inactive = true;
> +				xfs_buf_relse(agfbp);
> +			}
> +			xfs_buf_relse(agibp);
> +		}
> +		up_write(&pag->pag_inactive_rwsem);
> +		xfs_perag_put(pag);
> +		if (error)
> +			break;
> +	}
> +	return error;
> +}

Hmmmm. Ok, that's why the first patch had the specific locking
pattern it had, because once the AGI is locked under the
inactive_rwsem. This seems ... fragile. It relies on the code
looking up the perag to check the pag->pag_inactive flag before it
takes an AGF or AGI lock, but does not allow a caller than has
an AGI or AGF locked to take the inactive_sem to check if the per-ag
is inactive or not. It's a one-way locking mechanism...

I'd much prefer active/passive references here, and the order of
AG inactivation is highest to lowest...

static void
xfs_shrinkfs_deactivate_ags(
	struct xfs_mount        *mp,
	xfs_agnumber_t		oagcount,
	xfs_agnumber_t		nagcount)
{
	xfs_agnumber_t		agno;

	for (agno = oagcount - 1; agno >= nagcount; agno--) {
		struct xfs_perag *pag = xfs_perag_get(mp, agno);

		/* drop active reference */
		xfs_perag_put_active(pag);

		/* wait for pag->pag_active_refs to hit zero */
		.....

		xfs_perag_put(pag);
	}
}

At this point, we know there are going to be no new racing accesses
to the perags...


> +static void
> +xfs_shrinkfs_activate_ags(
> +	struct xfs_mount        *mp,
> +	xfs_agnumber_t		oagcount,
> +	xfs_agnumber_t		nagcount)
> +{
> +	xfs_agnumber_t		agno;
> +
> +	for (agno = nagcount; agno < oagcount; ++agno) {
> +		struct xfs_perag *pag = xfs_perag_get(mp, agno);
> +
> +		down_write(&pag->pag_inactive_rwsem);
> +		pag->pag_inactive = false;
> +		up_write(&pag->pag_inactive_rwsem);
> +	}
> +}

static void
xfs_shrinkfs_reactivate_ags(
	struct xfs_mount        *mp,
	xfs_agnumber_t		oagcount,
	xfs_agnumber_t		nagcount)
{
	xfs_agnumber_t		agno;

	for (agno = oagcount - 1; agno >= nagcount; agno--) {
		struct xfs_perag *pag = xfs_perag_get(mp, agno);

		/* get a new active reference for the mount */
		atomic_inc(&pag->pag_active_ref);

		xfs_perag_put(pag);
	}
}


> +
> +static int
> +xfs_shrinkfs_prepare_ags(
> +	struct xfs_mount        *mp,
> +	struct aghdr_init_data	*id,
> +	xfs_agnumber_t		oagcount,
> +	xfs_agnumber_t		nagcount)
> +{
> +	xfs_agnumber_t		agno;
> +	int 			error;
> +
> +	error = xfs_shrinkfs_deactivate_ags(mp, oagcount, nagcount);
> +	if (error)
> +		goto err_out;

Waiting for active references to drain means this can't fail.

> +
> +	/* confirm AGs pending for shrinking are all empty */
> +	for (agno = nagcount; agno < oagcount; ++agno) {

Again, needs to work from last AG back to first.

> +		struct xfs_buf		*agfbp;
> +		struct xfs_perag	*pag;
> +
> +		error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agfbp);
> +		if (error)
> +			goto err_out;
> +
> +		pag = agfbp->b_pag;
> +		error = xfs_ag_resv_free(pag);
> +		if (!error) {
> +			error = xfs_ag_is_empty(agfbp);
> +			if (!error) {
> +				ASSERT(!pag->pagf_flcount);
> +				id->nfree -= pag->pagf_freeblks;
> +			}
> +		}

Please don't nest "if (!error)" statements like this. It results in
excessive indent in the code, and it makes it harder to determine
what the actual error handling for failure is.

> +		xfs_buf_relse(agfbp);
> +		if (error)
> +			goto err_out;
> +	}
> +	xfs_log_force(mp, XFS_LOG_SYNC);

What does this do, and why is it not needed before we try to free
reservations and determine if the AG is empty?

> +	/*
> +	 * Wait for all busy extents to be freed, including completion of
> +	 * any discard operation.
> +	 */
> +	xfs_extent_busy_wait_all(mp);
> +	flush_workqueue(xfs_discard_wq);

Shouldn't this happen before we start trying to tear down the AGs?

> +
> +	/*
> +	 * Also need to drain out all related cached buffers, at least,
> +	 * in case of growfs back later (which uses uncached buffers.)
> +	 */
> +	xfs_ail_push_all_sync(mp->m_ail);
> +	xfs_buftarg_drain(mp->m_ddev_targp);

Urk, no, this can livelock on active filesystems.

What you want to do is drain the per-ag buffer cache, not the global
filesystem LRU. Given that, at this point, all the buffers still
cached in the per-ag should have zero references to them, a walk of
the rbtree taking a reference to each buffer, marking it stale and
then calling xfs_buf_rele() on it should be sufficient to free all
the buffers in the AG and release all the remaining passive
references to the struct perag for the AG.

At this point, we can remove the perag from the m_perag radix tree,
do the final teardown on it, and free if via call_rcu()....

> +	return error;
> +err_out:
> +	xfs_shrinkfs_activate_ags(mp, oagcount, nagcount);
> +	return error;
> +}
> +
>  /*
>   * growfs operations
>   */
> @@ -93,7 +202,7 @@ xfs_growfs_data_private(
>  	xfs_rfsblock_t		nb, nb_div, nb_mod;
>  	int64_t			delta;
>  	bool			lastag_extended;
> -	xfs_agnumber_t		oagcount;
> +	xfs_agnumber_t		oagcount, agno;
>  	struct xfs_trans	*tp;
>  	struct aghdr_init_data	id = {};
>  
> @@ -130,14 +239,13 @@ xfs_growfs_data_private(
>  	oagcount = mp->m_sb.sb_agcount;
>  
>  	/* allocate the new per-ag structures */
> -	if (nagcount > oagcount) {
> +	if (nagcount > oagcount)
>  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> -		if (error)
> -			return error;
> -	} else if (nagcount < oagcount) {
> -		/* TODO: shrinking the entire AGs hasn't yet completed */
> -		return -EINVAL;
> -	}
> +	else if (nagcount < oagcount)
> +		error = xfs_shrinkfs_prepare_ags(mp, &id, oagcount, nagcount);
> +
> +	if (error)
> +		return error;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
>  			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> @@ -151,13 +259,29 @@ xfs_growfs_data_private(
>  	} else {
>  		static struct ratelimit_state shrink_warning = \
>  			RATELIMIT_STATE_INIT("shrink_warning", 86400 * HZ, 1);
> +		xfs_agblock_t	agdelta;
> +
>  		ratelimit_set_flags(&shrink_warning, RATELIMIT_MSG_ON_RELEASE);
>  
>  		if (__ratelimit(&shrink_warning))
>  			xfs_alert(mp,
>  	"EXPERIMENTAL online shrink feature in use. Use at your own risk!");
>  
> -		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
> +		for (agno = nagcount; agno < oagcount; ++agno) {
> +			struct xfs_perag *pag = xfs_perag_get(mp, agno);
> +
> +			pag->pagf_freeblks = 0;
> +			pag->pagf_longest = 0;
> +			xfs_perag_put(pag);
> +		}
> +
> +		xfs_trans_agblocks_delta(tp, id.nfree);
> +
> +		if (nagcount != oagcount)
> +			agdelta = nagcount * mp->m_sb.sb_agblocks - nb;
> +		else
> +			agdelta = -delta;
> +		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, agdelta);
>  	}
>  	if (error)
>  		goto out_trans_cancel;
> @@ -167,8 +291,10 @@ xfs_growfs_data_private(
>  	 * seen by the rest of the world until the transaction commit applies
>  	 * them atomically to the superblock.
>  	 */
> -	if (nagcount > oagcount)
> -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> +	if (nagcount != oagcount)
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT,
> +				 (int64_t)nagcount - (int64_t)oagcount);
> +
>  	if (delta)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
>  	if (id.nfree)
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 69a60b5f4a32..ca9513fdc09e 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -172,6 +172,47 @@ xfs_sb_validate_fsb_count(
>  	return 0;
>  }
>  
> +static int
> +xfs_perag_reset(
> +	struct xfs_perag	*pag)
> +{
> +	int	error;
> +
> +	spin_lock_init(&pag->pag_ici_lock);
> +	INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
> +	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
> +
> +	error = xfs_buf_hash_init(pag);
> +	if (error)
> +		return error;
> +
> +	init_waitqueue_head(&pag->pagb_wait);
> +	spin_lock_init(&pag->pagb_lock);
> +	pag->pagb_count = 0;
> +	pag->pagb_tree = RB_ROOT;
> +
> +	error = xfs_iunlink_init(pag);
> +	if (error) {
> +		xfs_buf_hash_destroy(pag);
> +		return error;
> +	}
> +	spin_lock_init(&pag->pag_state_lock);
> +	return 0;
> +}
> +
> +static int
> +xfs_perag_inactive_reset(
> +	struct xfs_perag	*pag)
> +{
> +	cancel_delayed_work_sync(&pag->pag_blockgc_work);
> +	xfs_iunlink_destroy(pag);
> +	xfs_buf_hash_destroy(pag);
> +
> +	memset((char *)pag + offsetof(struct xfs_perag, pag_inactive), 0,
> +	       sizeof(*pag) - offsetof(struct xfs_perag, pag_inactive));
> +	return xfs_perag_reset(pag);
> +}
> +
>  int
>  xfs_initialize_perag(
>  	xfs_mount_t	*mp,
> @@ -180,6 +221,8 @@ xfs_initialize_perag(
>  {
>  	xfs_agnumber_t	index;
>  	xfs_agnumber_t	first_initialised = NULLAGNUMBER;
> +	xfs_agnumber_t	first_inactive = NULLAGNUMBER;
> +	xfs_agnumber_t	last_inactive = NULLAGNUMBER;
>  	xfs_perag_t	*pag;
>  	int		error = -ENOMEM;
>  
> @@ -191,6 +234,20 @@ xfs_initialize_perag(
>  	for (index = 0; index < agcount; index++) {
>  		pag = xfs_perag_get(mp, index);
>  		if (pag) {
> +			down_write(&pag->pag_inactive_rwsem);
> +			if (pag->pag_inactive) {
> +				error = xfs_perag_inactive_reset(pag);
> +				if (error) {
> +					pag->pag_inactive = true;
> +					up_write(&pag->pag_inactive_rwsem);
> +					xfs_perag_put(pag);
> +					goto out_unwind_new_pags;
> +				}
> +				if (first_inactive == NULLAGNUMBER)
> +					first_inactive = index;
> +				last_inactive = index;
> +			}
> +			up_write(&pag->pag_inactive_rwsem);

This should all go away if the perags have already been removed from
the tree. In fact, you shouldn't need to call xfs_initialize_perag()
at all for the shrink case that removes whole AGs....

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
