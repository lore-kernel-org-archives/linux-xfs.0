Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAFFC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjBPU7I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjBPU7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:59:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AC1505E5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:59:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D3A2B82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D83C433EF;
        Thu, 16 Feb 2023 20:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581139;
        bh=Wxf+sVc/7ZeuE5fyC27ctdwNyLHmTgk/OggyzIZzhX0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FMRpCeLb64N1+0yzILGHZz8deCKFcQQzAiPzGqiK4dP27xu7R+n6dXbhqp/YY/b1f
         4FLU8yldJkhDhJuKsejIayVEErYxn5U8yzedlZe5wUZt2zd/ylTH4HqUSmvBk8NOTw
         GODQowfAtGDOJBrQkl7ZJ4VmPhKOenqHAaG34nZFnsKQKbXQ/tsNNEkNvS7ft3GMSn
         myAgO/v55bqougZgsL8NCjxYh/oHNoev5xoN+UN+C3dJ7FjBAWHxKQn6/9DMnMFM3Q
         LJOzZsjD0JagpfeQ7O0JwUgYaLMXrvkUq1MKoJxHqP5MZtc8WFiYGu7wruxtn3SsJ4
         U4t9HSfF0imfg==
Date:   Thu, 16 Feb 2023 12:58:58 -0800
Subject: [PATCH 21/25] xfsprogs: Print pptrs in ATTRI items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879188.3476112.14960178578853220838.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies the ATTRI print routines to look for the parent pointer flag,
and print the log entry name as a parent pointer name record.  Values are printed as
strings since they contain the file name.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 logprint/log_redo.c |  193 +++++++++++++++++++++++++++++++++++++++++++++------
 logprint/logprint.h |    5 +
 2 files changed, 172 insertions(+), 26 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index b596af02..f7e9c9ad 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -674,6 +674,31 @@ xfs_attri_copy_log_format(
 	return 1;
 }
 
+/* iovec length must be 32-bit aligned */
+static inline size_t ATTR_NVEC_SIZE(size_t size)
+{
+	return round_up(size, sizeof(int32_t));
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
 int
 xlog_print_trans_attri(
 	char				**ptr,
@@ -714,7 +739,8 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
-		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len),
+						    src_f->alfi_attr_filter);
 		if (error)
 			goto error;
 	}
@@ -724,7 +750,8 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
-		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len),
+						    src_f->alfi_attr_filter);
 		if (error)
 			goto error;
 	}
@@ -735,7 +762,7 @@ xlog_print_trans_attri(
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
 		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
-				src_f->alfi_value_len);
+				src_f->alfi_value_len, src_f->alfi_attr_filter);
 	}
 error:
 	free(src_f);
@@ -746,13 +773,45 @@ xlog_print_trans_attri(
 int
 xlog_print_trans_attri_name(
 	char				**ptr,
-	uint				src_len)
+	uint				src_len,
+	uint				attr_flags)
 {
-	printf(_("ATTRI:  name len:%u\n"), src_len);
-	print_or_dump(*ptr, src_len);
+	struct xfs_parent_name_rec	*src_f = NULL;
+	uint				dst_len;
 
+	/*
+	 * If this is not a parent pointer, just do a bin dump
+	 */
+	if (!(attr_flags & XFS_ATTR_PARENT)) {
+		printf(_("ATTRI:  name len:%u\n"), src_len);
+		print_or_dump(*ptr, src_len);
+		goto out;
+	}
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
+
+	printf(_("ATTRI:  #p_ino: %llu	p_gen: %u, p_diroffset: %u\n"),
+		be64_to_cpu(src_f->p_ino), be32_to_cpu(src_f->p_gen),
+				be32_to_cpu(src_f->p_diroffset));
+
+	free(src_f);
+out:
 	*ptr += src_len;
-
 	return 0;
 }	/* xlog_print_trans_attri */
 
@@ -760,15 +819,32 @@ int
 xlog_print_trans_attri_value(
 	char				**ptr,
 	uint				src_len,
-	int				value_len)
+	int				value_len,
+	uint				attr_flags)
 {
 	int len = min(value_len, src_len);
+	char				*f = NULL;
 
-	printf(_("ATTRI:  value len:%u\n"), value_len);
-	print_or_dump(*ptr, len);
+	/*
+	 * If this is not a parent pointer, just do a bin dump
+	 */
+	if (!(attr_flags & XFS_ATTR_PARENT)) {
+		printf(_("ATTRI:  value len:%u\n"), value_len);
+		print_or_dump(*ptr, min(len, MAX_ATTR_VAL_PRINT));
+		goto out;
+	}
 
+	if ((f = (char *)malloc(src_len)) == NULL) {
+		fprintf(stderr, _("%s: xlog_print_trans_attri: malloc failed\n"), progname);
+		exit(1);
+	}
+
+	memcpy(f, *ptr, value_len);
+	printf(_("ATTRI:  value: %.*s\n"), value_len, f);
+
+	free(f);
+out:
 	*ptr += src_len;
-
 	return 0;
 }	/* xlog_print_trans_attri_value */
 
@@ -779,6 +855,9 @@ xlog_recover_print_attri(
 	struct xfs_attri_log_format	*f, *src_f = NULL;
 	uint				src_len, dst_len;
 
+	struct xfs_parent_name_rec 	*rec, *src_rec = NULL;
+	char				*value, *src_value = NULL;
+
 	int				region = 0;
 
 	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
@@ -803,27 +882,93 @@ xlog_recover_print_attri(
 
 	if (f->alfi_name_len > 0) {
 		region++;
-		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
-		print_or_dump((char *)item->ri_buf[region].i_addr,
-			       f->alfi_name_len);
+
+		if (f->alfi_attr_filter & XFS_ATTR_PARENT) {
+			src_rec = (struct xfs_parent_name_rec *)item->ri_buf[region].i_addr;
+			src_len = item->ri_buf[region].i_len;
+
+			dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
+
+			if ((rec = ((struct xfs_parent_name_rec *)malloc(dst_len))) == NULL) {
+				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
+					progname);
+				exit(1);
+			}
+			if (xfs_attri_copy_name_format((char *)src_rec, src_len, rec)) {
+				goto out;
+			}
+
+			printf(_("ATTRI:  #inode: %llu     gen: %u, offset: %u\n"),
+				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen),
+				be32_to_cpu(rec->p_diroffset));
+
+			free(rec);
+		}
+		else {
+			printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
+			print_or_dump((char *)item->ri_buf[region].i_addr,
+					f->alfi_name_len);
+		}
 	}
 
 	if (f->alfi_nname_len > 0) {
 		region++;
-		printf(_("ATTRI:  nname len:%u\n"), f->alfi_nname_len);
-		print_or_dump((char *)item->ri_buf[region].i_addr,
-			       f->alfi_nname_len);
+
+		if (f->alfi_attr_filter & XFS_ATTR_PARENT) {
+			src_rec = (struct xfs_parent_name_rec *)item->ri_buf[region].i_addr;
+			src_len = item->ri_buf[region].i_len;
+
+			dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
+
+			if ((rec = ((struct xfs_parent_name_rec *)malloc(dst_len))) == NULL) {
+				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
+					progname);
+				exit(1);
+			}
+			if (xfs_attri_copy_name_format((char *)src_rec, src_len, rec)) {
+				goto out;
+			}
+
+			printf(_("ATTRI:  new #inode: %llu     gen: %u, offset: %u\n"),
+				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen),
+				be32_to_cpu(rec->p_diroffset));
+
+			free(rec);
+		}
+		else {
+			printf(_("ATTRI:  nname len:%u\n"), f->alfi_nname_len);
+			print_or_dump((char *)item->ri_buf[region].i_addr,
+				       f->alfi_nname_len);
+		}
 	}
 
 	if (f->alfi_value_len > 0) {
-		int len = f->alfi_value_len;
-
-		if (len > MAX_ATTR_VAL_PRINT)
-			len = MAX_ATTR_VAL_PRINT;
-
 		region++;
-		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
-		print_or_dump((char *)item->ri_buf[region].i_addr, len);
+
+		if (f->alfi_attr_filter & XFS_ATTR_PARENT) {
+			src_value = (char *)item->ri_buf[region].i_addr;
+
+			if ((value = ((char *)malloc(f->alfi_value_len))) == NULL) {
+				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
+					progname);
+				exit(1);
+			}
+
+			memcpy((char *)value, (char *)src_value, f->alfi_value_len);
+			printf("ATTRI:  value: %.*s\n", f->alfi_value_len, value);
+
+			free(value);
+		}
+		else {
+			int len = f->alfi_value_len;
+
+			if (len > MAX_ATTR_VAL_PRINT)
+				len = MAX_ATTR_VAL_PRINT;
+
+			printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
+			print_or_dump((char *)item->ri_buf[region].i_addr,
+					len);
+		}
 	}
 
 out:
diff --git a/logprint/logprint.h b/logprint/logprint.h
index b4479c24..b8e1c932 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -59,8 +59,9 @@ extern void xlog_recover_print_bud(struct xlog_recover_item *item);
 #define MAX_ATTR_VAL_PRINT	128
 
 extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
-extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
-extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
+extern int xlog_print_trans_attri_name(char **ptr, uint src_len, uint attr_flags);
+extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len,
+					uint attr_flags);
 extern void xlog_recover_print_attri(struct xlog_recover_item *item);
 extern int xlog_print_trans_attrd(char **ptr, uint len);
 extern void xlog_recover_print_attrd(struct xlog_recover_item *item);

