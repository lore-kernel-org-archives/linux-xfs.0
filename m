Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCNWW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 09:22:22 -0400
Date: Wed, 3 Jul 2019 09:22:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/9] xfs: rename bulkstat functions
Message-ID: <20190703132219.GB26057@bfoster>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158194549.495715.11820133364251169894.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158194549.495715.11820133364251169894.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

On Wed, Jun 26, 2019 at 01:45:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename the bulkstat functions to 'fsbulkstat' so that they match the
> ioctl names.  We will be introducing a new set of bulkstat/inumbers
> ioctls soon, and it will be important to keep the names straight.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c   |   14 +++++++-------
>  fs/xfs/xfs_ioctl.h   |    5 +++--
>  fs/xfs/xfs_ioctl32.c |   18 +++++++++---------
>  3 files changed, 19 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 34b38d8e8dc9..5e0476003763 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -724,7 +724,7 @@ xfs_ioc_space(
>  
>  /* Return 0 on success or positive error */
>  int
> -xfs_bulkstat_one_fmt(
> +xfs_fsbulkstat_one_fmt(
>  	struct xfs_ibulk	*breq,
>  	const struct xfs_bstat	*bstat)
>  {
> @@ -734,7 +734,7 @@ xfs_bulkstat_one_fmt(
>  }
>  
>  int
> -xfs_inumbers_fmt(
> +xfs_fsinumbers_fmt(
>  	struct xfs_ibulk	*breq,
>  	const struct xfs_inogrp	*igrp)
>  {
> @@ -744,7 +744,7 @@ xfs_inumbers_fmt(
>  }
>  
>  STATIC int
> -xfs_ioc_bulkstat(
> +xfs_ioc_fsbulkstat(
>  	xfs_mount_t		*mp,
>  	unsigned int		cmd,
>  	void			__user *arg)
> @@ -794,16 +794,16 @@ xfs_ioc_bulkstat(
>  	 */
>  	if (cmd == XFS_IOC_FSINUMBERS) {
>  		breq.startino = lastino ? lastino + 1 : 0;
> -		error = xfs_inumbers(&breq, xfs_inumbers_fmt);
> +		error = xfs_inumbers(&breq, xfs_fsinumbers_fmt);
>  		lastino = breq.startino - 1;
>  	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
>  		breq.startino = lastino;
>  		breq.icount = 1;
> -		error = xfs_bulkstat_one(&breq, xfs_bulkstat_one_fmt);
> +		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
>  		lastino = breq.startino;
>  	} else {	/* XFS_IOC_FSBULKSTAT */
>  		breq.startino = lastino ? lastino + 1 : 0;
> -		error = xfs_bulkstat(&breq, xfs_bulkstat_one_fmt);
> +		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
>  		lastino = breq.startino - 1;
>  	}
>  
> @@ -1983,7 +1983,7 @@ xfs_file_ioctl(
>  	case XFS_IOC_FSBULKSTAT_SINGLE:
>  	case XFS_IOC_FSBULKSTAT:
>  	case XFS_IOC_FSINUMBERS:
> -		return xfs_ioc_bulkstat(mp, cmd, arg);
> +		return xfs_ioc_fsbulkstat(mp, cmd, arg);
>  
>  	case XFS_IOC_FSGEOMETRY_V1:
>  		return xfs_ioc_fsgeometry(mp, arg, 3);
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index fb303eaa8863..cb34bc821201 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -81,7 +81,8 @@ struct xfs_ibulk;
>  struct xfs_bstat;
>  struct xfs_inogrp;
>  
> -int xfs_bulkstat_one_fmt(struct xfs_ibulk *breq, const struct xfs_bstat *bstat);
> -int xfs_inumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
> +int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
> +			   const struct xfs_bstat *bstat);
> +int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
>  
>  #endif
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index d7c5153e1b61..9e5cf3988d3e 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -86,7 +86,7 @@ xfs_compat_growfs_rt_copyin(
>  }
>  
>  STATIC int
> -xfs_inumbers_fmt_compat(
> +xfs_fsinumbers_fmt_compat(
>  	struct xfs_ibulk	*breq,
>  	const struct xfs_inogrp	*igrp)
>  {
> @@ -101,7 +101,7 @@ xfs_inumbers_fmt_compat(
>  }
>  
>  #else
> -#define xfs_inumbers_fmt_compat xfs_inumbers_fmt
> +#define xfs_fsinumbers_fmt_compat xfs_fsinumbers_fmt
>  #endif	/* BROKEN_X86_ALIGNMENT */
>  
>  STATIC int
> @@ -171,7 +171,7 @@ xfs_bstime_store_compat(
>  
>  /* Return 0 on success or positive error (to xfs_bulkstat()) */
>  STATIC int
> -xfs_bulkstat_one_fmt_compat(
> +xfs_fsbulkstat_one_fmt_compat(
>  	struct xfs_ibulk	*breq,
>  	const struct xfs_bstat	*buffer)
>  {
> @@ -206,7 +206,7 @@ xfs_bulkstat_one_fmt_compat(
>  
>  /* copied from xfs_ioctl.c */
>  STATIC int
> -xfs_compat_ioc_bulkstat(
> +xfs_compat_ioc_fsbulkstat(
>  	xfs_mount_t		  *mp,
>  	unsigned int		  cmd,
>  	struct compat_xfs_fsop_bulkreq __user *p32)
> @@ -226,8 +226,8 @@ xfs_compat_ioc_bulkstat(
>  	 * to userpace memory via bulkreq.ubuffer.  Normally the compat
>  	 * functions and structure size are the correct ones to use ...
>  	 */
> -	inumbers_fmt_pf		inumbers_func = xfs_inumbers_fmt_compat;
> -	bulkstat_one_fmt_pf	bs_one_func = xfs_bulkstat_one_fmt_compat;
> +	inumbers_fmt_pf		inumbers_func = xfs_fsinumbers_fmt_compat;
> +	bulkstat_one_fmt_pf	bs_one_func = xfs_fsbulkstat_one_fmt_compat;
>  
>  #ifdef CONFIG_X86_X32
>  	if (in_x32_syscall()) {
> @@ -239,8 +239,8 @@ xfs_compat_ioc_bulkstat(
>  		 * the data written out in compat layout will not match what
>  		 * x32 userspace expects.
>  		 */
> -		inumbers_func = xfs_inumbers_fmt;
> -		bs_one_func = xfs_bulkstat_one_fmt;
> +		inumbers_func = xfs_fsinumbers_fmt;
> +		bs_one_func = xfs_fsbulkstat_one_fmt;
>  	}
>  #endif
>  
> @@ -669,7 +669,7 @@ xfs_file_compat_ioctl(
>  	case XFS_IOC_FSBULKSTAT_32:
>  	case XFS_IOC_FSBULKSTAT_SINGLE_32:
>  	case XFS_IOC_FSINUMBERS_32:
> -		return xfs_compat_ioc_bulkstat(mp, cmd, arg);
> +		return xfs_compat_ioc_fsbulkstat(mp, cmd, arg);
>  	case XFS_IOC_FD_TO_HANDLE_32:
>  	case XFS_IOC_PATH_TO_HANDLE_32:
>  	case XFS_IOC_PATH_TO_FSHANDLE_32: {
> 
