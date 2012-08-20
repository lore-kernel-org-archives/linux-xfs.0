Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KNGACk012377 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 18:16:10 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SjBK6iredvu0ycf0 for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 16:16:09 -0700 (PDT)
Date: Tue, 21 Aug 2012 09:16:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 3/4] xfs: xfs_seek_data() refinement with unwritten
	extents check up from page cache
Message-ID: <20120820231607.GK19235@dastard>
References: <5028FC39.5060809@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5028FC39.5060809@oracle.com>
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

On Mon, Aug 13, 2012 at 09:08:09PM +0800, Jeff Liu wrote:
> Improve xfs_seek_data() to search data offset from page cache for unwritten extents.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

One minor addition, otherwise

Reviewed-by: Dave Chinner <dchinner@redhat.com>

....
> +
> +		/*
> +		 * map[0] is hole or its an unwritten extent but
> +		 * without data in page cache.  Probably means that
> +		 * we are reading after EOF if nothing in map[1].
> +		 */
>  		if (nmap == 1) {
>  			error = ENXIO;
>  			goto out_unlock;
>  		}
>  
> -		offset = max_t(loff_t, start,
> -			       XFS_FSB_TO_B(mp, map[1].br_startoff));
> +		/*
> +		 * Nothing was found, proceed to the next round of search
> +		 * if reading offset not beyond or hit EOF.
> +		 */

		ASSERT(i > 1);

> +		fsbno = map[i - 1].br_startoff + map[i - 1].br_blockcount;
> +		start = XFS_FSB_TO_B(mp, fsbno);
> +		if (start >= isize) {
> +			error = ENXIO;
> +			goto out_unlock;
> +		}
>  	}
>  
> +out:
>  	if (offset != file->f_pos)
>  		file->f_pos = offset;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
