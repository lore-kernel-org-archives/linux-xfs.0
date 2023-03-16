Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B2BC6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCPTcT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCPTcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:32:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A922E500E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83D04B822F3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4226CC433D2;
        Thu, 16 Mar 2023 19:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995129;
        bh=KE4WdxMUWFKmeLNYsL2kE10GM4Wd1aTBlhTHXOAUi9U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=vIRH0YIo/i/2jkozvRDD/U4xUCbdMxUbDzz0jAyNyZZDRjvXEEajQ08B0t/XCzu0Z
         Yh7gGRgPmKXwebmHxQQL3j5RP9DNIBqqdC2FlfKC6+APHKbGp9SRpqY6jAfVBnr6vX
         nBbinnxPCXQQ2NVpuym/zut1TphLY33l7CADkCpwrvtLgHioZxxihGtCTxn98hlufX
         BZkwPU3h5/TVNfwjKmgfXENRTZO+zc8FxwbuQ00TyetPYbMvahOg3TvOvKPtRGplKf
         NNR7LCsi4BJr2ztau1d1WOGpd8a1fEt1N7jHWjcGLspvHRlLoiRlNDvxmzBQDWSYY+
         v8zDuGTRjwyFw==
Date:   Thu, 16 Mar 2023 12:32:08 -0700
Subject: [PATCH 1/4] xfs: revert "xfsprogs: Print pptrs in ATTRI items"
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416806.17000.4113016671170150035.stgit@frogsfrogsfrogs>
In-Reply-To: <167899416793.17000.8105050564560343480.stgit@frogsfrogsfrogs>
References: <167899416793.17000.8105050564560343480.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Parent pointers are stored inside extended attributes, which means that
they're a higher level data structure.  logprint shouldn't be reporting
parent pointers as "ATTRI" items, so let's replace all that with proper
helpers that will decode a parent pointer xattri log item.

But first, get rid of all this code that adds a bunch of repetitive
logic and unnecessary heap allocations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_redo.c |  193 ++++++---------------------------------------------
 logprint/logprint.h |    5 +
 2 files changed, 26 insertions(+), 172 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index f7e9c9ad9..b596af02c 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -674,31 +674,6 @@ xfs_attri_copy_log_format(
 	return 1;
 }
 
-/* iovec length must be 32-bit aligned */
-static inline size_t ATTR_NVEC_SIZE(size_t size)
-{
-	return round_up(size, sizeof(int32_t));
-}
-
-static int
-xfs_attri_copy_name_format(
-	char                            *buf,
-	uint                            len,
-	struct xfs_parent_name_rec     *dst_attri_fmt)
-{
-	uint dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
-
-	if (len == dst_len) {
-		memcpy((char *)dst_attri_fmt, buf, len);
-		return 0;
-	}
-
-	fprintf(stderr, _("%s: bad size of attri name format: %u; expected %u\n"),
-		progname, len, dst_len);
-
-	return 1;
-}
-
 int
 xlog_print_trans_attri(
 	char				**ptr,
@@ -739,8 +714,7 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
-		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len),
-						    src_f->alfi_attr_filter);
+		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
 		if (error)
 			goto error;
 	}
@@ -750,8 +724,7 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
-		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len),
-						    src_f->alfi_attr_filter);
+		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
 		if (error)
 			goto error;
 	}
@@ -762,7 +735,7 @@ xlog_print_trans_attri(
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
 		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
-				src_f->alfi_value_len, src_f->alfi_attr_filter);
+				src_f->alfi_value_len);
 	}
 error:
 	free(src_f);
@@ -773,45 +746,13 @@ xlog_print_trans_attri(
 int
 xlog_print_trans_attri_name(
 	char				**ptr,
-	uint				src_len,
-	uint				attr_flags)
+	uint				src_len)
 {
-	struct xfs_parent_name_rec	*src_f = NULL;
-	uint				dst_len;
+	printf(_("ATTRI:  name len:%u\n"), src_len);
+	print_or_dump(*ptr, src_len);
 
-	/*
-	 * If this is not a parent pointer, just do a bin dump
-	 */
-	if (!(attr_flags & XFS_ATTR_PARENT)) {
-		printf(_("ATTRI:  name len:%u\n"), src_len);
-		print_or_dump(*ptr, src_len);
-		goto out;
-	}
-
-	dst_len	= ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
-	if (dst_len != src_len) {
-		fprintf(stderr, _("%s: bad size of attri name format: %u; expected %u\n"),
-			progname, src_len, dst_len);
-		return 1;
-	}
-
-	/*
-	 * memmove to ensure 8-byte alignment for the long longs in
-	 * xfs_parent_name_rec structure
-	 */
-	if ((src_f = (struct xfs_parent_name_rec *)malloc(src_len)) == NULL) {
-		fprintf(stderr, _("%s: xlog_print_trans_attri_name: malloc failed\n"), progname);
-		exit(1);
-	}
-	memmove((char*)src_f, *ptr, src_len);
-
-	printf(_("ATTRI:  #p_ino: %llu	p_gen: %u, p_diroffset: %u\n"),
-		be64_to_cpu(src_f->p_ino), be32_to_cpu(src_f->p_gen),
-				be32_to_cpu(src_f->p_diroffset));
-
-	free(src_f);
-out:
 	*ptr += src_len;
+
 	return 0;
 }	/* xlog_print_trans_attri */
 
@@ -819,32 +760,15 @@ int
 xlog_print_trans_attri_value(
 	char				**ptr,
 	uint				src_len,
-	int				value_len,
-	uint				attr_flags)
+	int				value_len)
 {
 	int len = min(value_len, src_len);
-	char				*f = NULL;
 
-	/*
-	 * If this is not a parent pointer, just do a bin dump
-	 */
-	if (!(attr_flags & XFS_ATTR_PARENT)) {
-		printf(_("ATTRI:  value len:%u\n"), value_len);
-		print_or_dump(*ptr, min(len, MAX_ATTR_VAL_PRINT));
-		goto out;
-	}
+	printf(_("ATTRI:  value len:%u\n"), value_len);
+	print_or_dump(*ptr, len);
 
-	if ((f = (char *)malloc(src_len)) == NULL) {
-		fprintf(stderr, _("%s: xlog_print_trans_attri: malloc failed\n"), progname);
-		exit(1);
-	}
-
-	memcpy(f, *ptr, value_len);
-	printf(_("ATTRI:  value: %.*s\n"), value_len, f);
-
-	free(f);
-out:
 	*ptr += src_len;
+
 	return 0;
 }	/* xlog_print_trans_attri_value */
 
@@ -855,9 +779,6 @@ xlog_recover_print_attri(
 	struct xfs_attri_log_format	*f, *src_f = NULL;
 	uint				src_len, dst_len;
 
-	struct xfs_parent_name_rec 	*rec, *src_rec = NULL;
-	char				*value, *src_value = NULL;
-
 	int				region = 0;
 
 	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
@@ -882,93 +803,27 @@ xlog_recover_print_attri(
 
 	if (f->alfi_name_len > 0) {
 		region++;
-
-		if (f->alfi_attr_filter & XFS_ATTR_PARENT) {
-			src_rec = (struct xfs_parent_name_rec *)item->ri_buf[region].i_addr;
-			src_len = item->ri_buf[region].i_len;
-
-			dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
-
-			if ((rec = ((struct xfs_parent_name_rec *)malloc(dst_len))) == NULL) {
-				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
-					progname);
-				exit(1);
-			}
-			if (xfs_attri_copy_name_format((char *)src_rec, src_len, rec)) {
-				goto out;
-			}
-
-			printf(_("ATTRI:  #inode: %llu     gen: %u, offset: %u\n"),
-				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen),
-				be32_to_cpu(rec->p_diroffset));
-
-			free(rec);
-		}
-		else {
-			printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
-			print_or_dump((char *)item->ri_buf[region].i_addr,
-					f->alfi_name_len);
-		}
+		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
+		print_or_dump((char *)item->ri_buf[region].i_addr,
+			       f->alfi_name_len);
 	}
 
 	if (f->alfi_nname_len > 0) {
 		region++;
-
-		if (f->alfi_attr_filter & XFS_ATTR_PARENT) {
-			src_rec = (struct xfs_parent_name_rec *)item->ri_buf[region].i_addr;
-			src_len = item->ri_buf[region].i_len;
-
-			dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
-
-			if ((rec = ((struct xfs_parent_name_rec *)malloc(dst_len))) == NULL) {
-				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
-					progname);
-				exit(1);
-			}
-			if (xfs_attri_copy_name_format((char *)src_rec, src_len, rec)) {
-				goto out;
-			}
-
-			printf(_("ATTRI:  new #inode: %llu     gen: %u, offset: %u\n"),
-				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen),
-				be32_to_cpu(rec->p_diroffset));
-
-			free(rec);
-		}
-		else {
-			printf(_("ATTRI:  nname len:%u\n"), f->alfi_nname_len);
-			print_or_dump((char *)item->ri_buf[region].i_addr,
-				       f->alfi_nname_len);
-		}
+		printf(_("ATTRI:  nname len:%u\n"), f->alfi_nname_len);
+		print_or_dump((char *)item->ri_buf[region].i_addr,
+			       f->alfi_nname_len);
 	}
 
 	if (f->alfi_value_len > 0) {
+		int len = f->alfi_value_len;
+
+		if (len > MAX_ATTR_VAL_PRINT)
+			len = MAX_ATTR_VAL_PRINT;
+
 		region++;
-
-		if (f->alfi_attr_filter & XFS_ATTR_PARENT) {
-			src_value = (char *)item->ri_buf[region].i_addr;
-
-			if ((value = ((char *)malloc(f->alfi_value_len))) == NULL) {
-				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
-					progname);
-				exit(1);
-			}
-
-			memcpy((char *)value, (char *)src_value, f->alfi_value_len);
-			printf("ATTRI:  value: %.*s\n", f->alfi_value_len, value);
-
-			free(value);
-		}
-		else {
-			int len = f->alfi_value_len;
-
-			if (len > MAX_ATTR_VAL_PRINT)
-				len = MAX_ATTR_VAL_PRINT;
-
-			printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
-			print_or_dump((char *)item->ri_buf[region].i_addr,
-					len);
-		}
+		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
+		print_or_dump((char *)item->ri_buf[region].i_addr, len);
 	}
 
 out:
diff --git a/logprint/logprint.h b/logprint/logprint.h
index b8e1c9328..b4479c240 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -59,9 +59,8 @@ extern void xlog_recover_print_bud(struct xlog_recover_item *item);
 #define MAX_ATTR_VAL_PRINT	128
 
 extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
-extern int xlog_print_trans_attri_name(char **ptr, uint src_len, uint attr_flags);
-extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len,
-					uint attr_flags);
+extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
+extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
 extern void xlog_recover_print_attri(struct xlog_recover_item *item);
 extern int xlog_print_trans_attrd(char **ptr, uint len);
 extern void xlog_recover_print_attrd(struct xlog_recover_item *item);

