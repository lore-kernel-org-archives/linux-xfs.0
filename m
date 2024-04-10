Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A8DD51A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725317; cv=none; b=gnd0D9/DG8bKeIWl7mUar4WNIZdQX6uTlb9e3fkaIgMFL2zdA/sXi5okViZ/ysir/Rkb5yHdDITEfWe33qBrupgYpqRnPupCZrU8PiRrSc8yUoH/9LJtpKaxJov5jP8BCkV2+BQtcB1RfUqqYgGzROrCwXzNoF9o3fUcNT0PZzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725317; c=relaxed/simple;
	bh=CFGKJSMGOyNiDaNshji+USq3Cr38+DisQdPPSZDOCvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZIynbzIoFT3+pyRPRijgish9gNl4+ROho6DxytoW54OrMvo/SEpNX5uPvN+HndWS7ZQBeuzQ2lynSfiwRCUdAZ5fq1pwSeLmEIFH5eBK4aodXy25OXN4dSLMPkiJWcAOMY/jiGKMasyILgK6/hVxH59zwzVoETRBUg1/vWSX65M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QQtJRU0C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QQtJRU0C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X6dXXjQ50cB/BW83sdUf6f0Swh1tzaOzlX4fGc55/5M=; b=QQtJRU0CYRCsxvBG8Njlx8fXpc
	muWIM6Np2YSkYQ9HGCAL4aShttGpnCzmGBHlf7r6Z6vTXGP/BlZOAwKoGv3h6+ASAB/TEIDMUFAO7
	xD18VypRAtgsPnrfr30WMTdK3MMLQFByxrFTSxZof59zQPJBn3k7uOZqPG+wJc04NsuZIN16H5P1E
	oPlCeRW2ltaU2VPAbWzpLJtkviXq1iz0tMwj+RmE6ALzGuNp33fb7XZMCfMs/uETNeboOnnd2YwvJ
	/FqEkmfuTOYJiUTnHiGRyz2UnBWyPxOOTh+0AyWIRukxU9zKM1F+d4N/T+kkhw8oD24XvElpbOPZj
	7wHLNlKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQ5r-000000056mC-2OWs;
	Wed, 10 Apr 2024 05:01:55 +0000
Date: Tue, 9 Apr 2024 22:01:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: rename xfs_da_args.attr_flags
Message-ID: <ZhYdQ90rqsMOGaa1@infradead.org>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
 <171270968435.3631393.4664304714455437765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968435.3631393.4664304714455437765.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:50:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This field only ever contains XATTR_{CREATE,REPLACE}, so let's change
> the name of the field to make the field and its values consistent.

So, these flags only get passed to xfs_attr_set through xfs_attr_change
and xfs_attr_setname, which means we should probably just pass them
directly as in my patch (against your whole stack) below.

Also I suspect we should do an audit of all the internal callers
if they should ever be replace an existing attr, as I guess most
don't.  (and xfs_attr_change really should be folded into xfs_attr_set,
the split is confusing as hell).

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b98d2a908452a0..38d1f4d10baa3b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1034,7 +1034,8 @@ xfs_attr_ensure_iext(
  */
 int
 xfs_attr_set(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	uint8_t			xattr_flags)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1109,7 +1110,7 @@ xfs_attr_set(
 		}
 
 		/* Pure create fails if the attr already exists */
-		if (args->xattr_flags & XATTR_CREATE)
+		if (xattr_flags & XATTR_CREATE)
 			goto out_trans_cancel;
 		xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
 		break;
@@ -1119,7 +1120,7 @@ xfs_attr_set(
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */
-		if (args->xattr_flags & XATTR_REPLACE)
+		if (xattr_flags & XATTR_REPLACE)
 			goto out_trans_cancel;
 		xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
 		break;
@@ -1155,7 +1156,7 @@ xfs_attr_set(
  * Ensure that the xattr structure maps @args->name to @args->value.
  *
  * The caller must have initialized @args, attached dquots, and must not hold
- * any ILOCKs.  Only XATTR_CREATE may be specified in @args->xattr_flags.
+ * any ILOCKs.  Only XATTR_CREATE may be specified in @xattr_flags.
  * Reserved data blocks may be used if @rsvd is set.
  *
  * Returns -EEXIST if XATTR_CREATE was specified and the name already exists.
@@ -1163,6 +1164,7 @@ xfs_attr_set(
 int
 xfs_attr_setname(
 	struct xfs_da_args	*args,
+	uint8_t			xattr_flags,
 	bool			rsvd)
 {
 	struct xfs_inode	*dp = args->dp;
@@ -1172,7 +1174,7 @@ xfs_attr_setname(
 	int			rmt_extents = 0;
 	int			error, local;
 
-	ASSERT(!(args->xattr_flags & XATTR_REPLACE));
+	ASSERT(!(xattr_flags & ~XATTR_CREATE));
 	ASSERT(!args->trans);
 
 	args->total = xfs_attr_calc_size(args, &local);
@@ -1198,7 +1200,7 @@ xfs_attr_setname(
 	switch (error) {
 	case -EEXIST:
 		/* Pure create fails if the attr already exists */
-		if (args->xattr_flags & XATTR_CREATE)
+		if (xattr_flags & XATTR_CREATE)
 			goto out_trans_cancel;
 		if (args->attr_filter & XFS_ATTR_PARENT)
 			xfs_attr_defer_parent(args, XFS_ATTR_DEFER_REPLACE);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 2a0ef4f633e2d1..b90e04c3e64f60 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -550,7 +550,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
-int xfs_attr_set(struct xfs_da_args *args);
+int xfs_attr_set(struct xfs_da_args *args, uint8_t xattr_flags);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
 bool xfs_attr_check_namespace(unsigned int attr_flags);
@@ -560,7 +560,7 @@ int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
 
-int xfs_attr_setname(struct xfs_da_args *args, bool rsvd);
+int xfs_attr_setname(struct xfs_da_args *args, uint8_t xattr_flags, bool rsvd);
 int xfs_attr_removename(struct xfs_da_args *args, bool rsvd);
 
 /*
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 8d7a38fe2a5c07..354d5d65043e43 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -69,7 +69,6 @@ typedef struct xfs_da_args {
 	uint8_t		filetype;	/* filetype of inode for directories */
 	uint8_t		op_flags;	/* operation flags */
 	uint8_t		attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
-	uint8_t		xattr_flags;	/* XATTR_{CREATE,REPLACE} */
 	short		namelen;	/* length of string (maybe no NULL) */
 	short		new_namelen;	/* length of new attr name */
 	xfs_dahash_t	hashval;	/* hash value of name */
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 2b6ed8c1ee1522..c5422f714fcc72 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -355,7 +355,7 @@ xfs_parent_set(
 
 	memset(scratch, 0, sizeof(struct xfs_da_args));
 	xfs_parent_da_args_init(scratch, NULL, pptr, ip, owner, parent_name);
-	return xfs_attr_setname(scratch, true);
+	return xfs_attr_setname(scratch, 0, true);
 }
 
 /*
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index e06d00ea828b3e..8863eef5a0b87b 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -615,7 +615,6 @@ xrep_xattr_insert_rec(
 	struct xfs_da_args		args = {
 		.dp			= rx->sc->tempip,
 		.attr_filter		= key->flags,
-		.xattr_flags		= XATTR_CREATE,
 		.namelen		= key->namelen,
 		.valuelen		= key->valuelen,
 		.owner			= rx->sc->ip->i_ino,
@@ -675,7 +674,7 @@ xrep_xattr_insert_rec(
 	 * use reserved blocks because we can abort the repair with ENOSPC.
 	 */
 	xfs_attr_sethash(&args);
-	error = xfs_attr_setname(&args, false);
+	error = xfs_attr_setname(&args, XATTR_CREATE, false);
 	if (error == -EEXIST)
 		error = 0;
 
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index cf79cbcda3ecb4..1bc05efa344036 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -1031,7 +1031,7 @@ xrep_parent_insert_xattr(
 			rp->xattr_name, key->namelen, key->valuelen);
 
 	xfs_attr_sethash(&args);
-	return xfs_attr_setname(&args, false);
+	return xfs_attr_setname(&args, 0, false);
 }
 
 /*
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 4bf69c9c088e28..1aaf3dc64bcbc1 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -203,7 +203,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		xfs_acl_to_disk(args.value, acl);
 	}
 
-	error = xfs_attr_change(&args);
+	error = xfs_attr_change(&args, 0);
 	kvfree(args.value);
 
 	/*
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index 833b0d7d8bea1c..e3f54817b91557 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -492,7 +492,6 @@ xfs_attrmulti_attr_get(
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
 		.attr_filter	= xfs_attr_filter(flags),
-		.xattr_flags	= xfs_xattr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
 		.valuelen	= *len,
@@ -526,7 +525,6 @@ xfs_attrmulti_attr_set(
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
 		.attr_filter	= xfs_attr_filter(flags),
-		.xattr_flags	= xfs_xattr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
 	};
@@ -544,7 +542,7 @@ xfs_attrmulti_attr_set(
 		args.valuelen = len;
 	}
 
-	error = xfs_attr_change(&args);
+	error = xfs_attr_change(&args, xfs_xattr_flags(flags));
 	if (!error && (flags & XFS_IOC_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	kfree(args.value);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c4f9c7eec83590..d374be9f8a6e3e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -64,7 +64,7 @@ xfs_initxattrs(
 			.value		= xattr->value,
 			.valuelen	= xattr->value_len,
 		};
-		error = xfs_attr_change(&args);
+		error = xfs_attr_change(&args, 0);
 		if (error < 0)
 			break;
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index dc074240ad239f..1292d69087dc0c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2131,7 +2131,6 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		__field(int, valuelen)
 		__field(xfs_dahash_t, hashval)
 		__field(unsigned int, attr_filter)
-		__field(unsigned int, xattr_flags)
 		__field(uint32_t, op_flags)
 	),
 	TP_fast_assign(
@@ -2143,11 +2142,10 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		__entry->valuelen = args->valuelen;
 		__entry->hashval = args->hashval;
 		__entry->attr_filter = args->attr_filter;
-		__entry->xattr_flags = args->xattr_flags;
 		__entry->op_flags = args->op_flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
-		  "hashval 0x%x filter %s flags %s op_flags %s",
+		  "hashval 0x%x filter %s op_flags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->namelen,
@@ -2157,9 +2155,6 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		  __entry->hashval,
 		  __print_flags(__entry->attr_filter, "|",
 				XFS_ATTR_FILTER_FLAGS),
-		   __print_flags(__entry->xattr_flags, "|",
-				{ XATTR_CREATE,		"CREATE" },
-				{ XATTR_REPLACE,	"REPLACE" }),
 		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
 )
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 1d57e204c850ff..69fa7b89c68972 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -80,7 +80,8 @@ xfs_attr_want_log_assist(
  */
 int
 xfs_attr_change(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	uint8_t			xattr_flags)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	int			error;
@@ -95,7 +96,7 @@ xfs_attr_change(
 		args->op_flags |= XFS_DA_OP_LOGGED;
 	}
 
-	return xfs_attr_set(args);
+	return xfs_attr_set(args, xattr_flags);
 }
 
 
@@ -131,7 +132,6 @@ xfs_xattr_set(const struct xattr_handler *handler,
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
 		.attr_filter	= handler->flags,
-		.xattr_flags	= flags,
 		.name		= name,
 		.namelen	= strlen(name),
 		.value		= (void *)value,
@@ -139,7 +139,7 @@ xfs_xattr_set(const struct xattr_handler *handler,
 	};
 	int			error;
 
-	error = xfs_attr_change(&args);
+	error = xfs_attr_change(&args, flags);
 	if (!error && (handler->flags & XFS_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	return error;
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index f097002d06571f..79c0040cc904b4 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -6,7 +6,7 @@
 #ifndef __XFS_XATTR_H__
 #define __XFS_XATTR_H__
 
-int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_change(struct xfs_da_args *args, uint8_t xattr_flags);
 int xfs_attr_grab_log_assist(struct xfs_mount *mp);
 void xfs_attr_rele_log_assist(struct xfs_mount *mp);
 
