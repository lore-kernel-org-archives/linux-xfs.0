Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 768897CC9
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 12:18:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0336E8F8033
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 10:17:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 14T4BuYxUVN2v69F (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 10:17:57 -0700 (PDT)
Date: Thu, 21 Jul 2016 13:17:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: allocate log vector buffers outside CIL context lock
Message-ID: <20160721171754.GA24325@laptop.bfoster>
References: <1468974285-5648-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1468974285-5648-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 10:24:45AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> One of the problems we currently have with delayed logging is that
> under serious memory pressure we can deadlock memory reclaim. THis
> occurs when memory reclaim (such as run by kswapd) is reclaiming XFS
> inodes and issues a log force to unpin inodes that are dirty in the
> CIL.
> 
> The CIL is pushed, but this will only occur once it gets the CIL
> context lock to ensure that all committing transactions are complete
> and no new transactions start being committed to the CIL while the
> push switches to a new context.
> 
> The deadlock occurs when the CIL context lock is held by a
> committing process that is doing memory allocation for log vector
> buffers, and that allocation is then blocked on memory reclaim
> making progress. Memory reclaim, however, is blocked waiting for
> a log force to make progress, and so we effectively deadlock at this
> point.
> 
> To solve this problem, we have to move the CIL log vector buffer
> allocation outside of the context lock so that memory reclaim can
> always make progress when it needs to force the log. The problem
> with doing this is that a CIL push can take place while we are
> determining if we need to allocate a new log vector buffer for
> an item and hence the current log vector may go away without
> warning. That means we canot rely on the existing log vector being
> present when we finally grab the context lock and so we must have a
> replacement buffer ready to go at all times.
> 
> To ensure this, introduce a "shadow log vector" buffer that is
> always guaranteed to be present when we gain the CIL context lock
> and format the item. This shadow buffer may or may not be used
> during the formatting, but if the log item does not have an existing
> log vector buffer or that buffer is too small for the new
> modifications, we swap it for the new shadow buffer and format
> the modifications into that new log vector buffer.
> 
> The result of this is that for any object we modify more than once
> in a given CIL checkpoint, we double the memory required
> to track dirty regions in the log. For single modifications then
> we consume the shadow log vectorwe allocate on commit, and that gets
> consumed by the checkpoint. However, if we make multiple
> modifications, then the second transaction commit will allocate a
> shadow log vector and hence we will end up with double the memory
> usage as only one of the log vectors is consumed by the CIL
> checkpoint. The remaining shadow vector will be freed when th elog
> item is freed.
> 
> This can probably be optimised in future - access to the shadow log
> vector is serialised by the object lock (as opposited to the active
> log vector, which is controlled by the CIL context lock) and so we
> can probably free shadow log vector from some objects when the log
> item is marked clean on removal from the AIL.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c     |   1 +
>  fs/xfs/xfs_dquot.c        |   1 +
>  fs/xfs/xfs_dquot_item.c   |   2 +
>  fs/xfs/xfs_extfree_item.c |   2 +
>  fs/xfs/xfs_inode_item.c   |   1 +
>  fs/xfs/xfs_log_cil.c      | 258 ++++++++++++++++++++++++++++++++++------------
>  fs/xfs/xfs_trans.h        |   1 +
>  7 files changed, 202 insertions(+), 64 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 5e54e79..90ebd92 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -78,6 +78,157 @@ xlog_cil_init_post_recovery(
>  	log->l_cilp->xc_ctx->sequence = 1;
>  }
>  
> +static inline int
> +xlog_cil_iovec_space(
> +	uint	niovecs)
> +{
> +	return round_up((sizeof(struct xfs_log_vec) +
> +					niovecs * sizeof(struct xfs_log_iovec)),
> +			sizeof(uint64_t));
> +}
> +
> +/*
> + * Allocate or pin log vector buffers for CIL insertion.
> + *
> + * The CIL currently uses disposable buffers for copying a snapshot of the
> + * modified items into the log during a push. The biggest problem with this is
> + * the requirement to allocate the disposable buffer during the commit if:
> + *	a) does not exist; or
> + *	b) it is too small
> + *
> + * If we do this allocation within xlog_cil_insert_format_items(), it is done
> + * under the xc_ctx_lock, which means that a CIL push cannot occur during
> + * the memory allocation. This means that we have a potential deadlock situation
> + * under low memory conditions when we have lots of dirty metadata pinned in
> + * the CIL and we need a CIL commit to occur to free memory.
> + *
> + * To avoid this, we need to move the memory allocation outside the
> + * xc_ctx_lock(), but because the log vector buffers are disposable, that opens

		 ^ no params here

> + * up a TOCTOU race condition w.r.t. the CIL commiting and removing the log

						committing

> + * vector buffers between the check and the formatting of the item into the
> + * log vector buffer within the xc_ctx_lock.
> + *
> + * Because the log vector buffer needs to be unchanged during the CIL push
> + * process, we cannot share the buffer between the transaction commit (which
> + * modifies the buffer) and the CIL push context that is writing the changes
> + * into the log. This means skipping preallocation of buffer space is
> + * unreliable, but we most definitely do not want to be allocating and freeing
> + * buffers unnecessarily during commits when overwrites can be done safely.
> + *
> + * The simplest solution to this problem is to allocate a shadow buffer when a
> + * log item is committed for the second time, and then to only use this buffer
> + * if necessary. The buffer can remain attached to the log item until such time
> + * it is needed, and this is the buffer that is reallocated to match the size of
> + * the incoming modification. Then during the formatting of the item we can swap
> + * the active buffer with the new one if we can't reuse the existing buffer. We
> + * don't free the old buffer as it may be reused on the next modification if
> + * it's size is right, otherwise we'll free and reallocate it at that point.
> + *
> + * This function builds a vector for the changes in each log item in the
> + * transaction. It then works out the length of the buffer needed for each log
> + * item, allocates them and attaches the vector to the log item in preparation
> + * for the formatting step which occurs under the xc_ctx_lock.
> + *
> + * While this means the memory footprint goes up, it avoids the repeated
> + * alloc/free pattern that repeated modifications of an item would otherwise
> + * cause, and hence minimises the CPU overhead of such behaviour.
> + */
...
> @@ -170,59 +326,29 @@ xlog_cil_insert_format_items(
>  	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
>  		struct xfs_log_item *lip = lidp->lid_item;
>  		struct xfs_log_vec *lv;
> -		struct xfs_log_vec *old_lv;
> -		int	niovecs = 0;
> -		int	nbytes = 0;
> -		int	buf_size;
> +		struct xfs_log_vec *old_lv = NULL;
> +		struct xfs_log_vec *shadow;
>  		bool	ordered = false;
>  
>  		/* Skip items which aren't dirty in this transaction. */
>  		if (!(lidp->lid_flags & XFS_LID_DIRTY))
>  			continue;
>  
> -		/* get number of vecs and size of data to be stored */
> -		lip->li_ops->iop_size(lip, &niovecs, &nbytes);
> -
> -		/* Skip items that do not have any vectors for writing */
> -		if (!niovecs)
> -			continue;
> -
>  		/*
> -		 * Ordered items need to be tracked but we do not wish to write
> -		 * them. We need a logvec to track the object, but we do not
> -		 * need an iovec or buffer to be allocated for copying data.
> +		 * The formatting size information is already attached to
> +		 * the shadow lv on the log item.
>  		 */
> -		if (niovecs == XFS_LOG_VEC_ORDERED) {
> +		shadow = lip->li_lv_shadow;
> +		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED)
>  			ordered = true;
> -			niovecs = 0;
> -			nbytes = 0;
> -		}
>  
> -		/*
> -		 * We 64-bit align the length of each iovec so that the start
> -		 * of the next one is naturally aligned.  We'll need to
> -		 * account for that slack space here. Then round nbytes up
> -		 * to 64-bit alignment so that the initial buffer alignment is
> -		 * easy to calculate and verify.
> -		 */
> -		nbytes += niovecs * sizeof(uint64_t);
> -		nbytes = round_up(nbytes, sizeof(uint64_t));
> -
> -		/* grab the old item if it exists for reservation accounting */
> -		old_lv = lip->li_lv;
> -
> -		/*
> -		 * The data buffer needs to start 64-bit aligned, so round up
> -		 * that space to ensure we can align it appropriately and not
> -		 * overrun the buffer.
> -		 */
> -		buf_size = nbytes +
> -			   round_up((sizeof(struct xfs_log_vec) +
> -				     niovecs * sizeof(struct xfs_log_iovec)),
> -				    sizeof(uint64_t));
> +		/* Skip items that do not have any vectors for writing */
> +		if (!shadow->lv_niovecs && !ordered)
> +			continue;

It would be nice if we didn't need to introduce an allocation to
communicate this particular case, but probably not worth messing with at
this point. Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  		/* compare to existing item size */
> -		if (lip->li_lv && buf_size <= lip->li_lv->lv_size) {
> +		old_lv = lip->li_lv;
> +		if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
>  			/* same or smaller, optimise common overwrite case */
>  			lv = lip->li_lv;
>  			lv->lv_next = NULL;
> @@ -236,32 +362,29 @@ xlog_cil_insert_format_items(
>  			 */
>  			*diff_iovecs -= lv->lv_niovecs;
>  			*diff_len -= lv->lv_bytes;
> +
> +			/* Ensure the lv is set up according to ->iop_size */
> +			lv->lv_niovecs = shadow->lv_niovecs;
> +
> +			/* reset the lv buffer information for new formatting */
> +			lv->lv_buf_len = 0;
> +			lv->lv_bytes = 0;
> +			lv->lv_buf = (char *)lv +
> +					xlog_cil_iovec_space(lv->lv_niovecs);
>  		} else {
> -			/* allocate new data chunk */
> -			lv = kmem_zalloc(buf_size, KM_SLEEP|KM_NOFS);
> +			/* switch to shadow buffer! */
> +			lv = shadow;
>  			lv->lv_item = lip;
> -			lv->lv_size = buf_size;
>  			if (ordered) {
>  				/* track as an ordered logvec */
>  				ASSERT(lip->li_lv == NULL);
> -				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
>  				goto insert;
>  			}
> -			lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
>  		}
>  
> -		/* Ensure the lv is set up according to ->iop_size */
> -		lv->lv_niovecs = niovecs;
> -
> -		/* The allocated data region lies beyond the iovec region */
> -		lv->lv_buf_len = 0;
> -		lv->lv_bytes = 0;
> -		lv->lv_buf = (char *)lv + buf_size - nbytes;
>  		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
> -
>  		lip->li_ops->iop_format(lip, lv);
>  insert:
> -		ASSERT(lv->lv_buf_len <= nbytes);
>  		xfs_cil_prepare_item(log, lv, old_lv, diff_len, diff_iovecs);
>  	}
>  }
> @@ -783,6 +906,13 @@ xfs_log_commit_cil(
>  	struct xlog		*log = mp->m_log;
>  	struct xfs_cil		*cil = log->l_cilp;
>  
> +	/*
> +	 * Do all necessary memory allocation before we lock the CIL.
> +	 * This ensures the allocation does not deadlock with a CIL
> +	 * push in memory reclaim (e.g. from kswapd).
> +	 */
> +	xlog_cil_alloc_shadow_bufs(log, tp);
> +
>  	/* lock out background commit */
>  	down_read(&cil->xc_ctx_lock);
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 9a462e8..9b2b9fa 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -52,6 +52,7 @@ typedef struct xfs_log_item {
>  	/* delayed logging */
>  	struct list_head		li_cil;		/* CIL pointers */
>  	struct xfs_log_vec		*li_lv;		/* active log vector */
> +	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
>  	xfs_lsn_t			li_seq;		/* CIL commit seq */
>  } xfs_log_item_t;
>  
> -- 
> 2.8.0.rc3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
