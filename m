Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NCZ5g7046749 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 07:35:05 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ygeLVgHRcoHGeXLu (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Oct 2012 05:36:48 -0700 (PDT)
Date: Tue, 23 Oct 2012 08:36:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 24/23] xfs: convert buffer verifiers to an ops structure.
Message-ID: <20121023123646.GJ7341@infradead.org>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
	<1350020669-19504-23-git-send-email-david@fromorbit.com>
	<20121013160212.GA24337@infradead.org>
	<20121014001219.GR2739@dastard> <20121018045028.GQ2739@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121018045028.GQ2739@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Oct 18, 2012 at 03:50:28PM +1100, Dave Chinner wrote:
> Here's a patch that does this. It adds on top of the series, and
> points out more changes needed to growfs to support CRC checking
> properly.

I like this a lot, and I'm fine with having this at the end of the
series if it makes your life easier.

> -xfs_agfl_write_verify(
> +xfs_agfl_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	xfs_agfl_verify(bp);
>  }
>  
>  static void
> -xfs_agfl_read_verify(
> +xfs_agfl_write_verify(
>  	struct xfs_buf	*bp)
>  {
>  	xfs_agfl_verify(bp);
> -	bp->b_pre_io = xfs_agfl_write_verify;
> -	bp->b_iodone = NULL;
> -	xfs_buf_ioend(bp, 0);
>  }

Any good reason to keep all these no-op wrappers?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
