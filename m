Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBH7TaPJ203236 for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 01:29:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A973145E523
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 23:31:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	KxCbuwBlqW4n9JrY for <xfs@oss.sgi.com>;
	Thu, 16 Dec 2010 23:31:28 -0800 (PST)
Date: Fri, 17 Dec 2010 18:31:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: split direct IO write path from
	xfs_file_aio_write
Message-ID: <20101217073125.GE5193@dastard>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
	<1292376208-16282-5-git-send-email-david@fromorbit.com>
	<20101216120629.GC20445@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101216120629.GC20445@infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Dec 16, 2010 at 07:06:29AM -0500, Christoph Hellwig wrote:
> > +STATIC ssize_t
> > +xfs_file_dio_aio_write(
> > +	struct kiocb		*iocb,
> > +	const struct iovec	*iovp,
> > +	unsigned long		nr_segs,
> > +	loff_t			pos,
> > +	size_t			ocount,
> > +	int			*need_i_mutex,
> > +	int			*iolock)
> 
> need_i_mutex == 1 is equivalent to iolock == XFS_IOLOCK_EXCL, I think
> it's a good idea to throw in a patch to remove the need_i_mutex variable
> before this patch.
> 
> Maybe that patch can even add xfs_rw_lock or similar helpers to
> manipulate the i_mutex, the iolock, and the iolock variable together?

That sounds like a fine idea.

> Speaking of that, shouldn't xfs_file_aio_read also take the iolock
> exclusive during the page invalidation and then demote it, just like
> the write case?  The above helpers would enforce that nicely.

Probably, though it might be best to leave that to another cleanup
series. I'll see how much perturbation of the read path it makes....

> > +	if ((pos & target->bt_smask) || (count & target->bt_smask))
> > +		return XFS_ERROR(-EINVAL);
> 
> For the error traps to work this needs to be
> 
> 	-XFS_ERROR(EINVAL);

Ok, will fix. I just copied the existing code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
