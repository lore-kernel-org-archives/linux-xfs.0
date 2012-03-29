Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2T0Vd5t253330 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 19:31:40 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5c0zGdlTHoNjV0Wd for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 17:31:38 -0700 (PDT)
Date: Thu, 29 Mar 2012 11:31:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: use blocks for counting length of buffers
Message-ID: <20120329003136.GI5091@dastard>
References: <1332911958-5613-1-git-send-email-david@fromorbit.com>
	<1332911958-5613-4-git-send-email-david@fromorbit.com>
	<20120328152639.GB12205@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120328152639.GB12205@infradead.org>
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

On Wed, Mar 28, 2012 at 11:26:39AM -0400, Christoph Hellwig wrote:
> > +			tmp = (valuelen < BBTOB(bp->b_length))
> > +				? valuelen : BBTOB(bp->b_length);
> 
> maybe use min or min_t here while you're at it?
> 
> > -		tmp = (valuelen < XFS_BUF_SIZE(bp)) ? valuelen :
> > -							XFS_BUF_SIZE(bp);
> > +		tmp = valuelen < BBTOB(bp->b_length) ? valuelen :
> > +						       BBTOB(bp->b_length);
> 
> Same here.
> 
> >  		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);
> > -		if (tmp < XFS_BUF_SIZE(bp))
> > -			xfs_buf_zero(bp, tmp, XFS_BUF_SIZE(bp) - tmp);
> > +		if (tmp < BBTOB(bp->b_length))
> > +			xfs_buf_zero(bp, tmp, BBTOB(bp->b_length) - tmp);
> 
> Also a local buf_len variable in this function would probably be useful.
> 
> > -	size_t			b_buffer_length;/* size of buffer in bytes */
> > +	size_t			b_length;	/* size of buffer in BBs */
> 
> A count of blocks probably shold not be a size_t, but a uint.
> 
> >  	TP_fast_assign(
> >  		__entry->dev = bp->b_target->bt_dev;
> >  		__entry->bno = bp->b_bn;
> > -		__entry->buffer_length = bp->b_buffer_length;
> > +		__entry->buffer_length = BBTOB(bp->b_length);
> 
> Given that we print the bno in blocks it might make sense to print
> this as number of blocks, too?  Change the description string to nblks
> in that case as well.

All makes sense. Will do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
