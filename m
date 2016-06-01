Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 25F957CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 20:42:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF1A68F8035
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 18:42:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yldK4Qiral7FBD81 for <xfs@oss.sgi.com>;
	Tue, 31 May 2016 18:42:33 -0700 (PDT)
Date: Wed, 1 Jun 2016 11:42:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: make several functions static
Message-ID: <20160601014214.GH12670@dastard>
References: <3ec4e394-1885-6f3e-f909-c9a77a72668b@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3ec4e394-1885-6f3e-f909-c9a77a72668b@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, May 19, 2016 at 02:16:25PM -0500, Eric Sandeen wrote:
> Al Viro noticed that xfs_lock_inodes should be static, and
> that led to ... a few more.
> 
> These are just the easy ones, others require moving functions
> higher in source files, so that's not done here to keep
> this review simple.
....
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index c5d4eba..04afe38 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -524,7 +524,7 @@ xfs_setattr_mode(
>  	inode->i_mode |= mode & ~S_IFMT;
>  }
>  
> -void
> +static void
>  xfs_setattr_time(
>  	struct xfs_inode	*ip,
>  	struct iattr		*iattr)
> diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
> index a0f84ab..d4bcc29 100644
> --- a/fs/xfs/xfs_iops.h
> +++ b/fs/xfs/xfs_iops.h
> @@ -30,7 +30,6 @@ extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
>   */
>  #define XFS_ATTR_NOACL		0x01	/* Don't call posix_acl_chmod */
>  
> -extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
>  extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
>  			       int flags);
>  extern int xfs_setattr_size(struct xfs_inode *ip, struct iattr *vap);

Just a note: xfs_pnfs.c uses this function, so it can't be made
static. I've dropped this hunk. Maybe add CONFIG_NFSD_PNFS=y to you
kernel config?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
