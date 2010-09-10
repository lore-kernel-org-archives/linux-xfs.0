Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8A39Ohj128235 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 22:09:24 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C5891BA20C9
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 20:10:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	GsiUW6GWCLsXBURI for <xfs@oss.sgi.com>;
	Thu, 09 Sep 2010 20:10:07 -0700 (PDT)
Date: Fri, 10 Sep 2010 13:10:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: kill XBF_FS_MANAGED buffers
Message-ID: <20100910031004.GB24409@dastard>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
	<1283958778-28610-2-git-send-email-david@fromorbit.com>
	<20100909013312.GB29825@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100909013312.GB29825@infradead.org>
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

On Wed, Sep 08, 2010 at 09:33:13PM -0400, Christoph Hellwig wrote:
> Looks good, but a few comments below:
> 
> > +	bp = xfs_buf_get_noaddr(sector_size, mp->m_ddev_targp);
> > +
> >  	if (!bp || XFS_BUF_ISERROR(bp)) {
> 
> xfs_buf_get_noaddr will never return a buffer with an error set.

OK, will fix.

> > -	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
> > +
> > +	/* set up the buffer for a read IO */
> > +	xfs_buf_lock(bp);
> > +	XFS_BUF_SET_ADDR(bp, XFS_SB_DADDR);
> > +        XFS_BUF_READ(bp);
> > +        XFS_BUF_BUSY(bp);
> 
> Various indentation problems.

I'll fix all these by putting the uncached read function factoring
into an initial patch.

> > +	/* grab a reference for caching the buffer */
> > +        XFS_BUF_HOLD(bp);
> >  	mp->m_sb_bp = bp;
> > +
> >  	xfs_buf_relse(bp);
> 
> Grabbing the reference just to drop it three lines later is rather
> pointless, just remove both.

Except that xfs_buf_relse(bp) also unlocks bp. maybe I coul djust
make it do an explicit unlock....

> >  	ASSERT(XFS_BUF_VALUSEMA(bp) > 0);
> 
> Given that we took the lock a few lines above this one also feels rather
> poinless.

That's checking the buffer is unlocked, which could be removed if
there is an explicit unlock call. I'll do that.

> 
> > +fail:
> > +	if (bp)
> >  		xfs_buf_relse(bp);
> > -	}
> >  	return error;
> 
> I'd rather see this split into a fail_buf_relese label that puts the
> buffer, and a fail label that just returns the error.
> 
> >  	 * when we call xfs_buf_relse().
> >  	 */
> >  	bp = xfs_getsb(mp, 0);
> > -	XFS_BUF_UNMANAGE(bp);
> > -	xfs_buf_relse(bp);
> >  	mp->m_sb_bp = NULL;
> > +
> > +	/*
> > +	 * need to release the buffer twice to free it because we hold an extra
> > +	 * reference count on it.
> > +	 */
> > +	xfs_buf_relse(bp);
> > +	xfs_buf_relse(bp);
> 
> I'd rather rewrite xfs_freesb to not use xfs_getsb and thus avoid taking
> the superflous reference:
> 
> void
> xfs_freesb(
> 	struct xfs_mount	*mp);
> 
> 	struct xfs_buf		*bp = mp->m_sb_bp;
> 
> 	mp->m_sb_bp = NULL;
> 	if (xfs_buf_cond_lock(bp)
> 		BUG();
> 	xfs_buf_relse(bp);
> }

Yeah, that's better. I'll do that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
