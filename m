Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14G6iYF072847 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 10:06:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 906621AF2D3
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 08:07:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jtDSlDS9nnuxAr23 for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2010 08:07:54 -0800 (PST)
Date: Thu, 4 Feb 2010 11:07:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/10] xfs: move the inode locking outside xfs_fsync()
Message-ID: <20100204160752.GA11206@infradead.org>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-9-git-send-email-david@fromorbit.com>
	<20100203112917.GB19996@infradead.org>
	<20100203230833.GC5332@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100203230833.GC5332@discord.disaster>
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

On Thu, Feb 04, 2010 at 10:08:33AM +1100, Dave Chinner wrote:
> On Wed, Feb 03, 2010 at 06:29:17AM -0500, Christoph Hellwig wrote:
> > On Wed, Feb 03, 2010 at 10:25:02AM +1100, Dave Chinner wrote:
> > > We have a need for a delayed write inode flush operation
> > > to be made atomically with an fsync to avoid physically
> > > writing inodes but still keeping inode buffer information
> > > up to date for bulkstat.
> > > 
> > > Move the inode locking outside xfs_fsync() to allow this to
> > > be done.
> > 
> > What's the point of the lock_flags argument?  It should always
> > be IOLOCK_SHARED, so instead of passing it in as an argument
> > I'd rather add an assert to enforce it.
> 
> Fair enough. Updated patch below.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: move the inode locking outside xfs_fsync() V2
> 
> We have a need for a delayed write inode flush operation
> to be made atomically with an fsync to avoid physically
> writing inodes but still keeping inode buffer information
> up to date for bulkstat.
> 
> Move the inode locking outside xfs_fsync() to allow this to
> be done.
> 
> Version 2
> - kill the lock_flags argument and simply assert XFS_IOLOCK_SHARED
>   in xfs_fsync().

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
