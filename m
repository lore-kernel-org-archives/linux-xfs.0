Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8E4C8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZ/ry4sX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7924C433C7;
	Sun, 31 Dec 2023 23:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063875;
	bh=reJG7VGrPEdoDYNntwxpfp1J9+shAZEUZYU083LG9CM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HZ/ry4sXC0YYHAarsnvlHrpCFyZuXSkkI9rsS6KTfl4XW2wHvDMUOYDZ6R259sAXw
	 JlWliQx6AT805LmTCiKAJ2stkiX66qaGAX5F4U+jTuriVF2UZj0VOSetOD78uM9Ek4
	 K4hGuEYq3y2EyE7CgpFXlDQ7yOAs8d3aNNJzc4EFLgL3PkdSX+o614zXY/cy0Tgcb0
	 WzCbxENsiWsU0JpaniFGNy4thjbYiBPd47QiRFjTCrjpNBc+28J1D7T9eNjNxdWAyy
	 Idr2us2j/uRQkmbxJHhrcYGPQ7t1JL9BqG68RbGx/tkiiChhgHwxxnkX1ZF2DK0Mxb
	 N4eVpz0ip9Aqg==
Date: Sun, 31 Dec 2023 15:04:35 -0800
Subject: [PATCH 09/11] xfs: log NVLOOKUP xattr nvreplace operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005716.1804370.15258815822511157477.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_attr.c       |   16 ++++++++++++++++
 libxfs/xfs_attr.h       |    4 ++--
 libxfs/xfs_da_btree.h   |    6 +++++-
 libxfs/xfs_log_format.h |   27 +++++++++++++++++++++++----
 4 files changed, 46 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 47684d07693..3fe9041ae2c 100644
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
 
@@ -901,6 +915,8 @@ xfs_attr_defer_add(
 		new->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+			new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_NVREPLACE;
 		new->xattri_dela_state = xfs_attr_init_replace_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index ca51b93873b..b4e8ecee3e0 100644
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
index 1bcb291150e..93fcf49ab79 100644
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
index 2ac520a18e9..285a0a089df 100644
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
@@ -1045,6 +1047,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_NVSET	5	/* Set attr with w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	6	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -1062,11 +1065,27 @@ struct xfs_icreate_log {
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

