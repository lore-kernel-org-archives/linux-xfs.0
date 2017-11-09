Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19006 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754687AbdKIXdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 18:33:52 -0500
Date: Fri, 10 Nov 2017 10:24:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/5] xfs: on failed mount, force-reclaim inodes after
 unmounting quota controls
Message-ID: <20171109232425.GQ4094@dastard>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <20171109060010.GK26910@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171109060010.GK26910@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2017 at 10:00:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When mounting fails, we must force-reclaim inodes (and disable delayed
> reclaim) /after/ the realtime and quota control have let go of the
> realtime and quota inodes.  Without this, we corrupt the timer list and
> cause other weird problems.
> 
> Found by xfs/376 fuzzing u3.bmbt[0].lastoff on an rmap filesystem to
> force a bogus post-eof extent reclaim that causes the fs to go down.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_mount.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index e9727d0..a9f0fe9 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1022,10 +1022,15 @@ xfs_mountfs(
>  	xfs_rtunmount_inodes(mp);
>   out_rele_rip:
>  	IRELE(rip);
> -	cancel_delayed_work_sync(&mp->m_reclaim_work);
> -	xfs_reclaim_inodes(mp, SYNC_WAIT);
>  	/* Clean out dquots that might be in memory after quotacheck. */
>  	xfs_qm_unmount(mp);
> +	/*
> +	 * Cancel all delayed reclaim work and reclaim the inodes directly.
> +	 * We have to do this /after/ rtunmount and qm_unmount because those
> +	 * two will have scheduled delayed reclaim for the rt/quota inodes.
> +	 */
> +	cancel_delayed_work_sync(&mp->m_reclaim_work);
> +	xfs_reclaim_inodes(mp, SYNC_WAIT);
>   out_log_dealloc:
>  	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
>  	xfs_log_mount_cancel(mp);

Same bug in xfs_unmountfs(), isn't there? Otherwise this needs
explaining why the order is different to a normal unmount...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
