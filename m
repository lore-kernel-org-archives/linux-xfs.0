Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF2FC433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBD8F2087D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wvYmOlAG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgH0Ab3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:31:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55502 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgH0Ab1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:31:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0VPTd069907
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:31:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=su1FJUcRCMG2J43gwE1zTWSIlqrLOh5O4yasNMw2T40=;
 b=wvYmOlAGlILKxV3c2cXt80LyRYj68VNNnbzQwokiMIkMQvFnk45fRd8kjbjSCvsvgGDe
 gPc9SR2xVlUpeFfXUVhc5lIAmfD0hI3jRx+CUoh26QgZsxM0UsA0+HLVPG3wvGPdc6pz
 MhbrFe7xSRsFZnWG1COroVC5U4Z0JmMg4iwbBRJGiJiTHibAt4wncP9U9wIz4QD7LBVS
 SmtgHFpBwdL2omoAJZTEcS+sCUa4tEHK4IbyNJaruurOHP2Ec2cW4yruZ+X72sQekC15
 CudPI+1XWIPuaXqY16FnR9SAf2KrgvOxdmr+uxgnYLe/vd4PzeHasRaOF/eh0yoGjGY+ vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 333dbs3e37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:31:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0BTxV038463
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 333r9mk55n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07R0TNJs019441
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:23 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:23 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 31/32] [RFC] xfsprogs: Add log item printing for ATTRI and ATTRD
Date:   Wed, 26 Aug 2020 17:28:55 -0700
Message-Id: <20200827002856.1131-32-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=3 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=3
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch implements a new set of log printing functions to print the
ATTRI and ATTRD items and vectors in the log.  These will be used during
log dump and log recover operations.

RFC: Though most attributes are strings, the attribute operations accept
any binary payload, so we cannot assume them printable.  This was done
intentionally in preparation for parent pointers.  And until parent
pointers get here, attributes have no discernible format.  So the print
routines are just a simple hex dump for now.  It's not pretty, but works
for now.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 logprint/log_misc.c      |  31 +++++++-
 logprint/log_print_all.c |  12 +++
 logprint/log_redo.c      | 197 +++++++++++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |  10 +++
 4 files changed, 249 insertions(+), 1 deletion(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index be88988..2c73af0 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -54,11 +54,29 @@ print_stars(void)
 	   "***********************************\n");
 }	/* print_stars */
 
+void
+print_hex_dump(char *ptr, int len) {
+	int i = 0;
+
+	for (i = 0; i < len; i++) {
+		if (i % 16 == 0)
+			printf("%08x ", i);
+
+		printf("%02x", ptr[i]);
+
+		if ((i+1)%16 == 0)
+			printf("\n");
+		else if ((i+1)%2 == 0)
+			printf(" ");
+	}
+	printf("\n");
+}
+
 /*
  * Given a pointer to a data segment, print out the data as if it were
  * a log operation header.
  */
-static void
+void
 xlog_print_op_header(xlog_op_header_t	*op_head,
 		     int		i,
 		     char		**ptr)
@@ -949,6 +967,17 @@ xlog_print_record(
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
index 1924a0a..2b3f035 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -402,6 +402,12 @@ xlog_recover_print_logitem(
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
@@ -454,6 +460,12 @@ xlog_recover_print_item(
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
index 297e203..3e790e2 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -8,6 +8,7 @@
 #include "libxlog.h"
 
 #include "logprint.h"
+#include "xfs_attr_item.h"
 
 /* Extent Free Items */
 
@@ -653,3 +654,199 @@ xlog_recover_print_bud(
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
+	printf(_("ATTRI:  name len:%u\n"), src_len);
+	print_hex_dump(*ptr, src_len);
+
+	*ptr += src_len;
+
+	return 0;
+}	/* xlog_print_trans_attri */
+
+int
+xlog_print_trans_attri_value(
+	char				**ptr,
+	uint				src_len,
+	int				value_len)
+{
+	int len = value_len;
+
+	if (len > MAX_ATTR_VAL_PRINT)
+		len = MAX_ATTR_VAL_PRINT;
+
+	printf(_("ATTRI:  value len:%u\n"), value_len);
+	print_hex_dump(*ptr, len);
+
+	*ptr += src_len;
+
+	return 0;
+}	/* xlog_print_trans_attri_value */
+
+void
+xlog_recover_print_attri(
+	struct xlog_recover_item	*item)
+{
+	struct xfs_attri_log_format	*f, *src_f = NULL;
+	uint				src_len, dst_len;
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
+		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
+		print_hex_dump((char *)item->ri_buf[region].i_addr,
+			       f->alfi_name_len);
+	}
+
+	if (f->alfi_value_len > 0) {
+		int len = f->alfi_value_len;
+
+		if (len > MAX_ATTR_VAL_PRINT)
+			len = MAX_ATTR_VAL_PRINT;
+
+		region++;
+		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
+		print_hex_dump((char *)item->ri_buf[region].i_addr, len);
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
+	struct xlog_recover_item		*item)
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
index ee85bfe..2e256bd 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -28,6 +28,7 @@ extern void xfs_log_print_trans(struct xlog *, int);
 extern void print_xlog_record_line(void);
 extern void print_xlog_op_line(void);
 extern void print_stars(void);
+extern void print_hex_dump(char* ptr, int len);
 
 extern struct xfs_inode_log_format *
 	xfs_inode_item_format_convert(char *, uint, struct xfs_inode_log_format *);
@@ -52,4 +53,13 @@ extern void xlog_recover_print_bui(struct xlog_recover_item *item);
 extern int xlog_print_trans_bud(char **ptr, uint len);
 extern void xlog_recover_print_bud(struct xlog_recover_item *item);
 
+#define MAX_ATTR_VAL_PRINT	128
+
+extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
+extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
+extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
+extern void xlog_recover_print_attri(struct xlog_recover_item *item);
+extern int xlog_print_trans_attrd(char **ptr, uint len);
+extern void xlog_recover_print_attrd(struct xlog_recover_item *item);
+extern void xlog_print_op_header(xlog_op_header_t *op_head, int i, char **ptr);
 #endif	/* LOGPRINT_H */
-- 
2.7.4

