Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p37LVmkE132233 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 16:31:49 -0500
Subject: Re: [PATCH 2/9] xfs: introduce a xfssyncd workqueue
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1302141445-27457-3-git-send-email-david@fromorbit.com>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
	<1302141445-27457-3-git-send-email-david@fromorbit.com>
Date: Thu, 07 Apr 2011 16:34:53 -0500
Message-ID: <1302212093.2576.610.camel@doink>
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
> All of the work xfssyncd does is background functionality. There is
> no need for a thread per filesystem to do this work - it can al be
> managed by a global workqueue now they manage concurrency
> effectively.
> 
> Introduce a new gglobal xfssyncd workqueue, and convert the periodic
> work to use this new functionality. To do this, use a delayed work
> construct to schedule the next running of the periodic sync work
> for the filesystem. When the sync work is complete, queue a new
> delayed work for the next running of the sync work.
> 
> For laptop mode, we wait on completion for the sync works, so ensure
> that the sync work queuing interface can flush and wait for work to
> complete to enable the work queue infrastructure to replace the
> current sequence number and wakeup that is used.
> 
> Because the sync work does non-trivial amounts of work, mark the
> new work queue as CPU intensive.

(I've now seen your next patch so my confusion is I
think resolved.  I'm sending the following as I originally
wrote it anyway.)

I have two comments below.  One is something that can be
fixed later and another I think may be a problem.  I also
was just a little confused about something.

The confusing thing is that you still are spawning a kernel
thread per filesystem in xfs_syncd_init(), which is still
waiting xfs_syncd_centisecs between runs, and which is
then running work queued on the mount point's m_sync_list.

I *think* the reason it's confusing is just that your
description talks about "all of the work xfssyncd does,"
while this patch just pulls out the data syncing portion
of what it does.  The patch preserves the ability to make
use of the per-FS periodic syncer thread to flush inodes
(via xfs_flush_inodes()).

In any case, with the exception of the timeout thing
below (which ought to be easy to fix) the code looks
correct to me.  It just took me a little while to
reconcile the what the delayed workqueues (named
"xfssyncd") do, versus what the xfssyncd" threads
that remain do.

Despite the above, you can consider this reviewed by me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/linux-2.6/xfs_super.c |   24 +++++------
>  fs/xfs/linux-2.6/xfs_sync.c  |   86 ++++++++++++++++++++---------------------
>  fs/xfs/linux-2.6/xfs_sync.h  |    2 +
>  fs/xfs/xfs_mount.h           |    4 +-
>  4 files changed, 56 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index 1ba5c45..99dded9 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c

. . .

> @@ -1833,13 +1822,21 @@ init_xfs_fs(void)
>  	if (error)
>  		goto out_cleanup_procfs;
>  
> +	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_CPU_INTENSIVE, 8);

The value (8) for max_active here is arbitrary, and maybe
justified with some magic words in a comment or something.
But I really think it should be configurable, I suppose
via a module parameter, for the benefit of unusual (i.e.
large) configurations.

> +	if (!xfs_syncd_wq) {
> +		error = -ENOMEM;
> +		goto out_sysctl_unregister;
> +	}

. . .

> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index 594cd82..ee9a6c3 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c

. . .

> @@ -535,27 +511,12 @@ xfssyncd(
>  			break;
>  
>  		spin_lock(&mp->m_sync_lock);
> -		/*
> -		 * We can get woken by laptop mode, to do a sync -
> -		 * that's the (only!) case where the list would be
> -		 * empty with time remaining.
> -		 */
> -		if (!timeleft || list_empty(&mp->m_sync_list)) {
> -			if (!timeleft)
> -				timeleft = xfs_syncd_centisecs *
> -							msecs_to_jiffies(10);
> -			INIT_LIST_HEAD(&mp->m_sync_work.w_list);
> -			list_add_tail(&mp->m_sync_work.w_list,
> -					&mp->m_sync_list);
> -		}

Does timeleft have to be re-initialized in here somewhere?
It looks to me like it will become zero pretty quickly and
stay there.

>  		list_splice_init(&mp->m_sync_list, &tmp);
>  		spin_unlock(&mp->m_sync_lock);
>  
>  		list_for_each_entry_safe(work, n, &tmp, w_list) {
>  			(*work->w_syncer)(mp, work->w_data);
>  			list_del(&work->w_list);
> -			if (work == &mp->m_sync_work)
> -				continue;
>  			if (work->w_completion)
>  				complete(work->w_completion);
>  			kmem_free(work);

. . .



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
