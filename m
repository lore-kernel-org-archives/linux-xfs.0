Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:30370 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726268AbfC1VVv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Mar 2019 17:21:51 -0400
Date: Fri, 29 Mar 2019 08:21:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: reset page mappings after setting immutable
Message-ID: <20190328212147.GK23020@dastard>
References: <155379543409.24796.5783716624820175068.stgit@magnolia>
 <155379544747.24796.1807309281507099911.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155379544747.24796.1807309281507099911.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

On Thu, Mar 28, 2019 at 10:50:47AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The chattr manpage has this to say about immutable files:
> 
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
> 
> This means that we need to flush the page cache when setting the

nit: flush and invalidate the page cache.

> immutable flag so that programs cannot continue to write to writable
> mappings.

Do we even need to invalidate the page cache for this? i.e. we've
cleaned the pages so that any new write to them will fault,
that will see the immutable flag via ->page_mkwrite and then the
app should segv, right?

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c |   63 +++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 43 insertions(+), 20 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6ecdbb3af7de..2bd1c5ab5008 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -998,6 +998,37 @@ xfs_diflags_to_linux(
>  #endif
>  }
>  
> +static int
> +xfs_ioctl_setattr_flush(
> +	struct xfs_inode	*ip,
> +	int			*join_flags)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +	int			error;
> +
> +	if (S_ISDIR(inode->i_mode))
> +		return 0;
> +	if ((*join_flags) & (XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL))
> +		return 0;
> +
> +	/* lock, flush and invalidate mapping in preparation for flag change */
> +	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
> +	error = filemap_write_and_wait(inode->i_mapping);
> +	if (error)
> +		goto out_unlock;
> +	error = invalidate_inode_pages2(inode->i_mapping);
> +	if (error)
> +		goto out_unlock;
> +
> +	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
> +	return 0;
> +
> +out_unlock:
> +	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
> +	return error;
> +
> +}

Doesn't wait for direct IO to drain. Wouldn't it be better to do
this?

	lock()
	xfs_flush_unmap_range(ip, 0, XFS_SIZE(ip));
	unlock()

Otherwise looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
