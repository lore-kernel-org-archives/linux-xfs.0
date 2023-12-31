Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87595BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2GRRR1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F63DC433C8;
	Sun, 31 Dec 2023 20:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055710;
	bh=SLroRS486hblgNAgQo6CuewSLeMu9XkuRBCSIzBEK6U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c2GRRR1gE2gbXIgZj28IUsxbqff31b8qx7BJZq3O8V4SxEdCjxqAvHftLmkowmOe9
	 TGROmoUgdHko6DWvZMz0XrJAX+ddn/JUUHbxjWfnJyXPKFl65g9dlKTdxMppWDERfb
	 mQiw+lAnMZYBIPVCN9vkg3R17QIdSjav06SOi0qSFMabVZTqsOxSq23TYFPxl6jalP
	 8ruanUSYOsybbNZ0YxRzRG4+/AaFzpdxO/VK9jha6WegIvM1kBZuotxD4RlzQIrk8/
	 4ZtlaWPv1Kb0S9LjYZK3jtV5oPiKdNh/ckleIfFL2fKccSiCzd3xDVLmYCihBIgIcY
	 dxEZcbtyaKbPQ==
Date: Sun, 31 Dec 2023 12:48:29 -0800
Subject: [PATCH 14/14] xfs: log NVLOOKUP xattr nvreplace operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840624.1756514.7950064928524872253.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
References: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr.c       |   16 +++
 fs/xfs/libxfs/xfs_attr.h       |    4 -
 fs/xfs/libxfs/xfs_da_btree.h   |    6 +
 fs/xfs/libxfs/xfs_log_format.h |   27 ++++-
 fs/xfs/xfs_attr_item.c         |  207 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_attr_item.h         |    2 
 6 files changed, 230 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a900e184f6566..c6621af9554c2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -425,6 +425,20 @@ xfs_attr_complete_op(
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
 
@@ -903,6 +917,8 @@ xfs_attr_defer_add(
 		new->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+			new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_NVREPLACE;
 		new->xattri_dela_state = xfs_attr_init_replace_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index ca51b93873bb9..b4e8ecee3e039 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 1bcb291150eb5..93fcf49ab79dc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
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
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 2ac520a18e909..285a0a089df24 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
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
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 1ae2ecfe780c2..a1c8036310b21 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -73,8 +73,12 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
+	const void			*new_name,
+	unsigned int			new_name_len,
 	const void			*value,
-	unsigned int			value_len)
+	unsigned int			value_len,
+	const void			*new_value,
+	unsigned int			new_value_len)
 {
 	struct xfs_attri_log_nameval	*nv;
 
@@ -83,15 +87,26 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + new_name_len + value_len +
+					new_value_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
+	if (new_name_len) {
+		nv->new_name.i_addr = nv->name.i_addr + name_len;
+		nv->new_name.i_len = new_name_len;
+		memcpy(nv->new_name.i_addr, new_name, new_name_len);
+	} else {
+		nv->new_name.i_addr = NULL;
+		nv->new_name.i_len = 0;
+	}
+	nv->new_name.i_type = XLOG_REG_TYPE_ATTR_NEWNAME;
+
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + name_len;
+		nv->value.i_addr = nv->name.i_addr + name_len + new_name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -100,6 +115,17 @@ xfs_attri_log_nameval_alloc(
 	}
 	nv->value.i_type = XLOG_REG_TYPE_ATTR_VALUE;
 
+	if (new_value_len) {
+		nv->new_value.i_addr = nv->name.i_addr + name_len +
+						new_name_len + value_len;
+		nv->new_value.i_len = new_value_len;
+		memcpy(nv->new_value.i_addr, new_value, new_value_len);
+	} else {
+		nv->new_value.i_addr = NULL;
+		nv->new_value.i_len = 0;
+	}
+	nv->new_value.i_type = XLOG_REG_TYPE_ATTR_NEWVALUE;
+
 	refcount_set(&nv->refcount, 1);
 	return nv;
 }
@@ -145,11 +171,20 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (!nv->value.i_len)
-		return;
+	if (nv->new_name.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->new_name.i_len);
+	}
 
-	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	if (nv->value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	}
+
+	if (nv->new_value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->new_value.i_len);
+	}
 }
 
 /*
@@ -179,15 +214,28 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->new_name.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
+	if (nv->new_value.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
+
+	if (nv->new_name.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->new_name);
+
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
+
+	if (nv->new_value.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->new_value);
 }
 
 /*
@@ -333,7 +381,15 @@ xfs_attr_log_item(
 	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
-	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+
+	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
+		attrp->alfi_old_name_len = attr->xattri_nameval->name.i_len;
+		attrp->alfi_new_name_len = attr->xattri_nameval->new_name.i_len;
+		attrp->alfi_new_value_len = attr->xattri_nameval->new_value.i_len;
+	} else {
+		attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	}
+
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -374,8 +430,11 @@ xfs_attr_create_intent(
 		 * Transfer our reference to the name/value buffer to the
 		 * deferred work state structure.
 		 */
-		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+		attr->xattri_nameval = xfs_attri_log_nameval_alloc(
+				args->name, args->namelen,
+				args->new_name, args->new_namelen,
+				args->value, args->valuelen,
+				args->new_value, args->new_valuelen);
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
@@ -478,9 +537,6 @@ xfs_attri_validate(
 	    !xfs_attri_can_use_without_log_assistance(mp))
 		return false;
 
-	if (attrp->__pad != 0)
-		return false;
-
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
 		return false;
 
@@ -489,23 +545,43 @@ xfs_attri_validate(
 
 	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (attrp->alfi_value_len != 0)
+			return false;
+		if (attrp->alfi_name_len == 0 ||
+		    attrp->alfi_name_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_new_value_len != 0)
+			return false;
+		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-	case XFS_ATTRI_OP_FLAGS_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 	case XFS_ATTRI_OP_FLAGS_NVSET:
+		if (attrp->alfi_name_len == 0 ||
+		    attrp->alfi_name_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+			return false;
+		if (attrp->alfi_new_value_len != 0)
+			return false;
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (attrp->alfi_old_name_len == 0 ||
+		    attrp->alfi_old_name_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_new_name_len == 0 ||
+		    attrp->alfi_new_name_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+			return false;
+		if (attrp->alfi_new_value_len > XATTR_SIZE_MAX)
+			return false;
 		break;
 	default:
 		return false;
 	}
 
-	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
-		return false;
-
-	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
-	    (attrp->alfi_name_len == 0))
-		return false;
-
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
@@ -546,15 +622,20 @@ xfs_attri_recover_work(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->new_name.i_addr;
+	args->new_namelen = nv->new_name.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->value = nv->value.i_addr;
 	args->valuelen = nv->value.i_len;
+	args->new_value = nv->new_value.i_addr;
+	args->new_valuelen = nv->new_value.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
 	args->owner = args->dp->i_ino;
 
 	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 	case XFS_ATTRI_OP_FLAGS_NVSET:
 		args->op_flags |= XFS_DA_OP_NVLOOKUP;
 		fallthrough;
@@ -666,7 +747,15 @@ xfs_attr_relog_intent(
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
-	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+
+	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
+		new_attrp->alfi_new_name_len = old_attrp->alfi_new_name_len;
+		new_attrp->alfi_old_name_len = old_attrp->alfi_old_name_len;
+		new_attrp->alfi_new_value_len = old_attrp->alfi_new_value_len;
+	} else {
+		new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	}
+
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	return &new_attrip->attri_item;
@@ -719,9 +808,13 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_name;
 	const void			*attr_value = NULL;
+	const void			*attr_new_name = NULL;
+	const void			*attr_new_value = NULL;
 	size_t				len;
 	unsigned int			name_len = 0;
 	unsigned int			value_len = 0;
+	unsigned int			new_name_len = 0;
+	unsigned int			new_value_len = 0;
 	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -773,6 +866,21 @@ xlog_recover_attri_commit_pass2(
 		}
 		name_len = attri_formatp->alfi_name_len;
 		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		/*
+		 * Log item, attr name, new attr name, optional attr value,
+		 * optional new attr value
+		 */
+		if (item->ri_total < 3 || item->ri_total > 5) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_old_name_len;
+		new_name_len = attri_formatp->alfi_new_name_len;
+		value_len = attri_formatp->alfi_value_len;
+		new_value_len = attri_formatp->alfi_new_value_len;
+		break;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				     attri_formatp, len);
@@ -795,12 +903,30 @@ xlog_recover_attri_commit_pass2(
 	}
 	i++;
 
+	/* Validate the new attr name */
+	if (new_name_len > 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(new_name_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+
+		attr_new_name = item->ri_buf[i].i_addr;
+		if (!xfs_attr_namecheck(attr_new_name, new_name_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+		i++;
+	}
+
 	/* Validate the attr value, if present */
 	if (value_len != 0) {
 		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					item->ri_buf[0].i_addr,
-					item->ri_buf[0].i_len);
+					attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
 
@@ -808,6 +934,18 @@ xlog_recover_attri_commit_pass2(
 		i++;
 	}
 
+	/* Validate the new attr value, if present */
+	if (new_value_len != 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(new_value_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+
+		attr_new_value = item->ri_buf[i].i_addr;
+		i++;
+	}
+
 	/*
 	 * Make sure we got the correct number of buffers for the operation
 	 * that we just loaded.
@@ -845,6 +983,23 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		/*
+		 * Name-value replace operations require the caller to
+		 * specify the old and new names and values explicitly.
+		 * Values are optional.
+		 */
+		if (attr_name == NULL || name_len == 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		if (attr_new_name == NULL || new_name_len == 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
 	}
 
 	/*
@@ -853,7 +1008,9 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name, name_len,
-			attr_value, value_len);
+			attr_new_name, new_name_len,
+			attr_value, value_len,
+			attr_new_value, new_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 3280a79302876..9ae0b3696847b 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,7 +13,9 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	new_name;	/* NVREPLACE only */
 	struct xfs_log_iovec	value;
+	struct xfs_log_iovec	new_value;	/* NVREPLACE only */
 	refcount_t		refcount;
 
 	/* name and value follow the end of this struct */

