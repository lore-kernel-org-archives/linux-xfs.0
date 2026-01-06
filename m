Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAE7322DAF;
	Tue,  6 Jan 2026 08:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767686967; cv=none; b=k0mm5z2ANpD5qFseyeKVYh7JflG5zddzbYf8ZtXDPQSV+Te2S4dVEKOT0z+nQ8U4dtG4FRacyF9Wc4/eIosT9WxoIH8rPX5sa3wacGXm7K1db29v/s0YgveWSH5xSGTu/boP2eu2ex1HAerYV0SVSIdYao2IPVzCZlQnrWcqhtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767686967; c=relaxed/simple;
	bh=P9fm58xbEQDwQj50Z166DjrMxnOBNvcNph30Te2THXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxpigxHUdwWPi8319m2fJFwMvBY7fU31EOra8FVam0yGeJu9rXavW200P3B1XPCjPyQrsrLKOBQaqu9c23e0OeygbbMIMB+BoEkyyiDsEqD5HL7Uj26KOvTBoUEepKqV6Uz6WB/rpBsW32Su9ofdjUQPwHxRWBa0ZOkgSMUvIx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3FXDY6ff; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3FXDY6ff"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hRygh2nSrmA6oNuLt6iSZZ7a4khCTs3Pz4Q7gGNkrOQ=; b=3FXDY6ff+N1DWPWX1UwiZr2kGC
	2AX1JJqWnItBk30U1e0jv7hrphJkyIXjDLGwHrh3ktG9TNGdEEm5o8hQS57wYYdnNrT+TjLK7cHFn
	QwuUlu+bRIYneLm6hU38gET18U8yjQcK8ioXl4+32wlZvXxpiN5roMv/2OT6G94hNCv/CEJmVpJN2
	iR8tcn13YRBD1dos6l3mocgDV9aIBRRljeQHyjDPkIwnXQNnwsi/pkQa/d0sef+nsP7XeCiWc3law
	dztXxHSEacO241yZ/usZtHsDXFrDuyGgTLn2jBY5xnM/hiOeP0BDMOJvP8bqW8plDDXOod7kkyj/X
	t+k2DbJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd285-0000000Carj-0J8F;
	Tue, 06 Jan 2026 08:09:25 +0000
Date: Tue, 6 Jan 2026 00:09:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix NULL ptr in xfs_attr_leaf_get
Message-ID: <aVzDNYiygzgjMAkA@infradead.org>
References: <20251230190029.32684-1-mark.tinguely@oracle.com>
 <17cd5bef-e787-4dc9-9536-112d1e2cda2d@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17cd5bef-e787-4dc9-9536-112d1e2cda2d@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 30, 2025 at 01:02:41PM -0600, Mark Tinguely wrote:
> 
> The error path of xfs_attr_leaf_hasname() can leave a NULL
> xfs_buf pointer. xfs_has_attr() checks for the NULL pointer but
> the other callers do not.
> 
> We tripped over the NULL pointer in xfs_attr_leaf_get() but fix
> the other callers too.
> 
> Fixes v5.8-rc4-95-g07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> No reproducer.

Eww, what a mess.  I think we're better off to always leave releasing
bp to the caller.  Something like the patch below.  Only compile tested
for now, but I'll kick off an xfstests run.

Or maybe we might just kill off xfs_attr_leaf_hasname entirely and open
code it in the three callers, which might end up being more readable?

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8c04acd30d48..c5259641dd97 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -50,7 +50,6 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -951,6 +950,22 @@ xfs_attr_set_iter(
 	return error;
 }
 
+/*
+ * Return EEXIST if attr is found, or ENOATTR if not.
+ * Caller must relese @bp on error if non-NULL.
+ */
+static int
+xfs_attr_leaf_hasname(
+	struct xfs_da_args	*args,
+	struct xfs_buf		**bp)
+{
+	int                     error;
+
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, bp);
+	if (error)
+		return error;
+	return xfs_attr3_leaf_lookup_int(*bp, args);
+}
 
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
@@ -980,10 +995,8 @@ xfs_attr_lookup(
 
 	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_hasname(args, &bp);
-
 		if (bp)
 			xfs_trans_brelse(args->trans, bp);
-
 		return error;
 	}
 
@@ -1222,27 +1235,6 @@ xfs_attr_shortform_addname(
  * External routines when attribute list is one block
  *========================================================================*/
 
-/*
- * Return EEXIST if attr is found, or ENOATTR if not
- */
-STATIC int
-xfs_attr_leaf_hasname(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**bp)
-{
-	int                     error = 0;
-
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, bp);
-	if (error)
-		return error;
-
-	error = xfs_attr3_leaf_lookup_int(*bp, args);
-	if (error != -ENOATTR && error != -EEXIST)
-		xfs_trans_brelse(args->trans, *bp);
-
-	return error;
-}
-
 /*
  * Remove a name from the leaf attribute list structure
  *
@@ -1253,26 +1245,24 @@ STATIC int
 xfs_attr_leaf_removename(
 	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp;
-	struct xfs_buf		*bp;
+	struct xfs_inode	*dp = args->dp;
 	int			error, forkoff;
+	struct xfs_buf		*bp;
 
 	trace_xfs_attr_leaf_removename(args);
 
-	/*
-	 * Remove the attribute.
-	 */
-	dp = args->dp;
-
 	error = xfs_attr_leaf_hasname(args, &bp);
-	if (error == -ENOATTR) {
-		xfs_trans_brelse(args->trans, bp);
-		if (args->op_flags & XFS_DA_OP_RECOVERY)
+	if (error != -EEXIST) {
+		if (bp)
+			xfs_trans_brelse(args->trans, bp);
+		if (error == -ENOATTR && (args->op_flags & XFS_DA_OP_RECOVERY))
 			return 0;
 		return error;
-	} else if (error != -EEXIST)
-		return error;
+	}
 
+	/*
+	 * Remove the attribute.
+	 */
 	xfs_attr3_leaf_remove(bp, args);
 
 	/*
@@ -1281,8 +1271,8 @@ xfs_attr_leaf_removename(
 	forkoff = xfs_attr_shortform_allfit(bp, dp);
 	if (forkoff)
 		return xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-		/* bp is gone due to xfs_da_shrink_inode */
 
+	/* bp is gone due to xfs_da_shrink_inode */
 	return 0;
 }
 
@@ -1295,24 +1285,19 @@ xfs_attr_leaf_removename(
  * Returns 0 on successful retrieval, otherwise an error.
  */
 STATIC int
-xfs_attr_leaf_get(xfs_da_args_t *args)
+xfs_attr_leaf_get(
+	struct xfs_da_args	*args)
 {
-	struct xfs_buf *bp;
-	int error;
+	struct xfs_buf		*bp;
+	int			error;
 
 	trace_xfs_attr_leaf_get(args);
 
 	error = xfs_attr_leaf_hasname(args, &bp);
-
-	if (error == -ENOATTR)  {
+	if (error == -EEXIST)
+		error = xfs_attr3_leaf_getvalue(bp, args);
+	if (bp)
 		xfs_trans_brelse(args->trans, bp);
-		return error;
-	} else if (error != -EEXIST)
-		return error;
-
-
-	error = xfs_attr3_leaf_getvalue(bp, args);
-	xfs_trans_brelse(args->trans, bp);
 	return error;
 }
 
