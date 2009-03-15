Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2F7sfRF256913 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 02:55:01 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 291931C43052
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 00:53:58 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	eh1FZsIXCINzxcCy for <xfs@oss.sgi.com>;
	Sun, 15 Mar 2009 00:53:58 -0700 (PDT)
Date: Sun, 15 Mar 2009 18:53:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: cleanup xlog_bread
Message-ID: <20090315075356.GS26138@disturbed>
References: <20090220085207.663702000@bombadil.infradead.org>
	<20090220085229.488121000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090220085229.488121000@bombadil.infradead.org>
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

On Fri, Feb 20, 2009 at 03:52:11AM -0500, Christoph Hellwig wrote:
> Most callers of xlog_bread need to call xlog_align to get the actual offset.
> Consolidate that call into the main xlog_bread and provide a _xlog_bread
> for those few that don't want the actual offset.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

.....

>   * nbblks should be uint, but oh well.  Just want to catch that 32-bit length.
>   */
> -int
> -xlog_bread(
> +STATIC int
> +_xlog_bread(
>  	xlog_t		*log,
>  	xfs_daddr_t	blk_no,
>  	int		nbblks,
> @@ -137,6 +155,24 @@ xlog_bread(
>  	return error;
>  }

xlog_bread_noalign().

Otherwise looks good. Consider it:

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
