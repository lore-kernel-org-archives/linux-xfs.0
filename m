Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:53218 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755365AbeE2Dmi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 May 2018 23:42:38 -0400
Date: Tue, 29 May 2018 13:42:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/22] xfs: repair superblocks
Message-ID: <20180529034235.GO10363@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642367052.1556.15718680556361907984.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152642367052.1556.15718680556361907984.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 15, 2018 at 03:34:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If one of the backup superblocks is found to differ seriously from
> superblock 0, write out a fresh copy from the in-core sb.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good, couple of minor things and one for a followup patch.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> ---
>  fs/xfs/Makefile                |    1 +
>  fs/xfs/libxfs/xfs_sb.c         |   22 +++++++++++++
>  fs/xfs/libxfs/xfs_sb.h         |    3 ++
>  fs/xfs/scrub/agheader_repair.c |   70 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/repair.h          |    2 +
>  fs/xfs/scrub/scrub.c           |    2 +
>  6 files changed, 99 insertions(+), 1 deletion(-)
>  create mode 100644 fs/xfs/scrub/agheader_repair.c
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 0e93a099359b..29fe115f29d5 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -174,6 +174,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
>  # online repair
>  ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
>  xfs-y				+= $(addprefix scrub/, \
> +				   agheader_repair.o \
>  				   repair.o \
>  				   )
>  endif
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index ea6c85a4c27c..3a3273572a5c 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1097,3 +1097,25 @@ xfs_sb_read_secondary(
>  	*bpp = bp;
>  	return 0;
>  }
> +
> +/* Get a secondary superblock buffer. */

/* get an uninitialised secondary superblock buffer */

> +int
> +xfs_sb_get_secondary(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_buf		*bp;
> +
> +	ASSERT(agno != 0 && agno != NULLAGNUMBER);
> +	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
> +			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> +			XFS_FSS_TO_BB(mp, 1), 0);
> +	if (!bp)
> +		return -ENOMEM;
> +	bp->b_ops = &xfs_sb_buf_ops;
> +	xfs_buf_set_ref(bp, XFS_SSB_REF);
> +	*bpp = bp;

This should probably call xfs_buf_oneshot(bp) rather than having
multiple mechanisms for doing the same thing. Same goes for
xfs_sb_read_secondary().

> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 03e0cc6bf3a6..244e0162c49e 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -50,5 +50,8 @@ extern int	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
>  extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
>  				struct xfs_trans *tp, xfs_agnumber_t agno,
>  				struct xfs_buf **bpp);
> +extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
> +				struct xfs_trans *tp, xfs_agnumber_t agno,
> +				struct xfs_buf **bpp);
>  
>  #endif	/* __XFS_SB_H__ */
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> new file mode 100644
> index 000000000000..8b91e9ebe1e7
> --- /dev/null
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -0,0 +1,70 @@
> +/*
> + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_btree.h"
> +#include "xfs_bit.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans.h"
> +#include "xfs_sb.h"
> +#include "xfs_inode.h"
> +#include "xfs_alloc.h"
> +#include "xfs_ialloc.h"
> +#include "xfs_rmap.h"
> +#include "scrub/xfs_scrub.h"
> +#include "scrub/scrub.h"
> +#include "scrub/common.h"
> +#include "scrub/trace.h"
> +
> +/* Superblock */
> +
> +/* Repair the superblock. */
> +int
> +xfs_repair_superblock(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_buf			*bp;
> +	xfs_agnumber_t			agno;
> +	int				error;
> +
> +	/* Don't try to repair AG 0's sb; let xfs_repair deal with it. */
> +	agno = sc->sm->sm_agno;
> +	if (agno == 0)
> +		return -EOPNOTSUPP;
> +
> +	error = xfs_sb_get_secondary(mp, sc->tp, agno, &bp);
> +	if (error)
> +		return error;
> +
> +	/* Copy AG 0's superblock to this one. */
> +	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
> +	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
> +
> +	/* Write this to disk. */
> +	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
> +	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
> +	return error;
> +}

This is largely common with the core of xfs_update_secondary_sbs()
and can go into fs/xfs/libxfs/xfs_sb.c

int
xfs_sb_init_secondary(
	struct xfs_mount	*mp,
	struct xfs_trans	*tp,
	xfs_agnumber_t		agno
	struct xfs_buf		**bpp)
{
	struct xfs_buf		*bp;
	int			error;

	error = xfs_sb_get_secondary(mp, tp, agno, &bp);
	if (error)
		return error;

	/* Copy AG 0's superblock to this one. */
	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);

	if (tp) {
		xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
		xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
	}
	if (bpp)
		*bpp = bp;
	return 0;
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
