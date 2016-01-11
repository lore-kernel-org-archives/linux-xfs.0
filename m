Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04C9B29DF5
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 17:46:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7B4C9AC004
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 15:46:54 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Gguo5H8A9xKiQPrr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 15:46:51 -0800 (PST)
Date: Mon, 11 Jan 2016 15:46:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: check on-disk structure sizes
Message-ID: <20160111234644.GB7831@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Check on-disk structure sizes against known values.
Use this to catch inadvertent changes in structure size due to padding
and alignment issues, etc.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/Makefile         |    2 -
 db/init.c           |    3 +
 db/ondisk.c         |   63 +++++++++++++++++++++++
 db/ondisk.h         |  139 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_format.h |    4 +
 5 files changed, 210 insertions(+), 1 deletion(-)
 create mode 100644 db/ondisk.c
 create mode 100644 db/ondisk.h

diff --git a/db/Makefile b/db/Makefile
index 8260da3..ba3e942 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -12,7 +12,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
-	 sig.h strvec.h text.h type.h write.h attrset.h symlink.h
+	 sig.h strvec.h text.h type.h write.h attrset.h symlink.h ondisk.h
 CFILES = $(HFILES:.h=.c)
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/init.c b/db/init.c
index c0472c8..d6df093 100644
--- a/db/init.c
+++ b/db/init.c
@@ -28,6 +28,7 @@
 #include "output.h"
 #include "malloc.h"
 #include "type.h"
+#include "ondisk.h"
 
 static char		**cmdline;
 static int		ncmdline;
@@ -60,6 +61,8 @@ init(
 	struct xfs_buf	*bp;
 	int		c;
 
+	xfs_check_ondisk_structs();
+
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
diff --git a/db/ondisk.c b/db/ondisk.c
new file mode 100644
index 0000000..532333d
--- /dev/null
+++ b/db/ondisk.c
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2016 Oracle.
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
+
+#include "libxfs.h"
+#include "ondisk.h"
+
+void
+xfs_check_ondisk_structs(void)
+{
+	/* on-disk structures */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			336);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
+
+	/* log structures */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_64,	56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_ictimestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_icdinode,		176);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
+}
diff --git a/db/ondisk.h b/db/ondisk.h
new file mode 100644
index 0000000..b5784d1
--- /dev/null
+++ b/db/ondisk.h
@@ -0,0 +1,139 @@
+/*
+ * Copyright (c) 2016 Oracle.
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
+
+#ifndef __XFS_DB_ONDISK_H
+#define __XFS_DB_ONDISK_H
+
+/* Compile time object size, -1 for unknown */
+#ifndef __compiletime_error
+# define __compiletime_error(message)
+/*
+ * Sparse complains of variable sized arrays due to the temporary variable in
+ * __compiletime_assert. Unfortunately we can't just expand it out to make
+ * sparse see a constant array size without breaking compiletime_assert on old
+ * versions of GCC (e.g. 4.2.4), so hide the array from sparse altogether.
+ */
+# ifndef __CHECKER__
+#  define __compiletime_error_fallback(condition) \
+	do { ((void)sizeof(char[1 - 2 * condition])); } while (0)
+# endif
+#endif
+#ifndef __compiletime_error_fallback
+# define __compiletime_error_fallback(condition) do { } while (0)
+#endif
+
+#define __compiletime_assert(condition, msg, prefix, suffix)		\
+	do {								\
+		bool __cond = !(condition);				\
+		extern void prefix ## suffix(void) __compiletime_error(msg); \
+		if (__cond)						\
+			prefix ## suffix();				\
+		__compiletime_error_fallback(__cond);			\
+	} while (0)
+
+#define _compiletime_assert(condition, msg, prefix, suffix) \
+	__compiletime_assert(condition, msg, prefix, suffix)
+
+/**
+ * compiletime_assert - break build and emit msg if condition is false
+ * @condition: a compile-time constant condition to check
+ * @msg:       a message to emit if condition is false
+ *
+ * In tradition of POSIX assert, this macro will break the build if the
+ * supplied condition is *false*, emitting the supplied error message if the
+ * compiler has support to do so.
+ */
+#define compiletime_assert(condition, msg) \
+	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
+
+#ifdef __CHECKER__
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
+#define BUILD_BUG_ON_ZERO(e) (0)
+#define BUILD_BUG_ON_NULL(e) ((void*)0)
+#define BUILD_BUG_ON_INVALID(e) (0)
+#define BUILD_BUG_ON_MSG(cond, msg) (0)
+#define BUILD_BUG_ON(condition) (0)
+#define BUILD_BUG() (0)
+#else /* __CHECKER__ */
+
+/* Force a compilation error if a constant expression is not a power of 2 */
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
+	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
+
+/* Force a compilation error if condition is true, but also produce a
+   result (of value 0 and type size_t), so the expression can be used
+   e.g. in a structure initializer (or where-ever else comma expressions
+   aren't permitted). */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
+
+/*
+ * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
+ * expression but avoids the generation of any code, even if that expression
+ * has side-effects.
+ */
+#define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
+
+/**
+ * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
+ *		      error message.
+ * @condition: the condition which the compiler should know is false.
+ *
+ * See BUILD_BUG_ON for description.
+ */
+#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
+
+/**
+ * BUILD_BUG_ON - break compile if a condition is true.
+ * @condition: the condition which the compiler should know is false.
+ *
+ * If you have some code which relies on certain constants being equal, or
+ * some other compile-time-evaluated condition, you should use BUILD_BUG_ON to
+ * detect if someone changes it.
+ *
+ * The implementation uses gcc's reluctance to create a negative array, but gcc
+ * (as of 4.4) only emits that error for obvious cases (e.g. not arguments to
+ * inline functions).  Luckily, in 4.3 they added the "error" function
+ * attribute just for this type of case.  Thus, we use a negative sized array
+ * (should always create an error on gcc versions older than 4.4) and then call
+ * an undefined function with the error attribute (should always create an
+ * error on gcc 4.3 and later).  If for some reason, neither creates a
+ * compile-time error, we'll still have a link-time error, which is harder to
+ * track down.
+ */
+#ifndef __OPTIMIZE__
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#else
+#define BUILD_BUG_ON(condition) \
+	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
+#endif
+
+/**
+ * BUILD_BUG - break compile if used.
+ *
+ * If you have some code that you expect the compiler to eliminate at
+ * build time, you should use BUILD_BUG to detect if it is
+ * unexpectedly used.
+ */
+#define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
+
+#endif	/* __CHECKER__ */
+
+void xfs_check_ondisk_structs(void);
+
+#endif /* __XFS_DB_ONDISK_H */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index a35009a..c4c0c1c 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1505,4 +1505,8 @@ struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
+#define XFS_CHECK_STRUCT_SIZE(structname, size) \
+	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(struct " \
+		#structname ") is wrong, expected " #size)
+
 #endif /* __XFS_FORMAT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
