Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6V06Lse110158 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 19:06:22 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MkS3nRNETYluuHfS for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 17:06:20 -0700 (PDT)
Date: Tue, 31 Jul 2012 10:06:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 3/4]xfs: xfs_seek_data() refinements with lookup data
	buffer offset from page cache.
Message-ID: <20120731000606.GM2877@dastard>
References: <50110630.7020902@oracle.com>
 <50116322.2020005@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50116322.2020005@oracle.com>
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

On Thu, Jul 26, 2012 at 11:32:50PM +0800, Jeff Liu wrote:
> Search data buffer offset for given range from page cache.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> ---
>  fs/xfs/xfs_file.c |   88 ++++++++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 70 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 69965a4..b1158b3 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1182,8 +1182,6 @@ xfs_seek_data(
>  	struct inode		*inode = file->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_bmbt_irec	map[2];
> -	int			nmap = 2;
>  	loff_t			uninitialized_var(offset);
>  	xfs_fsize_t		isize;
>  	xfs_fileoff_t		fsbno;
> @@ -1199,34 +1197,88 @@ xfs_seek_data(
>  		goto out_unlock;
>  	}
>  
> -	fsbno = XFS_B_TO_FSBT(mp, start);
> -
>  	/*
>  	 * Try to read extents from the first block indicated
>  	 * by fsbno to the end block of the file.
>  	 */
> +	fsbno = XFS_B_TO_FSBT(mp, start);
>  	end = XFS_B_TO_FSB(mp, isize);
> +	for (;;) {
> +		struct xfs_bmbt_irec	map[2];
> +		int			nmap = 2;
>  
> -	error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
> -			       XFS_BMAPI_ENTIRE);
> -	if (error)
> -		goto out_unlock;
> +		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
> +				       XFS_BMAPI_ENTIRE);
> +		if (error)
> +			goto out_unlock;
>  
> -	/*
> -	 * Treat unwritten extent as data extent since it might
> -	 * contains dirty data in page cache.
> -	 */
> -	if (map[0].br_startblock != HOLESTARTBLOCK) {
> -		offset = max_t(loff_t, start,
> -			       XFS_FSB_TO_B(mp, map[0].br_startoff));
> -	} else {
> -		if (nmap == 1) {
> +		/* No extents at given offset, must be beyond EOF */
> +		if (nmap == 0) {
>  			error = ENXIO;
>  			goto out_unlock;
>  		}
>  
>  		offset = max_t(loff_t, start,
> -			       XFS_FSB_TO_B(mp, map[1].br_startoff));
> +			       XFS_FSB_TO_B(mp, map[0].br_startoff));
> +		if (map[0].br_state == XFS_EXT_NORM &&
> +		    !isnullstartblock(map[0].br_startblock))
> +			break;
> +		else {
> +			/*
> +			 * Landed in an unwritten extent, try to lookup data

Not correct - hole, delay or unwritten land here.

> +			 * buffer from the page cache before proceeding to
> +			 * check the next extent map.  It's a hole if nothing
> +			 * was found.
> +			 */
> +			if (map[0].br_startblock == DELAYSTARTBLOCK ||
> +			    map[0].br_state == XFS_EXT_UNWRITTEN) {
> +				/* Probing page cache start from offset */
> +				if (xfs_find_get_desired_pgoff(inode, &map[0],
> +							DATA_OFF, &offset))
> +					break;
> +			}

If is is a DELAYSTARTBLOCK, and it is within EOF, then it is
guaranteed to contain data. There is no need for a page cache lookup
to decide where the data starts - by definition the data starts at
map[0].br_startblock. I think you can treat DELAYSTARTBLOCK exactly
the same as allocated XFS_EXT_NORM extents.

That means the logic is:

		if (map[0].br_state == XFS_EXT_NORM &&
		    (!isnullstartblock(map[0].br_startblock) ||
		     map[0].br_startblock == DELAYSTARTBLOCK)) {
			break;
		} else if (map[0].br_state == XFS_EXT_UNWRITTEN) {
			/* Probing page cache start from offset */
			if (xfs_find_get_desired_pgoff(inode, &map[0],
						DATA_OFF, &offset))
				break;
		} else {
			/*
			 * If we find a hole in map[0] and nothing in map[1] it
			 * probably means that we are reading after EOF.
			 */
			 .....
		}

Which kills a level of indentation in the code....


> +			/*
> +			 * Found a hole in map[0] and nothing in map[1].
> +			 * Probably means that we are reading after EOF.
> +			 */
> +			if (nmap == 1) {
> +				error = ENXIO;
> +				goto out_unlock;
> +			}
> +
> +			/*
> +			 * We have two mappings, proceed to check map[1].
> +			 */
> +			offset = max_t(loff_t, start,
> +				       XFS_FSB_TO_B(mp, map[1].br_startoff));
> +			if (map[1].br_state == XFS_EXT_NORM &&
> +			    !isnullstartblock(map[1].br_startblock))
> +				break;
> +			else {
> +				/*
> +				 * map[1] is also an unwritten extent, lookup
> +				 * data buffer from page cache now.
> +				 */
> +				if (map[1].br_startblock == DELAYSTARTBLOCK ||
> +				    map[1].br_state == XFS_EXT_UNWRITTEN) {
> +					if (xfs_find_get_desired_pgoff(inode,
> +						&map[1], DATA_OFF, &offset))
> +						break;
> +				}
> +			}

And the if/elseif/else logic above can be repeated here.

> +		}
> +
> +		/*
> +		 * Nothing was found, proceed to the next round of search if
> +		 * reading offset not beyond or hit EOF.
> +		 */
> +		fsbno = map[1].br_startoff + map[1].br_blockcount;
> +		start = XFS_FSB_TO_B(mp, fsbno);
> +		if (start >= isize) {
> +			error = ENXIO;
> +			goto out_unlock;
> +		}

Shouldn't this check be done at the start of the loop?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
