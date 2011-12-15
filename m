Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBF32Fui244445 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 21:02:15 -0600
Date: Wed, 14 Dec 2011 21:02:37 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 13/19] xfs: nest qm_dqfrlist_lock inside the dquot qlock
Message-ID: <20111215030237.GF29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215854.945624913@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215854.945624913@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Dec 06, 2011 at 04:58:19PM -0500, Christoph Hellwig wrote:
> Allow xfs_qm_dqput to work without trylock loops by nesting the freelist lock
> inside the dquot qlock.  In turn that requires trylocks in the reclaim path
> instead, but given it's a classic tradeoff between fast and slow path, and
> we follow the model of the inode and dentry caches.
> 
> Document our new lock order now that it has settled.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  fs/xfs/xfs_dquot.c |   99 ++++++++++++++++++++---------------------------------
>  fs/xfs/xfs_qm.c    |    4 +-
>  2 files changed, 42 insertions(+), 61 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dquot.c	2011-12-06 15:46:19.730356139 +0100
> +++ xfs/fs/xfs/xfs_dquot.c	2011-12-06 15:51:23.630361773 +0100
> @@ -39,20 +39,19 @@
>  #include "xfs_qm.h"
>  #include "xfs_trace.h"
>  
> -
>  /*
> -   LOCK ORDER
> -
> -   inode lock		    (ilock)
> -   dquot hash-chain lock    (hashlock)
> -   xqm dquot freelist lock  (freelistlock
> -   mount's dquot list lock  (mplistlock)
> -   user dquot lock - lock ordering among dquots is based on the uid or gid
> -   group dquot lock - similar to udquots. Between the two dquots, the udquot
> -		      has to be locked first.
> -   pin lock - the dquot lock must be held to take this lock.
> -   flush lock - ditto.
> -*/
> + * Lock order:
> + *
> + * ip->i_lock
> + *   qh->qh_lock
> + *     qi->qi_dqlist_lock
> + *       dquot->q_qlock (xfs_dqlock() and friends)
> + *         dquot->q_flush (xfs_dqflock() and friends)
> + *         xfs_Gqm->qm_dqfrlist_lock
> + *
> + * If two dquots need to be locked the order is user before group/project,
> + * otherwise by the lowest id first, see xfs_dqlock2.
> + */
>  
>  #ifdef DEBUG
>  xfs_buftarg_t *xfs_dqerror_target;
> @@ -984,69 +983,49 @@ restart:
>   */
>  void
>  xfs_qm_dqput(
> -	xfs_dquot_t	*dqp)
> +	struct xfs_dquot	*dqp)
>  {
> -	xfs_dquot_t	*gdqp;
> +	struct xfs_dquot	*gdqp;
>  
>  	ASSERT(dqp->q_nrefs > 0);
>  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
>  
>  	trace_xfs_dqput(dqp);
>  
> -	if (dqp->q_nrefs != 1) {
> -		dqp->q_nrefs--;
> +recurse:
> +	if (--dqp->q_nrefs > 0) {
>  		xfs_dqunlock(dqp);
>  		return;
>  	}
>  
> -	/*
> -	 * drop the dqlock and acquire the freelist and dqlock
> -	 * in the right order; but try to get it out-of-order first
> -	 */
> -	if (!mutex_trylock(&xfs_Gqm->qm_dqfrlist_lock)) {
> -		trace_xfs_dqput_wait(dqp);
> -		xfs_dqunlock(dqp);
> -		mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
> -		xfs_dqlock(dqp);
> -	}
> -
> -	while (1) {
> -		gdqp = NULL;
> +	trace_xfs_dqput_free(dqp);
>  
> -		/* We can't depend on nrefs being == 1 here */
> -		if (--dqp->q_nrefs == 0) {
> -			trace_xfs_dqput_free(dqp);
> -
> -			if (list_empty(&dqp->q_freelist)) {
> -				list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
> -				xfs_Gqm->qm_dqfrlist_cnt++;
> -			}
> +	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
> +	if (list_empty(&dqp->q_freelist)) {
> +		list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
> +		xfs_Gqm->qm_dqfrlist_cnt++;
> +	}
> +	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
>  
> -			/*
> -			 * If we just added a udquot to the freelist, then
> -			 * we want to release the gdquot reference that
> -			 * it (probably) has. Otherwise it'll keep the
> -			 * gdquot from getting reclaimed.
> -			 */
> -			if ((gdqp = dqp->q_gdquot)) {
> -				/*
> -				 * Avoid a recursive dqput call
> -				 */
> -				xfs_dqlock(gdqp);
> -				dqp->q_gdquot = NULL;
> -			}
> -		}
> -		xfs_dqunlock(dqp);
> +	/*
> +	 * If we just added a udquot to the freelist, then we want to release
> +	 * the gdquot reference that it (probably) has. Otherwise it'll keep
> +	 * the gdquot from getting reclaimed.
> +	 */
> +	gdqp = dqp->q_gdquot;
> +	if (gdqp) {
> +		xfs_dqlock(gdqp);
> +		dqp->q_gdquot = NULL;
> +	}
> +	xfs_dqunlock(dqp);
>  
> -		/*
> -		 * If we had a group quota inside the user quota as a hint,
> -		 * release it now.
> -		 */
> -		if (! gdqp)
> -			break;
> +	/*
> +	 * If we had a group quota hint, release it now.
> +	 */
> +	if (gdqp) {
>  		dqp = gdqp;
> +		goto recurse;
>  	}
> -	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
>  }
>  
>  /*
> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm.c	2011-12-06 15:48:38.753692050 +0100
> +++ xfs/fs/xfs/xfs_qm.c	2011-12-06 15:49:31.303693024 +0100
> @@ -1668,7 +1668,9 @@ xfs_qm_dqreclaim_one(void)
>  restart:
>  	list_for_each_entry(dqp, &xfs_Gqm->qm_dqfrlist, q_freelist) {
>  		struct xfs_mount *mp = dqp->q_mount;
> -		xfs_dqlock(dqp);
> +
> +		if (!xfs_dqlock_nowait(dqp))
> +			continue;
>  
>  		/*
>  		 * This dquot has already been grabbed by dqlookup.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
