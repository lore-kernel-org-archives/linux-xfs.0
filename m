Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BL4AQq154043 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 16:04:10 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	POH7FmTMvd9EvkZJ for <xfs@oss.sgi.com>;
	Tue, 11 Sep 2012 14:05:14 -0700 (PDT)
Date: Wed, 12 Sep 2012 07:05:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5] Stop xfs_do_force_shutdown / messages fron
	xfs_log_force if filesystem is already shutdown.
Message-ID: <20120911210512.GE11511@dastard>
References: <76577fa31ab2aa750994c1bc6a1b6f44beb03116.1347002369.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <76577fa31ab2aa750994c1bc6a1b6f44beb03116.1347002369.git.rprabhu@wnohang.net>
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
To: raghu.prabhu13@gmail.com
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, xfs@oss.sgi.com

On Sat, Sep 08, 2012 at 03:28:11AM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> This is to prevent xfs_log_force from printing error message continuously (due
> to xfs_sync and others) till umount if the disk has been forcefully unplugged.
> 
> This is to prevent messages like these from being displayed repeatedly.
> 
> [ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.
> 
> Note, that even after xfs_do_force_shutdown has been called, xfs_log_force
> doesn't stop till the filesystem has been unmounted (and it keeps printing
> "error 5 returned" to kernel log). Also, xfs_do_force_shutdown is called
> repeatedly on an already shutdown filesystem through xfs_fs_sync_fs.
> 
> To fix this, added condition over XFS_FORCED_SHUTDOWN to xfs_log_force and
> xfs_fs_sync_fs.
> 
> To simulate it, mount an xfs filesystem located on external disk, and then pull
> the power to the disk.
> 
> Now, the dmesg looks,
> 
> [  268.307303] XFS (sdb2): xfs_do_force_shutdown(0x1) called from line 1031 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff8127c13a
> [  268.307318] XFS (sdb2): I/O Error Detected. Shutting down filesystem
> [  268.307323] XFS (sdb2): Please umount the filesystem and rectify the problem(s)
> 
> ---
> 
> Version 1: Removed calling xfs_syncd_stop from xfs_sync_worker.
> Version 2: Removed calling xfs_fs_writable in xfs_sync_worker and xfs_flush_worker.
> Version 3: Removed calling xfs_syncd_stop in xfs_bwrite.
> Version 4: Added return statements to xfs_log_force and xfs_fs_sync_fs.
> Version 5: As per suggestion, added xfs_warn to xfs_fs_sync_fs and removed EIO
> return in xfs_log_force
> 
>  Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>  Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>

Signed-off-by implies you tested it. Tested-by is used to
acknowledge third party testers, usually in the case to acknowledge
the fix was Tested-by the Reported-by...

And the signed-off-by belongs in the commit message (i.e. about the
first ---) not in the section after the commit message that is
stripped by the git tools.

> ---
>  fs/xfs/xfs_log.c   | 5 ++++-
>  fs/xfs/xfs_super.c | 5 +++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7f4f937..161c925 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3002,7 +3002,10 @@ xfs_log_force(
>  
>  	trace_xfs_log_force(mp, 0);
>  	error = _xfs_log_force(mp, flags, NULL);
> -	if (error)
> +	/*
> +	 * Avoid warning when the filesystem has already shutdown.
> +	 */
> +	if (error && !XFS_FORCED_SHUTDOWN(mp))
>  		xfs_warn(mp, "%s: error %d returned.", __func__, error);
>  }
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bdaf4cb..ebafc99 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -943,6 +943,11 @@ xfs_fs_sync_fs(
>  	if (!wait)
>  		return 0;
>  
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
> +		xfs_warn(mp, "Sync called: filesystem already shutdown");
> +		return XFS_ERROR(EIO);
> +	}

Why should we emit a warning here? There's already information in the
log to indicate the filesystem is shut down...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
