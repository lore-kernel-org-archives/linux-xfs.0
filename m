Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50662 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbeJaCqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 22:46:31 -0400
Date: Tue, 30 Oct 2018 10:51:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/7] repair: parallelise phase 6
Message-ID: <20181030175158.GL4135@magnolia>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030112043.6034-8-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:20:43PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A recent metadump provided to us caused repair to take hours in
> phase6. It wasn't IO bound - it was fully CPU bound the entire time.
> The only way to speed it up is to make phase 6 run multiple
> concurrent processing threads.
> 
> The obvious way to do this is to spread the concurrency across AGs,
> like the other phases, and while this works it is not optimal. When
> a processing thread hits a really large directory, it essentially
> sits CPU bound until that directory is processed. IF an AG has lots
> of large directories, we end up with a really long single threaded
> tail that limits concurrency.
> 
> Hence we also need to have concurrency /within/ the AG. This is
> realtively easy, as the inode chunk records allow for a simple
> concurrency mechanism within an AG. We can simply feed each chunk
> record to a workqueue, and we get concurrency within the AG for
> free. However, this allows prefetch to run way ahead of processing
> and this blows out the buffer cache size and can cause OOM.
> 
> However, we can use the new workqueue depth limiting to limit the
> number of inode chunks queued, and this then backs up the inode
> prefetching to it's maximum queue depth. Hence we prevent having the
> prefetch code queue the entire AG's inode chunks on the workqueue
> blowing out memory by throttling the prefetch consumer.
> 
> This takes phase 6 from taking many, many hours down to:
> 
> Phase 6:        10/30 21:12:58  10/30 21:40:48  27 minutes, 50 seconds
> 
> And burning 20-30 cpus that entire time on my test rig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/phase6.c | 43 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 35 insertions(+), 8 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 9477bc2527f3..422a53bca6c7 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -6,6 +6,7 @@
>  
>  #include "libxfs.h"
>  #include "threads.h"
> +#include "threads.h"
>  #include "prefetch.h"
>  #include "avl.h"
>  #include "globals.h"
> @@ -3169,20 +3170,45 @@ check_for_orphaned_inodes(
>  }
>  
>  static void
> -traverse_function(
> +do_dir_inode(
>  	struct workqueue	*wq,
> -	xfs_agnumber_t 		agno,
> +	xfs_agnumber_t		agno,
>  	void			*arg)
>  {
> -	ino_tree_node_t 	*irec;
> +	struct ino_tree_node	*irec = arg;
>  	int			i;
> +
> +	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
> +		if (inode_isadir(irec, i))
> +			process_dir_inode(wq->wq_ctx, agno, irec, i);
> +	}
> +}
> +
> +static void
> +traverse_function(
> +	struct workqueue	*wq,
> +	xfs_agnumber_t		agno,
> +	void			*arg)
> +{
> +	struct ino_tree_node	*irec;
>  	prefetch_args_t		*pf_args = arg;
> +	struct workqueue	lwq;
> +	struct xfs_mount	*mp = wq->wq_ctx;
> +
>  
>  	wait_for_inode_prefetch(pf_args);
>  
>  	if (verbose)
>  		do_log(_("        - agno = %d\n"), agno);
>  
> +	/*
> +	 * The more AGs we have in flight at once, the fewer processing threads
> +	 * per AG. This means we don't overwhelm the machine with hundreds of
> +	 * threads when we start acting on lots of AGs at once. We just want
> +	 * enough that we can keep multiple CPUs busy across multiple AGs.
> +	 */
> +	workqueue_create_bound(&lwq, mp, ag_stride, 1000);

Unlikely to happen, but do we need to check for errors here?
create_work_queue aborts repair if workqueue_create fails.

--D

> +
>  	for (irec = findfirst_inode_rec(agno); irec; irec = next_ino_rec(irec)) {
>  		if (irec->ino_isa_dir == 0)
>  			continue;
> @@ -3190,18 +3216,19 @@ traverse_function(
>  		if (pf_args) {
>  			sem_post(&pf_args->ra_count);
>  #ifdef XR_PF_TRACE
> +			{
> +			int	i;
>  			sem_getvalue(&pf_args->ra_count, &i);
>  			pftrace(
>  		"processing inode chunk %p in AG %d (sem count = %d)",
>  				irec, agno, i);
> +			}
>  #endif
>  		}
>  
> -		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
> -			if (inode_isadir(irec, i))
> -				process_dir_inode(wq->wq_ctx, agno, irec, i);
> -		}
> +		queue_work(&lwq, do_dir_inode, agno, irec);
>  	}
> +	destroy_work_queue(&lwq);
>  	cleanup_inode_prefetch(pf_args);
>  }
>  
> @@ -3229,7 +3256,7 @@ static void
>  traverse_ags(
>  	struct xfs_mount	*mp)
>  {
> -	do_inode_prefetch(mp, 0, traverse_function, false, true);
> +	do_inode_prefetch(mp, ag_stride, traverse_function, false, true);
>  }
>  
>  void
> -- 
> 2.19.1
> 
