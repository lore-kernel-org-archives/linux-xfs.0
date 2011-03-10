Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2AHWwDM114030 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 11:33:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 262E633825D
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 09:35:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id prdJwaMidXX881P1 for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2011 09:35:50 -0800 (PST)
Date: Thu, 10 Mar 2011 12:35:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] xfs: convert ENOSPC inode flushing to use new syncd
	workqueue
Message-ID: <20110310173549.GC19609@infradead.org>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299715529-11026-4-git-send-email-david@fromorbit.com>
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

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +STATIC void
> +xfs_flush_worker(
> +	struct work_struct *work)
> +{
> +	struct xfs_mount *mp = container_of(work,
> +					struct xfs_mount, m_flush_work);
> +
> +	xfs_sync_data(mp, SYNC_TRYLOCK);
> +	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
> +	xfs_log_force(mp, XFS_LOG_SYNC);

No actually new in this patch: but what's the point of the log force
here?  xfs_sync_data just did one before returning.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
