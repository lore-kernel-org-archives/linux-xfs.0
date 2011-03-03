Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p23M2Ba4116869 for <xfs@oss.sgi.com>; Thu, 3 Mar 2011 16:02:11 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6A2B1AEF3F5
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2011 14:05:01 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	l6WHa46eivUmxMcy for <xfs@oss.sgi.com>;
	Thu, 03 Mar 2011 14:05:01 -0800 (PST)
Date: Fri, 4 Mar 2011 09:04:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: introduce inode cluster buffer trylocks for
	xfs_iflush
Message-ID: <20110303220444.GN15097@dastard>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-2-git-send-email-david@fromorbit.com>
	<20110303155535.GA12670@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110303155535.GA12670@infradead.org>
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

On Thu, Mar 03, 2011 at 10:55:35AM -0500, Christoph Hellwig wrote:
> > +	 * pass through will see the stale flag set on the inode.
> > +	 */
> > +	error = xfs_iflush(ip, SYNC_TRYLOCK | sync_mode);
> >  	if (sync_mode & SYNC_WAIT) {
> > +		if (error == EAGAIN) {
> > +			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +			/* backoff longer than in xfs_ifree_cluster */
> > +			delay(2);
> 
> Do we really need the delay here?  It seems like we'd rather want to
> keep going with scanning the next inode cluster and return here from
> xfs_reclaim_inodes.

I did that because SYNC_WAIT semantics mean "block until the inode
is reclaimed". This is the slow, reliable reclaim path that doesn't
return until the inode is reclaimed, so we have to have a backoff
here to allow xfs_ifree_cluster() to complete it's backoff and gain
the locks successfully thereby allowing the inode to be reclaimed
successfully.

> > diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
> > index 32ba662..0ae48ff 100644
> > --- a/fs/xfs/linux-2.6/xfs_sync.h
> > +++ b/fs/xfs/linux-2.6/xfs_sync.h
> > @@ -34,6 +34,7 @@ typedef struct xfs_sync_work {
> >  
> >  int xfs_syncd_init(struct xfs_mount *mp);
> >  void xfs_syncd_stop(struct xfs_mount *mp);
> > +void xfs_syncd_queue_sync(struct xfs_mount *mp, int flags);
> 
> This hunk belongs into a different patch.

Oops. Will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
