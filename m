Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3H1X1Ge027024 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 20:33:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 790CC12B5F6B
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 18:34:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	BDpNSfYL7XR93eUB for <xfs@oss.sgi.com>;
	Fri, 16 Apr 2010 18:34:57 -0700 (PDT)
Date: Sat, 17 Apr 2010 11:34:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2 5/5] xfs: kill off l_sectbb_mask
Message-ID: <20100417013454.GF2493@dastard>
References: <201004162054.o3GKs54f025204@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201004162054.o3GKs54f025204@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 16, 2010 at 03:54:05PM -0500, Alex Elder wrote:
> There remains only one user of the l_sectbb_mask field in the log
> structure.  Just kill it off and compute the mask where needed from
> the power-of-2 sector size.
> 
> (Only update from last post is to accomodate the changes in the
> previous patch in the series.)
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>  	xfs_buf_t	*bp)
>  {
> +	xfs_daddr_t	offset;
>  	xfs_caddr_t	ptr;
>  
> -	if (log->l_sectBBsize == 1)
> -		return XFS_BUF_PTR(bp);
> +	offset = blk_no & ((xfs_daddr_t) log->l_sectBBsize - 1);
> +	ptr = XFS_BUF_PTR(bp) + BBTOB(offset);
> +
> +	ASSERT(ptr + BBTOB(nbblks) <= XFS_BUF_PTR(bp) + XFS_BUF_SIZE(bp));

The ASSERT is more obfuscated than it needs to be. It's not obvious
that it is bounds checking offset+nbblks. i.e. I prefer the original
format like:

	ASSERT(BBTOB(offset + nbblks) <= XFS_BUF_SIZE(bp));

but otherwise it looks good. Anyway, minor nitpick, so:

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
