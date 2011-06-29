Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TMDK9i145506 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 17:13:20 -0500
Subject: Re: [PATCH 06/27] xfs: split xfs_setattr
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110629140337.641422449@bombadil.infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140337.641422449@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 17:13:16 -0500
Message-ID: <1309385596.8649.36.camel@doink>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, 2011-06-29 at 10:01 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-split-setattr)
> Split up xfs_setattr into two functions, one for the complex truncate
> handling, and one for the trivial attribute updates.  Also move both
> new routines to xfs_iops.c as they are fairly Linux-specific.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice simplification (good start anyway...).

Looks good but I think that you need to mask off the
ia_valid bits in the calls now made in xfs_vn_setattr().
Also, I think you may still need to check the file type
for the size-setting function.  Details below.

Seems like a semi-exhaustive setattr() checker
test program would be pretty easy to create.

If you fix these things (or you point out I'm
mistaken), you can consider this:
    Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2011-06-29 11:29:02.684972774 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2011-06-29 11:29:07.154948558 +0200
> @@ -39,6 +39,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_utils.h"
>  #include "xfs_vnodeops.h"
> +#include "xfs_inode_item.h"
>  #include "xfs_trace.h"
>  
>  #include <linux/capability.h>
> @@ -497,12 +498,449 @@ xfs_vn_getattr(
>  	return 0;
>  }
>  
> +int
> +xfs_setattr_nonsize(
> +	struct xfs_inode	*ip,
> +	struct iattr		*iattr,
> +	int			flags)
> +{
> +	xfs_mount_t		*mp = ip->i_mount;
> +	struct inode		*inode = VFS_I(ip);
> +	int			mask = iattr->ia_valid;
> +	xfs_trans_t		*tp;
> +	int			error;
> +	uid_t			uid = 0, iuid = 0;
> +	gid_t			gid = 0, igid = 0;
> +	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
> +	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
> +
> +	trace_xfs_setattr(ip);
> +
> +	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +		return XFS_ERROR(EROFS);
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return XFS_ERROR(EIO);
> +
> +	error = -inode_change_ok(inode, iattr);
> +	if (error)
> +		return XFS_ERROR(error);
> +
> +	ASSERT((mask & ATTR_SIZE) == 0);

You need to mask ATTR_SIZE off in xfs_vn_setattr() if
you're going to make this assertion.  But you might
as well just mask it off locally I suppose (though
it's nice to have the explicitness of the assertion
here).

> +
> +	/*
> +	 * If disk quotas is on, we make sure that the dquots do exist on disk,
> +	 * before we start any other transactions. Trying to do this later
> +	 * is messy. We don't care to take a readlock to look at the ids
> +	 * in inode here, because we can't hold it across the trans_reserve.

. . .

> +}
> +
> +/*
> + * Truncate file.  Must have write permission and not be a directory.
> + */
> +int
> +xfs_setattr_size(
> +	struct xfs_inode	*ip,
> +	struct iattr		*iattr,
> +	int			flags)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct inode		*inode = VFS_I(ip);
> +	int			mask = iattr->ia_valid;
> +	struct xfs_trans	*tp;
> +	int			error;
> +	uint			lock_flags;
> +	uint			commit_flags = 0;
> +
> +	trace_xfs_setattr(ip);
> +
> +	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +		return XFS_ERROR(EROFS);
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return XFS_ERROR(EIO);
> +
> +	error = -inode_change_ok(inode, iattr);
> +	if (error)
> +		return XFS_ERROR(error);
> +
> +	ASSERT(S_ISREG(ip->i_d.di_mode));

There is nothing in xfs_vn_setattr(), nor--as far as
I can tell--anywhere else that reaches xfs_vn_seattr()
that will ensure this.  (Maybe it's unreachable for
a directory or whatever, but that's not obvious.)

You may have to put back the code that returns
EISDIR or EINVAL based on the file type rather
than do this assertion.  Seems like inode_change_ok()
might have been able to do this check for us.

> +	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> +			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
> +			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);

You'll have to mask these off in xfs_vn_setattr() if you're
going to make this assertion.

> +
> +	lock_flags = XFS_ILOCK_EXCL;
> +	if (!(flags & XFS_ATTR_NOLOCK))
> +		lock_flags |= XFS_IOLOCK_EXCL;
> +	xfs_ilock(ip, lock_flags);
> +
> +	/*
> +	 * Short circuit the truncate case for zero length files.
> +	 */

. . .

> +	goto out_unlock;
> +}
> +
>  STATIC int
>  xfs_vn_setattr(
>  	struct dentry	*dentry,
>  	struct iattr	*iattr)
>  {
> -	return -xfs_setattr(XFS_I(dentry->d_inode), iattr, 0);
> +	if (iattr->ia_valid & ATTR_SIZE)
> +		return -xfs_setattr_size(XFS_I(dentry->d_inode), iattr, 0);
> +	return -xfs_setattr_nonsize(XFS_I(dentry->d_inode), iattr, 0);
>  }

Just leaving this part in so you can see what I'm
talking about.
 
>  #define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)

. . .

> Index: xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-06-29 11:29:02.721639242 +0200
> +++ xfs/fs/xfs/xfs_vnodeops.c	2011-06-29 11:29:07.158281874 +0200
> @@ -50,430 +50,6 @@
>  #include "xfs_vnodeops.h"
>  #include "xfs_trace.h"
>  
> -int
> -xfs_setattr(
> -	struct xfs_inode	*ip,
> -	struct iattr		*iattr,
> -	int			flags)
> -{
> -	xfs_mount_t		*mp = ip->i_mount;
> -	struct inode		*inode = VFS_I(ip);
> -	int			mask = iattr->ia_valid;
> -	xfs_trans_t		*tp;
> -	int			code;
> -	uint			lock_flags;
> -	uint			commit_flags=0;
> -	uid_t			uid=0, iuid=0;
> -	gid_t			gid=0, igid=0;
> -	struct xfs_dquot	*udqp, *gdqp, *olddquot1, *olddquot2;
> -	int			need_iolock = 1;
> -

. . .

> -	/*
> -	 * Truncate file.  Must have write permission and not be a directory.
> -	 */
> -	if (mask & ATTR_SIZE) {
> -		/* Short circuit the truncate case for zero length files */
> -		if (iattr->ia_size == 0 &&
> -		    ip->i_size == 0 && ip->i_d.di_nextents == 0) {
> -			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -			lock_flags &= ~XFS_ILOCK_EXCL;
> -			if (mask & ATTR_CTIME) {
> -				inode->i_mtime = inode->i_ctime =
> -						current_fs_time(inode->i_sb);
> -				xfs_mark_inode_dirty_sync(ip);
> -			}
> -			code = 0;
> -			goto error_return;
> -		}
> -
> -		if (S_ISDIR(ip->i_d.di_mode)) {
> -			code = XFS_ERROR(EISDIR);
> -			goto error_return;
> -		} else if (!S_ISREG(ip->i_d.di_mode)) {
> -			code = XFS_ERROR(EINVAL);
> -			goto error_return;
> -		}

This is the file type checking code I referred to above.

> -
> -		/*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
