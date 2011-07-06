Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6632X28062660 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:02:33 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21E36179ABCE
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 20:02:31 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bfRqSZcsaJ5VXcWW for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 20:02:31 -0700 (PDT)
Date: Wed, 6 Jul 2011 13:02:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/27] xfs: avoid usage of struct xfs_dir2_data
Message-ID: <20110706030228.GM1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.003170984@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094606.003170984@bombadil.infradead.org>
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

On Fri, Jul 01, 2011 at 05:43:39AM -0400, Christoph Hellwig wrote:
> In most places we can simply pass around and use the struct xfs_dir2_data_hdr,
> which is the first and most important member of struct xfs_dir2_data instead
> of the full structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Only a couple of minor things.

....

> @@ -251,12 +258,13 @@ xfs_dir2_data_freeinsert(
>  	xfs_dir2_data_free_t	new;		/* new bestfree entry */
>  
>  #ifdef __KERNEL__
> -	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
> -	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
> +	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
> +	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
>  #endif

You kill the ifdef __KERNEL__ there.

> @@ -286,36 +294,36 @@ xfs_dir2_data_freeinsert(
>   */
>  STATIC void
>  xfs_dir2_data_freeremove(
> -	xfs_dir2_data_t		*d,		/* data block pointer */
> +	xfs_dir2_data_hdr_t	*hdr,		/* data block header */
>  	xfs_dir2_data_free_t	*dfp,		/* bestfree entry pointer */
>  	int			*loghead)	/* out: log data header */
>  {
>  #ifdef __KERNEL__
> -	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
> -	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
> +	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
> +	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
>  #endif

And there.

> @@ -335,23 +344,23 @@ xfs_dir2_data_freescan(
>  	char			*p;		/* current entry pointer */
>  
>  #ifdef __KERNEL__
> -	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
> -	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
> +	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
> +	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
>  #endif

I'll stop commenting on this now ;)

However, I have noticed that you've converted some of the magic
number compares to cpu_to_be32(XFS_DIR2_DATA_MAGIC) form and not
others. I'm not so concerned about the ASSERT()s, but some of the
real runtime checks are touched but not then not changed around.
Anyway, this can probably be done later as a separate cleanup.

>  			if (!needscan) {
> -				xfs_dir2_data_freeremove(d, dfp, needlogp);
> -				(void)xfs_dir2_data_freeinsert(d, newdup,
> +				xfs_dir2_data_freeremove(hdr, dfp, needlogp);
> +				(void)xfs_dir2_data_freeinsert(hdr, newdup,
>  					needlogp);
> -				(void)xfs_dir2_data_freeinsert(d, newdup2,
> +				(void)xfs_dir2_data_freeinsert(hdr, newdup2,
>  					needlogp);
>  			}
>  		}

Kill the (void) casts?

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
