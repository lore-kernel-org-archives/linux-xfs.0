Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A589AC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 03:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A8BC611F1
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 03:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhDODn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 23:43:26 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:40916 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229449AbhDODn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 23:43:26 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 796F4106390;
        Thu, 15 Apr 2021 13:42:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lWsu7-008ahk-R9; Thu, 15 Apr 2021 13:42:55 +1000
Date:   Thu, 15 Apr 2021 13:42:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: support deactivating AGs
Message-ID: <20210415034255.GJ63242@dread.disaster.area>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414195240.1802221-2-hsiangkao@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ZUsk1KR6EFIescRJSo8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 15, 2021 at 03:52:37AM +0800, Gao Xiang wrote:
> To get rid of paralleled requests related to AGs which are pending
> for shrinking, mark these perags as inactive rather than playing
> with per-ag structures theirselves.
> 
> Since in that way, a per-ag lock can be used to stablize the inactive
> status together with agi/agf buffer lock (which is much easier than
> adding more complicated perag_{get, put} pairs..) Also, Such per-ags
> can be released / reused when unmountfs / growfs.
> 
> On the read side, pag_inactive_rwsem can be unlocked immediately after
> the agf or agi buffer lock is acquired. However, pag_inactive_rwsem
> can only be unlocked after the agf/agi buffer locks are all acquired
> with the inactive status on the write side.
> 
> XXX: maybe there are some missing cases.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c     | 16 +++++++++++++---
>  fs/xfs/libxfs/xfs_alloc.c  | 12 +++++++++++-
>  fs/xfs/libxfs/xfs_ialloc.c | 26 +++++++++++++++++++++++++-
>  fs/xfs/xfs_mount.c         |  2 ++
>  fs/xfs/xfs_mount.h         |  6 ++++++
>  5 files changed, 57 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index c68a36688474..ba5702e5c9ad 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -676,16 +676,24 @@ xfs_ag_get_geometry(
>  	if (agno >= mp->m_sb.sb_agcount)
>  		return -EINVAL;
>  
> +	pag = xfs_perag_get(mp, agno);
> +	down_read(&pag->pag_inactive_rwsem);

No need to encode the lock type in the lock name. We know it's a
rwsem from the lock API functions...

> +
> +	if (pag->pag_inactive) {
> +		error = -EBUSY;
> +		up_read(&pag->pag_inactive_rwsem);
> +		goto out;
> +	}

This looks kinda heavyweight. Having to take a rwsem whenever we do
a perag lookup to determine if we can access the perag completely
defeats the purpose of xfs_perag_get() being a lightweight, lockless
operation.

I suspect what we really want here is active/passive references like
are used for the superblock, and an API that hides the
implementation from all the callers.


> +
>  	/* Lock the AG headers. */
>  	error = xfs_ialloc_read_agi(mp, NULL, agno, &agi_bp);
> +	up_read(&pag->pag_inactive_rwsem);
>  	if (error)
> -		return error;
> +		goto out;
>  	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
>  	if (error)
>  		goto out_agi;

This seems to imply that we don't need to hold the inactive rwsem
to read the AGF. Either we need the semaphore held in read mode to
protect the inactive state for the entire operation we are
performing, or you haven't documented how the locking is supposed to
guarantee existence once the inactive_rwsem has been dropped.

Instead, lets' look at this as an active vs passive reference issue.
Currently everything takes passive references because we don't
enforce the reference count for anything - it's largely to tell us
that everything that took a reference also released it by the time
we tear down the perag.

So say that buffers take passive references because we need buffers
to be used while we tear down the AG, and that everything else that
does perag_get()...perag_put() in a loop or single logic context is
an active reference, we can actually use active references to
prevent a shrink from stepping into the perag while something else
is actively referencing the perag.

Hence we convert the sites in this patch to use
xfs_perag_get_active() ...  xfs_perag_put_active() pairs, and
everything else gets hidden away inside those functions.

That allows us to implement active references as an atomic counter
that is manipulated under RCU context to provide existence
guarantees for the structure.  i.e. something like this:

/*
 * Get an active reference to the perag for a given agno. If the AG
 * is in the process of being torn down, the active reference count
 * will be zero and this lookup will fail and return NULL.
 */
static inline struct xfs_perag *
xfs_perag_get_active(
	struct xfs_mount	*mp,
	xfs_agnumber_t		agno)
{
	struct xfs_perag        *pag;

	rcu_read_lock();
	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
	if (pag) {
		if (!atomic_inc_not_zero(&pag->pag_active_ref))
			pag = NULL;
	}
	rcu_read_unlock();
	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
	return pag;
}

static inline void
xfs_perag_put_active(
	struct xfs_perag	*pag)
{
	atomic_dec(&pag->pag_active_ref);
}

For active references to work as an access barrier,
xfs_perag_initialise() needs to first take an active reference for
the mount when it is allocated. This makes the initial value
non-zero, so active references can be taken at any time after
initialisation.

When shrink needs to remove the AG, it first drops the mount's
active reference to the AG. This allows the active reference count
to fall to zero. It then waits for it to hit zero, and once it does
all future active reference lookups will fail to find this perag.
Hence shrink now can start the process of tearing down the AG
structures knowing that nobody is going to be using the AG for
per-ag based work...

This has no more overhead than the a passive lookup, and does not
require a rwsem or a separate inactive state flag to detect or
switch between active and inactive states. It's also trivially
reversable - the mount just has to take an active reference once the
perag has been re-initialised.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
