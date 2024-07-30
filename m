Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED2328EB
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302472; cv=none; b=hM63GFknY3xiEI/VxgPlcY0QqtkhalUfmoxkWFXX5qb/z9ART7aWfQuRf4f4RZttAlcl2JX76gCp4gZuYVZGpxdl8hzAtddeVlTsMeei+G3lYmnl8ihhogYJcHD2qbnJhl8Klf9Wb0XJ0RPEd/jmTn8Gkrj8nAe81pZDJEzbA4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302472; c=relaxed/simple;
	bh=0HpKqRAtVhOSohc7okaT9iJ6LevwJJq4FLSKwUNT6Yk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=utbu/hmgXhc+Vhu1Ja1XuxRJN2hpZ1JeAPowLpfNVYBWr6ESBvkLaCPxNgwhLaKeXnA1Niy56G8nlwgQCbL8kuu4cLr1NIF5M3+JWTuZrkKg0AFTfHRLAIWgtFPmMYnuwr7RUwB77eGv5ph17jZuIhmVNfkH3fCLJaO8GjRrBvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvTMq+dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvTMq+dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D09BC4AF07;
	Tue, 30 Jul 2024 01:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302472;
	bh=0HpKqRAtVhOSohc7okaT9iJ6LevwJJq4FLSKwUNT6Yk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MvTMq+dcrFyzA/eugpozR8tFo1zGTUPBzGlfAceTYJStlnMyv1NvFDey2lbzs3Xvd
	 JZtM3SaJC4XG7uf3dffHTRduJDxoSszu+uGRtp+9YAK5wWmgs51CHa5ymZ1xF3jGhv
	 wJzp7Mkg9e6vxQKv4c8PdRgtG59B+Pfa+mmKznQm2v1GpYpef2m9xTA4utN7ErO5lS
	 QCfOPgvPM8pLevYmGhsXeIhEPg7Mcj6ClM7jo5Sa+9MXLqdus4P9eww2ZwWXE859OA
	 5xxpl60F7gXR5mVAsC+GFqrOnJYfdu2GK0MJ60uAM5MI9H/e0tTwQ02QdS8mC8RY25
	 c3K8BE6oXF1Cg==
Date: Mon, 29 Jul 2024 18:21:11 -0700
Subject: [PATCH 09/24] xfs_logprint: decode parent pointers in ATTRI items
 fully
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850639.1350924.1756688729481178461.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    3 ++
 logprint/log_redo.c      |   77 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c36a6ac81..b7947591d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -190,6 +190,9 @@
 #define xfs_log_sb			libxfs_log_sb
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
 #define xfs_mkdir_space_res		libxfs_mkdir_space_res
+#define xfs_parent_add			libxfs_parent_add
+#define xfs_parent_finish		libxfs_parent_finish
+#define xfs_parent_start		libxfs_parent_start
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_hold			libxfs_perag_hold
 #define xfs_perag_put			libxfs_perag_put
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 1d55164a9..684e5f4a3 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -674,6 +674,55 @@ xfs_attri_copy_log_format(
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
+	const struct xfs_parent_rec	*rec = value_ptr;
+
+	if (value_len < sizeof(struct xfs_parent_rec)) {
+		printf("PPTR: %s CORRUPT\n", tag);
+		return;
+	}
+
+	printf("PPTR: %s attr_namelen %u attr_valuelen %u\n", tag, name_len, value_len);
+	printf("PPTR: %s parent_ino %llu parent_gen %u name '%.*s'\n",
+			tag,
+			(unsigned long long)be64_to_cpu(rec->p_ino),
+			(unsigned int)be32_to_cpu(rec->p_gen),
+			name_len,
+			(char *)name_ptr);
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
@@ -688,6 +737,10 @@ xlog_print_trans_attri(
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
@@ -742,6 +795,7 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		name_ptr = *ptr;
 		error = xlog_print_trans_attri_name(ptr,
 				be32_to_cpu(head->oh_len), "name");
 		if (error)
@@ -753,6 +807,7 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		new_name_ptr = *ptr;
 		error = xlog_print_trans_attri_name(ptr,
 				be32_to_cpu(head->oh_len), "newname");
 		if (error)
@@ -764,6 +819,7 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		value_ptr = *ptr;
 		error = xlog_print_trans_attri_value(ptr,
 				be32_to_cpu(head->oh_len), value_len, "value");
 		if (error)
@@ -775,12 +831,19 @@ xlog_print_trans_attri(
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
 
@@ -823,6 +886,10 @@ xlog_recover_print_attri(
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
@@ -874,6 +941,7 @@ xlog_recover_print_attri(
 		printf(_("ATTRI:  name len:%u\n"), name_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr,
 			       name_len);
+		name_ptr = item->ri_buf[region].i_addr;
 	}
 
 	if (new_name_len > 0) {
@@ -881,6 +949,7 @@ xlog_recover_print_attri(
 		printf(_("ATTRI:  newname len:%u\n"), new_name_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr,
 			       new_name_len);
+		new_name_ptr = item->ri_buf[region].i_addr;
 	}
 
 	if (value_len > 0) {
@@ -889,6 +958,7 @@ xlog_recover_print_attri(
 		region++;
 		printf(_("ATTRI:  value len:%u\n"), value_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr, len);
+		value_ptr = item->ri_buf[region].i_addr;
 	}
 
 	if (new_value_len > 0) {
@@ -897,8 +967,15 @@ xlog_recover_print_attri(
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
 

