Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KNHahg012552 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 18:17:36 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	MSfGrkaQzmZQj5FQ for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 16:17:34 -0700 (PDT)
Date: Tue, 21 Aug 2012 09:17:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 4/4] xfs: xfs_seek_hole() refinement with hole
	searching from page cache for unwritten extent
Message-ID: <20120820231733.GL19235@dastard>
References: <5028FC3D.8000007@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5028FC3D.8000007@oracle.com>
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

On Mon, Aug 13, 2012 at 09:08:13PM +0800, Jeff Liu wrote:
> Improve xfs_seek_hole() to search hole offset from page cache for unwritten extents.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

same as previous patch.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> +		 */
> +		if (nmap == 1) {
> +			offset = isize;
> +			break;
> +		}
>  
> -	holeoff = XFS_FSB_TO_B(mp, fsbno);
> -	if (holeoff <= start)
> -		offset = start;
> -	else {
>  		/*
> -		 * xfs_bmap_first_unused() could return a value bigger than
> -		 * isize if there are no more holes past the supplied offset.
> +		 * Both mappings contains data, proceed to the next round of
> +		 * search if the current reading offset not beyond or hit EOF.
>  		 */
> -		offset = min_t(loff_t, holeoff, isize);

		ASSERT(i > 1);

> +		fsbno = map[i - 1].br_startoff + map[i - 1].br_blockcount;
> +		start = XFS_FSB_TO_B(mp, fsbno);
> +		if (start >= isize) {
> +			offset = isize;
> +			break;
> +		}
>  	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
