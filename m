Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54294 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEW3h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 18:29:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MTa3e176333
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:29:36 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2sugstna9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 22:29:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MTCPP139856
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:29:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2swngm6e96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 22:29:36 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x55MTZsm008188
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:29:35 GMT
Subject: Re: [PATCH 2/9] xfs: rename bulkstat functions
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
 <155916886337.758159.1536999475082923389.stgit@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <483b10ce-5767-c0b0-b160-f2236f7861f2@oracle.com>
Date: Wed, 5 Jun 2019 15:29:33 -0700
MIME-Version: 1.0
In-Reply-To: <155916886337.758159.1536999475082923389.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 5/29/19 3:27 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename the bulkstat functions to 'fsbulkstat' so that they match the
> ioctl names.  We will be introducing a new set of bulkstat/inumbers
> ioctls soon, and it will be important to keep the names straight.
> 
Looks OK

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_ioctl.c   |   14 +++++++-------
>   fs/xfs/xfs_ioctl.h   |    5 +++--
>   fs/xfs/xfs_ioctl32.c |   18 +++++++++---------
>   3 files changed, 19 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 456a0e132d6d..f02a9bd757ad 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -723,7 +723,7 @@ xfs_ioc_space(
>   
>   /* Return 0 on success or positive error */
>   int
> -xfs_bulkstat_one_fmt(
> +xfs_fsbulkstat_one_fmt(
>   	struct xfs_ibulk	*breq,
>   	const struct xfs_bstat	*bstat)
>   {
> @@ -733,7 +733,7 @@ xfs_bulkstat_one_fmt(
>   }
>   
>   int
> -xfs_inumbers_fmt(
> +xfs_fsinumbers_fmt(
>   	struct xfs_ibulk	*breq,
>   	const struct xfs_inogrp	*igrp)
>   {
> @@ -743,7 +743,7 @@ xfs_inumbers_fmt(
>   }
>   
>   STATIC int
> -xfs_ioc_bulkstat(
> +xfs_ioc_fsbulkstat(
>   	xfs_mount_t		*mp,
>   	unsigned int		cmd,
>   	void			__user *arg)
> @@ -790,15 +790,15 @@ xfs_ioc_bulkstat(
>   	 */
>   	if (cmd == XFS_IOC_FSINUMBERS) {
>   		breq.startino = lastino + 1;
> -		error = xfs_inumbers(&breq, xfs_inumbers_fmt);
> +		error = xfs_inumbers(&breq, xfs_fsinumbers_fmt);
>   		lastino = breq.startino - 1;
>   	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
>   		breq.startino = lastino;
> -		error = xfs_bulkstat_one(&breq, xfs_bulkstat_one_fmt);
> +		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
>   		lastino = breq.startino;
>   	} else {	/* XFS_IOC_FSBULKSTAT */
>   		breq.startino = lastino + 1;
> -		error = xfs_bulkstat(&breq, xfs_bulkstat_one_fmt);
> +		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
>   		lastino = breq.startino - 1;
>   	}
>   
> @@ -1978,7 +1978,7 @@ xfs_file_ioctl(
>   	case XFS_IOC_FSBULKSTAT_SINGLE:
>   	case XFS_IOC_FSBULKSTAT:
>   	case XFS_IOC_FSINUMBERS:
> -		return xfs_ioc_bulkstat(mp, cmd, arg);
> +		return xfs_ioc_fsbulkstat(mp, cmd, arg);
>   
>   	case XFS_IOC_FSGEOMETRY_V1:
>   		return xfs_ioc_fsgeometry(mp, arg, 3);
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index fb303eaa8863..cb34bc821201 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -81,7 +81,8 @@ struct xfs_ibulk;
>   struct xfs_bstat;
>   struct xfs_inogrp;
>   
> -int xfs_bulkstat_one_fmt(struct xfs_ibulk *breq, const struct xfs_bstat *bstat);
> -int xfs_inumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
> +int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
> +			   const struct xfs_bstat *bstat);
> +int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
>   
>   #endif
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 8dcb7046ed15..af753f2708e8 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -84,7 +84,7 @@ xfs_compat_growfs_rt_copyin(
>   }
>   
>   STATIC int
> -xfs_inumbers_fmt_compat(
> +xfs_fsinumbers_fmt_compat(
>   	struct xfs_ibulk	*breq,
>   	const struct xfs_inogrp	*igrp)
>   {
> @@ -99,7 +99,7 @@ xfs_inumbers_fmt_compat(
>   }
>   
>   #else
> -#define xfs_inumbers_fmt_compat xfs_inumbers_fmt
> +#define xfs_fsinumbers_fmt_compat xfs_fsinumbers_fmt
>   #endif	/* BROKEN_X86_ALIGNMENT */
>   
>   STATIC int
> @@ -169,7 +169,7 @@ xfs_bstime_store_compat(
>   
>   /* Return 0 on success or positive error (to xfs_bulkstat()) */
>   STATIC int
> -xfs_bulkstat_one_fmt_compat(
> +xfs_fsbulkstat_one_fmt_compat(
>   	struct xfs_ibulk	*breq,
>   	const struct xfs_bstat	*buffer)
>   {
> @@ -204,7 +204,7 @@ xfs_bulkstat_one_fmt_compat(
>   
>   /* copied from xfs_ioctl.c */
>   STATIC int
> -xfs_compat_ioc_bulkstat(
> +xfs_compat_ioc_fsbulkstat(
>   	xfs_mount_t		  *mp,
>   	unsigned int		  cmd,
>   	struct compat_xfs_fsop_bulkreq __user *p32)
> @@ -223,8 +223,8 @@ xfs_compat_ioc_bulkstat(
>   	 * to userpace memory via bulkreq.ubuffer.  Normally the compat
>   	 * functions and structure size are the correct ones to use ...
>   	 */
> -	inumbers_fmt_pf		inumbers_func = xfs_inumbers_fmt_compat;
> -	bulkstat_one_fmt_pf	bs_one_func = xfs_bulkstat_one_fmt_compat;
> +	inumbers_fmt_pf		inumbers_func = xfs_fsinumbers_fmt_compat;
> +	bulkstat_one_fmt_pf	bs_one_func = xfs_fsbulkstat_one_fmt_compat;
>   
>   #ifdef CONFIG_X86_X32
>   	if (in_x32_syscall()) {
> @@ -236,8 +236,8 @@ xfs_compat_ioc_bulkstat(
>   		 * the data written out in compat layout will not match what
>   		 * x32 userspace expects.
>   		 */
> -		inumbers_func = xfs_inumbers_fmt;
> -		bs_one_func = xfs_bulkstat_one_fmt;
> +		inumbers_func = xfs_fsinumbers_fmt;
> +		bs_one_func = xfs_fsbulkstat_one_fmt;
>   	}
>   #endif
>   
> @@ -665,7 +665,7 @@ xfs_file_compat_ioctl(
>   	case XFS_IOC_FSBULKSTAT_32:
>   	case XFS_IOC_FSBULKSTAT_SINGLE_32:
>   	case XFS_IOC_FSINUMBERS_32:
> -		return xfs_compat_ioc_bulkstat(mp, cmd, arg);
> +		return xfs_compat_ioc_fsbulkstat(mp, cmd, arg);
>   	case XFS_IOC_FD_TO_HANDLE_32:
>   	case XFS_IOC_PATH_TO_HANDLE_32:
>   	case XFS_IOC_PATH_TO_FSHANDLE_32: {
> 
