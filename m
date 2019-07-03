Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25057 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfGCNYb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 09:24:31 -0400
Date: Wed, 3 Jul 2019 09:24:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] xfs: wire up new v5 bulkstat ioctls
Message-ID: <20190703132428.GE26057@bfoster>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158196664.495715.16022753346138162990.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158196664.495715.16022753346138162990.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

On Wed, Jun 26, 2019 at 01:46:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Wire up the new v5 BULKSTAT ioctl and rename the old one to V1.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

I don't see any renaming in this patch (or the subsequent that mention
it).. that aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_fs.h |   24 +++++++++++-
>  fs/xfs/xfs_ioctl.c     |   98 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioctl32.c   |    1 
>  fs/xfs/xfs_ondisk.h    |    1 
>  4 files changed, 123 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 8b8fe78511fb..960f3542e207 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -435,7 +435,6 @@ struct xfs_fsop_bulkreq {
>  	__s32		__user *ocount;	/* output count pointer		*/
>  };
>  
> -
>  /*
>   * Structures returned from xfs_inumbers routine (XFS_IOC_FSINUMBERS).
>   */
> @@ -457,6 +456,28 @@ struct xfs_inumbers {
>  #define XFS_INUMBERS_VERSION_V1	(1)
>  #define XFS_INUMBERS_VERSION_V5	(5)
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
>  /*
>   * Error injection.
>   */
> @@ -758,6 +779,7 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_FSGEOMETRY_V4	     _IOR ('X', 124, struct xfs_fsop_geom_v4)
>  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
>  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
> +#define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 47580762e154..cf6a38c2a3ed 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -827,6 +827,101 @@ xfs_ioc_fsbulkstat(
>  	return 0;
>  }
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
> + * should proceed; XFS_ITER_ABORT if there's nothing to do; or the usual
> + * negative error code.
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
> +	breq->startino = hdr->ino;
> +	breq->ubuffer = ubuffer;
> +	breq->icount = hdr->icount;
> +	breq->ocount = 0;
> +
> +	/* Asking for an inode past the end of the FS?  We're done! */
> +	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
> +		return XFS_ITER_ABORT;
> +
> +	return 0;
> +}
> +
> +/*
> + * Update the userspace bulk request @hdr to reflect the end state of the
> + * internal bulk request @breq.
> + */
> +static void
> +xfs_bulk_ireq_teardown(
> +	struct xfs_bulk_ireq	*hdr,
> +	struct xfs_ibulk	*breq)
> +{
> +	hdr->ino = breq->startino;
> +	hdr->ocount = breq->ocount;
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
> +	if (error == XFS_ITER_ABORT)
> +		goto out_teardown;
> +	if (error < 0)
> +		return error;
> +
> +	error = xfs_bulkstat(&breq, xfs_bulkstat_fmt);
> +	if (error)
> +		return error;
> +
> +out_teardown:
> +	xfs_bulk_ireq_teardown(&hdr, &breq);
> +	if (copy_to_user(&arg->hdr, &hdr, sizeof(hdr)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  STATIC int
>  xfs_ioc_fsgeometry(
>  	struct xfs_mount	*mp,
> @@ -1991,6 +2086,9 @@ xfs_file_ioctl(
>  	case XFS_IOC_FSINUMBERS:
>  		return xfs_ioc_fsbulkstat(mp, cmd, arg);
>  
> +	case XFS_IOC_BULKSTAT:
> +		return xfs_ioc_bulkstat(mp, cmd, arg);
> +
>  	case XFS_IOC_FSGEOMETRY_V1:
>  		return xfs_ioc_fsgeometry(mp, arg, 3);
>  	case XFS_IOC_FSGEOMETRY_V4:
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 41485e2ed431..df107adbdbf3 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -580,6 +580,7 @@ xfs_file_compat_ioctl(
>  	case XFS_IOC_ERROR_CLEARALL:
>  	case FS_IOC_GETFSMAP:
>  	case XFS_IOC_SCRUB_METADATA:
> +	case XFS_IOC_BULKSTAT:
>  		return xfs_file_ioctl(filp, cmd, p);
>  #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
>  	/*
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index d8f941b4d51c..954484c6eb96 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -149,6 +149,7 @@ xfs_check_ondisk_structs(void)
>  
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
>  }
>  
>  #endif /* __XFS_ONDISK_H */
> 
