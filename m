Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46519 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbcJYXGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:06:06 -0400
Subject: [PATCH 23/39] xfs_logprint: support refcount redo items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:06:02 -0700
Message-ID: <147743676212.11035.6341580285293427233.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Print reference count update redo items.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 logprint/log_misc.c      |   11 +++
 logprint/log_print_all.c |   12 ++++
 logprint/log_redo.c      |  148 ++++++++++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |    5 ++
 4 files changed, 176 insertions(+)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index dbe5729..8284206 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -962,6 +962,17 @@ xlog_print_record(
 					be32_to_cpu(op_head->oh_len));
 			break;
 		    }
+		    case XFS_LI_CUI: {
+			skip = xlog_print_trans_cui(&ptr,
+					be32_to_cpu(op_head->oh_len),
+					continued);
+			break;
+		    }
+		    case XFS_LI_CUD: {
+			skip = xlog_print_trans_cud(&ptr,
+					be32_to_cpu(op_head->oh_len));
+			break;
+		    }
 		    case XFS_LI_QUOTAOFF: {
 			skip = xlog_print_trans_qoff(&ptr,
 					be32_to_cpu(op_head->oh_len));
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 46952c4..eb3e326 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -418,6 +418,12 @@ xlog_recover_print_logitem(
 	case XFS_LI_RUI:
 		xlog_recover_print_rui(item);
 		break;
+	case XFS_LI_CUD:
+		xlog_recover_print_cud(item);
+		break;
+	case XFS_LI_CUI:
+		xlog_recover_print_cui(item);
+		break;
 	case XFS_LI_DQUOT:
 		xlog_recover_print_dquot(item);
 		break;
@@ -458,6 +464,12 @@ xlog_recover_print_item(
 	case XFS_LI_RUI:
 		printf("RUI");
 		break;
+	case XFS_LI_CUD:
+		printf("CUD");
+		break;
+	case XFS_LI_CUI:
+		printf("CUI");
+		break;
 	case XFS_LI_DQUOT:
 		printf("DQ ");
 		break;
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 40e0727..6be073e 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -378,3 +378,151 @@ xlog_recover_print_rud(
 	f = item->ri_buf[0].i_addr;
 	xlog_print_trans_rud(&f, sizeof(struct xfs_rud_log_format));
 }
+
+/* Reference Count Update Items */
+
+static int
+xfs_cui_copy_format(
+	char			  *buf,
+	uint			  len,
+	struct xfs_cui_log_format *dst_fmt,
+	int			  continued)
+{
+	uint nextents = ((struct xfs_cui_log_format *)buf)->cui_nextents;
+	uint dst_len = xfs_cui_log_format_sizeof(nextents);
+
+	if (len == dst_len || continued) {
+		memcpy((char *)dst_fmt, buf, len);
+		return 0;
+	}
+	fprintf(stderr, _("%s: bad size of CUI format: %u; expected %u; nextents = %u\n"),
+		progname, len, dst_len, nextents);
+	return 1;
+}
+
+int
+xlog_print_trans_cui(
+	char			**ptr,
+	uint			src_len,
+	int			continued)
+{
+	struct xfs_cui_log_format	*src_f, *f = NULL;
+	uint			dst_len;
+	uint			nextents;
+	struct xfs_phys_extent	*ex;
+	int			i;
+	int			error = 0;
+	int			core_size;
+
+	core_size = offsetof(struct xfs_cui_log_format, cui_extents);
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * struct xfs_cui_log_format structure
+	 */
+	src_f = malloc(src_len);
+	if (src_f == NULL) {
+		fprintf(stderr, _("%s: %s: malloc failed\n"),
+			progname, __func__);
+		exit(1);
+	}
+	memmove((char*)src_f, *ptr, src_len);
+	*ptr += src_len;
+
+	/* convert to native format */
+	nextents = src_f->cui_nextents;
+	dst_len = xfs_cui_log_format_sizeof(nextents);
+
+	if (continued && src_len < core_size) {
+		printf(_("CUI: Not enough data to decode further\n"));
+		error = 1;
+		goto error;
+	}
+
+	f = malloc(dst_len);
+	if (f == NULL) {
+		fprintf(stderr, _("%s: %s: malloc failed\n"),
+			progname, __func__);
+		exit(1);
+	}
+	if (xfs_cui_copy_format((char *)src_f, src_len, f, continued)) {
+		error = 1;
+		goto error;
+	}
+
+	printf(_("CUI:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
+		f->cui_size, f->cui_nextents, (unsigned long long)f->cui_id);
+
+	if (continued) {
+		printf(_("CUI extent data skipped (CONTINUE set, no space)\n"));
+		goto error;
+	}
+
+	ex = f->cui_extents;
+	for (i=0; i < f->cui_nextents; i++) {
+		printf("(s: 0x%llx, l: %d, f: 0x%x) ",
+			(unsigned long long)ex->pe_startblock, ex->pe_len,
+			ex->pe_flags);
+		printf("\n");
+		ex++;
+	}
+error:
+	free(src_f);
+	free(f);
+	return error;
+}
+
+void
+xlog_recover_print_cui(
+	struct xlog_recover_item	*item)
+{
+	char				*src_f;
+	uint				src_len;
+
+	src_f = item->ri_buf[0].i_addr;
+	src_len = item->ri_buf[0].i_len;
+
+	xlog_print_trans_cui(&src_f, src_len, 0);
+}
+
+int
+xlog_print_trans_cud(
+	char				**ptr,
+	uint				len)
+{
+	struct xfs_cud_log_format	*f;
+	struct xfs_cud_log_format	lbuf;
+
+	/* size without extents at end */
+	uint core_size = sizeof(struct xfs_cud_log_format);
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * xfs_efd_log_format_t structure
+	 */
+	memmove(&lbuf, *ptr, MIN(core_size, len));
+	f = &lbuf;
+	*ptr += len;
+	if (len >= core_size) {
+		printf(_("CUD:  #regs: %d	                 id: 0x%llx\n"),
+			f->cud_size,
+			(unsigned long long)f->cud_cui_id);
+
+		/* don't print extents as they are not used */
+
+		return 0;
+	} else {
+		printf(_("CUD: Not enough data to decode further\n"));
+		return 1;
+	}
+}
+
+void
+xlog_recover_print_cud(
+	struct xlog_recover_item	*item)
+{
+	char				*f;
+
+	f = item->ri_buf[0].i_addr;
+	xlog_print_trans_cud(&f, sizeof(struct xfs_cud_log_format));
+}
diff --git a/logprint/logprint.h b/logprint/logprint.h
index bdd0ee1..ae63c2e 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -54,4 +54,9 @@ extern void xlog_recover_print_rui(struct xlog_recover_item *item);
 extern int xlog_print_trans_rud(char **ptr, uint len);
 extern void xlog_recover_print_rud(struct xlog_recover_item *item);
 
+extern int xlog_print_trans_cui(char **ptr, uint src_len, int continued);
+extern void xlog_recover_print_cui(struct xlog_recover_item *item);
+extern int xlog_print_trans_cud(char **ptr, uint len);
+extern void xlog_recover_print_cud(struct xlog_recover_item *item);
+
 #endif	/* LOGPRINT_H */

