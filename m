Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47NrO1k222767 for <xfs@oss.sgi.com>; Mon, 7 May 2012 18:53:24 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3gzq7kiTFqkRGAnz for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 16:53:23 -0700 (PDT)
Date: Tue, 8 May 2012 09:53:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [PATCH] Stop periodic syncing if filesystem is already
	shutdown.
Message-ID: <20120507235321.GD5091@dastard>
References: <a27cbce4f4b35c2a8aee1b58d88c22381fe70ccf.1336378182.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a27cbce4f4b35c2a8aee1b58d88c22381fe70ccf.1336378182.git.rprabhu@wnohang.net>
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

On Mon, May 07, 2012 at 02:44:07PM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> This is to prevent syncing from running ad-infinitum till umount if the disk has been forcefully unplugged.
> 
> This is to prevent messages like these from being displayed.
.....
> ---
>  fs/xfs/xfs_sync.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
> index 205ebcb..7ec412c 100644
> --- a/fs/xfs/xfs_sync.c
> +++ b/fs/xfs/xfs_sync.c
> @@ -460,6 +460,12 @@ xfs_sync_worker(
>  					struct xfs_mount, m_sync_work);
>  	int		error;
>  
> +	if (!xfs_fs_writable(mp)) {
> +		xfs_err(mp, "Filesystem not writable / already shutdown.");
> +		xfs_syncd_stop(mp);
> +		return;
> +	}
> +

That is going to kill the xfssyncd on read only and frozen
filesystems as well as shutdowns, so this is certainly not correct.
The xfs_sync_worker should continue to run until the filesystem is
unmounted, even if it does nothing when it runs.

Indeed, all that is needed in xfs_sync_worker() is this:

-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (!xfs_fs_writable(mp)) {

and the error message won't appear. It fixes the problem for the
shutdown case, as well as handles frozen and read-only filesystems
correctly.

>  		/* dgc: errors ignored here */
>  		if (mp->m_super->s_frozen == SB_UNFROZEN &&
> @@ -551,6 +557,12 @@ xfs_flush_worker(
>  	struct xfs_mount *mp = container_of(work,
>  					struct xfs_mount, m_flush_work);
>  
> +	if (!xfs_fs_writable(mp)) {
> +		xfs_err(mp, "Filesystem not writable / already shutdown.");
> +		xfs_syncd_stop(mp);
> +		return;
> +	}
> +
>  	xfs_sync_data(mp, SYNC_TRYLOCK);
>  	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);

This is not necessary, either, because xfs_sync_data() has shutdown
checks and xfs_flush_worker() should never be called on a shutdown
filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
