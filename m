Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6V0DR4q110777 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 19:13:27 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	2TF2ICT3mWEeF2En for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 17:13:25 -0700 (PDT)
Date: Tue, 31 Jul 2012 10:13:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 4/4]xfs: xfs_seek_hole() refinements with lookup hole
	offset from page cache.
Message-ID: <20120731001322.GN2877@dastard>
References: <50110636.2010602@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50110636.2010602@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 26, 2012 at 04:56:22PM +0800, Jeff Liu wrote:
> Search possbile hole offset for given range from page cache for unwritten and delayed-allocation extents.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> ---
>  fs/xfs/xfs_file.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 80 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 15acd4d..1b83549 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1296,9 +1296,9 @@ xfs_seek_hole(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	loff_t			uninitialized_var(offset);
> -	loff_t			holeoff;
>  	xfs_fsize_t		isize;
>  	xfs_fileoff_t		fsbno;
> +	xfs_filblks_t		end;
>  	uint			lock;
>  	int			error;
>  
> @@ -1314,20 +1314,90 @@ xfs_seek_hole(
>  	}
>  
>  	fsbno = XFS_B_TO_FSBT(mp, start);
> -	error = xfs_bmap_first_unused(NULL, ip, 1, &fsbno, XFS_DATA_FORK);
> -	if (error)
> -		goto out_unlock;
> +	end = XFS_B_TO_FSB(mp, isize);
> +
> +	for (;;) {
> +		struct xfs_bmbt_irec	map[2];
> +		int			nmap = 2;
> +
> +		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
> +				       XFS_BMAPI_ENTIRE);
> +		if (error)
> +			goto out_unlock;
> +
> +		/* No extents at given offset, must be beyond EOF */
> +		if (nmap == 0) {
> +			error = ENXIO;
> +			goto out_unlock;
> +		}
>  
> -	holeoff = XFS_FSB_TO_B(mp, fsbno);
> -	if (holeoff <= start)
>  		offset = start;
> -	else {
> +		/* Landed in a hole, return */
> +		if (map[0].br_startblock == HOLESTARTBLOCK)
> +			break;
> +		else {
> +			/*
> +			 * Landed in an unwritten extent, try to lookup page
> +			 * cache to find holes.
> +			 */

Laned in a data extent is more correct here.

> +			if (map[0].br_state == XFS_EXT_UNWRITTEN ||
> +			    isnullstartblock(map[0].br_startblock)) {
> +				/* Probing page cache start from offset */
> +				if (xfs_find_get_desired_pgoff(inode, &map[0],
> +							HOLE_OFF, &offset))
> +					break;
> +			}

Same logic changes as previous patch:

		if (map[0].br_startblock == HOLESTARTBLOCK)
			break;
		else if (map[0].br_state == XFS_EXT_UNWRITTEN) {
			ASSERT(!isnullstartblock(map[0].br_startblock));

			/* Probing page cache start from offset */
			if (xfs_find_get_desired_pgoff(inode, &map[0],
						HOLE_OFF, &offset))
				break;
		} else {
			.....

>  		/*
> -		 * xfs_bmap_first_unused() could return a value bigger than
> -		 * isize if there are no more holes past the supplied offset.
> +		 * Both mappings contains data, proceed to the next round of
> +		 * search if the current reading offset not beyond or hit EOF.
>  		 */
> -		offset = min_t(loff_t, holeoff, isize);
> +		fsbno = map[1].br_startoff + map[1].br_blockcount;
> +		start = XFS_FSB_TO_B(mp, fsbno);
> +		if (start >= isize) {
> +			offset = isize;
> +			break;
> +		}

And that check can move to the start of the loop, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
