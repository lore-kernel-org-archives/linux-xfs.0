Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CCD28341
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:43:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E13138F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:43:21 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 1wUcHGp2vl0vBU3X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:43:20 -0700 (PDT)
Subject: [PATCH 119/145] xfs_logprint: support refcount redo items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:43:15 -0700
Message-ID: <146612779547.16048.11591159287269642096.stgit@birch.djwong.org>
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

Print reference count update redo items.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 logprint/log_misc.c      |   11 +++
 logprint/log_print_all.c |   12 ++++
 logprint/log_redo.c      |  151 ++++++++++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |    5 ++
 4 files changed, 179 insertions(+)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index f6488d9..5389b72 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1008,6 +1008,17 @@ xlog_print_record(
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
index 717dccd..1539be1 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -381,3 +381,154 @@ xlog_recover_print_rud(
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
+	uint dst_len = sizeof(struct xfs_cui_log_format) +
+			(nextents - 1) * sizeof(struct xfs_phys_extent);
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
+	dst_len = sizeof(struct xfs_cui_log_format) +
+			(nextents - 1) * sizeof(struct xfs_phys_extent);
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
+	uint core_size = sizeof(struct xfs_cud_log_format) -
+		sizeof(struct xfs_phys_extent);
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * xfs_efd_log_format_t structure
+	 */
+	memmove(&lbuf, *ptr, MIN(core_size, len));
+	f = &lbuf;
+	*ptr += len;
+	if (len >= core_size) {
+		printf(_("CUD:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
+			f->cud_size, f->cud_nextents,
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
index 0c03c08..a1115e2 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -56,4 +56,9 @@ extern void xlog_recover_print_rui(struct xlog_recover_item *item);
 extern int xlog_print_trans_rud(char **ptr, uint len);
 extern void xlog_recover_print_rud(struct xlog_recover_item *item);
 
+extern int xlog_print_trans_cui(char **ptr, uint src_len, int continued);
+extern void xlog_recover_print_cui(struct xlog_recover_item *item);
+extern int xlog_print_trans_cud(char **ptr, uint len);
+extern void xlog_recover_print_cud(struct xlog_recover_item *item);
+
 #endif	/* LOGPRINT_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
