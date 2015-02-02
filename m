Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8272F7FEF
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 11:11:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44D74304053
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 09:11:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fUSNn3lWt8WakTAm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 09:11:20 -0800 (PST)
Date: Mon, 2 Feb 2015 12:11:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: Remove icsb infrastructure
Message-ID: <20150202171113.GC6096@laptop.bfoster>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422826983-29570-6-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 02, 2015 at 08:43:03AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the in-cor superblock infrastructure has been replaced with
> generic per-cpu counters, we don't need it anymore. Nuke it from
> orbit so we are sure that it won't haunt us again...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |  16 +-
>  fs/xfs/libxfs/xfs_sb.c   |  10 +-
>  fs/xfs/xfs_fsops.c       |   2 -
>  fs/xfs/xfs_iomap.c       |   1 -
>  fs/xfs/xfs_linux.h       |   9 -
>  fs/xfs/xfs_log_recover.c |   3 -
>  fs/xfs/xfs_mount.c       | 509 -----------------------------------------------
>  fs/xfs/xfs_mount.h       |  64 +-----
>  fs/xfs/xfs_super.c       |  76 +++++--
>  9 files changed, 67 insertions(+), 623 deletions(-)
> 
...
> +static int
> +xfs_init_percpu_counters(
> +	struct xfs_mount	*mp)
> +{
> +	int		error;
> +
> +	error = percpu_counter_init(&mp->m_sb.sb_icount, 0, GFP_KERNEL);
> +	if (error)
> +		return ENOMEM;

			-ENOMEM

Brian

> +
> +	error = percpu_counter_init(&mp->m_sb.sb_ifree, 0, GFP_KERNEL);
> +	if (error)
> +		goto free_icount;
> +
> +	error = percpu_counter_init(&mp->m_sb.sb_fdblocks, 0, GFP_KERNEL);
> +	if (error)
> +		goto free_ifree;
> +
> +	return 0;
> +
> +free_ifree:
> +	percpu_counter_destroy(&mp->m_sb.sb_ifree);
> +free_icount:
> +	percpu_counter_destroy(&mp->m_sb.sb_icount);
> +	return -ENOMEM;
> +}
> +
> +static void
> +xfs_destroy_percpu_counters(
> +	struct xfs_mount	*mp)
> +{
> +	percpu_counter_destroy(&mp->m_sb.sb_icount);
> +	percpu_counter_destroy(&mp->m_sb.sb_ifree);
> +	percpu_counter_destroy(&mp->m_sb.sb_fdblocks);
> +}
> +
>  STATIC int
>  xfs_fs_fill_super(
>  	struct super_block	*sb,
> @@ -1455,7 +1472,7 @@ xfs_fs_fill_super(
>  	if (error)
>  		goto out_close_devices;
>  
> -	error = xfs_icsb_init_counters(mp);
> +	error = xfs_init_percpu_counters(mp);
>  	if (error)
>  		goto out_destroy_workqueues;
>  
> @@ -1513,7 +1530,7 @@ xfs_fs_fill_super(
>   out_free_sb:
>  	xfs_freesb(mp);
>   out_destroy_counters:
> -	xfs_icsb_destroy_counters(mp);
> +	xfs_destroy_percpu_counters(mp);
>  out_destroy_workqueues:
>  	xfs_destroy_mount_workqueues(mp);
>   out_close_devices:
> @@ -1530,6 +1547,23 @@ out_destroy_workqueues:
>  	goto out_free_sb;
>  }
>  
> +STATIC void
> +xfs_fs_put_super(
> +	struct super_block	*sb)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	xfs_filestream_unmount(mp);
> +	xfs_unmountfs(mp);
> +
> +	xfs_freesb(mp);
> +	xfs_destroy_percpu_counters(mp);
> +	xfs_destroy_mount_workqueues(mp);
> +	xfs_close_devices(mp);
> +	xfs_free_fsname(mp);
> +	kfree(mp);
> +}
> +
>  STATIC struct dentry *
>  xfs_fs_mount(
>  	struct file_system_type	*fs_type,
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
