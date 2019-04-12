Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47138 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbfDLLOn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Apr 2019 07:14:43 -0400
Date: Fri, 12 Apr 2019 07:14:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/8] xfs: report AG health via AG geometry ioctl
Message-ID: <20190412111440.GB50446@bfoster>
References: <155505048097.1279757.13952335054480511366.stgit@magnolia>
 <155505052747.1279757.8384383083144164193.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155505052747.1279757.8384383083144164193.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 11, 2019 at 11:28:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the AG geometry info ioctl to report health status too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.c     |    2 ++
>  fs/xfs/libxfs/xfs_fs.h     |   14 +++++++++++++-
>  fs/xfs/libxfs/xfs_health.h |    1 +
>  fs/xfs/xfs_health.c        |   36 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 52 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 1c0f2a6c10b4..b0c89f54d1bb 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -20,6 +20,7 @@
>  #include "xfs_rmap.h"
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
> +#include "xfs_health.h"
>  
>  static struct xfs_buf *
>  xfs_get_aghdr_buf(
> @@ -505,6 +506,7 @@ xfs_ag_get_geometry(
>  		   pag->pagf_btreeblks -
>  		   xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
>  	ageo->ag_freeblks = freeblks;
> +	xfs_ag_geom_health(pag, ageo);
>  
>  	/* Release resources. */
>  	xfs_perag_put(pag);
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 6b8956dbf49d..35d60f8017cd 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -285,9 +285,21 @@ struct xfs_ag_geometry {
>  	uint32_t	ag_freeblks;	/* o: free space */
>  	uint32_t	ag_icount;	/* o: inodes allocated */
>  	uint32_t	ag_ifree;	/* o: inodes free */
> +	uint32_t	ag_sick;	/* o: sick things in ag */
> +	uint32_t	ag_checked;	/* o: checked metadata in ag */
>  	uint32_t	ag_reserved32;	/* o: zero */
> -	uint64_t	ag_reserved[13];/* o: zero */
> +	uint64_t	ag_reserved[12];/* o: zero */
>  };
> +#define XFS_AG_GEOM_SICK_SB	(1 << 0)  /* superblock */
> +#define XFS_AG_GEOM_SICK_AGF	(1 << 1)  /* AGF header */
> +#define XFS_AG_GEOM_SICK_AGFL	(1 << 2)  /* AGFL header */
> +#define XFS_AG_GEOM_SICK_AGI	(1 << 3)  /* AGI header */
> +#define XFS_AG_GEOM_SICK_BNOBT	(1 << 4)  /* free space by block */
> +#define XFS_AG_GEOM_SICK_CNTBT	(1 << 5)  /* free space by length */
> +#define XFS_AG_GEOM_SICK_INOBT	(1 << 6)  /* inode index */
> +#define XFS_AG_GEOM_SICK_FINOBT	(1 << 7)  /* free inode index */
> +#define XFS_AG_GEOM_SICK_RMAPBT	(1 << 8)  /* reverse mappings */
> +#define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
>  
>  /*
>   * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
> diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> index 3fffdcc80970..e392457023a4 100644
> --- a/fs/xfs/libxfs/xfs_health.h
> +++ b/fs/xfs/libxfs/xfs_health.h
> @@ -184,5 +184,6 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
>  }
>  
>  void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
> +void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
>  
>  #endif	/* __XFS_HEALTH_H__ */
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index d137b8f13869..5431c4070f27 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -320,3 +320,39 @@ xfs_fsop_geom_health(
>  	for (m = rt_map; m->sick_mask; m++)
>  		xfgeo_health_tick(geo, sick, checked, m);
>  }
> +
> +static const struct ioctl_sick_map ag_map[] = {
> +	{ XFS_SICK_AG_SB,	XFS_AG_GEOM_SICK_SB },
> +	{ XFS_SICK_AG_AGF,	XFS_AG_GEOM_SICK_AGF },
> +	{ XFS_SICK_AG_AGFL,	XFS_AG_GEOM_SICK_AGFL },
> +	{ XFS_SICK_AG_AGI,	XFS_AG_GEOM_SICK_AGI },
> +	{ XFS_SICK_AG_BNOBT,	XFS_AG_GEOM_SICK_BNOBT },
> +	{ XFS_SICK_AG_CNTBT,	XFS_AG_GEOM_SICK_CNTBT },
> +	{ XFS_SICK_AG_INOBT,	XFS_AG_GEOM_SICK_INOBT },
> +	{ XFS_SICK_AG_FINOBT,	XFS_AG_GEOM_SICK_FINOBT },
> +	{ XFS_SICK_AG_RMAPBT,	XFS_AG_GEOM_SICK_RMAPBT },
> +	{ XFS_SICK_AG_REFCNTBT,	XFS_AG_GEOM_SICK_REFCNTBT },
> +	{ 0, 0 },
> +};
> +
> +/* Fill out ag geometry health info. */
> +void
> +xfs_ag_geom_health(
> +	struct xfs_perag		*pag,
> +	struct xfs_ag_geometry		*ageo)
> +{
> +	const struct ioctl_sick_map	*m;
> +	unsigned int			sick;
> +	unsigned int			checked;
> +
> +	ageo->ag_sick = 0;
> +	ageo->ag_checked = 0;
> +
> +	xfs_ag_measure_sickness(pag, &sick, &checked);
> +	for (m = ag_map; m->sick_mask; m++) {
> +		if (checked & m->sick_mask)
> +			ageo->ag_checked |= m->ioctl_mask;
> +		if (sick & m->sick_mask)
> +			ageo->ag_sick |= m->ioctl_mask;
> +	}
> +}
> 
