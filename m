Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7PKvwcJ238421 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 15:57:58 -0500
Subject: Re: [PATCH 6/6] xfs: convert xfsbufd to use a workqueue
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1314256626-11136-7-git-send-email-david@fromorbit.com>
References: <1314256626-11136-1-git-send-email-david@fromorbit.com>
	<1314256626-11136-7-git-send-email-david@fromorbit.com>
Date: Thu, 25 Aug 2011 15:57:19 -0500
Message-ID: <1314305839.3136.104.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Thu, 2011-08-25 at 17:17 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is no reason we need a thread per filesystem to do the
> flushing of the delayed write buffer queue. This can be easily
> handled by a global concurrency managed workqueue.
> 
> Convert the delayed write buffer handling to use workqueues and
> workqueue flushes to implement buffer writeback by embedding a
> delayed work structure into the struct xfs_buftarg and using that to
> control flushing.  This greatly simplifes the process of flushing
> and also removes a bunch of duplicated code between buftarg flushing
> and delwri buffer writeback.

I point out one bug below.  I also question one of the
changes and have some suggestions.  I'd like to see this
updated and get another chance to review the result.

					-Alex

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c       |  165 ++++++++++++++++++++----------------------------
>  fs/xfs/xfs_buf.h       |    5 +-
>  fs/xfs/xfs_dquot.c     |    1 -
>  fs/xfs/xfs_trans_ail.c |    2 +-
>  4 files changed, 72 insertions(+), 101 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 410de9f..b1b8c0c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c

. . .

> @@ -1407,8 +1407,9 @@ xfs_buf_delwri_queue(
>  	}
>  
>  	if (list_empty(dwq)) {
> -		/* start xfsbufd as it is about to have something to do */
> -		wake_up_process(bp->b_target->bt_task);
> +		/* queue a delayed flush as we are about to queue a buffer */
> +		queue_delayed_work(xfs_buf_wq, &bp->b_target->bt_delwrite_work,
> +			xfs_buf_timer_centisecs * msecs_to_jiffies(10));

I think this should be done *after* the buffer has been
added to the delayed work queue.  I realize there will be
a small delay so it should be fine, but...  It also doesn't
have to be done with bt_delwrite_lock held.

>  	}
>  
>  	bp->b_flags |= _XBF_DELWRI_Q;
> @@ -1486,13 +1487,13 @@ STATIC int
>  xfs_buf_delwri_split(
>  	xfs_buftarg_t	*target,
>  	struct list_head *list,
> -	unsigned long	age)
> +	unsigned long	age,
> +	int		force)
>  {
>  	xfs_buf_t	*bp, *n;
>  	struct list_head *dwq = &target->bt_delwrite_queue;
>  	spinlock_t	*dwlk = &target->bt_delwrite_lock;
>  	int		skipped = 0;
> -	int		force;
>  
>  	force = test_and_clear_bit(XBT_FORCE_FLUSH, &target->bt_flags);

You forgot to delete this line when you made "force" be
an argument to this function.

The (now sole) caller--xfs_buf_delwri_work()--uses the
value of force it computes after this function returns,
so it's clear you want to use the passed-in value.

But given that the caller will have already cleared
the bit, the value of "force" will now be 0.  Which
means that with this code xfs_flush_buftarg() does
not work as it should.

I think if you delete this line all is well, but you
need to test this.

>  	INIT_LIST_HEAD(list);
> @@ -1543,90 +1544,36 @@ xfs_buf_cmp(
>  	return 0;
>  }
>  
> -STATIC int
> -xfsbufd(
> -	void		*data)
> -{
> -	xfs_buftarg_t   *target = (xfs_buftarg_t *)data;

. . .

>  /*
> - *	Go through all incore buffers, and release buffers if they belong to
> - *	the given device. This is used in filesystem error handling to
> - *	preserve the consistency of its metadata.
> + * If we are doing a forced flush, then we need to wait for the IO that we
> + * issue to complete.
>   */
> -int
> -xfs_flush_buftarg(
> -	xfs_buftarg_t	*target,
> -	int		wait)
> +static void
> +xfs_buf_delwri_work(
> +	struct work_struct *work)
>  {
> -	xfs_buf_t	*bp;
> -	int		pincount = 0;
> +	struct xfs_buftarg *btp = container_of(to_delayed_work(work),
> +					struct xfs_buftarg, bt_delwrite_work);
> +	struct xfs_buf	*bp;
> +	struct blk_plug	plug;
>  	LIST_HEAD(tmp_list);
>  	LIST_HEAD(wait_list);
> -	struct blk_plug plug;
> -
> -	xfs_buf_runall_queues(xfsconvertd_workqueue);
> -	xfs_buf_runall_queues(xfsdatad_workqueue);
> -	xfs_buf_runall_queues(xfslogd_workqueue);
> +	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
> +	int		force = 0;
>  
> -	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
> -	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
> +	if (test_and_clear_bit(XBT_FORCE_FLUSH, &btp->bt_flags)) {
> +		force = 1;
> +		age = 0;
> +	}

xfs_buf_delwri_split() ignores its "age" argument if "force"
is set.  This function never uses "age" otherwise.  So the
above can just be:

	force = test_and_clear_bit(XBT_FORCE_FLUSH, &btp->bt_flags);

>  
> -	/*
> -	 * Dropped the delayed write list lock, now walk the temporary list.
> -	 * All I/O is issued async and then if we need to wait for completion
> -	 * we do that after issuing all the IO.
> -	 */
> +	xfs_buf_delwri_split(btp, &tmp_list, age, force);
>  	list_sort(NULL, &tmp_list, xfs_buf_cmp);
>  
>  	blk_start_plug(&plug);
>  	while (!list_empty(&tmp_list)) {
>  		bp = list_first_entry(&tmp_list, struct xfs_buf, b_list);
> -		ASSERT(target == bp->b_target);
>  		list_del_init(&bp->b_list);
> -		if (wait) {
> +		if (force) {
>  			bp->b_flags &= ~XBF_ASYNC;
>  			list_add(&bp->b_list, &wait_list);
>  		}

. . .

> @@ -1645,7 +1592,39 @@ xfs_flush_buftarg(
>  		}
>  	}
>  
> -	return pincount;
> +	if (list_empty(&btp->bt_delwrite_queue))
> +		return;
> +
> +	queue_delayed_work(xfs_buf_wq, &btp->bt_delwrite_work,
> +			xfs_buf_timer_centisecs * msecs_to_jiffies(10));
> +}
> +
> +/*
> + *	Handling of buffer targets (buftargs).
> + */
> +
> +/*
> + * Flush all the queued buffer work, then flush any remaining dirty buffers
> + * and wait for them to complete. If there are buffers remaining on the delwri
> + * queue, then they were pinned so couldn't be flushed. Return a value of 1 to
> + * indicate that there were pinned buffers and the caller needs to retry the
> + * flush.
> + */
> +int
> +xfs_flush_buftarg(
> +	xfs_buftarg_t	*target,
> +	int		wait)

Since this function now ignores its "wait" argument,
you could eliminate it, and perhaps get rid of the
one (first) call in xfs_quiesce_fs() that passes 0.

> +{
> +	xfs_buf_runall_queues(xfsconvertd_workqueue);
> +	xfs_buf_runall_queues(xfsdatad_workqueue);
> +	xfs_buf_runall_queues(xfslogd_workqueue);
> +
> +	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
> +	flush_delayed_work_sync(&target->bt_delwrite_work);
> +
> +	if (!list_empty(&target->bt_delwrite_queue))
> +		return 1;
> +	return 0;
 
Maybe just:
	return !list_empty(&target->bt_delwrite_queue);

(But I understand why you might prefer what you did.)

>  }
>  
>  /*

. . .

> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index db62959..1fb9d93 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1446,7 +1446,6 @@ xfs_qm_dqflock_pushbuf_wait(
>  		if (xfs_buf_ispinned(bp))
>  			xfs_log_force(mp, 0);
>  		xfs_buf_delwri_promote(bp);
> -		wake_up_process(bp->b_target->bt_task);

Why does this not need to be replaced with a
flush_delayed_work() call?  Was this wake_up_process()
not needed before?  If that's the case it seems like
that change is independent of the switch to work queues
and should be done separately (first).

>  	}
>  	xfs_buf_relse(bp);
>  out_lock:

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
