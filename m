Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 493497CA1
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 06:15:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 084F68F804C
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SCGhZkQ3baJ2wR9z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:40 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 68F026438E
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:15:39 +0000 (UTC)
Received: from localhost.localdomain (vpn1-7-36.ams2.redhat.com [10.36.7.36])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u2OBFbL7009274
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 07:15:38 -0400
From: jtulak@redhat.com
Subject: [PATCH 01/19] xfsprogs: use common code for multi-disk detection
Date: Thu, 24 Mar 2016 12:15:18 +0100
Message-Id: <1458818136-56043-2-git-send-email-jtulak@redhat.com>
In-Reply-To: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

CHANGELOG:
o Remove nonexistent headers from LIBHFILES in include/Makefile
o Remove a useless assignment which was immediately overwritten
  on the next line.
o Rename include/xfs_mkfs.h global header to include/xfs_multidisk.h,
  because we need it just for multidisk configuration
o Fix AG count for size thresholds to keep consistency

Both xfs_repair and mkfs.xfs need to agree on what is a "multidisk:
configuration - mkfs for determining the AG count of the filesystem,
repair for determining how to automatically parallelise it's
execution. This requires a bunch of common defines that both mkfs
and reapir need to share.

In fact, most of the defines in xfs_mkfs.h could be shared with
other programs (i.e. all the defaults mkfs uses) and so it is
simplest to move xfs_mkfs.h to the shared include directory and add
the new defines to it directly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/Makefile        |  5 ++-
 include/xfs_multidisk.h | 98 +++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/Makefile           |  2 +-
 mkfs/maxtrres.c         |  2 +-
 mkfs/proto.c            |  2 +-
 mkfs/xfs_mkfs.c         | 56 ++++++++++++++--------------
 mkfs/xfs_mkfs.h         | 89 --------------------------------------------
 repair/xfs_repair.c     | 44 +++++++++++++++++++++-
 8 files changed, 176 insertions(+), 122 deletions(-)
 create mode 100644 include/xfs_multidisk.h
 delete mode 100644 mkfs/xfs_mkfs.h

diff --git a/include/Makefile b/include/Makefile
index 6148756..5fb443a 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -33,13 +33,16 @@ LIBHFILES = libxfs.h \
 	xfs_log_recover.h \
 	xfs_metadump.h \
 	xfs_mount.h \
+	xfs_quota_defs.h \
+	xfs_sb.h \
+	xfs_shared.h \
 	xfs_trace.h \
 	xfs_trans.h \
 	command.h \
 	input.h \
 	path.h \
 	project.h \
-	platform_defs.h \
+	platform_defs.h
 
 HFILES = handle.h \
 	jdm.h \
diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
new file mode 100644
index 0000000..4006a01
--- /dev/null
+++ b/include/xfs_multidisk.h
@@ -0,0 +1,98 @@
+/*
+ * Copyright (c) 2000-2001,2004-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_MULTIDISK_H__
+#define	__XFS_MULTIDISK_H__
+
+#define XFS_DFL_SB_VERSION_BITS \
+                (XFS_SB_VERSION_NLINKBIT | \
+                 XFS_SB_VERSION_EXTFLGBIT | \
+                 XFS_SB_VERSION_DIRV2BIT)
+
+#define XFS_SB_VERSION_MKFS(crc,ia,dia,log2,attr1,sflag,ci,more) (\
+	((crc)||(ia)||(dia)||(log2)||(attr1)||(sflag)||(ci)||(more)) ? \
+	(((crc) ? XFS_SB_VERSION_5 : XFS_SB_VERSION_4) |		\
+		((ia) ? XFS_SB_VERSION_ALIGNBIT : 0) |			\
+		((dia) ? XFS_SB_VERSION_DALIGNBIT : 0) |		\
+		((log2) ? XFS_SB_VERSION_LOGV2BIT : 0) |		\
+		((attr1) ? XFS_SB_VERSION_ATTRBIT : 0) |		\
+		((sflag) ? XFS_SB_VERSION_SECTORBIT : 0) |		\
+		((ci) ? XFS_SB_VERSION_BORGBIT : 0) |			\
+		((more) ? XFS_SB_VERSION_MOREBITSBIT : 0) |		\
+	        XFS_DFL_SB_VERSION_BITS |                               \
+	0 ) : XFS_SB_VERSION_1 )
+
+#define XFS_SB_VERSION2_MKFS(crc, lazycount, attr2, projid32bit, parent, \
+			     ftype) (\
+	((lazycount) ? XFS_SB_VERSION2_LAZYSBCOUNTBIT : 0) |		\
+	((attr2) ? XFS_SB_VERSION2_ATTR2BIT : 0) |			\
+	((projid32bit) ? XFS_SB_VERSION2_PROJID32BIT : 0) |		\
+	((parent) ? XFS_SB_VERSION2_PARENTBIT : 0) |			\
+	((crc) ? XFS_SB_VERSION2_CRCBIT : 0) |				\
+	((ftype) ? XFS_SB_VERSION2_FTYPE : 0) |				\
+	0 )
+
+#define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */
+#define	XFS_DINODE_DFL_LOG	8		/* 256 byte inodes */
+#define	XFS_DINODE_DFL_CRC_LOG	9		/* 512 byte inodes for CRCs */
+#define	XFS_MIN_DATA_BLOCKS	100
+#define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
+#define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
+#define	XFS_IFLAG_ALIGN		1		/* -i align defaults on */
+#define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
+#define	XFS_DFL_DIR_VERSION	2		/* default directory version */
+#define	XFS_DFL_LOG_SIZE	1000		/* default log size, blocks */
+#define	XFS_DFL_LOG_FACTOR	5		/* default log size, factor */
+						/* with max trans reservation */
+#define XFS_MAX_INODE_SIG_BITS	32		/* most significant bits in an
+						 * inode number that we'll
+						 * accept w/o warnings
+						 */
+
+#define XFS_AG_BYTES(bblog)	((long long)BBSIZE << (bblog))
+#define	XFS_AG_MIN_BYTES	((XFS_AG_BYTES(15)))	/* 16 MB */
+#define XFS_AG_MIN_BLOCKS(blog)	((XFS_AG_BYTES(15)) >> (blog))
+#define XFS_AG_MAX_BLOCKS(blog)	((XFS_AG_BYTES(31) - 1) >> (blog))
+
+#define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
+
+/*
+ * These values define what we consider a "multi-disk" filesystem. That is, a
+ * filesystem that is likely to be made up of multiple devices, and hence have
+ * some level of parallelism avoid to it at the IO level.
+ */
+#define XFS_MULTIDISK_AGLOG		5	/* 32 AGs */
+#define XFS_NOMULTIDISK_AGLOG		2	/* 4 AGs */
+#define XFS_MULTIDISK_AGCOUNT		(1 << XFS_MULTIDISK_AGLOG)
+
+
+/* xfs_mkfs.c */
+extern int isdigits (char *str);
+extern long long cvtnum (unsigned int blocksize,
+			 unsigned int sectorsize, char *s);
+
+/* proto.c */
+extern char *setup_proto (char *fname);
+extern void parse_proto (xfs_mount_t *mp, struct fsxattr *fsx, char **pp);
+extern void res_failed (int err);
+
+/* maxtrres.c */
+extern int max_trans_res (int crcs_enabled, int dirversion,
+		int sectorlog, int blocklog, int inodelog, int dirblocklog,
+		int logversion, int log_sunit, int finobt);
+
+#endif	/* __XFS_MULTIDISK_H__ */
diff --git a/mkfs/Makefile b/mkfs/Makefile
index 570ab07..63ba4ec 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = mkfs.xfs
 
-HFILES = xfs_mkfs.h
+HFILES =
 CFILES = maxtrres.c proto.c xfs_mkfs.c
 
 LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index b97d020..f48a0f7 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -25,7 +25,7 @@
  */
 
 #include "libxfs.h"
-#include "xfs_mkfs.h"
+#include "xfs_multidisk.h"
 
 int
 max_trans_res(
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 21960d5..50d5e94 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -18,7 +18,7 @@
 
 #include "libxfs.h"
 #include <sys/stat.h>
-#include "xfs_mkfs.h"
+#include "xfs_multidisk.h"
 
 /*
  * Prototypes for internal functions.
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4c3a802..36e5b4f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -21,7 +21,7 @@
 #ifdef ENABLE_BLKID
 #  include <blkid/blkid.h>
 #endif /* ENABLE_BLKID */
-#include "xfs_mkfs.h"
+#include "xfs_multidisk.h"
 
 /*
  * Device topology information.
@@ -664,43 +664,45 @@ calc_default_ag_geometry(
 	}
 
 	/*
-	 * For the remainder we choose an AG size based on the
-	 * number of data blocks available, trying to keep the
-	 * number of AGs relatively small (especially compared
-	 * to the original algorithm).  AG count is calculated
-	 * based on the preferred AG size, not vice-versa - the
-	 * count can be increased by growfs, so prefer to use
-	 * smaller counts at mkfs time.
-	 *
-	 * For a single underlying storage device between 128MB
-	 * and 4TB in size, just use 4 AGs, otherwise scale up
-	 * smoothly between min/max AG sizes.
+	 * For a single underlying storage device between 128MB and 4TB in size
+	 * just use 4 AGs and scale up smoothly between min/max AG sizes.
 	 */
-
-	if (!multidisk && dblocks >= MEGABYTES(128, blocklog)) {
+	if (!multidisk) {
 		if (dblocks >= TERABYTES(4, blocklog)) {
 			blocks = XFS_AG_MAX_BLOCKS(blocklog);
 			goto done;
+		} else if (dblocks >= MEGABYTES(128, blocklog)) {
+			shift = XFS_NOMULTIDISK_AGLOG;
+			goto calc_blocks;
 		}
-		shift = 2;
-	} else if (dblocks > GIGABYTES(512, blocklog))
-		shift = 5;
-	else if (dblocks > GIGABYTES(8, blocklog))
-		shift = 4;
-	else if (dblocks >= MEGABYTES(128, blocklog))
-		shift = 3;
-	else if (dblocks >= MEGABYTES(64, blocklog))
-		shift = 2;
-	else if (dblocks >= MEGABYTES(32, blocklog))
-		shift = 1;
-	else
-		shift = 0;
+	}
+
+	/*
+	 * For the multidisk configs we choose an AG count based on the number
+	 * of data blocks available, trying to keep the number of AGs higher
+	 * than the single disk configurations. This makes the assumption that
+	 * larger filesystems have more parallelism available to them.
+	 */
+	shift = XFS_MULTIDISK_AGLOG;
+	if (dblocks <= GIGABYTES(512, blocklog))
+		shift--;
+	if (dblocks <= GIGABYTES(8, blocklog))
+		shift--;
+	if (dblocks < MEGABYTES(128, blocklog))
+		shift--;
+	if (dblocks < MEGABYTES(64, blocklog))
+		shift--;
+	if (dblocks < MEGABYTES(32, blocklog))
+		shift--;
+
 	/*
 	 * If dblocks is not evenly divisible by the number of
 	 * desired AGs, round "blocks" up so we don't lose the
 	 * last bit of the filesystem. The same principle applies
 	 * to the AG count, so we don't lose the last AG!
 	 */
+calc_blocks:
+	ASSERT(shift >= 0 && shift <= XFS_MULTIDISK_AGLOG);
 	blocks = dblocks >> shift;
 	if (dblocks & xfs_mask32lo(shift)) {
 		if (blocks < XFS_AG_MAX_BLOCKS(blocklog))
diff --git a/mkfs/xfs_mkfs.h b/mkfs/xfs_mkfs.h
deleted file mode 100644
index 128068e..0000000
--- a/mkfs/xfs_mkfs.h
+++ /dev/null
@@ -1,89 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2004-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_MKFS_H__
-#define	__XFS_MKFS_H__
-
-#define XFS_DFL_SB_VERSION_BITS \
-                (XFS_SB_VERSION_NLINKBIT | \
-                 XFS_SB_VERSION_EXTFLGBIT | \
-                 XFS_SB_VERSION_DIRV2BIT)
-
-#define XFS_SB_VERSION_MKFS(crc,ia,dia,log2,attr1,sflag,ci,more) (\
-	((crc)||(ia)||(dia)||(log2)||(attr1)||(sflag)||(ci)||(more)) ? \
-	(((crc) ? XFS_SB_VERSION_5 : XFS_SB_VERSION_4) |		\
-		((ia) ? XFS_SB_VERSION_ALIGNBIT : 0) |			\
-		((dia) ? XFS_SB_VERSION_DALIGNBIT : 0) |		\
-		((log2) ? XFS_SB_VERSION_LOGV2BIT : 0) |		\
-		((attr1) ? XFS_SB_VERSION_ATTRBIT : 0) |		\
-		((sflag) ? XFS_SB_VERSION_SECTORBIT : 0) |		\
-		((ci) ? XFS_SB_VERSION_BORGBIT : 0) |			\
-		((more) ? XFS_SB_VERSION_MOREBITSBIT : 0) |		\
-	        XFS_DFL_SB_VERSION_BITS |                               \
-	0 ) : XFS_SB_VERSION_1 )
-
-#define XFS_SB_VERSION2_MKFS(crc, lazycount, attr2, projid32bit, parent, \
-			     ftype) (\
-	((lazycount) ? XFS_SB_VERSION2_LAZYSBCOUNTBIT : 0) |		\
-	((attr2) ? XFS_SB_VERSION2_ATTR2BIT : 0) |			\
-	((projid32bit) ? XFS_SB_VERSION2_PROJID32BIT : 0) |		\
-	((parent) ? XFS_SB_VERSION2_PARENTBIT : 0) |			\
-	((crc) ? XFS_SB_VERSION2_CRCBIT : 0) |				\
-	((ftype) ? XFS_SB_VERSION2_FTYPE : 0) |				\
-	0 )
-
-#define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */
-#define	XFS_DINODE_DFL_LOG	8		/* 256 byte inodes */
-#define	XFS_DINODE_DFL_CRC_LOG	9		/* 512 byte inodes for CRCs */
-#define	XFS_MIN_DATA_BLOCKS	100
-#define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
-#define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
-#define	XFS_IFLAG_ALIGN		1		/* -i align defaults on */
-#define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
-#define	XFS_DFL_DIR_VERSION	2		/* default directory version */
-#define	XFS_DFL_LOG_SIZE	1000		/* default log size, blocks */
-#define	XFS_DFL_LOG_FACTOR	5		/* default log size, factor */
-						/* with max trans reservation */
-#define XFS_MAX_INODE_SIG_BITS	32		/* most significant bits in an
-						 * inode number that we'll
-						 * accept w/o warnings
-						 */
-
-#define XFS_AG_BYTES(bblog)	((long long)BBSIZE << (bblog))
-#define	XFS_AG_MIN_BYTES	((XFS_AG_BYTES(15)))	/* 16 MB */
-#define XFS_AG_MIN_BLOCKS(blog)	((XFS_AG_BYTES(15)) >> (blog))
-#define XFS_AG_MAX_BLOCKS(blog)	((XFS_AG_BYTES(31) - 1) >> (blog))
-
-#define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
-
-
-/* xfs_mkfs.c */
-extern int isdigits (char *str);
-extern long long cvtnum (unsigned int blocksize,
-			 unsigned int sectorsize, char *s);
-
-/* proto.c */
-extern char *setup_proto (char *fname);
-extern void parse_proto (xfs_mount_t *mp, struct fsxattr *fsx, char **pp);
-extern void res_failed (int err);
-
-/* maxtrres.c */
-extern int max_trans_res (int crcs_enabled, int dirversion,
-		int sectorlog, int blocklog, int inodelog, int dirblocklog,
-		int logversion, int log_sunit, int finobt);
-
-#endif	/* __XFS_MKFS_H__ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 5d5f3aa..9d91f2d 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -19,6 +19,7 @@
 #include "libxfs.h"
 #include "libxlog.h"
 #include <sys/resource.h>
+#include "xfs_multidisk.h"
 #include "avl.h"
 #include "avl64.h"
 #include "globals.h"
@@ -589,6 +590,33 @@ format_log_max_lsn(
 			 XLOG_FMT, new_cycle, true);
 }
 
+/*
+ * mkfs increases the AG count for "multidisk" configurations, we want
+ * to target these for an increase in thread count. Hence check the superlock
+ * geometry information to determine if mkfs considered this a multidisk
+ * configuration.
+ */
+static bool
+is_multidisk_filesystem(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+
+	/* High agcount filesystems are always considered "multidisk" */
+	if (sbp->sb_agcount >= XFS_MULTIDISK_AGCOUNT)
+		return true;
+
+	/*
+	 * If it doesn't have a sunit/swidth, mkfs didn't consider it a
+	 * multi-disk array, so we don't either.
+	 */
+	if (!sbp->sb_unit)
+		return false;
+
+	ASSERT(sbp->sb_width);
+	return true;
+}
+
 int
 main(int argc, char **argv)
 {
@@ -729,9 +757,21 @@ main(int argc, char **argv)
 	 * threads/CPU as this is enough threads to saturate a CPU on fast
 	 * devices, yet few enough that it will saturate but won't overload slow
 	 * devices.
+	 *
+	 * Multidisk filesystems can handle more IO parallelism so we should try
+	 * to process multiple AGs at a time in such a configuration to try to
+	 * saturate the underlying storage and speed the repair process. Only do
+	 * this if prefetching is enabled.
 	 */
-	if (!ag_stride && glob_agcount >= 16 && do_prefetch)
-		ag_stride = 15;
+	if (!ag_stride && do_prefetch && is_multidisk_filesystem(mp)) {
+		/*
+		 * For small agcount multidisk systems, just double the
+		 * parallelism. For larger AG count filesystems (32 and above)
+		 * use more parallelism, and linearly increase the parallelism
+		 * with the number of AGs.
+		 */
+		ag_stride = min(glob_agcount, XFS_MULTIDISK_AGCOUNT / 2) - 1;
+	}
 
 	if (ag_stride) {
 		int max_threads = platform_nproc() * 8;
-- 
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
