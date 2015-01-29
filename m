Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 130457F92
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 09:34:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B321DAC009
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:34:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b4rDXe9BUm2KtpR8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 07:34:56 -0800 (PST)
Date: Thu, 29 Jan 2015 10:34:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/9] xfs: disaggregate xfs_ioctl_setattr
Message-ID: <20150129153448.GD17652@laptop.bfoster>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
	<1422328486-24661-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422328486-24661-5-git-send-email-david@fromorbit.com>
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

On Tue, Jan 27, 2015 at 02:14:41PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_ioctl_setxflags doesn't need all of the functionailty in
> xfs_ioctl_setattr() and now we have separate helper functions that
> share the checks and modifications that xfs_ioctl_setxflags
> requires. Hence disaggregate it from xfs_ioctl_setattr() to allow
> further work to be done on xfs_ioctl_setattr.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d06f596..c71f32d 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1321,14 +1321,14 @@ xfs_ioc_getxflags(
>  
>  STATIC int
>  xfs_ioc_setxflags(
> -	xfs_inode_t		*ip,
> +	struct xfs_inode	*ip,
>  	struct file		*filp,
>  	void			__user *arg)
>  {
> +	struct xfs_trans	*tp;
>  	struct fsxattr		fa;
>  	unsigned int		flags;
> -	unsigned int		mask;
> -	int error;
> +	int			error;
>  
>  	if (copy_from_user(&flags, arg, sizeof(flags)))
>  		return -EFAULT;
> @@ -1338,13 +1338,26 @@ xfs_ioc_setxflags(
>  		      FS_SYNC_FL))
>  		return -EOPNOTSUPP;
>  
> -	mask = FSX_XFLAGS;
>  	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
>  
>  	error = mnt_want_write_file(filp);
>  	if (error)
>  		return error;
> -	error = xfs_ioctl_setattr(ip, &fa, mask);
> +
> +	tp = xfs_ioctl_setattr_get_trans(ip);
> +	if (IS_ERR(tp)) {
> +		error = PTR_ERR(tp);
> +		goto out_drop_write;
> +	}
> +
> +	error = xfs_ioctl_setattr_xflags(tp, ip, &fa);
> +	if (error) {
> +		xfs_trans_cancel(tp, 0);
> +		goto out_drop_write;
> +	}
> +
> +	error = xfs_trans_commit(tp, 0);
> +out_drop_write:
>  	mnt_drop_write_file(filp);
>  	return error;
>  }
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
