Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751848AbdCOPSL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 11:18:11 -0400
Date: Wed, 15 Mar 2017 11:18:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: write unmount record for ro mounts
Message-ID: <20170315151810.GC24729@bfoster.bfoster>
References: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
 <9a573fb1-0d4c-e393-b0b7-a0688b3849e5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a573fb1-0d4c-e393-b0b7-a0688b3849e5@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 09, 2017 at 02:15:01PM -0600, Eric Sandeen wrote:
> There are dueling comments in the xfs code about intent
> for log writes when unmounting a readonly filesystem.
> 
> In xfs_mountfs, we see the intent:
> 
> /*
>  * Now the log is fully replayed, we can transition to full read-only
>  * mode for read-only mounts. This will sync all the metadata and clean
>  * the log so that the recovery we just performed does not have to be
>  * replayed again on the next mount.
>  */
> 
> and it calls xfs_quiesce_attr(), but by the time we get to 
> xfs_log_unmount_write(), it returns early for a RDONLY mount:
> 
>  * Don't write out unmount record on read-only mounts.
> 
> Because of this, sequential ro mounts of a filesystem with
> a dirty log will replay the log each time, which seems odd.
> 
> Fix this by writing an unmount record even for RO mounts, as long
> as norecovery wasn't specified (don't write a clean log record
> if a dirty log may still be there!) and the log device is
> writable.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b1469f0..62176b8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -801,11 +801,14 @@
>  	int		 error;
>  
>  	/*
> -	 * Don't write out unmount record on read-only mounts.
> +	 * Don't write out unmount record on norecovery mounts or ro devices.
>  	 * Or, if we are doing a forced umount (typically because of IO errors).
>  	 */
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
> +	    xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
> +		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
>  		return 0;
> +	}
>  
>  	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
>  	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
