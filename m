Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7Q8PHVf056370 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 03:25:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3783513A37BF
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 01:28:12 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dvII7Tcakt81QIeh for <xfs@oss.sgi.com>;
	Fri, 26 Aug 2011 01:28:12 -0700 (PDT)
Date: Fri, 26 Aug 2011 04:25:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: convert xfsbufd to use a workqueue
Message-ID: <20110826082515.GD3551@infradead.org>
References: <1314341497-23910-1-git-send-email-david@fromorbit.com>
	<1314341497-23910-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1314341497-23910-5-git-send-email-david@fromorbit.com>
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

> -STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
> +STATIC void xfs_buf_delwri_queue(xfs_buf_t *bp, int unlock);

spuriously changing this prototype just makes merging with other
pending changes in this are harder :P

>  /*
> + * If we are doing a forced flush, then we need to wait for the IO that we
> + * issue to complete.
>   */
> +static void
> +xfs_buf_delwri_work(
> +	struct work_struct *work)
>  {
> +	struct xfs_buftarg *btp = container_of(to_delayed_work(work),
> +					struct xfs_buftarg, bt_delwrite_work);
> +	struct xfs_buf	*bp;
> +	struct blk_plug	plug;
>  	LIST_HEAD(tmp_list);
>  	LIST_HEAD(wait_list);
> +	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
> +	int		force = 0;
>  
> +	force = test_and_clear_bit(XBT_FORCE_FLUSH, &btp->bt_flags);
>  
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
> @@ -1634,7 +1577,7 @@ xfs_flush_buftarg(
>  	}
>  	blk_finish_plug(&plug);
>  
> +	if (force) {
>  		/* Wait for IO to complete. */
>  		while (!list_empty(&wait_list)) {
>  			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
> @@ -1645,7 +1588,48 @@ xfs_flush_buftarg(
>  		}
>  	}
>  

> +/*
> + *	Handling of buffer targets (buftargs).
> + */

I think we can just kill this comment.

> +/*
> + * Flush all the queued buffer work, then flush any remaining dirty buffers
> + * and wait for them to complete. If there are buffers remaining on the delwri
> + * queue, then they were pinned so couldn't be flushed. Return a value of 1 to
> + * indicate that there were pinned buffers and the caller needs to retry the
> + * flush.
> + */

Not directly related to your patch, but only one caller ever checks the
return value and retries.  This means e.g. during sync or umount we
don't bother with trying to push pinned buffers.

> +int
> +xfs_flush_buftarg(
> +	xfs_buftarg_t	*target,

Please use the non-typedef version of new or largely changed code.

> index 13188df..a3d1784 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -494,7 +494,7 @@ xfs_ail_worker(
>  
>  	if (push_xfsbufd) {
>  		/* we've got delayed write buffers to flush */
> -		wake_up_process(mp->m_ddev_targp->bt_task);
> +		flush_delayed_work(&mp->m_ddev_targp->bt_delwrite_work);

This is a huge change in behaviour.  wake_up_process just kicks the
thread to wakeup from sleep as soon as the schedule selects it, while
flush_delayed_work does not only queue a pending delayed work, but also
waits for it to finish.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
