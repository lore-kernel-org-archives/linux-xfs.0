Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADA047F4E
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 23:14:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47D63AC003
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 21:14:42 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id iB7SyCEm6e0g5yMV for
	<xfs@oss.sgi.com>; Tue, 30 Jul 2013 21:14:40 -0700 (PDT)
Message-ID: <51F88F82.4090606@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 12:16:02 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 3/7] xfs: ioctl check for capabilities in the current
	user namespace
References: <20130729230650.5db8228a@oracle.com>
In-Reply-To: <20130729230650.5db8228a@oracle.com>
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

On 07/30/2013 11:06 AM, Dwight Engen wrote:
> Use inode_capable() to check if SUID|SGID bits should be cleared to match
> similar check in inode_change_ok().
> 
> The check for CAP_LINUX_IMMUTABLE was not modified since all other file
> systems also check against init_user_ns rather than current_user_ns.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

Though the user in container can get his quota limit info which is configured on host,
but he has no rights to modify it, so this patch looks good to me.

Thanks

Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>


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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
