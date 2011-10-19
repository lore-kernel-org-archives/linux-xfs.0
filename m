Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9J9171p172300 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 04:01:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE116F7DC7F
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 02:09:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GjDP0pCBU9vurDD5 for <xfs@oss.sgi.com>;
	Wed, 19 Oct 2011 02:09:06 -0700 (PDT)
Date: Wed, 19 Oct 2011 05:01:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: replace i_flock with a sleeping bitlock
Message-ID: <20111019090105.GB6708@infradead.org>
References: <20111018201304.279051318@bombadil.infradead.org>
	<20111018201405.357001594@bombadil.infradead.org>
	<20111019004206.GB21338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111019004206.GB21338@dastard>
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

On Wed, Oct 19, 2011 at 11:42:06AM +1100, Dave Chinner wrote:
> > +void
> > +__xfs_iflock(
> > +	struct xfs_inode	*ip)
> > +{
> > +	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IFLOCK);
> > +	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_IFLOCK);
> > +
> > +	do {
> > +		prepare_to_wait_exclusive(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
> > +		if (xfs_isiflocked(ip))
> > +			schedule();
> > +	} while (!xfs_iflock_nowait(ip));
> > +
> > +	finish_wait(wq, &wait.wait);
> > +}
> 
> Given that the only way that the inode will become unlocked is for
> IO to complete, that makes this an IO wait, right? Perhaps this
> should call io_schedule() in that case?

It probably should, and would help a bit with our %iowait accounting.
The biggie for that is the buffer lock, though.  Either we'll need
a variant of the semaphore that does io_schedule, which is probably
unlikely to get given that the grater gods want struct semaphore to die.

Or we'll need to do the same bitlock trick there, even if we're not too
worried about struct xfs_buf size - in fact that his how fs/buffer.c
gets the iowait accounting right.

> > @@ -380,6 +372,8 @@ static inline void xfs_ifunlock(xfs_inod
> >  #define XFS_IFILESTREAM		0x0010	/* inode is in a filestream directory */
> >  #define XFS_ITRUNCATED		0x0020	/* truncated down so flush-on-close */
> >  #define XFS_IDIRTY_RELEASE	0x0040	/* dirty release already seen */
> > +#define __XFS_IFLOCK		8	/* inode is beeing flushed right now */
> > +#define XFS_IFLOCK		(1 << __XFS_IFLOCK)
> 
> Any reason for leaving a gap in the flag space here?

I can't remember.  But looking at it again it might be a good idea
to convert the other flags to the (1 << bit) scheme to make the
number more obvious.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
