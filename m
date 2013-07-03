Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EF777CBF
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 10:24:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 423808F8033
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 08:24:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id exwBhjZGWLdstRfV for
	<xfs@oss.sgi.com>; Wed, 03 Jul 2013 08:24:18 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r63FOG1G008746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 3 Jul 2013 11:24:17 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-139.phx2.redhat.com
	[10.3.113.139])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r63FODdG019752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 3 Jul 2013 11:24:15 -0400
Date: Wed, 3 Jul 2013 12:24:12 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Subject: [PATCH] xfs: fix sgid inheritance for
	subdirectories inheriting default acls [V3]
Message-ID: <20130703152410.GH24238@andromeda.usersys.redhat.com>
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
To: xfs@oss.sgi.com

Hi, any comments on this one?

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
>  
>  	ASSERT((mask & ATTR_SIZE) == 0);
>  
> -- 
> 1.8.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
