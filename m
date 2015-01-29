Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B45407F8E
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 09:34:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3EC1FAC002
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:34:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id z2umY3pqDV0PDHgh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 07:34:00 -0800 (PST)
Date: Thu, 29 Jan 2015 10:33:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/9] xfs: FSX_NONBLOCK is not used
Message-ID: <20150129153347.GA17652@laptop.bfoster>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
	<1422328486-24661-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422328486-24661-2-git-send-email-david@fromorbit.com>
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

On Tue, Jan 27, 2015 at 02:14:38PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is set if the filp is set ot non-blocking, but the flag is not
> used anywhere. Hence we can kill it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8810959..09325ff 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1016,7 +1016,6 @@ xfs_diflags_to_linux(
>  #define FSX_PROJID	1
>  #define FSX_EXTSIZE	2
>  #define FSX_XFLAGS	4
> -#define FSX_NONBLOCK	8
>  
>  STATIC int
>  xfs_ioctl_setattr(
> @@ -1299,8 +1298,6 @@ xfs_ioc_fssetxattr(
>  		return -EFAULT;
>  
>  	mask = FSX_XFLAGS | FSX_EXTSIZE | FSX_PROJID;
> -	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
> -		mask |= FSX_NONBLOCK;
>  
>  	error = mnt_want_write_file(filp);
>  	if (error)
> @@ -1343,8 +1340,6 @@ xfs_ioc_setxflags(
>  		return -EOPNOTSUPP;
>  
>  	mask = FSX_XFLAGS;
> -	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
> -		mask |= FSX_NONBLOCK;
>  	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
>  
>  	error = mnt_want_write_file(filp);
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
