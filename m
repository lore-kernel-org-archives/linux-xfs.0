Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbeLRUjk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:39:40 -0500
Subject: [PATCH 3/6] xfs: move XFS_AG_BTREE_CMP_FORMAT_STR mappings to libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Dec 2018 12:39:35 -0800
Message-ID: <154516557556.31776.15154742444799963226.stgit@magnolia>
In-Reply-To: <154516555511.31776.9868161112615886200.stgit@magnolia>
References: <154516555511.31776.9868161112615886200.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, sandeen@sandeen.net

From: Darrick J. Wong <darrick.wong@oracle.com>

Move XFS_AG_BTREE_CMP_FORMAT_STR to libxfs so that we don't forget to
keep it updated, and TRACE_DEFINE_ENUM the values while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_types.h |    5 +++++
 fs/xfs/xfs_trace.h        |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index e03508a650c4..2b48ff397355 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -108,6 +108,11 @@ typedef enum {
 	XFS_LOOKUP_EQi, XFS_LOOKUP_LEi, XFS_LOOKUP_GEi
 } xfs_lookup_t;
 
+#define XFS_AG_BTREE_CMP_FORMAT_STR \
+	{ XFS_LOOKUP_EQi,	"eq" }, \
+	{ XFS_LOOKUP_LEi,	"le" }, \
+	{ XFS_LOOKUP_GEi,	"ge" }
+
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index deac0b3e64c2..3f57002ca660 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2629,10 +2629,6 @@ DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 TRACE_DEFINE_ENUM(XFS_LOOKUP_EQi);
 TRACE_DEFINE_ENUM(XFS_LOOKUP_LEi);
 TRACE_DEFINE_ENUM(XFS_LOOKUP_GEi);
-#define XFS_AG_BTREE_CMP_FORMAT_STR \
-	{ XFS_LOOKUP_EQ,	"eq" }, \
-	{ XFS_LOOKUP_LE,	"le" }, \
-	{ XFS_LOOKUP_GE,	"ge" }
 DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_lookup_t dir),
