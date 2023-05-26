Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E47C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjEZCV0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbjEZCVZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:21:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F9F19D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E94D164C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589DEC433EF;
        Fri, 26 May 2023 02:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067680;
        bh=aH8aS7Z92kOkeEzjo7GWtvOuIXCkLZmz1cidHB4Cylw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=nrNtX8B0nQ7jrcBrWN4UsLPC8uAvzC5TNLzB9FKBZDPc4TrTehuiucCfWa12/wFQj
         m51lhm7s+vzAba5GOj5e8G8p6cl6utzEjJLCbJxJnf4kbAH9rP4K5zwSU7OCbbh5tq
         9PXI6UbkyJQ/Jtxy8xE1lwke7F+/y90NItSd1Bm/XPY/1NO94WS2osg4eNAxy06tjR
         vxgHR7Dle0Lr68praOgHU/G1XsHEyWMHt77v2BwqIFASoWFBynL1GKRXTa0I0/CJ8c
         hed0+I5PZfzG/ZaU1SukPihHYJJC4a+Qr0YKOhscKOkPLboYNnJ7pb21HgTdcxsANH
         sCnIu4N4LJYgQ==
Date:   Thu, 25 May 2023 19:21:19 -0700
Subject: [PATCH 08/10] xfs: log NVLOOKUP xattr nvreplace operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077543.3749126.15762548958386388902.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
References: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

(Formerly titled "xfs: Add new name to attri/d" and described as
follows:

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.)

If high level code wants to do a deferred xattr nvreplace operation with
the NVLOOKUP flag set, we need to push this through the log.  This log
item records the old name/value pair and the new name/value pair, and
completely replaces one with the other.  Parent pointers will need this
ability to handle rename moving a child file between parents.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: reworked to handle new disk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c       |   20 +++++++++++++++++++-
 libxfs/xfs_attr.h       |    4 ++--
 libxfs/xfs_da_btree.h   |    6 +++++-
 libxfs/xfs_log_format.h |   27 +++++++++++++++++++++++----
 4 files changed, 49 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8fa5b4f2819..2e6b6d6576e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -423,6 +423,20 @@ xfs_attr_complete_op(
 		return XFS_DAS_DONE;
 
 	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (xfs_attr_intent_op(attr) != XFS_ATTRI_OP_FLAGS_NVREPLACE)
+		return replace_state;
+
+	/*
+	 * NVREPLACE operations require the caller to set the old and new names
+	 * and values explicitly.
+	 */
+	ASSERT(args->new_namelen > 0);
+
+	args->name = args->new_name;
+	args->namelen = args->new_namelen;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->value = args->new_value;
+	args->valuelen = args->new_valuelen;
 	return replace_state;
 }
 
@@ -924,9 +938,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_REPLACE;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 4bacafa59a4..bb1776b8a6c 100644
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
index 091750b2d42..c2255250c58 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -54,11 +54,15 @@ enum xfs_dacmp {
  */
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
-	const uint8_t		*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
+	void		*new_value;	/* new xattr value (may contain NULLs) */
 	int		valuelen;	/* length of value */
+	int		new_valuelen;	/* length of new attr value */
 	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
 	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
 	xfs_dahash_t	hashval;	/* hash value of name */
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 7b848b1d8aa..21fbe1f49b6 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -115,11 +115,13 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_BUD_FORMAT	26
 #define XLOG_REG_TYPE_ATTRI_FORMAT	27
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
-#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_NAME		29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
 #define XLOG_REG_TYPE_SXI_FORMAT	31
 #define XLOG_REG_TYPE_SXD_FORMAT	32
-#define XLOG_REG_TYPE_MAX		32
+#define XLOG_REG_TYPE_ATTR_NEWNAME	33
+#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
+#define XLOG_REG_TYPE_MAX		34
 
 /*
  * Flags to log operation header
@@ -1038,6 +1040,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_NVSET	5	/* Set attr with w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	6	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -1055,11 +1058,27 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+
+	/*
+	 * For NVREPLACE, this is the length of the new xattr value.
+	 * alfi_value_len contains the length of the old xattr value.
+	 */
+	uint32_t	alfi_new_value_len;
+
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
-	uint32_t	alfi_name_len;	/* attr name length */
+	union {
+		uint32_t	alfi_name_len;	/* attr name length */
+		struct {
+			/*
+			 * For NVREPLACE, these are the lengths of the old and
+			 * new attr name.
+			 */
+			uint16_t	alfi_old_name_len;
+			uint16_t	alfi_new_name_len;
+		};
+	};
 	uint32_t	alfi_value_len;	/* attr value length */
 	uint32_t	alfi_attr_filter;/* attr filter flags */
 };

