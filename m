Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47BEF29DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 21:45:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2311E8F8049
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 19:45:49 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id XsWpjBqoEWyqjjMM for
	<xfs@oss.sgi.com>; Thu, 01 Aug 2013 19:45:48 -0700 (PDT)
Message-ID: <51FB1DAD.80506@cn.fujitsu.com>
Date: Fri, 02 Aug 2013 10:47:09 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v8 3/7] xfs: ioctl check for capabilities in the current
	user namespace
References: <20130801113006.13370058@oracle.com>
In-Reply-To: <20130801113006.13370058@oracle.com>
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

On 08/01/2013 11:30 PM, Dwight Engen wrote:
> Use inode_capable() to check if SUID|SGID bits should be cleared to match
> similar check in inode_change_ok().
> 
> The check for CAP_LINUX_IMMUTABLE was not modified since all other file
> systems also check against init_user_ns rather than current_user_ns.
> 
> Only allow changing of projid from init_user_ns.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---


looks good to me, thanks

Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>

>  fs/xfs/xfs_ioctl.c  | 11 +++++++++--
>  kernel/capability.c |  1 +
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6e2bca5..7b42192 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -981,15 +981,22 @@ xfs_ioctl_setattr(
>  	 * to the file owner ID, except in cases where the
>  	 * CAP_FSETID capability is applicable.
>  	 */
> -	if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
> +	if (!inode_owner_or_capable(VFS_I(ip))) {
>  		code = XFS_ERROR(EPERM);
>  		goto error_return;
>  	}
>  
>  	/*
>  	 * Do a quota reservation only if projid is actually going to change.
> +	 * Only allow changing of projid from init_user_ns since it is a
> +	 * non user namespace aware identifier.
>  	 */
>  	if (mask & FSX_PROJID) {
> +		if (current_user_ns() != &init_user_ns) {
> +			code = XFS_ERROR(EINVAL);
> +			goto error_return;
> +		}
> +
>  		if (XFS_IS_QUOTA_RUNNING(mp) &&
>  		    XFS_IS_PQUOTA_ON(mp) &&
>  		    xfs_get_projid(ip) != fa->fsx_projid) {
> @@ -1103,7 +1110,7 @@ xfs_ioctl_setattr(
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
