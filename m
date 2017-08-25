Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27325 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933269AbdHYWRr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:17:47 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMHlIL022277
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMHlkb022707
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:47 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7PMHkf5023761
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:47 GMT
Subject: [PATCH 08/19] xfs: implement the metadata repair ioctl flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:17:45 -0700
Message-ID: <150369946542.9957.12755552154555796419.stgit@magnolia>
In-Reply-To: <150369940879.9957.6303798184036268321.stgit@magnolia>
References: <150369940879.9957.6303798184036268321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb in the pieces necessary to make the "scrub" subfunction of
the scrub ioctl actually work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Kconfig       |   17 ++++++++
 fs/xfs/scrub/scrub.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/scrub.h |   10 +++++
 fs/xfs/xfs_error.c   |    3 +
 fs/xfs/xfs_error.h   |    4 +-
 5 files changed, 133 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index f42fcf1..06be67d 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -88,6 +88,23 @@ config XFS_ONLINE_SCRUB
 
 	  If unsure, say N.
 
+config XFS_ONLINE_REPAIR
+	bool "XFS online metadata repair support"
+	default n
+	depends on XFS_FS && XFS_ONLINE_SCRUB
+	help
+	  If you say Y here you will be able to repair metadata on a
+	  mounted XFS filesystem.  This feature is intended to reduce
+	  filesystem downtime even further by fixing minor problems
+	  before they cause the filesystem to go down.  However, it
+	  requires that the filesystem be formatted with secondary
+	  metadata, such as reverse mappings and inode parent pointers.
+
+	  This feature is considered EXPERIMENTAL.  Use with caution!
+
+	  See the xfs_scrub man page in section 8 for additional information.
+
+	  If unsure, say N.
 config XFS_WARN
 	bool "XFS Verbose Warnings"
 	depends on XFS_FS && !XFS_DEBUG
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 5f2c71d..cdc8233 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -42,6 +42,9 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_error.h"
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -121,6 +124,24 @@
  * XCORRUPT flag; btree query function errors are noted by setting the
  * XFAIL flag and deleting the cursor to prevent further attempts to
  * cross-reference with a defective btree.
+ *
+ * If a piece of metadata proves corrupt or suboptimal, the userspace
+ * program can ask the kernel to apply some tender loving care (TLC) to
+ * the metadata object by setting the REPAIR flag and re-calling the
+ * scrub ioctl.  "Corruption" is defined by metadata violating the
+ * on-disk specification; operations cannot continue if the violation is
+ * left untreated.  It is possible for XFS to continue if an object is
+ * "suboptimal", however performance may be degraded.  Repairs are
+ * usually performed by rebuilding the metadata entirely out of
+ * redundant metadata.  Optimizing, on the other hand, can sometimes be
+ * done without rebuilding entire structures.
+ *
+ * Generally speaking, the repair code has the following code structure:
+ * Lock -> scrub -> repair -> commit -> re-lock -> re-scrub -> unlock.
+ * The first check helps us figure out if we need to rebuild or simply
+ * optimize the structure so that the rebuild knows what to do.  The
+ * second check evaluates the completeness of the repair; that is what
+ * is reported to userspace.
  */
 
 /*
@@ -162,7 +183,10 @@ xfs_scrub_teardown(
 {
 	xfs_scrub_ag_free(sc, &sc->sa);
 	if (sc->tp) {
-		xfs_trans_cancel(sc->tp);
+		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
+			error = xfs_trans_commit(sc->tp);
+		else
+			xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
 	}
 	if (sc->ip) {
@@ -184,6 +208,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 	{ /* ioctl presence test */
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_tester,
+		.repair = xfs_scrub_tester,
 	},
 	{ /* superblock */
 		.setup	= xfs_scrub_setup_ag_header,
@@ -295,6 +320,18 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 #endif
 };
 
+#if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
+static inline bool xfs_scrub_can_repair(struct xfs_mount *mp)
+{
+	return xfs_sb_version_hascrc(&mp->m_sb);
+}
+#else
+static inline bool xfs_scrub_can_repair(struct xfs_mount *mp)
+{
+	return false;
+}
+#endif
+
 /* Dispatch metadata scrubbing. */
 int
 xfs_scrub_metadata(
@@ -304,7 +341,10 @@ xfs_scrub_metadata(
 	struct xfs_scrub_context	sc;
 	struct xfs_mount		*mp = ip->i_mount;
 	const struct xfs_scrub_meta_ops	*ops;
+	char				*errstr;
 	bool				try_harder = false;
+	bool				already_fixed = false;
+	bool				was_corrupt = false;
 	int				error = 0;
 
 	trace_xfs_scrub_start(ip, sm, error);
@@ -337,10 +377,17 @@ xfs_scrub_metadata(
 	if (ops->has && !ops->has(&mp->m_sb))
 		goto out;
 
-	/* We don't know how to repair anything yet. */
-	error = -EOPNOTSUPP;
-	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
-		goto out;
+	/* Can we repair it? */
+	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+		/* Only allow repair for metadata we know how to fix. */
+		error = -EOPNOTSUPP;
+		if (!xfs_scrub_can_repair(mp) || ops->repair == NULL)
+			goto out;
+
+		error = -EROFS;
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
+			goto out;
+	}
 
 	/* This isn't a stable feature.  Use with care. */
 	{
@@ -382,9 +429,55 @@ xfs_scrub_metadata(
 	} else if (error)
 		goto out_teardown;
 
+	/* Let debug users force us into the repair routines. */
+	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) && !already_fixed &&
+	    XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
+		sc.sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	}
+	if (!already_fixed)
+		was_corrupt = !!(sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+						    XFS_SCRUB_OFLAG_XCORRUPT));
+
+	if (!already_fixed && xfs_scrub_should_fix(sc.sm)) {
+		xfs_scrub_ag_btcur_free(&sc.sa);
+
+		/* Ok, something's wrong.  Repair it. */
+		trace_xfs_repair_attempt(ip, sc.sm, error);
+		error = sc.ops->repair(&sc);
+		trace_xfs_repair_done(ip, sc.sm, error);
+		if (!try_harder && error == -EDEADLOCK) {
+			error = xfs_scrub_teardown(&sc, ip, 0);
+			if (error)
+				goto out_dec;
+			try_harder = true;
+			goto retry_op;
+		} else if (error)
+			goto out_teardown;
+
+		/*
+		 * Commit the fixes and perform a second dry-run scrub
+		 * so that we can tell userspace if we fixed the problem.
+		 */
+		error = xfs_scrub_teardown(&sc, ip, error);
+		if (error)
+			goto out_dec;
+		sc.sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+		already_fixed = true;
+		goto retry_op;
+	}
+
 	if (sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
-			       XFS_SCRUB_OFLAG_XCORRUPT))
-		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
+			    XFS_SCRUB_OFLAG_XCORRUPT)) {
+		if (sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+			errstr = "Corruption not fixed during online repair.  "
+				 "Unmount and run xfs_repair.";
+		else
+			errstr = "Corruption detected during scrub.";
+		xfs_alert_ratelimited(mp, errstr);
+	} else if (already_fixed && was_corrupt) {
+		xfs_alert_ratelimited(mp, "Corruption repaired during scrub.");
+	}
 
 out_teardown:
 	error = xfs_scrub_teardown(&sc, ip, error);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 3218664..0713eda 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -26,9 +26,19 @@ struct xfs_scrub_meta_ops {
 	int		(*setup)(struct xfs_scrub_context *,
 				 struct xfs_inode *);
 	int		(*scrub)(struct xfs_scrub_context *);
+	int		(*repair)(struct xfs_scrub_context *);
 	bool		(*has)(struct xfs_sb *);
 };
 
+/* Did userspace tell us we can repair /and/ we found something to fix? */
+static inline bool xfs_scrub_should_fix(struct xfs_scrub_metadata *sm)
+{
+	return (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+	       (sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				XFS_SCRUB_OFLAG_XCORRUPT |
+				XFS_SCRUB_OFLAG_PREEN));
+}
+
 /* Buffer pointers and btree cursors for an entire AG. */
 struct xfs_scrub_ag {
 	xfs_agnumber_t			agno;
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 8cebbaa..5ff86c4 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -57,6 +57,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_AG_RESV_CRITICAL,
 	XFS_RANDOM_DROP_WRITES,
 	XFS_RANDOM_LOG_BAD_CRC,
+	XFS_RANDOM_FORCE_SCRUB_REPAIR,
 };
 
 struct xfs_errortag_attr {
@@ -161,6 +162,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_finish_one,	XFS_ERRTAG_BMAP_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
 XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
 XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
+XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -193,6 +195,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_critical),
 	XFS_ERRORTAG_ATTR_LIST(drop_writes),
 	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
+	XFS_ERRORTAG_ATTR_LIST(force_repair),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 7577be5..6ee23eb 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -106,7 +106,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
  */
 #define XFS_ERRTAG_DROP_WRITES				28
 #define XFS_ERRTAG_LOG_BAD_CRC				29
-#define XFS_ERRTAG_MAX					30
+#define XFS_ERRTAG_FORCE_SCRUB_REPAIR			30
+#define XFS_ERRTAG_MAX					31
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -141,6 +142,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_AG_RESV_CRITICAL			4
 #define XFS_RANDOM_DROP_WRITES				1
 #define XFS_RANDOM_LOG_BAD_CRC				1
+#define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 
 #ifdef DEBUG
 extern int xfs_errortag_init(struct xfs_mount *mp);

