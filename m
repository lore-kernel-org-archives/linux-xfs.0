Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfDPAUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 20:20:01 -0400
Subject: [PATCH 4/5] xfs: scrub/repair should update filesystem metadata
 health
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Apr 2019 17:19:55 -0700
Message-ID: <155537399567.27935.2695652869908662243.stgit@magnolia>
In-Reply-To: <155537397092.27935.16073573221774618735.stgit@magnolia>
References: <155537397092.27935.16073573221774618735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we have the ability to track sick metadata in-core, make scrub
and repair update those health assessments after doing work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile       |    1 
 fs/xfs/scrub/health.c |  176 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.h |   12 +++
 fs/xfs/scrub/scrub.c  |    4 +
 fs/xfs/scrub/scrub.h  |    7 ++
 5 files changed, 200 insertions(+)
 create mode 100644 fs/xfs/scrub/health.c
 create mode 100644 fs/xfs/scrub/health.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 786379c143f4..b20964e26a22 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -143,6 +143,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   common.o \
 				   dabtree.o \
 				   dir.o \
+				   health.o \
 				   ialloc.o \
 				   inode.o \
 				   parent.o \
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
new file mode 100644
index 000000000000..770ab0723a38
--- /dev/null
+++ b/fs/xfs/scrub/health.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
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
+#include "xfs_inode.h"
+#include "xfs_health.h"
+#include "scrub/scrub.h"
+#include "scrub/health.h"
+
+/*
+ * Scrub and In-Core Filesystem Health Assessments
+ * ===============================================
+ *
+ * Online scrub and repair have the time and the ability to perform stronger
+ * checks than we can do from the metadata verifiers, because they can
+ * cross-reference records between data structures.  Therefore, scrub is in a
+ * good position to update the online filesystem health assessments to reflect
+ * the good/bad state of the data structure.
+ *
+ * We therefore extend scrub in the following ways to achieve this:
+ *
+ * 1. Create a "sick_mask_update" field in the scrub context.  When we're
+ * setting up a scrub call, set this to the default XFS_SICK_* flag(s) for the
+ * selected scrub type (call it A).  Scrub and repair functions can override
+ * the default sick_mask_update value if they choose.
+ *
+ * 2. If the scrubber returns a runtime error code, we exit making no changes
+ * to the incore sick state.
+ *
+ * 3. If the scrubber finds that A is clean, use sick_mask_update to clear the
+ * incore sick flags before exiting.
+ *
+ * 4. If the scrubber finds that A is corrupt, use sick_mask_update to set the
+ * incore sick flags.  If the user didn't want to repair then we exit, leaving
+ * the metadata structure unfixed and the sick flag set.
+ *
+ * 5. Now we know that A is corrupt and the user wants to repair, so run the
+ * repairer.  If the repairer returns an error code, we exit with that error
+ * code, having made no further changes to the incore sick state.
+ *
+ * 6. If repair rebuilds A correctly and the subsequent re-scrub of A is
+ * clean, use sick_mask_update to clear the incore sick flags.  This should
+ * have the effect that A is no longer marked sick.
+ *
+ * 7. If repair rebuilds A incorrectly, the re-scrub will find it corrupt and
+ * use sick_mask_update to set the incore sick flags.  This should have no
+ * externally visible effect since we already set them in step (4).
+ *
+ * There are some complications to this story, however.  For certain types of
+ * complementary metadata indices (e.g. inobt/finobt), it is easier to rebuild
+ * both structures at the same time.  The following principles apply to this
+ * type of repair strategy:
+ *
+ * 8. Any repair function that rebuilds multiple structures should update
+ * sick_mask_visible to reflect whatever other structures are rebuilt, and
+ * verify that all the rebuilt structures can pass a scrub check.  The
+ * outcomes of 5-7 still apply, but with a sick_mask_update that covers
+ * everything being rebuilt.
+ */
+
+/* Map our scrub type to a sick mask and a set of health update functions. */
+
+enum xchk_health_group {
+	XHG_FS = 1,
+	XHG_RT,
+	XHG_AG,
+	XHG_INO,
+};
+
+struct xchk_health_map {
+	enum xchk_health_group	group;
+	unsigned int		sick_mask;
+};
+
+static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
+	[XFS_SCRUB_TYPE_SB]		= { XHG_AG,  XFS_SICK_AG_SB },
+	[XFS_SCRUB_TYPE_AGF]		= { XHG_AG,  XFS_SICK_AG_AGF },
+	[XFS_SCRUB_TYPE_AGFL]		= { XHG_AG,  XFS_SICK_AG_AGFL },
+	[XFS_SCRUB_TYPE_AGI]		= { XHG_AG,  XFS_SICK_AG_AGI },
+	[XFS_SCRUB_TYPE_BNOBT]		= { XHG_AG,  XFS_SICK_AG_BNOBT },
+	[XFS_SCRUB_TYPE_CNTBT]		= { XHG_AG,  XFS_SICK_AG_CNTBT },
+	[XFS_SCRUB_TYPE_INOBT]		= { XHG_AG,  XFS_SICK_AG_INOBT },
+	[XFS_SCRUB_TYPE_FINOBT]		= { XHG_AG,  XFS_SICK_AG_FINOBT },
+	[XFS_SCRUB_TYPE_RMAPBT]		= { XHG_AG,  XFS_SICK_AG_RMAPBT },
+	[XFS_SCRUB_TYPE_REFCNTBT]	= { XHG_AG,  XFS_SICK_AG_REFCNTBT },
+	[XFS_SCRUB_TYPE_INODE]		= { XHG_INO, XFS_SICK_INO_CORE },
+	[XFS_SCRUB_TYPE_BMBTD]		= { XHG_INO, XFS_SICK_INO_BMBTD },
+	[XFS_SCRUB_TYPE_BMBTA]		= { XHG_INO, XFS_SICK_INO_BMBTA },
+	[XFS_SCRUB_TYPE_BMBTC]		= { XHG_INO, XFS_SICK_INO_BMBTC },
+	[XFS_SCRUB_TYPE_DIR]		= { XHG_INO, XFS_SICK_INO_DIR },
+	[XFS_SCRUB_TYPE_XATTR]		= { XHG_INO, XFS_SICK_INO_XATTR },
+	[XFS_SCRUB_TYPE_SYMLINK]	= { XHG_INO, XFS_SICK_INO_SYMLINK },
+	[XFS_SCRUB_TYPE_PARENT]		= { XHG_INO, XFS_SICK_INO_PARENT },
+	[XFS_SCRUB_TYPE_RTBITMAP]	= { XHG_RT,  XFS_SICK_RT_BITMAP },
+	[XFS_SCRUB_TYPE_RTSUM]		= { XHG_RT,  XFS_SICK_RT_SUMMARY },
+	[XFS_SCRUB_TYPE_UQUOTA]		= { XHG_FS,  XFS_SICK_FS_UQUOTA },
+	[XFS_SCRUB_TYPE_GQUOTA]		= { XHG_FS,  XFS_SICK_FS_GQUOTA },
+	[XFS_SCRUB_TYPE_PQUOTA]		= { XHG_FS,  XFS_SICK_FS_PQUOTA },
+};
+
+/* Return the health status mask for this scrub type. */
+unsigned int
+xchk_health_mask_for_scrub_type(
+	__u32			scrub_type)
+{
+	return type_to_health_flag[scrub_type].sick_mask;
+}
+
+/*
+ * Update filesystem health assessments based on what we found and did.
+ *
+ * If the scrubber finds errors, we mark sick whatever's mentioned in
+ * sick_mask_update, no matter whether this is a first scan or an
+ * evaluation of repair effectiveness.
+ *
+ * Otherwise, no direct corruption was found, so mark whatever's in
+ * sick_mask_update as healthy.
+ */
+void
+xchk_update_health(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_perag	*pag;
+	bool			bad;
+
+	if (!sc->sick_mask_update)
+		return;
+
+	bad = (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT);
+	switch (type_to_health_flag[sc->sm->sm_type].group) {
+	case XHG_AG:
+		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
+		if (bad)
+			xfs_ag_mark_sick(pag, sc->sick_mask_update);
+		else
+			xfs_ag_mark_healthy(pag, sc->sick_mask_update);
+		xfs_perag_put(pag);
+		break;
+	case XHG_INO:
+		if (!sc->ip)
+			return;
+		if (bad)
+			xfs_inode_mark_sick(sc->ip, sc->sick_mask_update);
+		else
+			xfs_inode_mark_healthy(sc->ip, sc->sick_mask_update);
+		break;
+	case XHG_FS:
+		if (bad)
+			xfs_fs_mark_sick(sc->mp, sc->sick_mask_update);
+		else
+			xfs_fs_mark_healthy(sc->mp, sc->sick_mask_update);
+		break;
+	case XHG_RT:
+		if (bad)
+			xfs_rt_mark_sick(sc->mp, sc->sick_mask_update);
+		else
+			xfs_rt_mark_healthy(sc->mp, sc->sick_mask_update);
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+}
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
new file mode 100644
index 000000000000..fd0d466c8658
--- /dev/null
+++ b/fs/xfs/scrub/health.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_SCRUB_HEALTH_H__
+#define __XFS_SCRUB_HEALTH_H__
+
+unsigned int xchk_health_mask_for_scrub_type(__u32 scrub_type);
+void xchk_update_health(struct xfs_scrub *sc);
+
+#endif /* __XFS_SCRUB_HEALTH_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 02d278b7d20b..01d5bfc1917c 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -40,6 +40,7 @@
 #include "scrub/trace.h"
 #include "scrub/btree.h"
 #include "scrub/repair.h"
+#include "scrub/health.h"
 
 /*
  * Online Scrub and Repair
@@ -498,6 +499,7 @@ xfs_scrub_metadata(
 	xchk_experimental_warning(mp);
 
 	sc.ops = &meta_scrub_ops[sm->sm_type];
+	sc.sick_mask_update = xchk_health_mask_for_scrub_type(sm->sm_type);
 retry_op:
 	/* Set up for the operation. */
 	error = sc.ops->setup(&sc, ip);
@@ -520,6 +522,8 @@ xfs_scrub_metadata(
 	} else if (error)
 		goto out_teardown;
 
+	xchk_update_health(&sc);
+
 	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
 	    !(sc.flags & XREP_ALREADY_FIXED)) {
 		bool needs_fix;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1b23bf141438..b1d632f1c5ff 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -66,6 +66,13 @@ struct xfs_scrub {
 	/* See the XCHK/XREP state flags below. */
 	unsigned int			flags;
 
+	/*
+	 * The XFS_SICK_* flags that correspond to the metadata being scrubbed
+	 * or repaired.  We will use this mask to update the in-core fs health
+	 * status with whatever we find.
+	 */
+	unsigned int			sick_mask_update;
+
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
 };
