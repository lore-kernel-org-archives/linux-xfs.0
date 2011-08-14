Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7EGVklI246806 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 11:31:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD9781C01969
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 09:31:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HNPleFWtFbBvCs5J for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 09:31:45 -0700 (PDT)
Date: Sun, 14 Aug 2011 12:31:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: reduce the number of log forces from tail pushing
Message-ID: <20110814163144.GD29428@infradead.org>
References: <1312786271-10871-1-git-send-email-david@fromorbit.com>
	<1312786271-10871-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312786271-10871-3-git-send-email-david@fromorbit.com>
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

The flush_log variable in xfs_ail_worker is non-zero after your
patch, and can be removed.

The second argument for xfs_log_force to force a sync log force is
XFS_LOG_SYNC, not SYNC_WAIT.

I also don't really like the goto again style - we can just move the log
push at the beggining of the function, the only thing it requires is
adding an additional list_empty check, e.g.:

	spin_lock(&ailp->xa_lock);
 	/*
	 * If last time we ran we encountered pinned items, force the log
	 * first, wait for it and then push again.
	 */
	if (ailp->xa_last_pushed_lsn == 0 && ailp->xa_log_flush &&
	    !list_empty(&ailp->xa_ail)) {
		ailp->xa_log_flush = 0;
		spin_unlock(&ailp->xa_lock);
		XFS_STATS_INC(xs_push_ail_flush);
		xfs_log_force(mp, SYNC_WAIT);
		spin_lock(&ailp->xa_lock);
	}

	target = ailp->xa_target;
        lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
