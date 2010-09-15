Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8F067GK155230 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 19:06:08 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0A6D73C38
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:06:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	tZleHgPkddHErAkt for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 17:06:55 -0700 (PDT)
Date: Wed, 15 Sep 2010 10:06:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/18] xfs: stop using the page cache to back the
	buffer cache
Message-ID: <20100915000648.GI15695@dastard>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-19-git-send-email-david@fromorbit.com>
	<20100914232004.GC29338@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100914232004.GC29338@infradead.org>
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

On Tue, Sep 14, 2010 at 07:20:04PM -0400, Christoph Hellwig wrote:
> On Tue, Sep 14, 2010 at 08:56:17PM +1000, Dave Chinner wrote:
> > The only open question is how to best handle sub-page buffers - can we use
> > kmalloc/slab memory for sub-page sized buffers, or do we need to split up
> > pages ourselves? Worth noting is that the current code still works on sub-page
> > block size filesystems, it is just inefficient w.r.t. memory usage.
> 
> As mentioned before I think we're fine to use slab/kmalloc pages now.
> In fact using them will probably be more efficient than the current
> code, given that at least btree blocks usually won't be close to each
> other, so the old code wasted lots of memory for it, too.

Good point. I'll start working on this later today.

> 
> >  	for (i = 0; i < bp->b_page_count; i++) {
> >  		struct page	*page;
> >  		uint		retries = 0;
> > +retry:
> > +		page = alloc_page(gfp_mask);
> >  		if (unlikely(page == NULL)) {
> >  			if (flags & XBF_READ_AHEAD) {
> >  				bp->b_page_count = i;
> >  				for (i = 0; i < bp->b_page_count; i++)
> > +					__free_page(bp->b_pages[i]);
> >  				return -ENOMEM;
> 
> Maybe convert this to and out_free_pages goto while you're at it?

Yes, sounds reasonable. Will do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
