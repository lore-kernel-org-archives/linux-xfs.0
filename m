Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BEBB97F3F
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:12:26 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:12:26 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 26/35] libxfs: store utf8version in the superblock
Message-ID: <20141003221226.GZ1865@sgi.com>
References: <20141003214758.GY1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003214758.GY1865@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: olaf@sgi.com, xfs@oss.sgi.com

From: Ben Myers <bpm@sgi.com>

The utf8 version a filesystem was created with needs to be stored in
order that normalizations will remain stable over the lifetime of the
filesystem.  Convert sb_pad to sb_utf8version in the super block.  This
also adds checks at mount time to see whether the unicode normalization
module has support for the version of unicode that the filesystem
requires.  If not we fail the mount.

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 include/xfs_sb.h   | 10 ++++----
 include/xfs_utf8.h | 24 +++++++++++++++++++
 libxfs/xfs_sb.c    |  4 ++--
 libxfs/xfs_utf8.c  | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 6 deletions(-)
 create mode 100644 include/xfs_utf8.h
 create mode 100644 libxfs/xfs_utf8.c

diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index c8563ce..a400cf1 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -176,7 +176,7 @@ typedef struct xfs_sb {
 	__uint32_t	sb_features_log_incompat;
 
 	__uint32_t	sb_crc;		/* superblock crc */
-	__uint32_t	sb_pad;
+	__uint32_t	sb_utf8version;	/* unicode version */
 
 	xfs_ino_t	sb_pquotino;	/* project quota inode */
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
@@ -262,7 +262,7 @@ typedef struct xfs_dsb {
 	__be32		sb_features_log_incompat;
 
 	__le32		sb_crc;		/* superblock crc */
-	__be32		sb_pad;
+	__be32		sb_utf8version;	/* version of unicode */
 
 	__be64		sb_pquotino;	/* project quota inode */
 	__be64		sb_lsn;		/* last write sequence */
@@ -288,7 +288,7 @@ typedef enum {
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
 	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
 	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT,
-	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_PAD,
+	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_UTF8VERSION,
 	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
@@ -320,6 +320,7 @@ typedef enum {
 #define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
 #define XFS_SB_FEATURES_LOG_INCOMPAT XFS_SB_MVAL(FEATURES_LOG_INCOMPAT)
 #define XFS_SB_CRC		XFS_SB_MVAL(CRC)
+#define XFS_SB_UTF8VERSION	XFS_SB_MVAL(UTF8VERSION)
 #define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
@@ -330,7 +331,8 @@ typedef enum {
 	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
 	 XFS_SB_BAD_FEATURES2 | XFS_SB_FEATURES_COMPAT | \
 	 XFS_SB_FEATURES_RO_COMPAT | XFS_SB_FEATURES_INCOMPAT | \
-	 XFS_SB_FEATURES_LOG_INCOMPAT | XFS_SB_PQUOTINO)
+	 XFS_SB_FEATURES_LOG_INCOMPAT | XFS_SB_UTF8VERSION | \
+	 XFS_SB_PQUOTINO)
 
 
 /*
diff --git a/include/xfs_utf8.h b/include/xfs_utf8.h
new file mode 100644
index 0000000..8a700de
--- /dev/null
+++ b/include/xfs_utf8.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2014 SGI.
+ * All rights reserved.
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
+
+#ifndef XFS_UTF8_H
+#define XFS_UTF8_H
+
+extern int xfs_utf8_version_ok(struct xfs_mount *);
+
+#endif /* XFS_UTF8_H */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index ea89367..642a2df 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -78,7 +78,7 @@ static const struct {
 	{ offsetof(xfs_sb_t, sb_features_incompat),	0 },
 	{ offsetof(xfs_sb_t, sb_features_log_incompat),	0 },
 	{ offsetof(xfs_sb_t, sb_crc),		0 },
-	{ offsetof(xfs_sb_t, sb_pad),		0 },
+	{ offsetof(xfs_sb_t, sb_utf8version),	0 },
 	{ offsetof(xfs_sb_t, sb_pquotino),	0 },
 	{ offsetof(xfs_sb_t, sb_lsn),		0 },
 	{ sizeof(xfs_sb_t),			0 }
@@ -410,7 +410,7 @@ xfs_sb_from_disk(
 				be32_to_cpu(from->sb_features_log_incompat);
 	/* crc is only used on disk, not in memory; just init to 0 here. */
 	to->sb_crc = 0;
-	to->sb_pad = 0;
+	to->sb_utf8version = be32_to_cpu(from->sb_utf8version);
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
 }
diff --git a/libxfs/xfs_utf8.c b/libxfs/xfs_utf8.c
new file mode 100644
index 0000000..ebfdaec
--- /dev/null
+++ b/libxfs/xfs_utf8.c
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2014 SGI.
+ * All rights reserved.
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
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_mount.h"
+#include "xfs_da_btree.h"
+#include "xfs_format.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_inode_item.h"
+#include "xfs_bmap.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_utf8.h"
+#include <utf8norm/utf8norm.h>
+
+int
+xfs_utf8_version_ok(
+	struct xfs_mount	*mp)
+{
+	int	major, minor, revision;
+
+	if (utf8version_is_supported(mp->m_sb.sb_utf8version))
+		return 1;
+
+	major = mp->m_sb.sb_utf8version >> UNICODE_MAJ_SHIFT;
+	minor = (mp->m_sb.sb_utf8version & 0xff00) >> UNICODE_MIN_SHIFT;
+	revision = mp->m_sb.sb_utf8version & 0xff;
+
+	if (revision) {
+		xfs_warn(mp,
+		"Unicode version %d.%d.%d not supported by utf8norm.ko",
+		major, minor, revision);
+	} else {
+		xfs_warn(mp,
+		"Unicode version %d.%d not supported by utf8norm.ko",
+		major, minor);
+	}
+
+	return 0;
+}
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
