Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5M6n1Xr236621 for <xfs@oss.sgi.com>; Fri, 22 Jun 2012 01:49:01 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GesHG9JQyQl8turL for <xfs@oss.sgi.com>;
	Thu, 21 Jun 2012 23:48:59 -0700 (PDT)
Date: Fri, 22 Jun 2012 16:48:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120622064854.GW19223@dastard>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-3-git-send-email-david@fromorbit.com>
	<20120620064824.GC14760@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620064824.GC14760@infradead.org>
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

On Wed, Jun 20, 2012 at 02:48:24AM -0400, Christoph Hellwig wrote:
> > +STATIC int
> > +_xfs_buf_get_maps(
> 
> Should this really be STATIC which prevents inlining even if the
> compiler thinks that's a good idea?  (Same for the free side)

Not really, just habit. I'll change it.

> Also any reason for the underscore in the naming?

Just that other internal functions used it. I'll remove it.

> > +	bp->b_bn = map[0].bm_bn;
> > +	bp->b_length = 0;
> > +	for (i = 0; i < nmaps; i++) {
> > +		bp->b_maps[i].bm_bn = map[i].bm_bn;
> > +		bp->b_maps[i].bm_len = map[i].bm_len;
> > +		bp->b_length += map[i].bm_len;
> > +	}
> > +	bp->b_io_length = bp->b_length;
> > +
> 
> > +	for (i = 0; i < nmaps; i++) {
> > +		numblks += map[i].bm_len;
> > +	}
> 
> no need for the curly braces here.

 ok.

> 
> > +	struct xfs_buf	*bp,
> > +	int		map,
> > +	int		*buf_offset,
> > +	int		*count,
> > +	int		rw)
> >  {
> > -	int			rw, map_i, total_nr_pages, nr_pages;
> > +	int			page_index;
> 
> The indentation for the arguments and local variables doesn't seem to
> line up here.

Oops, my bad. Will fix.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
