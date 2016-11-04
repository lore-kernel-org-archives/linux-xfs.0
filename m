Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46604 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934946AbcKDSbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 14:31:10 -0400
Subject: [PATCH 10/11] libxfs: clean up _dir2_data_freescan
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 11:31:07 -0700
Message-ID: <147828426737.31492.978199544435434965.stgit@birch.djwong.org>
In-Reply-To: <147828420554.31492.4173929442743951581.stgit@birch.djwong.org>
References: <147828420554.31492.4173929442743951581.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Refactor the implementations of xfs_dir2_data_freescan into a
routine that takes the raw directory block parameters and
a second function that figures out the raw parameters from the
directory inode.  This enables us to use the exact same code
for both userspace and the kernel, since repair knows exactly
which directory block geometry parameters it needs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    2 +-
 libxfs/libxfs_priv.h     |    8 --------
 libxfs/xfs_dir2.h        |    4 +++-
 libxfs/xfs_dir2_data.c   |   12 +++++++++++-
 repair/dir2.c            |    4 ++--
 repair/phase6.c          |    3 ++-
 6 files changed, 19 insertions(+), 14 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d60b6c2..12a668e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -88,7 +88,7 @@
 #define xfs_dir_replace			libxfs_dir_replace
 #define xfs_dir2_isblock		libxfs_dir2_isblock
 #define xfs_dir2_isleaf			libxfs_dir2_isleaf
-#define __xfs_dir2_data_freescan	libxfs_dir2_data_freescan
+#define xfs_dir2_data_freescan_hdr	libxfs_dir2_data_freescan_hdr
 #define xfs_dir2_data_log_entry		libxfs_dir2_data_log_entry
 #define xfs_dir2_data_log_header	libxfs_dir2_data_log_header
 #define xfs_dir2_data_make_free		libxfs_dir2_data_make_free
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index a101a00..f4db183 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -49,14 +49,6 @@
 #ifndef __LIBXFS_INTERNAL_XFS_H__
 #define __LIBXFS_INTERNAL_XFS_H__
 
-/*
- * Repair doesn't have a inode when it calls libxfs_dir2_data_freescan,
- * so we to work around this internally for now.
- */
-#define xfs_dir2_data_freescan(ip, hdr, loghead) \
-	__xfs_dir2_data_freescan((ip)->i_mount->m_dir_geo, \
-				 (ip)->d_ops, hdr, loghead)
-
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
 #include "xfs.h"
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 89b9e24..385d6d5 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -157,9 +157,11 @@ extern int xfs_dir2_isleaf(struct xfs_da_args *args, int *r);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_buf *bp);
 
-extern void __xfs_dir2_data_freescan(struct xfs_da_geometry *geo,
+extern void xfs_dir2_data_freescan_hdr(struct xfs_da_geometry *geo,
 		const struct xfs_dir_ops *ops,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
+extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
+		struct xfs_dir2_data_hdr *hdr, int *loghead);
 extern void xfs_dir2_data_log_entry(struct xfs_da_args *args,
 		struct xfs_buf *bp, struct xfs_dir2_data_entry *dep);
 extern void xfs_dir2_data_log_header(struct xfs_da_args *args,
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 6ae5cd2..1dc0fa6 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -502,7 +502,7 @@ xfs_dir2_data_freeremove(
  * Given a data block, reconstruct its bestfree map.
  */
 void
-__xfs_dir2_data_freescan(
+xfs_dir2_data_freescan_hdr(
 	struct xfs_da_geometry	*geo,
 	const struct xfs_dir_ops *ops,
 	struct xfs_dir2_data_hdr *hdr,
@@ -562,6 +562,16 @@ __xfs_dir2_data_freescan(
 	}
 }
 
+void
+xfs_dir2_data_freescan(
+	struct xfs_inode	*dp,
+	struct xfs_dir2_data_hdr *hdr,
+	int			*loghead)
+{
+	return xfs_dir2_data_freescan_hdr(dp->i_mount->m_dir_geo, dp->d_ops,
+			hdr, loghead);
+}
+
 /*
  * Initialize a data block at the given block number in the directory.
  * Give back the buffer for the created block.
diff --git a/repair/dir2.c b/repair/dir2.c
index 61912d1..10c693e 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -921,8 +921,8 @@ _("bad bestfree table in block %u in directory inode %" PRIu64 ": "),
 			da_bno, ino);
 		if (!no_modify) {
 			do_warn(_("repairing table\n"));
-			libxfs_dir2_data_freescan(mp->m_dir_geo, M_DIROPS(mp),
-						  d, &i);
+			libxfs_dir2_data_freescan_hdr(mp->m_dir_geo,
+					M_DIROPS(mp), d, &i);
 			*dirty = 1;
 		} else {
 			do_warn(_("would repair table\n"));
diff --git a/repair/phase6.c b/repair/phase6.c
index 06eed16..1411d2e 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1883,7 +1883,8 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 	}
 	*num_illegal += nbad;
 	if (needscan)
-		libxfs_dir2_data_freescan(mp->m_dir_geo, M_DIROPS(mp), d, &i);
+		libxfs_dir2_data_freescan_hdr(mp->m_dir_geo, M_DIROPS(mp),
+				d, &i);
 	if (needlog)
 		libxfs_dir2_data_log_header(&da, bp);
 	libxfs_defer_finish(&tp, &dfops, ip);

