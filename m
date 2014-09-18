Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DBE7A7F37
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 15:16:29 -0500 (CDT)
Date: Thu, 18 Sep 2014 15:16:28 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 08/10] xfs: add xfs_nameops for utf8 and utf8+casefold.
Message-ID: <20140918201628.GK4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918195650.GI19952@sgi.com>
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

Signed-off-by: Olaf Weber <olaf@sgi.com>

---
[v2: updated to use utf8norm.ko module;
     compiled conditionally on CONFIG_XFS_UTF8=y;
     utf8version is now a function;
     move xfs_utf8.[ch] into libxfs. --bpm]
---
 fs/xfs/Makefile          |   2 +
 fs/xfs/libxfs/xfs_dir2.c |  24 ++++-
 fs/xfs/libxfs/xfs_utf8.c | 242 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_utf8.h |  25 +++++
 fs/xfs/xfs_iops.c        |   2 +-
 5 files changed, 290 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_utf8.c
 create mode 100644 fs/xfs/libxfs/xfs_utf8.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6d000d3..5a4dfa0 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -114,6 +114,8 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 				   xfs_qm.o \
 				   xfs_quotaops.o
 
+xfs-$(CONFIG_XFS_UTF8)		+= libxfs/xfs_utf8.o
+
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 84e5ca9..e28736b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -35,6 +35,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_dinode.h"
+#include "xfs_utf8.h"
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
@@ -156,10 +157,25 @@ xfs_da_mount(
 				(uint)sizeof(xfs_da_node_entry_t);
 	dageo->magicpct = (dageo->blksize * 37) / 100;
 
-	if (xfs_sb_version_hasasciici(&mp->m_sb))
-		mp->m_dirnameops = &xfs_ascii_ci_nameops;
-	else
-		mp->m_dirnameops = &xfs_default_nameops;
+	if (xfs_sb_version_hasutf8(&mp->m_sb)) {
+#ifdef CONFIG_XFS_UTF8
+		if (xfs_sb_version_hasasciici(&mp->m_sb))
+			mp->m_dirnameops = &xfs_utf8_ci_nameops;
+		else
+			mp->m_dirnameops = &xfs_utf8_nameops;
+#else
+		xfs_warn(mp,
+		"Recompile XFS with CONFIG_XFS_UTF8 to mount this filesystem");
+		kmem_free(mp->m_dir_geo);
+		kmem_free(mp->m_attr_geo);
+		return -ENOSYS;
+#endif	
+	} else {
+		if (xfs_sb_version_hasasciici(&mp->m_sb))
+			mp->m_dirnameops = &xfs_ascii_ci_nameops;
+		else
+			mp->m_dirnameops = &xfs_default_nameops;
+	}
 
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_utf8.c b/fs/xfs/libxfs/xfs_utf8.c
new file mode 100644
index 0000000..1e64c44
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_utf8.c
@@ -0,0 +1,242 @@
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
+	nfkdi = utf8nfkdi(utf8version());
+	hash = 0;
+	if (utf8ncursor(&u8c, nfkdi, name, len) < 0)
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
+	nfkdi = utf8nfkdi(utf8version());
+	/* Failure to normalize is treated as a blob. */
+	if ((normlen = utf8nlen(nfkdi, args->name, args->namelen)) < 0)
+		goto blob;
+	if (utf8ncursor(&u8c, nfkdi, args->name, args->namelen) < 0)
+		goto blob;
+	if (!(norm = kmem_alloc(normlen + 1, KM_NOFS|KM_MAYFAIL)))
+		return -ENOMEM;
+	args->norm = norm;
+	args->normlen = normlen;
+	while ((c = utf8byte(&u8c)) > 0)
+		*norm++ = c;
+	if (c == 0) {
+		*norm = '\0';
+		args->hashval = xfs_da_hashname(args->norm, args->normlen);
+		return 0;
+	}
+	kmem_free(args->norm);
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
+	const unsigned char *norm;
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
+	nfkdi = utf8nfkdi(utf8version());
+	if (utf8ncursor(&u8c, nfkdi, name, len) < 0)
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
+	nfkdicf = utf8nfkdicf(utf8version());
+	hash = 0;
+	if (utf8ncursor(&u8c, nfkdicf, name, len) < 0)
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
+	nfkdicf = utf8nfkdicf(utf8version());
+	/* Failure to normalize is treated as a blob. */
+	if ((normlen = utf8nlen(nfkdicf, args->name, args->namelen)) < 0)
+		goto blob;
+	if (utf8ncursor(&u8c, nfkdicf, args->name, args->namelen) < 0)
+		goto blob;
+	if (!(norm = kmem_alloc(normlen + 1, KM_NOFS|KM_MAYFAIL)))
+		return -ENOMEM;
+	args->norm = norm;
+	args->normlen = normlen;
+	while ((c = utf8byte(&u8c)) > 0)
+		*norm++ = c;
+	if (c == 0) {
+		*norm = '\0';
+		args->hashval = xfs_da_hashname(args->norm, args->normlen);
+		return 0;
+	}
+	kmem_free(args->norm);
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
+	nfkdicf = utf8nfkdicf(utf8version());
+	if (utf8ncursor(&u8c, nfkdicf, name, len) < 0)
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
diff --git a/fs/xfs/libxfs/xfs_utf8.h b/fs/xfs/libxfs/xfs_utf8.h
new file mode 100644
index 0000000..97b6a91
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_utf8.h
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
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index cea3d64..fbfb1bb 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1257,7 +1257,7 @@ xfs_setup_inode(
 		break;
 	case S_IFDIR:
 		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
-		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
+		if (xfs_sb_version_hasci(&XFS_M(inode->i_sb)->m_sb))
 			inode->i_op = &xfs_dir_ci_inode_operations;
 		else
 			inode->i_op = &xfs_dir_inode_operations;
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
