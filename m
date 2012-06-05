Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5566Mfx048340 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 01:06:22 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kxguB0oOSbvJzJVN for <xfs@oss.sgi.com>;
	Mon, 04 Jun 2012 23:06:20 -0700 (PDT)
Date: Tue, 5 Jun 2012 16:06:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] Stop periodic syncing if filesystem is already
	shutdown.
Message-ID: <20120605060617.GG4347@dastard>
References: <d585aa328fc296e20bd3a180c2c3dbc4c77c45df.1338487073.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d585aa328fc296e20bd3a180c2c3dbc4c77c45df.1338487073.git.rprabhu@wnohang.net>
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

On Thu, May 31, 2012 at 11:37:34PM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> This is to prevent xfs_log_force from running ad-infinitum (due to xfs_sync)
> till umount if the disk has been forcefully unplugged.

I'm not sure where versions 2 and 3 went - I haven't seen them....

> 
> This is also to prevent messages like these from being displayed repeatedly.
> 
> [ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.
> 
> Note, that even after xfs_do_force_shutdown has been called, xfs_log_force
> doesn't stop till the filesystem has been unmounted (and it keeps printing
> "error 5 returned" to kernel log).
> 
> To fix it, added return statements to xfs_log_force and xfs_fs_sync_fs if the
> filesystem is already shutdown -- based on XFS_FORCED_SHUTDOWN.
> 
> To simulate it, mount an xfs filesystem located on external disk, and then pull
> the power to the disk.
> 
> Tested it on latest linus tree.
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
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>   ---
> ---
>  fs/xfs/xfs_log.c   |    7 +++++++
>  fs/xfs/xfs_super.c |    7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6db1fef..e4192b2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2932,6 +2932,13 @@ xfs_log_force(
>  {
>  	int	error;
>  
> +	/*
> +	 * No need to printk here since xfs_bwrite already printks about xfs
> +	 * shutdown if it has shutdown already.
> +	 */
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return;
> +
>  	error = _xfs_log_force(mp, flags, NULL);
>  	if (error)
>  		xfs_warn(mp, "%s: error %d returned.", __func__, error);

I don't think this is the right place for the check. Depending on
the type of error that caused the shutdown, the log may still be
functioning and we need to be able to force the log so we don't lose
all the changes in memory. The internal log implementation has all
the checks necessary to avoid writing to the log if the log has
already been shut down, which is why you keep seeing the error
message.

What it appears to me is that you want to stop the error message
from being emitted when the log is shut down. The way to do that is
this:

 	error = _xfs_log_force(mp, flags, NULL);
-	if (error)
+	if (error && !XFS_FORCED_SHUTDOWN(mp))
 		xfs_warn(mp, "%s: error %d returned.", __func__, error);

Rather than avoining calling _xfs_log_force() altogether.

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index dab9a5f..b0f6041 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1010,6 +1010,13 @@ xfs_fs_sync_fs(
>  	int			error;
>  
>  	/*
> +	 * No need to printk here since xfs_bwrite already printks about xfs
> +	 * shutdown if it has shutdown already.
> +	 */
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return XFS_ERROR(EIO);


I think if someone runs sync or calls syncfs() we should emit an
error message indicating that it failed. We can't return an error to
sync(), so we are limited to writing to the syslog.  This is not
called periodically, so I don't see any problem with emitting an
error message here. Being verbose in error states is desirable - you
can never have too much information in the logs when something goes
wrong....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
