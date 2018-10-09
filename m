Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbeJITd2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Oct 2018 15:33:28 -0400
Date: Tue, 9 Oct 2018 08:16:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: issue log message on user force shutdown
Message-ID: <20181009121644.GC2816@bfoster>
References: <20181009053045.27473-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009053045.27473-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 09, 2018 at 04:30:45PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The kernel only issues a log message that it's been shut down when
> the filesystem triggers a shutdown itself. Hence there is no trace
> in the log when a shutdown is triggered manually from userspace.
> This can make it hard to see sequence of events in the log when
> things go wrong, so make sure we always log a message when a
> shutdown is run.
> 
> While there, clean up the logic flow so we don't have to continually
> check if the shutdown trigger was user initiated before logging
> shutdown messages.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_fsops.c | 50 +++++++++++++++++++++++-----------------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 7c00b8bedfe3..093c2b8d7e20 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -470,20 +470,13 @@ xfs_fs_goingdown(
>   */
>  void
>  xfs_do_force_shutdown(
> -	xfs_mount_t	*mp,
> +	struct xfs_mount *mp,
>  	int		flags,
>  	char		*fname,
>  	int		lnnum)
>  {
> -	int		logerror;
> -
> -	logerror = flags & SHUTDOWN_LOG_IO_ERROR;
> +	bool		logerror = flags & SHUTDOWN_LOG_IO_ERROR;
>  
> -	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
> -		xfs_notice(mp,
> -	"%s(0x%x) called from line %d of file %s.  Return address = "PTR_FMT,
> -			__func__, flags, lnnum, fname, __return_address);
> -	}
>  	/*
>  	 * No need to duplicate efforts.
>  	 */
> @@ -499,27 +492,34 @@ xfs_do_force_shutdown(
>  	if (xfs_log_force_umount(mp, logerror))
>  		return;
>  
> +	if (flags & SHUTDOWN_FORCE_UMOUNT) {
> +		xfs_alert(mp,
> +"User initiated shutdown received. Shutting down filesystem");
> +		return;
> +	}
> +
> +	xfs_notice(mp,
> +"%s(0x%x) called from line %d of file %s. Return address = "PTR_FMT,
> +		__func__, flags, lnnum, fname, __return_address);
> +
>  	if (flags & SHUTDOWN_CORRUPT_INCORE) {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
> -    "Corruption of in-memory data detected.  Shutting down filesystem");
> +"Corruption of in-memory data detected.  Shutting down filesystem");
>  		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
>  			xfs_stack_trace();
> -	} else if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
> -		if (logerror) {
> -			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
> -		"Log I/O Error Detected.  Shutting down filesystem");
> -		} else if (flags & SHUTDOWN_DEVICE_REQ) {
> -			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
> -		"All device paths lost.  Shutting down filesystem");
> -		} else if (!(flags & SHUTDOWN_REMOTE_REQ)) {
> -			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
> -		"I/O Error Detected. Shutting down filesystem");
> -		}
> -	}
> -	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
> -		xfs_alert(mp,
> -	"Please umount the filesystem and rectify the problem(s)");
> +	} else if (logerror) {
> +		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
> +			"Log I/O Error Detected. Shutting down filesystem");
> +	} else if (flags & SHUTDOWN_DEVICE_REQ) {
> +		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
> +			"All device paths lost. Shutting down filesystem");
> +	} else if (!(flags & SHUTDOWN_REMOTE_REQ)) {
> +		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
> +			"I/O Error Detected. Shutting down filesystem");
>  	}
> +
> +	xfs_alert(mp,
> +		"Please unmount the filesystem and rectify the problem(s)");
>  }
>  
>  /*
> -- 
> 2.17.0
> 
