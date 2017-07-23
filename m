Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26731 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdGWRVQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2017 13:21:16 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6NHLFhS021930
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:21:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6NHLFx5032315
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:21:15 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6NHLC6Z016993
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:21:12 GMT
Subject: Re: [PATCH 11/22] xfs: scrub rmap btrees
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061198108.14732.5313687596824770967.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <934193c1-4fdb-81cc-fc06-dbe28989ce67@oracle.com>
Date: Sun, 23 Jul 2017 10:21:12 -0700
MIME-Version: 1.0
In-Reply-To: <150061198108.14732.5313687596824770967.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 7/20/2017 9:39 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Check the reverse mapping records to make sure that the contents
> make sense.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile        |    1
>  fs/xfs/libxfs/xfs_fs.h |    3 +
>  fs/xfs/scrub/common.c  |    5 ++
>  fs/xfs/scrub/common.h  |    2 +
>  fs/xfs/scrub/rmap.c    |  127 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trace.h     |    3 +
>  6 files changed, 139 insertions(+), 2 deletions(-)
>  create mode 100644 fs/xfs/scrub/rmap.c
>
>
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 5197bea..5fe0c8e 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -146,5 +146,6 @@ xfs-y				+= $(addprefix scrub/, \
>  				   common.o \
>  				   ialloc.o \
>  				   metabufs.o \
> +				   rmap.o \
>  				   )
>  endif
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 5120cfd..24db73a 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -491,7 +491,8 @@ struct xfs_scrub_metadata {
>  #define XFS_SCRUB_TYPE_CNTBT	7	/* freesp by length btree */
>  #define XFS_SCRUB_TYPE_INOBT	8	/* inode btree */
>  #define XFS_SCRUB_TYPE_FINOBT	9	/* free inode btree */
> -#define XFS_SCRUB_TYPE_MAX	9
> +#define XFS_SCRUB_TYPE_RMAPBT	10	/* reverse mapping btree */
> +#define XFS_SCRUB_TYPE_MAX	10
>
>  /* i: repair this metadata */
>  #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 9a31846..dfa5fc5 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -725,6 +725,11 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
>  		.scrub	= xfs_scrub_finobt,
>  		.has	= xfs_sb_version_hasfinobt,
>  	},
> +	{ /* rmapbt */
> +		.setup	= xfs_scrub_setup_ag_rmapbt,
> +		.scrub	= xfs_scrub_rmapbt,
> +		.has	= xfs_sb_version_hasrmapbt,
> +	},
>  };
>
>  /* Dispatch metadata scrubbing. */
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index cd89bec..8fbd19b 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -211,6 +211,7 @@ SETUP_FN(xfs_scrub_setup_metabufs);
>  SETUP_FN(xfs_scrub_setup_ag_header);
>  SETUP_FN(xfs_scrub_setup_ag_allocbt);
>  SETUP_FN(xfs_scrub_setup_ag_iallocbt);
> +SETUP_FN(xfs_scrub_setup_ag_rmapbt);
>  #undef SETUP_FN
>
>  /* Metadata scrubbers */
> @@ -226,6 +227,7 @@ SCRUB_FN(xfs_scrub_bnobt);
>  SCRUB_FN(xfs_scrub_cntbt);
>  SCRUB_FN(xfs_scrub_inobt);
>  SCRUB_FN(xfs_scrub_finobt);
> +SCRUB_FN(xfs_scrub_rmapbt);
>  #undef SCRUB_FN
>
>  #endif	/* __XFS_REPAIR_COMMON_H__ */
> diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> new file mode 100644
> index 0000000..82d027b
> --- /dev/null
> +++ b/fs/xfs/scrub/rmap.c
> @@ -0,0 +1,127 @@
> +/*
> + * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
> +#include "xfs_trace.h"
> +#include "xfs_sb.h"
> +#include "xfs_rmap.h"
> +#include "scrub/common.h"
> +#include "scrub/btree.h"
> +
> +/*
> + * Set us up to scrub reverse mapping btrees.
> + */
> +int
> +xfs_scrub_setup_ag_rmapbt(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip)
> +{
> +	return xfs_scrub_setup_ag_btree(sc, ip, false);
> +}
> +
> +/* Reverse-mapping scrubber. */
> +
> +/* Scrub an rmapbt record. */
> +STATIC int
> +xfs_scrub_rmapbt_helper(
> +	struct xfs_scrub_btree		*bs,
> +	union xfs_btree_rec		*rec)
> +{
> +	struct xfs_mount		*mp = bs->cur->bc_mp;
> +	struct xfs_agf			*agf;
> +	struct xfs_rmap_irec		irec;
> +	xfs_agblock_t			eoag;
> +	bool				non_inode;
> +	bool				is_unwritten;
> +	bool				is_bmbt;
> +	bool				is_attr;
> +	int				error;
> +
> +	error = xfs_rmap_btrec_to_irec(rec, &irec);
> +	XFS_SCRUB_BTREC_OP_ERROR_GOTO(bs, &error, out);
> +
> +	/* Check extent. */
> +	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
> +	eoag = be32_to_cpu(agf->agf_length);
> +	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_startblock < mp->m_sb.sb_agblocks);
> +	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_startblock < eoag);
> +	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_startblock < irec.rm_startblock +
> +			irec.rm_blockcount);
> +	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_startblock + irec.rm_blockcount <=
> +			mp->m_sb.sb_agblocks);
> +	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_startblock + irec.rm_blockcount <=
> +			eoag);
> +
> +	/* Check flags. */
> +	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
> +	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
> +	is_attr = irec.rm_flags & XFS_RMAP_ATTR_FORK;
> +	is_unwritten = irec.rm_flags & XFS_RMAP_UNWRITTEN;
> +
> +	XFS_SCRUB_BTREC_CHECK(bs, !is_bmbt || irec.rm_offset == 0);
> +	XFS_SCRUB_BTREC_CHECK(bs, !non_inode || irec.rm_offset == 0);
> +	XFS_SCRUB_BTREC_CHECK(bs, !is_unwritten || !(is_bmbt || non_inode ||
> +			is_attr));
> +	XFS_SCRUB_BTREC_CHECK(bs, !non_inode || !(is_bmbt || is_unwritten ||
> +			is_attr));
> +
> +	/* Owner inode within an AG? */
> +	XFS_SCRUB_BTREC_CHECK(bs, non_inode ||
> +			(XFS_INO_TO_AGNO(mp, irec.rm_owner) <
> +							mp->m_sb.sb_agcount &&
> +			 XFS_AGINO_TO_AGBNO(mp,
> +				XFS_INO_TO_AGINO(mp, irec.rm_owner)) <
> +							mp->m_sb.sb_agblocks));
> +	/* Owner inode within the FS? */
> +	XFS_SCRUB_BTREC_CHECK(bs, non_inode ||
> +			XFS_AGB_TO_DADDR(mp,
> +				XFS_INO_TO_AGNO(mp, irec.rm_owner),
> +				XFS_AGINO_TO_AGBNO(mp,
> +					XFS_INO_TO_AGINO(mp, irec.rm_owner))) <
> +			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
> +
> +	/* Non-inode owner within the magic values? */
> +	XFS_SCRUB_BTREC_CHECK(bs, !non_inode ||
> +			(irec.rm_owner > XFS_RMAP_OWN_MIN &&
> +			 irec.rm_owner <= XFS_RMAP_OWN_FS));
> +out:
> +	return error;
> +}
> +
> +/* Scrub the rmap btree for some AG. */
> +int
> +xfs_scrub_rmapbt(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_owner_info		oinfo;
> +
> +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> +	return xfs_scrub_btree(sc, sc->sa.rmap_cur, xfs_scrub_rmapbt_helper,
> +			&oinfo, NULL);
> +}
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index e2c5f99..3996cb8 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3321,7 +3321,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
>  	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \
>  	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }, \
>  	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
> -	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }
> +	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
> +	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }
>  DECLARE_EVENT_CLASS(xfs_scrub_class,
>  	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
>  		 int error),
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
