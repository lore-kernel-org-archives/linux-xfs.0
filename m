Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3JMi3r2126497 for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 17:44:04 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	D6bLrNGExXL9nxsX for <xfs@oss.sgi.com>;
	Thu, 19 Apr 2012 15:44:01 -0700 (PDT)
Date: Fri, 20 Apr 2012 08:43:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: reduce ilock hold times in xfs_setattr_size
Message-ID: <20120419224357.GW6734@dastard>
References: <20120327143445.196524266@bombadil.infradead.org>
	<20120327143826.615954651@bombadil.infradead.org>
	<20120419210044.GF16881@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120419210044.GF16881@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Apr 19, 2012 at 04:00:44PM -0500, Ben Myers wrote:
> On Tue, Mar 27, 2012 at 10:34:48AM -0400, Christoph Hellwig wrote:
> > We do not need the ilock for most checks done in the beginning of
> > xfs_setattr_size.  Replace the long critical section before starting the
> > transaction with a smaller one around xfs_zero_eof and an optional one
> > inside xfs_qm_dqattach that isn't entered unless using quotas.  While
> > this isn't a big optimization for xfs_setattr_size itself it will allow
> > pushing the ilock into xfs_zero_eof itself later.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > ---
> >  fs/xfs/xfs_iops.c |   14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > Index: xfs/fs/xfs/xfs_iops.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_iops.c	2012-03-26 15:17:47.088854526 +0200
> > +++ xfs/fs/xfs/xfs_iops.c	2012-03-26 15:17:57.265521382 +0200
> > @@ -700,7 +700,7 @@ xfs_setattr_size(
> >  	xfs_off_t		oldsize, newsize;
> >  	struct xfs_trans	*tp;
> >  	int			error;
> > -	uint			lock_flags;
> > +	uint			lock_flags = 0;
> >  	uint			commit_flags = 0;
> >  
> >  	trace_xfs_setattr(ip);
> > @@ -720,10 +720,10 @@ xfs_setattr_size(
> >  			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
> >  			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
> >  
> > -	lock_flags = XFS_ILOCK_EXCL;
> > -	if (!(flags & XFS_ATTR_NOLOCK))
> > +	if (!(flags & XFS_ATTR_NOLOCK)) {
> >  		lock_flags |= XFS_IOLOCK_EXCL;
> > -	xfs_ilock(ip, lock_flags);
> > +		xfs_ilock(ip, lock_flags);
> > +	}
> >  
> >  	oldsize = inode->i_size;
> >  	newsize = iattr->ia_size;
> 
> Usually the ilock is taken to protect i_d.di_nextents.

I don't think it matters here - we hold the IO lock exclusive and
the inode size is 0 so there can be no writes in progress nor dirty
data to write back. Hence no allocation can occur, so the extent
count cannot change, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
