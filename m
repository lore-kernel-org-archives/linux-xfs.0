Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A1DA77F3F
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 18:00:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 904C9304032
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 16:00:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fziO3bRGsS2ZcC1e for <xfs@oss.sgi.com>;
	Thu, 06 Nov 2014 16:00:20 -0800 (PST)
Date: Fri, 7 Nov 2014 10:59:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: move global xfslogd workqueue to per-mount
Message-ID: <20141106235948.GH23575@dastard>
References: <1414773271-48598-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1414773271-48598-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 31, 2014 at 12:34:31PM -0400, Brian Foster wrote:
> The xfslogd workqueue is a global, single-job workqueue for buffer ioend
> processing. This means we allow for a single work item at a time for all
> possible XFS mounts on a system. fsstress testing in loopback XFS over
> XFS configurations has reproduced xfslogd deadlocks due to the single
> threaded nature of the queue and dependencies introduced between the
> separate XFS instances by online discard (-o discard).
> 
> Discard over a loopback device converts the discard request to a hole
> punch (fallocate) on the underlying file. Online discard requests are
> issued synchronously and from xfslogd context in XFS, hence the xfslogd
> workqueue is blocked in the upper fs waiting on a hole punch request to
> be servied in the lower fs. If the lower fs issues I/O that depends on
> xfslogd to complete, both filesystems end up hung indefinitely. This is
> reproduced reliabily by generic/013 on XFS->loop->XFS test devices with
> the '-o discard' mount option.
> 
> Further, docker implementations appear to use this kind of configuration
> for container instance filesystems by default (container fs->dm->
> loop->base fs) and therefore are subject to this deadlock when running
> on XFS.
> 
> Replace the global xfslogd workqueue with a per-mount variant. This
> guarantees each mount access to a single worker and prevents deadlocks
> due to inter-fs dependencies introduced by discard.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> Thoughts? An alternative was to increase max jobs on the existing
> workqueue, but this seems more in line with how we manage workqueues
> these days.

First thing is that it's no longer a "log" workqueue. It's an async
buffer completion workqueue, so we really should rename it.
Especially as this change would mean we now have m_log_workqueue
for the log and m_xfslogd_workqueue for buffer completion...

Indeed, is the struct xfs_mount the right place for this? Shouldn't
it be on the relevant buftarg that the buffer is associated with?

> Brian
> 
>  fs/xfs/xfs_buf.c   | 13 ++-----------
>  fs/xfs/xfs_mount.h |  1 +
>  fs/xfs/xfs_super.c | 11 ++++++++++-
>  3 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 24b4ebe..758bc2e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -44,8 +44,6 @@
>  
>  static kmem_zone_t *xfs_buf_zone;
>  
> -static struct workqueue_struct *xfslogd_workqueue;
> -
>  #ifdef XFS_BUF_LOCK_TRACKING
>  # define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
>  # define XB_CLEAR_OWNER(bp)	((bp)->b_last_holder = -1)
> @@ -1053,7 +1051,8 @@ xfs_buf_ioend_async(
>  	struct xfs_buf	*bp)
>  {
>  	INIT_WORK(&bp->b_iodone_work, xfs_buf_ioend_work);
> -	queue_work(xfslogd_workqueue, &bp->b_iodone_work);
> +	queue_work(bp->b_target->bt_mount->m_xfslogd_workqueue,
> +		   &bp->b_iodone_work);
>  }

ie. queue_work(bp->b_target->bt_iodone_wq, &bp->b_iodone_work);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
