Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46822 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729539AbfDARLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 13:11:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x31H9px6134674
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:11:14 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2rhwyd0gp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2019 17:11:14 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x31HBD5b015363
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:11:13 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x31HBDl9007662
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:11:13 GMT
Subject: [PATCH 09/10] xfs: scrub/repair should update filesystem metadata
 health
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Apr 2019 10:11:12 -0700
Message-ID: <155413867262.4966.18080677522827911800.stgit@magnolia>
In-Reply-To: <155413860964.4966.6087725033542837255.stgit@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we have the ability to track sick metadata in-core, make scrub
and repair update those health assessments after doing work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile       |    1 
 fs/xfs/scrub/health.c |  180 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.h |   12 +++
 fs/xfs/scrub/scrub.c  |    8 ++
 fs/xfs/scrub/scrub.h  |   11 +++
 5 files changed, 212 insertions(+)
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
index 000000000000..dd9986500801
--- /dev/null
+++ b/fs/xfs/scrub/health.c
@@ -0,0 +1,180 @@
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
+static const unsigned int xchk_type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
+	[XFS_SCRUB_TYPE_SB]		= XFS_HEALTH_AG_SB,
+	[XFS_SCRUB_TYPE_AGF]		= XFS_HEALTH_AG_AGF,
+	[XFS_SCRUB_TYPE_AGFL]		= XFS_HEALTH_AG_AGFL,
+	[XFS_SCRUB_TYPE_AGI]		= XFS_HEALTH_AG_AGI,
+	[XFS_SCRUB_TYPE_BNOBT]		= XFS_HEALTH_AG_BNOBT,
+	[XFS_SCRUB_TYPE_CNTBT]		= XFS_HEALTH_AG_CNTBT,
+	[XFS_SCRUB_TYPE_INOBT]		= XFS_HEALTH_AG_INOBT,
+	[XFS_SCRUB_TYPE_FINOBT]		= XFS_HEALTH_AG_FINOBT,
+	[XFS_SCRUB_TYPE_RMAPBT]		= XFS_HEALTH_AG_RMAPBT,
+	[XFS_SCRUB_TYPE_REFCNTBT]	= XFS_HEALTH_AG_REFCNTBT,
+	[XFS_SCRUB_TYPE_INODE]		= XFS_HEALTH_INO_CORE,
+	[XFS_SCRUB_TYPE_BMBTD]		= XFS_HEALTH_INO_BMBTD,
+	[XFS_SCRUB_TYPE_BMBTA]		= XFS_HEALTH_INO_BMBTA,
+	[XFS_SCRUB_TYPE_BMBTC]		= XFS_HEALTH_INO_BMBTC,
+	[XFS_SCRUB_TYPE_DIR]		= XFS_HEALTH_INO_DIR,
+	[XFS_SCRUB_TYPE_XATTR]		= XFS_HEALTH_INO_XATTR,
+	[XFS_SCRUB_TYPE_SYMLINK]	= XFS_HEALTH_INO_SYMLINK,
+	[XFS_SCRUB_TYPE_PARENT]		= XFS_HEALTH_INO_PARENT,
+	[XFS_SCRUB_TYPE_RTBITMAP]	= XFS_HEALTH_RT_BITMAP,
+	[XFS_SCRUB_TYPE_RTSUM]		= XFS_HEALTH_RT_SUMMARY,
+	[XFS_SCRUB_TYPE_UQUOTA]		= XFS_HEALTH_FS_UQUOTA,
+	[XFS_SCRUB_TYPE_GQUOTA]		= XFS_HEALTH_FS_GQUOTA,
+	[XFS_SCRUB_TYPE_PQUOTA]		= XFS_HEALTH_FS_PQUOTA,
+};
+
+/* Return the health status mask for this scrub type. */
+unsigned int
+xchk_health_mask_for_scrub_type(
+	__u32			scrub_type)
+{
+	return xchk_type_to_health_flag[scrub_type];
+}
+
+/* Mark metadata unhealthy. */
+static void
+xchk_mark_sick(
+	struct xfs_scrub	*sc,
+	unsigned int		mask)
+{
+	struct xfs_perag	*pag;
+
+	if (!mask)
+		return;
+
+	switch (sc->sm->sm_type) {
+	case XFS_SCRUB_TYPE_SB:
+	case XFS_SCRUB_TYPE_AGF:
+	case XFS_SCRUB_TYPE_AGFL:
+	case XFS_SCRUB_TYPE_AGI:
+	case XFS_SCRUB_TYPE_BNOBT:
+	case XFS_SCRUB_TYPE_CNTBT:
+	case XFS_SCRUB_TYPE_INOBT:
+	case XFS_SCRUB_TYPE_FINOBT:
+	case XFS_SCRUB_TYPE_RMAPBT:
+	case XFS_SCRUB_TYPE_REFCNTBT:
+		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
+		xfs_ag_mark_sick(pag, mask);
+		xfs_perag_put(pag);
+		break;
+	case XFS_SCRUB_TYPE_INODE:
+	case XFS_SCRUB_TYPE_BMBTD:
+	case XFS_SCRUB_TYPE_BMBTA:
+	case XFS_SCRUB_TYPE_BMBTC:
+	case XFS_SCRUB_TYPE_DIR:
+	case XFS_SCRUB_TYPE_XATTR:
+	case XFS_SCRUB_TYPE_SYMLINK:
+	case XFS_SCRUB_TYPE_PARENT:
+		xfs_inode_mark_sick(sc->ip, mask);
+		break;
+	case XFS_SCRUB_TYPE_UQUOTA:
+	case XFS_SCRUB_TYPE_GQUOTA:
+	case XFS_SCRUB_TYPE_PQUOTA:
+		xfs_fs_mark_sick(sc->mp, mask);
+		break;
+	case XFS_SCRUB_TYPE_RTBITMAP:
+	case XFS_SCRUB_TYPE_RTSUM:
+		xfs_rt_mark_sick(sc->mp, mask);
+		break;
+	default:
+		break;
+	}
+}
+
+/* Mark metadata healed after a repair or healthy after a clean scan. */
+static void
+xchk_mark_healthy(
+	struct xfs_scrub	*sc,
+	unsigned int		mask)
+{
+	struct xfs_perag	*pag;
+
+	if (!mask)
+		return;
+
+	switch (sc->sm->sm_type) {
+	case XFS_SCRUB_TYPE_SB:
+	case XFS_SCRUB_TYPE_AGF:
+	case XFS_SCRUB_TYPE_AGFL:
+	case XFS_SCRUB_TYPE_AGI:
+	case XFS_SCRUB_TYPE_BNOBT:
+	case XFS_SCRUB_TYPE_CNTBT:
+	case XFS_SCRUB_TYPE_INOBT:
+	case XFS_SCRUB_TYPE_FINOBT:
+	case XFS_SCRUB_TYPE_RMAPBT:
+	case XFS_SCRUB_TYPE_REFCNTBT:
+		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
+		xfs_ag_mark_healthy(pag, mask);
+		xfs_perag_put(pag);
+		break;
+	case XFS_SCRUB_TYPE_INODE:
+	case XFS_SCRUB_TYPE_BMBTD:
+	case XFS_SCRUB_TYPE_BMBTA:
+	case XFS_SCRUB_TYPE_BMBTC:
+	case XFS_SCRUB_TYPE_DIR:
+	case XFS_SCRUB_TYPE_XATTR:
+	case XFS_SCRUB_TYPE_SYMLINK:
+	case XFS_SCRUB_TYPE_PARENT:
+		xfs_inode_mark_healthy(sc->ip, mask);
+		break;
+	case XFS_SCRUB_TYPE_UQUOTA:
+	case XFS_SCRUB_TYPE_GQUOTA:
+	case XFS_SCRUB_TYPE_PQUOTA:
+		xfs_fs_mark_healthy(sc->mp, mask);
+		break;
+	case XFS_SCRUB_TYPE_RTBITMAP:
+	case XFS_SCRUB_TYPE_RTSUM:
+		xfs_rt_mark_healthy(sc->mp, mask);
+		break;
+	default:
+		break;
+	}
+}
+
+/* Update filesystem health assessments based on what we found and did. */
+void
+xchk_update_health(
+	struct xfs_scrub	*sc,
+	bool			already_fixed)
+{
+	/*
+	 * If the scrubber finds errors, we mark sick whatever's mentioned in
+	 * sick_mask, no matter whether this is a first scan or an evaluation
+	 * of repair effectiveness.
+	 *
+	 * If there is no direct corruption and we're called after a repair,
+	 * clear whatever's in heal_mask because that's what we fixed.
+	 *
+	 * Otherwise, there's no direct corruption and we didn't repair
+	 * anything, so mark whatever's in sick_mask as healthy.
+	 */
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		xchk_mark_sick(sc, sc->sick_mask);
+	else if (already_fixed)
+		xchk_mark_healthy(sc, sc->heal_mask);
+	else
+		xchk_mark_healthy(sc, sc->sick_mask);
+}
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
new file mode 100644
index 000000000000..e795f4c9a23c
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
+void xchk_update_health(struct xfs_scrub *sc, bool already_fixed);
+
+#endif /* __XFS_SCRUB_HEALTH_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1b2344d00525..b1519dfc5811 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -40,6 +40,7 @@
 #include "scrub/trace.h"
 #include "scrub/btree.h"
 #include "scrub/repair.h"
+#include "scrub/health.h"
 
 /*
  * Online Scrub and Repair
@@ -468,6 +469,7 @@ xfs_scrub_metadata(
 {
 	struct xfs_scrub		sc;
 	struct xfs_mount		*mp = ip->i_mount;
+	unsigned int			heal_mask;
 	bool				try_harder = false;
 	bool				already_fixed = false;
 	int				error = 0;
@@ -488,6 +490,7 @@ xfs_scrub_metadata(
 	error = xchk_validate_inputs(mp, sm);
 	if (error)
 		goto out;
+	heal_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
 
 	xchk_experimental_warning(mp);
 
@@ -499,6 +502,8 @@ xfs_scrub_metadata(
 	sc.ops = &meta_scrub_ops[sm->sm_type];
 	sc.try_harder = try_harder;
 	sc.sa.agno = NULLAGNUMBER;
+	sc.heal_mask = heal_mask;
+	sc.sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
 	error = sc.ops->setup(&sc, ip);
 	if (error)
 		goto out_teardown;
@@ -519,6 +524,8 @@ xfs_scrub_metadata(
 	} else if (error)
 		goto out_teardown;
 
+	xchk_update_health(&sc, already_fixed);
+
 	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) && !already_fixed) {
 		bool needs_fix;
 
@@ -551,6 +558,7 @@ xfs_scrub_metadata(
 				xrep_failure(mp);
 				goto out;
 			}
+			heal_mask = sc.heal_mask;
 			goto retry_op;
 		}
 	}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 22f754fba8e5..05f1ad242a35 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -62,6 +62,17 @@ struct xfs_scrub {
 	struct xfs_inode		*ip;
 	void				*buf;
 	uint				ilock_flags;
+
+	/* Metadata to be marked sick if scrub finds errors. */
+	unsigned int			sick_mask;
+
+	/*
+	 * Metadata to be marked healthy if repair fixes errors.  Some repair
+	 * functions can fix multiple data structures at once, so we have to
+	 * treat sick and heal masks separately.
+	 */
+	unsigned int			heal_mask;
+
 	bool				try_harder;
 	bool				has_quotaofflock;
 
