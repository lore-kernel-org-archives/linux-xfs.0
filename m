Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46942 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfAAC0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:26:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012NirG023954
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:26:19 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pp0btp7f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:26:19 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012QJUg003924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:26:19 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012QJuU005606
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:26:19 GMT
Subject: [PATCH 18/20] xfs: scrub the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:26:18 -0800
Message-ID: <154630957793.8108.12232532635749659024.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
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
 fs/xfs/scrub/common.h  |    6 +++
 fs/xfs/scrub/rtrmap.c  |  109 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |    7 +++
 fs/xfs/scrub/scrub.h   |    6 +++
 fs/xfs/scrub/trace.h   |    4 +-
 8 files changed, 138 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b0176dd2bd6b..635bdb6f00e0 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -162,7 +162,10 @@ xfs-y				+= $(addprefix scrub/, \
 				   symlink.o \
 				   )
 
-xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
+xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rtbitmap.o \
+				   rtrmap.o \
+				   )
 xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 
 # online repair
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 0f0e2948866c..11d8217cf005 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -503,9 +503,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
+#define XFS_SCRUB_TYPE_RTRMAPBT	25	/* realtime reverse mapping btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	25
+#define XFS_SCRUB_TYPE_NR	26
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index c90f13430aa4..799a8c9731af 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -675,6 +675,7 @@ xchk_bmap(
 	case XFS_DINODE_FMT_UUID:
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_RMAP:
 		/* No mappings to check. */
 		goto out;
 	case XFS_DINODE_FMT_EXTENTS:
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 8e89b61ab8d5..9a62bdaa58f1 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -89,12 +89,18 @@ int xchk_setup_parent(struct xfs_scrub *sc,
 			   struct xfs_inode *ip);
 #ifdef CONFIG_XFS_RT
 int xchk_setup_rt(struct xfs_scrub *sc, struct xfs_inode *ip);
+int xchk_setup_rtrmapbt(struct xfs_scrub *sc, struct xfs_inode *ip);
 #else
 static inline int
 xchk_setup_rt(struct xfs_scrub *sc, struct xfs_inode *ip)
 {
 	return -ENOENT;
 }
+static inline int
+xchk_setup_rtrmapbt(struct xfs_scrub *sc, struct xfs_inode *ip)
+{
+	return -ENOENT;
+}
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip);
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
new file mode 100644
index 000000000000..95e182a306b9
--- /dev/null
+++ b/fs/xfs/scrub/rtrmap.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
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
+#include "xfs_rtalloc.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+
+/* Set us up with the realtime metadata and AG headers locked. */
+int
+xchk_setup_rtrmapbt(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = sc->mp;
+	int			lockmode;
+	int			error = 0;
+
+	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
+		return -EINVAL;
+
+	error = xchk_setup_fs(sc, ip);
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
+xchk_rtrmapbt_helper(
+	struct xchk_btree	*bs,
+	union xfs_btree_rec	*rec)
+{
+	struct xfs_mount	*mp = bs->cur->bc_mp;
+	struct xfs_rmap_irec	irec;
+	bool			non_inode;
+	bool			is_bmbt;
+	bool			is_attr;
+	int			error;
+
+	error = xfs_rmap_btrec_to_irec(bs->cur, rec, &irec);
+	if (!xchk_btree_process_error(bs->sc, bs->cur, 0, &error))
+		goto out;
+
+	if (irec.rm_startblock + irec.rm_blockcount <= irec.rm_startblock ||
+	    (!xfs_verify_rtbno(mp, irec.rm_startblock) ||
+	     !xfs_verify_rtbno(mp, irec.rm_startblock +
+				irec.rm_blockcount - 1)))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
+	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec.rm_flags & XFS_RMAP_ATTR_FORK;
+
+	if (is_bmbt || non_inode || is_attr)
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+out:
+	return error;
+}
+
+/* Scrub the realtime rmap btree. */
+int
+xchk_rtrmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_owner_info	oinfo;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	cur = xfs_rtrmapbt_init_cursor(mp, sc->tp, mp->m_rrmapip);
+	xfs_rmap_ino_bmbt_owner(&oinfo, mp->m_rrmapip->i_ino, XFS_DATA_FORK);
+	error = xchk_btree(sc, cur, xchk_rtrmapbt_helper, &oinfo, NULL);
+	xfs_btree_del_cursor(cur, error);
+
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 5f176575dad7..6d7f85b27078 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -362,6 +362,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_fscounters,
 		.repair	= xrep_fscounters,
 	},
+	[XFS_SCRUB_TYPE_RTRMAPBT] = {	/* realtime rmapbt */
+		.type	= ST_FS,
+		.setup	= xchk_setup_rtrmapbt,
+		.scrub	= xchk_rtrmapbt,
+		.has	= xfs_sb_version_hasrtrmapbt,
+		.repair	= xrep_notsupported,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 9e52caa0c0b9..312f4a56e1b9 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -99,6 +99,7 @@ int xchk_parent(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
+int xchk_rtrmapbt(struct xfs_scrub *sc);
 #else
 static inline int
 xchk_rtbitmap(struct xfs_scrub *sc)
@@ -110,6 +111,11 @@ xchk_rtsummary(struct xfs_scrub *sc)
 {
 	return -ENOENT;
 }
+static inline int
+xchk_rtrmapbt(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1146d90d7454..9fd8757c25ed 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -51,6 +51,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_UQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_GQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTRMAPBT);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -77,7 +78,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XFS_SCRUB_TYPE_UQUOTA,	"usrquota" }, \
 	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
 	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
-	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }
+	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }, \
+	{ XFS_SCRUB_TYPE_RTRMAPBT,	"rtrmapbt" }
 
 DECLARE_EVENT_CLASS(xchk_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
