Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56540 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbeLRUjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:39:47 -0500
Subject: [PATCH 4/6] xfs: move XFS_INODE_FORMAT_STR mappings to libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Dec 2018 12:39:41 -0800
Message-ID: <154516558181.31776.11748064239827461401.stgit@magnolia>
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

Move XFS_INODE_FORMAT_STR to libxfs so that we don't forget to keep it
updated, and add necessary TRACE_DEFINE_ENUM.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |   10 ++++++++++
 fs/xfs/xfs_trace.h         |   10 +++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b15412e4c535..9bb3c48843ec 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -916,6 +916,9 @@ static inline uint xfs_dinode_size(int version)
 
 /*
  * Values for di_format
+ *
+ * This enum is used in string mapping in xfs_trace.h; please keep the
+ * TRACE_DEFINE_ENUMs for it up to date.
  */
 typedef enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_DEV,		/* xfs_dev_t */
@@ -925,6 +928,13 @@ typedef enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
 } xfs_dinode_fmt_t;
 
+#define XFS_INODE_FORMAT_STR \
+	{ XFS_DINODE_FMT_DEV,		"dev" }, \
+	{ XFS_DINODE_FMT_LOCAL,		"local" }, \
+	{ XFS_DINODE_FMT_EXTENTS,	"extent" }, \
+	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
+	{ XFS_DINODE_FMT_UUID,		"uuid" }
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3f57002ca660..94e289aca220 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1901,11 +1901,11 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
 	{ 0,	"target" }, \
 	{ 1,	"temp" }
 
-#define XFS_INODE_FORMAT_STR \
-	{ 0,	"invalid" }, \
-	{ 1,	"local" }, \
-	{ 2,	"extent" }, \
-	{ 3,	"btree" }
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_DEV);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_LOCAL);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_EXTENTS);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_BTREE);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_UUID);
 
 DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 	TP_PROTO(struct xfs_inode *ip, int which),
