Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUMIwBb234858 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 16:18:58 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	C0Cr7CV0WlPp1VdF for <xfs@oss.sgi.com>;
	Fri, 30 Nov 2012 14:21:17 -0800 (PST)
Date: Sat, 1 Dec 2012 09:21:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/3] xfs: use b_maps[] for discontiguous buffers
Message-ID: <20121130222110.GB12955@dastard>
References: <20121128222309.109033307@.sgi.com>
	<20121128222622.688093599@sgi.com>
	<20121130160920.GA9873@infradead.org> <50B8F2FC.6060501@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B8F2FC.6060501@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Nov 30, 2012 at 11:55:08AM -0600, Mark Tinguely wrote:
> On 11/30/12 10:09, Christoph Hellwig wrote:
> >>  use_alloc_page:
> >>-	start = BBTOB(bp->b_map.bm_bn)>>  PAGE_SHIFT;
> >>-	end = (BBTOB(bp->b_map.bm_bn + bp->b_length) + PAGE_SIZE - 1)
> >>+	start = BBTOB(bp->b_maps[0].bm_bn)>>  PAGE_SHIFT;
> >>+	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
> >
> >Btw, how is this logic supposed to work for discontiguous buffers?
> >
> >Each of them might straddle boundaries individually, so doing the
> >start/end calculation for the number of pages isn't going to be correct.
> >
> 
> eeek. yep, I will loop through and count the pages needed in each
> segment.

That's wrong - the pages must be mappable as a contiguous memory
range. That's how this code avoids copying the data from
discontiguous page ranges into a contiguous mapped memory range.
If you separate each IO into to it's own set of pages, then you have
to completely rewrite _xfs_buf_ioapply(), which AFAICT works just
fine with the page allocation that is done right now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
