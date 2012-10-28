Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9SNJh3V080051 for <xfs@oss.sgi.com>; Sun, 28 Oct 2012 18:19:43 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Z8QUWTOABfjJCjjl for <xfs@oss.sgi.com>;
	Sun, 28 Oct 2012 16:21:30 -0700 (PDT)
Date: Mon, 29 Oct 2012 10:21:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 3/3] xfs: Print error when unable to allocate inodes
	or out of free inodes.
Message-ID: <20121028232124.GD4353@dastard>
References: <cover.1348641483.git.rprabhu@wnohang.net>
	<f0a97d0a46ee8f8bbc42a742274dde7a4c76801b.1348641483.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f0a97d0a46ee8f8bbc42a742274dde7a4c76801b.1348641483.git.rprabhu@wnohang.net>
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
To: raghu.prabhu13@gmail.com
Cc: bpm@sgi.com, elder@kernel.org, Raghavendra D Prabhu <rprabhu@wnohang.net>, xfs@oss.sgi.com

On Wed, Sep 26, 2012 at 12:26:49PM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> When xfs_dialloc is unable to allocate required number of inodes due to global
> ceiling, or AGs are out of free inodes but not allowed to allocate inodes or
> unable to allocate without continguous free space, printk the error in
> ratelimited manner.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  fs/xfs/xfs_ialloc.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index e75a39d..e9f911b2 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -991,7 +991,7 @@ xfs_dialloc(
>  
>  			xfs_perag_put(pag);
>  			*inop = NULLFSINO;
> -			return 0;
> +			goto out_spc;
>  		}

So this is the case where noroom = 0, okalloc = 1, error = ENOSPC.

This means we selected an AG that we could allocate new inodes in,
but xfs_ialloc_ag_alloc() failed because we are now over the
mp->m_maxicount. That's the only way it can return ENOSPC. More
below....

>  
>  		if (ialloced) {
> @@ -1017,7 +1017,7 @@ nextag:
>  			agno = 0;
>  		if (agno == start_agno) {
>  			*inop = NULLFSINO;
> -			return noroom ? ENOSPC : 0;
> +			goto out_spc;
>  		}
>  	}
>  
> @@ -1027,6 +1027,28 @@ out_alloc:
>  out_error:
>  	xfs_perag_put(pag);
>  	return XFS_ERROR(error);
> +out_spc:

Irrelevant given my next comments, but shouldn't that have been
called "out_nospace"?

> +	if (noroom) {
> +		xfs_err_ratelimited(mp, "Hit global inode ceiling:");
> +		error = ENOSPC;
> +	} else if (!okalloc) {
> +		/*
> +		 * implies noroom=0 && (!pag->pagi_freecount && !okalloc) for
> +		 * all pag
> +		 */
> +		xfs_err_ratelimited(mp,
> +			"No AGs with free inodes and allocation not allowed:");
> +		error = 0;
> +	} else {
> +		xfs_err_ratelimited(mp,
> +			"Unable to allocate continguous space for inodes:");
> +		error = 0;
> +	}

So for the first case we always get "Unable to allocate
continguous space for inodes:". That's wrong (see above) because
we've got the same error as if we were in the noroom case -
allocation is not allowed as we are above the max inode count. i.e:

"Unable to locate free inodes. Allocation failure reason:"
"Over global inode limit"

I think it is much better to issue the error message immediately and
returning instead of jumping to this code. That way we'll know
*exactly* what error occurred and it is simple to verify the message
is, in fact, correct.

In the second case, for both noroom states the second message (the
!okalloc message) is appropriate. We can be above the global inode
ceiling and still have free inodes available for allocation, and we
only fail if we are unable to locate free inodes for allocation.
i.e:

"Unable to locate free inodes. Allocation failure reason:"
if (noroom) {
	"Over global inode limit"
	error = ENOSPC;
else if (!okalloc)
	"Not allowed by caller"
else
	"Insufficient contiguous free space is available"

This is where separating the error messages from the location that
they are generated at is a bad idea - it's taken me 20 minutes of
code reading to get to this point, and for a patch that adds a
couple of error messages that's just, well, wrong.

If you are going to separate them write a small wrapper function
that has the above code snippet in it and takes a couple of boolean
flags to select the allocation failure reason....

> +
> +	xfs_err_ratelimited(mp, "Required %d, Current %llu, Maximum %llu",
> +		XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);

That's not completely correct, as we only require a single inode to
be allocated during this call. We only try to allocate an inode
chunk when there are no existing free inodes, but we still only
require 1 inode to be allocated to the caller. Hence I don't think
this is necessary information - we can get if from the superblock if
we really need it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
