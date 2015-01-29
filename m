Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB46F7F37
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 09:35:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2638BAC002
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:35:28 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id B8SFjiJD0BDCTeyj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 07:35:27 -0800 (PST)
Date: Thu, 29 Jan 2015 10:35:15 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/9] xfs: XFS_IOCTL_SETXATTR can run in user namespaces
Message-ID: <20150129153515.GF17652@laptop.bfoster>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
	<1422328486-24661-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422328486-24661-7-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: iustin@k1024.org, xfs@oss.sgi.com

On Tue, Jan 27, 2015 at 02:14:43PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently XFS_IOCTL_SETXATTR will fail if run in a user namespace as
> it it not allowed to change project IDs. The current code, however,
> also prevents any other change being made as well, so things like
> extent size hints cannot be set in user namespaces. This is wrong,
> so only disallow access to project IDs and related flags from inside
> the init namespace.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ioctl.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 563d2b4..ae6e1e3 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1120,6 +1120,19 @@ xfs_ioctl_setattr(
>  		return -EINVAL;
>  
>  	/*
> +	 * Project Quota ID state is only allowed to change from within the init
> +	 * namespace. Enforce that restriction only if we are trying to change
> +	 * the quota ID state. Everything else is allowed in user namespaces.
> +	 */
> +	if (current_user_ns() != &init_user_ns) {
> +		if (xfs_get_projid(ip) != fa->fsx_projid)
> +			return -EINVAL;
> +		if ((fa->fsx_xflags & XFS_XFLAG_PROJINHERIT) ^
> +		    (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT))

Why not use != here? Looks fine, anyways:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +			return -EINVAL;
> +	}
> +
> +	/*
>  	 * If disk quotas is on, we make sure that the dquots do exist on disk,
>  	 * before we start any other transactions. Trying to do this later
>  	 * is messy. We don't care to take a readlock to look at the ids
> @@ -1139,15 +1152,6 @@ xfs_ioctl_setattr(
>  	if (IS_ERR(tp))
>  		return PTR_ERR(tp);
>  
> -	/*
> -	 * Do a quota reservation only if projid is actually going to change.
> -	 * Only allow changing of projid from init_user_ns since it is a
> -	 * non user namespace aware identifier.
> -	 */
> -	if (current_user_ns() != &init_user_ns) {
> -		code = -EINVAL;
> -		goto error_return;
> -	}
>  
>  	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
>  	    xfs_get_projid(ip) != fa->fsx_projid) {
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
