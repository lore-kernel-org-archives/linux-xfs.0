Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2233Iow234021 for <xfs@oss.sgi.com>; Tue, 1 Mar 2011 21:03:18 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE272A5C045
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2011 19:06:05 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Vi5C3HpS2bOhOKfF for <xfs@oss.sgi.com>;
	Tue, 01 Mar 2011 19:06:05 -0800 (PST)
Date: Wed, 2 Mar 2011 14:06:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: kick inode writeback when low on memory
Message-ID: <20110302030602.GD4905@dastard>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298412969-14389-6-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com
Cc: chris.mason@oracle.com

On Wed, Feb 23, 2011 at 09:16:09AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the inode cache shrinker runs, we may have lots of dirty inodes queued up
> in the VFS dirty queues that have not been expired. The typical case for this
> with XFS is atime updates. The result is that a highly concurrent workload that
> copies files and then later reads them (say to verify checksums) dirties all
> the inodes again, even when relatime is used.
> 
> In a constrained memory environment, this results in a large number of dirty
> inodes using all of available memory and memory reclaim being unable to free
> them as dirty inodes areconsidered active. This problem was uncovered by Chris
> Mason during recent low memory stress testing.
> 
> The fix is to trigger VFS level writeback from the XFS inode cache shrinker if
> there isn't already writeback in progress. This ensures that when we enter a
> low memory situation we start cleaning inodes (via the flusher thread) on the
> filesystem immediately, thereby making it more likely that we will be able to
> evict those dirty inodes from the VFS in the near future.
> 
> The mechanism is not perfect - it only acts on the current filesystem, so if
> all the dirty inodes are on a different filesystem it won't help. However, it
> seems to be a valid assumption is that the filesystem with lots of dirty inodes
> is going to have the shrinker called very soon after the memory shortage
> begins, so this shouldn't be an issue.
> 
> The other flaw is that there is no guarantee that the flusher thread will make
> progress fast enough to clean the dirty inodes so they can be reclaimed in the
> near future. However, this mechanism does improve the resilience of the
> filesystem under the test conditions - instead of reliably triggering the OOM
> killer 20 minutes into the stress test, it took more than 6 hours before it
> happened.
> 
> This small addition definitely improves the low memory resilience of XFS on
> this type of workload, and best of all it has no impact on performance when
> memory is not constrained.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_sync.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index 35138dc..3abde91 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -1044,6 +1044,17 @@ xfs_reclaim_inode_shrink(
>  		if (!(gfp_mask & __GFP_FS))
>  			return -1;
>  
> +		/*
> +		 * make sure VFS is cleaning inodes so they can be pruned
> +		 * and marked for reclaim in the XFS inode cache. If we don't
> +		 * do this the VFS can accumulate dirty inodes and we can OOM
> +		 * before they are cleaned by the periodic VFS writeback.
> +		 *
> +		 * This takes VFS level locks, so we can only do this after
> +		 * the __GFP_FS checks otherwise lockdep gets really unhappy.
> +		 */
> +		writeback_inodes_sb_nr_if_idle(mp->m_super, nr_to_scan);
> +

Well, this generates a deadlock if we get a low memory situation
before the bdi flusher thread for the underly device has been
created. That is, we get low memory, kick
writeback_inodes_sb_nr_if_idle(), we end up with the bdi-default
thread trying to create the flush-x:y thread, which gets stuck
waiting for kthread_create() to complete.

kthread_create() never completes because the do_fork() call in the
kthreadd fails memory allocation and again calls (via the shrinker)
writeback_inodes_sb_nr_if_idle(), which thinks that
writeback_in_progress(bdi) is false, so tries to start
writeback again....

So, writeback_inodes_sb_nr_if_idle() is busted w.r.t. only queuing a
single writeback instance as writeback is only marked as in progress
once the queued callback is running. Perhaps writeback_in_progress()
should return try if the BDI_Pending bit is set, indicating the
flusher thread is being created right now, but I'm not sure that is
sufficient to avoid all the potential races here.

I'm open to ideas here - I could convert the bdi flusher
infrastructure to cmwqs rather than using worker threads, or move
all dirty inode tracking and writeback into XFS, or ???

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
