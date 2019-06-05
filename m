Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34624 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEWal (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 18:30:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MTTn3183711
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:30:40 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2suj0qn6yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 22:30:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MUcDD017017
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:30:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2swnhaedsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 22:30:40 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x55MUdE5031497
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:30:40 GMT
Subject: Re: [PATCH 6/9] xfs: wire up the new v5 bulkstat_single ioctl
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
 <155916888978.758159.5450955030930365488.stgit@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <3ffdedd0-8199-b522-4361-503ea506bf60@oracle.com>
Date: Wed, 5 Jun 2019 15:30:38 -0700
MIME-Version: 1.0
In-Reply-To: <155916888978.758159.5450955030930365488.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 5/29/19 3:28 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Wire up the V5 BULKSTAT_SINGLE ioctl and rename the old one V1.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_fs.h |   16 +++++++++
>   fs/xfs/xfs_ioctl.c     |   85 ++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/xfs/xfs_ioctl32.c   |    1 +
>   fs/xfs/xfs_ondisk.h    |    1 +
>   4 files changed, 103 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 960f3542e207..95d0411dae9b 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -468,6 +468,16 @@ struct xfs_bulk_ireq {
>   
>   #define XFS_BULK_IREQ_FLAGS_ALL	(0)
>   
> +/* Header for a single inode request. */
> +struct xfs_ireq {
> +	uint64_t	ino;		/* I/O: start with this inode	*/
> +	uint32_t	flags;		/* I/O: operation flags		*/
> +	uint32_t	reserved32;	/* must be zero			*/
> +	uint64_t	reserved[2];	/* must be zero			*/
> +};
> +
> +#define XFS_IREQ_FLAGS_ALL	(0)
> +
>   /*
>    * ioctl structures for v5 bulkstat and inumbers requests
>    */
> @@ -478,6 +488,11 @@ struct xfs_bulkstat_req {
>   #define XFS_BULKSTAT_REQ_SIZE(nr)	(sizeof(struct xfs_bulkstat_req) + \
>   					 (nr) * sizeof(struct xfs_bulkstat))
>   
> +struct xfs_bulkstat_single_req {
> +	struct xfs_ireq		hdr;
> +	struct xfs_bulkstat	bulkstat;
> +};
> +
>   /*
>    * Error injection.
>    */
> @@ -780,6 +795,7 @@ struct xfs_scrub_metadata {
>   #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
>   #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
>   #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
> +#define XFS_IOC_BULKSTAT_SINGLE	     _IOR ('X', 128, struct xfs_bulkstat_single_req)
>   /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>   
>   
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f6724c75ba97..f6971eb9561e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -923,6 +923,89 @@ xfs_ioc_bulkstat(
>   	return 0;
>   }
>   
> +/*
> + * Check the incoming singleton request @hdr from userspace and initialize the
> + * internal @breq bulk request appropriately.  Returns 0 if the bulk request
> + * should proceed; or the usual negative error code.
> + */
> +static int
> +xfs_ireq_setup(
> +	struct xfs_mount	*mp,
> +	struct xfs_ireq		*hdr,
> +	struct xfs_ibulk	*breq,
> +	void __user		*ubuffer)
> +{
> +	if ((hdr->flags & ~XFS_IREQ_FLAGS_ALL) ||
> +	    hdr->reserved32 ||
> +	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
> +		return -EINVAL;
> +
> +	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
> +		return -EINVAL;
> +
> +	breq->ubuffer = ubuffer;
> +	breq->icount = 1;
> +	breq->startino = hdr->ino;
> +	return 0;
> +}
> +
> +/*
> + * Update the userspace singleton request @hdr to reflect the end state of the
> + * internal bulk request @breq.  If @error is negative then we return just
> + * that; otherwise we copy the state so that userspace can discover what
> + * happened.
> + */
> +static int
> +xfs_ireq_teardown(
> +	struct xfs_ireq		*hdr,
> +	struct xfs_ibulk	*breq,
> +	int			error)
> +{
> +	if (error < 0)
> +		return error;
Similar nit about the error code here too.  This function is so small, 
it might make sense to just factor it up into the calling function, 
sense I don't see it used else where in the set.  I suppose it's good to 
keep things consistent too though, it seem to be the pattern that the 
other ioctls use.

I think the rest is ok though

Allison

> +
> +	hdr->ino = breq->startino;
> +	return 0;
> +}
> +
> +/* Handle the v5 bulkstat_single ioctl. */
> +STATIC int
> +xfs_ioc_bulkstat_single(
> +	struct xfs_mount	*mp,
> +	unsigned int		cmd,
> +	struct xfs_bulkstat_single_req __user *arg)
> +{
> +	struct xfs_ireq		hdr;
> +	struct xfs_ibulk	breq = {
> +		.mp		= mp,
> +	};
> +	int			error;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +
> +	if (copy_from_user(&hdr, &arg->hdr, sizeof(hdr)))
> +		return -EFAULT;
> +
> +	error = xfs_ireq_setup(mp, &hdr, &breq, &arg->bulkstat);
> +	if (error)
> +		return error;
> +
> +	error = xfs_bulkstat_one(&breq, xfs_bulkstat_fmt);
> +
> +	error = xfs_ireq_teardown(&hdr, &breq, error);
> +	if (error)
> +		return error;
> +
> +	if (copy_to_user(&arg->hdr, &hdr, sizeof(hdr)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>   STATIC int
>   xfs_ioc_fsgeometry(
>   	struct xfs_mount	*mp,
> @@ -2089,6 +2172,8 @@ xfs_file_ioctl(
>   
>   	case XFS_IOC_BULKSTAT:
>   		return xfs_ioc_bulkstat(mp, cmd, arg);
> +	case XFS_IOC_BULKSTAT_SINGLE:
> +		return xfs_ioc_bulkstat_single(mp, cmd, arg);
>   
>   	case XFS_IOC_FSGEOMETRY_V1:
>   		return xfs_ioc_fsgeometry(mp, arg, 3);
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 84c342be4536..08a90e3459d1 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -577,6 +577,7 @@ xfs_file_compat_ioctl(
>   	case FS_IOC_GETFSMAP:
>   	case XFS_IOC_SCRUB_METADATA:
>   	case XFS_IOC_BULKSTAT:
> +	case XFS_IOC_BULKSTAT_SINGLE:
>   		return xfs_file_ioctl(filp, cmd, p);
>   #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
>   	/*
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 954484c6eb96..fa1252657b08 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -150,6 +150,7 @@ xfs_check_ondisk_structs(void)
>   	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
>   	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
>   	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_single_req,	224);
>   }
>   
>   #endif /* __XFS_ONDISK_H */
> 
