Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F35AC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjDFThF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjDFThE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:37:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E52E72
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08E3164B89
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F07C433EF;
        Thu,  6 Apr 2023 19:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809822;
        bh=sgNtJhpUzv8T32i+1w34lBRcFN1SPYu+zo1MIIWGZcI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=n/B41I23RSp8XaLkrOrl5eae3iZ/wR6xcoBi9+YMHru1IkGu8ckyTM1mqOZMxOmes
         HSpurV8ZHqL+/grjARBLlzCwvcJoHcu3xuGjw3t0fiPUdMC2YXBajOkV4021eaVD6F
         bizVTyf1K/D8KJY8+v2qXas2dcxevByeSorDiVYYc2x60cd1zipnDVaJCUtx/j2ldz
         glfyJTeSqvLheav/urgz8fvsAbnvJGs9+phQL+BqpLC80rKB5LR9euI+U1A2OFL/Ox
         ini70zslhF/c7feLWyi7c69hW1UOYn6dZ1G5vEiBcb5GUU0pgaR8pKHa6sFhOgRjHx
         rvhc/fZS0wEcA==
Date:   Thu, 06 Apr 2023 12:37:02 -0700
Subject: [PATCH 21/32] xfs_logprint: decode parent pointers in ATTRI items
 fully
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827833.616793.9679802078608173155.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

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
index f8efcce77..092934935 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -139,6 +139,10 @@
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
 #define xfs_log_sb			libxfs_log_sb
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
+#define xfs_parent_add			libxfs_parent_add
+#define xfs_parent_finish		libxfs_parent_finish
+#define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
+#define xfs_parent_start		libxfs_parent_start
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_put			libxfs_perag_put
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 8b6aa9279..a8a367bb0 100644
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
 

