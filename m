Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11DD3EAC76
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871382; cv=none; b=i3kk5vG8KGLjWi+6ndPS2QWtDMc6XyQ8FYqukqtTjTZUC1sEMw0yiTRg8LZZS1QcHq+fsbb5bWZXv1V7PrlDRPrGbbVchquFBJ7epkH9058NjpMre7H2H0J3stWO+vpBHkdq6WMpY6FmpZxAUd3libfz+Gtnu3q336wODDPQA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871382; c=relaxed/simple;
	bh=BVBuDSi0sv05Ue4LuxCrCz0eS2xM/Q0xz62jIVNvc4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9loAjE2W5zz57FyE1oZnB1zB363dh7+npY1/A9gc0+XSy3mMqgLSfmSGOxp49+cOz8C9Meqylf/KtkfEaJLISiCrEsgGNgXJwlntvGK7HvKh34URfoXfF794K2hLKmTZbBVYMr456zlNEyx/h2W5Q5PxDvUxStfZ5bsNxoCKd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AHu8R7sq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AHu8R7sq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E751F00893;
	Tue, 13 Oct 2026 06:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871381;
	bh=UD+07iappLTRGcbRaNbbWPTmMK0msZ+1JqkE/3CbMEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHu8R7sqMWu+QEZ7e19PavdKJrTfZUZp2V+EGPAvH3MDxAlW90qlqsmk/blb1En7G
	 COMbk+cPafnHy3TEG8VaFhR4GQpAyAfYjec/CPLCVaBg3YAsDFQw59oo35SwxRHiHN
	 JenAEdSX7+0GiVitHi75uBvM8raKzBjlimU8xZmQ0jvveHxcgA9f3jFHQ44pYP3jIx
	 R223napceIPvCmtxR7kPoBgxVuVZAPp0C9GUX1iyQjzJdCZt9uY3mhFu+nGDBn1uYi
	 QF6fWCmsNG9fGHrnYHtyLM4jxpWGQIU3K5rzkrckQ952qlIR7SBdi3KCoH96qe/CHY
	 blChYQslx4dVA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 42/48] xfs: validate logged metadata btree fork roots during recovery
Date: Tue, 13 Oct 2026 17:01:32 +1100
Message-ID: <20261013060204.3138690-43-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A metadata btree format data fork holds an rt rmap or rt refcount btree root,
logged as the expanded in-core btree root like a bmap btree root. Recovery
copied this root into the inode without inspecting it, so a corrupt root was
replayed as it stood.

Validate the logged metadata btree root once the fork has been verified against
the core. The root is checked as a short btree root block whose record count
fills the fork region exactly, and its node pointers are checked to be in range.
The record and key contents are relative to a realtime group, which is not set up
until after log recovery, so their validation is left to the first runtime access
to the root block.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_inode_item_recover.c | 129 +++++++++++++++++++++++++++++++-
 1 file changed, 128 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index b979e922e5e9..09107322ce18 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -524,6 +524,132 @@ xlog_dinode_verify_bmbt_root(
 	return NULL;
 }
 
+/*
+ * Verify a logged rt rmap btree root, as for the bmap btree root. The node
+ * pointers are filesystem block numbers and are checked here.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_rtrmap_root(
+	struct xfs_mount		*mp,
+	struct xfs_log_dinode		*ldip,
+	void				*src,
+	unsigned int			size)
+{
+	struct xfs_btree_block		*block = src;
+	xfs_failaddr_t			fa;
+	unsigned int			level;
+	unsigned int			numrecs;
+	unsigned int			i;
+
+	if (size < XFS_RTRMAP_BLOCK_LEN)
+		return __this_address;
+
+	fa = xfs_btree_check_fsblock_root_hdr(mp, XFS_RTRMAP_CRC_MAGIC,
+			xfs_rtrmapbt_maxrecs(mp, size,
+				be16_to_cpu(block->bb_level) == 0),
+			block, 0, mp->m_rtrmap_maxlevels);
+	if (fa)
+		return fa;
+
+	level = be16_to_cpu(block->bb_level);
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs == 0 ||
+	    size != xfs_rtrmap_broot_space_calc(level, numrecs))
+		return __this_address;
+
+	/*
+	 * A leaf root holds records whose bounds are relative to a realtime
+	 * group. The realtime groups are not set up until long after log
+	 * recovery runs, so the leaf contents cannot be validated here. That is
+	 * deferred to the first runtime access to the root block.
+	 */
+	if (level == 0)
+		return NULL;
+
+	for (i = 1; i <= numrecs; i++) {
+		xfs_rtrmap_ptr_t	*ptr = xfs_rtrmap_broot_ptr_addr(mp,
+						block, i, size);
+
+		if (!xfs_verify_fsbno(mp, be64_to_cpu(*ptr)))
+			return __this_address;
+	}
+
+	return NULL;
+}
+
+/*
+ * Verify a logged rt refcount btree root, as for the rt rmap btree root.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_rtrefcount_root(
+	struct xfs_mount		*mp,
+	struct xfs_log_dinode		*ldip,
+	void				*src,
+	unsigned int			size)
+{
+	struct xfs_btree_block		*block = src;
+	xfs_failaddr_t			fa;
+	unsigned int			level;
+	unsigned int			numrecs;
+	unsigned int			i;
+
+	if (size < XFS_RTREFCOUNT_BLOCK_LEN)
+		return __this_address;
+
+	fa = xfs_btree_check_fsblock_root_hdr(mp, XFS_RTREFC_CRC_MAGIC,
+			xfs_rtrefcountbt_maxrecs(mp, size,
+				be16_to_cpu(block->bb_level) == 0),
+			block, 0, mp->m_rtrefc_maxlevels - 1);
+	if (fa)
+		return fa;
+
+	level = be16_to_cpu(block->bb_level);
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs == 0 ||
+	    size != xfs_rtrefcount_broot_space_calc(level, numrecs))
+		return __this_address;
+
+	/*
+	 * A leaf root holds records whose bounds are relative to a realtime
+	 * group. The realtime groups are not set up until long after log
+	 * recovery runs, so the leaf contents cannot be validated here. That is
+	 * deferred to the first runtime access to the root block.
+	 */
+	if (level == 0)
+		return NULL;
+
+	for (i = 1; i <= numrecs; i++) {
+		xfs_rtrefcount_ptr_t	*ptr = xfs_rtrefcount_broot_ptr_addr(mp,
+						block, i, size);
+
+		if (!xfs_verify_fsbno(mp, be64_to_cpu(*ptr)))
+			return __this_address;
+	}
+
+	return NULL;
+}
+
+/*
+ * Verify a logged metadata btree root. The metadata btree type is fixed by the
+ * inode, so it is chosen from the log dinode metadata type.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_metabtree_root(
+	struct xfs_mount		*mp,
+	struct xfs_log_dinode		*ldip,
+	void				*src,
+	unsigned int			size)
+{
+	switch (ldip->di_metatype) {
+	case XFS_METAFILE_RTRMAP:
+		return xlog_dinode_verify_rtrmap_root(mp, ldip, src, size);
+	case XFS_METAFILE_RTREFCOUNT:
+		return xlog_dinode_verify_rtrefcount_root(mp, ldip, src, size);
+	default:
+		return __this_address;
+	}
+}
+
 /*
  * Verify a logged shortform symlink target. The logged target is the on-disk
  * form, which is not null terminated, so this cannot use
@@ -629,7 +755,8 @@ xlog_dinode_verify_dfork(
 	case XFS_DINODE_FMT_META_BTREE:
 		if (field != XFS_ILOG_DBROOT)
 			return __this_address;
-		break;
+		return xlog_dinode_verify_metabtree_root(mp, ldip,
+				item->ri_buf[2].iov_base, ilfp->ilf_dsize);
 	}
 
 	return NULL;
-- 
2.55.0

