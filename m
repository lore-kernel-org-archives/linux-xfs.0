Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DN7bDb049346 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 17:07:37 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8ZXkA8YSJSEsi2NN for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 15:07:35 -0800 (PST)
Date: Tue, 14 Feb 2012 10:07:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: concurrent direct IO write in xfs
Message-ID: <20120213230731.GB14132@dastard>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
	<20120123051155.GI15102@dastard>
	<CAFLer82QxfgXEx7ofzOHOK2YKiA+ab+_Aizd10SWHvnC-mVUHg@mail.gmail.com>
	<CAFLer81GWSCCCMppU=2dE+5KKqD-hYVKAA0hz9n-CBbxAs_xfw@mail.gmail.com>
	<20120124035431.GD6922@dastard> <20120209060920.GF7479@dastard>
	<20120213174806.GA7630@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120213174806.GA7630@infradead.org>
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
Cc: Zheng Da <zhengda1936@gmail.com>, xfs@oss.sgi.com

On Mon, Feb 13, 2012 at 12:48:06PM -0500, Christoph Hellwig wrote:
> On Thu, Feb 09, 2012 at 05:09:20PM +1100, Dave Chinner wrote:
> >  	if (create) {
> > -		lockmode = XFS_ILOCK_EXCL;
> > +		/*
> > +		 * For direct IO, we lock in shared mode so that write
> > +		 * operations that don't require allocation can occur
> > +		 * concurrently. The ilock has to be dropped over the allocation
> > +		 * transaction reservation, so the only thing the ilock is
> > +		 * providing here is modification exclusion. i.e. there is no
> > +		 * need to hold the lock exclusive.
> > +		 *
> > +		 * For buffered IO, if we need to do delayed allocation then
> > +		 * hold the ilock exclusive so that the lookup and delalloc
> > +		 * reservation is atomic.
> > +		 */
> > +		if (direct)
> > +			lockmode = XFS_ILOCK_SHARED;
> > +		else
> > +			lockmode = XFS_ILOCK_EXCL;
> >  		xfs_ilock(ip, lockmode);
> >  	} else {
> >  		lockmode = xfs_ilock_map_shared(ip);
> 
> We'll actually need to use xfs_ilock_map_shared for the the direct
> create case too, to make sure we have the exclusive lock when we first
> read the extent list in.

Good point.

> Also xfs_qm_dqattach_locked really wants the inode locked exclusively,
> which your current code doesn't handle.

I didn't consider quotas. Looking at the code, it seems that it
wants an exclusive lock purely for ensuring there are no races
attaching the dquots to the inode. The xfs_dqget() code can actually
drop and regain the ilock, so I can't see that it is for any other
specific purpose.

I think that we could probably attach the dquot after dropping the
shared lock but before starting the transaction via a call to
xfs_qm_dqattach() which handles the locking internally. It does mean
an extra lock traversal for the quota case, but it still allows the
initial mapping to be done with a shared lock....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
