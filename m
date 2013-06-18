Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6118629E09
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 17:44:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34C41304039
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 15:44:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MQ0fTNjkWHQr2rOd for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 15:44:06 -0700 (PDT)
Date: Wed, 19 Jun 2013 08:43:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix sgid inheritance for subdirectories inheriting
	default acls [V2]
Message-ID: <20130618224351.GB29338@dastard>
References: <1371569536-5779-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371569536-5779-1-git-send-email-cmaiolino@redhat.com>
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

On Tue, Jun 18, 2013 at 12:32:16PM -0300, Carlos Maiolino wrote:
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
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_iops.c |   27 ++++++++++++++-------------
>  1 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ca9ecaa..3547d89 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -467,9 +467,6 @@ xfs_setattr_mode(
>  	ASSERT(tp);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
> -	if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> -		mode &= ~S_ISGID;
> -
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

I'd leave the RO and shutdown checks outside the NOACL branch...

>  
> -	error = -inode_change_ok(inode, iattr);
> -	if (error)
> -		return XFS_ERROR(error);
> +		error = -inode_change_ok(inode, iattr);
> +		if (error)
> +			return XFS_ERROR(error);
> +	}
>  
>  	ASSERT((mask & ATTR_SIZE) == 0);
>  
> @@ -594,9 +594,10 @@ xfs_setattr_nonsize(
>  		 * The set-user-ID and set-group-ID bits of a file will be
>  		 * cleared upon successful return from chown()
>  		 */
> -		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> -		    !capable(CAP_FSETID))
> -			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
> +		if (!S_ISDIR(inode->i_mode))
> +			if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> +			    !capable(CAP_FSETID))
> +				ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);

I'm not sure I understand why this is part of this patch - the ACL
path does not enter this code branch (ATTR_UID/GID) so it doesn't
affect ACL inheritence. So this is some other behavioural change?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
