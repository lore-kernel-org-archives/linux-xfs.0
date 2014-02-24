Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F22F97F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 14:43:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BB862304053
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 12:43:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FWj38EGtPQwkcCpH for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 12:43:10 -0800 (PST)
Date: Mon, 24 Feb 2014 15:43:05 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/10] repair: factor out threading setup code
Message-ID: <20140224204304.GB49654@bfoster.bfoster>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393223369-4696-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 24, 2014 at 05:29:24PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The same code is repeated in different places to set up
> multithreaded prefetching. This can all be factored into a single
> implementation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/dinode.h   | 15 ++++++------
>  repair/phase3.c   | 40 +++----------------------------
>  repair/phase4.c   | 48 +++----------------------------------
>  repair/phase6.c   | 22 ++++-------------
>  repair/prefetch.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  repair/prefetch.h | 10 ++++++++
>  6 files changed, 98 insertions(+), 108 deletions(-)
> 
...
> diff --git a/repair/phase6.c b/repair/phase6.c
> index cdbf4db..08f78d2 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -17,6 +17,8 @@
>   */
>  
>  #include <libxfs.h>
> +#include "threads.h"
> +#include "prefetch.h"
>  #include "avl.h"
>  #include "globals.h"
>  #include "agheader.h"
> @@ -25,9 +27,7 @@
>  #include "protos.h"
>  #include "err_protos.h"
>  #include "dinode.h"
> -#include "prefetch.h"
>  #include "progress.h"
> -#include "threads.h"
>  #include "versions.h"
>  
>  static struct cred		zerocr;
> @@ -3031,23 +3031,9 @@ update_missing_dotdot_entries(
>  
>  static void
>  traverse_ags(
> -	xfs_mount_t 		*mp)
> +	struct xfs_mount	*mp)
>  {
> -	int			i;
> -	work_queue_t		queue;
> -	prefetch_args_t		*pf_args[2];
> -
> -	/*
> -	 * we always do prefetch for phase 6 as it will fill in the gaps
> -	 * not read during phase 3 prefetch.
> -	 */
> -	queue.mp = mp;
> -	pf_args[0] = start_inode_prefetch(0, 1, NULL);
> -	for (i = 0; i < glob_agcount; i++) {
> -		pf_args[(~i) & 1] = start_inode_prefetch(i + 1, 1,
> -				pf_args[i & 1]);
> -		traverse_function(&queue, i, pf_args[i & 1]);
> -	}
> +	do_inode_prefetch(mp, 0, traverse_function, true, true);

The cover letter indicates the parallelization of phase 6 was dropped,
but this appears to (conditionally) enable it.

Brian

>  }
>  
>  void
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 984beda..e573e35 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -865,6 +865,77 @@ start_inode_prefetch(
>  	return args;
>  }
>  
> +/*
> + * Do inode prefetch in the most optimal way for the context under which repair
> + * has been run.
> + */
> +void
> +do_inode_prefetch(
> +	struct xfs_mount	*mp,
> +	int			stride,
> +	void			(*func)(struct work_queue *,
> +					xfs_agnumber_t, void *),
> +	bool			check_cache,
> +	bool			dirs_only)
> +{
> +	int			i, j;
> +	xfs_agnumber_t		agno;
> +	struct work_queue	queue;
> +	struct work_queue	*queues;
> +	struct prefetch_args	*pf_args[2];
> +
> +	/*
> +	 * If the previous phases of repair have not overflowed the buffer
> +	 * cache, then we don't need to re-read any of the metadata in the
> +	 * filesystem - it's all in the cache. In that case, run a thread per
> +	 * CPU to maximise parallelism of the queue to be processed.
> +	 */
> +	if (check_cache && !libxfs_bcache_overflowed()) {
> +		queue.mp = mp;
> +		create_work_queue(&queue, mp, libxfs_nproc());
> +		for (i = 0; i < mp->m_sb.sb_agcount; i++)
> +			queue_work(&queue, func, i, NULL);
> +		destroy_work_queue(&queue);
> +		return;
> +	}
> +
> +	/*
> +	 * single threaded behaviour - single prefetch thread, processed
> +	 * directly after each AG is queued.
> +	 */
> +	if (!stride) {
> +		queue.mp = mp;
> +		pf_args[0] = start_inode_prefetch(0, dirs_only, NULL);
> +		for (i = 0; i < mp->m_sb.sb_agcount; i++) {
> +			pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
> +					dirs_only, pf_args[i & 1]);
> +			func(&queue, i, pf_args[i & 1]);
> +		}
> +		return;
> +	}
> +
> +	/*
> +	 * create one worker thread for each segment of the volume
> +	 */
> +	queues = malloc(thread_count * sizeof(work_queue_t));
> +	for (i = 0, agno = 0; i < thread_count; i++) {
> +		create_work_queue(&queues[i], mp, 1);
> +		pf_args[0] = NULL;
> +		for (j = 0; j < stride && agno < mp->m_sb.sb_agcount;
> +				j++, agno++) {
> +			pf_args[0] = start_inode_prefetch(agno, dirs_only,
> +							  pf_args[0]);
> +			queue_work(&queues[i], func, agno, pf_args[0]);
> +		}
> +	}
> +	/*
> +	 * wait for workers to complete
> +	 */
> +	for (i = 0; i < thread_count; i++)
> +		destroy_work_queue(&queues[i]);
> +	free(queues);
> +}
> +
>  void
>  wait_for_inode_prefetch(
>  	prefetch_args_t		*args)
> diff --git a/repair/prefetch.h b/repair/prefetch.h
> index 44a406c..b837752 100644
> --- a/repair/prefetch.h
> +++ b/repair/prefetch.h
> @@ -4,6 +4,7 @@
>  #include <semaphore.h>
>  #include "incore.h"
>  
> +struct work_queue;
>  
>  extern int 	do_prefetch;
>  
> @@ -41,6 +42,15 @@ start_inode_prefetch(
>  	prefetch_args_t		*prev_args);
>  
>  void
> +do_inode_prefetch(
> +	struct xfs_mount	*mp,
> +	int			stride,
> +	void			(*func)(struct work_queue *,
> +					xfs_agnumber_t, void *),
> +	bool			check_cache,
> +	bool			dirs_only);
> +
> +void
>  wait_for_inode_prefetch(
>  	prefetch_args_t		*args);
>  
> -- 
> 1.8.4.rc3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
