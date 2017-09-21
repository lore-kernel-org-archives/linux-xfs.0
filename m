Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43911 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbdIUAUb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 20:20:31 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8L0KUqJ017761
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:20:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0KTcS005451
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:20:30 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0KTdD000433
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:20:29 GMT
Subject: [PATCH 27/27] xfs: scrub quota information
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Sep 2017 17:20:28 -0700
Message-ID: <150595322887.18473.16151585194402633196.stgit@magnolia>
In-Reply-To: <150595305131.18473.16572195821331601191.stgit@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Perform some quick sanity testing of the disk quota information.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    5 +
 fs/xfs/scrub/common.h  |    1 
 fs/xfs/scrub/quota.c   |  258 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |   18 +++
 fs/xfs/scrub/scrub.h   |    1 
 6 files changed, 283 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/quota.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 9ce581e..3152469 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -164,4 +164,5 @@ xfs-y				+= $(addprefix scrub/, \
 				   )
 
 xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
+xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 endif
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 3f37156..fba0105 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -504,9 +504,12 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_PARENT	18	/* parent pointers */
 #define XFS_SCRUB_TYPE_RTBITMAP	19	/* realtime bitmap */
 #define XFS_SCRUB_TYPE_RTSUM	20	/* realtime summary */
+#define XFS_SCRUB_TYPE_UQUOTA	21	/* user quotas */
+#define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
+#define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	21
+#define XFS_SCRUB_TYPE_NR	24
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 871204a..a4a2ca5 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -117,6 +117,7 @@ int xfs_scrub_setup_symlink(struct xfs_scrub_context *sc,
 int xfs_scrub_setup_parent(struct xfs_scrub_context *sc,
 			   struct xfs_inode *ip);
 int xfs_scrub_setup_rt(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+int xfs_scrub_setup_quota(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
new file mode 100644
index 0000000..302d5a8
--- /dev/null
+++ b/fs/xfs/scrub/quota.c
@@ -0,0 +1,258 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "xfs_qm.h"
+#include "xfs_dquot.h"
+#include "xfs_dquot_item.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+
+/* Convert a scrub type code to a DQ flag, or return 0 if error. */
+static inline uint
+xfs_scrub_quota_to_dqtype(
+	struct xfs_scrub_context	*sc)
+{
+	switch (sc->sm->sm_type) {
+	case XFS_SCRUB_TYPE_UQUOTA:
+		return XFS_DQ_USER;
+	case XFS_SCRUB_TYPE_GQUOTA:
+		return XFS_DQ_GROUP;
+	case XFS_SCRUB_TYPE_PQUOTA:
+		return XFS_DQ_PROJ;
+	default:
+		return 0;
+	}
+}
+
+/* Set us up to scrub a quota. */
+int
+xfs_scrub_setup_quota(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	uint				dqtype;
+
+	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
+		return -EINVAL;
+
+	dqtype = xfs_scrub_quota_to_dqtype(sc);
+	if (dqtype == 0)
+		return -EINVAL;
+	return 0;
+}
+
+/* Quotas. */
+
+/* Scrub the fields in an individual quota item. */
+STATIC void
+xfs_scrub_quota_item(
+	struct xfs_scrub_context	*sc,
+	uint				dqtype,
+	struct xfs_dquot		*dq,
+	xfs_dqid_t			id)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_disk_dquot		*d = &dq->q_core;
+	struct xfs_quotainfo		*qi = mp->m_quotainfo;
+	xfs_fileoff_t			offset;
+	unsigned long long		bsoft;
+	unsigned long long		isoft;
+	unsigned long long		rsoft;
+	unsigned long long		bhard;
+	unsigned long long		ihard;
+	unsigned long long		rhard;
+	unsigned long long		bcount;
+	unsigned long long		icount;
+	unsigned long long		rcount;
+	xfs_ino_t			inodes;
+
+	/* Did we get the dquot we wanted? */
+	offset = id * qi->qi_dqperchunk;
+	xfs_scrub_fblock_check_ok(sc, XFS_DATA_FORK, offset,
+			id <= be32_to_cpu(d->d_id) &&
+			dqtype == (d->d_flags & XFS_DQ_ALLTYPES));
+
+	/* Check the limits. */
+	bhard = be64_to_cpu(d->d_blk_hardlimit);
+	ihard = be64_to_cpu(d->d_ino_hardlimit);
+	rhard = be64_to_cpu(d->d_rtb_hardlimit);
+
+	bsoft = be64_to_cpu(d->d_blk_softlimit);
+	isoft = be64_to_cpu(d->d_ino_softlimit);
+	rsoft = be64_to_cpu(d->d_rtb_softlimit);
+
+	inodes = XFS_AGINO_TO_INO(mp, mp->m_sb.sb_agcount, 0);
+
+	/*
+	 * Warn if the limits are larger than the fs.  Administrators
+	 * can do this, though in production this seems suspect.
+	 */
+	xfs_scrub_fblock_warn_ok(sc, XFS_DATA_FORK, offset,
+			bhard <= mp->m_sb.sb_dblocks &&
+			ihard <= inodes &&
+			rhard <= mp->m_sb.sb_rblocks &&
+			bsoft <= mp->m_sb.sb_dblocks &&
+			isoft <= inodes &&
+			rsoft <= mp->m_sb.sb_rblocks);
+
+	/* Soft limit must be less than the hard limit. */
+	xfs_scrub_fblock_check_ok(sc, XFS_DATA_FORK, offset,
+			bsoft <= bhard &&
+			isoft <= ihard &&
+			rsoft <= rhard);
+
+	/* Check the resource counts. */
+	bcount = be64_to_cpu(d->d_bcount);
+	icount = be64_to_cpu(d->d_icount);
+	rcount = be64_to_cpu(d->d_rtbcount);
+	inodes = percpu_counter_sum(&mp->m_icount);
+
+	/*
+	 * Check that usage doesn't exceed physical limits.  However, on
+	 * a reflink filesystem we're allowed to exceed physical space
+	 * if there are no quota limits.
+	 */
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		xfs_scrub_fblock_warn_ok(sc, XFS_DATA_FORK, offset,
+				bcount <= mp->m_sb.sb_dblocks);
+	else
+		xfs_scrub_fblock_check_ok(sc, XFS_DATA_FORK, offset,
+				bcount <= mp->m_sb.sb_dblocks);
+	xfs_scrub_fblock_check_ok(sc, XFS_DATA_FORK, offset,
+			icount <= inodes && rcount <= mp->m_sb.sb_rblocks);
+
+	/*
+	 * We can violate the hard limits if the admin suddenly sets a
+	 * lower limit than the actual usage.  However, we flag it for
+	 * admin review.
+	 */
+	xfs_scrub_fblock_warn_ok(sc, XFS_DATA_FORK, offset,
+			(id == 0 || bhard == 0 || bcount <= bhard) &&
+			(id == 0 || ihard == 0 || icount <= ihard) &&
+			(id == 0 || rhard == 0 || rcount <= rhard));
+}
+
+/* Scrub all of a quota type's items. */
+int
+xfs_scrub_quota(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_bmbt_irec		irec = { 0 };
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_inode		*ip;
+	struct xfs_quotainfo		*qi = mp->m_quotainfo;
+	struct xfs_dquot		*dq;
+	xfs_fileoff_t			max_dqid_off;
+	xfs_fileoff_t			off = 0;
+	xfs_dqid_t			id = 0;
+	uint				dqtype;
+	int				nimaps;
+	int				error;
+
+	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+		return -ENOENT;
+
+	mutex_lock(&qi->qi_quotaofflock);
+	dqtype = xfs_scrub_quota_to_dqtype(sc);
+	if (!xfs_this_quota_on(sc->mp, dqtype)) {
+		error = -ENOENT;
+		goto out;
+	}
+
+	/* Attach to the quota inode and set sc->ip so that reporting works. */
+	ip = xfs_quota_inode(sc->mp, dqtype);
+	sc->ip = ip;
+
+	/* Look for problem extents. */
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
+	while (1) {
+		if (xfs_scrub_should_terminate(&error))
+			break;
+
+		off = irec.br_startoff + irec.br_blockcount;
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, off, -1, &irec, &nimaps,
+				XFS_BMAPI_ENTIRE);
+		if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, off, &error))
+			goto out_unlock;
+		if (!nimaps)
+			break;
+		if (irec.br_startblock == HOLESTARTBLOCK)
+			continue;
+
+		/*
+		 * Unwritten extents or blocks mapped above the highest
+		 * quota id shouldn't happen.
+		 */
+		xfs_scrub_fblock_check_ok(sc, XFS_DATA_FORK, off,
+				!isnullstartblock(irec.br_startblock) &&
+				irec.br_startoff <= max_dqid_off &&
+				irec.br_startoff + irec.br_blockcount <=
+					max_dqid_off + 1);
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	/* Check all the quota items. */
+	while (id < ((xfs_dqid_t)-1ULL)) {
+		if (xfs_scrub_should_terminate(&error))
+			break;
+
+		error = xfs_qm_dqget(mp, NULL, id, dqtype, XFS_QMOPT_DQNEXT,
+				&dq);
+		if (error == -ENOENT)
+			break;
+		if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK,
+				id * qi->qi_dqperchunk, &error))
+			goto out;
+
+		xfs_scrub_quota_item(sc, dqtype, dq, id);
+
+		id = be32_to_cpu(dq->q_core.d_id) + 1;
+		xfs_qm_dqput(dq);
+		if (!id)
+			break;
+	}
+	goto out;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
+	sc->ip = NULL;
+	mutex_unlock(&qi->qi_quotaofflock);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 23b010d..8cddfcd 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -265,6 +265,24 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 	{ NULL },
 	{ NULL },
 #endif
+#ifdef CONFIG_XFS_QUOTA
+	{ /* user quota */
+		.setup = xfs_scrub_setup_quota,
+		.scrub = xfs_scrub_quota,
+	},
+	{ /* group quota */
+		.setup = xfs_scrub_setup_quota,
+		.scrub = xfs_scrub_quota,
+	},
+	{ /* project quota */
+		.setup = xfs_scrub_setup_quota,
+		.scrub = xfs_scrub_quota,
+	},
+#else
+	{ NULL },
+	{ NULL },
+	{ NULL },
+#endif
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 97fd03f..3218664 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -84,5 +84,6 @@ int xfs_scrub_symlink(struct xfs_scrub_context *sc);
 int xfs_scrub_parent(struct xfs_scrub_context *sc);
 int xfs_scrub_rtbitmap(struct xfs_scrub_context *sc);
 int xfs_scrub_rtsummary(struct xfs_scrub_context *sc);
+int xfs_scrub_quota(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

