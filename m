Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2AHjRtd115023 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 11:45:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A77D334C8D
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 09:48:18 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6LvtPxBrfzrg873W for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2011 09:48:18 -0800 (PST)
Date: Thu, 10 Mar 2011 12:48:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: convert the xfsaild threads to a workqueue
Message-ID: <20110310174818.GE19609@infradead.org>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299715529-11026-6-git-send-email-david@fromorbit.com>
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

>  STATIC int __init
> +xfs_init_workqueues(void)

> +STATIC void __exit
> +xfs_destroy_workqueues(void)

I don't think these helpers are overly useful.

> +	xfs_ail_wq = alloc_workqueue("xfsail", WQ_CPU_INTENSIVE, 8);

> +}


> +static void
> +xfs_ail_push_queue(
> +	struct xfs_ail		*ailp,
> +	xfs_lsn_t		threshold_lsn,
> +	int			tout)
> +{
> +	if (XFS_LSN_CMP(threshold_lsn, ailp->xa_target) > 0) {
> +		ailp->xa_target = threshold_lsn;
> +		queue_delayed_work(xfs_syncd_wq, &ailp->xa_work, tout);

tout is always one in the only caller and thus doesn't need to be
passed.  But I think you really want a timeout of 0 here to queue it up
ASAP (it translates to a direct queue_work() call internally).

Also this function could simply be merged into it's only and relatively
simple caller.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
