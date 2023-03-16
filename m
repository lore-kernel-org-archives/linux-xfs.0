Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A29C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCPTdB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCPTdA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:33:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DB4BBB3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:32:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42EC3B82302
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02666C433D2;
        Thu, 16 Mar 2023 19:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995176;
        bh=NXlNBHHXCTZrFmhgAh0gm84lgmN9Klu/XJQlcq6jFYU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rgBzo6+efP+F5okjqMLSNJDLvWYvuQiOJC0xMc5xfnqtUVTCySoi7cmUaBaV3LPx1
         p2AEeTPOJW0H/MOmjTTS6QnQJxdcNWmF7jUGqZfmhrgsZoY7ko2J7LrWKZJp4YpMpy
         rMxvmrQCEoUAJ5fKTm/rhKuHGhf3Pgn/7hQDDOJnmB3nKvB/be1DecJFqReIC5W25Q
         Ep+W++3RIG/g4Fd90puz/994houTlQnbkfojBV1sKSEp1p2CSdokM41edq0tMgjRix
         rSmreOsoIoljORoLE4CftPGXMAuIOz9tjs5qicu1MSFnnJcrYCwmLI0zmnR1rajXa4
         V+pV2QYty44FA==
Date:   Thu, 16 Mar 2023 12:32:55 -0700
Subject: [PATCH 4/4] xfs_logprint: decode parent pointers fully
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416845.17000.1149289596796145954.stgit@frogsfrogsfrogs>
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

Decode logged parent pointers fully when dumping log contents.  Between
the existing ATTRI: printouts and the new ones introduced here, we can
figure out what was stored in each log iovec, as well as the higher
level parent pointer that was logged.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 logprint/log_redo.c      |   63 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 63 insertions(+), 1 deletion(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 60d3339a7..092934935 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -141,6 +141,7 @@
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
 #define xfs_parent_add			libxfs_parent_add
 #define xfs_parent_finish		libxfs_parent_finish
+#define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_put			libxfs_perag_put
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index f0d64ae9f..0f4891436 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -674,6 +674,46 @@ xfs_attri_copy_log_format(
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
+	libxfs_parent_irec_from_disk(&irec, name_ptr, value_ptr, value_len);
+
+	printf("PPTR: %s attr_namelen %u attr_valuelen %u\n", tag, name_len, value_len);
+	printf("PPTR: %s parent_ino %llu parent_gen %u diroffset %u namelen %u name '%.*s'\n",
+			tag, (unsigned long long)irec.p_ino, irec.p_gen,
+			irec.p_diroffset,
+			irec.p_namelen, irec.p_namelen, irec.p_name);
+}
+
+static void
+dump_pptr_update(
+	const void	*name_ptr,
+	unsigned int	name_len,
+	const void	*newname_ptr,
+	unsigned int	newname_len,
+	const void	*value_ptr,
+	unsigned int	value_len)
+{
+	if (newname_ptr && name_ptr) {
+		dump_pptr("OLDNAME", name_ptr, name_len, value_ptr, value_len);
+		dump_pptr("NEWNAME", newname_ptr, newname_len, "", 0);
+		return;
+	}
+
+	if (name_ptr)
+		dump_pptr("NAME", name_ptr, name_len, value_ptr, value_len);
+	if (newname_ptr)
+		dump_pptr("NNAME", newname_ptr, newname_len, NULL, 0);
+}
+
 int
 xlog_print_trans_attri(
 	char				**ptr,
@@ -682,6 +722,8 @@ xlog_print_trans_attri(
 {
 	struct xfs_attri_log_format	*src_f = NULL;
 	xlog_op_header_t		*head = NULL;
+	void				*name_ptr = NULL, *newname_ptr = NULL;
+	void				*value_ptr = NULL;
 	uint				dst_len;
 	int				error = 0;
 
@@ -720,6 +762,7 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		name_ptr = *ptr;
 		error = xlog_print_trans_attri_name(ptr,
 				be32_to_cpu(head->oh_len), "name");
 		if (error)
@@ -731,6 +774,7 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		newname_ptr = *ptr;
 		error = xlog_print_trans_attri_name(ptr,
 				be32_to_cpu(head->oh_len), "newname");
 		if (error)
@@ -742,9 +786,17 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		value_ptr = *ptr;
 		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
 				src_f->alfi_value_len);
+		if (error)
+			goto error;
 	}
+
+	if (src_f->alfi_attr_filter & XFS_ATTR_PARENT)
+		dump_pptr_update(name_ptr, src_f->alfi_name_len,
+				 newname_ptr, src_f->alfi_nname_len,
+				 value_ptr, src_f->alfi_value_len);
 error:
 	free(src_f);
 
@@ -787,7 +839,8 @@ xlog_recover_print_attri(
 {
 	struct xfs_attri_log_format	*f, *src_f = NULL;
 	uint				src_len, dst_len;
-
+	void				*name_ptr = NULL, *newname_ptr = NULL;
+	void				*value_ptr = NULL;
 	int				region = 0;
 
 	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
@@ -822,6 +875,7 @@ xlog_recover_print_attri(
 		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr,
 			       f->alfi_name_len);
+		name_ptr = item->ri_buf[region].i_addr;
 	}
 
 	if (f->alfi_nname_len > 0) {
@@ -829,6 +883,7 @@ xlog_recover_print_attri(
 		printf(_("ATTRI:  newname len:%u\n"), f->alfi_nname_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr,
 			       f->alfi_nname_len);
+		newname_ptr = item->ri_buf[region].i_addr;
 	}
 
 	if (f->alfi_value_len > 0) {
@@ -840,8 +895,14 @@ xlog_recover_print_attri(
 		region++;
 		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr, len);
+		value_ptr = item->ri_buf[region].i_addr;
 	}
 
+	if (src_f->alfi_attr_filter & XFS_ATTR_PARENT)
+		dump_pptr_update(name_ptr, src_f->alfi_name_len,
+				 newname_ptr, src_f->alfi_nname_len,
+				 value_ptr, src_f->alfi_value_len);
+
 out:
 	free(f);
 

