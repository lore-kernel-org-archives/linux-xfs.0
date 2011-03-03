Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p23McInU117979 for <xfs@oss.sgi.com>; Thu, 3 Mar 2011 16:38:19 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BC0C310E30
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2011 14:41:08 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	dcmqq96sre4CfgGI for <xfs@oss.sgi.com>;
	Thu, 03 Mar 2011 14:41:08 -0800 (PST)
Date: Fri, 4 Mar 2011 09:41:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: convert ENOSPC inode flushing to use new
	syncd workqueue
Message-ID: <20110303224105.GP15097@dastard>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-4-git-send-email-david@fromorbit.com>
	<20110303153410.GA27205@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110303153410.GA27205@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: chris.mason@oracle.com, xfs@oss.sgi.com

On Thu, Mar 03, 2011 at 10:34:10AM -0500, Christoph Hellwig wrote:
> I still don't see any point in having the ENOSPC flushing moved to a
> different context.

IIRC, stack usage has always been an issue, and we also call
xfs_flush_inodes() with the XFS_IOLOCK held (from
xfs_iomap_write_delay()) so the alternate context was used to avoid
deadlocks. I don't think we have that deadlock problem now thanks to
being able to combine SYNC_TRYLOCK | SYNC_WAIT flags, but I'm not
sure we can ignore the stack issues.

> Just add a mutex and flush inline, e.g.
> 
> void
> xfs_flush_inodes(
> 	struct xfs_inode	*ip)
> {
> 	struct xfs_mount	*mp = ip->i_mount;
> 
> 	if (!mutex_trylock(&xfs_syncd_lock))
> 		return;		/* someone else is flushing right now */
> 	xfs_sync_data(mp, SYNC_TRYLOCK);
> 	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
> 	xfs_log_force(mp, XFS_LOG_SYNC);
> 	mutex_unlock(&xfs_syncd_lock);
> }

This doesn't allow all the concurrent flushes to block on the flush
in progress. i.e. if there is a flush in progress, all the others
will simply return an likely get ENOSPC again because they haven't
waited for any potential space to be freed up. It also realy
requires a per-filesystem mutex, not a global mutex, because we
don't wan't to avoid flushing filesystem X because filesystem Y is
currently flushing.

Yes, I could play tricks when the trylock case fails, but I'd prefer
to leave it as a work item because then all the concurrent flushers
all block on the same work item and it is clear from the stack
traces what they are all waiting on.

I've also realised the work_pending() check is unnecessary, as is
the lock, because queue_work() will only queue new work if the work
item isn't already pending so there's no need to check it here.
Hence all this actually needs to do is:

	queue_work()
	flush_work_sync()

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
