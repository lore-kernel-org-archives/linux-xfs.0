Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729526AbfDARLW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 13:11:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x31H9Lkx131470
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:11:20 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2rhyvt0cxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2019 17:11:20 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x31HBJ3n015532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:11:19 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x31HBJiw007802
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:11:19 GMT
Subject: [PATCH 10/10] xfs: update health status if we get a clean bill of
 health
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Apr 2019 10:11:18 -0700
Message-ID: <155413867884.4966.3786317285199498710.stgit@magnolia>
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

If scrub finds that everything is ok with the filesystem, we need a way
to tell the health tracking that it can let go of indirect health flags,
since indirect flags only mean that at some point in the past we lost
some context.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    3 ++
 fs/xfs/scrub/common.c  |   12 ++++++++++
 fs/xfs/scrub/common.h  |    1 +
 fs/xfs/scrub/health.c  |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.h  |    1 +
 fs/xfs/scrub/repair.c  |    1 +
 fs/xfs/scrub/scrub.c   |    6 +++++
 fs/xfs/scrub/trace.h   |    4 ++-
 8 files changed, 84 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index fffaead718a5..320274d3809a 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -574,9 +574,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_UQUOTA	21	/* user quotas */
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
+#define XFS_SCRUB_TYPE_HEALTHY	24	/* everything checked out ok */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	24
+#define XFS_SCRUB_TYPE_NR	25
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 0c54ff55b901..9064ed567e37 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -208,6 +208,18 @@ xchk_ino_set_preen(
 	trace_xchk_ino_preen(sc, ino, __return_address);
 }
 
+/* Record non-specific corruption. */
+void
+xchk_set_corrupt(
+	struct xfs_scrub	*sc)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	xfs_scrub_whine(sc->mp, "type %d ret_ip %pS",
+			sc->sm->sm_type,
+			__return_address);
+	trace_xchk_fs_error(sc, 0, __return_address);
+}
+
 /* Record a corrupt block. */
 void
 xchk_block_set_corrupt(
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e26a430bd466..1b7b8c555f2e 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -39,6 +39,7 @@ void xchk_block_set_preen(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
 void xchk_ino_set_preen(struct xfs_scrub *sc, xfs_ino_t ino);
 
+void xchk_set_corrupt(struct xfs_scrub *sc);
 void xchk_block_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
 void xchk_ino_set_corrupt(struct xfs_scrub *sc, xfs_ino_t ino);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index dd9986500801..049e802b9418 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -19,6 +19,7 @@
 #include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/health.h"
+#include "scrub/common.h"
 
 static const unsigned int xchk_type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_SB]		= XFS_HEALTH_AG_SB,
@@ -54,6 +55,60 @@ xchk_health_mask_for_scrub_type(
 	return xchk_type_to_health_flag[scrub_type];
 }
 
+/*
+ * Quick scan to double-check that there isn't any evidence of lingering
+ * primary health problems.  If we're still clear, then the health update will
+ * take care of clearing the indirect evidence.
+ */
+int
+xchk_health_record(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	unsigned int		sick;
+
+	sick = xfs_fs_measure_sickness(mp);
+	if (sick & XFS_HEALTH_FS_PRIMARY)
+		xchk_set_corrupt(sc);
+
+	sick = xfs_rt_measure_sickness(mp);
+	if (sick & XFS_HEALTH_RT_PRIMARY)
+		xchk_set_corrupt(sc);
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		sick = xfs_ag_measure_sickness(pag);
+		if (sick & XFS_HEALTH_AG_PRIMARY)
+			xchk_set_corrupt(sc);
+		xfs_perag_put(pag);
+	}
+
+	return 0;
+}
+
+/*
+ * Scrub gave the filesystem a clean bill of health, so clear all the indirect
+ * markers of past problems (at least for the fs and ags) so that we can be
+ * healthy again.
+ */
+STATIC void
+xchk_mark_all_healthy(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	int			error = 0;
+
+	xfs_fs_mark_healthy(mp, XFS_HEALTH_FS_INDIRECT);
+	xfs_rt_mark_healthy(mp, XFS_HEALTH_RT_INDIRECT);
+	for (agno = 0; error == 0 && agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		xfs_ag_mark_healthy(pag, XFS_HEALTH_AG_INDIRECT);
+		xfs_perag_put(pag);
+	}
+}
 /* Mark metadata unhealthy. */
 static void
 xchk_mark_sick(
@@ -149,6 +204,9 @@ xchk_mark_healthy(
 	case XFS_SCRUB_TYPE_RTSUM:
 		xfs_rt_mark_healthy(sc->mp, mask);
 		break;
+	case XFS_SCRUB_TYPE_HEALTHY:
+		xchk_mark_all_healthy(sc->mp);
+		break;
 	default:
 		break;
 	}
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
index e795f4c9a23c..001e5a93273d 100644
--- a/fs/xfs/scrub/health.h
+++ b/fs/xfs/scrub/health.h
@@ -8,5 +8,6 @@
 
 unsigned int xchk_health_mask_for_scrub_type(__u32 scrub_type);
 void xchk_update_health(struct xfs_scrub *sc, bool already_fixed);
+int xchk_health_record(struct xfs_scrub *sc);
 
 #endif /* __XFS_SCRUB_HEALTH_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f28f4bad317b..5df67fe5d8ac 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -31,6 +31,7 @@
 #include "xfs_quota.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
+#include "xfs_health.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b1519dfc5811..f446ab57d7b0 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -348,6 +348,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_quota,
 		.repair	= xrep_notsupported,
 	},
+	[XFS_SCRUB_TYPE_HEALTHY] = {	/* fs healthy; clean all reminders */
+		.type	= ST_FS,
+		.setup	= xchk_setup_fs,
+		.scrub	= xchk_health_record,
+		.repair = xrep_notsupported,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3c83e8b3b39c..7c25a38c6f81 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -75,7 +75,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
 	{ XFS_SCRUB_TYPE_RTSUM,		"rtsummary" }, \
 	{ XFS_SCRUB_TYPE_UQUOTA,	"usrquota" }, \
 	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
-	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }
+	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
+	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }
 
 DECLARE_EVENT_CLASS(xchk_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
@@ -223,6 +224,7 @@ DEFINE_EVENT(xchk_block_error_class, name, \
 		 void *ret_ip), \
 	TP_ARGS(sc, daddr, ret_ip))
 
+DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_fs_error);
 DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_error);
 DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_preen);
 
