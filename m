Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2SHcJAr149269 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 12:38:19 -0500
Date: Wed, 28 Mar 2012 12:38:29 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/8] xfs: initialise xfssync work before running
	quotachecks
Message-ID: <20120328173829.GD7762@sgi.com>
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
> 
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
		     ^^^^ 

I haven't seen a patch to use d_make_root instead of d_alloc_root, so we'll
take the earlier version of this patch... this one doesn't apply.  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
