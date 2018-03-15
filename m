Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752734AbeCOU1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 16:27:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2FKQwht133240
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:15 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2gqyve002j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:15 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2FKREL2011586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:14 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2FKRDau024226
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:14 GMT
Subject: [PATCH 08/20] xfs: implement the metadata repair ioctl flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Mar 2018 13:27:12 -0700
Message-ID: <152114563259.22742.3424176118811554983.stgit@magnolia>
In-Reply-To: <152114558216.22742.6635423816559130061.stgit@magnolia>
References: <152114558216.22742.6635423816559130061.stgit@magnolia>
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
 fs/xfs/Kconfig               |   17 +++++++
 fs/xfs/Makefile              |    7 +++
 fs/xfs/libxfs/xfs_errortag.h |    4 +-
 fs/xfs/scrub/repair.c        |   66 +++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |   50 +++++++++++++++++++++
 fs/xfs/scrub/scrub.c         |  102 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/scrub.h         |    7 +++
 fs/xfs/xfs_error.c           |    3 +
 8 files changed, 249 insertions(+), 7 deletions(-)
 create mode 100644 fs/xfs/scrub/repair.c
 create mode 100644 fs/xfs/scrub/repair.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 46bcf0e6..45566a1 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -85,6 +85,23 @@ config XFS_ONLINE_SCRUB
 
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
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b03c77e..9175d51 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -169,4 +169,11 @@ xfs-y				+= $(addprefix scrub/, \
 
 xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
 xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
+
+# online repair
+ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
+xfs-y				+= $(addprefix scrub/, \
+				   repair.o \
+				   )
+endif
 endif
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index bc1789d..d47b916 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -65,7 +65,8 @@
 #define XFS_ERRTAG_LOG_BAD_CRC				29
 #define XFS_ERRTAG_LOG_ITEM_PIN				30
 #define XFS_ERRTAG_BUF_LRU_REF				31
-#define XFS_ERRTAG_MAX					32
+#define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
+#define XFS_ERRTAG_MAX					33
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -102,5 +103,6 @@
 #define XFS_RANDOM_LOG_BAD_CRC				1
 #define XFS_RANDOM_LOG_ITEM_PIN				1
 #define XFS_RANDOM_BUF_LRU_REF				2
+#define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
new file mode 100644
index 0000000..f6752e9
--- /dev/null
+++ b/fs/xfs/scrub/repair.c
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
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
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_extent_busy.h"
+#include "xfs_ag_resv.h"
+#include "xfs_trans_space.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * Repair probe -- userspace uses this to probe if we're willing to repair a
+ * given mountpoint.
+ */
+int
+xfs_repair_probe(
+	struct xfs_scrub_context	*sc,
+	uint32_t			scrub_oflags)
+{
+	int				error = 0;
+
+	if (xfs_scrub_should_terminate(sc, &error))
+		return error;
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
new file mode 100644
index 0000000..b9f2c0e
--- /dev/null
+++ b/fs/xfs/scrub/repair.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
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
+#ifndef __XFS_SCRUB_REPAIR_H__
+#define __XFS_SCRUB_REPAIR_H__
+
+#if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
+
+/* Online repair only works for v5 filesystems. */
+static inline bool xfs_repair_can_fix(struct xfs_mount *mp)
+{
+	return xfs_sb_version_hascrc(&mp->m_sb);
+}
+
+/* Did userspace want us to repair /and/ we found something to fix? */
+static inline bool xfs_repair_should_fix(struct xfs_scrub_metadata *sm)
+{
+	return (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+	       (sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				XFS_SCRUB_OFLAG_XCORRUPT |
+				XFS_SCRUB_OFLAG_PREEN));
+}
+
+int xfs_repair_probe(struct xfs_scrub_context *sc, uint32_t scrub_oflags);
+
+#else
+
+# define xfs_repair_can_fix(mp)		(false)
+# define xfs_repair_should_fix(sm)	(false)
+# define xfs_repair_probe		(NULL)
+
+#endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
+
+#endif	/* __XFS_SCRUB_REPAIR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 26c7596..64003dc 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -42,11 +42,16 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/btree.h"
+#include "scrub/repair.h"
 
 /*
  * Online Scrub and Repair
@@ -120,6 +125,24 @@
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
@@ -155,7 +178,10 @@ xfs_scrub_teardown(
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
@@ -180,6 +206,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_NONE,
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_probe,
+		.repair = xfs_repair_probe,
 	},
 	[XFS_SCRUB_TYPE_SB] = {		/* superblock */
 		.type	= ST_PERAG,
@@ -379,9 +406,17 @@ xfs_scrub_validate_inputs(
 	if (!xfs_sb_version_hasextflgbit(&mp->m_sb))
 		goto out;
 
-	/* We don't know how to repair anything yet. */
-	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
-		goto out;
+	/* Can we repair it? */
+	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+		/* Only allow repair for metadata we know how to fix. */
+		error = -EOPNOTSUPP;
+		if (!xfs_repair_can_fix(mp) || ops->repair == NULL)
+			goto out;
+
+		error = -EROFS;
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
+			goto out;
+	}
 
 	error = 0;
 out:
@@ -396,7 +431,11 @@ xfs_scrub_metadata(
 {
 	struct xfs_scrub_context	sc;
 	struct xfs_mount		*mp = ip->i_mount;
+	char				*errstr;
 	bool				try_harder = false;
+	bool				already_fixed = false;
+	bool				was_corrupt = false;
+	uint32_t			scrub_oflags;
 	int				error = 0;
 
 	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
@@ -446,9 +485,60 @@ xfs_scrub_metadata(
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
+	if (!already_fixed && xfs_repair_should_fix(sc.sm)) {
+		xfs_scrub_ag_btcur_free(&sc.sa);
+
+		/*
+		 * Repair whatever's broken.  We have to clear the out
+		 * flags because some of our iterator functions abort if
+		 * any of the corruption flags are set.
+		 */
+		trace_xfs_repair_attempt(ip, sc.sm, error);
+		scrub_oflags = sc.sm->sm_flags & XFS_SCRUB_FLAGS_OUT;
+		sc.sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+		error = sc.ops->repair(&sc, scrub_oflags);
+		trace_xfs_repair_done(ip, sc.sm, error);
+		if (!try_harder && error == -EDEADLOCK) {
+			error = xfs_scrub_teardown(&sc, ip, 0);
+			if (error)
+				goto out;
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
+			goto out;
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
index 0d92af8..9c3d345 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -38,6 +38,13 @@ struct xfs_scrub_meta_ops {
 	/* Examine metadata for errors. */
 	int		(*scrub)(struct xfs_scrub_context *);
 
+	/*
+	 * Repair the metadata.  The outflags are cleared from the scrub
+	 * context (so that the iterator functions will not abort early) and
+	 * passed in as the second argument.
+	 */
+	int		(*repair)(struct xfs_scrub_context *, uint32_t);
+
 	/* Decide if we even have this piece of metadata. */
 	bool		(*has)(struct xfs_sb *);
 
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index a63f508..7975634 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -61,6 +61,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_LOG_BAD_CRC,
 	XFS_RANDOM_LOG_ITEM_PIN,
 	XFS_RANDOM_BUF_LRU_REF,
+	XFS_RANDOM_FORCE_SCRUB_REPAIR,
 };
 
 struct xfs_errortag_attr {
@@ -167,6 +168,7 @@ XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
 XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
 XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
 XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
+XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -201,6 +203,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
 	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
 	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
+	XFS_ERRORTAG_ATTR_LIST(force_repair),
 	NULL,
 };
 

