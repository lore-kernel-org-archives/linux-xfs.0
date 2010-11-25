Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAP0LkTG183515 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 18:21:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5BA013EAF17
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 16:23:22 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	rru3zAIjg6nknSXf for <xfs@oss.sgi.com>;
	Wed, 24 Nov 2010 16:23:22 -0800 (PST)
Date: Thu, 25 Nov 2010 11:23:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: push stale, pinned buffers on trylock failures
Message-ID: <20101125002319.GA12187@dastard>
References: <1290597873-5807-1-git-send-email-david@fromorbit.com>
	<1290597873-5807-3-git-send-email-david@fromorbit.com>
	<20101124172051.GA32129@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101124172051.GA32129@infradead.org>
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

On Wed, Nov 24, 2010 at 12:20:51PM -0500, Christoph Hellwig wrote:
> > -	/* Attempt to get the semaphore without sleeping,
> > -	 * if this does not work then we need to drop the
> > -	 * spinlock and do a hard attempt on the semaphore.
> > +	/*
> > +	 * Attempt to get the semaphore without sleeping first. if we fail then
> > +	 * do a blocking lock if requested.
> >  	 */
> 
> You might as well remove the comment entirely, as it's utterly
> pointless.

Ok.

> > -	if (down_trylock(&bp->b_sema)) {
> > +	if (xfs_buf_cond_lock(bp)) {
> >  		if (!(flags & XBF_TRYLOCK)) {
> >  			/* wait for buffer ownership */
> >  			xfs_buf_lock(bp);
> >  			XFS_STATS_INC(xb_get_locked_waited);
> >  		} else {
> > -			/* We asked for a trylock and failed, no need
> > -			 * to look at file offset and length here, we
> > -			 * know that this buffer at least overlaps our
> > -			 * buffer and is locked, therefore our buffer
> > -			 * either does not exist, or is this buffer.
> > -			 */
> > +			/* We asked for a trylock and failed.  */
> >  			xfs_buf_rele(bp);
> >  			XFS_STATS_INC(xb_busy_locked);
> >  			return NULL;
> >  		}
> 
> In case we wait for the lock we now do the log force twice, but that
> should be fine.

Yeah, I considered ways of avoiding this, but when i actually
measured how often it occurs, it is quite rare because the log force
clears the entire backlog of pinned, stale buffers and so the log
force is lost in the noise of other IO. Hence I thought the more
robust method of fixing and calling xfs_buf_cond_lock() was a better
tradeoff.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
