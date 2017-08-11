Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20555 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753325AbdHKTrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 15:47:19 -0400
Date: Fri, 11 Aug 2017 12:47:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2 V2] xfs: toggle readonly state around
 xfs_log_mount_finish
Message-ID: <20170811194710.GF24087@magnolia>
References: <e98c7179-fdb0-1cc7-544b-c55489451db5@redhat.com>
 <6c81fb42-4601-dc0f-6ebb-a73c7c40aaa4@sandeen.net>
 <537e1ca3-60be-8182-7130-dff3a1059078@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537e1ca3-60be-8182-7130-dff3a1059078@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Aug 11, 2017 at 12:45:05PM -0700, Eric Sandeen wrote:
> When we do log recovery on a readonly mount, unlinked inode
> processing does not happen due to the readonly checks in
> xfs_inactive(), which are trying to prevent any I/O on a
> readonly mount.
> 
> This is misguided - we do I/O on readonly mounts all the time,
> for consistency; for example, log recovery.  So do the same
> RDONLY flag twiddling around xfs_log_mount_finish() as we
> do around xfs_log_mount(), for the same reason.
> 
> This all cries out for a big rework but for now this is a
> simple fix to an obvious problem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> 
> V2: bool "readonly" per Christoph's request
> 

Looks good, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0bd1341..ca56d85 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -743,16 +743,23 @@
>  	struct xfs_mount	*mp)
>  {
>  	int	error = 0;
> +	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
>  
>  	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
>  		return 0;
> +	} else if (readonly) {
> +		/* Allow unlinked processing to proceed */
> +		mp->m_flags &= ~XFS_MOUNT_RDONLY;
>  	}
>  
>  	error = xlog_recover_finish(mp->m_log);
>  	if (!error)
>  		xfs_log_work_queue(mp);
>  
> +	if (readonly)
> +		mp->m_flags |= XFS_MOUNT_RDONLY;
> +
>  	return error;
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
