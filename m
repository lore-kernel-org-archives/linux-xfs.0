Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AA8846F
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804034; cv=none; b=Ap+KXAKqarUftH63//264UD2wH9egNtu1S+2EpelRlDc/pXQLcyt/3LJw96RQx25PyH1kTOcq8JzHVLpn9GCbOy+5OYBKbyPapYzjh1SCebuROgXhZcDsBGMdC4nmAO2tY1nD+p8GeKVSrWsHF8bGVGyJMgY8K9ySJrCTQMIdQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804034; c=relaxed/simple;
	bh=6B9t/pzuM0HyJd03Rxmloqd3SZxzprcoXyUhdg0X0XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIDwFra4x2F70sX67yox/byhNyHz2++OzE45l9GgQY2xwNv7pjDazMToywoAXVHKeKFVsqSNciMjgG6M8usyxHWDuQKwJet+QM/f++8XaeZP4v9iLHTRXnWvhK4vX2OR/DjuGO3Q4Pu+9LxcjDcZFTQD8gjfR88XM8qjkBRcQHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wy6T2pBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wy6T2pBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97219C32782;
	Mon, 22 Apr 2024 16:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804034;
	bh=6B9t/pzuM0HyJd03Rxmloqd3SZxzprcoXyUhdg0X0XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wy6T2pBFz0T8xsFUev2mkGJnqZ/vNdtZWqCqdpdDwhvSFj3RcgBdKJCnTMRkEYJv9
	 4e4mQWO9eNgQf5PjMxLmPShbs/RaSmqoPPoBHETLV/VeDGHhK5jPT3o8yor9JzE0qF
	 dw8BsLMDGUqztUq/EOqNKKB50MqlpHcFNizBz+uf9JeLcXkHMRHNcq3LnYNsBTI9Mf
	 wmv32XINHEnis/vr51zP6jBnKIlE2Ir3yXIc8v0C5sKLweZ8yp+7cTXgffY643TBMs
	 QT3G15vSovSqAz9NQ01L2UFuy3xydZLUtcpBbPySsia8iuF07n0TgXNTfuEfMc2k4W
	 tWYj53e6wYjMA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 57/67] xfs: simplify xfs_attr_sf_findname
Date: Mon, 22 Apr 2024 18:26:19 +0200
Message-ID: <20240422163832.858420-59-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 6c8d169bbd51fc10d1d0029d495962881315b4c2

xfs_attr_sf_findname has the simple job of finding a xfs_attr_sf_entry in
the attr fork, but the convoluted calling convention obfuscates that.

Return the found entry as the return value instead of an pointer
argument, as the -ENOATTR/-EEXIST can be trivally derived from that, and
remove the basep argument, as it is equivalent of the offset of sfe in
the data for if an sfe was found, or an offset of totsize if not was
found.  To simplify the totsize computation add a xfs_attr_sf_endptr
helper that returns the imaginative xfs_attr_sf_entry at the end of
the current attrs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr.c      |  7 ++-
 libxfs/xfs_attr_leaf.c | 96 +++++++++++++++---------------------------
 libxfs/xfs_attr_leaf.h |  4 +-
 libxfs/xfs_attr_sf.h   |  7 +++
 4 files changed, 48 insertions(+), 66 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d7512efd4..d5a5ae6e2 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -860,8 +860,11 @@ xfs_attr_lookup(
 	if (!xfs_inode_hasattr(dp))
 		return -ENOATTR;
 
-	if (dp->i_af.if_format == XFS_DINODE_FMT_LOCAL)
-		return xfs_attr_sf_findname(args, NULL, NULL);
+	if (dp->i_af.if_format == XFS_DINODE_FMT_LOCAL) {
+		if (xfs_attr_sf_findname(args))
+			return -EEXIST;
+		return -ENOATTR;
+	}
 
 	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_hasname(args, &bp);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 10ed518f3..6ea364059 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -695,47 +695,24 @@ xfs_attr_shortform_create(
 }
 
 /*
- * Return -EEXIST if attr is found, or -ENOATTR if not
- * args:  args containing attribute name and namelen
- * sfep:  If not null, pointer will be set to the last attr entry found on
-	  -EEXIST.  On -ENOATTR pointer is left at the last entry in the list
- * basep: If not null, pointer is set to the byte offset of the entry in the
- *	  list on -EEXIST.  On -ENOATTR, pointer is left at the byte offset of
- *	  the last entry in the list
+ * Return the entry if the attr in args is found, or NULL if not.
  */
-int
+struct xfs_attr_sf_entry *
 xfs_attr_sf_findname(
-	struct xfs_da_args	 *args,
-	struct xfs_attr_sf_entry **sfep,
-	unsigned int		 *basep)
+	struct xfs_da_args		*args)
 {
-	struct xfs_attr_shortform *sf = args->dp->i_af.if_data;
-	struct xfs_attr_sf_entry *sfe;
-	unsigned int		base = sizeof(struct xfs_attr_sf_hdr);
-	int			size = 0;
-	int			end;
-	int			i;
+	struct xfs_attr_shortform	*sf = args->dp->i_af.if_data;
+	struct xfs_attr_sf_entry	*sfe;
 
-	sfe = &sf->list[0];
-	end = sf->hdr.count;
-	for (i = 0; i < end; sfe = xfs_attr_sf_nextentry(sfe),
-			     base += size, i++) {
-		size = xfs_attr_sf_entsize(sfe);
-		if (!xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				    sfe->flags))
-			continue;
-		break;
+	for (sfe = &sf->list[0];
+	     sfe < xfs_attr_sf_endptr(sf);
+	     sfe = xfs_attr_sf_nextentry(sfe)) {
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			return sfe;
 	}
 
-	if (sfep != NULL)
-		*sfep = sfe;
-
-	if (basep != NULL)
-		*basep = base;
-
-	if (i == end)
-		return -ENOATTR;
-	return -EEXIST;
+	return NULL;
 }
 
 /*
@@ -752,21 +729,19 @@ xfs_attr_shortform_add(
 	struct xfs_ifork		*ifp = &dp->i_af;
 	struct xfs_attr_shortform	*sf = ifp->if_data;
 	struct xfs_attr_sf_entry	*sfe;
-	int				offset, size;
+	int				size;
 
 	trace_xfs_attr_sf_add(args);
 
 	dp->i_forkoff = forkoff;
 
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-	if (xfs_attr_sf_findname(args, &sfe, NULL) == -EEXIST)
-		ASSERT(0);
+	ASSERT(!xfs_attr_sf_findname(args));
 
-	offset = (char *)sfe - (char *)sf;
 	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
 	sf = xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
-	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
 
+	sfe = xfs_attr_sf_endptr(sf);
 	sfe->namelen = args->namelen;
 	sfe->valuelen = args->valuelen;
 	sfe->flags = args->attr_filter;
@@ -806,39 +781,38 @@ xfs_attr_sf_removename(
 	struct xfs_mount		*mp = dp->i_mount;
 	struct xfs_attr_shortform	*sf = dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
-	int				size = 0, end, totsize;
-	unsigned int			base;
-	int				error;
+	uint16_t			totsize = be16_to_cpu(sf->hdr.totsize);
+	void				*next, *end;
+	int				size = 0;
 
 	trace_xfs_attr_sf_remove(args);
 
-	error = xfs_attr_sf_findname(args, &sfe, &base);
-
-	/*
-	 * If we are recovering an operation, finding nothing to
-	 * remove is not an error - it just means there was nothing
-	 * to clean up.
-	 */
-	if (error == -ENOATTR && (args->op_flags & XFS_DA_OP_RECOVERY))
-		return 0;
-	if (error != -EEXIST)
-		return error;
-	size = xfs_attr_sf_entsize(sfe);
+	sfe = xfs_attr_sf_findname(args);
+	if (!sfe) {
+		/*
+		 * If we are recovering an operation, finding nothing to remove
+		 * is not an error, it just means there was nothing to clean up.
+		 */
+		if (args->op_flags & XFS_DA_OP_RECOVERY)
+			return 0;
+		return -ENOATTR;
+	}
 
 	/*
 	 * Fix up the attribute fork data, covering the hole
 	 */
-	end = base + size;
-	totsize = be16_to_cpu(sf->hdr.totsize);
-	if (end != totsize)
-		memmove(&((char *)sf)[base], &((char *)sf)[end], totsize - end);
+	size = xfs_attr_sf_entsize(sfe);
+	next = xfs_attr_sf_nextentry(sfe);
+	end = xfs_attr_sf_endptr(sf);
+	if (next < end)
+		memmove(sfe, next, end - next);
 	sf->hdr.count--;
-	be16_add_cpu(&sf->hdr.totsize, -size);
+	totsize -= size;
+	sf->hdr.totsize = cpu_to_be16(totsize);
 
 	/*
 	 * Fix up the start offset of the attribute fork
 	 */
-	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index ce6743463..56fcd689e 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -51,9 +51,7 @@ int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
 int	xfs_attr_sf_removename(struct xfs_da_args *args);
-int	xfs_attr_sf_findname(struct xfs_da_args *args,
-			     struct xfs_attr_sf_entry **sfep,
-			     unsigned int *basep);
+struct xfs_attr_sf_entry *xfs_attr_sf_findname(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
 xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_attr_shortform *sfp,
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index 37578b369..a774d4d87 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -48,4 +48,11 @@ xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep)
 	return (void *)sfep + xfs_attr_sf_entsize(sfep);
 }
 
+/* pointer to the space after the last entry, e.g. for adding a new one */
+static inline struct xfs_attr_sf_entry *
+xfs_attr_sf_endptr(struct xfs_attr_shortform *sf)
+{
+	return (void *)sf + be16_to_cpu(sf->hdr.totsize);
+}
+
 #endif	/* __XFS_ATTR_SF_H__ */
-- 
2.44.0

