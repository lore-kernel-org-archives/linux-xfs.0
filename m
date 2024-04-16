Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCB24C7E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230513; cv=none; b=I1vpVf+u2mUHl2B2tTv5w53mEMbxrMzEgCToJ6x/OBraiIDlylfMqUB6iU3frgX+iR7QoJDCj5hi+CKHCLGfwtlnOgiychXu9cerXLEdCQ1fo2quSdQvFwRG0jin55ZAqi/l4pl9RkKvW96+/qfX82+wdk7RxeF471jcvk6SVx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230513; c=relaxed/simple;
	bh=fVho7BSgnvEQPu2cPJubFb126jLQB8FGHQ1N5pCUJSk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sDLpFl7iSYrdvxnTElkE0OWZ8xN/O1xs/Jv3WIy2NB2Z6CwQXvs4xVuGtyEnEVyI+qVdq3TBM3qCBJthTf8XIkEeIiNJla4QDouYmfFed7p3ZThMqck2UaGWz1lcPATo/lN6hWcZRlkc9gG9QFoja06am2Xtd9+nruLqBuOGT7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2kPEXQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2kPEXQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AECC113CC;
	Tue, 16 Apr 2024 01:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230512;
	bh=fVho7BSgnvEQPu2cPJubFb126jLQB8FGHQ1N5pCUJSk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p2kPEXQohNX8RswY74L8lXo725HaQFf2a77CeJ3vk40eZ6GDWYGZLSSQYh3iMz8bF
	 SLLeQYg/X8hrmsEJ9AKdKB78/5m534G3jPvzafcgaBDQeu6JxIiGH7MDz2P5lA0Ef8
	 g+51kqbVd6uwCVt8uH7wmMjOljQjG2lRrY5cnPw9BNwtsxAWMNl9BKLUMgUHsgOKZC
	 5JtfZ2rt3uGTZM7+7PpO+Wc/ry8sjko78SprQ8KwSxD//cu2AlmdbR3gX0Hv2GtSzP
	 7oVhXxuKnG4QeGc/SeaBOJ+7kfuA2nUTJ3JO/lmSwm2AUfwrguR1jR499qylp3xdk9
	 hXsbe/FV+Thdg==
Date: Mon, 15 Apr 2024 18:21:52 -0700
Subject: [PATCH 3/5] xfs: remove xfs_da_args.attr_flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Message-ID: <171323026636.250975.12612221980696101903.stgit@frogsfrogsfrogs>
In-Reply-To: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
References: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
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

This field only ever contains XATTR_{CREATE,REPLACE}, and it only goes
as deep as xfs_attr_set.  Remove the field from the structure and
replace it with an enum specifying exactly what kind of change we want
to make to the xattr structure.  Upsert is the name that we'll give to
the flags==0 operation, because we're either updating an existing value
or inserting it, and the caller doesn't care.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c     |    7 ++++---
 fs/xfs/libxfs/xfs_attr.h     |    9 ++++++++-
 fs/xfs/libxfs/xfs_da_btree.h |    1 -
 fs/xfs/scrub/attr_repair.c   |    3 +--
 fs/xfs/xfs_acl.c             |    2 +-
 fs/xfs/xfs_ioctl.c           |   14 ++++++--------
 fs/xfs/xfs_iops.c            |    2 +-
 fs/xfs/xfs_trace.h           |    7 +------
 fs/xfs/xfs_xattr.c           |   19 +++++++++++++++----
 fs/xfs/xfs_xattr.h           |    3 ++-
 10 files changed, 39 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 30e6084122d8b..b04e09143869d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -922,7 +922,8 @@ xfs_attr_defer_add(
  */
 int
 xfs_attr_set(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	enum xfs_attr_update	op)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1008,7 +1009,7 @@ xfs_attr_set(
 		}
 
 		/* Pure create fails if the attr already exists */
-		if (args->attr_flags & XATTR_CREATE)
+		if (op == XFS_ATTRUPDATE_CREATE)
 			goto out_trans_cancel;
 		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REPLACE);
 		break;
@@ -1018,7 +1019,7 @@ xfs_attr_set(
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */
-		if (args->attr_flags & XATTR_REPLACE)
+		if (op == XFS_ATTRUPDATE_REPLACE)
 			goto out_trans_cancel;
 		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
 		break;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 670ab2a613fc6..02dca538f6b91 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -544,7 +544,14 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
-int xfs_attr_set(struct xfs_da_args *args);
+
+enum xfs_attr_update {
+	XFS_ATTRUPDATE_UPSERT,	/* set value, replace any existing attr */
+	XFS_ATTRUPDATE_CREATE,	/* set value, fail if attr already exists */
+	XFS_ATTRUPDATE_REPLACE,	/* set value, fail if attr does not exist */
+};
+
+int xfs_attr_set(struct xfs_da_args *args, enum xfs_attr_update op);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index b04a3290ffacc..706b529a81feb 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -60,7 +60,6 @@ typedef struct xfs_da_args {
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
-	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_ino_t	inumber;	/* input/output inode number */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 7b4318764d030..3066d662ea13f 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -557,7 +557,6 @@ xrep_xattr_insert_rec(
 	struct xfs_da_args		args = {
 		.dp			= rx->sc->tempip,
 		.attr_filter		= key->flags,
-		.attr_flags		= XATTR_CREATE,
 		.namelen		= key->namelen,
 		.valuelen		= key->valuelen,
 		.owner			= rx->sc->ip->i_ino,
@@ -605,7 +604,7 @@ xrep_xattr_insert_rec(
 	 * xfs_attr_set creates and commits its own transaction.  If the attr
 	 * already exists, we'll just drop it during the rebuild.
 	 */
-	error = xfs_attr_set(&args);
+	error = xfs_attr_set(&args, XFS_ATTRUPDATE_CREATE);
 	if (error == -EEXIST)
 		error = 0;
 
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 4bf69c9c088e2..ea3ae0acff096 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -203,7 +203,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		xfs_acl_to_disk(args.value, acl);
 	}
 
-	error = xfs_attr_change(&args);
+	error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERT);
 	kvfree(args.value);
 
 	/*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 69704426fc8d3..9cf3f8d16c055 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -361,15 +361,15 @@ xfs_attr_filter(
 	return 0;
 }
 
-static unsigned int
-xfs_attr_flags(
+static inline enum xfs_attr_update
+xfs_xattr_flags(
 	u32			ioc_flags)
 {
 	if (ioc_flags & XFS_IOC_ATTR_CREATE)
-		return XATTR_CREATE;
+		return XFS_ATTRUPDATE_CREATE;
 	if (ioc_flags & XFS_IOC_ATTR_REPLACE)
-		return XATTR_REPLACE;
-	return 0;
+		return XFS_ATTRUPDATE_REPLACE;
+	return XFS_ATTRUPDATE_UPSERT;
 }
 
 int
@@ -476,7 +476,6 @@ xfs_attrmulti_attr_get(
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
 		.attr_filter	= xfs_attr_filter(flags),
-		.attr_flags	= xfs_attr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
 		.valuelen	= *len,
@@ -510,7 +509,6 @@ xfs_attrmulti_attr_set(
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
 		.attr_filter	= xfs_attr_filter(flags),
-		.attr_flags	= xfs_attr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
 	};
@@ -528,7 +526,7 @@ xfs_attrmulti_attr_set(
 		args.valuelen = len;
 	}
 
-	error = xfs_attr_change(&args);
+	error = xfs_attr_change(&args, xfs_xattr_flags(flags));
 	if (!error && (flags & XFS_IOC_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	kfree(args.value);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 7f0c840f0fd2f..76c0d482ae481 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -63,7 +63,7 @@ xfs_initxattrs(
 			.value		= xattr->value,
 			.valuelen	= xattr->value_len,
 		};
-		error = xfs_attr_change(&args);
+		error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERT);
 		if (error < 0)
 			break;
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ba7b01a390c00..2d394038a5927 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2000,7 +2000,6 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		__field(int, valuelen)
 		__field(xfs_dahash_t, hashval)
 		__field(unsigned int, attr_filter)
-		__field(unsigned int, attr_flags)
 		__field(uint32_t, op_flags)
 	),
 	TP_fast_assign(
@@ -2012,11 +2011,10 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		__entry->valuelen = args->valuelen;
 		__entry->hashval = args->hashval;
 		__entry->attr_filter = args->attr_filter;
-		__entry->attr_flags = args->attr_flags;
 		__entry->op_flags = args->op_flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
-		  "hashval 0x%x filter %s flags %s op_flags %s",
+		  "hashval 0x%x filter %s op_flags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->namelen,
@@ -2026,9 +2024,6 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		  __entry->hashval,
 		  __print_flags(__entry->attr_filter, "|",
 				XFS_ATTR_FILTER_FLAGS),
-		   __print_flags(__entry->attr_flags, "|",
-				{ XATTR_CREATE,		"CREATE" },
-				{ XATTR_REPLACE,	"REPLACE" }),
 		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
 )
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 4ebf7052eb673..c2d17def7d9d1 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -73,7 +73,8 @@ xfs_attr_want_log_assist(
  */
 int
 xfs_attr_change(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	enum xfs_attr_update	op)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	int			error;
@@ -88,7 +89,7 @@ xfs_attr_change(
 		args->op_flags |= XFS_DA_OP_LOGGED;
 	}
 
-	return xfs_attr_set(args);
+	return xfs_attr_set(args, op);
 }
 
 
@@ -115,6 +116,17 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 	return args.valuelen;
 }
 
+static inline enum xfs_attr_update
+xfs_xattr_flags_to_op(
+	int		flags)
+{
+	if (flags & XATTR_CREATE)
+		return XFS_ATTRUPDATE_CREATE;
+	if (flags & XATTR_REPLACE)
+		return XFS_ATTRUPDATE_REPLACE;
+	return XFS_ATTRUPDATE_UPSERT;
+}
+
 static int
 xfs_xattr_set(const struct xattr_handler *handler,
 	      struct mnt_idmap *idmap, struct dentry *unused,
@@ -124,7 +136,6 @@ xfs_xattr_set(const struct xattr_handler *handler,
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
 		.attr_filter	= handler->flags,
-		.attr_flags	= flags,
 		.name		= name,
 		.namelen	= strlen(name),
 		.value		= (void *)value,
@@ -132,7 +143,7 @@ xfs_xattr_set(const struct xattr_handler *handler,
 	};
 	int			error;
 
-	error = xfs_attr_change(&args);
+	error = xfs_attr_change(&args, xfs_xattr_flags_to_op(flags));
 	if (!error && (handler->flags & XFS_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	return error;
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index cec766cad26cd..c3eb858fb59e7 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -6,7 +6,8 @@
 #ifndef __XFS_XATTR_H__
 #define __XFS_XATTR_H__
 
-int xfs_attr_change(struct xfs_da_args *args);
+enum xfs_attr_update;
+int xfs_attr_change(struct xfs_da_args *args, enum xfs_attr_update op);
 
 extern const struct xattr_handler * const xfs_xattr_handlers[];
 

