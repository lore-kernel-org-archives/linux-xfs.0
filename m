Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7A5mWuT161402 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 00:48:33 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23CFC6CB87
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2011 22:49:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lbSaocHoAJjoaOAs for <xfs@oss.sgi.com>;
	Tue, 09 Aug 2011 22:49:57 -0700 (PDT)
Date: Wed, 10 Aug 2011 15:48:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: Don't allocate new buffers on every call to
	_xfs_buf_find
Message-ID: <20110810054827.GZ3162@dastard>
References: <1312786271-10871-1-git-send-email-david@fromorbit.com>
	<1312786271-10871-2-git-send-email-david@fromorbit.com>
	<20110809075151.GA22968@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110809075151.GA22968@infradead.org>
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

On Tue, Aug 09, 2011 at 03:51:51AM -0400, Christoph Hellwig wrote:
> On Mon, Aug 08, 2011 at 04:51:10PM +1000, Dave Chinner wrote:
> > -xfs_buf_t *
> > +struct xfs_buf *
> >  xfs_buf_get(
> > -	xfs_buftarg_t		*target,/* target for buffer		*/
> > +	struct xfs_buftarg	*target,/* target for buffer		*/
> >  	xfs_off_t		ioff,	/* starting offset of range	*/
> >  	size_t			isize,	/* length of range		*/
> >  	xfs_buf_flags_t		flags)
> >  {
> > -	xfs_buf_t		*bp, *new_bp;
> > +	struct xfs_buf		*bp;
> > +	struct xfs_buf		*new_bp = NULL;
> >  	int			error = 0;
> >  
> > -	new_bp = xfs_buf_allocate(flags);
> > -	if (unlikely(!new_bp))
> > -		return NULL;
> > -
> > +again:
> >  	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
> > -	if (bp == new_bp) {
> > +	if (!(bp || new_bp)) {
> > +		new_bp = xfs_buf_allocate(flags);
> > +		if (unlikely(!new_bp))
> > +			return NULL;
> > +
> > +		_xfs_buf_initialize(new_bp, target, ioff << BBSHIFT,
> > +				isize << BBSHIFT, flags);
> > +		goto again;
> > +	}
> > +
> > +	if (!bp) {
> > +		xfs_buf_deallocate(new_bp);
> > +		return NULL;
> > +	} else if (bp == new_bp) {
> >  		error = xfs_buf_allocate_memory(bp, flags);
> >  		if (error)
> >  			goto no_buffer;
> > -	} else {
> > +	} else if (new_bp)
> >  		xfs_buf_deallocate(new_bp);
> > -		if (unlikely(bp == NULL))
> > -			return NULL;
> > -	}
> 
> The while loop looks a bit confusing to me.  Why not unroll it similar
> to how it's done for the VFS inode cache:
> 
> 	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
> 	if (bp)
> 		goto found;
> 
> 	new_bp = xfs_buf_allocate(flags);
> 	if (unlikely(!new_bp))
> 		return NULL;
> 	_xfs_buf_initialize(new_bp, target, ioff << BBSHIFT, isize << BBSHIFT,
> 			    flags);
> 	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
> 	if (!bp) {
> 		xfs_buf_deallocate(new_bp);
> 		return NULL;
> 	}
> 
> 	if (bp == new_bp) {
>   		error = xfs_buf_allocate_memory(bp, flags);
>   		if (error)
>   			goto no_buffer;
> 	}
> found:

Makes sense.

> or even better make sure all buffer initialization is done either as
> part of xfs_buf_find or the caller - although we'd need a variant
> with caller locking if we want to go down the latter route.  This
> variant would be nessecary if we ever want to add shared/exclusive or
> RCU locking for buffer lookup anyway.

I'll leave that problem for when RCU-izing the lookup - I haven't
quite worked out what the best way of doing that is yet, anyway.

> There's also some other weird things here that should be cleaned up
> when touching it:
> 
>  - we should never be able to find a buffer with the wrong mapped
>    state, so this could be replaced by an assert

OK.

>  - there should be no need to re-assign b_bn and b_count_desired
>    when we find a buffer

Yes, definitely.

I'm also tempted to rename some variables to make it more obvious
what units they are in and to reduce the conversions we do from
one type to another.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
