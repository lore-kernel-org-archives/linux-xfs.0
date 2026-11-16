Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871048;
	b=X+kc5ngQkVqpK6J7Wn/LWsI2S3jLgTJ1kZU3q33yeFolme87MKHDQ88kpt6fWMzCNjN2
	 r7LDI+EPS7oZtz3eqZAGDf/MiiwhvxnWJJMQrQgjKSRPcbK+ZQdaWUU+XbYTwCYmfqHFg
	 ODTZCFM5Dz3rn2kxp7YDwbJjIi7l+ZcFRK1cFIDxzzs6yIfXumOCso+y04kZ/gmjgP96D
	 mFiNLD3QzmnGsjQfdyWeNRiNhwDqltvvfEtkTcEhP0WGJ2AJSWpaXG6AjTgx2ERxspPQT
	 JEDeA3P19Qh0YqjA++7bBUweucRoiN36Lkll9RERzpfDPDZJY/mgOXjw924CcX9Vm/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/L03XVnJRxTmkShqPkzhDp4QwQhopqTWll6ov8/wd/M=;
	b=N3pNxrb9YUUqqdSZwNbXBr9mRlmPUdfAYcgUbnRSL6KZKw562JPq0qc63Bc6FA3TCOmx
	 KtnRPVckOez6pkklDi1XrKRc8B+HtSdvkFfpCzjk//YTwGp9oL0nOmgbycBaPIzPL6aku
	 RcHMoy/IU/XPti4ds3gfm+74xVpTBynO7OHi1W54dmAu9KcblnAhfS17oCT1rsWHXGcpk
	 9qOOi+ST1k53GCYxl5fOTcPWxwnyDMRBmu4SH2HJ7xajQxP3OoTjBnHKBEj45fF7qhhaO
	 asjaG+t70wVuhLsTCtOErBERmp8l9vhY68ynYzdMTD7M7CVawoUUQb+qfWRWHTdV9Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CDJVIe+t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9DF606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CDJVIe+t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DDA1F000C5;
	Mon, 16 Nov 2026 23:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871048;
	bh=/L03XVnJRxTmkShqPkzhDp4QwQhopqTWll6ov8/wd/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDJVIe+tw5coJflrbu26333Hb1h8L8MtVzz8Mkrqr/O7sqt7VC8i2SwnBm+j6xEbL
	 JjM0KAMvIPIBgdd96TG9kolDRBHX5e/egzao9EZAoLBqlRwivgUnrNylNZp449hesA
	 5o+D9MPeWnPfrKql2YC/g6f8Iqa2L5U/CSY/Q6Uky4X3rbzj5XIX9/xyqKEQzzfU9T
	 4GAnd4tnF9GMgchjo3qN6Y4NwXwFMwzdOfdWk8QKOszD1nHqTGTOTW6O6h7CDll2NB
	 NPJtOusRz0gq+PfwjPXZPryAzh2pjsvfDuPiReGinJDIeV5rOTc1uKLJk6gK3pcvRN
	 WJHNTkxAUY5Wg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 11/59] xfs: fix the bmap btree maximum height calculation
Date: Tue, 17 Nov 2026 10:14:28 +1100
Message-ID: <20261116231707.3625263-12-dgc@kernel.org>
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

m_bm_maxlevels is the maximum height of a bmap btree, including the inode root
level. The calculation models a worst case tree with every block at minimum
fill. It stops adding levels once a level reduces to a single block. That block
is a disk block, but the bmap btree root lives in the inode and holds far fewer
pointers than a disk block. The top disk level usually needs more pointers than
the inode root can hold, so a disk node and the inode root above it are both
still needed. The calculation leaves out that level.

m_bm_maxlevels is therefore one level less than the worst case height for
almost every filesystem geometry. Space and log reservations sized from it can
be one level short for a full height split, and a cursor over a worst case tree
has more levels than it was sized for.

Compute the height by adding disk levels until all the blocks of the top disk
level can be pointed to from the inode root, then adding the inode root level.

With the corrected height, the deepest valid root level is one less than
m_bm_maxlevels. The root loader, the block verifier and the inode repair code
reject only levels greater than m_bm_maxlevels, which was correct for the old
value. Reject levels at or above m_bm_maxlevels instead. This must change
together with the height calculation, or the checks would accept a root one
level too deep.

The minimum log size is derived from transaction reservations sized by
m_bm_maxlevels. Changing it would change the minimum log size, and existing
filesystems with logs at the old minimum would no longer mount. Keep the legacy
calculation, and use it only to compute the minimum log size.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       | 48 ++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_bmap.h       |  2 ++
 fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_log_rlimit.c | 66 ++++++++++++++++++++++------------
 fs/xfs/scrub/inode_repair.c    |  2 +-
 6 files changed, 92 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index dcd5faf3428e..ed081a5e4166 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -49,13 +49,53 @@ struct kmem_cache		*xfs_bmap_intent_cache;
  */
 
 /*
- * Compute and fill in the value of the maximum depth of a bmap btree
- * in this filesystem.  Done once, during mount.
+ * Compute and fill in the value of the maximum height of a bmap btree in this
+ * filesystem, including the inode root level.  Done once, during mount.
+ *
+ * The worst case tree has every block at minimum fill. The root lives in the
+ * inode and holds far fewer pointers than a disk block, so disk levels are
+ * added until all the blocks of the top disk level can be pointed to from the
+ * inode root, then the inode root level is added on top.
  */
 void
 xfs_bmap_compute_maxlevels(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	int		whichfork)	/* data or attr fork */
+	struct xfs_mount	*mp,
+	int			whichfork)
+{
+	uint64_t		maxblocks;
+	xfs_extnum_t		maxleafents;
+	int			level;
+	int			maxrootrecs;
+	int			sz;
+
+	maxleafents = xfs_iext_max_nextents(xfs_has_large_extent_counts(mp),
+				whichfork);
+	if (whichfork == XFS_DATA_FORK)
+		sz = xfs_bmdr_space_calc(MINDBTPTRS);
+	else
+		sz = xfs_bmdr_space_calc(MINABTPTRS);
+	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
+
+	maxblocks = howmany_64(maxleafents, mp->m_bmap_dmnr[0]);
+	for (level = 1; maxblocks > maxrootrecs; level++)
+		maxblocks = howmany_64(maxblocks, mp->m_bmap_dmnr[1]);
+
+	/* Add the inode root level. */
+	mp->m_bm_maxlevels[whichfork] = level + 1;
+	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
+}
+
+/*
+ * Legacy calculation of the maximum height of a bmap btree. This stops once a
+ * level reduces to a single block without accounting for the inode root above
+ * it, so it is one level short for most geometries. The minimum log size is
+ * derived from transaction reservations sized by this value, so it is only used
+ * to compute the minimum log size.
+ */
+void
+xfs_bmap_compute_maxlevels_minlogsize(
+	struct xfs_mount	*mp,
+	int			whichfork)
 {
 	uint64_t	maxblocks;	/* max blocks at this level */
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index fb7481e8190c..ab870415c505 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -199,6 +199,8 @@ int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 				void *priv),
 		void *priv);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
+void	xfs_bmap_compute_maxlevels_minlogsize(struct xfs_mount *mp,
+		int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
 int	xfs_bmap_last_before(struct xfs_trans *tp, struct xfs_inode *ip,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 758a4b1ccf5b..a55655300c04 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -421,7 +421,7 @@ xfs_bmbt_verify(
 	 * precise.
 	 */
 	level = be16_to_cpu(block->bb_level);
-	if (level > max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
+	if (level >= max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
 		return __this_address;
 
 	return xfs_btree_fsblock_verify(bp, mp->m_bmap_dmxr[level != 0]);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 486fe7ab8b61..0cf91ea2bf37 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -203,7 +203,7 @@ xfs_iformat_btree(
 		     xfs_bmdr_space_calc(nrecs) >
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
 		     ifp->if_nextents > ip->i_nblocks) ||
-		     level == 0 || level > XFS_BM_MAXLEVELS(mp, whichfork)) {
+		     level == 0 || level >= XFS_BM_MAXLEVELS(mp, whichfork)) {
 		xfs_warn(mp, "corrupt inode %llu (btree).",
 					(unsigned long long)I_INO(ip));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 685d4797913e..f3be6ef9e433 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -14,6 +14,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_bmap.h"
 #include "xfs_trace.h"
 
 /*
@@ -50,7 +51,8 @@ xfs_want_minlogsize_fixes(
  */
 STATIC int
 xfs_log_calc_max_attrsetm_res(
-	struct xfs_mount	*mp)
+	struct xfs_mount		*mp,
+	const struct xfs_trans_resv	*resv)
 {
 	int			size;
 	int			nblks;
@@ -70,21 +72,20 @@ xfs_log_calc_max_attrsetm_res(
 
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
 
-	return  M_RES(mp)->tr_attrsetm.tr_logres +
-		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
+	return  resv->tr_attrsetm.tr_logres +
+		resv->tr_attrsetrt.tr_logres * nblks;
 }
 
 /*
  * Compute an alternate set of log reservation sizes for use exclusively with
- * minimum log size calculations.
+ * minimum log size calculations. The caller must have set up the legacy btree
+ * heights.
  */
 static void
 xfs_log_calc_trans_resv_for_minlogblocks(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resv)
 {
-	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
-
 	/*
 	 * If the feature set is new enough, drop the oversized minimum log
 	 * size computation introduced by the original reflink code.
@@ -95,17 +96,6 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 		return;
 	}
 
-	/*
-	 * In the early days of rmap+reflink, we always set the rmap maxlevels
-	 * to 9 even if the AG was small enough that it would never grow to
-	 * that height.  Transaction reservation sizes influence the minimum
-	 * log size calculation, which influences the size of the log that mkfs
-	 * creates.  Use the old value here to ensure that newly formatted
-	 * small filesystems will mount on older kernels.
-	 */
-	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
-		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
-
 	xfs_trans_resv_calc(mp, resv);
 
 	/* Copy the dynamic transaction reservation types from the running fs */
@@ -141,15 +131,15 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 			xfs_calc_itruncate_reservation_minlogsize(mp);
 	resv->tr_qm_dqalloc.tr_logres =
 			xfs_calc_qm_dqalloc_reservation_minlogsize(mp);
-
-	/* Put everything back the way it was.  This goes at the end. */
-	mp->m_rmap_maxlevels = rmap_maxlevels;
 }
 
 /*
  * Iterate over the log space reservation table to figure out and return
- * the maximum one in terms of the pre-calculated values which were done
- * at mount time.
+ * the maximum one for the minimum log size calculation.
+ *
+ * The minimum log size must not change for existing filesystems, so the
+ * reservations are calculated with legacy btree heights. This temporarily
+ * changes mount-wide state, so it can only be used at mkfs and mount time.
  */
 void
 xfs_log_get_max_trans_res(
@@ -159,13 +149,43 @@ xfs_log_get_max_trans_res(
 	struct xfs_trans_resv	resv = {};
 	struct xfs_trans_res	*resp;
 	struct xfs_trans_res	*end_resp;
+	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
+	unsigned int		bm_maxlevels[2] = {
+		mp->m_bm_maxlevels[XFS_DATA_FORK],
+		mp->m_bm_maxlevels[XFS_ATTR_FORK],
+	};
 	unsigned int		i;
 	int			log_space = 0;
 	int			attr_space;
 
-	attr_space = xfs_log_calc_max_attrsetm_res(mp);
+	/*
+	 * The minimum log size was always computed with the legacy bmap btree
+	 * height, which is one level short for most geometries. Use it here so
+	 * the minimum log size does not change.
+	 */
+	xfs_bmap_compute_maxlevels_minlogsize(mp, XFS_DATA_FORK);
+	xfs_bmap_compute_maxlevels_minlogsize(mp, XFS_ATTR_FORK);
+
+	/*
+	 * In the early days of rmap+reflink, we always set the rmap maxlevels
+	 * to 9 even if the AG was small enough that it would never grow to
+	 * that height.  Transaction reservation sizes influence the minimum
+	 * log size calculation, which influences the size of the log that mkfs
+	 * creates.  Use the old value here to ensure that newly formatted
+	 * small filesystems will mount on older kernels. Feature sets new
+	 * enough for the minimum log size fixes do not need this.
+	 */
+	if (!xfs_want_minlogsize_fixes(&mp->m_sb) &&
+	    xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
+		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
 
 	xfs_log_calc_trans_resv_for_minlogblocks(mp, &resv);
+	attr_space = xfs_log_calc_max_attrsetm_res(mp, &resv);
+
+	/* Put everything back the way it was. */
+	mp->m_rmap_maxlevels = rmap_maxlevels;
+	mp->m_bm_maxlevels[XFS_DATA_FORK] = bm_maxlevels[XFS_DATA_FORK];
+	mp->m_bm_maxlevels[XFS_ATTR_FORK] = bm_maxlevels[XFS_ATTR_FORK];
 
 	resp = (struct xfs_trans_res *)&resv;
 	end_resp = (struct xfs_trans_res *)(&resv + 1);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 05bb4be29390..dbd42976bdcd 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -927,7 +927,7 @@ xrep_dinode_bad_bmbt_fork(
 
 	if (nrecs == 0 || xfs_bmdr_space_calc(nrecs) > dfork_size)
 		return true;
-	if (level == 0 || level > XFS_BM_MAXLEVELS(sc->mp, whichfork))
+	if (level == 0 || level >= XFS_BM_MAXLEVELS(sc->mp, whichfork))
 		return true;
 
 	dmxr = xfs_bmdr_maxrecs(dfork_size, 0);
-- 
2.55.0

