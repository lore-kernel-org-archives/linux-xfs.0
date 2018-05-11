Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752959AbeEKNqp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 09:46:45 -0400
Date: Fri, 11 May 2018 09:46:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: clear sb->s_fs_info on mount failure
Message-ID: <20180511134644.GA105683@bfoster.bfoster>
References: <20180511020943.10132-1-david@fromorbit.com>
 <20180511020943.10132-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511020943.10132-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 12:09:43PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We recently had an oops reported on a 4.14 kernel in
> xfs_reclaim_inodes_count() where sb->s_fs_info pointed to garbage
> and so the m_perag_tree lookup walked into lala land.
> 
> Essentially, the machine was under memory pressure when the mount
> was being run, xfs_fs_fill_super() failed after allocating the
> xfs_mount and attaching it to sb->s_fs_info. It then cleaned up and
> freed the xfs_mount, but the sb->s_fs_info field still pointed to
> the freed memory. Hence when the superblock shrinker then ran
> it fell off the bad pointer.
> 
> With the superblock shrinker problem fixed at teh VFS level, this
> stale s_fs_info pointer is still a problem - we use it
> unconditionally in ->put_super when the superblock is being torn
> down, and hence we can still trip over it after a ->fill_super
> call failure. Hence we need to clear s_fs_info if
> xfs-fs_fill_super() fails, and we need to check if it's valid in
> the places it can potentially be dereferenced after a ->fill_super
> failure.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_super.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a523eaeb3f29..d7e51b08919c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1772,6 +1772,7 @@ xfs_fs_fill_super(
>   out_close_devices:
>  	xfs_close_devices(mp);
>   out_free_fsname:
> +	sb->s_fs_info = NULL;
>  	xfs_free_fsname(mp);
>  	kfree(mp);
>   out:
> @@ -1789,6 +1790,10 @@ xfs_fs_put_super(
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
>  
> +	/* if ->fill_super failed, we have no mount to tear down */
> +	if (!sb->s_fs_info)
> +		return;
> +

I'd still prefer we use either XFS_M() or ->s_fs_info consistently in
this function, but that's a nit:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	xfs_notice(mp, "Unmounting Filesystem");
>  	xfs_filestream_unmount(mp);
>  	xfs_unmountfs(mp);
> @@ -1798,6 +1803,8 @@ xfs_fs_put_super(
>  	xfs_destroy_percpu_counters(mp);
>  	xfs_destroy_mount_workqueues(mp);
>  	xfs_close_devices(mp);
> +
> +	sb->s_fs_info = NULL;
>  	xfs_free_fsname(mp);
>  	kfree(mp);
>  }
> @@ -1817,6 +1824,9 @@ xfs_fs_nr_cached_objects(
>  	struct super_block	*sb,
>  	struct shrink_control	*sc)
>  {
> +	/* Paranoia: catch incorrect calls during mount setup or teardown */
> +	if (WARN_ON_ONCE(!sb->s_fs_info))
> +		return 0;
>  	return xfs_reclaim_inodes_count(XFS_M(sb));
>  }
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
