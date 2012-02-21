Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1L5E8fq145672 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 23:14:08 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6AXonXNadlRUjXKx for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 21:14:06 -0800 (PST)
Date: Tue, 21 Feb 2012 16:14:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] xfs: make xfs_inode_item_size idempotent
Message-ID: <20120221051404.GM3592@dastard>
References: <20120221003824.415885674@bombadil.infradead.org>
	<20120221003907.081625923@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120221003907.081625923@bombadil.infradead.org>
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

On Mon, Feb 20, 2012 at 07:38:30PM -0500, Christoph Hellwig wrote:
> Move all code messing with the inode log item flags into xfs_inode_item_format
> to make sure xfs_inode_item_size really only calculates the the number of
> vectors, but doesn't modify any state of the inode item.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

One minor cleanup:

>  	case XFS_DINODE_FMT_LOCAL:
> -		ASSERT(!(iip->ili_format.ilf_fields &
> -			 (XFS_ILOG_ABROOT | XFS_ILOG_AEXT)));
> -		if (iip->ili_format.ilf_fields & XFS_ILOG_ADATA) {
> +		iip->ili_format.ilf_fields &=
> +			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
> +
> +		if ((iip->ili_format.ilf_fields & XFS_ILOG_ADATA) &&
> +		    ip->i_afp->if_bytes > 0) {
>  			ASSERT(ip->i_afp->if_bytes > 0);

That assert can go - it's checked in the if statement now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
