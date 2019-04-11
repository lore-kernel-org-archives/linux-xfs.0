Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfDKNIN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Apr 2019 09:08:13 -0400
Date: Thu, 11 Apr 2019 09:08:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/8] xfs: add a new ioctl to describe allocation group
 geometry
Message-ID: <20190411130810.GE2888@bfoster>
References: <155494712442.1090518.2784809287026447547.stgit@magnolia>
 <155494715806.1090518.13259730969995378693.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155494715806.1090518.13259730969995378693.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 10, 2019 at 06:45:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new ioctl to describe an allocation group's geometry.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h |    2 ++
>  fs/xfs/libxfs/xfs_fs.h |   14 +++++++++++++
>  fs/xfs/xfs_ioctl.c     |   24 ++++++++++++++++++++++
>  fs/xfs/xfs_ioctl32.c   |    1 +
>  5 files changed, 93 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 1ef8acf35e7d..1c0f2a6c10b4 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -19,6 +19,7 @@
>  #include "xfs_ialloc.h"
>  #include "xfs_rmap.h"
>  #include "xfs_ag.h"
> +#include "xfs_ag_resv.h"
>  
>  static struct xfs_buf *
>  xfs_get_aghdr_buf(
> @@ -461,3 +462,54 @@ xfs_ag_extend_space(
>  				len, &XFS_RMAP_OINFO_SKIP_UPDATE,
>  				XFS_AG_RESV_NONE);
>  }
> +
> +/* Retrieve AG geometry. */
> +int
> +xfs_ag_get_geometry(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_ag_geometry	*ageo)
> +{
> +	struct xfs_buf		*agi_bp;
> +	struct xfs_buf		*agf_bp;
> +	struct xfs_agi		*agi;
> +	struct xfs_agf		*agf;
> +	struct xfs_perag	*pag;
> +	unsigned int		freeblks;
> +	int			error;
> +
> +	if (agno >= mp->m_sb.sb_agcount)
> +		return -EINVAL;
> +
> +	/* Lock the AG headers. */
> +	error = xfs_ialloc_read_agi(mp, NULL, agno, &agi_bp);
> +	if (error)
> +		return error;
> +	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
> +	if (error)
> +		goto out_agi;
> +	pag = xfs_perag_get(mp, agno);
> +
> +	/* Fill out form. */
> +	memset(ageo, 0, sizeof(*ageo));
> +	ageo->ag_number = agno;
> +
> +	agi = XFS_BUF_TO_AGI(agi_bp);
> +	ageo->ag_icount = be32_to_cpu(agi->agi_count);
> +	ageo->ag_ifree = be32_to_cpu(agi->agi_freecount);
> +
> +	agf = XFS_BUF_TO_AGF(agf_bp);
> +	ageo->ag_length = be32_to_cpu(agf->agf_length);
> +	freeblks = pag->pagf_freeblks +
> +		   pag->pagf_flcount +
> +		   pag->pagf_btreeblks -
> +		   xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
> +	ageo->ag_freeblks = freeblks;
> +
> +	/* Release resources. */
> +	xfs_perag_put(pag);
> +	xfs_buf_relse(agf_bp);
> +out_agi:
> +	xfs_buf_relse(agi_bp);
> +	return error;
> +}
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 412702e23f61..5166322807e7 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -26,5 +26,7 @@ struct aghdr_init_data {
>  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
>  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
>  			struct aghdr_init_data *id, xfs_extlen_t len);
> +int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> +			struct xfs_ag_geometry *ageo);
>  
>  #endif /* __LIBXFS_AG_H */
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index cb7d0b1453cd..ee33d628a240 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -267,6 +267,19 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_MIN_DBLOCKS(s) ((xfs_rfsblock_t)((s)->sb_agcount - 1) *	\
>  			 (s)->sb_agblocks + XFS_MIN_AG_BLOCKS)
>  
> +/*
> + * Output for XFS_IOC_AG_GEOMETRY
> + */
> +struct xfs_ag_geometry {
> +	uint32_t	ag_number;	/* i/o: AG number */
> +	uint32_t	ag_length;	/* o: length in blocks */
> +	uint32_t	ag_freeblks;	/* o: free space */
> +	uint32_t	ag_icount;	/* o: inodes allocated */
> +	uint32_t	ag_ifree;	/* o: inodes free */
> +	uint32_t	ag_reserved32;	/* o: zero */
> +	uint64_t	ag_reserved[13];/* o: zero */
> +};
> +
>  /*
>   * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
>   */
> @@ -620,6 +633,7 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
>  /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
>  #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
> +#define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
>  
>  /*
>   * ioctl commands that replace IRIX syssgi()'s
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d243660f1826..0aaf4f88524d 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -33,6 +33,7 @@
>  #include "xfs_fsmap.h"
>  #include "scrub/xfs_scrub.h"
>  #include "xfs_sb.h"
> +#include "xfs_ag.h"
>  
>  #include <linux/capability.h>
>  #include <linux/cred.h>
> @@ -804,6 +805,26 @@ xfs_ioc_fsgeometry(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_ioc_ag_geometry(
> +	struct xfs_mount	*mp,
> +	void			__user *arg)
> +{
> +	struct xfs_ag_geometry	ageo;
> +	int			error;
> +
> +	if (copy_from_user(&ageo, arg, sizeof(ageo)))
> +		return -EFAULT;
> +
> +	error = xfs_ag_get_geometry(mp, ageo.ag_number, &ageo);
> +	if (error)
> +		return error;
> +
> +	if (copy_to_user(arg, &ageo, sizeof(ageo)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
>  /*
>   * Linux extended inode flags interface.
>   */
> @@ -2009,6 +2030,9 @@ xfs_file_ioctl(
>  	case XFS_IOC_FSGEOMETRY:
>  		return xfs_ioc_fsgeometry(mp, arg, 5);
>  
> +	case XFS_IOC_AG_GEOMETRY:
> +		return xfs_ioc_ag_geometry(mp, arg);
> +
>  	case XFS_IOC_GETVERSION:
>  		return put_user(inode->i_generation, (int __user *)arg);
>  
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 55ace6308637..65997a6315e9 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -563,6 +563,7 @@ xfs_file_compat_ioctl(
>  	case XFS_IOC_DIOINFO:
>  	case XFS_IOC_FSGEOMETRY_V4:
>  	case XFS_IOC_FSGEOMETRY:
> +	case XFS_IOC_AG_GEOMETRY:
>  	case XFS_IOC_FSGETXATTR:
>  	case XFS_IOC_FSSETXATTR:
>  	case XFS_IOC_FSGETXATTRA:
> 
