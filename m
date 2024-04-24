Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F19BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928105; cv=none; b=cgJNOlZZ32FprPFK9mLUhWskg6k0xV6x5G3cGbmgnpBo896LjZddeM4NhG6j60poybVqPbdgwDiyvnJAYrrp4Q3cCw0l7Gs+SG3xnwS66F1M5ei6YzVGF/Id9L5PAqz2b9evRoioYHG52Xgki6rAE345wQI7T3YRcIthn6TQvrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928105; c=relaxed/simple;
	bh=bFF0KaokPchZ1FFKprTV33OcOy2OkAAT05RFzxPOxPI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W0oHilXhSZW7ncuXHhla4JofHyqeojVqiKvRihIynHM8TXlfiHjx7N/gJGUDMrU/fHTctvfJqCLhjVdJtl8qK3F3tzjQ521zv4quykG1VhfkK3Yx6kyNS5mvrmhbxogNE7KBiEYlVKJw5BjdAzMch1EZrg2gaNLLZNu6DIVA59Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1Z20z3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1Z20z3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CCCC2BD10;
	Wed, 24 Apr 2024 03:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928105;
	bh=bFF0KaokPchZ1FFKprTV33OcOy2OkAAT05RFzxPOxPI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D1Z20z3liDjlblhDqjNawHQ7FkSvOiWYyCeoM71Ak25tgyVL27AWTVfODKdSMJBIk
	 Ivyt14dXWrz1ByImulLjhMhZ/tFKKGLDCFOkDHz7j/lIWdpCByeNgNUNYMRMB8XYs/
	 mOIUl3r/ClAf/Gotw4uWu5oVBKRohXcaUdGhx4867NzTdth/AldgMngXm+k5pZyPjn
	 BriixHajjMINa/X1LOfO/nHcUN0r2JiGpfiPouPIiTGnXDFVvpRg4FcUJPnU/gAYk5
	 HEaEF46x1apoX9lVTwlpS75qRDFKlF09SMjeHyQi2W9LuxugtjqLXpqa/8QyoDVtFl
	 ix7O45QtuS4SA==
Date: Tue, 23 Apr 2024 20:08:24 -0700
Subject: [PATCH 3/5] xfs: remove xfs_da_args.attr_flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782161.1904378.2149232663534391488.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
References: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
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

Note: The "UPSERTR" name created here is to make userspace porting
easier.  It will be removed in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 30e6084122d8..b04e09143869 100644
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
index 670ab2a613fc..228360f7c85c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -544,7 +544,14 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
-int xfs_attr_set(struct xfs_da_args *args);
+
+enum xfs_attr_update {
+	XFS_ATTRUPDATE_UPSERTR,	/* set/remove value, replace any existing attr */
+	XFS_ATTRUPDATE_CREATE,	/* set value, fail if attr already exists */
+	XFS_ATTRUPDATE_REPLACE,	/* set value, fail if attr does not exist */
+};
+
+int xfs_attr_set(struct xfs_da_args *args, enum xfs_attr_update op);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index b04a3290ffac..706b529a81fe 100644
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
index 7b4318764d03..3066d662ea13 100644
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
index 4bf69c9c088e..12f98af9e709 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -203,7 +203,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		xfs_acl_to_disk(args.value, acl);
 	}
 
-	error = xfs_attr_change(&args);
+	error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERTR);
 	kvfree(args.value);
 
 	/*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index efa95892655d..0eca7a9096e2 100644
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
+	return XFS_ATTRUPDATE_UPSERTR;
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
index ad76704ab133..d02ca2248bbc 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -63,7 +63,7 @@ xfs_initxattrs(
 			.value		= xattr->value,
 			.valuelen	= xattr->value_len,
 		};
-		error = xfs_attr_change(&args);
+		error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERTR);
 		if (error < 0)
 			break;
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 08df5bb70a6c..57f225ba7e8a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1999,7 +1999,6 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		__field(int, valuelen)
 		__field(xfs_dahash_t, hashval)
 		__field(unsigned int, attr_filter)
-		__field(unsigned int, attr_flags)
 		__field(uint32_t, op_flags)
 	),
 	TP_fast_assign(
@@ -2011,11 +2010,10 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
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
@@ -2025,9 +2023,6 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		  __entry->hashval,
 		  __print_flags(__entry->attr_filter, "|",
 				XFS_ATTR_FILTER_FLAGS),
-		   __print_flags(__entry->attr_flags, "|",
-				{ XATTR_CREATE,		"CREATE" },
-				{ XATTR_REPLACE,	"REPLACE" }),
 		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
 )
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 4ebf7052eb67..6ce1e06f650a 100644
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
+	return XFS_ATTRUPDATE_UPSERTR;
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
index cec766cad26c..c3eb858fb59e 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -6,7 +6,8 @@
 #ifndef __XFS_XATTR_H__
 #define __XFS_XATTR_H__
 
-int xfs_attr_change(struct xfs_da_args *args);
+enum xfs_attr_update;
+int xfs_attr_change(struct xfs_da_args *args, enum xfs_attr_update op);
 
 extern const struct xattr_handler * const xfs_xattr_handlers[];
 

