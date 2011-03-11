Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2BMxetZ187141 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 16:59:45 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D2B11EBAD78
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 15:02:20 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yfzAgGsjxMeffgtB for <xfs@oss.sgi.com>;
	Fri, 11 Mar 2011 15:02:20 -0800 (PST)
Date: Sat, 12 Mar 2011 10:02:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: stop using the page cache to back the buffer cache
Message-ID: <20110311230215.GD15097@dastard>
References: <1299719104-11961-1-git-send-email-david@fromorbit.com>
	<20110311101642.GA15786@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110311101642.GA15786@infradead.org>
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
Cc: chris.mason@oracle.com, xfs@oss.sgi.com

On Fri, Mar 11, 2011 at 05:16:42AM -0500, Christoph Hellwig wrote:
> > +		if (((unsigned long)(bp->b_addr + bp->b_buffer_length - 1) &
> > +								PAGE_MASK) !=
> > +		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
> > +			/* b_addr spans two pages - use alloc_page instead */
> > +			kmem_free(bp->b_addr);
> > +			bp->b_addr = NULL;
> > +			goto use_alloc_page;
> > +		}
> 
> Did you manage to hit this case?  If it happens with any frequency under
> real workloads we really need to find a wayto avoid the allocation to
> start with.

It's the replacement for the assert that you managed to trigger in
the previous version. The assert fired if the returned memory
spanned two pages, so this is catching and handling that case if it
ever occurs. No, I haven't sen it trip, but then again I only ever
saw the previous assert fire once and was never able to reproduce
it.

I'd prefer to leave it there as a definsive mechanism, especially if
the kernel grows a new SLxB allocator with different behaviour...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
