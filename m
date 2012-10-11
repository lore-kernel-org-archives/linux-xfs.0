Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BLsHvK245379 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 16:54:17 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zqTumEGyeLLfZhJK for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 14:55:49 -0700 (PDT)
Date: Fri, 12 Oct 2012 08:55:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/19] xfs: verify inode buffers as they are read from disk
Message-ID: <20121011215547.GH2739@dastard>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<1349754670-32009-9-git-send-email-david@fromorbit.com>
	<20121011214555.GH6346@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121011214555.GH6346@infradead.org>
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

On Thu, Oct 11, 2012 at 05:45:56PM -0400, Christoph Hellwig wrote:
> > +		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
> > +						XFS_ERRTAG_ITOBP_INOTOBP,
> > +						XFS_RANDOM_ITOBP_INOTOBP))) {
> > +			xfs_buf_ioerror(bp, EFSCORRUPTED);
> > +			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
> > +					     mp, dip);
> > +#ifdef DEBUG
> > +			xfs_emerg(mp,
> > +				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
> > +				(unsigned long long)bp->b_bn, i,
> > +				be16_to_cpu(dip->di_magic));
> > +			ASSERT(0);
> > +#endif
> 
> Is there any point in having this additional output in addition to the
> high error level corruption report above?

IMO, yes. It has the block number in it and it stops the operation
immediately, so you can look at it with xfs_db and see the current
state on disk without it being further modified. Otherwise all we
know is that an inode failed validation without any specific
information as to where it is.

It's quite a way down my list of things to do before I get to the
"put lots more information in failure messages" line item....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
