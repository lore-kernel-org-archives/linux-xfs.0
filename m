Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q182fTkY026716 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 20:41:30 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	j64kBcqLWZZxczBD for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 18:41:27 -0800 (PST)
Date: Wed, 8 Feb 2012 13:41:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: rfc: drop support for historic fs formats from xfsprogs
Message-ID: <20120208024124.GB20305@dastard>
References: <20120207182902.GA22486@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120207182902.GA22486@infradead.org>
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

On Tue, Feb 07, 2012 at 01:29:02PM -0500, Christoph Hellwig wrote:
> While doing a lot of xfs_repair work I noticed that there's a lot of
> effort spent on handling historic filesystem features.  The two that
> make my life in repair hard are mostly:
> 
>  - unaligned inodes
>  - dirv1
> 
> none of which every made it to production on Linux.  I'd like to suggest
> to drop support for old filesystem features before a certain cut off
> date after we release the currently pending xfsprogs 3.1.8 release.

That seems like a good idea to me - less code to support in future,
and I'd say taht code is rarely, if ever, tested to work these days.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
