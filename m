Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p37LDSqE130754 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 16:13:28 -0500
Subject: Re: [PATCH 4/9] xfs: introduce background inode reclaim work
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1302141445-27457-5-git-send-email-david@fromorbit.com>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
	<1302141445-27457-5-git-send-email-david@fromorbit.com>
Date: Thu, 07 Apr 2011 16:16:22 -0500
Message-ID: <1302210982.2576.600.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-04-07 at 11:57 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Background inode reclaim needs to run more frequently that the XFS
> syncd work is run as 30s is too long between optimal reclaim runs.
> Add a new periodic work item to the xfs syncd workqueue to run a
> fast, non-blocking inode reclaim scan.
> 
> Background inode reclaim is kicked by the act of marking inodes for
> reclaim.  When an AG is first marked as having reclaimable inodes,
> the background reclaim work is kicked. It will continue to run
> periodically untill it detects that there are no more reclaimable
> inodes. It will be kicked again when the first inode is queued for
> reclaim.
> 
> To ensure shrinker based inode reclaim throttles to the inode
> cleaning and reclaim rate but still reclaim inodes efficiently, make it kick the
> background inode reclaim so that when we are low on memory we are
> trying to reclaim inodes as efficiently as possible. This kick shoul
> d not be necessary, but it will protect against failures to kick the
> background reclaim when inodes are first dirtied.
> 
> To provide the rate throttling, make the shrinker pass do
> synchronous inode reclaim so that it blocks on inodes under IO. This
> means that the shrinker will reclaim inodes rather than just
> skipping over them, but it does not adversely affect the rate of
> reclaim because most dirty inodes are already under IO due to the
> background reclaim work the shrinker kicked.
> 
> These two modifications solve one of the two OOM killer invocations
> Chris Mason reported recently when running a stress testing script.
> The particular workload trigger for the OOM killer invocation is
> where there are more threads than CPUs all unlinking files in an
> extremely memory constrained environment. Unlike other solutions,
> this one does not have a performance impact on performance when
> memory is not constrained or the number of concurrent threads
> operating is <= to the number of CPUs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> @@ -470,6 +469,52 @@ xfs_sync_worker(
>  }
>  
>  /*
> + * Queue a new inode reclaim pass if there are reclaimable inodes and there
> + * isn't a reclaim pass already in progress. By default it runs every 5s based
> + * on the xfs syncd work default of 30s. Perhaps this should have it's own

Agreed--I was going to say that but then I noticed your comment.

> + * tunable, but that can be done if this method proves to be ineffective or too
> + * aggressive.
> + */
> +static void
> +xfs_syncd_queue_reclaim(
> +	struct xfs_mount        *mp)
> +{
> +
> +	/*
> +	 * We can have inodes enter reclaim after we've shut down the syncd
> +	 * workqueue during unmount, so don't allow reclaim work to be queued
> +	 * during unmount.
> +	 */
> +	if (!(mp->m_super->s_flags & MS_ACTIVE))
> +		return;
> +
> +	rcu_read_lock();
> +	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
> +		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
> +			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));

Probably better to do the multiply before the divide here.
(But whatever... it's heuristic.)

> +	}
> +	rcu_read_unlock();
> +}
> +
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
