Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08BDdux034539 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 05:13:39 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1081B152281
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 03:14:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fApTdMiMWtHb4IaB for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2010 03:14:32 -0800 (PST)
Date: Fri, 8 Jan 2010 06:14:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: Use delayed write for inodes rather than async
Message-ID: <20100108111432.GA4685@infradead.org>
References: <1262649861-28530-1-git-send-email-david@fromorbit.com>
	<1262649861-28530-2-git-send-email-david@fromorbit.com>
	<20100108103620.GA11769@infradead.org>
	<20100108110524.GC8718@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100108110524.GC8718@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jan 08, 2010 at 10:05:24PM +1100, Dave Chinner wrote:
> I don't think it really matters for the existing code as we do the
> xfs_flush_buftarg(SYNC_WAIT) in the loop below which will push out
> inodes flushed during reclaim.

True.

> Hmmm - given that xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI) can skip
> inodes, there probably should be a sync reclaim done in the flush
> loop to ensure we've caught them.

Indeed, the skipping behaviour is rather confusing and needs to be taken
care off.

> Yes - xfs_iflush_int() gets called only from xfs_iflush() and
> xfs_iflush_cluster() and both check first.

Ok.

> The delayed write flush can skip inodes, so we need to do a sync
> flush to guarantee that we reclaim all dirty inodes. The flush is done
> first so the sync flush doesn't block on the flush locks for too
> long for inodes that are already locked for delwri flushing.
> Perhaps a:
> 
> 	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
> 	XFS_bflush(mp->m_ddev_targp);
> 	xfs_reclaim_inodes(mp, XFS_IFLUSH_SYNC);
> 
> sequence would be better here?

I guess that would be optimal.  Maybe with a little comment explaining
why we do it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
