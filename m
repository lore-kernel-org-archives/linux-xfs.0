Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC3FC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbjDFTbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbjDFTbV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:31:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D2B5580
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:31:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2975864B8B
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860ABC433EF;
        Thu,  6 Apr 2023 19:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809479;
        bh=QXLpCCcZarrSHdr/5J0QMrmjwUmEdqFxrARf+RktNWc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=d4zfHVcLYuaP2u6XmGFKm3PAAIw6dNSaWXUF+TUwXjXuYBEwP1wpR/cIjy3hhqzZf
         PFJUrUrBDWZwDwpEQ1hX9wiZ6M6znaAbT7lA9pWI9ajfwpm+D9mx8vXSspk2lvKtJm
         YDS3zgXVlglrD9IQ4mMlEBdvurcQp4gc+/NoaKcF9Ur+EmMM+4UiBSMg7w2lDDPsNs
         eTJwn7V0INilEP5seH+69KiJ4r6lSTBzL5YFI32FdX8gHI0kPOhwuBZys0vMZBZd5F
         a8dHs5G+1mVvnbXWWJ6IDNDv2/oRxoIAjY4jcc++uOCeOpfHEndsehBplQyv0jFV2g
         VfbjfGWusBNmA==
Date:   Thu, 06 Apr 2023 12:31:19 -0700
Subject: [PATCH 09/10] xfs_logprint: dump new attr log item fields
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827233.616519.15176184729186777150.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
References: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
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
index edf7e0fbf..2eaf58918 100644
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
index b4479c240..27f1cd9a7 100644
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

