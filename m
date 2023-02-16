Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4467DC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjBPUyF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBPUyE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:54:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D612942C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:54:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10D4C60A55
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7375BC433EF;
        Thu, 16 Feb 2023 20:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580842;
        bh=mji0PllpvZlYfAIpul0+BmnVD81hSKypHV5C62iNgVQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=o5DGJHRC+82jdWrDeLPZsjWFxM0JCgkFn4QuvollVb0T0vfY6evXh9RADiZbUUYwx
         uuQRk6qfbOUBWgZ13P8UEDk0gtXuYQf02ZX2qsEzVj3KURpetphVE7ZGDOnKS+Dg5o
         6Ld/k84aF6tdR666tbJkhUAgj0TMIuWElEmO5di+dQL4suiseKy61uvpwy97lKETAC
         KAFPTna61rvmOP5WhJ1eVgbopd717CGlppyU7+iZFluyMAE2JRCr92l22HQaXe6p5w
         z06Z3dnWD9nB6/8dULfTYxXWFMsV50w6e2Raw+Dfhx7pu4/yxFBjFr3LaCjkTugXTF
         slumikm32Ka+g==
Date:   Thu, 16 Feb 2023 12:54:02 -0800
Subject: [PATCH 02/25] xfsprogs: Add new name to attri/d
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657878922.3476112.9094775507103949014.stgit@magnolia>
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

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

This patch also applies the necassary updates to print the new
attri/d name fields.

Source kernel commit: 7b3bde6f488372494236cb96da308b192bbe72c9

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c       |   12 +++++++++++-
 libxfs/xfs_attr.h       |    4 ++--
 libxfs/xfs_da_btree.h   |    2 ++
 libxfs/xfs_log_format.h |    6 ++++--
 logprint/log_redo.c     |   27 ++++++++++++++++++++++-----
 5 files changed, 41 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2103a06b..2f619286 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -421,6 +421,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		if (args->new_namelen > 0) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		}
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
@@ -920,9 +926,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
+		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 81be9b3e..3e81f3f4 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index ffa3df5b..a4b29827 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index f13e0809..ae9c9976 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
+#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_MAX		31
 
 
 /*
@@ -957,6 +958,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -974,7 +976,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index edf7e0fb..b596af02 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -705,9 +705,9 @@ xlog_print_trans_attri(
 	memmove((char*)src_f, *ptr, src_len);
 	*ptr += src_len;
 
-	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
-		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_value_len,
-				(unsigned long long)src_f->alfi_id);
+	printf(_("ATTRI:  #regs: %d	name_len: %d, nname_len: %d value_len: %d  id: 0x%llx\n"),
+		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_nname_len,
+		src_f->alfi_value_len, (unsigned long long)src_f->alfi_id);
 
 	if (src_f->alfi_name_len > 0) {
 		printf(_("\n"));
@@ -719,6 +719,16 @@ xlog_print_trans_attri(
 			goto error;
 	}
 
+	if (src_f->alfi_nname_len > 0) {
+		printf(_("\n"));
+		(*i)++;
+		head = (xlog_op_header_t *)*ptr;
+		xlog_print_op_header(head, *i, ptr);
+		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		if (error)
+			goto error;
+	}
+
 	if (src_f->alfi_value_len > 0) {
 		printf(_("\n"));
 		(*i)++;
@@ -788,8 +798,8 @@ xlog_recover_print_attri(
 	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
 		goto out;
 
-	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
-		f->alfi_size, f->alfi_name_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
+	printf(_("ATTRI:  #regs: %d	name_len: %d, nname_len:%d, value_len: %d  id: 0x%llx\n"),
+		f->alfi_size, f->alfi_name_len, f->alfi_nname_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
 
 	if (f->alfi_name_len > 0) {
 		region++;
@@ -798,6 +808,13 @@ xlog_recover_print_attri(
 			       f->alfi_name_len);
 	}
 
+	if (f->alfi_nname_len > 0) {
+		region++;
+		printf(_("ATTRI:  nname len:%u\n"), f->alfi_nname_len);
+		print_or_dump((char *)item->ri_buf[region].i_addr,
+			       f->alfi_nname_len);
+	}
+
 	if (f->alfi_value_len > 0) {
 		int len = f->alfi_value_len;
 

