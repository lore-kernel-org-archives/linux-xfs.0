Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6EIPhCC158901 for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 13:25:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BBDE1D67F11
	for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 11:28:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oLYGSCGFRSvcnfAf for
	<xfs@oss.sgi.com>; Wed, 14 Jul 2010 11:28:39 -0700 (PDT)
Date: Wed, 14 Jul 2010 14:28:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: don't block on buffer read errors
Message-ID: <20100714182836.GA12108@infradead.org>
References: <1279007450-10457-1-git-send-email-david@fromorbit.com>
	<1279007450-10457-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279007450-10457-2-git-send-email-david@fromorbit.com>
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
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Looks good, except that I'd rework the snipplet below

>  	status = xfs_buf_iorequest(bp);
> -	if (!status && !(flags & XBF_ASYNC))
> +	if (!(status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC)))
>  		status = xfs_buf_iowait(bp);
>  	return status;

as:

	if (status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC))
		return status;
	return xfs_buf_iowait(bp);

to make it a bit more clear.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
