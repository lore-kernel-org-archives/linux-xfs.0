Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871101;
	b=uNqtXha2pOLqX293XFfJUf5L6u4zpClFfNT7qbvBRacHmLwgLRTcFTR+6/sznb7kVJtd
	 Tu5s60ZWDLDn0Pul1UgWKXsHB5hfysfkDWEaxIEd/+mNcNZvzwRO24LGRe7lIH67Jmzwv
	 11WoS08bWJvPaYsHjM10/oB5pybQCxaCLUDrjHqfy40iHO75FfUUZu9ktaYV773Uc8Hwh
	 IKFh1skDZKod6xmzbjWI5wwjYZFLn3ZyH2l4/KnVusG3Jh2CkzJfTBU+iRu02CRSZBvXJ
	 G+S+xpdLphdK+lPQHqrLm0QLNXNFMaeVMUiaqB0wfRPpbMr1B3A2x/x0tBFX4C+bOqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bXiI5puHVTLG9ZCQ4BjhNQPMCTp0+5zfiWWAHEeXV7Q=;
	b=4px6IYK4UwEsJKCN7yZ+/4utjVtI8xYfOmJCJykhh04BASGJFIUmo0+ZKL1sDGkkLEWB
	 1BVMjNYEWyfArM17na+UidldfTC7VdFkkWuzYD9dmKKhXFSjIhBPApJBkpdQJmQz0FMIj
	 BhkMt7OHHVj/KnISN/dz2RfR8TgTTfKTYif4desG+biUTt60VL8Pd4zFEDsYajjZtMMwN
	 oJ71HC7DqsNNEJrj7A+x0R+txuAJY9syTpSTw5xDS6sDgjOWCNHRKJu49gemD7QrL7piw
	 aAb+A05qEwCVQjcohKaJd6D/SG5mIRyG0vT/WHlPpO83Y9d/OD5eOGIlNqCSGlJB4zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SFjfpHu5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716EC606A332
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SFjfpHu5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE491F000C7;
	Mon, 16 Nov 2026 23:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871101;
	bh=bXiI5puHVTLG9ZCQ4BjhNQPMCTp0+5zfiWWAHEeXV7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFjfpHu5kAW4L0E4AZKKk8P4sy96YZPB5pb+Y0FGtlWNPDBtY7IZ1/+ztttMxd5wQ
	 mlE6rfi1p6GjoVwUgZllLmhxsLaxhNgqv1NAYKSK+Tw7fivEDxWHORzIAsbeFcJdUg
	 qmjdqCX69nhxGrAx4N63YIgTB8G9omSxtZqXBB81MVNIL9Z19Teneo+C2Ch+X8Y94S
	 jhubBjPzw/SStVL7FX9+WaLhrDLrQPD1KKdB3fjjjT+PUCjKpxVeT6r1qkWuTUVbmP
	 d+9xLI2OG92wx3dlYKVGjDimcawvy3yl//WNj4lBnQui3UcZGgkXHoSh1iprvhaN2+
	 vJNCZjR42xTJQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 52/59] xfs: validate logged metadata btree fork roots during recovery
Date: Tue, 17 Nov 2026 10:15:09 +1100
Message-ID: <20261116231707.3625263-53-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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

The maximum height of these btrees depends on the filesystem geometry, which
a growfs being recovered can change. The geometry the item will be replayed
against is not known when it is validated, so the root level is bounded by
the largest height any geometry allows. The runtime root loaders check it
against the real geometry once recovery has finished. An empty level zero
root is accepted, because growfs creates these inodes before it adds the
first realtime volume.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_inode_item_recover.c | 170 +++++++++++++++++++++++++++++++-
 1 file changed, 169 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index d9ab9900a201..efb142efa0ef 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -529,6 +529,173 @@ xlog_dinode_verify_bmbt_root(
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
+	/*
+	 * The maximum rtrmap btree height depends on the filesystem geometry,
+	 * which a growfs being recovered can change. The geometry this item
+	 * will be replayed against is not known yet, so bound the root level by
+	 * the largest height any geometry allows. The root is checked against
+	 * the real geometry when the inode is loaded after recovery. Tighter
+	 * validation depends on solving the recovery geometry problem described
+	 * in the log recovery validation design document.
+	 */
+	fa = xfs_btree_check_fsblock_root_hdr(mp, XFS_RTRMAP_CRC_MAGIC,
+			xfs_rtrmapbt_maxrecs(mp, size,
+				be16_to_cpu(block->bb_level) == 0),
+			block, 0, xfs_rtrmapbt_maxlevels_ondisk() - 1);
+	if (fa)
+		return fa;
+
+	/*
+	 * rtrmap inodes can be dynamically created by growfs, resulting in a
+	 * transient state on disk where they can have no contents. Only a level
+	 * zero root may be empty.
+	 */
+	level = be16_to_cpu(block->bb_level);
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (level > 0 && numrecs == 0)
+		return __this_address;
+
+	if (size != xfs_rtrmap_broot_space_calc(level, numrecs))
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
+	/*
+	 * The maximum rtrefcount btree height depends on the filesystem
+	 * geometry, which a growfs being recovered can change. The geometry
+	 * this item will be replayed against is not known yet, so bound the
+	 * root level by the largest height any geometry allows. The root is
+	 * checked against the real geometry when the inode is loaded after
+	 * recovery. Tighter validation depends on solving the recovery geometry
+	 * problem described in the log recovery validation design document.
+	 */
+	fa = xfs_btree_check_fsblock_root_hdr(mp, XFS_RTREFC_CRC_MAGIC,
+			xfs_rtrefcountbt_maxrecs(mp, size,
+				be16_to_cpu(block->bb_level) == 0),
+			block, 0, xfs_rtrefcountbt_maxlevels_ondisk() - 1);
+	if (fa)
+		return fa;
+
+	/*
+	 * rtrefcount inodes can be dynamically created by growfs, resulting in
+	 * a transient state on disk where they can have no contents. Only a
+	 * level zero root may be empty.
+	 */
+	level = be16_to_cpu(block->bb_level);
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (level > 0 && numrecs == 0)
+		return __this_address;
+
+	if (size != xfs_rtrefcount_broot_space_calc(level, numrecs))
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
+	/*
+	 * growfs creates these inodes before it adds a realtime volume, so gate
+	 * them on the btree feature rather than the realtime btree feature, as
+	 * the root loaders do.
+	 */
+	switch (ldip->di_metatype) {
+	case XFS_METAFILE_RTRMAP:
+		if (!xfs_has_rmapbt(mp))
+			return __this_address;
+		return xlog_dinode_verify_rtrmap_root(mp, ldip, src, size);
+	case XFS_METAFILE_RTREFCOUNT:
+		if (!xfs_has_reflink(mp))
+			return __this_address;
+		return xlog_dinode_verify_rtrefcount_root(mp, ldip, src, size);
+	default:
+		return __this_address;
+	}
+}
+
 /*
  * Verify a logged shortform symlink target. The logged target is the on-disk
  * form, which is not null terminated, so this cannot use
@@ -635,7 +802,8 @@ xlog_dinode_verify_dfork(
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

