Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3U2jja2189691 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 21:45:45 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lO9ecdbE9WOl8Y6V for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 19:45:44 -0700 (PDT)
Date: Mon, 30 Apr 2012 12:45:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 37/37] xfs: make XBF_MAPPED the default behaviour
Message-ID: <20120430024542.GE7015@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-38-git-send-email-david@fromorbit.com>
	<20120429215728.GP19889@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429215728.GP19889@infradead.org>
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

On Sun, Apr 29, 2012 at 05:57:28PM -0400, Christoph Hellwig wrote:
> > @@ -399,8 +399,9 @@ _xfs_buf_map_pages(
> >  	if (bp->b_page_count == 1) {
> >  		/* A single page buffer is always mappable */
> >  		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
> > -		bp->b_flags |= XBF_MAPPED;
> > -	} else if (flags & XBF_MAPPED) {
> > +	} else if (flags & XBF_UNMAPPED) {
> > +		bp->b_addr = NULL;
> 
> Do we need this explicit assigned?  The buffer should always have
> b_addr == NULL at this point.

True. I'll change it to an ASSERT.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
