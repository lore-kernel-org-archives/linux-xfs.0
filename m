Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUMGQM8234526 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 16:16:26 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	H7LUd0N72jV1oEFd for <xfs@oss.sgi.com>;
	Fri, 30 Nov 2012 14:18:44 -0800 (PST)
Date: Sat, 1 Dec 2012 09:18:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/3] xfs: use b_maps[] for discontiguous buffers
Message-ID: <20121130221826.GA12955@dastard>
References: <20121128222309.109033307@.sgi.com>
	<20121128222622.688093599@sgi.com>
	<20121130160920.GA9873@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121130160920.GA9873@infradead.org>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Fri, Nov 30, 2012 at 11:09:20AM -0500, Christoph Hellwig wrote:
> >  use_alloc_page:
> > -	start = BBTOB(bp->b_map.bm_bn) >> PAGE_SHIFT;
> > -	end = (BBTOB(bp->b_map.bm_bn + bp->b_length) + PAGE_SIZE - 1)
> > +	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
> > +	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
> 
> Btw, how is this logic supposed to work for discontiguous buffers?
> 
> Each of them might straddle boundaries individually, so doing the
> start/end calculation for the number of pages isn't going to be correct.

AFAICT it is correct - the first page is always aligned to the start
of the buffer (i.e. b_offset = 0), and the end is extended to ensure
that it covers any partial tail page. e.g:

Page	0		1		2
	+---------------+---------------+---------------+
map[0]	|----------|
map[1]		   |------------|
map[2]				|--------------|
        |---------------bp->b_length-----------|
	|						|
	start						end

Maps are always multiples of basic blocks, so every segment boundary
aligns to something that IO can be done on, and the array of pages
always spans the entire range of the maps.

Hence I'm not sure what the problem is here, Christoph. Can you
expand on the issue?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
