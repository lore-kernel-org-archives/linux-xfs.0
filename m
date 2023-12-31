Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46D4C8CF
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caekxNq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8B2C433C7;
	Sun, 31 Dec 2023 23:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063891;
	bh=wFL97SFPOMPzyf6NDCVCHFJpOJGzV1YH7/b6K1Banqs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=caekxNq7or46xuSSN2tABL0f+0U4N51a74m5RiU/7KmnoKyuUuI59AS0rSZxYZUKh
	 CudFaAW8nDy/A1HSy3sdpsJrFt7+F+jKcbMqazbjg3yn6i9Roxk+1t7rDxwVX0C2Dg
	 WOYEd1OpX1bDjZzUX8UXPp8aJmE2Mx2HiGJYZ7E87vLDwuUVBK9+rSyjpSBAn1pvpt
	 nFm8xxKDVDZEjrsLiubGjz47JZALU/ufDZ0Lvw87QvTUJTmeM1J97r2tBuNVADjwIG
	 Fciq8/6oc4YBRVXSRYV0DMddex8fsn6Ye8OWErsnoh9vlb/Gu3Wz3JKLJKTRC0wyx5
	 KRuaP/2Cs6Etw==
Date: Sun, 31 Dec 2023 15:04:51 -0800
Subject: [PATCH 10/11] xfs_logprint: dump new attr log item fields
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005730.1804370.3323399662841222983.stgit@frogsfrogsfrogs>
In-Reply-To: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
References: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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

