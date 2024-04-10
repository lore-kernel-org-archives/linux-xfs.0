Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605A038B
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710583; cv=none; b=Z+n3nPXrq6G8xGuEoYdJUNrGNx9liNnlpQYi6ztuWFDPDlloWB4OPJbCCwC8++Trn7gEuzOdRUznLNRlZp3hL75RsoP/s+EfaKUFXN/BtQRV/M8TEu3SQScYeUzja6RRz4un1BCCJoFX7Rx+FnEL4soCg4rbY6N4K/x8rycCvx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710583; c=relaxed/simple;
	bh=0Wx3n+wcu2Q+5SJl+nuakY56o/OcfkxIfnd3Wra5ymg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/8ksA81/u00t+WXJ+uB+KPIohq1DrRGkX1sDujc4JGLU8HlBpOZQQDljRR4yKkP+SARahZeaBFzCoCpQXgsiBZaeoMcPuvL59tec7Yv8CJBKVme9wAKu12qhhtbPkpiN1tRY13qjLUONfpo1kcwvPkyc1EMwTGOwn+CST3HZUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ubgvWTaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ubgvWTaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7C5C433C7;
	Wed, 10 Apr 2024 00:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710583;
	bh=0Wx3n+wcu2Q+5SJl+nuakY56o/OcfkxIfnd3Wra5ymg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ubgvWTaHBpXTraTSNjkjCEtC30MXkCmMXVM8mpgqtcKH7F+h/OvtCHkvDfaBIe4t5
	 2/rAIeHWEnn4fxSd37mYuqnvcP/fCmd673OA1PIOT9TZhDnnguIZqbuxRCjowaGLnM
	 hrAIUyBAyISf2g14omVIEsbDn2KE0PMx2yJU2/lKAlFQPmbBAPpcy9cssOxLhjs/3a
	 kvOUFRnnT3hn5SEYJdeikzBcjimqdCrYrXQum3TaMcuKV346f1J3WIP1JTogDyfcE5
	 kqBv0KC5HraDz3KKieb6v461FCuHR/EMHztRwP2LHpi8TUN2qB1G93209tWGVF/NXS
	 gcXyEQSvr4pLg==
Date: Tue, 09 Apr 2024 17:56:22 -0700
Subject: [PATCH 11/32] xfs: log parent pointer xattr replace operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969740.3631889.12974902040083725812.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

The parent pointer code needs to do a deferred parent pointer replace
operation with the xattr log intent code.  Declare a new logged xattr
opcode and push it through the log.

(Formerly titled "xfs: Add new name to attri/d" and described as
follows:

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.)

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: reworked to handle new disk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |   19 ++++
 fs/xfs/libxfs/xfs_attr.h       |    4 -
 fs/xfs/libxfs/xfs_da_btree.h   |    4 +
 fs/xfs/libxfs/xfs_log_format.h |   20 ++++
 fs/xfs/xfs_attr_item.c         |  193 ++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_attr_item.h         |    2 
 6 files changed, 218 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 30988d60162c7..6e47c493bf9e2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -441,6 +441,23 @@ xfs_attr_hashval(
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
@@ -461,6 +478,8 @@ xfs_attr_complete_op(
 
 	if (!(args->op_flags & XFS_DA_OP_REPLACE))
 		replace_state = XFS_DAS_DONE;
+	else if (xfs_attr_intent_op(attr) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE)
+		xfs_attr_update_pptr_replace_args(args);
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index df91c94d5bf5c..d63305fc54155 100644
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
index 47485f5edae86..8d7a38fe2a5c0 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t	*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
+	void		*new_value;	/* new xattr value (may contain NULLs) */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
 	struct xfs_trans *trans;	/* current trans (changes over time) */
 
@@ -63,11 +65,13 @@ typedef struct xfs_da_args {
 	xfs_ino_t	owner;		/* inode that owns the dir/attr data */
 
 	int		valuelen;	/* length of value */
+	int		new_valuelen;	/* length of new_value */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	uint8_t		op_flags;	/* operation flags */
 	uint8_t		attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
 	uint8_t		xattr_flags;	/* XATTR_{CREATE,REPLACE} */
 	short		namelen;	/* length of string (maybe no NULL) */
+	short		new_namelen;	/* length of new attr name */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
 	int		whichfork;	/* data or attribute fork */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 96732a212507e..632dd97324557 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
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
@@ -1028,6 +1030,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_PPTR_SET	4	/* Set parent pointer */
 #define XFS_ATTRI_OP_FLAGS_PPTR_REMOVE	5	/* Remove parent pointer */
+#define XFS_ATTRI_OP_FLAGS_PPTR_REPLACE	6	/* Replace parent pointer */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -1050,7 +1053,18 @@ struct xfs_attri_log_format {
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
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index d89495990f03b..8d33294217aca 100644
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
@@ -333,7 +381,17 @@ xfs_attr_log_item(
 	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
-	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+
+	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE) {
+		ASSERT(attr->xattri_nameval->value.i_len ==
+		       attr->xattri_nameval->new_value.i_len);
+
+		attrp->alfi_old_name_len = attr->xattri_nameval->name.i_len;
+		attrp->alfi_new_name_len = attr->xattri_nameval->new_name.i_len;
+	} else {
+		attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	}
+
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -374,8 +432,11 @@ xfs_attr_create_intent(
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
@@ -477,9 +538,6 @@ xfs_attri_validate(
 	if (!xfs_is_using_logged_xattrs(mp) && !xfs_has_parent(mp))
 		return false;
 
-	if (attrp->__pad != 0)
-		return false;
-
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
 		return false;
 
@@ -515,6 +573,21 @@ xfs_attri_validate(
 		    attrp->alfi_name_len > XATTR_NAME_MAX)
 			return false;
 		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		if (!xfs_has_parent(mp))
+			return false;
+		if (attrp->alfi_old_name_len == 0 ||
+		    attrp->alfi_old_name_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_new_name_len == 0 ||
+		    attrp->alfi_new_name_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_value_len == 0 ||
+		    attrp->alfi_value_len > XATTR_SIZE_MAX)
+			return false;
+		if (!(attrp->alfi_attr_filter & XFS_ATTR_PARENT))
+			return false;
+		break;
 	default:
 		return false;
 	}
@@ -587,8 +660,12 @@ xfs_attri_recover_work(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->new_name.i_addr;
+	args->new_namelen = nv->new_name.i_len;
 	args->value = nv->value.i_addr;
 	args->valuelen = nv->value.i_len;
+	args->new_value = nv->new_value.i_addr;
+	args->new_valuelen = nv->new_value.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
@@ -597,6 +674,7 @@ xfs_attri_recover_work(
 
 	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->total = xfs_attr_calc_size(args, &local);
@@ -706,7 +784,14 @@ xfs_attr_relog_intent(
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
-	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+
+	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE) {
+		new_attrp->alfi_new_name_len = old_attrp->alfi_new_name_len;
+		new_attrp->alfi_old_name_len = old_attrp->alfi_old_name_len;
+	} else {
+		new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	}
+
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	return &new_attrip->attri_item;
@@ -784,8 +869,10 @@ xfs_attr_defer_parent(
 		new->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTR_DEFER_REPLACE:
-		/* will be added in subsequent patches */
-		ASSERT(0);
+		ASSERT(args->new_valuelen == args->valuelen);
+
+		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_PPTR_REPLACE;
+		new->xattri_dela_state = xfs_attr_init_replace_state(args);
 		break;
 	case XFS_ATTR_DEFER_REMOVE:
 		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_PPTR_REMOVE;
@@ -822,9 +909,13 @@ xlog_recover_attri_commit_pass2(
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
@@ -876,6 +967,20 @@ xlog_recover_attri_commit_pass2(
 		}
 		name_len = attri_formatp->alfi_name_len;
 		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		/*
+		 * Log item, attr name, new attr name, attr value, new attr
+		 * value
+		 */
+		if (item->ri_total != 5) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_old_name_len;
+		new_name_len = attri_formatp->alfi_new_name_len;
+		new_value_len = value_len = attri_formatp->alfi_value_len;
+		break;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				     attri_formatp, len);
@@ -899,12 +1004,31 @@ xlog_recover_attri_commit_pass2(
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
+		if (!xfs_attr_namecheck(attri_formatp->alfi_attr_filter,
+					attr_new_name, new_name_len)) {
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
 
@@ -912,6 +1036,18 @@ xlog_recover_attri_commit_pass2(
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
@@ -949,6 +1085,23 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
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
@@ -957,7 +1110,9 @@ xlog_recover_attri_commit_pass2(
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
index f9efd674fd062..d5e4658f711d1 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,7 +13,9 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	new_name;	/* PPTR_REPLACE only */
 	struct xfs_log_iovec	value;
+	struct xfs_log_iovec	new_value;	/* PPTR_REPLACE only */
 	refcount_t		refcount;
 
 	/* name and value follow the end of this struct */

