Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34414 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEWa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 18:30:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MT2HL183630
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:30:25 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2suj0qn6y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 22:30:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MU5Yd138772
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:30:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2swngj4fph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 22:30:24 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x55MUNcR031356
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:30:23 GMT
Subject: Re: [PATCH 5/9] xfs: wire up new v5 bulkstat ioctls
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
 <155916888365.758159.10884362336065224287.stgit@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <dfe26188-ce75-a916-db26-eaf8286882e9@oracle.com>
Date: Wed, 5 Jun 2019 15:30:21 -0700
MIME-Version: 1.0
In-Reply-To: <155916888365.758159.10884362336065224287.stgit@magnolia>
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
> Wire up the new v5 BULKSTAT ioctl and rename the old one to V1.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_fs.h |   24 +++++++++++
>   fs/xfs/xfs_ioctl.c     |  104 ++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/xfs/xfs_ioctl32.c   |    1
>   fs/xfs/xfs_ondisk.h    |    1
>   4 files changed, 129 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 8b8fe78511fb..960f3542e207 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -435,7 +435,6 @@ struct xfs_fsop_bulkreq {
>   	__s32		__user *ocount;	/* output count pointer		*/
>   };
>   
> -
>   /*
>    * Structures returned from xfs_inumbers routine (XFS_IOC_FSINUMBERS).
>    */
> @@ -457,6 +456,28 @@ struct xfs_inumbers {
>   #define XFS_INUMBERS_VERSION_V1	(1)
>   #define XFS_INUMBERS_VERSION_V5	(5)
>   
> +/* Header for bulk inode requests. */
> +struct xfs_bulk_ireq {
> +	uint64_t	ino;		/* I/O: start with this inode	*/
> +	uint32_t	flags;		/* I/O: operation flags		*/
> +	uint32_t	icount;		/* I: count of entries in buffer */
> +	uint32_t	ocount;		/* O: count of entries filled out */
> +	uint32_t	reserved32;	/* must be zero			*/
> +	uint64_t	reserved[5];	/* must be zero			*/
> +};
> +
> +#define XFS_BULK_IREQ_FLAGS_ALL	(0)
> +
> +/*
> + * ioctl structures for v5 bulkstat and inumbers requests
> + */
> +struct xfs_bulkstat_req {
> +	struct xfs_bulk_ireq	hdr;
> +	struct xfs_bulkstat	bulkstat[];
> +};
> +#define XFS_BULKSTAT_REQ_SIZE(nr)	(sizeof(struct xfs_bulkstat_req) + \
> +					 (nr) * sizeof(struct xfs_bulkstat))
> +
>   /*
>    * Error injection.
>    */
> @@ -758,6 +779,7 @@ struct xfs_scrub_metadata {
>   #define XFS_IOC_FSGEOMETRY_V4	     _IOR ('X', 124, struct xfs_fsop_geom_v4)
>   #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
>   #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
> +#define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
>   /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>   
>   
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index e43ad688e683..f6724c75ba97 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -822,6 +822,107 @@ xfs_ioc_fsbulkstat(
>   	return 0;
>   }
>   
> +/* Return 0 on success or positive error */
> +static int
> +xfs_bulkstat_fmt(
> +	struct xfs_ibulk		*breq,
> +	const struct xfs_bulkstat	*bstat)
> +{
> +	if (copy_to_user(breq->ubuffer, bstat, sizeof(struct xfs_bulkstat)))
> +		return -EFAULT;
> +	return xfs_ibulk_advance(breq, sizeof(struct xfs_bulkstat));
> +}
> +
> +/*
> + * Check the incoming bulk request @hdr from userspace and initialize the
> + * internal @breq bulk request appropriately.  Returns 0 if the bulk request
> + * should proceed; 1 if there's nothing to do; or the usual negative error
> + * code.
> + */
> +static int
> +xfs_bulk_ireq_setup(
> +	struct xfs_mount	*mp,
> +	struct xfs_bulk_ireq	*hdr,
> +	struct xfs_ibulk	*breq,
> +	void __user		*ubuffer)
> +{
> +	if (hdr->icount == 0 ||
> +	    (hdr->flags & ~XFS_BULK_IREQ_FLAGS_ALL) ||
> +	    hdr->reserved32 ||
> +	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
> +		return -EINVAL;
> +
> +	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
> +		goto no_results;
> +
> +	breq->ubuffer = ubuffer;
> +	breq->icount = hdr->icount;
> +	breq->startino = hdr->ino;
> +	return 0;
> +no_results:
> +	hdr->ocount = 0;
> +	return 1;
> +}
> +
> +/*
> + * Update the userspace bulk request @hdr to reflect the end state of the
> + * internal bulk request @breq.  If @error is negative then we return just
> + * that; otherwise (@error is 0 or 1) we copy the state so that userspace
> + * can discover what happened.
> + */
> +static int
> +xfs_bulk_ireq_teardown(
> +	struct xfs_bulk_ireq	*hdr,
> +	struct xfs_ibulk	*breq,
> +	int			error)
> +{
> +	if (error < 0)
> +		return error;
Hmm, passing in error just to bail on error seemed a little out of scope 
to me.  Is there a reason we're doing it here?  Instead of after the 
preceding call made in the caller?  Referenced below.....

> +
> +	hdr->ino = breq->startino;
> +	hdr->ocount = breq->ocount;
> +	return 0;
> +}
> +
> +/* Handle the v5 bulkstat ioctl. */
> +STATIC int
> +xfs_ioc_bulkstat(
> +	struct xfs_mount		*mp,
> +	unsigned int			cmd,
> +	struct xfs_bulkstat_req __user	*arg)
> +{
> +	struct xfs_bulk_ireq		hdr;
> +	struct xfs_ibulk		breq = {
> +		.mp			= mp,
> +	};
> +	int				error;
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
> +	error = xfs_bulk_ireq_setup(mp, &hdr, &breq, arg->bulkstat);
> +	if (error < 0)
> +		return error;
> +
> +	if (!error)
> +		error = xfs_bulkstat(&breq, xfs_bulkstat_fmt);
> +
         Right here.  How about

         if (error < 0)
            return error;

         It seems functionally equivalent.  If error < 0, teardown will 
bounce it back anyway and then the error check below will toss it back 
up.  Is that what you meant?

Allison

> +	error = xfs_bulk_ireq_teardown(&hdr, &breq, error);
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
> @@ -1986,6 +2087,9 @@ xfs_file_ioctl(
>   	case XFS_IOC_FSINUMBERS:
>   		return xfs_ioc_fsbulkstat(mp, cmd, arg);
>   
> +	case XFS_IOC_BULKSTAT:
> +		return xfs_ioc_bulkstat(mp, cmd, arg);
> +
>   	case XFS_IOC_FSGEOMETRY_V1:
>   		return xfs_ioc_fsgeometry(mp, arg, 3);
>   	case XFS_IOC_FSGEOMETRY_V4:
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index bfe71747776b..84c342be4536 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -576,6 +576,7 @@ xfs_file_compat_ioctl(
>   	case XFS_IOC_ERROR_CLEARALL:
>   	case FS_IOC_GETFSMAP:
>   	case XFS_IOC_SCRUB_METADATA:
> +	case XFS_IOC_BULKSTAT:
>   		return xfs_file_ioctl(filp, cmd, p);
>   #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
>   	/*
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index d8f941b4d51c..954484c6eb96 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -149,6 +149,7 @@ xfs_check_ondisk_structs(void)
>   
>   	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
>   	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
>   }
>   
>   #endif /* __XFS_ONDISK_H */
> 
