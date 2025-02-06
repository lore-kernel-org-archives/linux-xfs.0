Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1646723C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881778; cv=none; b=dyb+a5PAEpTcTXJLNVCjZbekKLN00TchxRmqKePmh3vJ35dBKH7Rs0/EAbgbTdvhygRd6y3oNk+DhnBxFq+koGN4iEL0ZdmlLkfLa9w/D5X0vYflDsd8Bcz06989lNc25RhyW6aXXubKJ7kYydiU7vqd65FXCY00/txSjFf+yZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881778; c=relaxed/simple;
	bh=jXUfiPJIUWY9vL6hxHHoEAuKUAUB96dBX3NdqzsOc5I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ruser3ve0d/1x7bjQyyX6Tk0NysB6HY3TEAPtYPnCm58BEw45QD58aKAvVWqBOPe8oLiFky+kobqUY1q6OiNAnGl0FXZKCBPhgtB0Mpc+8X1VZ7GEWcdJ9fKNUY43rnwj1iEUdCiAdZXvITXILgQnyBme5fxaYDR0xp5ah9uRFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwj/9AZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwj/9AZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C77C4CEDD;
	Thu,  6 Feb 2025 22:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881777;
	bh=jXUfiPJIUWY9vL6hxHHoEAuKUAUB96dBX3NdqzsOc5I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fwj/9AZH64N2zwnX0Lg3e6MRZCiF5aMbpr08yX5MYyrY/6Q/zBrgp/JA3BXGcQZ2u
	 +GB8Q50bAZ2MlT2fYiZzR722BS8z6U37UArbkjaYpsokU7SIB6UvfwjrMd8b3Dig76
	 xrcYFQ3Oee0Rs8iy60tn5Cah3AFDt+NJQM1REcg6cGBns6rak+7O0BaNR4Fzfu1bG1
	 9ZhqkdwxaPOijj009sZcvoChdQHUixSUCvt2plzLNQJaR9NIMgieTqoqQH09Jr5Ims
	 o8RZ686t0eH309toBxVYrLRwqiTkyobixabnM9pYyhROQnGtkq6OS3lfWVyPzPuxno
	 JxhDE7I3EVEpg==
Date: Thu, 06 Feb 2025 14:42:57 -0800
Subject: [PATCH 30/56] xfs: create a shadow rmap btree during realtime rmap
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087251.2739176.3633690263453715499.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 4a61f12eb11958f157e054d386466627445644cd

Create an in-memory btree of rmap records instead of an array.  This
enables us to do live record collection instead of freezing the fs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree_mem.c    |    1 
 libxfs/xfs_rmap.c         |    3 +
 libxfs/xfs_rtrmap_btree.c |  118 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    6 ++
 libxfs/xfs_shared.h       |    7 +++
 5 files changed, 134 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_btree_mem.c b/libxfs/xfs_btree_mem.c
index 8e3efdbccc156a..2b98b8d01dce0d 100644
--- a/libxfs/xfs_btree_mem.c
+++ b/libxfs/xfs_btree_mem.c
@@ -17,6 +17,7 @@
 #include "xfs_btree_mem.h"
 #include "xfs_ag.h"
 #include "xfs_trace.h"
+#include "xfs_rtgroup.h"
 
 /* Set the root of an in-memory btree. */
 void
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 551f158e5424f3..3748bfc7a9dfc1 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -326,7 +326,8 @@ xfs_rmap_check_btrec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
-	if (xfs_btree_is_rtrmap(cur->bc_ops))
+	if (xfs_btree_is_rtrmap(cur->bc_ops) ||
+	    xfs_btree_is_mem_rtrmap(cur->bc_ops))
 		return xfs_rtrmap_check_irec(to_rtg(cur->bc_group), irec);
 	return xfs_rmap_check_irec(to_perag(cur->bc_group), irec);
 }
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index ac51e736e7e489..10055110b8cf42 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -26,6 +26,9 @@
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
+#include "xfile.h"
+#include "buf_mem.h"
+#include "xfs_btree_mem.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -540,6 +543,121 @@ xfs_rtrmapbt_init_cursor(
 	return cur;
 }
 
+#ifdef CONFIG_XFS_BTREE_IN_MEM
+/*
+ * Validate an in-memory realtime rmap btree block.  Callers are allowed to
+ * generate an in-memory btree even if the ondisk feature is not enabled.
+ */
+static xfs_failaddr_t
+xfs_rtrmapbt_mem_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	unsigned int		level;
+	unsigned int		maxrecs;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	fa = xfs_btree_fsblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+
+	level = be16_to_cpu(block->bb_level);
+	if (xfs_has_rmapbt(mp)) {
+		if (level >= mp->m_rtrmap_maxlevels)
+			return __this_address;
+	} else {
+		if (level >= xfs_rtrmapbt_maxlevels_ondisk())
+			return __this_address;
+	}
+
+	maxrecs = xfs_rtrmapbt_maxrecs(mp, XFBNO_BLOCKSIZE, level == 0);
+	return xfs_btree_memblock_verify(bp, maxrecs);
+}
+
+static void
+xfs_rtrmapbt_mem_rw_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa = xfs_rtrmapbt_mem_verify(bp);
+
+	if (fa)
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+}
+
+/* skip crc checks on in-memory btrees to save time */
+static const struct xfs_buf_ops xfs_rtrmapbt_mem_buf_ops = {
+	.name			= "xfs_rtrmapbt_mem",
+	.magic			= { 0, cpu_to_be32(XFS_RTRMAP_CRC_MAGIC) },
+	.verify_read		= xfs_rtrmapbt_mem_rw_verify,
+	.verify_write		= xfs_rtrmapbt_mem_rw_verify,
+	.verify_struct		= xfs_rtrmapbt_mem_verify,
+};
+
+const struct xfs_btree_ops xfs_rtrmapbt_mem_ops = {
+	.type			= XFS_BTREE_TYPE_MEM,
+	.geom_flags		= XFS_BTGEO_OVERLAPPING,
+
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	/* Overlapping btree; 2 keys per pointer. */
+	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.ptr_len		= XFS_BTREE_LONG_PTR_LEN,
+
+	.lru_refs		= XFS_RMAP_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_rtrmap_mem_2),
+
+	.dup_cursor		= xfbtree_dup_cursor,
+	.set_root		= xfbtree_set_root,
+	.alloc_block		= xfbtree_alloc_block,
+	.free_block		= xfbtree_free_block,
+	.get_minrecs		= xfbtree_get_minrecs,
+	.get_maxrecs		= xfbtree_get_maxrecs,
+	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
+	.key_diff		= xfs_rtrmapbt_key_diff,
+	.buf_ops		= &xfs_rtrmapbt_mem_buf_ops,
+	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
+	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
+	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
+};
+
+/* Create a cursor for an in-memory btree. */
+struct xfs_btree_cur *
+xfs_rtrmapbt_mem_cursor(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_trans	*tp,
+	struct xfbtree		*xfbt)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrmapbt_mem_ops,
+			mp->m_rtrmap_maxlevels, xfs_rtrmapbt_cur_cache);
+	cur->bc_mem.xfbtree = xfbt;
+	cur->bc_nlevels = xfbt->nlevels;
+	cur->bc_group = xfs_group_hold(rtg_group(rtg));
+	return cur;
+}
+
+/* Create an in-memory realtime rmap btree. */
+int
+xfs_rtrmapbt_mem_init(
+	struct xfs_mount	*mp,
+	struct xfbtree		*xfbt,
+	struct xfs_buftarg	*btp,
+	xfs_rgnumber_t		rgno)
+{
+	xfbt->owner = rgno;
+	return xfbtree_init(mp, xfbt, btp, &xfs_rtrmapbt_mem_ops);
+}
+#endif /* CONFIG_XFS_BTREE_IN_MEM */
+
 /*
  * Install a new rt reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index ad76ac7938b602..9d0915089891a5 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -11,6 +11,7 @@ struct xfs_btree_cur;
 struct xfs_mount;
 struct xbtree_ifakeroot;
 struct xfs_rtgroup;
+struct xfbtree;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RTRMAP_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
@@ -201,4 +202,9 @@ int xfs_rtrmapbt_init_rtsb(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
 unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
+		struct xfs_trans *tp, struct xfbtree *xfbtree);
+int xfs_rtrmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
+		struct xfs_buftarg *btp, xfs_rgnumber_t rgno);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index da23dac22c3f08..960716c387cc2b 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -57,6 +57,7 @@ extern const struct xfs_btree_ops xfs_refcountbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_mem_ops;
 extern const struct xfs_btree_ops xfs_rtrmapbt_ops;
+extern const struct xfs_btree_ops xfs_rtrmapbt_mem_ops;
 
 static inline bool xfs_btree_is_bno(const struct xfs_btree_ops *ops)
 {
@@ -98,8 +99,14 @@ static inline bool xfs_btree_is_mem_rmap(const struct xfs_btree_ops *ops)
 {
 	return ops == &xfs_rmapbt_mem_ops;
 }
+
+static inline bool xfs_btree_is_mem_rtrmap(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_rtrmapbt_mem_ops;
+}
 #else
 # define xfs_btree_is_mem_rmap(...)	(false)
+# define xfs_btree_is_mem_rtrmap(...)	(false)
 #endif
 
 static inline bool xfs_btree_is_rtrmap(const struct xfs_btree_ops *ops)

