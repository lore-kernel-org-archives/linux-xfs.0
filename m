Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24CbV96163663 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 06:37:35 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67B54A943F4
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 04:40:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tKGRW4E9tQO9mdvu for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 04:40:23 -0800 (PST)
Date: Fri, 4 Mar 2011 07:40:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: convert ENOSPC inode flushing to use new syncd
	workqueue
Message-ID: <20110304124018.GA29062@infradead.org>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-4-git-send-email-david@fromorbit.com>
	<20110303153410.GA27205@infradead.org>
	<20110303224105.GP15097@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110303224105.GP15097@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, chris.mason@oracle.com, xfs@oss.sgi.com

On Fri, Mar 04, 2011 at 09:41:05AM +1100, Dave Chinner wrote:
> On Thu, Mar 03, 2011 at 10:34:10AM -0500, Christoph Hellwig wrote:
> > I still don't see any point in having the ENOSPC flushing moved to a
> > different context.
> 
> IIRC, stack usage has always been an issue, and we also call
> xfs_flush_inodes() with the XFS_IOLOCK held (from
> xfs_iomap_write_delay()) so the alternate context was used to avoid
> deadlocks. I don't think we have that deadlock problem now thanks to
> being able to combine SYNC_TRYLOCK | SYNC_WAIT flags, but I'm not
> sure we can ignore the stack issues.

Given that we wait for completion of the syncing in the caller moving it
to a different context does not help with any deadlocks.  It just makes
them impossible to detect using lockdep.

> I've also realised the work_pending() check is unnecessary, as is
> the lock, because queue_work() will only queue new work if the work
> item isn't already pending so there's no need to check it here.
> Hence all this actually needs to do is:
> 
> 	queue_work()
> 	flush_work_sync()

or in fact only use the writeback_inodes_sb_if_idle call you added
later.  That also causes writeback of data from the flusher threads.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
