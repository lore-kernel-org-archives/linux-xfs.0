Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC82C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjEZCVj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjEZCVi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:21:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16E0B2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72DEA64C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28AFC433EF;
        Fri, 26 May 2023 02:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067695;
        bh=wFL97SFPOMPzyf6NDCVCHFJpOJGzV1YH7/b6K1Banqs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=MaNcq/RWYV7jA3GL6KKP4gAl8BNbQNHFw+cwfni+4dlOf0qDNy7fqZqvvZ4H5Koaw
         s0jNJffpr5JRkqak29gJmEfxXlc/Xl6uVzxp7YmAXWh35Zuy8Bu1aBLxIJHTisGaAg
         4oGHGnmX5mlTS/07H4vsfLRiv2aV+RhvhyZa1cvBAGoSR3bQ1x543Kz2gutSQCLVkh
         R2ZXOlpaLXxGs0jSJYNjnFBeUAbyXhHQoUZNFw01jYdYkNN3fTzXBmlNOcVr4iCzqQ
         +tBPAtO3dppcyri1TnbAb4mxYGEOJ2xDDwo7gEvnOQ5vwdhn/wo5PjIsn5tTngFPuC
         jmUu+E01p7JAw==
Date:   Thu, 25 May 2023 19:21:35 -0700
Subject: [PATCH 09/10] xfs_logprint: dump new attr log item fields
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077557.3749126.13546809186832151071.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
References: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Dump the new extended attribute log item fields.  This was split out
from the previous patch to make libxfs resyncing easier.  This code
needs more cleaning, which we'll do in the next few patches before
moving on to the parent pointer code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_redo.c |  132 +++++++++++++++++++++++++++++++++++++++++----------
 logprint/logprint.h |    6 ++
 2 files changed, 111 insertions(+), 27 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 770485df75d..7531c6117bd 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -674,6 +674,12 @@ xfs_attri_copy_log_format(
 	return 1;
 }
 
+static inline unsigned int
+xfs_attr_log_item_op(const struct xfs_attri_log_format *attrp)
+{
+	return attrp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
+
 int
 xlog_print_trans_attri(
 	char				**ptr,
@@ -683,6 +689,10 @@ xlog_print_trans_attri(
 	struct xfs_attri_log_format	*src_f = NULL;
 	xlog_op_header_t		*head = NULL;
 	uint				dst_len;
+	unsigned int			name_len = 0;
+	unsigned int			new_name_len = 0;
+	unsigned int			value_len = 0;
+	unsigned int			new_value_len = 0;
 	int				error = 0;
 
 	dst_len = sizeof(struct xfs_attri_log_format);
@@ -705,27 +715,67 @@ xlog_print_trans_attri(
 	memmove((char*)src_f, *ptr, src_len);
 	*ptr += src_len;
 
-	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
-		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_value_len,
-				(unsigned long long)src_f->alfi_id);
+	if (xfs_attr_log_item_op(src_f) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
+		name_len      = src_f->alfi_old_name_len;
+		new_name_len  = src_f->alfi_new_name_len;
+		value_len     = src_f->alfi_value_len;
+		new_value_len = src_f->alfi_new_value_len;
+	} else {
+		name_len      = src_f->alfi_name_len;
+		value_len     = src_f->alfi_value_len;
+	}
+
+	printf(_("ATTRI:  #regs: %d	name_len: %u, new_name_len: %u, value_len: %u, new_value_len: %u  id: 0x%llx\n"),
+			src_f->alfi_size,
+			name_len,
+			new_name_len,
+			value_len,
+			new_value_len,
+			(unsigned long long)src_f->alfi_id);
+
+	if (name_len > 0) {
+		printf(_("\n"));
+		(*i)++;
+		head = (xlog_op_header_t *)*ptr;
+		xlog_print_op_header(head, *i, ptr);
+		error = xlog_print_trans_attri_name(ptr,
+				be32_to_cpu(head->oh_len), "name");
+		if (error)
+			goto error;
+	}
 
-	if (src_f->alfi_name_len > 0) {
+	if (new_name_len > 0) {
 		printf(_("\n"));
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
-		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		error = xlog_print_trans_attri_name(ptr,
+				be32_to_cpu(head->oh_len), "newname");
 		if (error)
 			goto error;
 	}
 
-	if (src_f->alfi_value_len > 0) {
+	if (value_len > 0) {
 		printf(_("\n"));
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
-		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
-				src_f->alfi_value_len);
+		error = xlog_print_trans_attri_value(ptr,
+				be32_to_cpu(head->oh_len), value_len, "value");
+		if (error)
+			goto error;
+	}
+
+	if (new_value_len > 0) {
+		printf(_("\n"));
+		(*i)++;
+		head = (xlog_op_header_t *)*ptr;
+		xlog_print_op_header(head, *i, ptr);
+		error = xlog_print_trans_attri_value(ptr,
+				be32_to_cpu(head->oh_len), new_value_len,
+				"newvalue");
+		if (error)
+			goto error;
 	}
 error:
 	free(src_f);
@@ -736,31 +786,33 @@ xlog_print_trans_attri(
 int
 xlog_print_trans_attri_name(
 	char				**ptr,
-	uint				src_len)
+	uint				src_len,
+	const char			*tag)
 {
-	printf(_("ATTRI:  name len:%u\n"), src_len);
+	printf(_("ATTRI:  %s len:%u\n"), tag, src_len);
 	print_or_dump(*ptr, src_len);
 
 	*ptr += src_len;
 
 	return 0;
-}	/* xlog_print_trans_attri */
+}
 
 int
 xlog_print_trans_attri_value(
 	char				**ptr,
 	uint				src_len,
-	int				value_len)
+	int				value_len,
+	const char			*tag)
 {
 	int len = min(value_len, src_len);
 
-	printf(_("ATTRI:  value len:%u\n"), value_len);
+	printf(_("ATTRI:  %s len:%u\n"), tag, value_len);
 	print_or_dump(*ptr, len);
 
 	*ptr += src_len;
 
 	return 0;
-}	/* xlog_print_trans_attri_value */
+}
 
 void
 xlog_recover_print_attri(
@@ -768,7 +820,10 @@ xlog_recover_print_attri(
 {
 	struct xfs_attri_log_format	*f, *src_f = NULL;
 	uint				src_len, dst_len;
-
+	unsigned int			name_len = 0;
+	unsigned int			new_name_len = 0;
+	unsigned int			value_len = 0;
+	unsigned int			new_value_len = 0;
 	int				region = 0;
 
 	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
@@ -788,24 +843,51 @@ xlog_recover_print_attri(
 	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
 		goto out;
 
-	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
-		f->alfi_size, f->alfi_name_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
+	if (xfs_attr_log_item_op(f) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
+		name_len      = f->alfi_old_name_len;
+		new_name_len  = f->alfi_new_name_len;
+		value_len     = f->alfi_value_len;
+		new_value_len = f->alfi_new_value_len;
+	} else {
+		name_len      = f->alfi_name_len;
+		value_len     = f->alfi_value_len;
+	}
+
+	printf(_("ATTRI:  #regs: %d	name_len: %u, new_name_len: %u, value_len: %d, new_value_len: %u  id: 0x%llx\n"),
+			f->alfi_size,
+			name_len,
+			new_name_len,
+			value_len,
+			new_value_len,
+			(unsigned long long)f->alfi_id);
 
-	if (f->alfi_name_len > 0) {
+	if (name_len > 0) {
 		region++;
-		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
+		printf(_("ATTRI:  name len:%u\n"), name_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr,
-			       f->alfi_name_len);
+			       name_len);
 	}
 
-	if (f->alfi_value_len > 0) {
-		int len = f->alfi_value_len;
+	if (new_name_len > 0) {
+		region++;
+		printf(_("ATTRI:  newname len:%u\n"), new_name_len);
+		print_or_dump((char *)item->ri_buf[region].i_addr,
+			       new_name_len);
+	}
+
+	if (value_len > 0) {
+		int	len = min(MAX_ATTR_VAL_PRINT, value_len);
+
+		region++;
+		printf(_("ATTRI:  value len:%u\n"), value_len);
+		print_or_dump((char *)item->ri_buf[region].i_addr, len);
+	}
 
-		if (len > MAX_ATTR_VAL_PRINT)
-			len = MAX_ATTR_VAL_PRINT;
+	if (new_value_len > 0) {
+		int	len = min(MAX_ATTR_VAL_PRINT, new_value_len);
 
 		region++;
-		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
+		printf(_("ATTRI:  newvalue len:%u\n"), new_value_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr, len);
 	}
 
diff --git a/logprint/logprint.h b/logprint/logprint.h
index 892b280b548..8742b98a9d1 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -59,8 +59,10 @@ extern void xlog_recover_print_bud(struct xlog_recover_item *item);
 #define MAX_ATTR_VAL_PRINT	128
 
 extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
-extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
-extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
+extern int xlog_print_trans_attri_name(char **ptr, uint src_len,
+		const char *tag);
+extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len,
+		const char *tag);
 extern void xlog_recover_print_attri(struct xlog_recover_item *item);
 extern int xlog_print_trans_attrd(char **ptr, uint len);
 extern void xlog_recover_print_attrd(struct xlog_recover_item *item);

