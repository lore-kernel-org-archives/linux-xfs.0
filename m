Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6DC07F52
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 15:38:42 -0500 (CDT)
Date: Thu, 18 Sep 2014 15:38:42 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 08/13] libxfs: add xfs_nameops for utf8 and utf8+casefold.
Message-ID: <20140918203842.GV4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
 <20140918203114.GN4482@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918203114.GN4482@sgi.com>
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
Cc: tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

From: Olaf Weber <olaf@sgi.com>

The xfs_utf8_nameops use the nfkdi normalization when comparing filenames,
and are installed if the utf8bit is set in the super block.

The xfs_utf8_ci_nameops use the nfkdicf normalization when comparing
filenames, and are installed if both the utf8bit and the borgbit are set
in the superblock.

Normalized filenames are not stored on disk. Normalization will fail if a
filename is not valid UTF-8, in which case the filename is treated as an
opaque blob.

Changes:
 Type conversion to "(const char *)" added to utf8ncursor() and utf8nlen()
 calls.

Signed-off-by: Olaf Weber <olaf@sgi.com>
---
 Makefile           |   2 +-
 include/libxfs.h   |   1 +
 include/xfs_utf8.h |  25 ++++++
 libxfs/Makefile    |   4 +-
 libxfs/xfs_dir2.c  |  15 +++-
 libxfs/xfs_utf8.c  | 238 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 support/Makefile   |  24 ++++++
 7 files changed, 303 insertions(+), 6 deletions(-)
 create mode 100644 include/xfs_utf8.h
 create mode 100644 libxfs/xfs_utf8.c
 create mode 100644 support/Makefile

diff --git a/Makefile b/Makefile
index f56aebd..c442da6 100644
--- a/Makefile
+++ b/Makefile
@@ -40,7 +40,7 @@ LDIRDIRT = $(SRCDIR)
 LDIRT += $(SRCTAR)
 endif
 
-LIB_SUBDIRS = libxfs libxlog libxcmd libhandle libdisk
+LIB_SUBDIRS = support libxfs libxlog libxcmd libhandle libdisk
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
 		mdrestore repair rtcp m4 man doc po debian
 
diff --git a/include/libxfs.h b/include/libxfs.h
index 45a924f..99cb3d9 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -59,6 +59,7 @@
 #include <xfs/xfs_btree_trace.h>
 #include <xfs/xfs_bmap.h>
 #include <xfs/xfs_trace.h>
+#include <xfs_utf8.h>
 
 
 #ifndef ARRAY_SIZE
diff --git a/include/xfs_utf8.h b/include/xfs_utf8.h
new file mode 100644
index 0000000..97b6a91
--- /dev/null
+++ b/include/xfs_utf8.h
@@ -0,0 +1,25 @@
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
+extern struct xfs_nameops xfs_utf8_nameops;
+extern struct xfs_nameops xfs_utf8_ci_nameops;
+
+#endif /* XFS_UTF8_H */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index ae15a5d..d836027 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -14,6 +14,7 @@ HFILES = xfs.h init.h xfs_dir2_priv.h crc32defs.h crc32table.h
 CFILES = cache.c \
 	crc32.c \
 	init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
+	utf8norm.c \
 	xfs_alloc.c \
 	xfs_alloc_btree.c \
 	xfs_attr.c \
@@ -38,7 +39,8 @@ CFILES = cache.c \
 	xfs_rtbitmap.c \
 	xfs_sb.c \
 	xfs_symlink_remote.c \
-	xfs_trans_resv.c
+	xfs_trans_resv.c \
+	xfs_utf8.c
 
 CFILES += $(PKG_PLATFORM).c
 PCFILES = darwin.c freebsd.c irix.c linux.c
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 1893931..6872844 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -123,10 +123,17 @@ xfs_dir_mount(
 				(uint)sizeof(xfs_da_node_entry_t);
 
 	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
-	if (xfs_sb_version_hasasciici(&mp->m_sb))
-		mp->m_dirnameops = &xfs_ascii_ci_nameops;
-	else
-		mp->m_dirnameops = &xfs_default_nameops;
+	if (xfs_sb_version_hasutf8(&mp->m_sb)) {
+		if (xfs_sb_version_hasasciici(&mp->m_sb))
+			mp->m_dirnameops = &xfs_utf8_ci_nameops;
+		else
+			mp->m_dirnameops = &xfs_utf8_nameops;
+	} else {
+		if (xfs_sb_version_hasasciici(&mp->m_sb))
+			mp->m_dirnameops = &xfs_ascii_ci_nameops;
+		else
+			mp->m_dirnameops = &xfs_default_nameops;
+	}
 }
 
 /*
diff --git a/libxfs/xfs_utf8.c b/libxfs/xfs_utf8.c
new file mode 100644
index 0000000..f5cc231
--- /dev/null
+++ b/libxfs/xfs_utf8.c
@@ -0,0 +1,238 @@
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
+#include "xfs_inum.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_bmap.h"
+#include "xfs_dir2.h"
+#include "xfs_trace.h"
+#include "xfs_utf8.h"
+#include "utf8norm.h"
+
+/*
+ * xfs nameops using nfkdi
+ */
+
+static xfs_dahash_t
+xfs_utf8_hashname(
+	const unsigned char *name,
+	int len)
+{
+	utf8data_t	nfkdi;
+	struct utf8cursor u8c;
+	xfs_dahash_t	hash;
+	int		val;
+
+	nfkdi = utf8nfkdi(utf8version);
+	hash = 0;
+	if (utf8ncursor(&u8c, nfkdi, (const char *)name, len) < 0)
+		goto blob;
+	while ((val = utf8byte(&u8c)) > 0)
+		hash = val ^ rol32(hash, 7);
+	/* In case of error treat the name as a binary blob. */
+	if (val == 0)
+		return hash;
+blob:
+	return xfs_da_hashname(name, len);
+}
+
+static int
+xfs_utf8_normhash(
+	struct xfs_da_args *args)
+{
+	utf8data_t	nfkdi;
+	struct utf8cursor u8c;
+	unsigned char	*norm;
+	ssize_t		normlen;
+	int		c;
+
+	nfkdi = utf8nfkdi(utf8version);
+	/* Failure to normalize is treated as a blob. */
+	if ((normlen = utf8nlen(nfkdi, (const char *)args->name,
+				 args->namelen)) < 0)
+		goto blob;
+	if (utf8ncursor(&u8c, nfkdi, (const char *)args->name,
+			args->namelen) < 0)
+		goto blob;
+	if (!(norm = kmem_alloc(normlen + 1, KM_NOFS|KM_MAYFAIL)))
+		return ENOMEM;
+	args->norm = norm;
+	args->normlen = normlen;
+	while ((c = utf8byte(&u8c)) > 0)
+		*norm++ = c;
+	if (c == 0) {
+		*norm = '\0';
+		args->hashval = xfs_da_hashname(args->norm, args->normlen);
+		return 0;
+	}
+	kmem_free((void *)args->norm);
+blob:
+	args->norm = NULL;
+	args->normlen = -1;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return 0;
+}
+
+static enum xfs_dacmp
+xfs_utf8_compname(
+	struct xfs_da_args *args,
+	const unsigned char *name,
+	int		len)
+{
+	utf8data_t	nfkdi;
+	struct utf8cursor u8c;
+	const char	*norm;
+	int		c;
+
+	ASSERT(args->norm || args->normlen == -1);
+
+	/* Check for an exact match first. */
+	if (args->namelen == len && memcmp(args->name, name, len) == 0)
+		return XFS_CMP_EXACT;
+	/* xfs_utf8_normhash() set args->normlen to -1 for a blob */
+	if (args->normlen < 0)
+		return XFS_CMP_DIFFERENT;
+	nfkdi = utf8nfkdi(utf8version);
+	if (utf8ncursor(&u8c, nfkdi, (const char *)name, len) < 0)
+		return XFS_CMP_DIFFERENT;
+	norm = (const char *)args->norm;
+	while ((c = utf8byte(&u8c)) > 0)
+		if (c != *norm++)
+			return XFS_CMP_DIFFERENT;
+	if (c < 0 || *norm != '\0')
+		return XFS_CMP_DIFFERENT;
+	return XFS_CMP_MATCH;
+}
+
+struct xfs_nameops xfs_utf8_nameops = {
+	.hashname = xfs_utf8_hashname,
+	.normhash = xfs_utf8_normhash,
+	.compname = xfs_utf8_compname,
+};
+
+/*
+ * xfs nameops using nfkdicf
+ */
+
+static xfs_dahash_t
+xfs_utf8_ci_hashname(
+	const unsigned char *name,
+	int len)
+{
+	utf8data_t	nfkdicf;
+	struct utf8cursor u8c;
+	xfs_dahash_t	hash;
+	int		val;
+
+	nfkdicf = utf8nfkdicf(utf8version);
+	hash = 0;
+	if (utf8ncursor(&u8c, nfkdicf, (const char *)name, len) < 0)
+		goto blob;
+	while ((val = utf8byte(&u8c)) > 0)
+		hash = val ^ rol32(hash, 7);
+	/* In case of error treat the name as a binary blob. */
+	if (val == 0)
+		return hash;
+blob:
+	return xfs_da_hashname(name, len);
+}
+
+static int
+xfs_utf8_ci_normhash(
+	struct xfs_da_args *args)
+{
+	utf8data_t	nfkdicf;
+	struct utf8cursor u8c;
+	unsigned char	*norm;
+	ssize_t		normlen;
+	int		c;
+
+	nfkdicf = utf8nfkdicf(utf8version);
+	/* Failure to normalize is treated as a blob. */
+	if ((normlen = utf8nlen(nfkdicf, (const char *)args->name,
+				args->namelen)) < 0)
+		goto blob;
+	if (utf8ncursor(&u8c, nfkdicf, (const char *)args->name,
+			args->namelen) < 0)
+		goto blob;
+	if (!(norm = kmem_alloc(normlen + 1, KM_NOFS|KM_MAYFAIL)))
+		return ENOMEM;
+	args->norm = norm;
+	args->normlen = normlen;
+	while ((c = utf8byte(&u8c)) > 0)
+		*norm++ = c;
+	if (c == 0) {
+		*norm = '\0';
+		args->hashval = xfs_da_hashname(args->norm, args->normlen);
+		return 0;
+	}
+	kmem_free((void *)args->norm);
+blob:
+	args->norm = NULL;
+	args->normlen = -1;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return 0;
+}
+
+static enum xfs_dacmp
+xfs_utf8_ci_compname(
+	struct xfs_da_args *args,
+	const unsigned char *name,
+	int		len)
+{
+	utf8data_t	nfkdicf;
+	struct utf8cursor u8c;
+	const unsigned char *norm;
+	int		c;
+
+	ASSERT(args->norm || args->normlen == -1);
+
+	/* Check for an exact match first. */
+	if (args->namelen == len && memcmp(args->name, name, len) == 0)
+		return XFS_CMP_EXACT;
+	/* xfs_utf8_ci_normhash() set args->normlen to -1 for a blob */
+	if (args->normlen < 0)
+		return XFS_CMP_DIFFERENT;
+	nfkdicf = utf8nfkdicf(utf8version);
+	if (utf8ncursor(&u8c, nfkdicf, (const char *)name, len) < 0)
+		return XFS_CMP_DIFFERENT;
+	norm = args->norm;
+	while ((c = utf8byte(&u8c)) > 0)
+		if (c != *norm++)
+			return XFS_CMP_DIFFERENT;
+	if (c < 0 || *norm != '\0')
+		return XFS_CMP_DIFFERENT;
+	return XFS_CMP_MATCH;
+}
+
+struct xfs_nameops xfs_utf8_ci_nameops = {
+	.hashname = xfs_utf8_ci_hashname,
+	.normhash = xfs_utf8_ci_normhash,
+	.compname = xfs_utf8_ci_compname,
+};
diff --git a/support/Makefile b/support/Makefile
new file mode 100644
index 0000000..cade5fe
--- /dev/null
+++ b/support/Makefile
@@ -0,0 +1,24 @@
+#
+# Copyright (c) 2014 SGI. All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+default = ../include/utf8data.h
+
+../include/utf8data.h:	mkutf8data.c
+	cc -o mkutf8data mkutf8data.c
+	cd ucd-7.0.0 ; ../mkutf8data
+	mv ucd-7.0.0/utf8data.h ../include
+
+default clean:
+	rm -f mkutf8data ../include/utf8data.h
+
+default install:
+
+default install-dev:
+
+default install-qa:
+
+-include .ltdep
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
