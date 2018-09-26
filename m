Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48662 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbeIZQiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANcf5036953
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:52 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mnvtur9c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:51 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPphO027463
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:51 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPpSl018478
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:51 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 25/30] xfsprogs: Add log item printing for ATTRI and ATTRD
Date: Wed, 26 Sep 2018 03:23:28 -0700
Message-Id: <1537957413-10630-26-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch implements a new set of log printing functions to
print the ATTRI and ATTRD items and vectors in the log.  These
will be used during log dump and log recover operations.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 logprint/log_misc.c      |  11 ++
 logprint/log_print_all.c |  12 +++
 logprint/log_redo.c      | 262 +++++++++++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |   6 ++
 4 files changed, 291 insertions(+)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 640c00e..f932bfd 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -947,6 +947,17 @@ xlog_print_record(
 					be32_to_cpu(op_head->oh_len));
 			break;
 		    }
+		    case XFS_LI_ATTRI: {
+                        skip = xlog_print_trans_attri(&ptr,
+                                        be32_to_cpu(op_head->oh_len),
+                                        &i);
+                        break;
+                    }
+                    case XFS_LI_ATTRD: {
+                        skip = xlog_print_trans_attrd(&ptr,
+                                        be32_to_cpu(op_head->oh_len));
+                        break;
+                    }
 		    case XFS_LI_RUI: {
 			skip = xlog_print_trans_rui(&ptr,
 					be32_to_cpu(op_head->oh_len),
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index cd47313..4b839c8 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -400,6 +400,12 @@ xlog_recover_print_logitem(
 	case XFS_LI_EFI:
 		xlog_recover_print_efi(item);
 		break;
+	case XFS_LI_ATTRD:
+		xlog_recover_print_attrd(item);
+		break;
+	case XFS_LI_ATTRI:
+		xlog_recover_print_attri(item);
+		break;
 	case XFS_LI_RUD:
 		xlog_recover_print_rud(item);
 		break;
@@ -452,6 +458,12 @@ xlog_recover_print_item(
 	case XFS_LI_EFI:
 		printf("EFI");
 		break;
+	case XFS_LI_ATTRD:
+		printf("ATTRD");
+		break;
+	case XFS_LI_ATTRI:
+		printf("ATTRI");
+		break;
 	case XFS_LI_RUD:
 		printf("RUD");
 		break;
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index f1f690e..27a6432 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -8,6 +8,7 @@
 #include "libxlog.h"
 
 #include "logprint.h"
+#include "xfs_attr_item.h"
 
 /* Extent Free Items */
 
@@ -653,3 +654,264 @@ xlog_recover_print_bud(
 	f = item->ri_buf[0].i_addr;
 	xlog_print_trans_bud(&f, sizeof(struct xfs_bud_log_format));
 }
+
+/* Attr Items */
+
+static int
+xfs_attri_copy_log_format(
+	char				*buf,
+	uint				len,
+	struct xfs_attri_log_format	*dst_attri_fmt)
+{
+	uint dst_len = sizeof(struct xfs_attri_log_format);
+
+	if (len == dst_len) {
+		memcpy((char *)dst_attri_fmt, buf, len);
+		return 0;
+	}
+
+	fprintf(stderr, _("%s: bad size of attri format: %u; expected %u\n"),
+		progname, len, dst_len);
+	return 1;
+}
+
+static int
+xfs_attri_copy_name_format(
+	char                            *buf,
+	uint                            len,
+	struct xfs_parent_name_rec     *dst_attri_fmt)
+{
+	uint dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
+
+	if (len == dst_len) {
+		memcpy((char *)dst_attri_fmt, buf, len);
+		return 0;
+	}
+
+	fprintf(stderr, _("%s: bad size of attri name format: %u; expected %u\n"),
+		progname, len, dst_len);
+
+	return 1;
+}
+
+int
+xlog_print_trans_attri(
+	char				**ptr,
+	uint				src_len,
+	int				*i)
+{
+	struct xfs_attri_log_format	*src_f = NULL;
+	xlog_op_header_t		*head = NULL;
+	uint				dst_len;
+	int				error = 0;
+
+	dst_len = sizeof(struct xfs_attri_log_format);
+	if (src_len != dst_len) {
+		fprintf(stderr, _("%s: bad size of attri format: %u; expected %u\n"),
+				progname, src_len, dst_len);
+		return 1;
+	}
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * xfs_attri_log_format_t structure
+	 */
+	if ((src_f = (struct xfs_attri_log_format *)malloc(src_len)) == NULL) {
+		fprintf(stderr, _("%s: xlog_print_trans_attri: malloc failed\n"),
+				progname);
+		exit(1);
+	}
+	memmove((char*)src_f, *ptr, src_len);
+	*ptr += src_len;
+
+	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
+		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_value_len,
+				(unsigned long long)src_f->alfi_id);
+
+	if (src_f->alfi_name_len > 0) {
+		printf(_("\n"));
+		(*i)++;
+		head = (xlog_op_header_t *)*ptr;
+		xlog_print_op_header(head, *i, ptr);
+		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		if (error)
+			goto error;
+	}
+
+	if (src_f->alfi_value_len > 0) {
+		printf(_("\n"));
+		(*i)++;
+		head = (xlog_op_header_t *)*ptr;
+		xlog_print_op_header(head, *i, ptr);
+		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
+				src_f->alfi_value_len);
+	}
+error:
+	free(src_f);
+
+	return error;
+}	/* xlog_print_trans_attri */
+
+int
+xlog_print_trans_attri_name(
+	char				**ptr,
+	uint				src_len)
+{
+	struct xfs_parent_name_rec	*src_f = NULL;
+	uint				dst_len;
+
+	dst_len	= ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
+	if (dst_len != src_len) {
+		fprintf(stderr, _("%s: bad size of attri name format: %u; expected %u\n"),
+			progname, src_len, dst_len);
+		return 1;
+	}
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * xfs_parent_name_rec structure
+	 */
+	if ((src_f = (struct xfs_parent_name_rec *)malloc(src_len)) == NULL) {
+		fprintf(stderr, _("%s: xlog_print_trans_attri_name: malloc failed\n"), progname);
+		exit(1);
+	}
+	memmove((char*)src_f, *ptr, src_len);
+	*ptr += src_len;
+
+	printf(_("ATTRI:  #p_ino: %llu	p_gen: %u, p_diroffset: %u\n"),
+		be64_to_cpu(src_f->p_ino), be32_to_cpu(src_f->p_gen),
+				be32_to_cpu(src_f->p_diroffset));
+
+	free(src_f);
+	return 0;
+}	/* xlog_print_trans_attri */
+
+int
+xlog_print_trans_attri_value(
+	char				**ptr,
+	uint				src_len,
+	int				value_len)
+{
+	char				*f = NULL;
+
+	if ((f = (char *)malloc(src_len)) == NULL) {
+		fprintf(stderr, _("%s: xlog_print_trans_attri: malloc failed\n"), progname);
+		exit(1);
+	}
+
+	memcpy(f, *ptr, value_len);
+	printf(_("ATTRI:  value: %.*s\n"), value_len, f);
+	*ptr += src_len;
+
+	free(f);
+	return 0;
+}	/* xlog_print_trans_attri_value */
+
+void
+xlog_recover_print_attri(
+	xlog_recover_item_t	*item)
+{
+	struct xfs_attri_log_format	*f, *src_f = NULL;
+	uint				src_len, dst_len;
+
+	struct xfs_parent_name_rec 	*rec, *src_rec = NULL;
+	char				*value, *src_value = NULL;
+
+	int				region = 0;
+
+	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
+	src_len = item->ri_buf[region].i_len;
+
+	/*
+	 * An xfs_attri_log_format structure contains a attribute name and
+	 * variable length value  as the last field.
+	 */
+	dst_len = sizeof(struct xfs_attri_log_format);
+
+	if ((f = ((struct xfs_attri_log_format *)malloc(dst_len))) == NULL) {
+		fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
+			progname);
+		exit(1);
+	}
+	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
+		goto out;
+
+	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
+		f->alfi_size, f->alfi_name_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
+
+	if (f->alfi_name_len > 0) {
+		region++;
+		src_rec = (struct xfs_parent_name_rec *)item->ri_buf[region].i_addr;
+		src_len = item->ri_buf[region].i_len;
+
+		dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
+
+		if ((rec = ((struct xfs_parent_name_rec *)malloc(dst_len))) == NULL) {
+			fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
+				progname);
+			exit(1);
+		}
+		if (xfs_attri_copy_name_format((char *)src_rec, src_len, rec)) {
+			goto out;
+		}
+
+		printf(_("ATTRI:  #inode: %llu     gen: %u, offset: %u\n"),
+			be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen), be32_to_cpu(rec->p_diroffset));
+
+		free(rec);
+	}
+
+	if (f->alfi_value_len > 0) {
+		region++;
+		src_value = (char *)item->ri_buf[region].i_addr;
+
+		if ((value = ((char *)malloc(f->alfi_value_len))) == NULL) {
+			fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
+				progname);
+			exit(1);
+		}
+
+		memcpy((char *)value, (char *)src_value, f->alfi_value_len);
+		printf("ATTRI:  value: %.*s\n", f->alfi_value_len, value);
+
+		free(value);
+	}
+
+out:
+	free(f);
+
+}
+
+int
+xlog_print_trans_attrd(char **ptr, uint len)
+{
+	struct xfs_attrd_log_format *f;
+	struct xfs_attrd_log_format lbuf;
+	uint core_size = sizeof(struct xfs_attrd_log_format);
+
+	memcpy(&lbuf, *ptr, MIN(core_size, len));
+	f = &lbuf;
+	*ptr += len;
+	if (len >= core_size) {
+		printf(_("ATTRD:  #regs: %d	id: 0x%llx\n"),
+			f->alfd_size,
+			(unsigned long long)f->alfd_alf_id);
+		return 0;
+	} else {
+		printf(_("ATTRD: Not enough data to decode further\n"));
+		return 1;
+	}
+}	/* xlog_print_trans_attrd */
+
+void
+xlog_recover_print_attrd(
+	xlog_recover_item_t		*item)
+{
+	struct xfs_attrd_log_format	*f;
+
+	f = (struct xfs_attrd_log_format *)item->ri_buf[0].i_addr;
+
+	printf(_("	ATTRD:  #regs: %d	id: 0x%llx\n"),
+		f->alfd_size,
+		(unsigned long long)f->alfd_alf_id);
+}
diff --git a/logprint/logprint.h b/logprint/logprint.h
index 98ac0d4..a5d5396 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -52,4 +52,10 @@ extern void xlog_recover_print_bui(struct xlog_recover_item *item);
 extern int xlog_print_trans_bud(char **ptr, uint len);
 extern void xlog_recover_print_bud(struct xlog_recover_item *item);
 
+extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
+extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
+extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
+extern void xlog_recover_print_attri(xlog_recover_item_t *item);
+extern int xlog_print_trans_attrd(char **ptr, uint len);
+extern void xlog_recover_print_attrd(xlog_recover_item_t *item);
 #endif	/* LOGPRINT_H */
-- 
2.7.4
