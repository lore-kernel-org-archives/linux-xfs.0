Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE04C7F5E
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 00:29:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4996DAC00E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 22:29:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	L0GjUqi4uLklXbuZ for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 22:29:22 -0700 (PDT)
Date: Fri, 19 Jul 2013 15:29:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 3/7] xfs: ioctl check for capabilities in the current
	user namespace
Message-ID: <20130719052920.GU11674@dastard>
References: <20130717114727.23491330@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130717114727.23491330@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 17, 2013 at 11:47:27AM -0400, Dwight Engen wrote:
> Use inode_capable() to check if SUID|SGID bits should be cleared to match
> similar check in inode_change_ok().
> 
> The check for CAP_LINUX_IMMUTABLE was not modified since all other file
> systems also check against init_user_ns rather than current_user_ns.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c  | 4 ++--
>  kernel/capability.c | 1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6e2bca5..8edc780 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -981,7 +981,7 @@ xfs_ioctl_setattr(
>  	 * to the file owner ID, except in cases where the
>  	 * CAP_FSETID capability is applicable.
>  	 */
> -	if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
> +	if (!inode_owner_or_capable(VFS_I(ip))) {
>  		code = XFS_ERROR(EPERM);
>  		goto error_return;
>  	}
> @@ -1103,7 +1103,7 @@ xfs_ioctl_setattr(
>  		 * cleared upon successful return from chown()
>  		 */
>  		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> -		    !capable(CAP_FSETID))
> +		    !inode_capable(VFS_I(ip), CAP_FSETID))
>  			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
>  
>  		/*
> diff --git a/kernel/capability.c b/kernel/capability.c
> index f6c2ce5..a4b6744 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -464,3 +464,4 @@ bool inode_capable(const struct inode *inode, int cap)
>  
>  	return ns_capable(ns, cap) && kuid_has_mapping(ns, inode->i_uid);
>  }
> +EXPORT_SYMBOL(inode_capable);

Looks good. I'm surprised that no-one else has needed this exported;
there are several non-core !capable(CAP_FSETID) checks that are
similar to this one that weren't converted to inode_capable()
checks, yet the core inode_change_ok()/setattr_copy() code was...

Regardless,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
