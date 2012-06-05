Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55DSw4l087559 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 08:28:59 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DFrC1BX13XYn93Wh for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 06:28:56 -0700 (PDT)
Date: Tue, 5 Jun 2012 23:28:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix overallocation in xfs_buf_allocate_memory()
Message-ID: <20120605132852.GB22848@dastard>
References: <1338894490-12662-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1338894490-12662-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

On Tue, Jun 05, 2012 at 01:08:10PM +0200, Jan Kara wrote:
> Commit 0e6e847f which introduced xfs_buf_allocate_memory() function has a bug
> causing the function to overestimate the number of necessary pages.

I don't think that commit is responsible at all - bp->b_bn was not
used at all originally - it was bp->b_file_offset that was used.

> The problem
> is that xfs_buf_alloc() sets b_bn to -1

Right, and the change that was made in commit de1cbee (xfs: kill
b_file_offset) changed that bp->b_file_offset to bp->b_bn, and that
is where the bug was introduced. This means it's only been present
in mainline since the 3.5-rc1 XFS merge....

> and thus effectively every buffer is
> straddling a page boundary which causes xfs_buf_allocate_memory() to allocate
> two pages and use vmalloc() for access which slows things down.

I did not notice this at all - it didn't cause me any problems or
slowdowns that I could measure in any benchmark I ran, so I'm
interested to know how you found it/noticed it....

> Fix the code to use correct block number.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_buf.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 172d3cc..b67cc83 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -296,6 +296,7 @@ xfs_buf_free(
>  STATIC int
>  xfs_buf_allocate_memory(
>  	xfs_buf_t		*bp,
> +	xfs_daddr_t		blkno,
>  	uint			flags)
>  {
>  	size_t			size;
> @@ -334,8 +335,8 @@ xfs_buf_allocate_memory(
>  	}
>  
>  use_alloc_page:
> -	start = BBTOB(bp->b_bn) >> PAGE_SHIFT;
> -	end = (BBTOB(bp->b_bn + bp->b_length) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	start = BBTOB(blkno) >> PAGE_SHIFT;
> +	end = (BBTOB(blkno + bp->b_length) + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	page_count = end - start;
>  	error = _xfs_buf_get_pages(bp, page_count, flags);
>  	if (unlikely(error))
> @@ -552,7 +553,7 @@ xfs_buf_get(
>  	if (unlikely(!new_bp))
>  		return NULL;
>  
> -	error = xfs_buf_allocate_memory(new_bp, flags);
> +	error = xfs_buf_allocate_memory(new_bp, blkno, flags);
>  	if (error) {
>  		kmem_zone_free(xfs_buf_zone, new_bp);
>  		return NULL;

While that will fix the problem, I think that I fixed the
underlying problem that required us to set bp->b_bn to -1 at
initialisation in that same series that introduced this problem.
That problem was that we were inserting buffers in a partially
intialised state into the cache and so we couldn't allow IO to be
started on them in the case of a lookup race before the final
initialisation was done. We could detect that case by checking for
bp->b_bn == -1 at any point in time.

We now don't insert the new buffer into the cache until it is fully
initialised, so we don't need to initialise bp->b_bn to -1 anymore -
it can be intialised to the correct block number, which we already
pass to xfs_buf_alloc() for the cached case. Hence I think that's
the better way to solve the problem. If this is done, then the
xfs_buf_alloc() call in xfs_buf_get_uncached() needs to pass
XFS_BUF_DADDR_NULL as the blkno rather than 0 as it currently
does....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
