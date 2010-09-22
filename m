Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MHOV4u073772 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 12:24:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A46E183C697
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 10:25:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xQdVn2BfcMFnPuVu for
	<xfs@oss.sgi.com>; Wed, 22 Sep 2010 10:25:26 -0700 (PDT)
Date: Wed, 22 Sep 2010 13:25:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/16] xfs: rename xfs_buf_get_nodaddr to be more
	appropriate
Message-ID: <20100922172525.GC5697@infradead.org>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285137869-10310-6-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

>  xfs_buf_t *
> -xfs_buf_get_noaddr(
> +xfs_buf_get_uncached(
>  	size_t			len,
> +	int			flags,
>  	xfs_buftarg_t		*target)

Sorry for coming up with minor details like this again, but if we change
the name and signature anyway, can we please make the buftarg the first
argument, just like for the other buf helpers?

Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
