Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2REVXCW092729 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 09:31:35 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QicRaAIVEZ6VydXR (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 07:31:30 -0700 (PDT)
Date: Tue, 27 Mar 2012 10:31:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Do background CIL flushes via a workqueue
Message-ID: <20120327143127.GA11434@infradead.org>
References: <1332841605-3538-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1332841605-3538-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, xfs@oss.sgi.com

Vivek, does CFQ still need any hints for this sort of handoff?

On Tue, Mar 27, 2012 at 08:46:45PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Doing background CIL flushes adds significant latency to whatever
> async transaction that triggers it. To avoid blocking async
> transactions on things like waiting for log buffer IO to complete,
> move the CIL push off into a workqueue.  By moving the push work
> into a workqueue, we remove all the latency that the commit adds
> from the foreground transaction commit path. This also means that
> single threaded workloads won't do the CIL push procssing, leaving
> them more CPU to do more async transactions.
> 
> To do this, we need to keep track of the sequence number we have
> pushed work for. This avoids having many transaction commits
> attempting to schedule work for the same sequence, and ensures that
> we only ever have one push (background or forced) in progress at a
> time. It also means that we don't need to take the CIL lock in write
> mode to check for potential background push races, which reduces
> lock contention.
> 
> To avoid potential issues with "smart" IO schedulers, don't use the
> workqueue for log force triggered flushes. Instead, do them directly
> so that the log IO is done directly by the process issuing the log
> force and so doesn't get stuck on IO elevator queue idling
> incorrectly delaying the log IO from the workqueue.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  |  241 ++++++++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_log_priv.h |    4 +
>  fs/xfs/xfs_super.c    |    6 ++
>  3 files changed, 158 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index d4fadbe..6a5a7ba 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -31,57 +31,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_discard.h"
>  
> -/*
> - * Perform initial CIL structure initialisation.
> - */
> -int
> -xlog_cil_init(
> -	struct log	*log)
> -{
> -	struct xfs_cil	*cil;
> -	struct xfs_cil_ctx *ctx;
> -
> -	cil = kmem_zalloc(sizeof(*cil), KM_SLEEP|KM_MAYFAIL);
> -	if (!cil)
> -		return ENOMEM;
> -
> -	ctx = kmem_zalloc(sizeof(*ctx), KM_SLEEP|KM_MAYFAIL);
> -	if (!ctx) {
> -		kmem_free(cil);
> -		return ENOMEM;
> -	}
> -
> -	INIT_LIST_HEAD(&cil->xc_cil);
> -	INIT_LIST_HEAD(&cil->xc_committing);
> -	spin_lock_init(&cil->xc_cil_lock);
> -	init_rwsem(&cil->xc_ctx_lock);
> -	init_waitqueue_head(&cil->xc_commit_wait);
> -
> -	INIT_LIST_HEAD(&ctx->committing);
> -	INIT_LIST_HEAD(&ctx->busy_extents);
> -	ctx->sequence = 1;
> -	ctx->cil = cil;
> -	cil->xc_ctx = ctx;
> -	cil->xc_current_sequence = ctx->sequence;
> -
> -	cil->xc_log = log;
> -	log->l_cilp = cil;
> -	return 0;
> -}
> -
> -void
> -xlog_cil_destroy(
> -	struct log	*log)
> -{
> -	if (log->l_cilp->xc_ctx) {
> -		if (log->l_cilp->xc_ctx->ticket)
> -			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
> -		kmem_free(log->l_cilp->xc_ctx);
> -	}
> -
> -	ASSERT(list_empty(&log->l_cilp->xc_cil));
> -	kmem_free(log->l_cilp);
> -}
> +struct workqueue_struct *xfs_cil_wq;
>  
>  /*
>   * Allocate a new ticket. Failing to get a new ticket makes it really hard to
> @@ -426,8 +376,7 @@ xlog_cil_committed(
>   */
>  STATIC int
>  xlog_cil_push(
> -	struct log		*log,
> -	xfs_lsn_t		push_seq)
> +	struct log		*log)
>  {
>  	struct xfs_cil		*cil = log->l_cilp;
>  	struct xfs_log_vec	*lv;
> @@ -443,39 +392,35 @@ xlog_cil_push(
>  	struct xfs_log_iovec	lhdr;
>  	struct xfs_log_vec	lvhdr = { NULL };
>  	xfs_lsn_t		commit_lsn;
> +	xfs_lsn_t		push_seq;
>  
>  	if (!cil)
>  		return 0;
>  
> -	ASSERT(!push_seq || push_seq <= cil->xc_ctx->sequence);
> -
>  	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_SLEEP|KM_NOFS);
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
>  
> -	/*
> -	 * Lock out transaction commit, but don't block for background pushes
> -	 * unless we are well over the CIL space limit. See the definition of
> -	 * XLOG_CIL_HARD_SPACE_LIMIT() for the full explanation of the logic
> -	 * used here.
> -	 */
> -	if (!down_write_trylock(&cil->xc_ctx_lock)) {
> -		if (!push_seq &&
> -		    cil->xc_ctx->space_used < XLOG_CIL_HARD_SPACE_LIMIT(log))
> -			goto out_free_ticket;
> -		down_write(&cil->xc_ctx_lock);
> -	}
> +	down_write(&cil->xc_ctx_lock);
>  	ctx = cil->xc_ctx;
>  
> -	/* check if we've anything to push */
> -	if (list_empty(&cil->xc_cil))
> -		goto out_skip;
> +	spin_lock(&cil->xc_cil_lock);
> +	push_seq = cil->xc_push_seq;
> +	ASSERT(push_seq > 0 && push_seq <= ctx->sequence);
>  
> -	/* check for spurious background flush */
> -	if (!push_seq && cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
> +	/*
> +	 * Check if we've anything to push. If there is nothing, then we don't
> +	 * move on to a new sequence number and so we have to be able to push
> +	 * this sequence again later.
> +	 */
> +	if (list_empty(&cil->xc_cil)) {
> +		cil->xc_push_seq = 0;
> +		spin_unlock(&cil->xc_cil_lock);
>  		goto out_skip;
> +	}
> +	spin_unlock(&cil->xc_cil_lock);
>  
>  	/* check for a previously pushed seqeunce */
> -	if (push_seq && push_seq < cil->xc_ctx->sequence)
> +	if (push_seq < cil->xc_ctx->sequence)
>  		goto out_skip;
>  
>  	/*
> @@ -629,7 +574,6 @@ restart:
>  
>  out_skip:
>  	up_write(&cil->xc_ctx_lock);
> -out_free_ticket:
>  	xfs_log_ticket_put(new_ctx->ticket);
>  	kmem_free(new_ctx);
>  	return 0;
> @@ -641,6 +585,80 @@ out_abort:
>  	return XFS_ERROR(EIO);
>  }
>  
> +static void
> +xlog_cil_push_work(
> +	struct work_struct	*work)
> +{
> +	struct xfs_cil		*cil = container_of(work, struct xfs_cil,
> +							xc_push_work);
> +	xlog_cil_push(cil->xc_log);
> +}
> +
> +/*
> + * We need to push CIL every so often so we don't cache more than we can fit in
> + * the log. The limit really is that a checkpoint can't be more than half the
> + * log (the current checkpoint is not allowed to overwrite the previous
> + * checkpoint), but commit latency and memory usage limit this to a smaller
> + * size.
> + */
> +static void
> +xlog_cil_push_background(
> +	struct log	*log)
> +{
> +	struct xfs_cil	*cil = log->l_cilp;
> +
> +	/*
> +	 * The cil won't be empty because we are called while holding the
> +	 * context lock so whatever we added to the CIL will still be there
> +	 */
> +	ASSERT(!list_empty(&cil->xc_cil));
> +
> +	/*
> +	 * don't do a background push if we haven't used up all the
> +	 * space available yet.
> +	 */
> +	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
> +		return;
> +
> +	spin_lock(&cil->xc_cil_lock);
> +	cil->xc_push_seq = cil->xc_current_sequence;
> +	queue_work(xfs_cil_wq, &cil->xc_push_work);
> +	spin_unlock(&cil->xc_cil_lock);
> +
> +}
> +
> +static void
> +xlog_cil_push_foreground(
> +	struct log	*log,
> +	xfs_lsn_t	push_seq)
> +{
> +	struct xfs_cil	*cil = log->l_cilp;
> +
> +	if (!cil)
> +		return;
> +
> +	ASSERT(push_seq && push_seq <= cil->xc_current_sequence);
> +
> +	/* start on any pending background push to minimise wait time on it */
> +	flush_work(&cil->xc_push_work);
> +
> +	/*
> +	 * If the CIL is empty or we've already pushed the sequence then
> +	 * there's no work we need to do.
> +	 */
> +	spin_lock(&cil->xc_cil_lock);
> +	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
> +		spin_unlock(&cil->xc_cil_lock);
> +		return;
> +	}
> +
> +	cil->xc_push_seq = push_seq;
> +	spin_unlock(&cil->xc_cil_lock);
> +
> +	/* do the push now */
> +	xlog_cil_push(log);
> +}
> +
>  /*
>   * Commit a transaction with the given vector to the Committed Item List.
>   *
> @@ -667,7 +685,6 @@ xfs_log_commit_cil(
>  {
>  	struct log		*log = mp->m_log;
>  	int			log_flags = 0;
> -	int			push = 0;
>  	struct xfs_log_vec	*log_vector;
>  
>  	if (flags & XFS_TRANS_RELEASE_LOG_RES)
> @@ -719,21 +736,9 @@ xfs_log_commit_cil(
>  	 */
>  	xfs_trans_free_items(tp, *commit_lsn, 0);
>  
> -	/* check for background commit before unlock */
> -	if (log->l_cilp->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log))
> -		push = 1;
> +	xlog_cil_push_background(log);
>  
>  	up_read(&log->l_cilp->xc_ctx_lock);
> -
> -	/*
> -	 * We need to push CIL every so often so we don't cache more than we
> -	 * can fit in the log. The limit really is that a checkpoint can't be
> -	 * more than half the log (the current checkpoint is not allowed to
> -	 * overwrite the previous checkpoint), but commit latency and memory
> -	 * usage limit this to a smaller size in most cases.
> -	 */
> -	if (push)
> -		xlog_cil_push(log, 0);
>  	return 0;
>  }
>  
> @@ -746,9 +751,6 @@ xfs_log_commit_cil(
>   *
>   * We return the current commit lsn to allow the callers to determine if a
>   * iclog flush is necessary following this call.
> - *
> - * XXX: Initially, just push the CIL unconditionally and return whatever
> - * commit lsn is there. It'll be empty, so this is broken for now.
>   */
>  xfs_lsn_t
>  xlog_cil_force_lsn(
> @@ -766,8 +768,7 @@ xlog_cil_force_lsn(
>  	 * xlog_cil_push() handles racing pushes for the same sequence,
>  	 * so no need to deal with it here.
>  	 */
> -	if (sequence == cil->xc_current_sequence)
> -		xlog_cil_push(log, sequence);
> +	xlog_cil_push_foreground(log, sequence);
>  
>  	/*
>  	 * See if we can find a previous sequence still committing.
> @@ -826,3 +827,57 @@ xfs_log_item_in_current_chkpt(
>  		return false;
>  	return true;
>  }
> +
> +/*
> + * Perform initial CIL structure initialisation.
> + */
> +int
> +xlog_cil_init(
> +	struct log	*log)
> +{
> +	struct xfs_cil	*cil;
> +	struct xfs_cil_ctx *ctx;
> +
> +	cil = kmem_zalloc(sizeof(*cil), KM_SLEEP|KM_MAYFAIL);
> +	if (!cil)
> +		return ENOMEM;
> +
> +	ctx = kmem_zalloc(sizeof(*ctx), KM_SLEEP|KM_MAYFAIL);
> +	if (!ctx) {
> +		kmem_free(cil);
> +		return ENOMEM;
> +	}
> +
> +	INIT_WORK(&cil->xc_push_work, xlog_cil_push_work);
> +	INIT_LIST_HEAD(&cil->xc_cil);
> +	INIT_LIST_HEAD(&cil->xc_committing);
> +	spin_lock_init(&cil->xc_cil_lock);
> +	init_rwsem(&cil->xc_ctx_lock);
> +	init_waitqueue_head(&cil->xc_commit_wait);
> +
> +	INIT_LIST_HEAD(&ctx->committing);
> +	INIT_LIST_HEAD(&ctx->busy_extents);
> +	ctx->sequence = 1;
> +	ctx->cil = cil;
> +	cil->xc_ctx = ctx;
> +	cil->xc_current_sequence = ctx->sequence;
> +
> +	cil->xc_log = log;
> +	log->l_cilp = cil;
> +	return 0;
> +}
> +
> +void
> +xlog_cil_destroy(
> +	struct log	*log)
> +{
> +	if (log->l_cilp->xc_ctx) {
> +		if (log->l_cilp->xc_ctx->ticket)
> +			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
> +		kmem_free(log->l_cilp->xc_ctx);
> +	}
> +
> +	ASSERT(list_empty(&log->l_cilp->xc_cil));
> +	kmem_free(log->l_cilp);
> +}
> +
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 2152900..ea8c076 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -417,8 +417,12 @@ struct xfs_cil {
>  	struct list_head	xc_committing;
>  	wait_queue_head_t	xc_commit_wait;
>  	xfs_lsn_t		xc_current_sequence;
> +	struct work_struct	xc_push_work;
> +	xfs_lsn_t		xc_push_seq;
>  };
>  
> +extern struct workqueue_struct *xfs_cil_wq;
> +
>  /*
>   * The amount of log space we allow the CIL to aggregate is difficult to size.
>   * Whatever we choose, we have to make sure we can get a reservation for the
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aef50ab..c5059f5 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1634,8 +1634,13 @@ xfs_init_workqueues(void)
>  	if (!xfs_alloc_wq)
>  		goto out_destroy_syncd;
>  
> +	xfs_cil_wq = alloc_workqueue("xfscwcilalloc", WQ_MEM_RECLAIM, 0);
> +	if (!xfs_cil_wq)
> +		goto out_destroy_alloc;
>  	return 0;
>  
> +out_destroy_alloc:
> +	destroy_workqueue(xfs_alloc_wq);
>  out_destroy_syncd:
>  	destroy_workqueue(xfs_syncd_wq);
>  	return -ENOMEM;
> @@ -1644,6 +1649,7 @@ out_destroy_syncd:
>  STATIC void
>  xfs_destroy_workqueues(void)
>  {
> +	destroy_workqueue(xfs_cil_wq);
>  	destroy_workqueue(xfs_alloc_wq);
>  	destroy_workqueue(xfs_syncd_wq);
>  }
> -- 
> 1.7.9
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
