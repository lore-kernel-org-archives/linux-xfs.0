Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5Q2c4Yg046958 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 21:38:04 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EDDahxK0WVjYpCG4 for <xfs@oss.sgi.com>;
	Mon, 25 Jun 2012 19:38:03 -0700 (PDT)
Date: Tue, 26 Jun 2012 12:38:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: probe data buffer from page cache for unwritten
	extents
Message-ID: <20120626023800.GE19223@dastard>
References: <4FE85C7B.3010909@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FE85C7B.3010909@oracle.com>
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

On Mon, Jun 25, 2012 at 08:41:31PM +0800, Jeff Liu wrote:
> Hello,
> 
> Using the start offset rather than map->br_startoff to calculate the starting page index could
> get more accurate data offset in page cache probe routine.
> With this refinement, the old max_t() could be able to remove too. 
....
> +			}
> +			/*
> +			 * xfs_bmapi_read() can handle repeated hole regions,
> +			 * hence it should not return two extents both are
> +			 * holes.  If the 2nd extent is unwritten, there must
> +			 * have data buffer resides in page cache.
> +			 */
> +			BUG();

That's wrong. A hole can be up to 32bits in length. When the hole is
longer than that, you'll get two extents that are holes. Try working
with sparse files that have holes in the order of a 100TB in them...

Also, as I've said before - BUG() does not belong in filesystem code
that can return an error. Shut the filesystem down with an in-memory
corruption error and maybe put an ASSERT(0) there so debug kernels
trip over it. However, no filesystem "can not happen" logic error is
a reason to panic a production machine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
