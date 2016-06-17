Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 798E58063
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:31:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B6168F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qRJqGxLRQxcCYERo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:45 -0700 (PDT)
Subject: [PATCH 009/145] xfs_logprint: move the EFI copying/printing
	functions to a redo items file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:31:41 -0700
Message-ID: <146612710170.16048.15356139701108271924.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Move the functions that handle EFI items into a separate file to
avoid cluttering up log_misc.c even more when we start adding the
other redo item types.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 logprint/Makefile        |    2 
 logprint/log_misc.c      |  144 -----------------------------
 logprint/log_print_all.c |   60 ------------
 logprint/log_redo.c      |  226 ++++++++++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |    6 +
 5 files changed, 232 insertions(+), 206 deletions(-)
 create mode 100644 logprint/log_redo.c


diff --git a/logprint/Makefile b/logprint/Makefile
index 7bcf27f..534bf5b 100644
--- a/logprint/Makefile
+++ b/logprint/Makefile
@@ -10,7 +10,7 @@ LTCOMMAND = xfs_logprint
 HFILES = logprint.h
 CFILES = logprint.c \
 	 log_copy.c log_dump.c log_misc.c \
-	 log_print_all.c log_print_trans.c
+	 log_print_all.c log_print_trans.c log_redo.c
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index e6ee832..57d397c 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -475,100 +475,6 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 
 
 int
-xlog_print_trans_efd(char **ptr, uint len)
-{
-    xfs_efd_log_format_t *f;
-    xfs_efd_log_format_t lbuf;
-    /* size without extents at end */
-    uint core_size = sizeof(xfs_efd_log_format_t) - sizeof(xfs_extent_t);
-
-    /*
-     * memmove to ensure 8-byte alignment for the long longs in
-     * xfs_efd_log_format_t structure
-     */
-    memmove(&lbuf, *ptr, MIN(core_size, len));
-    f = &lbuf;
-    *ptr += len;
-    if (len >= core_size) {
-	printf(_("EFD:  #regs: %d    num_extents: %d  id: 0x%llx\n"),
-	       f->efd_size, f->efd_nextents, (unsigned long long)f->efd_efi_id);
-
-	/* don't print extents as they are not used */
-
-	return 0;
-    } else {
-	printf(_("EFD: Not enough data to decode further\n"));
-	return 1;
-    }
-}	/* xlog_print_trans_efd */
-
-
-int
-xlog_print_trans_efi(
-	char **ptr,
-	uint src_len,
-	int continued)
-{
-    xfs_efi_log_format_t *src_f, *f = NULL;
-    uint		 dst_len;
-    xfs_extent_t	 *ex;
-    int			 i;
-    int			 error = 0;
-    int			 core_size = offsetof(xfs_efi_log_format_t, efi_extents);
-
-    /*
-     * memmove to ensure 8-byte alignment for the long longs in
-     * xfs_efi_log_format_t structure
-     */
-    if ((src_f = (xfs_efi_log_format_t *)malloc(src_len)) == NULL) {
-	fprintf(stderr, _("%s: xlog_print_trans_efi: malloc failed\n"), progname);
-	exit(1);
-    }
-    memmove((char*)src_f, *ptr, src_len);
-    *ptr += src_len;
-
-    /* convert to native format */
-    dst_len = sizeof(xfs_efi_log_format_t) + (src_f->efi_nextents - 1) * sizeof(xfs_extent_t);
-
-    if (continued && src_len < core_size) {
-	printf(_("EFI: Not enough data to decode further\n"));
-	error = 1;
-	goto error;
-    }
-
-    if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
-	fprintf(stderr, _("%s: xlog_print_trans_efi: malloc failed\n"), progname);
-	exit(1);
-    }
-    if (xfs_efi_copy_format((char*)src_f, src_len, f, continued)) {
-	error = 1;
-	goto error;
-    }
-
-    printf(_("EFI:  #regs: %d    num_extents: %d  id: 0x%llx\n"),
-	   f->efi_size, f->efi_nextents, (unsigned long long)f->efi_id);
-
-    if (continued) {
-	printf(_("EFI free extent data skipped (CONTINUE set, no space)\n"));
-	goto error;
-    }
-
-    ex = f->efi_extents;
-    for (i=0; i < f->efi_nextents; i++) {
-	    printf("(s: 0x%llx, l: %d) ",
-		    (unsigned long long)ex->ext_start, ex->ext_len);
-	    if (i % 4 == 3) printf("\n");
-	    ex++;
-    }
-    if (i % 4 != 0) printf("\n");
-error:
-    free(src_f);
-    free(f);
-    return error;
-}	/* xlog_print_trans_efi */
-
-
-int
 xlog_print_trans_qoff(char **ptr, uint len)
 {
     xfs_qoff_logformat_t *f;
@@ -1617,53 +1523,3 @@ xfs_inode_item_format_convert(char *src_buf, uint len, xfs_inode_log_format_t *i
 	}
 	return in_f;
 }
-
-int
-xfs_efi_copy_format(
-	char			  *buf,
-	uint			  len,
-	struct xfs_efi_log_format *dst_efi_fmt,
-	int			  continued)
-{
-        uint i;
-	uint nextents = ((xfs_efi_log_format_t *)buf)->efi_nextents;
-        uint dst_len = sizeof(xfs_efi_log_format_t) + (nextents - 1) * sizeof(xfs_extent_t);
-        uint len32 = sizeof(xfs_efi_log_format_32_t) + (nextents - 1) * sizeof(xfs_extent_32_t);
-        uint len64 = sizeof(xfs_efi_log_format_64_t) + (nextents - 1) * sizeof(xfs_extent_64_t);
-
-        if (len == dst_len || continued) {
-                memcpy((char *)dst_efi_fmt, buf, len);
-                return 0;
-        } else if (len == len32) {
-                xfs_efi_log_format_32_t *src_efi_fmt_32 = (xfs_efi_log_format_32_t *)buf;
-
-                dst_efi_fmt->efi_type     = src_efi_fmt_32->efi_type;
-                dst_efi_fmt->efi_size     = src_efi_fmt_32->efi_size;
-                dst_efi_fmt->efi_nextents = src_efi_fmt_32->efi_nextents;
-                dst_efi_fmt->efi_id       = src_efi_fmt_32->efi_id;
-                for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
-                        dst_efi_fmt->efi_extents[i].ext_start =
-                                src_efi_fmt_32->efi_extents[i].ext_start;
-                        dst_efi_fmt->efi_extents[i].ext_len =
-                                src_efi_fmt_32->efi_extents[i].ext_len;
-                }
-                return 0;
-        } else if (len == len64) {
-                xfs_efi_log_format_64_t *src_efi_fmt_64 = (xfs_efi_log_format_64_t *)buf;
-
-                dst_efi_fmt->efi_type     = src_efi_fmt_64->efi_type;
-                dst_efi_fmt->efi_size     = src_efi_fmt_64->efi_size;
-                dst_efi_fmt->efi_nextents = src_efi_fmt_64->efi_nextents;
-                dst_efi_fmt->efi_id       = src_efi_fmt_64->efi_id;
-                for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
-                        dst_efi_fmt->efi_extents[i].ext_start =
-                                src_efi_fmt_64->efi_extents[i].ext_start;
-                        dst_efi_fmt->efi_extents[i].ext_len =
-                                src_efi_fmt_64->efi_extents[i].ext_len;
-                }
-                return 0;
-        }
-	fprintf(stderr, _("%s: bad size of efi format: %u; expected %u or %u; nextents = %u\n"),
-		progname, len, len32, len64, nextents);
-        return 1;
-}
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index f95f4aa..4d92c3b 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -372,66 +372,6 @@ xlog_recover_print_inode(
 	}
 }
 
-STATIC void
-xlog_recover_print_efd(
-	xlog_recover_item_t	*item)
-{
-	xfs_efd_log_format_t	*f;
-
-	f = (xfs_efd_log_format_t *)item->ri_buf[0].i_addr;
-	/*
-	 * An xfs_efd_log_format structure contains a variable length array
-	 * as the last field.
-	 * Each element is of size xfs_extent_32_t or xfs_extent_64_t.
-	 * However, the extents are never used and won't be printed.
-	 */
-	printf(_("	EFD:  #regs: %d    num_extents: %d  id: 0x%llx\n"),
-	       f->efd_size, f->efd_nextents, (unsigned long long)f->efd_efi_id);
-}
-
-
-STATIC void
-xlog_recover_print_efi(
-	xlog_recover_item_t	*item)
-{
-	xfs_efi_log_format_t	*f, *src_f;
-	xfs_extent_t		*ex;
-	int			i;
-	uint			src_len, dst_len;
-
-	src_f = (xfs_efi_log_format_t *)item->ri_buf[0].i_addr;
-	src_len = item->ri_buf[0].i_len;
-	/*
-	 * An xfs_efi_log_format structure contains a variable length array
-	 * as the last field.
-	 * Each element is of size xfs_extent_32_t or xfs_extent_64_t.
-	 * Need to convert to native format.
-	 */
-	dst_len = sizeof(xfs_efi_log_format_t) + (src_f->efi_nextents - 1) * sizeof(xfs_extent_t);
-	if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
-	    fprintf(stderr, _("%s: xlog_recover_print_efi: malloc failed\n"), progname);
-	    exit(1);
-	}
-	if (xfs_efi_copy_format((char*)src_f, src_len, f, 0)) {
-	    free(f);
-	    return;
-	}
-
-	printf(_("	EFI:  #regs:%d    num_extents:%d  id:0x%llx\n"),
-	       f->efi_size, f->efi_nextents, (unsigned long long)f->efi_id);
-	ex = f->efi_extents;
-	printf("	");
-	for (i=0; i< f->efi_nextents; i++) {
-		printf("(s: 0x%llx, l: %d) ",
-			(unsigned long long)ex->ext_start, ex->ext_len);
-		if (i % 4 == 3)
-			printf("\n");
-		ex++;
-	}
-	if (i % 4 != 0)
-		printf("\n");
-	free(f);
-}
 
 STATIC void
 xlog_recover_print_icreate(
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
new file mode 100644
index 0000000..a9608f0
--- /dev/null
+++ b/logprint/log_redo.c
@@ -0,0 +1,226 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2016 Oracle, Inc.
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
+#include "libxfs.h"
+#include "libxlog.h"
+
+#include "logprint.h"
+
+/* Extent Free Items */
+
+int
+xfs_efi_copy_format(
+	char			  *buf,
+	uint			  len,
+	struct xfs_efi_log_format *dst_efi_fmt,
+	int			  continued)
+{
+        uint i;
+	uint nextents = ((xfs_efi_log_format_t *)buf)->efi_nextents;
+        uint dst_len = sizeof(xfs_efi_log_format_t) + (nextents - 1) * sizeof(xfs_extent_t);
+        uint len32 = sizeof(xfs_efi_log_format_32_t) + (nextents - 1) * sizeof(xfs_extent_32_t);
+        uint len64 = sizeof(xfs_efi_log_format_64_t) + (nextents - 1) * sizeof(xfs_extent_64_t);
+
+        if (len == dst_len || continued) {
+                memcpy((char *)dst_efi_fmt, buf, len);
+                return 0;
+        } else if (len == len32) {
+                xfs_efi_log_format_32_t *src_efi_fmt_32 = (xfs_efi_log_format_32_t *)buf;
+
+                dst_efi_fmt->efi_type     = src_efi_fmt_32->efi_type;
+                dst_efi_fmt->efi_size     = src_efi_fmt_32->efi_size;
+                dst_efi_fmt->efi_nextents = src_efi_fmt_32->efi_nextents;
+                dst_efi_fmt->efi_id       = src_efi_fmt_32->efi_id;
+                for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
+                        dst_efi_fmt->efi_extents[i].ext_start =
+                                src_efi_fmt_32->efi_extents[i].ext_start;
+                        dst_efi_fmt->efi_extents[i].ext_len =
+                                src_efi_fmt_32->efi_extents[i].ext_len;
+                }
+                return 0;
+        } else if (len == len64) {
+                xfs_efi_log_format_64_t *src_efi_fmt_64 = (xfs_efi_log_format_64_t *)buf;
+
+                dst_efi_fmt->efi_type     = src_efi_fmt_64->efi_type;
+                dst_efi_fmt->efi_size     = src_efi_fmt_64->efi_size;
+                dst_efi_fmt->efi_nextents = src_efi_fmt_64->efi_nextents;
+                dst_efi_fmt->efi_id       = src_efi_fmt_64->efi_id;
+                for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
+                        dst_efi_fmt->efi_extents[i].ext_start =
+                                src_efi_fmt_64->efi_extents[i].ext_start;
+                        dst_efi_fmt->efi_extents[i].ext_len =
+                                src_efi_fmt_64->efi_extents[i].ext_len;
+                }
+                return 0;
+        }
+	fprintf(stderr, _("%s: bad size of efi format: %u; expected %u or %u; nextents = %u\n"),
+		progname, len, len32, len64, nextents);
+        return 1;
+}
+
+int
+xlog_print_trans_efi(
+	char **ptr,
+	uint src_len,
+	int continued)
+{
+    xfs_efi_log_format_t *src_f, *f = NULL;
+    uint		 dst_len;
+    xfs_extent_t	 *ex;
+    int			 i;
+    int			 error = 0;
+    int			 core_size = offsetof(xfs_efi_log_format_t, efi_extents);
+
+    /*
+     * memmove to ensure 8-byte alignment for the long longs in
+     * xfs_efi_log_format_t structure
+     */
+    if ((src_f = (xfs_efi_log_format_t *)malloc(src_len)) == NULL) {
+	fprintf(stderr, _("%s: xlog_print_trans_efi: malloc failed\n"), progname);
+	exit(1);
+    }
+    memmove((char*)src_f, *ptr, src_len);
+    *ptr += src_len;
+
+    /* convert to native format */
+    dst_len = sizeof(xfs_efi_log_format_t) + (src_f->efi_nextents - 1) * sizeof(xfs_extent_t);
+
+    if (continued && src_len < core_size) {
+	printf(_("EFI: Not enough data to decode further\n"));
+	error = 1;
+	goto error;
+    }
+
+    if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
+	fprintf(stderr, _("%s: xlog_print_trans_efi: malloc failed\n"), progname);
+	exit(1);
+    }
+    if (xfs_efi_copy_format((char*)src_f, src_len, f, continued)) {
+	error = 1;
+	goto error;
+    }
+
+    printf(_("EFI:  #regs: %d    num_extents: %d  id: 0x%llx\n"),
+	   f->efi_size, f->efi_nextents, (unsigned long long)f->efi_id);
+
+    if (continued) {
+	printf(_("EFI free extent data skipped (CONTINUE set, no space)\n"));
+	goto error;
+    }
+
+    ex = f->efi_extents;
+    for (i=0; i < f->efi_nextents; i++) {
+	    printf("(s: 0x%llx, l: %d) ",
+		    (unsigned long long)ex->ext_start, ex->ext_len);
+	    if (i % 4 == 3) printf("\n");
+	    ex++;
+    }
+    if (i % 4 != 0) printf("\n");
+error:
+    free(src_f);
+    free(f);
+    return error;
+}	/* xlog_print_trans_efi */
+
+void
+xlog_recover_print_efi(
+	xlog_recover_item_t	*item)
+{
+	xfs_efi_log_format_t	*f, *src_f;
+	xfs_extent_t		*ex;
+	int			i;
+	uint			src_len, dst_len;
+
+	src_f = (xfs_efi_log_format_t *)item->ri_buf[0].i_addr;
+	src_len = item->ri_buf[0].i_len;
+	/*
+	 * An xfs_efi_log_format structure contains a variable length array
+	 * as the last field.
+	 * Each element is of size xfs_extent_32_t or xfs_extent_64_t.
+	 * Need to convert to native format.
+	 */
+	dst_len = sizeof(xfs_efi_log_format_t) + (src_f->efi_nextents - 1) * sizeof(xfs_extent_t);
+	if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
+	    fprintf(stderr, _("%s: xlog_recover_print_efi: malloc failed\n"), progname);
+	    exit(1);
+	}
+	if (xfs_efi_copy_format((char*)src_f, src_len, f, 0)) {
+	    free(f);
+	    return;
+	}
+
+	printf(_("	EFI:  #regs:%d    num_extents:%d  id:0x%llx\n"),
+	       f->efi_size, f->efi_nextents, (unsigned long long)f->efi_id);
+	ex = f->efi_extents;
+	printf("	");
+	for (i=0; i< f->efi_nextents; i++) {
+		printf("(s: 0x%llx, l: %d) ",
+			(unsigned long long)ex->ext_start, ex->ext_len);
+		if (i % 4 == 3)
+			printf("\n");
+		ex++;
+	}
+	if (i % 4 != 0)
+		printf("\n");
+	free(f);
+}
+
+int
+xlog_print_trans_efd(char **ptr, uint len)
+{
+    xfs_efd_log_format_t *f;
+    xfs_efd_log_format_t lbuf;
+    /* size without extents at end */
+    uint core_size = sizeof(xfs_efd_log_format_t) - sizeof(xfs_extent_t);
+
+    /*
+     * memmove to ensure 8-byte alignment for the long longs in
+     * xfs_efd_log_format_t structure
+     */
+    memmove(&lbuf, *ptr, MIN(core_size, len));
+    f = &lbuf;
+    *ptr += len;
+    if (len >= core_size) {
+	printf(_("EFD:  #regs: %d    num_extents: %d  id: 0x%llx\n"),
+	       f->efd_size, f->efd_nextents, (unsigned long long)f->efd_efi_id);
+
+	/* don't print extents as they are not used */
+
+	return 0;
+    } else {
+	printf(_("EFD: Not enough data to decode further\n"));
+	return 1;
+    }
+}	/* xlog_print_trans_efd */
+
+void
+xlog_recover_print_efd(
+	xlog_recover_item_t	*item)
+{
+	xfs_efd_log_format_t	*f;
+
+	f = (xfs_efd_log_format_t *)item->ri_buf[0].i_addr;
+	/*
+	 * An xfs_efd_log_format structure contains a variable length array
+	 * as the last field.
+	 * Each element is of size xfs_extent_32_t or xfs_extent_64_t.
+	 * However, the extents are never used and won't be printed.
+	 */
+	printf(_("	EFD:  #regs: %d    num_extents: %d  id: 0x%llx\n"),
+	       f->efd_size, f->efd_nextents, (unsigned long long)f->efd_efi_id);
+}
diff --git a/logprint/logprint.h b/logprint/logprint.h
index 018af81..517e852 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -45,6 +45,10 @@ extern void print_stars(void);
 
 extern xfs_inode_log_format_t *
 	xfs_inode_item_format_convert(char *, uint, xfs_inode_log_format_t *);
-extern int xfs_efi_copy_format(char *, uint, xfs_efi_log_format_t *, int);
+
+extern int xlog_print_trans_efi(char **ptr, uint src_len, int continued);
+extern void xlog_recover_print_efi(xlog_recover_item_t *item);
+extern int xlog_print_trans_efd(char **ptr, uint len);
+extern void xlog_recover_print_efd(xlog_recover_item_t *item);
 
 #endif	/* LOGPRINT_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
