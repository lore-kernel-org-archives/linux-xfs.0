Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2MFFe7O253169 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 10:15:40 -0500
Date: Thu, 22 Mar 2012 10:15:48 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/8] xfs: initialise xfssync work before running
	quotachecks
Message-ID: <20120322151548.GS7762@sgi.com>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1332393313-1955-4-git-send-email-david@fromorbit.com>
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

On Thu, Mar 22, 2012 at 04:15:08PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because the mount process can run a quotacheck and consume lots of
> inodes, we need to be able to run periodic inode reclaim during the
> mount process. This will prevent running the system out of memory
> during quota checks.
> 
> This essentially reverts 2bcf6e97, but that is safe to do now that
> the quota sync code that was causing problems during long quotacheck
> executions is now gone.

Dave, I've held off on #s 3 and 4 because they appear to be racy.  Being
able to run inode reclaim during quota check seems like a good idea
though.

-Ben

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2c3cc2e..a08c56d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1346,31 +1346,33 @@ xfs_fs_fill_super(
>  	sb->s_time_gran = 1;
>  	set_posix_acl_flag(sb);
>  
> -	error = xfs_mountfs(mp);
> +	error = xfs_syncd_init(mp);
>  	if (error)
>  		goto out_filestream_unmount;
>  
> -	error = xfs_syncd_init(mp);
> +	error = xfs_mountfs(mp);
>  	if (error)
> -		goto out_unmount;
> +		goto out_syncd_stop;
>  
>  	root = igrab(VFS_I(mp->m_rootip));
>  	if (!root) {
>  		error = ENOENT;
> -		goto out_syncd_stop;
> +		goto out_unmount;
>  	}
>  	if (is_bad_inode(root)) {
>  		error = EINVAL;
> -		goto out_syncd_stop;
> +		goto out_unmount;
>  	}
>  	sb->s_root = d_make_root(root);
>  	if (!sb->s_root) {
>  		error = ENOMEM;
> -		goto out_syncd_stop;
> +		goto out_unmount;
>  	}
>  
>  	return 0;
>  
> + out_syncd_stop:
> +	xfs_syncd_stop(mp);
>   out_filestream_unmount:
>  	xfs_filestream_unmount(mp);
>   out_free_sb:
> @@ -1387,8 +1389,6 @@ out_destroy_workqueues:
>   out:
>  	return -error;
>  
> - out_syncd_stop:
> -	xfs_syncd_stop(mp);
>   out_unmount:
>  	/*
>  	 * Blow away any referenced inode in the filestreams cache.
> @@ -1400,6 +1400,7 @@ out_destroy_workqueues:
>  	xfs_flush_buftarg(mp->m_ddev_targp, 1);
>  
>  	xfs_unmountfs(mp);
> +	xfs_syncd_stop(mp);
>  	goto out_free_sb;
>  }
>  
> -- 
> 1.7.9
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
