Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2UITSuI194421 for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 13:29:28 -0500
Subject: Re: [PATCH] xfs: don't warn on EAGAIN in inode reclaim
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1269930010-19174-1-git-send-email-david@fromorbit.com>
References: <1269930010-19174-1-git-send-email-david@fromorbit.com>
Date: Tue, 30 Mar 2010 13:30:34 -0500
Message-ID: <1269973834.2738.46.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2010-03-30 at 17:20 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Any inode reclaim flush that returns EAGAIN will result in the inode
> reclaim being attempted again later. There is no need to issue a
> warning into the logs about this situation.

Looks good.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/linux-2.6/xfs_sync.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index 97813e7..5a4731e 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -820,10 +820,10 @@ xfs_reclaim_inode(
>  	 * call into reclaim to find it in a clean state instead of waiting for
>  	 * it now. We also don't return errors here - if the error is transient
>  	 * then the next reclaim pass will flush the inode, and if the error
> -	 * is permanent then the next sync reclaim will relcaim the inode and
> +	 * is permanent then the next sync reclaim will reclaim the inode and
>  	 * pass on the error.
>  	 */
> -	if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
> +	if (error && error != EAGAIN && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		xfs_fs_cmn_err(CE_WARN, ip->i_mount,
>  			"inode 0x%llx background reclaim flush failed with %d",
>  			(long long)ip->i_ino, error);



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
