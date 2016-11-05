Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18175 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753593AbcKEAWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:22:45 -0400
Subject: [PATCH 33/41] xfs: implement the metadata repair ioctl flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:22:33 -0700
Message-ID: <147830535378.2155.7081955300807768072.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Plumb in the pieces necessary to make the "repair" subfunction of
the scrub ioctl actually work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.h |    4 ++
 fs/xfs/xfs_scrub.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 93 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 05f8666..4c22d9a 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -96,7 +96,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
 #define XFS_ERRTAG_BMAP_FINISH_ONE			26
 #define XFS_ERRTAG_AG_RESV_CRITICAL			27
-#define XFS_ERRTAG_MAX					28
+#define XFS_ERRTAG_FORCE_SCRUB_REPAIR			28
+#define XFS_ERRTAG_MAX					29
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -129,6 +130,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_REFCOUNT_FINISH_ONE			1
 #define XFS_RANDOM_BMAP_FINISH_ONE			1
 #define XFS_RANDOM_AG_RESV_CRITICAL			4
+#define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 
 #ifdef DEBUG
 extern int xfs_error_test_active;
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index ca1bc8b..7e03c54 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -54,6 +54,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_attr.h"
 #include "xfs_symlink.h"
+#include "xfs_error.h"
 
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
@@ -121,6 +122,23 @@
  * the metadata is correct but otherwise suboptimal, there's a "preen"
  * flag to signal that.  Finally, if we were unable to access a data
  * structure to perform cross-referencing, we can signal that as well.
+ *
+ * If a piece of metadata proves corrupt or suboptimal, the userspace
+ * program can ask the kernel to apply some tender loving care (TLC) to
+ * the metadata object.  "Corruption" is defined by metadata violating
+ * the on-disk specification; operations cannot continue if the
+ * violation is left untreated.  It is possible for XFS to continue if
+ * an object is "suboptimal", however performance may be degraded.
+ * Repairs are usually performed by rebuilding the metadata entirely out
+ * of redundant metadata.  Optimizing, on the other hand, can sometimes
+ * be done without rebuilding entire structures.
+ *
+ * Generally speaking, the repair code has the following code structure:
+ * Lock -> scrub -> repair -> commit -> re-lock -> re-scrub -> unlock.
+ * The first check helps us figure out if we need to rebuild or simply
+ * optimize the structure so that the rebuild knows what to do.  The
+ * second check evaluates the completeness of the repair; that is what
+ * is reported to userspace.
  */
 
 /* Buffer pointers and btree cursors for an entire AG. */
@@ -171,6 +189,24 @@ struct xfs_scrub_context {
 	struct xfs_scrub_ag		sa;
 };
 
+/* Fix something if errors were detected and the user asked for repair. */
+static inline bool
+xfs_scrub_should_fix(
+	struct xfs_scrub_metadata	*sm)
+{
+	return (sm->sm_flags & XFS_SCRUB_FLAG_REPAIR) &&
+	       (sm->sm_flags & (XFS_SCRUB_FLAG_CORRUPT | XFS_SCRUB_FLAG_PREEN));
+}
+
+/* Clear the corruption status flags. */
+static inline bool
+xfs_scrub_reset_corruption_flags(
+	struct xfs_scrub_metadata	*sm)
+{
+	return sm->sm_flags &= ~(XFS_SCRUB_FLAG_CORRUPT | XFS_SCRUB_FLAG_PREEN |
+			      XFS_SCRUB_FLAG_XREF_FAIL);
+}
+
 /*
  * Grab a transaction.  If we're going to repair something, we need to
  * ensure there's enough reservation to make all the changes.  If not,
@@ -186,6 +222,9 @@ xfs_scrub_trans_alloc(
 	uint				flags,
 	struct xfs_trans		**tpp)
 {
+	if (sm->sm_flags & XFS_SCRUB_FLAG_REPAIR)
+		return xfs_trans_alloc(mp, resp, blocks, rtextents, flags, tpp);
+
 	return xfs_trans_alloc_empty(mp, tpp);
 }
 
@@ -1472,7 +1511,10 @@ xfs_scrub_teardown(
 	if (sc->ag_lock.agmask != sc->ag_lock.__agmask)
 		kmem_free(sc->ag_lock.agmask);
 	sc->ag_lock.agmask = NULL;
-	xfs_trans_cancel(sc->tp);
+	if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_FLAG_REPAIR))
+		error = xfs_trans_commit(sc->tp);
+	else
+		xfs_trans_cancel(sc->tp);
 	sc->tp = NULL;
 	if (sc->ip != NULL) {
 		xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
@@ -4673,6 +4715,7 @@ xfs_scrub_metadata(
 	struct xfs_mount		*mp = ip->i_mount;
 	const struct xfs_scrub_meta_fns	*fns;
 	bool				deadlocked = false;
+	bool				already_fixed = false;
 	int				error = 0;
 
 	trace_xfs_scrub(ip, sm->sm_type, sm->sm_agno, sm->sm_ino, sm->sm_gen,
@@ -4686,12 +4729,18 @@ xfs_scrub_metadata(
 	sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
 	if (sm->sm_flags & ~XFS_SCRUB_FLAGS_IN)
 		goto out;
-	if (sm->sm_flags & XFS_SCRUB_FLAG_REPAIR)
-		goto out;
 	error = -ENOTTY;
 	if (sm->sm_type > XFS_SCRUB_TYPE_MAX)
 		goto out;
 	fns = &meta_scrub_fns[sm->sm_type];
+	if ((sm->sm_flags & XFS_SCRUB_FLAG_REPAIR) &&
+	    (fns->repair == NULL || !xfs_sb_version_hascrc(&mp->m_sb)))
+		goto out;
+
+	error = -EROFS;
+	if ((sm->sm_flags & XFS_SCRUB_FLAG_REPAIR) &&
+	    (mp->m_flags & XFS_MOUNT_RDONLY))
+		goto out;
 
 	/* Do we even have this type of metadata? */
 	error = -ENOENT;
@@ -4731,8 +4780,44 @@ xfs_scrub_metadata(
 	} else if (error)
 		goto out_teardown;
 
-	if (sm->sm_flags & XFS_SCRUB_FLAG_CORRUPT)
-		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
+	/* Let debug users force us into the repair routines. */
+	if ((sm->sm_flags & XFS_SCRUB_FLAG_REPAIR) && !already_fixed &&
+	    XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_FORCE_SCRUB_REPAIR,
+			XFS_RANDOM_FORCE_SCRUB_REPAIR)) {
+		sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	}
+
+	if (!already_fixed && xfs_scrub_should_fix(sm)) {
+		xfs_scrub_ag_btcur_free(&sc.sa);
+
+		/* Ok, something's wrong.  Repair it. */
+		error = fns->repair(&sc);
+		if (error)
+			goto out_teardown;
+
+		/*
+		 * Commit the fixes and perform a second dry-run scrub
+		 * so that we can tell userspace if we fixed the problem.
+		 */
+		error = xfs_scrub_teardown(&sc, ip, error);
+		if (error)
+			goto out_teardown;
+		xfs_scrub_reset_corruption_flags(sm);
+		already_fixed = true;
+		goto retry_op;
+	}
+
+	if (sm->sm_flags & XFS_SCRUB_FLAG_CORRUPT) {
+		char	*errstr;
+
+		if (sm->sm_flags & XFS_SCRUB_FLAG_REPAIR)
+			errstr = "Corruption not fixed during online repair.  "
+				 "Unmount and run xfs_repair.";
+		else
+			errstr = "Corruption detected during scrub.";
+		xfs_alert_ratelimited(mp, errstr);
+	}
 
 out_teardown:
 	error = xfs_scrub_teardown(&sc, ip, error);

