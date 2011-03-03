Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p23FVKMh098772 for <xfs@oss.sgi.com>; Thu, 3 Mar 2011 09:31:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 382FC1DDF279
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2011 07:34:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DNPFitDxGDBHhFCv for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2011 07:34:11 -0800 (PST)
Date: Thu, 3 Mar 2011 10:34:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: convert ENOSPC inode flushing to use new syncd
	workqueue
Message-ID: <20110303153410.GA27205@infradead.org>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298412969-14389-4-git-send-email-david@fromorbit.com>
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

I still don't see any point in having the ENOSPC flushing moved to a
different context.

Just add a mutex and flush inline, e.g.

void
xfs_flush_inodes(
	struct xfs_inode	*ip)
{
	struct xfs_mount	*mp = ip->i_mount;

	if (!mutex_trylock(&xfs_syncd_lock))
		return;		/* someone else is flushing right now */
	xfs_sync_data(mp, SYNC_TRYLOCK);
	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
	xfs_log_force(mp, XFS_LOG_SYNC);
	mutex_unlock(&xfs_syncd_lock);
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
