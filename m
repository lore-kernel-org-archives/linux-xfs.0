Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095B6883D
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882689; cv=none; b=Bz6hJXKsT+w2fzgmMg+x1a3BbXQS7cRY3eeC02wuuSf6hEGdrbDo0nJHL0IULpYEeaVqwH1jaSdlY+GBvhLH6/lZIw7SlldpD4kpWhS4CGKAt+laQfxt7n/TmVd4BY1iuFBMYwUZ07aThkS+H/asHqVaR4wgVFMXkFzpRMxD5Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882689; c=relaxed/simple;
	bh=k3/E8ahruVyWCLFc4xS1M1AXmAmXhrcmBhNaJt4WCFs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BnK2p/j+Lmivwzb0wtdsXZVcOfVio3LITbuIIMKO3MDbGiCMClu4pRkBbYmsxLbQshiB1JO1nvMgseVmntcanzNMzzCJQyo4wWgRaUtN0zn1ZKqFXNEqVjkLE/+pd9u36seCb+HBvPG2hMAiZpAU6Jdw2geaislk2BwLu1h0p/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJKtbEVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJKtbEVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4519C116B1;
	Tue,  2 Jul 2024 01:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882688;
	bh=k3/E8ahruVyWCLFc4xS1M1AXmAmXhrcmBhNaJt4WCFs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rJKtbEVVU6jj68YPfwAFGszMao2kIy0Huhl4vXUpmRfs3BOKSmaZWeqRchgBnjeQp
	 zkhAaMadykp00kK7/CGuNVFVvu1xJCj4/dQmTS3ateB4KaVC768SXMQBBbwpBPzva4
	 QqIRaejyFtPaCJFK5GuceKpfTrT+h0f3jErhLk9qckjrNh0vVa/LCNG4tPz+IwC76V
	 lpBCJV6qdZ6L6KV/WTh8xsRbn6SM7gUfspZYAjtCno1IwQRDp6kuhPrlnr17sUp+ET
	 3hZ2VYKe05hEZcggNFNYjMEz1f16jlgTqGoOYB/520c0k48Qr0NsFO+JNvlFTeqVX3
	 Z3PkU+uMzlNCw==
Date: Mon, 01 Jul 2024 18:11:28 -0700
Subject: [PATCH 03/24] xfs_logprint: dump new attr log item fields
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121108.2009260.6026012075133524751.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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
 logprint/log_redo.c |  140 ++++++++++++++++++++++++++++++++++++++++++---------
 logprint/logprint.h |    6 +-
 2 files changed, 119 insertions(+), 27 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index ca6dadd7551a..1d55164a90ff 100644
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
@@ -705,27 +715,71 @@ xlog_print_trans_attri(
 	memmove((char*)src_f, *ptr, src_len);
 	*ptr += src_len;
 
-	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
-		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_value_len,
-				(unsigned long long)src_f->alfi_id);
+	if (xfs_attr_log_item_op(src_f) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE) {
+		name_len      = src_f->alfi_old_name_len;
+		new_name_len  = src_f->alfi_new_name_len;
+		value_len     = src_f->alfi_value_len;
+		new_value_len = src_f->alfi_value_len;
+	} else {
+		name_len      = src_f->alfi_name_len;
+		value_len     = src_f->alfi_value_len;
+	}
+
+	printf(_("ATTRI:  #regs: %d	f: 0x%x, ino: 0x%llx, igen: 0x%x, attr_filter: 0x%x, name_len: %u, new_name_len: %u, value_len: %u, new_value_len: %u  id: 0x%llx\n"),
+			src_f->alfi_size,
+			src_f->alfi_op_flags,
+			(unsigned long long)src_f->alfi_ino,
+			(unsigned int)src_f->alfi_igen,
+			src_f->alfi_attr_filter,
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
@@ -736,31 +790,33 @@ xlog_print_trans_attri(
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
@@ -768,7 +824,10 @@ xlog_recover_print_attri(
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
@@ -788,24 +847,55 @@ xlog_recover_print_attri(
 	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
 		goto out;
 
-	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
-		f->alfi_size, f->alfi_name_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
+	if (xfs_attr_log_item_op(f) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE) {
+		name_len      = f->alfi_old_name_len;
+		new_name_len  = f->alfi_new_name_len;
+		value_len     = f->alfi_value_len;
+		new_value_len = f->alfi_value_len;
+	} else {
+		name_len      = f->alfi_name_len;
+		value_len     = f->alfi_value_len;
+	}
+
+	printf(_("ATTRI:  #regs: %d	f: 0x%x, ino: 0x%llx, igen: 0x%x, attr_filter: 0x%x, name_len: %u, new_name_len: %u, value_len: %d, new_value_len: %u  id: 0x%llx\n"),
+			f->alfi_size,
+			f->alfi_op_flags,
+			(unsigned long long)f->alfi_ino,
+			(unsigned int)f->alfi_igen,
+			f->alfi_attr_filter,
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
index 8867b110ecaf..9715cdb9e27b 100644
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

