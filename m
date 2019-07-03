Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfGCNYB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 09:24:01 -0400
Date: Wed, 3 Jul 2019 09:23:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/9] xfs: introduce v5 inode group structure
Message-ID: <20190703132357.GD26057@bfoster>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158195888.495715.17662104546912391174.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158195888.495715.17662104546912391174.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

On Wed, Jun 26, 2019 at 01:45:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new "v5" inode group structure that fixes the alignment
> and padding problems of the existing structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_fs.h |   11 +++++++++++
>  fs/xfs/xfs_ioctl.c     |    9 ++++++---
>  fs/xfs/xfs_ioctl.h     |    2 +-
>  fs/xfs/xfs_ioctl32.c   |   10 +++++++---
>  fs/xfs/xfs_itable.c    |   14 +++++++++++++-
>  fs/xfs/xfs_itable.h    |    4 +++-
>  fs/xfs/xfs_ondisk.h    |    1 +
>  7 files changed, 42 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 132e364eb141..8b8fe78511fb 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -445,6 +445,17 @@ struct xfs_inogrp {
>  	__u64		xi_allocmask;	/* mask of allocated inodes	*/
>  };
>  
> +/* New inumbers structure that reports v5 features and fixes padding issues */
> +struct xfs_inumbers {
> +	uint64_t	xi_startino;	/* starting inode number	*/
> +	uint64_t	xi_allocmask;	/* mask of allocated inodes	*/
> +	uint8_t		xi_alloccount;	/* # bits set in allocmask	*/
> +	uint8_t		xi_version;	/* version			*/
> +	uint8_t		xi_padding[6];	/* zero				*/
> +};
> +
> +#define XFS_INUMBERS_VERSION_V1	(1)
> +#define XFS_INUMBERS_VERSION_V5	(5)
>  
>  /*
>   * Error injection.
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0b8c631d53dd..47580762e154 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -738,10 +738,13 @@ xfs_fsbulkstat_one_fmt(
>  
>  int
>  xfs_fsinumbers_fmt(
> -	struct xfs_ibulk	*breq,
> -	const struct xfs_inogrp	*igrp)
> +	struct xfs_ibulk		*breq,
> +	const struct xfs_inumbers	*igrp)
>  {
> -	if (copy_to_user(breq->ubuffer, igrp, sizeof(*igrp)))
> +	struct xfs_inogrp		ig1;
> +
> +	xfs_inumbers_to_inogrp(&ig1, igrp);
> +	if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))
>  		return -EFAULT;
>  	return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
>  }
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index 514d3028a134..654c0bb1bcf8 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -83,6 +83,6 @@ struct xfs_inogrp;
>  
>  int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
>  			   const struct xfs_bulkstat *bstat);
> -int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
> +int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inumbers *igrp);
>  
>  #endif
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index a97612927f9e..41485e2ed431 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -87,10 +87,14 @@ xfs_compat_growfs_rt_copyin(
>  
>  STATIC int
>  xfs_fsinumbers_fmt_compat(
> -	struct xfs_ibulk	*breq,
> -	const struct xfs_inogrp	*igrp)
> +	struct xfs_ibulk		*breq,
> +	const struct xfs_inumbers	*ig)
>  {
> -	struct compat_xfs_inogrp __user *p32 = breq->ubuffer;
> +	struct compat_xfs_inogrp __user	*p32 = breq->ubuffer;
> +	struct xfs_inogrp		ig1;
> +	struct xfs_inogrp		*igrp = &ig1;
> +
> +	xfs_inumbers_to_inogrp(&ig1, ig);
>  
>  	if (put_user(igrp->xi_startino,   &p32->xi_startino) ||
>  	    put_user(igrp->xi_alloccount, &p32->xi_alloccount) ||
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 50c2bb8e13c4..745b04f59132 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -331,10 +331,11 @@ xfs_inumbers_walk(
>  	const struct xfs_inobt_rec_incore *irec,
>  	void			*data)
>  {
> -	struct xfs_inogrp	inogrp = {
> +	struct xfs_inumbers	inogrp = {
>  		.xi_startino	= XFS_AGINO_TO_INO(mp, agno, irec->ir_startino),
>  		.xi_alloccount	= irec->ir_count - irec->ir_freecount,
>  		.xi_allocmask	= ~irec->ir_free,
> +		.xi_version	= XFS_INUMBERS_VERSION_V5,
>  	};
>  	struct xfs_inumbers_chunk *ic = data;
>  	xfs_agino_t		agino;
> @@ -381,3 +382,14 @@ xfs_inumbers(
>  
>  	return error;
>  }
> +
> +/* Convert an inumbers (v5) struct to a inogrp (v1) struct. */
> +void
> +xfs_inumbers_to_inogrp(
> +	struct xfs_inogrp		*ig1,
> +	const struct xfs_inumbers	*ig)
> +{
> +	ig1->xi_startino = ig->xi_startino;
> +	ig1->xi_alloccount = ig->xi_alloccount;
> +	ig1->xi_allocmask = ig->xi_allocmask;
> +}
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 60e259192056..fa9fb9104c7f 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -46,8 +46,10 @@ void xfs_bulkstat_to_bstat(struct xfs_mount *mp, struct xfs_bstat *bs1,
>  		const struct xfs_bulkstat *bstat);
>  
>  typedef int (*inumbers_fmt_pf)(struct xfs_ibulk *breq,
> -		const struct xfs_inogrp *igrp);
> +		const struct xfs_inumbers *igrp);
>  
>  int xfs_inumbers(struct xfs_ibulk *breq, inumbers_fmt_pf formatter);
> +void xfs_inumbers_to_inogrp(struct xfs_inogrp *ig1,
> +		const struct xfs_inumbers *ig);
>  
>  #endif	/* __XFS_ITABLE_H__ */
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 0b4cdda68524..d8f941b4d51c 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -148,6 +148,7 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
>  
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
>  }
>  
>  #endif /* __XFS_ONDISK_H */
> 
