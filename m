Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A75B47F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 17:51:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 59764AC003
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 15:51:16 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jAZPWWIOEaBWf4iY for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 15:51:14 -0800 (PST)
Date: Wed, 26 Feb 2014 10:51:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/10] repair: BMBT prefetch needs to be CRC aware
Message-ID: <20140225235112.GK13647@dastard>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-11-git-send-email-david@fromorbit.com>
	<20140225172518.GA12871@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225172518.GA12871@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 09:25:18AM -0800, Christoph Hellwig wrote:
> >  	/*
> >  	 * do some validation on the block contents
> >  	 */
> > -	if ((be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC) ||
> > +	if ((block->bb_magic != cpu_to_be32(XFS_BMAP_MAGIC) &&
> > +	     block->bb_magic != cpu_to_be32(XFS_BMAP_CRC_MAGIC)) ||
> >  			(be16_to_cpu(block->bb_level) != level))
> 
> Seems like this should be factored into a well-documented helper
> function.

Sure, but it's way outside the scope of fixing this bug.
We'd need to start with the kernel code, then port it is userspace
and propagate it into all the utilities. Patches welcome ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
