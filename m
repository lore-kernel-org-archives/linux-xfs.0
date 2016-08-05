Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 409707CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 19:05:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 11D658F8035
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 17:05:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	K6sg7pXsH4w6Z3BN for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2016 17:05:00 -0700 (PDT)
Date: Fri, 5 Aug 2016 10:03:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix bogus space reservation in
	xfs_iomap_write_allocate
Message-ID: <20160805000354.GD16044@dastard>
References: <1470245586-14068-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470245586-14068-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 07:33:06PM +0200, Christoph Hellwig wrote:
> The space reservations was without an explaination back in commit
> 
>     "Add error reporting calls in error paths that return EFSCORRUPTED"
> 
> back in 2003.  There is no reason to reserve disk blocks in the
> transaction when allocating blocks for delalloc space as we already
> reserved the space when creating the delalloc extent.
> 
> With this fix we stop running out of the reserved pool in generic/229,
> which has happened for long time with small blocksize file systems,
> and has increased in severity with the new buffered write path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 2114d53..279353c 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -691,7 +691,6 @@ xfs_iomap_write_allocate(
>  	xfs_trans_t	*tp;
>  	int		nimaps;
>  	int		error = 0;
> -	int		nres;
>  
>  	/*
>  	 * Make sure that the dquots are there.
> @@ -715,12 +714,15 @@ xfs_iomap_write_allocate(
>  		 * is in the delayed allocation extent on which we sit
>  		 * but before our buffer starts.
>  		 */
> -
>  		nimaps = 0;
>  		while (nimaps == 0) {
> -			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> -
> -			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, nres,
> +			/*
> +			 * We have already reserved space for the extent and any
> +			 * indirect blocks when creating the delalloc extent,
> +			 * there is no need to reserve space in this transaction
> +			 * again.
> +			 */
> +			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0,
>  					0, XFS_TRANS_RESERVE, &tp);
>  			if (error)
>  				return error;
> @@ -783,7 +785,7 @@ xfs_iomap_write_allocate(
>  			 */
>  			error = xfs_bmapi_write(tp, ip, map_start_fsb,
>  						count_fsb, 0, &first_block,
> -						nres, imap, &nimaps,
> +						0, imap, &nimaps,
>  						&dfops);

I don't think this part of the fix is correct. nres feeds into
args->total which is then used during the AGFL fixup checks. If this
is not set correctly, then we'll select AGs we have enough space in
the AG to fix up the AGFL, but not enough space to allocate all the
BMBT blocks we require. That then leads to ABBA deadlocks on AGF
locks near ENOSPC - see commit dbd5c8c ("xfs: pass total block
res. as total xfs_bmapi_write() parameter") for the full details.

I've been testing a local version of this fix since you pointed out
the problem that still passed nres into xfs_bmapi_write() and I
haven't seen any problems, so I think it is correct to keep nres
here. I'm going to drop this hunk from this patch for the moment in
my tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
