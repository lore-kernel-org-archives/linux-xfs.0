Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48715 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdHaUfN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:35:13 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKZD7D015486
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKZC87023726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:12 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKZCkJ018642
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:12 GMT
Subject: [PATCH 17/19] xfs: scrub the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:35:10 -0700
Message-ID: <150421171018.17458.10680213880705603242.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the realtime reverse mapping btree against the rtbitmap, and
modify the rtbitmap scrub to check against the rtrmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    5 ++
 fs/xfs/libxfs/xfs_fs.h |    3 +
 fs/xfs/scrub/bmap.c    |    1 
 fs/xfs/scrub/common.h  |    2 +
 fs/xfs/scrub/rtrmap.c  |  123 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |    9 ++++
 fs/xfs/scrub/scrub.h   |    1 
 7 files changed, 142 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 35a2ddf..4336e14 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -163,6 +163,9 @@ xfs-y				+= $(addprefix scrub/, \
 				   symlink.o \
 				   )
 
-xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
+xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rtbitmap.o \
+				   rtrmap.o \
+				   )
 xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 endif
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index fba0105..eb8102c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -507,9 +507,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_UQUOTA	21	/* user quotas */
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
+#define XFS_SCRUB_TYPE_RTRMAPBT	24	/* realtime reverse mapping btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	24
+#define XFS_SCRUB_TYPE_NR	25
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7858a5e..438a8b6 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -509,6 +509,7 @@ xfs_scrub_bmap(
 	case XFS_DINODE_FMT_UUID:
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_RMAP:
 		/* No mappings to check. */
 		goto out_unlock;
 	case XFS_DINODE_FMT_EXTENTS:
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index bf844e5..aceb557 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -145,6 +145,8 @@ int xfs_scrub_setup_parent(struct xfs_scrub_context *sc,
 			   struct xfs_inode *ip);
 int xfs_scrub_setup_rt(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 int xfs_scrub_setup_quota(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+int xfs_scrub_setup_rtrmapbt(struct xfs_scrub_context *sc,
+			     struct xfs_inode *ip);
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
new file mode 100644
index 0000000..1480ea6
--- /dev/null
+++ b/fs/xfs/scrub/rtrmap.c
@@ -0,0 +1,123 @@
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
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_inode.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+
+/* Set us up with the realtime metadata and AG headers locked. */
+int
+xfs_scrub_setup_rtrmapbt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = sc->mp;
+	int				lockmode;
+	int				error = 0;
+
+	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
+		return -EINVAL;
+
+	error = xfs_scrub_setup_fs(sc, ip);
+	if (error)
+		return error;
+
+	lockmode = XFS_ILOCK_EXCL;
+	xfs_ilock(mp->m_rrmapip, lockmode);
+	xfs_trans_ijoin(sc->tp, mp->m_rrmapip, lockmode);
+
+	lockmode = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
+	xfs_ilock(mp->m_rbmip, lockmode);
+	xfs_trans_ijoin(sc->tp, mp->m_rbmip, lockmode);
+
+	return 0;
+}
+
+/* Realtime reverse mapping. */
+
+/* Scrub a realtime rmapbt record. */
+STATIC int
+xfs_scrub_rtrmapbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_rmap_irec		irec;
+	unsigned long long		rec_end;
+	bool				non_inode;
+	bool				is_bmbt;
+	bool				is_attr;
+	int				error;
+
+	error = xfs_rmap_btrec_to_irec(bs->cur, rec, &irec);
+	if (!xfs_scrub_btree_op_ok(bs->sc, bs->cur, 0, &error))
+		goto out;
+
+	rec_end = (unsigned long long)irec.rm_startblock + irec.rm_blockcount;
+	xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
+			irec.rm_startblock < mp->m_sb.sb_rblocks &&
+			rec_end <= mp->m_sb.sb_rblocks);
+
+	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
+	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec.rm_flags & XFS_RMAP_ATTR_FORK;
+
+	xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
+			!is_bmbt && !non_inode && !is_attr);
+
+out:
+	return error;
+}
+
+/* Scrub the realtime rmap btree. */
+int
+xfs_scrub_rtrmapbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	cur = xfs_rtrmapbt_init_cursor(mp, sc->tp, mp->m_rrmapip);
+	xfs_rmap_ino_bmbt_owner(&oinfo, mp->m_sb.sb_rrmapino, XFS_DATA_FORK);
+	error = xfs_scrub_btree(sc, cur, xfs_scrub_rtrmapbt_helper,
+			&oinfo, NULL);
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7f9a4f8..ffb1465 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -343,6 +343,15 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 	{ NULL },
 	{ NULL },
 #endif
+#ifdef CONFIG_XFS_RT
+	{ /* realtime rmapbt */
+		.setup	= xfs_scrub_setup_rtrmapbt,
+		.scrub	= xfs_scrub_rtrmapbt,
+		.has	= xfs_sb_version_hasrtrmapbt,
+	},
+#else
+	{ NULL },
+#endif
 };
 
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 41ec126..0fc334e 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -105,5 +105,6 @@ int xfs_scrub_parent(struct xfs_scrub_context *sc);
 int xfs_scrub_rtbitmap(struct xfs_scrub_context *sc);
 int xfs_scrub_rtsummary(struct xfs_scrub_context *sc);
 int xfs_scrub_quota(struct xfs_scrub_context *sc);
+int xfs_scrub_rtrmapbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

