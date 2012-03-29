Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2T0UWg5252696 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 19:30:32 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	usiVtC23rfpKXW5r for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 17:30:30 -0700 (PDT)
Date: Thu, 29 Mar 2012 11:30:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: kill b_file_offset
Message-ID: <20120329003029.GH5091@dastard>
References: <1332911958-5613-1-git-send-email-david@fromorbit.com>
	<1332911958-5613-3-git-send-email-david@fromorbit.com>
	<20120328152028.GA12205@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120328152028.GA12205@infradead.org>
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

On Wed, Mar 28, 2012 at 11:20:28AM -0400, Christoph Hellwig wrote:
> Looks good.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
> Minor comments below:
> 
> On Wed, Mar 28, 2012 at 04:19:16PM +1100, Dave Chinner wrote:
> > -	end = bp->b_file_offset + bp->b_buffer_length;
> > -	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(bp->b_file_offset);
> > +	end = BBTOB(bp->b_bn) + bp->b_buffer_length;
> > +	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(BBTOB(bp->b_bn));
> 
> Btw, xfs_buf_btoc and xfs_buf_btoct are more remoal candidates,
> they actually make the code harder to read compared to using the
> opencoded arithmetics..

Ok, I'll consider doing that in the next set of patches.

> >  	numbytes = numblks << BBSHIFT;
> >  
> >  	/* Check for IOs smaller than the sector size / not sector aligned */
> >  	ASSERT(!(numbytes < (1 << btp->bt_sshift)));
> > -	ASSERT(!(offset & (xfs_off_t)btp->bt_smask));
> > +	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));
> 
> I don't think it makes sense to keep this assert, given that the
> return value from BBTOB is aligned by defintion.

I kept them there for the 4k sector case. Basic Blocks are always
512 bytes, so for filesystems with sector sizes greater than 512
bytes we still need a sector alignment and size check.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
