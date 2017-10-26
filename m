Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21756 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932365AbdJZQbh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 12:31:37 -0400
Date: Thu, 26 Oct 2017 09:31:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/3] xfs: drain the buffer LRU on mount
Message-ID: <20171026163132.GX5483@magnolia>
References: <20171025185705.64983-1-bfoster@redhat.com>
 <20171025185705.64983-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171025185705.64983-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2017 at 02:57:05PM -0400, Brian Foster wrote:
> Log recovery of v4 filesystems does not use buffer verifiers because
> log recovery historically can result in transient buffer corruption
> when target buffers might be ahead of the log after a crash. v5
> filesystems work around this problem with metadata LSN ordering.
> 
> While this log recovery verifier behavior is necessary on v4 supers,
> it can result in leaving buffers around in the LRU without verifiers
> attached for a significant amount of time. This leads to use of
> unverified buffers while the filesystem is in active use, long after
> recovery has completed.
> 
> To address this problem, drain all buffers from the LRU as a final
> step of the log mount sequence. Note that this is done
> unconditionally to provide a consistently clean cache footprint,
> regardless of superblock version or log state. As a side effect,
> this ensures that all cache resident, unverified buffers are
> reclaimed after log recovery and therefore must be recreated with
> verifiers on subsequent use.
> 
> Reported-by: Darrick Wong <darrick.wong@oracle.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_log.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index dc95a49..ab59e78 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -744,6 +744,7 @@ xfs_log_mount_finish(
>  {
>  	int	error = 0;
>  	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
> +	bool	recovered = mp->m_log->l_flags & XLOG_RECOVERY_NEEDED;
>  
>  	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> @@ -780,6 +781,21 @@ xfs_log_mount_finish(
>  	mp->m_super->s_flags &= ~MS_ACTIVE;
>  	evict_inodes(mp->m_super);
>  
> +	/*
> +	 * Drain the buffer LRU after log recovery. This is required for v4
> +	 * filesystems to avoid leaving around buffers with NULL verifier ops,
> +	 * but we do it unconditionally to make sure we're always in a clean
> +	 * cache state after mount.
> +	 *
> +	 * Don't push in the error case because the AIL may have pending intents
> +	 * that aren't removed until recovery is cancelled.
> +	 */
> +	if (!error && recovered) {
> +		xfs_log_force(mp, XFS_LOG_SYNC);
> +		xfs_ail_push_all_sync(mp->m_ail);
> +	}
> +	xfs_wait_buftarg(mp->m_ddev_targp);
> +
>  	if (readonly)
>  		mp->m_flags |= XFS_MOUNT_RDONLY;
>  
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
