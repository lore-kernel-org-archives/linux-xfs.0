Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8A3EAmt128485 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 22:14:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F014F1D85001
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 20:14:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	RZwJQXYjDRIHCUUB for <xfs@oss.sgi.com>;
	Thu, 09 Sep 2010 20:14:54 -0700 (PDT)
Date: Fri, 10 Sep 2010 13:14:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: use unhashed buffers for size checks
Message-ID: <20100910031452.GC24409@dastard>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
	<1283958778-28610-3-git-send-email-david@fromorbit.com>
	<20100909013806.GC29825@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100909013806.GC29825@infradead.org>
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

On Wed, Sep 08, 2010 at 09:38:07PM -0400, Christoph Hellwig wrote:
> > +struct xfs_buf *
> > +xfs_buf_read_uncached(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_buftarg	*target,
> > +	xfs_daddr_t		daddr,
> > +	size_t			length)
> > +{
> > +	xfs_buf_t	*bp;
> > +	int		error;
> 
> struct xfs_buf and the same indentation as the parameters, please.
> 
> > +
> > +	bp = xfs_buf_get_noaddr(length, target);
> 
> I think both the buf_get and buf_read interfaces for the non-hash
> buffers should have the same name.  Either your uncached or maybe better
> unhashed?  (And certainly no noaddr, which is not very useful)

I'll rename it *_uncached, because the hash is going away ;)

> 
> > +	if (!bp || XFS_BUF_ISERROR(bp))
> > +		goto fail;
> 
> xfs_buf_get_noaddr never returns an error in the buffer.

I'll fix all these - they are just CNP from the previous patch.
> 
> Also this one returns the buffer locked, while buf_get_noaddr doesn't.
> I suspect we should also change buf_get_noaddr to return a locked buffer
> to make it consistant with all other buf_read/get interfaces.

None of the other callers require locked buffers. I'll leave this
for a separate patch set for the moment.

> > +struct xfs_buf * xfs_buf_read_uncached(struct xfs_mount *mp,
> > +				struct xfs_buftarg *target,
> > +				xfs_daddr_t daddr, size_t length);
> 
> wrong placement of the *
> 
> 
> This patch, or at least the introduction of the new read helper should
> be moved before patch 1 so that we don't add code that gets removed a
> little later.

Yes, I plan to do that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
