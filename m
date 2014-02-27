Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A5C7529DF7
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 08:08:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35D74AC00E
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 06:08:50 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6XaoUEmlsA6RqMFP for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 06:08:49 -0800 (PST)
Date: Thu, 27 Feb 2014 09:08:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/10] repair: prefetch runs too far ahead
Message-ID: <20140227140846.GB62463@bfoster.bfoster>
References: <1393494675-30194-1-git-send-email-david@fromorbit.com>
	<1393494675-30194-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393494675-30194-10-git-send-email-david@fromorbit.com>
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

On Thu, Feb 27, 2014 at 08:51:14PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 

Hmm, I replied to this one in the previous thread, but now I notice that
it apparently never made it to the list. Dave, did you happen to see
that in your inbox? Anyways, I had a couple minor comments/questions
that I'll duplicate here (which probably don't require another
repost)...

> When trying to work out why a non-crc filesystem took 1m57 to repair
> and the same CRC enabled filesystem took 11m35 to repair, I noticed
> that the was way to much CRC checking going on. Prefetched buffers
       there
> should not be being CRCed, yet shortly after the starting this began
		^?				^?
> to happen. perf profiling also showed up an awful lot of time doing
> buffer cache lookups, and the cache profile output indicated that
> the hit rate was way below 3%. IOWs, the readahead was getting so
> far ahead of the processing that it was thrashing the cache.
> 
> That there is a difference in processing rate between CRC and
> non-CRC filesystems is not surprising. What is surprising is the
> readahead behaviour - it basically just keeps reading ahead until it
> has read everything on an AG, and then it goes on to the next AG,
> and reads everything on it, and then goes on to the next AG,....
> 
> This goes on until it pushes all the buffers the processing threads
> need out of the cache, and suddening they start re-reading from disk
			     suddenly
> with the various CRC checking verifiers enabled, and we end up going
> -really- slow. Yes, threading made up for it a bit, but it's just
> wrong.
> 
> Basically, the code assumes that IO is going to be slower than
> processing, so it doesn't throttle prefetch across AGs to slow
> down prefetch to match the processing rate.
> 
> So, to fix this, don't let a prefetch thread get more than a single
> AG ahead of it's processing thread, just like occurs for single
> threaded (i.e. -o ag_stride=-1) operation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/prefetch.c | 79 ++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 61 insertions(+), 18 deletions(-)
> 
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index aee6342..7d3efde 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -866,6 +866,48 @@ start_inode_prefetch(
>  	return args;
>  }
>  

A brief comment before the prefetch_ag_range bits that explain the
implicit design constraints (e.g., throttle prefetch based on
processing) would be nice. :)

> +void
> +prefetch_ag_range(
> +	struct work_queue	*work,
> +	xfs_agnumber_t		start_ag,
> +	xfs_agnumber_t		end_ag,
> +	bool			dirs_only,
> +	void			(*func)(struct work_queue *,
> +					xfs_agnumber_t, void *))
> +{
> +	int			i;
> +	struct prefetch_args	*pf_args[2];
> +
> +	pf_args[start_ag & 1] = start_inode_prefetch(start_ag, dirs_only, NULL);
> +	for (i = start_ag; i < end_ag; i++) {
> +		/* Don't prefetch end_ag */
> +		if (i + 1 < end_ag)
> +			pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
> +						dirs_only, pf_args[i & 1]);
> +		func(work, i, pf_args[i & 1]);
> +	}
> +}
> +
> +struct pf_work_args {
> +	xfs_agnumber_t	start_ag;
> +	xfs_agnumber_t	end_ag;
> +	bool		dirs_only;
> +	void		(*func)(struct work_queue *, xfs_agnumber_t, void *);
> +};
> +
> +static void
> +prefetch_ag_range_work(
> +	struct work_queue	*work,
> +	xfs_agnumber_t		unused,
> +	void			*args)
> +{
> +	struct pf_work_args *wargs = args;
> +
> +	prefetch_ag_range(work, wargs->start_ag, wargs->end_ag, 
> +			  wargs->dirs_only, wargs->func);
> +	free(args);
> +}
> +
>  /*
>   * Do inode prefetch in the most optimal way for the context under which repair
>   * has been run.
> @@ -879,11 +921,9 @@ do_inode_prefetch(
>  	bool			check_cache,
>  	bool			dirs_only)
>  {
> -	int			i, j;
> -	xfs_agnumber_t		agno;
> +	int			i;
>  	struct work_queue	queue;
>  	struct work_queue	*queues;
> -	struct prefetch_args	*pf_args[2];
>  
>  	/*
>  	 * If the previous phases of repair have not overflowed the buffer
> @@ -906,12 +946,8 @@ do_inode_prefetch(
>  	 */
>  	if (!stride) {
>  		queue.mp = mp;
> -		pf_args[0] = start_inode_prefetch(0, dirs_only, NULL);
> -		for (i = 0; i < mp->m_sb.sb_agcount; i++) {
> -			pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
> -					dirs_only, pf_args[i & 1]);
> -			func(&queue, i, pf_args[i & 1]);
> -		}
> +		prefetch_ag_range(&queue, 0, mp->m_sb.sb_agcount,
> +				  dirs_only, func);
>  		return;
>  	}
>  
> @@ -919,20 +955,27 @@ do_inode_prefetch(
>  	 * create one worker thread for each segment of the volume
>  	 */
>  	queues = malloc(thread_count * sizeof(work_queue_t));
> -	for (i = 0, agno = 0; i < thread_count; i++) {
> +	for (i = 0; i < thread_count; i++) {
> +		struct pf_work_args *wargs;
> +
> +		wargs = malloc(sizeof(struct pf_work_args));
> +		wargs->start_ag = i * stride;
> +		wargs->end_ag = min((i + 1) * stride,
> +				    mp->m_sb.sb_agcount);
> +		wargs->dirs_only = dirs_only;
> +		wargs->func = func;
> +
>  		create_work_queue(&queues[i], mp, 1);
> -		pf_args[0] = NULL;
> -		for (j = 0; j < stride && agno < mp->m_sb.sb_agcount;
> -				j++, agno++) {
> -			pf_args[0] = start_inode_prefetch(agno, dirs_only,
> -							  pf_args[0]);
> -			queue_work(&queues[i], func, agno, pf_args[0]);
> -		}
> +		queue_work(&queues[i], prefetch_ag_range_work, 0, wargs);
> +
> +		if (wargs->end_ag >= mp->m_sb.sb_agcount)
> +			break;
>  	}

Ok, so instead of giving prefetch a green light on every single AG (and
queueing the "work" functions), we queue a series of prefetch(next) then
do_work() instances based on the stride. The prefetch "greenlight" (to
distinguish from the prefetch itself) is now offloaded to the threads
doing the work, which will only green light the next AG in the sequence.

The code looks reasonable to me. Does the non-crc fs referenced in the
commit log to repair at 1m57 still run at that rate with this enabled?

Brian

> +
>  	/*
>  	 * wait for workers to complete
>  	 */
> -	for (i = 0; i < thread_count; i++)
> +	for (; i >= 0; i--)
>  		destroy_work_queue(&queues[i]);
>  	free(queues);
>  }
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
