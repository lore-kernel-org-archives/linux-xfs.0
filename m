Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35722 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdG0Wmo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 18:42:44 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6RMghB8007240
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMghq0015680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:43 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6RMgh80003475
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:43 GMT
Subject: [PATCH 10/26] xfs: scrub the backup superblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Jul 2017 15:42:41 -0700
Message-ID: <150119536147.15159.16270669906346228424.stgit@magnolia>
In-Reply-To: <150119530010.15159.9900948790538082160.stgit@magnolia>
References: <150119530010.15159.9900948790538082160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Ensure that the geometry presented in the backup superblocks matches
the primary superblock so that repair can recover the filesystem if
that primary gets corrupted.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile         |    1 
 fs/xfs/libxfs/xfs_fs.h  |    3 
 fs/xfs/scrub/agheader.c |  326 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h   |    2 
 fs/xfs/scrub/scrub.c    |    4 +
 fs/xfs/scrub/scrub.h    |    1 
 fs/xfs/scrub/trace.h    |    3 
 7 files changed, 338 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/agheader.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 276b7a3..b057689 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -144,6 +144,7 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
 
 xfs-y				+= $(addprefix scrub/, \
 				   trace.o \
+				   agheader.o \
 				   btree.o \
 				   common.o \
 				   scrub.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 5105bad..b98bba2 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -484,9 +484,10 @@ struct xfs_scrub_metadata {
 
 /* Scrub subcommands. */
 #define XFS_SCRUB_TYPE_TEST	0	/* presence test ioctl */
+#define XFS_SCRUB_TYPE_SB	1	/* superblock */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	1
+#define XFS_SCRUB_TYPE_NR	2
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
new file mode 100644
index 0000000..c58a5ef
--- /dev/null
+++ b/fs/xfs/scrub/agheader.c
@@ -0,0 +1,326 @@
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
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+
+/* Set us up to check an AG header. */
+int
+xfs_scrub_setup_ag_header(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = sc->mp;
+
+	if (sc->sm->sm_agno >= mp->m_sb.sb_agcount ||
+	    sc->sm->sm_ino || sc->sm->sm_gen)
+		return -EINVAL;
+	return xfs_scrub_setup_fs(sc, ip);
+}
+
+/* Superblock */
+
+/* Scrub the filesystem superblock. */
+int
+xfs_scrub_superblock(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*bp;
+	struct xfs_dsb			*sb;
+	xfs_agnumber_t			agno;
+	uint32_t			v2_ok;
+	__be32				features_mask;
+	int				error;
+	__be16				vernum_mask;
+
+	agno = sc->sm->sm_agno;
+	if (agno == 0)
+		return 0;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+		  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	if (!xfs_scrub_op_ok(sc, agno, XFS_SB_BLOCK(mp), &error))
+		return error;
+
+	sb = XFS_BUF_TO_SBP(bp);
+
+	/*
+	 * Verify the geometries match.  Fields that are permanently
+	 * set by mkfs are checked; fields that can be updated later
+	 * (and are not propagated to backup superblocks) are preen
+	 * checked.
+	 */
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_blocksize == cpu_to_be32(mp->m_sb.sb_blocksize));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_dblocks == cpu_to_be64(mp->m_sb.sb_dblocks));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_rblocks == cpu_to_be64(mp->m_sb.sb_rblocks));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_rextents == cpu_to_be64(mp->m_sb.sb_rextents));
+
+	xfs_scrub_block_preen_ok(sc, bp,
+			uuid_equal(&sb->sb_uuid, &mp->m_sb.sb_uuid));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_logstart == cpu_to_be64(mp->m_sb.sb_logstart));
+
+	xfs_scrub_block_preen_ok(sc, bp,
+			sb->sb_rootino == cpu_to_be64(mp->m_sb.sb_rootino));
+
+	xfs_scrub_block_preen_ok(sc, bp,
+			sb->sb_rbmino == cpu_to_be64(mp->m_sb.sb_rbmino));
+
+	xfs_scrub_block_preen_ok(sc, bp,
+			sb->sb_rsumino == cpu_to_be64(mp->m_sb.sb_rsumino));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_rextsize == cpu_to_be32(mp->m_sb.sb_rextsize));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_agblocks == cpu_to_be32(mp->m_sb.sb_agblocks));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_agcount == cpu_to_be32(mp->m_sb.sb_agcount));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_rbmblocks == cpu_to_be32(mp->m_sb.sb_rbmblocks));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_logblocks == cpu_to_be32(mp->m_sb.sb_logblocks));
+
+	/* Check sb_versionnum bits that are set at mkfs time. */
+	vernum_mask = cpu_to_be16(~XFS_SB_VERSION_OKBITS |
+				  XFS_SB_VERSION_NUMBITS |
+				  XFS_SB_VERSION_ALIGNBIT |
+				  XFS_SB_VERSION_DALIGNBIT |
+				  XFS_SB_VERSION_SHAREDBIT |
+				  XFS_SB_VERSION_LOGV2BIT |
+				  XFS_SB_VERSION_SECTORBIT |
+				  XFS_SB_VERSION_EXTFLGBIT |
+				  XFS_SB_VERSION_DIRV2BIT);
+	xfs_scrub_block_check_ok(sc, bp,
+			(sb->sb_versionnum & vernum_mask) ==
+			(cpu_to_be16(mp->m_sb.sb_versionnum) & vernum_mask));
+
+	/* Check sb_versionnum bits that can be set after mkfs time. */
+	vernum_mask = cpu_to_be16(XFS_SB_VERSION_ATTRBIT |
+				  XFS_SB_VERSION_NLINKBIT |
+				  XFS_SB_VERSION_QUOTABIT);
+	xfs_scrub_block_preen_ok(sc, bp,
+			(sb->sb_versionnum & vernum_mask) ==
+			(cpu_to_be16(mp->m_sb.sb_versionnum) & vernum_mask));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_sectsize == cpu_to_be16(mp->m_sb.sb_sectsize));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_inodesize == cpu_to_be16(mp->m_sb.sb_inodesize));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_inopblock == cpu_to_be16(mp->m_sb.sb_inopblock));
+
+	xfs_scrub_block_preen_ok(sc, bp,
+			!memcmp(sb->sb_fname, mp->m_sb.sb_fname,
+				sizeof(sb->sb_fname)));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_blocklog == mp->m_sb.sb_blocklog);
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_sectlog == mp->m_sb.sb_sectlog);
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_inodelog == mp->m_sb.sb_inodelog);
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_inopblog == mp->m_sb.sb_inopblog);
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_agblklog == mp->m_sb.sb_agblklog);
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_rextslog == mp->m_sb.sb_rextslog);
+
+	xfs_scrub_block_preen_ok(sc, bp,
+			sb->sb_imax_pct == mp->m_sb.sb_imax_pct);
+
+	/*
+	 * Skip the summary counters since we track them in memory anyway.
+	 * sb_icount, sb_ifree, sb_fdblocks, sb_frexents
+	 */
+
+	xfs_scrub_block_preen_ok(sc, bp,
+			sb->sb_uquotino == cpu_to_be64(mp->m_sb.sb_uquotino));
+
+	xfs_scrub_block_preen_ok(sc, bp,
+			sb->sb_gquotino == cpu_to_be64(mp->m_sb.sb_gquotino));
+
+	/*
+	 * Skip the quota flags since repair will force quotacheck.
+	 * sb_qflags
+	 */
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_flags == mp->m_sb.sb_flags);
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_shared_vn == mp->m_sb.sb_shared_vn);
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_inoalignmt == cpu_to_be32(mp->m_sb.sb_inoalignmt));
+
+	xfs_scrub_block_preen_ok(sc, bp,
+			sb->sb_unit == cpu_to_be32(mp->m_sb.sb_unit));
+
+	xfs_scrub_block_preen_ok(sc, bp,
+			sb->sb_width == cpu_to_be32(mp->m_sb.sb_width));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_dirblklog == mp->m_sb.sb_dirblklog);
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_logsectlog == mp->m_sb.sb_logsectlog);
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_logsectsize ==
+			cpu_to_be16(mp->m_sb.sb_logsectsize));
+
+	xfs_scrub_block_check_ok(sc, bp,
+			sb->sb_logsunit == cpu_to_be32(mp->m_sb.sb_logsunit));
+
+	/* Do we see any invalid bits in sb_features2? */
+	if (!xfs_sb_version_hasmorebits(&mp->m_sb)) {
+		xfs_scrub_block_check_ok(sc, bp, sb->sb_features2 == 0);
+	} else {
+		v2_ok = XFS_SB_VERSION2_OKBITS;
+		if (XFS_SB_VERSION_NUM(&mp->m_sb) >= XFS_SB_VERSION_5)
+			v2_ok |= XFS_SB_VERSION2_CRCBIT;
+
+		xfs_scrub_block_check_ok(sc, bp,
+				!(sb->sb_features2 & cpu_to_be32(~v2_ok)));
+
+		xfs_scrub_block_preen_ok(sc, bp,
+				sb->sb_features2 == sb->sb_bad_features2);
+	}
+
+	/* Check sb_features2 flags that are set at mkfs time. */
+	features_mask = cpu_to_be32(XFS_SB_VERSION2_LAZYSBCOUNTBIT |
+				    XFS_SB_VERSION2_PROJID32BIT |
+				    XFS_SB_VERSION2_CRCBIT |
+				    XFS_SB_VERSION2_FTYPE);
+	xfs_scrub_block_check_ok(sc, bp,
+			(sb->sb_features2 & features_mask) ==
+			(cpu_to_be32(mp->m_sb.sb_features2) & features_mask));
+
+	/* Check sb_features2 flags that can be set after mkfs time. */
+	features_mask = cpu_to_be32(XFS_SB_VERSION2_ATTR2BIT);
+	xfs_scrub_block_check_ok(sc, bp,
+			(sb->sb_features2 & features_mask) ==
+			(cpu_to_be32(mp->m_sb.sb_features2) & features_mask));
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		/* all v5 fields must be zero */
+		xfs_scrub_block_check_ok(sc, bp,
+				!memchr_inv(&sb->sb_features_compat, 0,
+					sizeof(struct xfs_dsb) -
+					offsetof(struct xfs_dsb,
+						sb_features_compat)));
+	} else {
+		/* Check compat flags; all are set at mkfs time. */
+		features_mask = cpu_to_be32(XFS_SB_FEAT_COMPAT_UNKNOWN);
+		xfs_scrub_block_check_ok(sc, bp,
+				(sb->sb_features_compat & features_mask) ==
+				(cpu_to_be32(mp->m_sb.sb_features_compat) &
+					features_mask));
+
+		/* Check ro compat flags; all are set at mkfs time. */
+		features_mask = cpu_to_be32(XFS_SB_FEAT_RO_COMPAT_UNKNOWN |
+					    XFS_SB_FEAT_RO_COMPAT_FINOBT |
+					    XFS_SB_FEAT_RO_COMPAT_RMAPBT |
+					    XFS_SB_FEAT_RO_COMPAT_REFLINK);
+		xfs_scrub_block_check_ok(sc, bp,
+				(sb->sb_features_ro_compat & features_mask) ==
+				(cpu_to_be32(mp->m_sb.sb_features_ro_compat) &
+					features_mask));
+
+		/* Check incompat flags; all are set at mkfs time. */
+		features_mask = cpu_to_be32(XFS_SB_FEAT_INCOMPAT_UNKNOWN |
+					    XFS_SB_FEAT_INCOMPAT_FTYPE |
+					    XFS_SB_FEAT_INCOMPAT_SPINODES |
+					    XFS_SB_FEAT_INCOMPAT_META_UUID);
+		xfs_scrub_block_check_ok(sc, bp,
+				(sb->sb_features_incompat & features_mask) ==
+				(cpu_to_be32(mp->m_sb.sb_features_incompat) &
+					features_mask));
+
+		/* Check log incompat flags; all are set at mkfs time. */
+		features_mask = cpu_to_be32(XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN);
+		xfs_scrub_block_check_ok(sc, bp,
+				(sb->sb_features_log_incompat & features_mask) ==
+				(cpu_to_be32(mp->m_sb.sb_features_log_incompat) &
+					features_mask));
+
+		/* Don't care about sb_crc */
+
+		xfs_scrub_block_check_ok(sc, bp,
+				sb->sb_spino_align ==
+				cpu_to_be32(mp->m_sb.sb_spino_align));
+
+		xfs_scrub_block_preen_ok(sc, bp,
+				sb->sb_pquotino ==
+				cpu_to_be64(mp->m_sb.sb_pquotino));
+
+		/* Don't care about sb_lsn */
+	}
+
+	if (xfs_sb_version_hasmetauuid(&mp->m_sb)) {
+		/* The metadata UUID must be the same for all supers */
+		xfs_scrub_block_check_ok(sc, bp,
+				uuid_equal(&sb->sb_meta_uuid,
+					&mp->m_sb.sb_meta_uuid));
+	}
+
+	/* Everything else must be zero. */
+	xfs_scrub_block_check_ok(sc, bp,
+			!memchr_inv(sb + 1, 0,
+				BBTOB(bp->b_length) - sizeof(struct xfs_dsb)));
+
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 105b7ad..4c7c308 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -92,6 +92,8 @@ bool xfs_scrub_check_thoroughness(struct xfs_scrub_context *sc, bool fs_ok);
 
 /* Setup functions */
 int xfs_scrub_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+int xfs_scrub_setup_ag_header(struct xfs_scrub_context *sc,
+			      struct xfs_inode *ip);
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 41b2328..d8103e5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -162,6 +162,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_tester,
 	},
+	{ /* superblock */
+		.setup	= xfs_scrub_setup_ag_header,
+		.scrub	= xfs_scrub_superblock,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 291444f..027f62e 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -62,5 +62,6 @@ struct xfs_scrub_context {
 
 /* Metadata scrubbers */
 int xfs_scrub_tester(struct xfs_scrub_context *sc);
+int xfs_scrub_superblock(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index f16431a..9a15109 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -26,7 +26,8 @@
 #include <linux/tracepoint.h>
 
 #define XFS_SCRUB_TYPE_DESC \
-	{ XFS_SCRUB_TYPE_TEST,		"test" }
+	{ XFS_SCRUB_TYPE_TEST,		"test" }, \
+	{ XFS_SCRUB_TYPE_SB,		"superblock" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

