Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3IHRbWb150501 for <xfs@oss.sgi.com>; Sun, 18 Apr 2010 12:27:37 -0500
Date: Sun, 18 Apr 2010 13:29:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 5/5] xfs: kill off l_sectbb_mask
Message-ID: <20100418172935.GA1677@infradead.org>
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
> + * Return the address of the start of the given block number's data
> + * in a log buffer.  The buffer covers a log sector-aligned region.
> + */
>  STATIC xfs_caddr_t
>  xlog_align(
>  	xlog_t		*log,
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
>  
> -	ptr = XFS_BUF_PTR(bp) + BBTOB((int)blk_no & log->l_sectbb_mask);
> -	ASSERT(XFS_BUF_SIZE(bp) >=
> -		BBTOB(nbblks + (blk_no & log->l_sectbb_mask)));
>  	return ptr;

And btw, now that I think about it we can just remove the
log->l_sectBBsize == 1 case entirely, so the whole thing could become:

STATIC xfs_caddr_t
xlog_align(
	struct log	*log,
	xfs_daddr_t	blk_no,
	int		nbblks,
	struct xfs_buf	*bp)
{
	xfs_daddr_t	offset;

	offset = blk_no & ((xfs_daddr_t) log->l_sectBBsize - 1);
	ASSERT(BBTOB(offset + nbblks) <= XFS_BUF_SIZE(bp));

	return XFS_BUF_PTR(bp) + BBTOB(offset);
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
