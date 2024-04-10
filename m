Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB36621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711037; cv=none; b=C6waqiL7ETmqjUxoqTrg4a5Bhs8zLnTIfD07RnV64iWNchx2bRVMHveQR4YOPY8vAlvlWuASKGClciC219xlpycWQQKWf3sn0pE9b5Gc/7xqsGDTFvmj+WOpv6SklKZQRV4ZLffs7YJ8dHfcSZq0eVItcwh+PydLtOAXLK6FNBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711037; c=relaxed/simple;
	bh=C+I2X9BKXmzUO1laTwHDgBFR9BvPVMowMhDSjhFcJwE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aK0KnqFZ78JvdNgaqEDt5XWnpdrUuXKRj3YPSNxlc56S9xie/hxkZTMvJS52i/nc+uAzqvNYLlTui/bkQ/Txx6OUHacJP6hQ0ANwcEkdkUPvXjASSkyRVx2KZq5CwlXNaBO1P3wTtjf6zv71mTbtkMWTFxlj3uUeMgvQ8DhlPAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBjCJmgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBjCJmgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFC8C433C7;
	Wed, 10 Apr 2024 01:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711037;
	bh=C+I2X9BKXmzUO1laTwHDgBFR9BvPVMowMhDSjhFcJwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CBjCJmgAlKPs96+kHHFu6/5K6AxVkhbBW5agVOOCXTiQdznTC8QUOwperyA3sVw4s
	 iztOw7LSydYTL2R9B6UTgbaTzfRoxY5tn8bADZb42ClVOQIAOmP4BuIfF+X6U4n01W
	 jdWk7mj5fmO0QySCn+oWfbvm+4mWz4XM6nvUIdY+UatwDYageyiw2rLT+A2rXJ+vxu
	 lvfM8n26M0P7/5Ru4uwXPFkZpytNVsafd5S97FuIsbARLtNk3By1VYcXD0GpprAl+G
	 v3xw5HkPjTXdff1VGOEnTkoJdDFzYHra5+XJ5klhZMYQ3Fu6i4RkFfWs/iVQSpTmBo
	 YA/qEkm/rpflA==
Date: Tue, 09 Apr 2024 18:03:56 -0700
Subject: [PATCH 01/14] xfs: add xattr setname and removename functions for
 internal users
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270971004.3632937.5852027532367765797.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
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

Add a couple of internal xattr functions to set or remove attr names
from the xattr structures.  The upcoming parent pointer and fsverity
patchsets will want the ability to set and clear xattrs with a fully
initialized xfs_da_args structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c   |  193 ++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_attr.h   |    3 +
 fs/xfs/scrub/attr_repair.c |   17 +++-
 3 files changed, 191 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 99930472e59da..83f8cf551816a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -950,6 +950,44 @@ xfs_attr_lookup(
 	return error;
 }
 
+/*
+ * Before updating xattrs, add an attribute fork if the inode doesn't have.
+ * (inode must not be locked when we call this routine)
+ */
+static int
+xfs_attr_ensure_fork(
+	struct xfs_da_args	*args,
+	bool			rsvd)
+{
+	int			sf_size;
+
+	if (xfs_inode_has_attr_fork(args->dp))
+		return 0;
+
+	sf_size = sizeof(struct xfs_attr_sf_hdr) +
+			xfs_attr_sf_entsize_byname(args->namelen,
+						   args->valuelen);
+
+	return xfs_bmap_add_attrfork(args->dp, sf_size, rsvd);
+}
+
+/*
+ * Before updating xattrs, make sure we can handle adding to the extent count.
+ * There must be a transaction and the ILOCK must be held.
+ */
+static int
+xfs_attr_ensure_iext(
+	struct xfs_da_args	*args,
+	int			nr)
+{
+	int			error;
+
+	error = xfs_iext_count_may_overflow(args->dp, XFS_ATTR_FORK, nr);
+	if (error == -EFBIG)
+		return xfs_iext_count_upgrade(args->trans, args->dp, nr);
+	return error;
+}
+
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -994,19 +1032,9 @@ xfs_attr_set(
 		XFS_STATS_INC(mp, xs_attr_set);
 		args->total = xfs_attr_calc_size(args, &local);
 
-		/*
-		 * If the inode doesn't have an attribute fork, add one.
-		 * (inode must not be locked when we call this routine)
-		 */
-		if (xfs_inode_has_attr_fork(dp) == 0) {
-			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
-				xfs_attr_sf_entsize_byname(args->namelen,
-						args->valuelen);
-
-			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
-			if (error)
-				return error;
-		}
+		error = xfs_attr_ensure_fork(args, rsvd);
+		if (error)
+			return error;
 
 		if (!local)
 			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
@@ -1025,11 +1053,8 @@ xfs_attr_set(
 		return error;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
-		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+		error = xfs_attr_ensure_iext(args,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(args->trans, dp,
-					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -1086,6 +1111,140 @@ xfs_attr_set(
 	goto out_unlock;
 }
 
+/*
+ * Ensure that the xattr structure maps @args->name to @args->value.
+ *
+ * The caller must have initialized @args, attached dquots, and must not hold
+ * any ILOCKs.  Only XATTR_CREATE may be specified in @args->xattr_flags.
+ * Reserved data blocks may be used if @rsvd is set.
+ *
+ * Returns -EEXIST if XATTR_CREATE was specified and the name already exists.
+ */
+int
+xfs_attr_setname(
+	struct xfs_da_args	*args,
+	bool			rsvd)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans_res	tres;
+	unsigned int		total;
+	int			rmt_extents = 0;
+	int			error, local;
+
+	ASSERT(!(args->xattr_flags & XATTR_REPLACE));
+	ASSERT(!args->trans);
+
+	args->total = xfs_attr_calc_size(args, &local);
+
+	error = xfs_attr_ensure_fork(args, rsvd);
+	if (error)
+		return error;
+
+	if (!local)
+		rmt_extents = XFS_IEXT_ATTR_MANIP_CNT(
+				xfs_attr3_rmt_blocks(mp, args->valuelen));
+
+	xfs_init_attr_trans(args, &tres, &total);
+	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
+	if (error)
+		return error;
+
+	error = xfs_attr_ensure_iext(args, rmt_extents);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_attr_lookup(args);
+	switch (error) {
+	case -EEXIST:
+		/* Pure create fails if the attr already exists */
+		if (args->xattr_flags & XATTR_CREATE)
+			goto out_trans_cancel;
+		if (args->attr_filter & XFS_ATTR_PARENT)
+			xfs_attr_defer_parent(args, XFS_ATTR_DEFER_REPLACE);
+		else
+			xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
+		break;
+	case -ENOATTR:
+		if (args->attr_filter & XFS_ATTR_PARENT)
+			xfs_attr_defer_parent(args, XFS_ATTR_DEFER_SET);
+		else
+			xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
+		break;
+	default:
+		goto out_trans_cancel;
+	}
+
+	xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+	error = xfs_trans_commit(args->trans);
+out_unlock:
+	args->trans = NULL;
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	return error;
+
+out_trans_cancel:
+	xfs_trans_cancel(args->trans);
+	goto out_unlock;
+}
+
+/*
+ * Ensure that the xattr structure does not map @args->name to @args->value.
+ *
+ * The caller must have initialized @args, attached dquots, and must not hold
+ * any ILOCKs.  Reserved data blocks may be used if @rsvd is set.
+ *
+ * Returns -ENOATTR if the name did not already exist.
+ */
+int
+xfs_attr_removename(
+	struct xfs_da_args	*args,
+	bool			rsvd)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans_res	tres;
+	unsigned int		total;
+	int			rmt_extents;
+	int			error;
+
+	ASSERT(!args->trans);
+
+	rmt_extents = XFS_IEXT_ATTR_MANIP_CNT(
+				xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX));
+
+	xfs_init_attr_trans(args, &tres, &total);
+	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
+	if (error)
+		return error;
+
+	if (xfs_inode_hasattr(dp)) {
+		error = xfs_attr_ensure_iext(args, rmt_extents);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	error = xfs_attr_lookup(args);
+	if (error != -EEXIST)
+		goto out_trans_cancel;
+
+	if (args->attr_filter & XFS_ATTR_PARENT)
+		xfs_attr_defer_parent(args, XFS_ATTR_DEFER_REMOVE);
+	else
+		xfs_attr_defer_add(args, XFS_ATTR_DEFER_REMOVE);
+	xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+	error = xfs_trans_commit(args->trans);
+out_unlock:
+	args->trans = NULL;
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	return error;
+
+out_trans_cancel:
+	xfs_trans_cancel(args->trans);
+	goto out_unlock;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index cb5ca37000848..d51001c5809fe 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -560,6 +560,9 @@ int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
 
+int xfs_attr_setname(struct xfs_da_args *args, bool rsvd);
+int xfs_attr_removename(struct xfs_da_args *args, bool rsvd);
+
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 091cef077cdde..a3a98051df0fb 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -570,6 +570,9 @@ xrep_xattr_insert_rec(
 		.namelen		= key->namelen,
 		.valuelen		= key->valuelen,
 		.owner			= rx->sc->ip->i_ino,
+		.geo			= rx->sc->mp->m_attr_geo,
+		.whichfork		= XFS_ATTR_FORK,
+		.op_flags		= XFS_DA_OP_OKNOENT,
 	};
 	struct xchk_xattr_buf		*ab = rx->sc->buf;
 	int				error;
@@ -607,19 +610,23 @@ xrep_xattr_insert_rec(
 
 	ab->name[key->namelen] = 0;
 
-	if (key->flags & XFS_ATTR_PARENT)
+	if (key->flags & XFS_ATTR_PARENT) {
 		trace_xrep_xattr_insert_pptr(rx->sc->tempip, key->flags,
 				ab->name, key->namelen, ab->value,
 				key->valuelen);
-	else
+		args.op_flags |= XFS_DA_OP_LOGGED;
+	} else {
 		trace_xrep_xattr_insert_rec(rx->sc->tempip, key->flags,
 				ab->name, key->namelen, key->valuelen);
+	}
 
 	/*
-	 * xfs_attr_set creates and commits its own transaction.  If the attr
-	 * already exists, we'll just drop it during the rebuild.
+	 * xfs_attr_setname creates and commits its own transaction.  If the
+	 * attr already exists, we'll just drop it during the rebuild.  Don't
+	 * use reserved blocks because we can abort the repair with ENOSPC.
 	 */
-	error = xfs_attr_set(&args);
+	xfs_attr_sethash(&args);
+	error = xfs_attr_setname(&args, false);
 	if (error == -EEXIST)
 		error = 0;
 

