Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38218 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752842AbdLDWBK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Dec 2017 17:01:10 -0500
Date: Mon, 4 Dec 2017 14:01:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 02/12] libfrog: move libxfs_log2_roundup to libfrog
Message-ID: <20171204220105.GB4903@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
 <151094961718.29763.17807612789023568958.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151094961718.29763.17807612789023568958.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move libxfs_log2_roundup to libfrog and remove the 'libxfs_' prefix.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix copyright problems
---
 include/libfrog.h |   23 +++++++++++++++++++++++
 include/libxfs.h  |    1 -
 libfrog/Makefile  |    3 ++-
 libfrog/util.c    |   36 ++++++++++++++++++++++++++++++++++++
 libxfs/util.c     |   12 ------------
 mkfs/Makefile     |    5 +++--
 mkfs/maxtrres.c   |    4 ++--
 mkfs/xfs_mkfs.c   |    4 ++--
 repair/Makefile   |    6 +++---
 repair/sb.c       |    4 ++--
 10 files changed, 73 insertions(+), 25 deletions(-)
 create mode 100644 include/libfrog.h
 create mode 100644 libfrog/util.c

diff --git a/include/libfrog.h b/include/libfrog.h
new file mode 100644
index 0000000..2d8055b
--- /dev/null
+++ b/include/libfrog.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
+#ifndef __LIBFROG_UTIL_H_
+#define __LIBFROG_UTIL_H_
+
+unsigned int	log2_roundup(unsigned int i);
+
+#endif /* __LIBFROG_UTIL_H_ */
diff --git a/include/libxfs.h b/include/libxfs.h
index abb01cb..e392e52 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -165,7 +165,6 @@ extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 
 
 /* Shared utility routines */
-extern unsigned int	libxfs_log2_roundup(unsigned int i);
 
 extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
 				xfs_off_t, int, int);
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 231a734..6d9ed07 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -10,7 +10,8 @@ LT_CURRENT = 0
 LT_REVISION = 0
 LT_AGE = 0
 
-CFILES =
+CFILES = \
+util.c
 
 default: ltdepend $(LTLIBRARY)
 
diff --git a/libfrog/util.c b/libfrog/util.c
new file mode 100644
index 0000000..4896e4b
--- /dev/null
+++ b/libfrog/util.c
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
+#include "platform_defs.h"
+#include "libfrog.h"
+
+/*
+ * libfrog is a collection of miscellaneous userspace utilities.
+ * It's a library of Funny Random Oddball Gunk <cough>.
+ */
+
+unsigned int
+log2_roundup(unsigned int i)
+{
+	unsigned int	rval;
+
+	for (rval = 0; rval < NBBY * sizeof(i); rval++) {
+		if ((1 << rval) >= i)
+			break;
+	}
+	return rval;
+}
diff --git a/libxfs/util.c b/libxfs/util.c
index 3b11ac4..6d8cb5e 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -631,18 +631,6 @@ libxfs_alloc_file_space(
 	return error;
 }
 
-unsigned int
-libxfs_log2_roundup(unsigned int i)
-{
-	unsigned int	rval;
-
-	for (rval = 0; rval < NBBY * sizeof(i); rval++) {
-		if ((1 << rval) >= i)
-			break;
-	}
-	return rval;
-}
-
 /*
  * Wrapper around call to libxfs_ialloc. Takes care of committing and
  * allocating a new transaction as needed.
diff --git a/mkfs/Makefile b/mkfs/Makefile
index c13b903..e2dc1d4 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -10,8 +10,9 @@ LTCOMMAND = mkfs.xfs
 HFILES =
 CFILES = maxtrres.c proto.c xfs_mkfs.c
 
-LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) $(LIBUUID)
-LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD)
+LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
+	$(LIBUUID)
+LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index 04028bf..0fa18c8 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -23,7 +23,7 @@
  * of sector size, block size, inode size, directory version, and
  * directory block size.
  */
-
+#include "libfrog.h"
 #include "libxfs.h"
 #include "xfs_multidisk.h"
 
@@ -55,7 +55,7 @@ max_trans_res(
 	sbp->sb_blocklog = blocklog;
 	sbp->sb_blocksize = 1 << blocklog;
 	sbp->sb_agblocks = agsize;
-	sbp->sb_agblklog = (uint8_t)libxfs_log2_roundup((unsigned int)agsize);
+	sbp->sb_agblklog = (uint8_t)log2_roundup((unsigned int)agsize);
 	sbp->sb_inodelog = inodelog;
 	sbp->sb_inopblog = blocklog - inodelog;
 	sbp->sb_inodesize = 1 << inodelog;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5bfec03..cade04c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -15,7 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
+#include "libfrog.h"
 #include "libxfs.h"
 #include <ctype.h>
 #include "xfs_multidisk.h"
@@ -2720,7 +2720,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	memset(mp, 0, sizeof(xfs_mount_t));
 	sbp->sb_blocklog = (uint8_t)blocklog;
 	sbp->sb_sectlog = (uint8_t)sectorlog;
-	sbp->sb_agblklog = (uint8_t)libxfs_log2_roundup((unsigned int)agsize);
+	sbp->sb_agblklog = (uint8_t)log2_roundup((unsigned int)agsize);
 	sbp->sb_agblocks = (xfs_agblock_t)agsize;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
diff --git a/repair/Makefile b/repair/Makefile
index b7e8fd5..4184a70 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -20,9 +20,9 @@ CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
 	progress.c prefetch.c rmap.c rt.c sb.c scan.c slab.c threads.c \
 	versions.c xfs_repair.c
 
-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBUUID) \
-	$(LIBRT) $(LIBPTHREAD) $(LIBBLKID)
-LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
+	$(LIBPTHREAD) $(LIBBLKID)
+LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
diff --git a/repair/sb.c b/repair/sb.c
index acc9283..f40cdea 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -15,7 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
+#include "libfrog.h"
 #include "libxfs.h"
 #include "libxcmd.h"
 #include "libxlog.h"
@@ -399,7 +399,7 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		sb->sb_dblocks < XFS_MIN_DBLOCKS(sb))
 		return(XR_BAD_FS_SIZE_DATA);
 
-	if (sb->sb_agblklog != (uint8_t)libxfs_log2_roundup(sb->sb_agblocks))
+	if (sb->sb_agblklog != (uint8_t)log2_roundup(sb->sb_agblocks))
 		return(XR_BAD_FS_SIZE_DATA);
 
 	if (sb->sb_inodesize < XFS_DINODE_MIN_SIZE                     ||
