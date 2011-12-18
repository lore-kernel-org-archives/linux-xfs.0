Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIMslBF257270 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 16:54:47 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	0AwGdzGBeuPofRe0 for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 14:54:46 -0800 (PST)
Date: Sun, 18 Dec 2011 17:54:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/12] repair: use recursive buffer locking
Message-ID: <20111218225445.GB20578@infradead.org>
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174742.106589485@bombadil.infradead.org>
	<20111213022208.GZ14273@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111213022208.GZ14273@dastard>
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

On Tue, Dec 13, 2011 at 01:22:08PM +1100, Dave Chinner wrote:
> >  	if (use_xfs_buf_lock) {
> > -		if (flags & LIBXFS_GETBUF_TRYLOCK) {
> > -			int ret;
> > +		int ret;
> >  
> > -			ret = pthread_mutex_trylock(&bp->b_lock);
> > -			if (ret) {
> > -				ASSERT(ret == EAGAIN);
> > -				cache_node_put(libxfs_bcache, (struct cache_node *)bp);
> > -				return NULL;
> > +		ret = pthread_mutex_trylock(&bp->b_lock);
> > +		if (ret) {
> > +			ASSERT(ret == EAGAIN);
> > +			if (flags & LIBXFS_GETBUF_TRYLOCK)
> > +				goto out_put;
> > +
> > +			if (pthread_equal(bp->b_holder, pthread_self())) {
> > +				fprintf(stderr,
> > +	_("recursive buffer locking detected\n"));
> 
> "Warning: recursive buffer locking @ bno %lld detected"
> 
> might be more informative, especially to do with the severity of the
> issue.

Ok, I'll make it print the block number.

> 
> > +				bp->b_recur++;
> > +			} else {
> > +				pthread_mutex_lock(&bp->b_lock);
> >  			}
> > -		} else {
> > -			pthread_mutex_lock(&bp->b_lock);
> >  		}
> > +
> > +		bp->b_holder = pthread_self();
> 
> That should probably only be written in the branch where the lock is
> taken not every time through here.

We actually should return the buffer just after incrementing the
recursion count, else we might add it to the global list of buffers
twice.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
