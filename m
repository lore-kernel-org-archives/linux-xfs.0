Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753193AbdHNMkl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Aug 2017 08:40:41 -0400
Date: Mon, 14 Aug 2017 08:40:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 3/3] xfs: don't leak quotacheck dquots when cow
 recovery fails
Message-ID: <20170814124039.GC39742@bfoster.bfoster>
References: <150234262066.13754.6534116056866237943.stgit@magnolia>
 <150234263808.13754.11636194057966589953.stgit@magnolia>
 <20170811194844.GG24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811194844.GG24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Fri, Aug 11, 2017 at 12:48:44PM -0700, Darrick J. Wong wrote:
> If we fail a mount on account of cow recovery errors, it's possible that
> a previous quotacheck left some dquots in memory.  The bailout clause of
> xfs_mountfs forgets to purge these, and so we leak them.  Fix that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: move call to the same place as it is in unmountfs
> v2: move call below quota inode removal
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_mount.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index d63a367..a46c9d7 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1034,6 +1034,8 @@ xfs_mountfs(
>  	IRELE(rip);
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
>  	xfs_reclaim_inodes(mp, SYNC_WAIT);
> +	/* Clean out dquots that might be in memory after quotacheck. */
> +	xfs_qm_unmount(mp);
>   out_log_dealloc:
>  	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
>  	xfs_log_mount_cancel(mp);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
