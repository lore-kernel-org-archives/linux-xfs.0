Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36330 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEWaV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 18:30:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MSvku001651
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:30:19 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2suevdnj2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 22:30:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MSWYn013211
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:30:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2swnhaedng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 22:30:18 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x55MUHtM031313
        for <linux-xfs@vger.kernel.org>; Wed, 5 Jun 2019 22:30:17 GMT
Subject: Re: [PATCH 4/9] xfs: introduce v5 inode group structure
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
 <155916887585.758159.12839282593059100664.stgit@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <f37473bb-b5b0-7619-5ebd-6371b6d09196@oracle.com>
Date: Wed, 5 Jun 2019 15:30:16 -0700
MIME-Version: 1.0
In-Reply-To: <155916887585.758159.12839282593059100664.stgit@magnolia>
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
> Introduce a new "v5" inode group structure that fixes the alignment
> and padding problems of the existing structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_fs.h |   11 +++++++++++
>   fs/xfs/xfs_ioctl.c     |    9 ++++++---
>   fs/xfs/xfs_ioctl.h     |    2 +-
>   fs/xfs/xfs_ioctl32.c   |   10 +++++++---
>   fs/xfs/xfs_itable.c    |   14 +++++++++++++-
>   fs/xfs/xfs_itable.h    |    3 ++-
>   fs/xfs/xfs_ondisk.h    |    1 +
>   7 files changed, 41 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 132e364eb141..8b8fe78511fb 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -445,6 +445,17 @@ struct xfs_inogrp {
>   	__u64		xi_allocmask;	/* mask of allocated inodes	*/
>   };
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
Ditto on the V1 not being used here too.  Other than that it, this one 
looks ok too

Allison

>   
>   /*
>    * Error injection.
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0f70005cbe61..e43ad688e683 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -737,10 +737,13 @@ xfs_fsbulkstat_one_fmt(
>   
>   int
>   xfs_fsinumbers_fmt(
> -	struct xfs_ibulk	*breq,
> -	const struct xfs_inogrp	*igrp)
> +	struct xfs_ibulk		*breq,
> +	const struct xfs_inumbers	*igrp)
>   {
> -	if (copy_to_user(breq->ubuffer, igrp, sizeof(*igrp)))
> +	struct xfs_inogrp		ig1;
> +
> +	xfs_inumbers_to_inogrp(&ig1, igrp);
> +	if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))
>   		return -EFAULT;
>   	return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
>   }
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index 514d3028a134..654c0bb1bcf8 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -83,6 +83,6 @@ struct xfs_inogrp;
>   
>   int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
>   			   const struct xfs_bulkstat *bstat);
> -int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
> +int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inumbers *igrp);
>   
>   #endif
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 9806d27892df..bfe71747776b 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -85,10 +85,14 @@ xfs_compat_growfs_rt_copyin(
>   
>   STATIC int
>   xfs_fsinumbers_fmt_compat(
> -	struct xfs_ibulk	*breq,
> -	const struct xfs_inogrp	*igrp)
> +	struct xfs_ibulk		*breq,
> +	const struct xfs_inumbers	*ig)
>   {
> -	struct compat_xfs_inogrp __user *p32 = breq->ubuffer;
> +	struct compat_xfs_inogrp __user	*p32 = breq->ubuffer;
> +	struct xfs_inogrp		ig1;
> +	struct xfs_inogrp		*igrp = &ig1;
> +
> +	xfs_inumbers_to_inogrp(&ig1, ig);
>   
>   	if (put_user(igrp->xi_startino,   &p32->xi_startino) ||
>   	    put_user(igrp->xi_alloccount, &p32->xi_alloccount) ||
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 764b7f98fd5b..8701596976bb 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -322,10 +322,11 @@ xfs_inumbers_walk(
>   	const struct xfs_inobt_rec_incore *irec,
>   	void			*data)
>   {
> -	struct xfs_inogrp	inogrp = {
> +	struct xfs_inumbers	inogrp = {
>   		.xi_startino	= XFS_AGINO_TO_INO(mp, agno, irec->ir_startino),
>   		.xi_alloccount	= irec->ir_count - irec->ir_freecount,
>   		.xi_allocmask	= ~irec->ir_free,
> +		.xi_version	= XFS_INUMBERS_VERSION_V5,
>   	};
>   	struct xfs_inumbers_chunk *ic = data;
>   	xfs_agino_t		agino;
> @@ -376,3 +377,14 @@ xfs_inumbers(
>   
>   	return error;
>   }
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
> index 806069c9838c..2987f3eb335f 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -49,8 +49,9 @@ void xfs_bulkstat_to_bstat(struct xfs_mount *mp, struct xfs_bstat *bs1,
>   		const struct xfs_bulkstat *bstat);
>   
>   typedef int (*inumbers_fmt_pf)(struct xfs_ibulk *breq,
> -		const struct xfs_inogrp *igrp);
> +		const struct xfs_inumbers *igrp);
>   
>   int xfs_inumbers(struct xfs_ibulk *breq, inumbers_fmt_pf formatter);
> +void xfs_inumbers_to_inogrp(struct xfs_inogrp *ig1, const struct xfs_inumbers *ig);
>   
>   #endif	/* __XFS_ITABLE_H__ */
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 0b4cdda68524..d8f941b4d51c 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -148,6 +148,7 @@ xfs_check_ondisk_structs(void)
>   	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
>   
>   	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
>   }
>   
>   #endif /* __XFS_ONDISK_H */
> 
