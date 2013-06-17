Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61F077F37
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 07:12:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B056AC004
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 05:12:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UMbl4kHElzNAkxXt for
	<xfs@oss.sgi.com>; Mon, 17 Jun 2013 05:12:08 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5HCC8nZ019893
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 08:12:08 -0400
Message-ID: <51BEFE1D.3000604@redhat.com>
Date: Mon, 17 Jun 2013 08:16:29 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix sgid inheritance for subdirectories inheriting
	default acls
References: <1371238877-5722-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1371238877-5722-1-git-send-email-cmaiolino@redhat.com>
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

On 06/14/2013 03:41 PM, Carlos Maiolino wrote:
> XFS removes sgid bits of subdirectories created under a directory containing a
> default acl.
> 
> When a default acl is set, it implies xfs to call xfs_setattr_nonsize() in its
> code path. Such function is shared among mkdir and chmod system calls, and
> does some checks unneeded by mkdir (calling inode_change_ok()). Such checks
> remove sgid bit from the inode after it has been granted. So, this patch wraps
> up these checks to be used only in chmod path.
> 
> Also, chmod should not remove sgid bit from an inode if this is a directory, so,
> it adds a check if S_ISDIR is set in the inode mode, into xfs_setattr_nonsize()
> 
> Done that, xfs_setattr_mode() doesn't need to re-check for group id and
> capabilities permissions, this only implies in another try to remove sgid bit
> from the directories. Such check is already done either on inode_change_ok() or
> xfs_setattr_nonsize().
> 
> This addresses SGI bug 280:
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=280
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---

Hi Carlos,

A couple comments, mostly aesthetic...

>  fs/xfs/xfs_iops.c |   51 ++++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 34 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ca9ecaa..5c9c505 100644
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
> @@ -477,23 +474,20 @@ xfs_setattr_mode(
>  	inode->i_mode |= mode & ~S_IFMT;
>  }
>  
> +/* Check inode permissions and filesystem errors
> + *
> + * Wrapper to some pre-checks needed while changing
> + * inode attributes
> + */
>  int
> -xfs_setattr_nonsize(
> +xfs_setattr_setup(
>  	struct xfs_inode	*ip,
>  	struct iattr		*iattr,
>  	int			flags)
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
> -	int			mask = iattr->ia_valid;
> -	xfs_trans_t		*tp;
>  	int			error;
> -	uid_t			uid = 0, iuid = 0;
> -	gid_t			gid = 0, igid = 0;
> -	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
> -	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
> -
> -	trace_xfs_setattr(ip);
>  
>  	if (mp->m_flags & XFS_MOUNT_RDONLY)
>  		return XFS_ERROR(EROFS);
> @@ -505,6 +499,27 @@ xfs_setattr_nonsize(
>  	if (error)
>  		return XFS_ERROR(error);
>  

Is it safe to package up these other checks as well out of that inherit
code path (i.e., the read-only and shutdown check)?

> +	return xfs_setattr_nonsize(ip, iattr, flags);

It seems a little confusing (IMO) for a _setup() function to go and do
work by calling xfs_setattr_nonsize(). What about creating the helper
check function, but calling it and xfs_attr_nonsize() from
xfs_vn_setattr() (assuming _setup() doesn't return an error)?

Brian

> +}
> +
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
>  	ASSERT((mask & ATTR_SIZE) == 0);
>  
>  	/*
> @@ -592,11 +607,13 @@ xfs_setattr_nonsize(
>  		 * CAP_FSETID overrides the following restrictions:
>  		 *
>  		 * The set-user-ID and set-group-ID bits of a file will be
> -		 * cleared upon successful return from chown()
> +		 * cleared upon successful return from chown().
> +		 * Of a directory, these bits should be kept.
>  		 */
> -		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> -		    !capable(CAP_FSETID))
> -			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
> +		if (!S_ISDIR(inode->i_mode))
> +			if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> +			    !capable(CAP_FSETID))
> +				ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
>  
>  		/*
>  		 * Change the ownerships and register quota modifications
> @@ -915,7 +932,7 @@ xfs_vn_setattr(
>  {
>  	if (iattr->ia_valid & ATTR_SIZE)
>  		return -xfs_setattr_size(XFS_I(dentry->d_inode), iattr, 0);
> -	return -xfs_setattr_nonsize(XFS_I(dentry->d_inode), iattr, 0);
> +	return -xfs_setattr_setup(XFS_I(dentry->d_inode), iattr, 0);
>  }
>  
>  STATIC int
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
