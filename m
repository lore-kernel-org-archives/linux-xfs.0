Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52362 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727133AbeJEN7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 09:59:52 -0400
Date: Fri, 5 Oct 2018 17:02:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/15] xfs: refactor clonerange preparation into a
 separate helper
Message-ID: <20181005070228.GE12041@dastard>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870028762.29072.5369530877410002226.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870028762.29072.5369530877410002226.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

On Thu, Oct 04, 2018 at 05:44:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the reflink preparation steps into a separate helper that
> we'll use to land all the upcoming fixes for insufficient input checks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....

> +xfs_reflink_remap_range(
> +	struct file		*file_in,
> +	loff_t			pos_in,
> +	struct file		*file_out,
> +	loff_t			pos_out,
> +	u64			len,
> +	bool			is_dedupe)
> +{
> +	struct inode		*inode_in = file_inode(file_in);
> +	struct xfs_inode	*src = XFS_I(inode_in);
> +	struct inode		*inode_out = file_inode(file_out);
> +	struct xfs_inode	*dest = XFS_I(inode_out);
> +	struct xfs_mount	*mp = src->i_mount;
> +	xfs_fileoff_t		sfsbno, dfsbno;
> +	xfs_filblks_t		fsblen;
> +	xfs_extlen_t		cowextsize;
> +	ssize_t			ret;
> +
> +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> +		return -EOPNOTSUPP;
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +
> +	/* Prepare and then clone file data. */
> +	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
> +			len, is_dedupe);
> +	if (ret)
> +		return ret;

generic/013 indicates there's a double unlock bug here.	

vfs_clone_file_prep_inodes() can return zero (do nothing, but don't
fail!), and when that happens xfs_reflink_remap_prep() unlocks the
inodes and returns 0.  This new code doesn't catch it, we do the
remap on unlocked inodes, and then trip lock debugging bugs 

> @@ -1300,12 +1351,7 @@ xfs_reflink_remap_range(
>  			is_dedupe);
>  
>  out_unlock:
> -	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
> -	if (!same_inode)
> -		xfs_iunlock(src, XFS_MMAPLOCK_SHARED);
> -	inode_unlock(inode_out);
> -	if (!same_inode)
> -		inode_unlock_shared(inode_in);
> +	xfs_reflink_remap_unlock(file_in, file_out);

here:

 DEBUG_LOCKS_WARN_ON(sem->owner != get_current())
 WARNING: CPU: 3 PID: 4766 at kernel/locking/rwsem.c:133 up_write+0x66/0x70
 CPU: 3 PID: 4766 Comm: fsstress Not tainted 4.19.0-rc6-dgc+ #671
....
 Call Trace:
  xfs_iunlock+0x152/0x220
  xfs_reflink_remap_unlock+0x22/0x70
  xfs_reflink_remap_range+0x129/0x2a0
  do_clone_file_range+0x119/0x200
  vfs_clone_file_range+0x35/0xa0
  ioctl_file_clone+0x8a/0xa0
  do_vfs_ioctl+0x2e1/0x6c0
  ksys_ioctl+0x70/0x80
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x5a/0x180
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

I'll fix it for the moment by making xfs_reflink_remap_prep() behave
like vfs_clone_file_prep_inodes() - it will return 1 on success,
0 for nothing to do and < 0 for an error and catch it in this code.

I note that later patches in the series change the
vfs_clone_file_prep_inodes() behaviour so this behaviour is probably
masked by those later changes. It's still a nasty bisect landmine,
though, so I'll fix it here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
