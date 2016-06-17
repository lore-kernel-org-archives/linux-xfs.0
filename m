Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6C72806C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:31:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 233E9AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:58 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id VgvFyB4niMUjlGHy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:55 -0700 (PDT)
Subject: [PATCH 010/145] xfs_logprint: fix formatting issues with the EFI
	printing code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:31:47 -0700
Message-ID: <146612710794.16048.674906502840774962.stgit@birch.djwong.org>
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

Fix some formatting issues with the EFI handling functions.
This is a purely mechanical whitespace fix, no code changes
aside from adding 'static'.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 logprint/log_redo.c |  261 ++++++++++++++++++++++++++-------------------------
 1 file changed, 133 insertions(+), 128 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index a9608f0..d60cc1b 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -23,118 +23,119 @@
 
 /* Extent Free Items */
 
-int
+static int
 xfs_efi_copy_format(
 	char			  *buf,
 	uint			  len,
 	struct xfs_efi_log_format *dst_efi_fmt,
 	int			  continued)
 {
-        uint i;
+	uint i;
 	uint nextents = ((xfs_efi_log_format_t *)buf)->efi_nextents;
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
+	uint dst_len = sizeof(xfs_efi_log_format_t) + (nextents - 1) * sizeof(xfs_extent_t);
+	uint len32 = sizeof(xfs_efi_log_format_32_t) + (nextents - 1) * sizeof(xfs_extent_32_t);
+	uint len64 = sizeof(xfs_efi_log_format_64_t) + (nextents - 1) * sizeof(xfs_extent_64_t);
+
+	if (len == dst_len || continued) {
+		memcpy((char *)dst_efi_fmt, buf, len);
+		return 0;
+	} else if (len == len32) {
+		xfs_efi_log_format_32_t *src_efi_fmt_32 = (xfs_efi_log_format_32_t *)buf;
+
+		dst_efi_fmt->efi_type	 = src_efi_fmt_32->efi_type;
+		dst_efi_fmt->efi_size	 = src_efi_fmt_32->efi_size;
+		dst_efi_fmt->efi_nextents = src_efi_fmt_32->efi_nextents;
+		dst_efi_fmt->efi_id	   = src_efi_fmt_32->efi_id;
+		for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
+			dst_efi_fmt->efi_extents[i].ext_start =
+				src_efi_fmt_32->efi_extents[i].ext_start;
+			dst_efi_fmt->efi_extents[i].ext_len =
+				src_efi_fmt_32->efi_extents[i].ext_len;
+		}
+		return 0;
+	} else if (len == len64) {
+		xfs_efi_log_format_64_t *src_efi_fmt_64 = (xfs_efi_log_format_64_t *)buf;
+
+		dst_efi_fmt->efi_type	 = src_efi_fmt_64->efi_type;
+		dst_efi_fmt->efi_size	 = src_efi_fmt_64->efi_size;
+		dst_efi_fmt->efi_nextents = src_efi_fmt_64->efi_nextents;
+		dst_efi_fmt->efi_id	   = src_efi_fmt_64->efi_id;
+		for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
+			dst_efi_fmt->efi_extents[i].ext_start =
+				src_efi_fmt_64->efi_extents[i].ext_start;
+			dst_efi_fmt->efi_extents[i].ext_len =
+				src_efi_fmt_64->efi_extents[i].ext_len;
+		}
+		return 0;
+	}
 	fprintf(stderr, _("%s: bad size of efi format: %u; expected %u or %u; nextents = %u\n"),
 		progname, len, len32, len64, nextents);
-        return 1;
+	return 1;
 }
 
 int
 xlog_print_trans_efi(
-	char **ptr,
-	uint src_len,
-	int continued)
+	char			**ptr,
+	uint			src_len,
+	int			continued)
 {
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
+	xfs_efi_log_format_t	*src_f, *f = NULL;
+	uint			dst_len;
+	xfs_extent_t		*ex;
+	int			i;
+	int			error = 0;
+	int			core_size = offsetof(xfs_efi_log_format_t, efi_extents);
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * xfs_efi_log_format_t structure
+	 */
+	if ((src_f = (xfs_efi_log_format_t *)malloc(src_len)) == NULL) {
+		fprintf(stderr, _("%s: xlog_print_trans_efi: malloc failed\n"), progname);
+		exit(1);
+	}
+	memmove((char*)src_f, *ptr, src_len);
+	*ptr += src_len;
+
+	/* convert to native format */
+	dst_len = sizeof(xfs_efi_log_format_t) + (src_f->efi_nextents - 1) * sizeof(xfs_extent_t);
+
+	if (continued && src_len < core_size) {
+		printf(_("EFI: Not enough data to decode further\n"));
+		error = 1;
+		goto error;
+	}
+
+	if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
+		fprintf(stderr, _("%s: xlog_print_trans_efi: malloc failed\n"), progname);
+		exit(1);
+	}
+	if (xfs_efi_copy_format((char*)src_f, src_len, f, continued)) {
+		error = 1;
+		goto error;
+	}
+
+	printf(_("EFI:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
+		f->efi_size, f->efi_nextents, (unsigned long long)f->efi_id);
+
+	if (continued) {
+		printf(_("EFI free extent data skipped (CONTINUE set, no space)\n"));
+		goto error;
+	}
+
+	ex = f->efi_extents;
+	for (i=0; i < f->efi_nextents; i++) {
+		printf("(s: 0x%llx, l: %d) ",
+			(unsigned long long)ex->ext_start, ex->ext_len);
+		if (i % 4 == 3) printf("\n");
+		ex++;
+	}
+	if (i % 4 != 0)
+		printf("\n");
 error:
-    free(src_f);
-    free(f);
-    return error;
+	free(src_f);
+	free(f);
+	return error;
 }	/* xlog_print_trans_efi */
 
 void
@@ -154,18 +155,20 @@ xlog_recover_print_efi(
 	 * Each element is of size xfs_extent_32_t or xfs_extent_64_t.
 	 * Need to convert to native format.
 	 */
-	dst_len = sizeof(xfs_efi_log_format_t) + (src_f->efi_nextents - 1) * sizeof(xfs_extent_t);
+	dst_len = sizeof(xfs_efi_log_format_t) +
+		(src_f->efi_nextents - 1) * sizeof(xfs_extent_t);
 	if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
-	    fprintf(stderr, _("%s: xlog_recover_print_efi: malloc failed\n"), progname);
-	    exit(1);
+		fprintf(stderr, _("%s: xlog_recover_print_efi: malloc failed\n"),
+			progname);
+		exit(1);
 	}
 	if (xfs_efi_copy_format((char*)src_f, src_len, f, 0)) {
-	    free(f);
-	    return;
+		free(f);
+		return;
 	}
 
-	printf(_("	EFI:  #regs:%d    num_extents:%d  id:0x%llx\n"),
-	       f->efi_size, f->efi_nextents, (unsigned long long)f->efi_id);
+	printf(_("	EFI:  #regs:%d	num_extents:%d  id:0x%llx\n"),
+		   f->efi_size, f->efi_nextents, (unsigned long long)f->efi_id);
 	ex = f->efi_extents;
 	printf("	");
 	for (i=0; i< f->efi_nextents; i++) {
@@ -183,29 +186,30 @@ xlog_recover_print_efi(
 int
 xlog_print_trans_efd(char **ptr, uint len)
 {
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
+	xfs_efd_log_format_t *f;
+	xfs_efd_log_format_t lbuf;
+	/* size without extents at end */
+	uint core_size = sizeof(xfs_efd_log_format_t) - sizeof(xfs_extent_t);
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * xfs_efd_log_format_t structure
+	 */
+	memmove(&lbuf, *ptr, MIN(core_size, len));
+	f = &lbuf;
+	*ptr += len;
+	if (len >= core_size) {
+		printf(_("EFD:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
+			f->efd_size, f->efd_nextents,
+			(unsigned long long)f->efd_efi_id);
+
+		/* don't print extents as they are not used */
+
+		return 0;
+	} else {
+		printf(_("EFD: Not enough data to decode further\n"));
 	return 1;
-    }
+	}
 }	/* xlog_print_trans_efd */
 
 void
@@ -221,6 +225,7 @@ xlog_recover_print_efd(
 	 * Each element is of size xfs_extent_32_t or xfs_extent_64_t.
 	 * However, the extents are never used and won't be printed.
 	 */
-	printf(_("	EFD:  #regs: %d    num_extents: %d  id: 0x%llx\n"),
-	       f->efd_size, f->efd_nextents, (unsigned long long)f->efd_efi_id);
+	printf(_("	EFD:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
+		f->efd_size, f->efd_nextents,
+		(unsigned long long)f->efd_efi_id);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
