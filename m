Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B937E6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299935; cv=none; b=H3JdV18aZESluMc0pkjbuvBEQ/WlkmNODcGQdYPbF7q2I7OMP196PdrPAbiEAYlgaQ6uQXVDQ44kiFODMWmXPPwEbQhRFus6P837W7YHskamk63/9UHKDG1FvnNxJN/yyXcQHSU5Eb+7GpkTB29GI7DJUEuqQR6KR/lOo3zSlT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299935; c=relaxed/simple;
	bh=FWUPqFOfmJEeSLsTiw/jAjjLb0bvwxa/4o6ecg65KBo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZRrl+6GJpmfcwo2FcDo+5Y8Y3ybVQlcVOFb6NYuFin+DeXgAnJFbWvBytL6kyTseFJ5RB1hnaP3BrV+BbfhSljHsN3RiGqBcqpz69g6BRfUAR32PzHMcJch98B8p88U7GM5CuLjvBB4Tts3/Bolaz7lvGpsOllcdk533C0XbqPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDdhghbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDdhghbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31A5C32786;
	Tue, 30 Jul 2024 00:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299934;
	bh=FWUPqFOfmJEeSLsTiw/jAjjLb0bvwxa/4o6ecg65KBo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dDdhghblav5Q0APhbJl6xJW1wn/kfjxdO0/8RMTmxr8gq+ObKdHeV9jBfGuI2ocPL
	 6m3DXre6k8J+OQwkEmPuZ9CgGMjCtj8GQim4LwVhYFmdwfmZSP0B/iKIbzmr36mC66
	 ZeBFvWmjSYQ3TgYm8e3jhGSkBEmcfq9Jv5ClMZ8OlkSngLF84pfXQTR/mbVJdvjYqn
	 VtapNie2thbEsxrZr3yS+dh49mjQmfQ6abiudXPJQ+IP6TntD26c7wWmrsH0xqEGtC
	 h9rvmGtwMUQwnvKyyvwHXagQLHwqKWS3T5IrMKJgqv1SEz6wXVZ11rmYeGI2Z9AAC4
	 6y/u2lcAEhvpA==
Date: Mon, 29 Jul 2024 17:38:54 -0700
Subject: [PATCH 058/115] xfs: create attr log item opcodes and formats for
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843259.1338752.7080239945946535934.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5773f7f82be5aa98e4883566072d33342814cebe

Make the necessary alterations to the extended attribute log intent item
ondisk format so that we can log parent pointer operations.  This
requires the creation of new opcodes specific to parent pointers, and a
new four-argument replace operation to handle renames.  At this point
this part of the patchset has changed so much from what Allison original
wrote that I no longer think her SoB applies.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c       |   19 +++++++++++++++++++
 libxfs/xfs_attr.h       |    4 ++--
 libxfs/xfs_da_btree.h   |    4 ++++
 libxfs/xfs_log_format.h |   22 +++++++++++++++++++---
 4 files changed, 44 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 91e7961c2..c67cdc77a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -438,6 +438,23 @@ xfs_attr_hashval(
 	return xfs_attr_hashname(name, namelen);
 }
 
+/*
+ * PPTR_REPLACE operations require the caller to set the old and new names and
+ * values explicitly.  Update the canonical fields to the new name and value
+ * here now that the removal phase has finished.
+ */
+static void
+xfs_attr_update_pptr_replace_args(
+	struct xfs_da_args	*args)
+{
+	ASSERT(args->new_namelen > 0);
+	args->name = args->new_name;
+	args->namelen = args->new_namelen;
+	args->value = args->new_value;
+	args->valuelen = args->new_valuelen;
+	xfs_attr_sethash(args);
+}
+
 /*
  * Handle the state change on completion of a multi-state attr operation.
  *
@@ -458,6 +475,8 @@ xfs_attr_complete_op(
 
 	if (!(args->op_flags & XFS_DA_OP_REPLACE))
 		replace_state = XFS_DAS_DONE;
+	else if (xfs_attr_intent_op(attr) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE)
+		xfs_attr_update_pptr_replace_args(args);
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index c63b1d610..d0ed7ea58 100644
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
index 17cef594b..354d5d650 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t	*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
+	void		*new_value;	/* new xattr value (may contain NULLs) */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
 	struct xfs_trans *trans;	/* current trans (changes over time) */
 
@@ -63,10 +65,12 @@ typedef struct xfs_da_args {
 	xfs_ino_t	owner;		/* inode that owns the dir/attr data */
 
 	int		valuelen;	/* length of value */
+	int		new_valuelen;	/* length of new_value */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	uint8_t		op_flags;	/* operation flags */
 	uint8_t		attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
 	short		namelen;	/* length of string (maybe no NULL) */
+	short		new_namelen;	/* length of new attr name */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
 	int		whichfork;	/* data or attribute fork */
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 020aebd10..632dd9732 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -115,11 +115,13 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_BUD_FORMAT	26
 #define XLOG_REG_TYPE_ATTRI_FORMAT	27
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
-#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_NAME		29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
 #define XLOG_REG_TYPE_XMI_FORMAT	31
 #define XLOG_REG_TYPE_XMD_FORMAT	32
-#define XLOG_REG_TYPE_MAX		32
+#define XLOG_REG_TYPE_ATTR_NEWNAME	33
+#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
+#define XLOG_REG_TYPE_MAX		34
 
 /*
  * Flags to log operation header
@@ -1026,6 +1028,9 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_PPTR_SET	4	/* Set parent pointer */
+#define XFS_ATTRI_OP_FLAGS_PPTR_REMOVE	5	/* Remove parent pointer */
+#define XFS_ATTRI_OP_FLAGS_PPTR_REPLACE	6	/* Replace parent pointer */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -1048,7 +1053,18 @@ struct xfs_attri_log_format {
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
-	uint32_t	alfi_name_len;	/* attr name length */
+	union {
+		uint32_t	alfi_name_len;	/* attr name length */
+		struct {
+			/*
+			 * For PPTR_REPLACE, these are the lengths of the old
+			 * and new attr names.  The new and old values must
+			 * have the same length.
+			 */
+			uint16_t	alfi_old_name_len;
+			uint16_t	alfi_new_name_len;
+		};
+	};
 	uint32_t	alfi_value_len;	/* attr value length */
 	uint32_t	alfi_attr_filter;/* attr filter flags */
 };

