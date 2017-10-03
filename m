Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41972 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbdJCUmU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:42:20 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93KgJVE002975
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v93KgJ28015998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:19 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v93KgIwa001624
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:19 GMT
Subject: [PATCH 14/25] xfs: scrub rmap btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:42:17 -0700
Message-ID: <150706333767.19351.13637260621369926859.stgit@magnolia>
In-Reply-To: <150706324963.19351.17715069858921948692.stgit@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the reverse mapping records to make sure that the contents
make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 +
 fs/xfs/scrub/common.h  |    2 +
 fs/xfs/scrub/rmap.c    |  137 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |    5 ++
 fs/xfs/scrub/scrub.h   |    1 
 6 files changed, 148 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/rmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 82326b7..5a64f8d 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -151,6 +151,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
+				   rmap.o \
 				   scrub.o \
 				   )
 endif
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 74df6ec..fb1d997 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -492,9 +492,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_CNTBT	6	/* freesp by length btree */
 #define XFS_SCRUB_TYPE_INOBT	7	/* inode btree */
 #define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
+#define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	9
+#define XFS_SCRUB_TYPE_NR	10
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 60b159a..dd12b37 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -82,6 +82,8 @@ int xfs_scrub_setup_ag_allocbt(struct xfs_scrub_context *sc,
 			       struct xfs_inode *ip);
 int xfs_scrub_setup_ag_iallocbt(struct xfs_scrub_context *sc,
 				struct xfs_inode *ip);
+int xfs_scrub_setup_ag_rmapbt(struct xfs_scrub_context *sc,
+			      struct xfs_inode *ip);
 
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
new file mode 100644
index 0000000..d4ec751
--- /dev/null
+++ b/fs/xfs/scrub/rmap.c
@@ -0,0 +1,137 @@
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
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+
+/*
+ * Set us up to scrub reverse mapping btrees.
+ */
+int
+xfs_scrub_setup_ag_rmapbt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return xfs_scrub_setup_ag_btree(sc, ip, false);
+}
+
+/* Reverse-mapping scrubber. */
+
+/* Scrub an rmapbt record. */
+STATIC int
+xfs_scrub_rmapbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agf			*agf;
+	struct xfs_rmap_irec		irec;
+	unsigned long long		rec_end;
+	xfs_agblock_t			eoag;
+	bool				non_inode;
+	bool				is_unwritten;
+	bool				is_bmbt;
+	bool				is_attr;
+	int				error;
+
+	error = xfs_rmap_btrec_to_irec(rec, &irec);
+	if (!xfs_scrub_btree_op_ok(bs->sc, bs->cur, 0, &error))
+		goto out;
+
+	/* Check extent. */
+	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
+	eoag = be32_to_cpu(agf->agf_length);
+	rec_end = (unsigned long long)irec.rm_startblock + irec.rm_blockcount;
+
+	if (irec.rm_startblock >= mp->m_sb.sb_agblocks ||
+	    irec.rm_startblock >= eoag ||
+	    irec.rm_blockcount == 0 ||
+	    rec_end > mp->m_sb.sb_agblocks ||
+	    rec_end > eoag)
+		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	/* Check flags. */
+	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
+	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec.rm_flags & XFS_RMAP_ATTR_FORK;
+	is_unwritten = irec.rm_flags & XFS_RMAP_UNWRITTEN;
+
+	if (is_bmbt && irec.rm_offset != 0)
+		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	if (non_inode && irec.rm_offset != 0)
+		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	if (is_unwritten && (is_bmbt || non_inode || is_attr))
+		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	if (non_inode && (is_bmbt || is_unwritten || is_attr))
+		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	if (!non_inode) {
+		xfs_agnumber_t	agno = XFS_INO_TO_AGNO(mp, irec.rm_owner);
+		xfs_agino_t	agino = XFS_INO_TO_AGINO(mp, irec.rm_owner);
+		xfs_agblock_t	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+
+		/* Owner inode within an AG? */
+		if (agno >= mp->m_sb.sb_agcount ||
+		    agbno >= mp->m_sb.sb_agblocks)
+			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+		/* Owner inode within the FS? */
+		if (XFS_AGB_TO_DADDR(mp, agno, agbno) >=
+		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks))
+			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+	} else {
+		/* Non-inode owner within the magic values? */
+		if (irec.rm_owner <= XFS_RMAP_OWN_MIN ||
+		    irec.rm_owner > XFS_RMAP_OWN_FS)
+			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+	}
+out:
+	return error;
+}
+
+/* Scrub the rmap btree for some AG. */
+int
+xfs_scrub_rmapbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_owner_info		oinfo;
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	return xfs_scrub_btree(sc, sc->sa.rmap_cur, xfs_scrub_rmapbt_helper,
+			&oinfo, NULL);
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f209348..35f7dce 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -186,6 +186,11 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.scrub	= xfs_scrub_finobt,
 		.has	= xfs_sb_version_hasfinobt,
 	},
+	{ /* rmapbt */
+		.setup	= xfs_scrub_setup_ag_rmapbt,
+		.scrub	= xfs_scrub_rmapbt,
+		.has	= xfs_sb_version_hasrmapbt,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 5d97453..0d1e78b 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -75,5 +75,6 @@ int xfs_scrub_bnobt(struct xfs_scrub_context *sc);
 int xfs_scrub_cntbt(struct xfs_scrub_context *sc);
 int xfs_scrub_inobt(struct xfs_scrub_context *sc);
 int xfs_scrub_finobt(struct xfs_scrub_context *sc);
+int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

