Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08B6QRK033840 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 05:06:26 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F35A1C3B599
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 03:07:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Sj5MumKviNvGbtd5 for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2010 03:07:19 -0800 (PST)
Date: Fri, 8 Jan 2010 06:07:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: Don't issue buffer IO direct from AIL push
Message-ID: <20100108110719.GA17442@infradead.org>
References: <1262649861-28530-1-git-send-email-david@fromorbit.com>
	<1262649861-28530-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262649861-28530-3-git-send-email-david@fromorbit.com>
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

> +/*
> + * If a delwri buffer needs to be pushed before it has aged out, then
> + * promote it to the head of the delwri queue so that it will be flushed
> + * on the next xfsbufd run.
> + */
> +void
> +xfs_buf_delwri_promote(
> +	xfs_buf_t	*bp)
> +{
> +	struct list_head *dwq = &bp->b_target->bt_delwrite_queue;
> +	spinlock_t	*dwlk = &bp->b_target->bt_delwrite_lock;
> +	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10) + 1;
> +
> +	spin_lock(dwlk);
> +	ASSERT(bp->b_flags & XBF_DELWRI);
> +	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
> +	list_del(&bp->b_list);
> +	list_add(&bp->b_list, dwq);
> +	bp->b_queuetime = jiffies - age;
> +	spin_unlock(dwlk);

Sorry for the nitpicking, but:

 a) can you use the struct types instead of the typedefs where possible?
 b) second the pointer to spinlock style used here like in some other
    buf code is rather odd.  What about this instead:

void
xfs_buf_delwri_promote(
	struct xfs_buf		*bp)
{
	struct xfs_buftarg	*target = bp->b_target;

	spin_lock(&target->bt_delwrite_lock);
	ASSERT(bp->b_flags & XBF_DELWRI);
	ASSERT(bp->b_flags & _XBF_DELWRI_Q);

	list_move(&bp->b_list, &target->bt_delwrite_queue);
	bp->b_queuetime = jiffies -
			  xfs_buf_age_centisecs * msecs_to_jiffies(10) - 1;
	spin_unlock(&target->bt_delwrite_lock);
}

Also the queuetime calculation could use some comments.

>  extern void xfs_wait_buftarg(xfs_buftarg_t *);
>  extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
>  extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
> +
> +/*
> + * run the xfsbufd on demand to age buffers. Use in combination with
> + * xfs_buf_delwri_promote() to flus delayed write buffers efficiently.
> + */
> +static inline void xfs_flush_buftarg_delwri(xfs_buftarg_t *btp)
> +{
> +	wake_up_process(btp->bt_task);
> +}

The function name is extremly misleading.  It's an xfsbufd wakeup, so it
should be named like that.  In doubt I'd just opencode the
wake_up_process call instead.


The changes to the various log items look good, especially as we bring
some more commonality into the various items.


You removed the only call to trace_xfs_inode_item_push, so you might
aswell remove the trace point declaration, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
