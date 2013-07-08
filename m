Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C2E157F37
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 16:11:25 -0500 (CDT)
Date: Mon, 8 Jul 2013 16:11:21 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] Subject: [PATCH] xfs: fix sgid inheritance for
	subdirectories inheriting default acls [V3]
Message-ID: <20130708211121.GI20932@sgi.com>
References: <1371836753-3327-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371836753-3327-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 21, 2013 at 02:45:53PM -0300, Carlos Maiolino wrote:
> XFS removes sgid bits of subdirectories under a directory containing a default
> acl.
> 
> When a default acl is set, it implies xfs to call xfs_setattr_nonsize() in its
> code path. Such function is shared among mkdir and chmod system calls, and
> does some checks unneeded by mkdir (calling inode_change_ok()). Such checks
> remove sgid bit from the inode after it has been granted.
> 
> With this patch, we extend the meaning of XFS_ATTR_NOACL flag to avoid these
> checks when acls are being inherited (thanks hch).
> 
> Also, xfs_setattr_mode, doesn't need to re-check for group id and capabilities
> permissions, this only implies in another try to remove sgid bit from the
> directories. Such check is already done either on inode_change_ok() or
> xfs_setattr_nonsize().
> 
> Changelog:
> 
> V2: Extends the meaning of XFS_ATTR_NOACL instead of wrap the tests into another
>     function
> 
> V3: Remove S_ISDIR check in xfs_setattr_nonsize() from the patch
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_iops.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ca9ecaa..2e5aca8 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -467,9 +467,6 @@ xfs_setattr_mode(
>  	ASSERT(tp);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
> -	if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> -		mode &= ~S_ISGID;
> -

inode_change_ok has had the check for whether to clear S_ISGID since the
initial import of Linus's tree, and it is called when ATTR_MODE is set there,
just as in xfs_setattr_nonsize, and xfs_setattr_size.  That aspect of this
looks ok to me.

>  	ip->i_d.di_mode &= S_IFMT;
>  	ip->i_d.di_mode |= mode & ~S_IFMT;
>  
> @@ -495,15 +492,18 @@ xfs_setattr_nonsize(
>  
>  	trace_xfs_setattr(ip);
>  
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> -		return XFS_ERROR(EROFS);
> +	/* If acls are being inherited, we already have this checked */
> +	if (!(flags & XFS_ATTR_NOACL)) {
> +		if (mp->m_flags & XFS_MOUNT_RDONLY)
> +			return XFS_ERROR(EROFS);
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> -		return XFS_ERROR(EIO);
> +		if (XFS_FORCED_SHUTDOWN(mp))
> +			return XFS_ERROR(EIO);
>  
> -	error = -inode_change_ok(inode, iattr);
> -	if (error)
> -		return XFS_ERROR(error);
> +		error = -inode_change_ok(inode, iattr);
> +		if (error)
> +			return XFS_ERROR(error);
> +	}

I'm not so sure about this change yet.  Looks like the two relevant callers are:

.set - xattr_handler
  xfs_xattr_acl_set
    xfs_set_mode
      xfs_setattr_nonsize(..., XFS_ATTR_NOACL);

and

xfs_vn_mknod
  xfs_inherit_acl
    xfs_set_mode
      xfs_setattr_nonsize(..., XFS_ATTR_NOACL);

I suggest moving the forced shutdown and readonly checks outside of the
XFS_ATTR_NOACL conditional.  I'm not seeing those checks in xfs_attr_acl_set or
xfs_vn_mknod and it won't hurt to be careful.

It also seems like inode_change_ok might have some other checks that are
necessary to determine whether it is ok to update the mode and ctime here.  A
call to inode_owner_or_capable as is done in inode_change_ok would cover this
possibility.

Other than those two suggestions this looks pretty good to me.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
