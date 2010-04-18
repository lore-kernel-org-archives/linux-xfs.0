Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3IHJNnr150119 for <xfs@oss.sgi.com>; Sun, 18 Apr 2010 12:19:23 -0500
Date: Sun, 18 Apr 2010 13:21:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 5/5] xfs: kill off l_sectbb_mask
Message-ID: <20100418172121.GB28944@infradead.org>
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
> -	uint			l_sectBBsize;   /* sector size in BBs */
> -	uint			l_sectbb_mask;  /* sector size (in BBs)
> -						 * alignment mask */
> +	uint			l_sectBBsize;   /* sector size in BBs (2^n) */

The 2^n comment doesn't make too much sense to me.

But in general looks good, nice cleanup.


Signed-off-by: Christoph Hellwig <hch@lst.de>

> @@ -128,14 +132,14 @@ xlog_align(
>  	int		nbblks,
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

And Dave's version of this assert definitively makes a lot more sense,
this is one while evolved from the previous one is rather ugly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
