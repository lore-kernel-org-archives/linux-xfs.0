Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58328 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCmX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:42:23 -0400
Subject: [PATCH 02/24] xfs: implement the metadata repair ioctl flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:42:02 -0700
Message-ID: <152401932256.12079.4955969902069178226.stgit@magnolia>
In-Reply-To: <152401930978.12079.2000682561964128780.stgit@magnolia>
References: <152401930978.12079.2000682561964128780.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb in the pieces necessary to make the "scrub" subfunction of
the scrub ioctl actually work.  This means that we make the IFLAG_REPAIR
flag to the scrub ioctl actually do something, and we add an errortag
knob so that xfstests can force the kernel to rebuild a metadata
structure even if there's nothing wrong with it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Kconfig               |   18 ++++++
 fs/xfs/Makefile              |    7 ++
 fs/xfs/libxfs/xfs_errortag.h |    4 +
 fs/xfs/libxfs/xfs_fs.h       |    9 +++
 fs/xfs/scrub/repair.c        |  130 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |   56 ++++++++++++++++++
 fs/xfs/scrub/scrub.c         |  118 ++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/scrub.h         |    3 +
 fs/xfs/xfs_error.c           |    3 +
 9 files changed, 340 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/repair.c
 create mode 100644 fs/xfs/scrub/repair.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 46bcf0e6..457ac9f 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -85,6 +85,24 @@ config XFS_ONLINE_SCRUB
 
 	  If unsure, say N.
 
+config XFS_ONLINE_REPAIR
+	bool "XFS online metadata repair support"
+	default n
+	depends on XFS_FS && XFS_ONLINE_SCRUB
+	help
+	  If you say Y here you will be able to repair metadata on a
+	  mounted XFS filesystem.  This feature is intended to reduce
+	  filesystem downtime by fixing minor problems before they cause the
+	  filesystem to go down.  However, it requires that the filesystem be
+	  formatted with secondary metadata, such as reverse mappings and inode
+	  parent pointers.
+
+	  This feature is considered EXPERIMENTAL.  Use with caution!
+
+	  See the xfs_scrub man page in section 8 for additional information.
+
+	  If unsure, say N.
+
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
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index faf1a4e..dddc75e 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -542,13 +542,20 @@ struct xfs_scrub_metadata {
 /* o: Metadata object looked funny but isn't corrupt. */
 #define XFS_SCRUB_OFLAG_WARNING		(1 << 6)
 
+/*
+ * o: IFLAG_REPAIR was set but metadata object did not need fixing or
+ *    optimization and has therefore not been altered.
+ */
+#define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1 << 7)
+
 #define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
 #define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_OFLAG_CORRUPT | \
 				 XFS_SCRUB_OFLAG_PREEN | \
 				 XFS_SCRUB_OFLAG_XFAIL | \
 				 XFS_SCRUB_OFLAG_XCORRUPT | \
 				 XFS_SCRUB_OFLAG_INCOMPLETE | \
-				 XFS_SCRUB_OFLAG_WARNING)
+				 XFS_SCRUB_OFLAG_WARNING | \
+				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
 /*
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
new file mode 100644
index 0000000..be30825
--- /dev/null
+++ b/fs/xfs/scrub/repair.c
@@ -0,0 +1,130 @@
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
+ * Attempt to repair some metadata, if the metadata is corrupt and userspace
+ * told us to fix it.  This function returns -EAGAIN to mean "re-run scrub",
+ * and will set *fixed to true if it thinks it repaired anything.
+ */
+int
+xfs_repair_attempt(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_context	*sc,
+	bool				*fixed)
+{
+	int				error = 0;
+
+	trace_xfs_repair_attempt(ip, sc->sm, error);
+
+	xfs_scrub_ag_btcur_free(&sc->sa);
+
+	/* Repair whatever's broken. */
+	ASSERT(sc->ops->repair);
+	error = sc->ops->repair(sc);
+	trace_xfs_repair_done(ip, sc->sm, error);
+	switch (error) {
+	case 0:
+		/*
+		 * Repair succeeded.  Commit the fixes and perform a second
+		 * scrub so that we can tell userspace if we fixed the problem.
+		 */
+		sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+		*fixed = true;
+		return -EAGAIN;
+	case -EDEADLOCK:
+	case -EAGAIN:
+		/* Tell the caller to try again having grabbed all the locks. */
+		if (!sc->try_harder) {
+			sc->try_harder = true;
+			return -EAGAIN;
+		}
+		/*
+		 * We tried harder but still couldn't grab all the resources
+		 * we needed to fix it.  The corruption has not been fixed,
+		 * so report back to userspace.
+		 */
+		return -EFSCORRUPTED;
+	default:
+		return error;
+	}
+}
+
+/*
+ * Complain about unfixable problems in the filesystem.  We don't log
+ * corruptions when IFLAG_REPAIR wasn't set on the assumption that the driver
+ * program is xfs_scrub, which will call back with IFLAG_REPAIR set if the
+ * administrator isn't running xfs_scrub in no-repairs mode.
+ *
+ * Use this helper function because _ratelimited silently declares a static
+ * structure to track rate limiting information.
+ */
+void
+xfs_repair_failure(
+	struct xfs_mount		*mp)
+{
+	xfs_alert_ratelimited(mp,
+"Corruption not fixed during online repair.  Unmount and run xfs_repair.");
+}
+
+/*
+ * Repair probe -- userspace uses this to probe if we're willing to repair a
+ * given mountpoint.
+ */
+int
+xfs_repair_probe(
+	struct xfs_scrub_context	*sc)
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
index 0000000..83170dd
--- /dev/null
+++ b/fs/xfs/scrub/repair.h
@@ -0,0 +1,56 @@
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
+static inline int xfs_repair_notsupported(struct xfs_scrub_context *sc)
+{
+	return -EOPNOTSUPP;
+}
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+
+/* Repair helpers */
+
+int xfs_repair_attempt(struct xfs_inode *ip, struct xfs_scrub_context *sc,
+		bool *fixed);
+void xfs_repair_failure(struct xfs_mount *mp);
+
+/* Metadata repairers */
+
+int xfs_repair_probe(struct xfs_scrub_context *sc);
+
+#else
+
+static inline int xfs_repair_attempt(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_context	*sc,
+	bool				*fixed)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void xfs_repair_failure(struct xfs_mount *mp) {}
+
+#define xfs_repair_probe		xfs_repair_notsupported
+
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif	/* __XFS_SCRUB_REPAIR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index c43ee9e..0bfc4e7d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -44,11 +44,16 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
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
@@ -122,6 +127,24 @@
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
@@ -157,7 +180,10 @@ xfs_scrub_teardown(
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
@@ -184,126 +210,150 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_NONE,
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_probe,
+		.repair = xfs_repair_probe,
 	},
 	[XFS_SCRUB_TYPE_SB] = {		/* superblock */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_superblock,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_AGF] = {	/* agf */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_agf,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_AGFL]= {	/* agfl */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_agfl,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_AGI] = {	/* agi */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_agi,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_ag_allocbt,
 		.scrub	= xfs_scrub_bnobt,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_ag_allocbt,
 		.scrub	= xfs_scrub_cntbt,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_ag_iallocbt,
 		.scrub	= xfs_scrub_inobt,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_ag_iallocbt,
 		.scrub	= xfs_scrub_finobt,
 		.has	= xfs_sb_version_hasfinobt,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_ag_rmapbt,
 		.scrub	= xfs_scrub_rmapbt,
 		.has	= xfs_sb_version_hasrmapbt,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_ag_refcountbt,
 		.scrub	= xfs_scrub_refcountbt,
 		.has	= xfs_sb_version_hasreflink,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_inode,
 		.scrub	= xfs_scrub_inode,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_BMBTD] = {	/* inode data fork */
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_inode_bmap,
 		.scrub	= xfs_scrub_bmap_data,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_BMBTA] = {	/* inode attr fork */
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_inode_bmap,
 		.scrub	= xfs_scrub_bmap_attr,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_BMBTC] = {	/* inode CoW fork */
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_inode_bmap,
 		.scrub	= xfs_scrub_bmap_cow,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_DIR] = {	/* directory */
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_directory,
 		.scrub	= xfs_scrub_directory,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_XATTR] = {	/* extended attributes */
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_xattr,
 		.scrub	= xfs_scrub_xattr,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_symlink,
 		.scrub	= xfs_scrub_symlink,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_PARENT] = {	/* parent pointers */
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_parent,
 		.scrub	= xfs_scrub_parent,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
 		.type	= ST_FS,
 		.setup	= xfs_scrub_setup_rt,
 		.scrub	= xfs_scrub_rtbitmap,
 		.has	= xfs_sb_version_hasrealtime,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,
 		.setup	= xfs_scrub_setup_rt,
 		.scrub	= xfs_scrub_rtsummary,
 		.has	= xfs_sb_version_hasrealtime,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
 		.type	= ST_FS,
 		.setup	= xfs_scrub_setup_quota,
 		.scrub	= xfs_scrub_quota,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_GQUOTA] = {	/* group quota */
 		.type	= ST_FS,
 		.setup	= xfs_scrub_setup_quota,
 		.scrub	= xfs_scrub_quota,
+		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_PQUOTA] = {	/* project quota */
 		.type	= ST_FS,
 		.setup	= xfs_scrub_setup_quota,
 		.scrub	= xfs_scrub_quota,
+		.repair	= xfs_repair_notsupported,
 	},
 };
 
@@ -383,9 +433,21 @@ xfs_scrub_validate_inputs(
 	if (!xfs_sb_version_hasextflgbit(&mp->m_sb))
 		goto out;
 
-	/* We don't know how to repair anything yet. */
-	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
-		goto out;
+	/*
+	 * We only want to repair read-write v5+ filesystems.  Defer the check
+	 * for ops->repair until after our scrub confirms that we need to
+	 * perform repairs so that we avoid failing due to not supporting
+	 * repairing an object that doesn't need repairs.
+	 */
+	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+		error = -EOPNOTSUPP;
+		if (!xfs_sb_version_hascrc(&mp->m_sb))
+			goto out;
+
+		error = -EROFS;
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
+			goto out;
+	}
 
 	error = 0;
 out:
@@ -401,6 +463,7 @@ xfs_scrub_metadata(
 	struct xfs_scrub_context	sc;
 	struct xfs_mount		*mp = ip->i_mount;
 	bool				try_harder = false;
+	bool				already_fixed = false;
 	int				error = 0;
 
 	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
@@ -450,8 +513,51 @@ xfs_scrub_metadata(
 	} else if (error)
 		goto out_teardown;
 
-	if (xfs_scrub_found_corruption(sc.sm))
-		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
+	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) && !already_fixed) {
+		bool needs_fix;
+
+		/* Let debug users force us into the repair routines. */
+		if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
+			sc.sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+
+		needs_fix = (sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+						XFS_SCRUB_OFLAG_XCORRUPT |
+						XFS_SCRUB_OFLAG_PREEN));
+		/*
+		 * If userspace asked for a repair but it wasn't necessary,
+		 * report that back to userspace.
+		 */
+		if (!needs_fix) {
+			sc.sm->sm_flags |= XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED;
+			goto out_nofix;
+		}
+
+		/*
+		 * If it's broken, userspace wants us to fix it, and we haven't
+		 * already tried to fix it, then attempt a repair.
+		 */
+		error = xfs_repair_attempt(ip, &sc, &already_fixed);
+		if (error == -EAGAIN) {
+			if (sc.try_harder)
+				try_harder = true;
+			error = xfs_scrub_teardown(&sc, ip, 0);
+			if (error) {
+				xfs_repair_failure(mp);
+				goto out;
+			}
+			goto retry_op;
+		}
+	}
+
+out_nofix:
+	/*
+	 * Userspace asked us to repair something, we repaired it, rescanned
+	 * it, and the rescan says it's still broken.  Scream about this in
+	 * the system logs.
+	 */
+	if ((sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+	    xfs_scrub_found_corruption(sc.sm))
+		xfs_repair_failure(mp);
 
 out_teardown:
 	error = xfs_scrub_teardown(&sc, ip, error);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 5d79731..2f89a84 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -38,6 +38,9 @@ struct xfs_scrub_meta_ops {
 	/* Examine metadata for errors. */
 	int		(*scrub)(struct xfs_scrub_context *);
 
+	/* Repair or optimize the metadata. */
+	int		(*repair)(struct xfs_scrub_context *);
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
 

