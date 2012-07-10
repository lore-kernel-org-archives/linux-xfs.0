Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6A4rMrm053299 for <xfs@oss.sgi.com>; Mon, 9 Jul 2012 23:53:22 -0500
Received: from LGEMRELSE7Q.lge.com (LGEMRELSE7Q.lge.com [156.147.1.151]) by
	cuda.sgi.com with ESMTP id bsh2EaDNEtWkoKoO for
	<xfs@oss.sgi.com>; Mon, 09 Jul 2012 21:53:20 -0700 (PDT)
From: Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/6] workqueue: factor out worker_pool from global_cwq
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-3-git-send-email-tj@kernel.org>
Date: Tue, 10 Jul 2012 13:48:44 +0900
In-Reply-To: <1341859315-17759-3-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Mon, 9 Jul 2012 11:41:51 -0700")
Message-ID: <87ehok8bmb.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
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
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Hi, Tejun

Just nitpicks..


On Mon,  9 Jul 2012 11:41:51 -0700, Tejun Heo wrote:
> Move worklist and all worker management fields from global_cwq into
> the new struct worker_pool.  worker_pool points back to the containing
> gcwq.  worker and cpu_workqueue_struct are updated to point to
> worker_pool instead of gcwq too.
>
> This change is mechanical and doesn't introduce any functional
> difference other than rearranging of fields and an added level of
> indirection in some places.  This is to prepare for multiple pools per
> gcwq.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  include/trace/events/workqueue.h |    2 +-
>  kernel/workqueue.c               |  216 ++++++++++++++++++++-----------------
>  2 files changed, 118 insertions(+), 100 deletions(-)
>
> diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
> index 4018f50..f28d1b6 100644
> --- a/include/trace/events/workqueue.h
> +++ b/include/trace/events/workqueue.h
> @@ -54,7 +54,7 @@ TRACE_EVENT(workqueue_queue_work,
>  		__entry->function	= work->func;
>  		__entry->workqueue	= cwq->wq;
>  		__entry->req_cpu	= req_cpu;
> -		__entry->cpu		= cwq->gcwq->cpu;
> +		__entry->cpu		= cwq->pool->gcwq->cpu;
>  	),
>  
>  	TP_printk("work struct=%p function=%pf workqueue=%p req_cpu=%u cpu=%u",
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 27637c2..bc43a0c 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -115,6 +115,7 @@ enum {
>   */
>  
>  struct global_cwq;
> +struct worker_pool;
>  
>  /*
>   * The poor guys doing the actual heavy lifting.  All on-duty workers
> @@ -131,7 +132,7 @@ struct worker {
>  	struct cpu_workqueue_struct *current_cwq; /* L: current_work's cwq */
>  	struct list_head	scheduled;	/* L: scheduled works */
>  	struct task_struct	*task;		/* I: worker task */
> -	struct global_cwq	*gcwq;		/* I: the associated gcwq */
> +	struct worker_pool	*pool;		/* I: the associated pool */
>  	/* 64 bytes boundary on 64bit, 32 on 32bit */
>  	unsigned long		last_active;	/* L: last active timestamp */
>  	unsigned int		flags;		/* X: flags */
> @@ -139,6 +140,21 @@ struct worker {
>  	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
>  };
>  
> +struct worker_pool {
> +	struct global_cwq	*gcwq;		/* I: the owning gcwq */
> +
> +	struct list_head	worklist;	/* L: list of pending works */
> +	int			nr_workers;	/* L: total number of workers */
> +	int			nr_idle;	/* L: currently idle ones */
> +
> +	struct list_head	idle_list;	/* X: list of idle workers */
> +	struct timer_list	idle_timer;	/* L: worker idle timeout */
> +	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */

What is 'dworkers'?


> +
> +	struct ida		worker_ida;	/* L: for worker IDs */
> +	struct worker		*first_idle;	/* L: first idle worker */
> +};
> +
>  /*
>   * Global per-cpu workqueue.  There's one and only one for each cpu
>   * and all works are queued and processed here regardless of their
> @@ -146,27 +162,18 @@ struct worker {
>   */
>  struct global_cwq {
>  	spinlock_t		lock;		/* the gcwq lock */
> -	struct list_head	worklist;	/* L: list of pending works */
>  	unsigned int		cpu;		/* I: the associated cpu */
>  	unsigned int		flags;		/* L: GCWQ_* flags */
>  
> -	int			nr_workers;	/* L: total number of workers */
> -	int			nr_idle;	/* L: currently idle ones */
> -
> -	/* workers are chained either in the idle_list or busy_hash */
> -	struct list_head	idle_list;	/* X: list of idle workers */
> +	/* workers are chained either in busy_head or pool idle_list */

s/busy_head/busy_hash/ ?

Thanks,
Namhyung


>  	struct hlist_head	busy_hash[BUSY_WORKER_HASH_SIZE];
>  						/* L: hash of busy workers */
>  
> -	struct timer_list	idle_timer;	/* L: worker idle timeout */
> -	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */
> -
> -	struct ida		worker_ida;	/* L: for worker IDs */
> +	struct worker_pool	pool;		/* the worker pools */
>  
>  	struct task_struct	*trustee;	/* L: for gcwq shutdown */
>  	unsigned int		trustee_state;	/* L: trustee state */
>  	wait_queue_head_t	trustee_wait;	/* trustee wait */
> -	struct worker		*first_idle;	/* L: first idle worker */
>  } ____cacheline_aligned_in_smp;
>  
>  /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
