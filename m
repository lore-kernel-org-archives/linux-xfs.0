Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38D038264
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:52:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E263B8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:52:43 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pG0581a7AOq0UA1A (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:52:41 -0700 (PDT)
Subject: [PATCH 56/71] xfs_logprint: support bmap redo items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:52:37 -0700
Message-ID: <147216915771.4420.14619176682224551855.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Print block mapping update redo items.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 logprint/log_misc.c      |   11 +++
 logprint/log_print_all.c |   12 ++++
 logprint/log_redo.c      |  151 ++++++++++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |    5 ++
 4 files changed, 179 insertions(+)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 5389b72..c10a1d1 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1019,6 +1019,17 @@ xlog_print_record(
 					be32_to_cpu(op_head->oh_len));
 			break;
 		    }
+		    case XFS_LI_BUI: {
+			skip = xlog_print_trans_bui(&ptr,
+					be32_to_cpu(op_head->oh_len),
+					continued);
+			break;
+		    }
+		    case XFS_LI_BUD: {
+			skip = xlog_print_trans_bud(&ptr,
+					be32_to_cpu(op_head->oh_len));
+			break;
+		    }
 		    case XFS_LI_QUOTAOFF: {
 			skip = xlog_print_trans_qoff(&ptr,
 					be32_to_cpu(op_head->oh_len));
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index eb3e326..f49316e 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -424,6 +424,12 @@ xlog_recover_print_logitem(
 	case XFS_LI_CUI:
 		xlog_recover_print_cui(item);
 		break;
+	case XFS_LI_BUD:
+		xlog_recover_print_bud(item);
+		break;
+	case XFS_LI_BUI:
+		xlog_recover_print_bui(item);
+		break;
 	case XFS_LI_DQUOT:
 		xlog_recover_print_dquot(item);
 		break;
@@ -470,6 +476,12 @@ xlog_recover_print_item(
 	case XFS_LI_CUI:
 		printf("CUI");
 		break;
+	case XFS_LI_BUD:
+		printf("BUD");
+		break;
+	case XFS_LI_BUI:
+		printf("BUI");
+		break;
 	case XFS_LI_DQUOT:
 		printf("DQ ");
 		break;
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 6a2e30a..dcca427 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -530,3 +530,154 @@ xlog_recover_print_cud(
 	f = item->ri_buf[0].i_addr;
 	xlog_print_trans_cud(&f, sizeof(struct xfs_cud_log_format));
 }
+
+/* Block Mapping Update Items */
+
+static int
+xfs_bui_copy_format(
+	char			  *buf,
+	uint			  len,
+	struct xfs_bui_log_format *dst_fmt,
+	int			  continued)
+{
+	uint nextents = ((struct xfs_bui_log_format *)buf)->bui_nextents;
+	uint dst_len = sizeof(struct xfs_bui_log_format) +
+			(nextents - 1) * sizeof(struct xfs_map_extent);
+
+	if (len == dst_len || continued) {
+		memcpy((char *)dst_fmt, buf, len);
+		return 0;
+	}
+	fprintf(stderr, _("%s: bad size of BUI format: %u; expected %u; nextents = %u\n"),
+		progname, len, dst_len, nextents);
+	return 1;
+}
+
+int
+xlog_print_trans_bui(
+	char			**ptr,
+	uint			src_len,
+	int			continued)
+{
+	struct xfs_bui_log_format	*src_f, *f = NULL;
+	uint			dst_len;
+	uint			nextents;
+	struct xfs_map_extent	*ex;
+	int			i;
+	int			error = 0;
+	int			core_size;
+
+	core_size = offsetof(struct xfs_bui_log_format, bui_extents);
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * struct xfs_bui_log_format structure
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
+	nextents = src_f->bui_nextents;
+	dst_len = sizeof(struct xfs_bui_log_format) +
+			(nextents - 1) * sizeof(struct xfs_map_extent);
+
+	if (continued && src_len < core_size) {
+		printf(_("BUI: Not enough data to decode further\n"));
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
+	if (xfs_bui_copy_format((char *)src_f, src_len, f, continued)) {
+		error = 1;
+		goto error;
+	}
+
+	printf(_("BUI:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
+		f->bui_size, f->bui_nextents, (unsigned long long)f->bui_id);
+
+	if (continued) {
+		printf(_("BUI extent data skipped (CONTINUE set, no space)\n"));
+		goto error;
+	}
+
+	ex = f->bui_extents;
+	for (i=0; i < f->bui_nextents; i++) {
+		printf("(s: 0x%llx, l: %d, own: %lld, off: %llu, f: 0x%x) ",
+			(unsigned long long)ex->me_startblock, ex->me_len,
+			(long long)ex->me_owner,
+			(unsigned long long)ex->me_startoff, ex->me_flags);
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
+xlog_recover_print_bui(
+	struct xlog_recover_item	*item)
+{
+	char				*src_f;
+	uint				src_len;
+
+	src_f = item->ri_buf[0].i_addr;
+	src_len = item->ri_buf[0].i_len;
+
+	xlog_print_trans_bui(&src_f, src_len, 0);
+}
+
+int
+xlog_print_trans_bud(
+	char				**ptr,
+	uint				len)
+{
+	struct xfs_bud_log_format	*f;
+	struct xfs_bud_log_format	lbuf;
+
+	/* size without extents at end */
+	uint core_size = sizeof(struct xfs_bud_log_format);
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * xfs_efd_log_format_t structure
+	 */
+	memmove(&lbuf, *ptr, MIN(core_size, len));
+	f = &lbuf;
+	*ptr += len;
+	if (len >= core_size) {
+		printf(_("BUD:  #regs: %d	                 id: 0x%llx\n"),
+			f->bud_size,
+			(unsigned long long)f->bud_bui_id);
+
+		/* don't print extents as they are not used */
+
+		return 0;
+	} else {
+		printf(_("BUD: Not enough data to decode further\n"));
+		return 1;
+	}
+}
+
+void
+xlog_recover_print_bud(
+	struct xlog_recover_item	*item)
+{
+	char				*f;
+
+	f = item->ri_buf[0].i_addr;
+	xlog_print_trans_bud(&f, sizeof(struct xfs_bud_log_format));
+}
diff --git a/logprint/logprint.h b/logprint/logprint.h
index a1115e2..81feff3 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -61,4 +61,9 @@ extern void xlog_recover_print_cui(struct xlog_recover_item *item);
 extern int xlog_print_trans_cud(char **ptr, uint len);
 extern void xlog_recover_print_cud(struct xlog_recover_item *item);
 
+extern int xlog_print_trans_bui(char **ptr, uint src_len, int continued);
+extern void xlog_recover_print_bui(struct xlog_recover_item *item);
+extern int xlog_print_trans_bud(char **ptr, uint len);
+extern void xlog_recover_print_bud(struct xlog_recover_item *item);
+
 #endif	/* LOGPRINT_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
