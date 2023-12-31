Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE2DC154
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQj6T4kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6C4C433C8;
	Sun, 31 Dec 2023 23:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064219;
	bh=IvoEZEncoNCSumIANu5vGkmZUDvZMskNk21AEZcm0CA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IQj6T4kdEmzYGUMYuFMkwOMisxDSP+jw+TTfjYSXhHPGUpW5/SY+/Xcpj/B4SoxFE
	 gd3SRjnlsqFepcZ5fCEBlb7XdyhOcH/aYCLH9qLlaDbUkQXKSJ18w06SMr6beGu4RY
	 oiDcJwqegdgJFcH775thHsUDpwquMtHSXjZ3y4qwwW5FkuBcaRb55c+dSrGVcWtvKW
	 SeFGtyVMTJ+4775v4kLIVlm4dlCWY6q00BmcRDY3UafQrvgaxgzLrqkFeA3hlDoNs9
	 91AsiJcyq1fXIthNyQ17j/R/QpPmrj1fO9Ri9OXv9ZTsWl9RUtYVcIdCjNYDcbXHZs
	 OqoY/T0RSdumw==
Date: Sun, 31 Dec 2023 15:10:19 -0800
Subject: [PATCH 20/32] xfs_logprint: decode parent pointers in ATTRI items
 fully
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006368.1804688.13069374496914124680.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies the ATTRI print routines to look for the parent
pointer flag, and decode logged parent pointers fully when dumping log
contents.  Between the existing ATTRI: printouts and the new ones
introduced here, we can figure out what was stored in each log iovec,
as well as the higher level parent pointer that was logged.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adjust to new ondisk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    4 ++
 logprint/log_redo.c      |   81 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1b69124767c..c94972fb84b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -177,6 +177,10 @@
 #define xfs_log_sb			libxfs_log_sb
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
 #define xfs_mkdir_space_res		libxfs_mkdir_space_res
+#define xfs_parent_add			libxfs_parent_add
+#define xfs_parent_finish		libxfs_parent_finish
+#define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
+#define xfs_parent_start		libxfs_parent_start
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_hold			libxfs_perag_hold
 #define xfs_perag_put			libxfs_perag_put
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index e6401bb293e..948924d5bcb 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -674,6 +674,59 @@ xfs_attri_copy_log_format(
 	return 1;
 }
 
+static void
+dump_pptr(
+	const char			*tag,
+	const void			*name_ptr,
+	unsigned int			name_len,
+	const void			*value_ptr,
+	unsigned int			value_len)
+{
+	struct xfs_parent_name_irec	irec;
+
+	if (name_len < sizeof(struct xfs_parent_name_rec)) {
+		printf("PPTR: %s CORRUPT\n", tag);
+		return;
+	}
+
+	libxfs_parent_irec_from_disk(&irec, name_ptr, value_ptr, value_len);
+
+	printf("PPTR: %s attr_namelen %u attr_valuelen %u\n", tag, name_len, value_len);
+	printf("PPTR: %s parent_ino %llu parent_gen %u namehash 0x%x namelen %u name '%.*s'\n",
+			tag,
+			(unsigned long long)irec.p_ino,
+			irec.p_gen,
+			irec.p_namehash,
+			irec.p_namelen,
+			irec.p_namelen,
+			irec.p_name);
+}
+
+static void
+dump_pptr_update(
+	const void	*name_ptr,
+	unsigned int	name_len,
+	const void	*new_name_ptr,
+	unsigned int	new_name_len,
+	const void	*value_ptr,
+	unsigned int	value_len,
+	const void	*new_value_ptr,
+	unsigned int	new_value_len)
+{
+	if (new_name_ptr && name_ptr) {
+		dump_pptr("OLDNAME", name_ptr, name_len, value_ptr, value_len);
+		dump_pptr("NEWNAME", new_name_ptr, new_name_len, new_value_ptr,
+				new_value_len);
+		return;
+	}
+
+	if (name_ptr)
+		dump_pptr("NAME", name_ptr, name_len, value_ptr, value_len);
+	if (new_name_ptr)
+		dump_pptr("NEWNAME", new_name_ptr, new_name_len, new_value_ptr,
+				new_value_len);
+}
+
 static inline unsigned int
 xfs_attr_log_item_op(const struct xfs_attri_log_format *attrp)
 {
@@ -688,6 +741,10 @@ xlog_print_trans_attri(
 {
 	struct xfs_attri_log_format	*src_f = NULL;
 	xlog_op_header_t		*head = NULL;
+	void				*name_ptr = NULL;
+	void				*new_name_ptr = NULL;
+	void				*value_ptr = NULL;
+	void				*new_value_ptr = NULL;
 	uint				dst_len;
 	unsigned int			name_len = 0;
 	unsigned int			new_name_len = 0;
@@ -741,6 +798,7 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		name_ptr = *ptr;
 		error = xlog_print_trans_attri_name(ptr,
 				be32_to_cpu(head->oh_len), "name");
 		if (error)
@@ -752,6 +810,7 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		new_name_ptr = *ptr;
 		error = xlog_print_trans_attri_name(ptr,
 				be32_to_cpu(head->oh_len), "newname");
 		if (error)
@@ -763,6 +822,7 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		value_ptr = *ptr;
 		error = xlog_print_trans_attri_value(ptr,
 				be32_to_cpu(head->oh_len), value_len, "value");
 		if (error)
@@ -774,12 +834,19 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		new_value_ptr = *ptr;
 		error = xlog_print_trans_attri_value(ptr,
 				be32_to_cpu(head->oh_len), new_value_len,
 				"newvalue");
 		if (error)
 			goto error;
 	}
+
+	if (src_f->alfi_attr_filter & XFS_ATTR_PARENT)
+		dump_pptr_update(name_ptr, name_len,
+				 new_name_ptr, new_name_len,
+				 value_ptr, value_len,
+				 new_value_ptr, new_value_len);
 error:
 	free(src_f);
 
@@ -822,6 +889,10 @@ xlog_recover_print_attri(
 	struct xlog_recover_item	*item)
 {
 	struct xfs_attri_log_format	*f, *src_f = NULL;
+	void				*name_ptr = NULL;
+	void				*new_name_ptr = NULL;
+	void				*value_ptr = NULL;
+	void				*new_value_ptr = NULL;
 	uint				src_len, dst_len;
 	unsigned int			name_len = 0;
 	unsigned int			new_name_len = 0;
@@ -872,6 +943,7 @@ xlog_recover_print_attri(
 		printf(_("ATTRI:  name len:%u\n"), name_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr,
 			       name_len);
+		name_ptr = item->ri_buf[region].i_addr;
 	}
 
 	if (new_name_len > 0) {
@@ -879,6 +951,7 @@ xlog_recover_print_attri(
 		printf(_("ATTRI:  newname len:%u\n"), new_name_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr,
 			       new_name_len);
+		new_name_ptr = item->ri_buf[region].i_addr;
 	}
 
 	if (value_len > 0) {
@@ -887,6 +960,7 @@ xlog_recover_print_attri(
 		region++;
 		printf(_("ATTRI:  value len:%u\n"), value_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr, len);
+		value_ptr = item->ri_buf[region].i_addr;
 	}
 
 	if (new_value_len > 0) {
@@ -895,8 +969,15 @@ xlog_recover_print_attri(
 		region++;
 		printf(_("ATTRI:  newvalue len:%u\n"), new_value_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr, len);
+		new_value_ptr = item->ri_buf[region].i_addr;
 	}
 
+	if (src_f->alfi_attr_filter & XFS_ATTR_PARENT)
+		dump_pptr_update(name_ptr, name_len,
+				 new_name_ptr, new_name_len,
+				 value_ptr, value_len,
+				 new_value_ptr, new_value_len);
+
 out:
 	free(f);
 

