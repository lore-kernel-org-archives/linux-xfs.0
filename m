Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbeH3Wg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Aug 2018 18:36:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7UISg3V133736
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:30 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2m2yrqpb25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7UIXOi4026482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:24 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7UIXNIj020094
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:23 GMT
Subject: [PATCH 16/18] xfs: scrub the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 30 Aug 2018 11:33:21 -0700
Message-ID: <153565400192.32612.147987129357562666.stgit@magnolia>
In-Reply-To: <153565389576.32612.11057291402738397706.stgit@magnolia>
References: <153565389576.32612.11057291402738397706.stgit@magnolia>
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
 7 files changed, 135 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c9b452646699..8aa72dc8be83 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -159,7 +159,10 @@ xfs-y				+= $(addprefix scrub/, \
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
index 6659f41e7b4c..b62845d016d2 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -648,6 +648,7 @@ xchk_bmap(
 	case XFS_DINODE_FMT_UUID:
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_RMAP:
 		/* No mappings to check. */
 		goto out;
 	case XFS_DINODE_FMT_EXTENTS:
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 97da298abedd..6bccffddc832 100644
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
index 000000000000..6dde3c026918
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
+	xfs_rmap_ino_bmbt_owner(&oinfo, mp->m_sb.sb_rrmapino, XFS_DATA_FORK);
+	error = xchk_btree(sc, cur, xchk_rtrmapbt_helper, &oinfo, NULL);
+	xfs_btree_del_cursor(cur, error);
+
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 047261cedd4b..b7910238d4a4 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -361,6 +361,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
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
index 1ce261f648f3..470785292b46 100644
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
