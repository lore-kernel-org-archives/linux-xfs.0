Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33392 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbdGWSHe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2017 14:07:34 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6NI7Ya2016197
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 18:07:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6NI7Xjb020706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 18:07:34 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6NI7XsG017351
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 18:07:33 GMT
Subject: Re: [PATCH 22/22] xfs: scrub quota information
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061205214.14732.3436141782959149381.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <36fc32ce-c123-9907-d8f4-23a2b45069f5@oracle.com>
Date: Sun, 23 Jul 2017 11:07:32 -0700
MIME-Version: 1.0
In-Reply-To: <150061205214.14732.3436141782959149381.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 7/20/2017 9:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Perform some quick sanity testing of the disk quota information.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile        |    1
>  fs/xfs/libxfs/xfs_fs.h |    5 +
>  fs/xfs/scrub/common.c  |   18 +++
>  fs/xfs/scrub/common.h  |    2
>  fs/xfs/scrub/quota.c   |  274 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trace.h     |    5 +
>  6 files changed, 303 insertions(+), 2 deletions(-)
>  create mode 100644 fs/xfs/scrub/quota.c
>
>
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 86fc94c..010a90f 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -158,4 +158,5 @@ xfs-y				+= $(addprefix scrub/, \
>  				   )
>
>  xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
> +xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
>  endif
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 83121fc..444e286 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -503,7 +503,10 @@ struct xfs_scrub_metadata {
>  #define XFS_SCRUB_TYPE_PARENT	19	/* parent pointers */
>  #define XFS_SCRUB_TYPE_RTBITMAP	20	/* realtime bitmap */
>  #define XFS_SCRUB_TYPE_RTSUM	21	/* realtime summary */
> -#define XFS_SCRUB_TYPE_MAX	21
> +#define XFS_SCRUB_TYPE_UQUOTA	22	/* user quotas */
> +#define XFS_SCRUB_TYPE_GQUOTA	23	/* group quotas */
> +#define XFS_SCRUB_TYPE_PQUOTA	24	/* project quotas */
> +#define XFS_SCRUB_TYPE_MAX	24
>
>  /* i: repair this metadata */
>  #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 6e40fa6..62884a8 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -875,6 +875,24 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
>  	{ NULL },
>  	{ NULL },
>  #endif
> +#ifdef CONFIG_XFS_QUOTA
> +	{ /* user quota */
> +		.setup = xfs_scrub_setup_quota,
> +		.scrub = xfs_scrub_quota,
> +	},
> +	{ /* group quota */
> +		.setup = xfs_scrub_setup_quota,
> +		.scrub = xfs_scrub_quota,
> +	},
> +	{ /* project quota */
> +		.setup = xfs_scrub_setup_quota,
> +		.scrub = xfs_scrub_quota,
> +	},
> +#else
> +	{ NULL },
> +	{ NULL },
> +	{ NULL },
> +#endif
>  };
>
>  /* Dispatch metadata scrubbing. */
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 43a74f0..fcb3764 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -226,6 +226,7 @@ SETUP_FN(xfs_scrub_setup_xattr);
>  SETUP_FN(xfs_scrub_setup_parent);
>  SETUP_FN(xfs_scrub_setup_symlink);
>  SETUP_FN(xfs_scrub_setup_rt);
> +SETUP_FN(xfs_scrub_setup_quota);
>  #undef SETUP_FN
>
>  /* Metadata scrubbers */
> @@ -253,6 +254,7 @@ SCRUB_FN(xfs_scrub_parent);
>  SCRUB_FN(xfs_scrub_symlink);
>  SCRUB_FN(xfs_scrub_rtbitmap);
>  SCRUB_FN(xfs_scrub_rtsummary);
> +SCRUB_FN(xfs_scrub_quota);
>  #undef SCRUB_FN
>
>  #endif	/* __XFS_REPAIR_COMMON_H__ */
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> new file mode 100644
> index 0000000..117b8b6
> --- /dev/null
> +++ b/fs/xfs/scrub/quota.c
> @@ -0,0 +1,274 @@
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
> +#include "xfs_inode.h"
> +#include "xfs_inode_fork.h"
> +#include "xfs_bmap.h"
> +#include "xfs_quota.h"
> +#include "xfs_qm.h"
> +#include "xfs_dquot.h"
> +#include "xfs_dquot_item.h"
> +#include "scrub/common.h"
> +
> +/* Convert a scrub type code to a DQ flag, or return 0 if error. */
> +static inline uint
> +xfs_scrub_quota_to_dqtype(
> +	struct xfs_scrub_context	*sc)
> +{
> +	switch (sc->sm->sm_type) {
> +	case XFS_SCRUB_TYPE_UQUOTA:
> +		return XFS_DQ_USER;
> +	case XFS_SCRUB_TYPE_GQUOTA:
> +		return XFS_DQ_GROUP;
> +	case XFS_SCRUB_TYPE_PQUOTA:
> +		return XFS_DQ_PROJ;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +/* Set us up to scrub a quota. */
> +int
> +xfs_scrub_setup_quota(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip)
> +{
> +	uint				dqtype;
> +
> +	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
> +		return -EINVAL;
> +
> +	dqtype = xfs_scrub_quota_to_dqtype(sc);
> +	if (dqtype == 0)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +/* Quotas. */
> +
> +#define XFS_SCRUB_QUOTA_CHECK(fs_ok) \
> +	XFS_SCRUB_DATA_CHECK(sc, XFS_DATA_FORK, id, tag, fs_ok)
> +#define XFS_SCRUB_QUOTA_WARN(fs_ok) \
> +	XFS_SCRUB_DATA_WARN(sc, XFS_DATA_FORK, id, tag, fs_ok)
> +#define XFS_SCRUB_QUOTA_GOTO(fs_ok, label) \
> +	XFS_SCRUB_DATA_GOTO(sc, XFS_DATA_FORK, id, tag, fs_ok, label)
> +#define XFS_SCRUB_QUOTA_OP_ERR(label) \
> +	XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, XFS_DATA_FORK, id, tag, &error, label)
> +/* Scrub the fields in an individual quota item. */
> +STATIC void
> +xfs_scrub_quota_item(
> +	struct xfs_scrub_context	*sc,
> +	const char			*tag,
> +	uint				dqtype,
> +	struct xfs_dquot		*dq,
> +	xfs_dqid_t			id)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_disk_dquot		*d = &dq->q_core;
> +	unsigned long long		bsoft;
> +	unsigned long long		isoft;
> +	unsigned long long		rsoft;
> +	unsigned long long		bhard;
> +	unsigned long long		ihard;
> +	unsigned long long		rhard;
> +	unsigned long long		bcount;
> +	unsigned long long		icount;
> +	unsigned long long		rcount;
> +	xfs_ino_t			inodes;
> +
> +	/* Did we get the dquot we wanted? */
> +	XFS_SCRUB_QUOTA_CHECK(id <= be32_to_cpu(d->d_id));
> +	XFS_SCRUB_QUOTA_CHECK(dqtype ==
> +			(d->d_flags & XFS_DQ_ALLTYPES));
> +
> +	/* Check the limits. */
> +	bhard = be64_to_cpu(d->d_blk_hardlimit);
> +	ihard = be64_to_cpu(d->d_ino_hardlimit);
> +	rhard = be64_to_cpu(d->d_rtb_hardlimit);
> +
> +	bsoft = be64_to_cpu(d->d_blk_softlimit);
> +	isoft = be64_to_cpu(d->d_ino_softlimit);
> +	rsoft = be64_to_cpu(d->d_rtb_softlimit);
> +
> +	inodes = XFS_AGINO_TO_INO(mp, mp->m_sb.sb_agcount, 0);
> +
> +	/*
> +	 * Warn if the limits are larger than the fs.  Administrators
> +	 * can do this, though in production this seems suspect.
> +	 */
> +	XFS_SCRUB_QUOTA_WARN(bhard <= mp->m_sb.sb_dblocks);
> +	XFS_SCRUB_QUOTA_WARN(ihard <= inodes);
> +	XFS_SCRUB_QUOTA_WARN(rhard <= mp->m_sb.sb_rblocks);
> +
> +	XFS_SCRUB_QUOTA_WARN(bsoft <= mp->m_sb.sb_dblocks);
> +	XFS_SCRUB_QUOTA_WARN(isoft <= inodes);
> +	XFS_SCRUB_QUOTA_WARN(rsoft <= mp->m_sb.sb_rblocks);
> +
> +	/* Soft limit must be less than the hard limit. */
> +	XFS_SCRUB_QUOTA_CHECK(bsoft <= bhard);
> +	XFS_SCRUB_QUOTA_CHECK(isoft <= ihard);
> +	XFS_SCRUB_QUOTA_CHECK(rsoft <= rhard);
> +
> +	/* Check the resource counts. */
> +	bcount = be64_to_cpu(d->d_bcount);
> +	icount = be64_to_cpu(d->d_icount);
> +	rcount = be64_to_cpu(d->d_rtbcount);
> +	inodes = percpu_counter_sum(&mp->m_icount);
> +
> +	/*
> +	 * Check that usage doesn't exceed physical limits.  However, on
> +	 * a reflink filesystem we're allowed to exceed physical space
> +	 * if there are no quota limits.
> +	 */
> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		XFS_SCRUB_QUOTA_WARN(bcount <= mp->m_sb.sb_dblocks);
> +	else
> +		XFS_SCRUB_QUOTA_CHECK(bcount <= mp->m_sb.sb_dblocks);
> +	XFS_SCRUB_QUOTA_CHECK(icount <= inodes);
> +	XFS_SCRUB_QUOTA_CHECK(rcount <= mp->m_sb.sb_rblocks);
> +
> +	/*
> +	 * We can violate the hard limits if the admin suddenly sets a
> +	 * lower limit than the actual usage.  However, we flag it for
> +	 * admin review.
> +	 */
> +	XFS_SCRUB_QUOTA_WARN(id == 0 || bhard == 0 || bcount <= bhard);
> +	XFS_SCRUB_QUOTA_WARN(id == 0 || ihard == 0 || icount <= ihard);
> +	XFS_SCRUB_QUOTA_WARN(id == 0 || rhard == 0 || rcount <= rhard);
> +}
> +
> +/* Scrub all of a quota type's items. */
> +int
> +xfs_scrub_quota(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_bmbt_irec		irec = { 0 };
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_inode		*ip;
> +	const char			*tag = NULL;
> +	struct xfs_quotainfo		*qi = mp->m_quotainfo;
> +	struct xfs_dquot		*dq;
> +	xfs_fileoff_t			max_dqid_off;
> +	xfs_fileoff_t			off = 0;
> +	xfs_dqid_t			id = 0;
> +	uint				dqtype;
> +	int				nimaps;
> +	int				error;
> +
> +	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> +		return -ENOENT;
> +
> +	dqtype = xfs_scrub_quota_to_dqtype(sc);
> +	switch (dqtype) {
> +	case XFS_DQ_USER:
> +		tag = "usrquota";
> +		break;
> +	case XFS_DQ_GROUP:
> +		tag = "grpquota";
> +		break;
> +	case XFS_DQ_PROJ:
> +		tag = "prjquota";
> +		break;
> +	default:
> +		ASSERT(0);
> +	}
> +
> +	mutex_lock(&qi->qi_quotaofflock);
> +	if (!xfs_this_quota_on(sc->mp, dqtype)) {
> +		error = -ENOENT;
> +		goto out;
> +	}
> +
> +	/* Attach to the quota inode and set sc->ip so that reporting works. */
> +	ip = xfs_quota_inode(sc->mp, dqtype);
> +	sc->ip = ip;
> +
> +	/* Look for problem extents. */
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
> +	while (1) {
> +		if (xfs_scrub_should_terminate(&error))
> +			break;
> +
> +		off = irec.br_startoff + irec.br_blockcount;
> +		nimaps = 1;
> +		error = xfs_bmapi_read(ip, off, -1, &irec, &nimaps,
> +				XFS_BMAPI_ENTIRE);
> +		XFS_SCRUB_QUOTA_OP_ERR(out_unlock);
> +		if (!nimaps)
> +			break;
> +		if (irec.br_startblock == HOLESTARTBLOCK)
> +			continue;
> +
> +		/*
> +		 * Unwritten extents or blocks mapped above the highest
> +		 * quota id shouldn't happen.
> +		 */
> +		XFS_SCRUB_QUOTA_GOTO(!isnullstartblock(irec.br_startblock),
> +				next_extent);
> +		XFS_SCRUB_QUOTA_GOTO(irec.br_startoff <= max_dqid_off,
> +				next_extent);
> +		XFS_SCRUB_QUOTA_GOTO(irec.br_startoff + irec.br_blockcount <=
> +				max_dqid_off + 1, next_extent);
> +next_extent:;
> +	}
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +	/* Check all the quota items. */
> +	while (id < ((xfs_dqid_t)-1ULL)) {
> +		if (xfs_scrub_should_terminate(&error))
> +			break;
> +
> +		error = xfs_qm_dqget(mp, NULL, id, dqtype, XFS_QMOPT_DQNEXT,
> +				&dq);
> +		if (error == -ENOENT)
> +			break;
> +		XFS_SCRUB_QUOTA_OP_ERR(out);
> +
> +		xfs_scrub_quota_item(sc, tag, dqtype, dq, id);
> +
> +		id = be32_to_cpu(dq->q_core.d_id) + 1;
> +		xfs_qm_dqput(dq);
> +	}
> +	goto out;
> +
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +out:
> +	sc->ip = NULL;
> +	mutex_unlock(&qi->qi_quotaofflock);
> +	return error;
> +}
> +#undef XFS_SCRUB_QUOTA_OP_ERR
> +#undef XFS_SCRUB_QUOTA_GOTO
> +#undef XFS_SCRUB_QUOTA_WARN
> +#undef XFS_SCRUB_QUOTA_CHECK
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 1be7b00..9f71cb9 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3332,7 +3332,10 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
>  	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }, \
>  	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }, \
>  	{ XFS_SCRUB_TYPE_RTBITMAP,	"rtbitmap" }, \
> -	{ XFS_SCRUB_TYPE_RTSUM,		"rtsummary" }
> +	{ XFS_SCRUB_TYPE_RTSUM,		"rtsummary" }, \
> +	{ XFS_SCRUB_TYPE_UQUOTA,	"usrquota" }, \
> +	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
> +	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }
>  DECLARE_EVENT_CLASS(xfs_scrub_class,
>  	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
>  		 int error),
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
