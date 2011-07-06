Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p664A0X3065776 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 23:10:00 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF05D4D8BC
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 20:54:14 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yYeWkTwtZLIWJNiu for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 20:54:14 -0700 (PDT)
Date: Wed, 6 Jul 2011 13:54:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 26/27] xfs: cleanup I/O-related buffer flags
Message-ID: <20110706035411.GU1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094607.536262104@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094607.536262104@bombadil.infradead.org>
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

On Fri, Jul 01, 2011 at 05:43:47AM -0400, Christoph Hellwig wrote:
> Remove the unused and misnamed _XBF_RUN_QUEUES flag, rename XBF_LOG_BUFFER
> to the more fitting XBF_SYNCIO, and split XBF_ORDERED into XBF_FUA and
> XBF_FLUSH to allow more fine grained control over the bio flags.  Also
> cleanup processing of the flags in _xfs_buf_ioapply to make more sense,
> and renumber the sparse flag number space to group flags by purpose.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> -		bp->b_flags &= ~_XBF_RUN_QUEUES;
> -		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
> -	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
> -		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
> -		bp->b_flags &= ~_XBF_RUN_QUEUES;
> -		rw = (bp->b_flags & XBF_WRITE) ? WRITE_META : READ_META;
> +	if (bp->b_flags & XBF_WRITE) {
> +		if (bp->b_flags & XBF_SYNCIO)
> +			rw = WRITE_SYNC;
> +		else
> +			rw = WRITE;
> +		if (bp->b_flags & XBF_FUA)
> +			rw |= REQ_FUA;
> +		if (bp->b_flags & XBF_FLUSH)
> +			rw |= REQ_FLUSH;
> +	} else if (bp->b_flags & XBF_READ_AHEAD) {
> +		rw = READA;
>  	} else {
> -		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
> -		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
> +		rw = READ;
>  	}

Is it worthwhile tagging all these as READ_META and WRITE_META?
Though that probably needs to be done as a separate commit...

>  /* flags used only internally */
> -#define _XBF_PAGES	(1 << 18)/* backed by refcounted pages */
> -#define	_XBF_RUN_QUEUES	(1 << 19)/* run block device task queue	*/
> -#define	_XBF_KMEM	(1 << 20)/* backed by heap memory */
> -#define _XBF_DELWRI_Q	(1 << 21)/* buffer on delwri queue */
> +#define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
> +#define	_XBF_KMEM	(1 << 21)/* backed by heap memory */
> +#define _XBF_DELWRI_Q	(1 << 22)/* buffer on delwri queue */

Might be worthwhile cleaning up the stray tab before _XBF_KMEM
there.

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
