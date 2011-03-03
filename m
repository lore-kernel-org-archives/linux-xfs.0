Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p23FXhB6098916 for <xfs@oss.sgi.com>; Thu, 3 Mar 2011 09:33:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0990430F08A
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2011 07:36:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GlwSXnT3ftfSo1EK for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2011 07:36:34 -0800 (PST)
Date: Thu, 3 Mar 2011 10:36:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: introduce background inode reclaim work
Message-ID: <20110303153634.GB27205@infradead.org>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298412969-14389-5-git-send-email-david@fromorbit.com>
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
Cc: chris.mason@oracle.com, xfs@oss.sgi.com

> +void
> +xfs_syncd_queue_reclaim(
> +	struct xfs_mount        *mp,
> +	int			flags)
> +{
> +	mutex_lock(&xfs_syncd_lock);
> +	if (!delayed_work_pending(&mp->m_reclaim_work))
> +		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
> +			xfs_syncd_centisecs / 5 * msecs_to_jiffies(10));
> +	mutex_unlock(&xfs_syncd_lock);
> +
> +	if (flags & SYNC_WAIT)
> +		flush_delayed_work_sync(&mp->m_reclaim_work);
> +}

queue_work/queue_delayed_work have a test_set_bit on
WORK_STRUCT_PENDING_BIT, so can just call queue_work/queue_delayed_work
and it will do the right thing if it is in use.  So you can remove the
mutex and delayed_work_pending check here.

At least currently SYNC_WAIT is never set by any caller, and I wonder if
we should just leave the waiting to the caller if we ever grow one.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
