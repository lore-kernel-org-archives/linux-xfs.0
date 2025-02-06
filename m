Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E614C8E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824343; cv=none; b=Do5V0/XvjpkFRDSVwg6lGxaKtW7TRLZLOYXo6ShlDeokTjTpcYj/DGb2XzgPamn7B+QHCHKuxXH3zT9uUSdeMsAoYeYU168ZVvGTRmGGEB+oTNiqE8zLumyW8D1vNjK+FPOPjrFeQNp3uBIuYsYOb3jcoRCAQ3evlPThI/VPGh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824343; c=relaxed/simple;
	bh=cxAMHilNOEDV24qJgGQUZSAbDVjvW8adMCS8CxOkHBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKhXY9kW+InJXFF7fI/gBOJF2Cb9lld4MNFPTHPKUFk/xRIE3kia1hG5M9xD4mwPl3dK+AkiDghsIn2OGFWCiMv936EZALCrK8PYd3+TQdEpT3waeGyBgCwtcsR/CCkqUu9wZ4Pk/eUrZIxbVjuBafEhK96sbwTvSPP2ark/EmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oLgkorMF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oLgkorMF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kWQ2MZdN6L01SUHRBHmyS+MOetxQ7R8USJX+ixO8cCM=; b=oLgkorMFI/JLm9YzBbpBqD4Hpy
	gBBO7/kk/TKkkW20IYEnP/OYfj+1tiB6wCJg1eZ8DkrI0gW1TuZUrDbiEcWIdIm2W6UiKetxg2ZVd
	exsYAmewKbsBKCO7uq6bNdXJzHOVxd+dCS5WVf6sIfkesY4Nu0MymNIholI20R8NYTrO401bT3IW2
	bbfpwbua7Ms0/8SQPp/jsVS9mP0Uug3qqagtlmDvCV1Q7fngSwZKGqV3MV/E4/6xB3AuphoQkhU/9
	8Nwo3S5YBbAw5ifebI/pohoBXNUNEoXFuwTTLIjEG4+dH+3e0ap/pKeiHt8H/pJz/sajljk+FvtsW
	L/bTPDcg==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvdr-00000005QCd-3sPs;
	Thu, 06 Feb 2025 06:45:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/43] xfs: make metabtree reservations global
Date: Thu,  6 Feb 2025 07:44:26 +0100
Message-ID: <20250206064511.2323878-11-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently each metabtree inode has it's own space reservation to ensure
it can be expanded to the maximum size.  This is not very efficient as it
requires a large number of blocks to be set aside that can't be used at
all by other btrees.

Switch to a model that uses a global pool instead in preparation for
reducing the amount of reserved space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_metafile.c     | 164 ++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_metafile.h     |   6 +-
 fs/xfs/scrub/reap.c              |  12 ++-
 fs/xfs/scrub/repair.c            |  54 ----------
 fs/xfs/scrub/repair.h            |   1 -
 fs/xfs/scrub/rtrefcount_repair.c |  34 ++-----
 fs/xfs/scrub/rtrmap_repair.c     |  29 +-----
 fs/xfs/xfs_fsops.c               |  19 ++--
 fs/xfs/xfs_inode.h               |  16 +--
 fs/xfs/xfs_mount.h               |   9 ++
 fs/xfs/xfs_reflink.c             |  12 +--
 fs/xfs/xfs_rtalloc.c             |  43 +-------
 fs/xfs/xfs_rtalloc.h             |   5 -
 fs/xfs/xfs_super.c               |   1 +
 fs/xfs/xfs_trace.h               |  23 ++---
 15 files changed, 160 insertions(+), 268 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index 7625e694eb8d..88f011750add 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -21,6 +21,9 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_alloc.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 static const struct {
 	enum xfs_metafile_type	mtype;
@@ -74,12 +77,11 @@ xfs_metafile_clear_iflag(
 }
 
 /*
- * Is the amount of space that could be allocated towards a given metadata
- * file at or beneath a certain threshold?
+ * Is the metafile reservations at or beneath a certain threshold?
  */
 static inline bool
 xfs_metafile_resv_can_cover(
-	struct xfs_inode	*ip,
+	struct xfs_mount	*mp,
 	int64_t			rhs)
 {
 	/*
@@ -88,43 +90,38 @@ xfs_metafile_resv_can_cover(
 	 * global free block count.  Take care of the first case to avoid
 	 * touching the per-cpu counter.
 	 */
-	if (ip->i_delayed_blks >= rhs)
+	if (mp->m_metafile_resv_avail >= rhs)
 		return true;
 
 	/*
 	 * There aren't enough blocks left in the inode's reservation, but it
 	 * isn't critical unless there also isn't enough free space.
 	 */
-	return xfs_compare_freecounter(ip->i_mount, XC_FREE_BLOCKS,
-			rhs - ip->i_delayed_blks, 2048) >= 0;
+	return xfs_compare_freecounter(mp, XC_FREE_BLOCKS,
+			rhs - mp->m_metafile_resv_avail, 2048) >= 0;
 }
 
 /*
- * Is this metadata file critically low on blocks?  For now we'll define that
- * as the number of blocks we can get our hands on being less than 10% of what
- * we reserved or less than some arbitrary number (maximum btree height).
+ * Is the metafile reservation critically low on blocks?  For now we'll define
+ * that as the number of blocks we can get our hands on being less than 10% of
+ * what we reserved or less than some arbitrary number (maximum btree height).
  */
 bool
 xfs_metafile_resv_critical(
-	struct xfs_inode	*ip)
+	struct xfs_mount	*mp)
 {
-	uint64_t		asked_low_water;
+	ASSERT(xfs_has_metadir(mp));
 
-	if (!ip)
-		return false;
-
-	ASSERT(xfs_is_metadir_inode(ip));
-	trace_xfs_metafile_resv_critical(ip, 0);
+	trace_xfs_metafile_resv_critical(mp, 0);
 
-	if (!xfs_metafile_resv_can_cover(ip, ip->i_mount->m_rtbtree_maxlevels))
+	if (!xfs_metafile_resv_can_cover(mp, mp->m_rtbtree_maxlevels))
 		return true;
 
-	asked_low_water = div_u64(ip->i_meta_resv_asked, 10);
-	if (!xfs_metafile_resv_can_cover(ip, asked_low_water))
+	if (!xfs_metafile_resv_can_cover(mp,
+			div_u64(mp->m_metafile_resv_target, 10)))
 		return true;
 
-	return XFS_TEST_ERROR(false, ip->i_mount,
-			XFS_ERRTAG_METAFILE_RESV_CRITICAL);
+	return XFS_TEST_ERROR(false, mp, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
 }
 
 /* Allocate a block from the metadata file's reservation. */
@@ -133,22 +130,24 @@ xfs_metafile_resv_alloc_space(
 	struct xfs_inode	*ip,
 	struct xfs_alloc_arg	*args)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	int64_t			len = args->len;
 
 	ASSERT(xfs_is_metadir_inode(ip));
 	ASSERT(args->resv == XFS_AG_RESV_METAFILE);
 
-	trace_xfs_metafile_resv_alloc_space(ip, args->len);
+	trace_xfs_metafile_resv_alloc_space(mp, args->len);
 
 	/*
 	 * Allocate the blocks from the metadata inode's block reservation
 	 * and update the ondisk sb counter.
 	 */
-	if (ip->i_delayed_blks > 0) {
+	mutex_lock(&mp->m_metafile_resv_lock);
+	if (mp->m_metafile_resv_avail > 0) {
 		int64_t		from_resv;
 
-		from_resv = min_t(int64_t, len, ip->i_delayed_blks);
-		ip->i_delayed_blks -= from_resv;
+		from_resv = min_t(int64_t, len, mp->m_metafile_resv_avail);
+		mp->m_metafile_resv_avail -= from_resv;
 		xfs_mod_delalloc(ip, 0, -from_resv);
 		xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_RES_FDBLOCKS,
 				-from_resv);
@@ -175,6 +174,9 @@ xfs_metafile_resv_alloc_space(
 		xfs_trans_mod_sb(args->tp, field, -len);
 	}
 
+	mp->m_metafile_resv_used += args->len;
+	mutex_unlock(&mp->m_metafile_resv_lock);
+
 	ip->i_nblocks += args->len;
 	xfs_trans_log_inode(args->tp, ip, XFS_ILOG_CORE);
 }
@@ -186,26 +188,33 @@ xfs_metafile_resv_free_space(
 	struct xfs_trans	*tp,
 	xfs_filblks_t		len)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	int64_t			to_resv;
 
 	ASSERT(xfs_is_metadir_inode(ip));
-	trace_xfs_metafile_resv_free_space(ip, len);
+
+	trace_xfs_metafile_resv_free_space(mp, len);
 
 	ip->i_nblocks -= len;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
+	mutex_lock(&mp->m_metafile_resv_lock);
+	mp->m_metafile_resv_used -= len;
+
 	/*
 	 * Add the freed blocks back into the inode's delalloc reservation
 	 * until it reaches the maximum size.  Update the ondisk fdblocks only.
 	 */
-	to_resv = ip->i_meta_resv_asked - (ip->i_nblocks + ip->i_delayed_blks);
+	to_resv = mp->m_metafile_resv_target -
+		(mp->m_metafile_resv_used + mp->m_metafile_resv_avail);
 	if (to_resv > 0) {
 		to_resv = min_t(int64_t, to_resv, len);
-		ip->i_delayed_blks += to_resv;
+		mp->m_metafile_resv_avail += to_resv;
 		xfs_mod_delalloc(ip, 0, to_resv);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, to_resv);
 		len -= to_resv;
 	}
+	mutex_unlock(&mp->m_metafile_resv_lock);
 
 	/*
 	 * Everything else goes back to the filesystem, so update the in-core
@@ -215,61 +224,96 @@ xfs_metafile_resv_free_space(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, len);
 }
 
-/* Release a metadata file's space reservation. */
+static void
+__xfs_metafile_resv_free(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_metafile_resv_avail) {
+		xfs_mod_sb_delalloc(mp, -(int64_t)mp->m_metafile_resv_avail);
+		xfs_add_fdblocks(mp, mp->m_metafile_resv_avail);
+	}
+	mp->m_metafile_resv_avail = 0;
+	mp->m_metafile_resv_used = 0;
+	mp->m_metafile_resv_target = 0;
+}
+
+/* Release unused metafile space reservation. */
 void
 xfs_metafile_resv_free(
-	struct xfs_inode	*ip)
+	struct xfs_mount	*mp)
 {
-	/* Non-btree metadata inodes don't need space reservations. */
-	if (!ip || !ip->i_meta_resv_asked)
+	if (!xfs_has_metadir(mp))
 		return;
 
-	ASSERT(xfs_is_metadir_inode(ip));
-	trace_xfs_metafile_resv_free(ip, 0);
+	trace_xfs_metafile_resv_free(mp, 0);
 
-	if (ip->i_delayed_blks) {
-		xfs_mod_delalloc(ip, 0, -ip->i_delayed_blks);
-		xfs_add_fdblocks(ip->i_mount, ip->i_delayed_blks);
-		ip->i_delayed_blks = 0;
-	}
-	ip->i_meta_resv_asked = 0;
+	mutex_lock(&mp->m_metafile_resv_lock);
+	__xfs_metafile_resv_free(mp);
+	mutex_unlock(&mp->m_metafile_resv_lock);
 }
 
-/* Set up a metadata file's space reservation. */
+/* Set up a metafile space reservation. */
 int
 xfs_metafile_resv_init(
-	struct xfs_inode	*ip,
-	xfs_filblks_t		ask)
+	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg = NULL;
+	xfs_filblks_t		used = 0, target = 0;
 	xfs_filblks_t		hidden_space;
-	xfs_filblks_t		used;
-	int			error;
+	int			error = 0;
 
-	if (!ip || ip->i_meta_resv_asked > 0)
+	if (!xfs_has_metadir(mp))
 		return 0;
 
-	ASSERT(xfs_is_metadir_inode(ip));
+	/*
+	 * Free any previous reservation to have a clean slate.
+	 */
+	mutex_lock(&mp->m_metafile_resv_lock);
+	__xfs_metafile_resv_free(mp);
+
+	/*
+	 * Currently the only btree metafiles that require reservations are the
+	 * rtrmap and the rtrefcount.  Anything new will have to be added here
+	 * as well.
+	 */
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		if (xfs_has_rtrmapbt(mp)) {
+			used += rtg_rmap(rtg)->i_nblocks;
+			target += xfs_rtrmapbt_calc_reserves(mp);
+		}
+		if (xfs_has_rtreflink(mp)) {
+			used += rtg_refcount(rtg)->i_nblocks;
+			target += xfs_rtrefcountbt_calc_reserves(mp);
+		}
+	}
+
+	if (!target)
+		goto out_unlock;
 
 	/*
-	 * Space taken by all other metadata btrees are accounted on-disk as
+	 * Space taken by the per-AG metadata btrees are accounted on-disk as
 	 * used space.  We therefore only hide the space that is reserved but
 	 * not used by the trees.
 	 */
-	used = ip->i_nblocks;
-	if (used > ask)
-		ask = used;
-	hidden_space = ask - used;
+	if (used > target)
+		target = used;
+	hidden_space = target - used;
 
-	error = xfs_dec_fdblocks(ip->i_mount, hidden_space, true);
+	error = xfs_dec_fdblocks(mp, hidden_space, true);
 	if (error) {
-		trace_xfs_metafile_resv_init_error(ip, error, _RET_IP_);
-		return error;
+		trace_xfs_metafile_resv_init_error(mp, 0);
+		goto out_unlock;
 	}
 
-	xfs_mod_delalloc(ip, 0, hidden_space);
-	ip->i_delayed_blks = hidden_space;
-	ip->i_meta_resv_asked = ask;
+	xfs_mod_sb_delalloc(mp, hidden_space);
+
+	mp->m_metafile_resv_target = target;
+	mp->m_metafile_resv_used = used;
+	mp->m_metafile_resv_avail = hidden_space;
+
+	trace_xfs_metafile_resv_init(mp, target);
 
-	trace_xfs_metafile_resv_init(ip, ask);
-	return 0;
+out_unlock:
+	mutex_unlock(&mp->m_metafile_resv_lock);
+	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_metafile.h b/fs/xfs/libxfs/xfs_metafile.h
index 95af4b52e5a7..ae6f9e779b98 100644
--- a/fs/xfs/libxfs/xfs_metafile.h
+++ b/fs/xfs/libxfs/xfs_metafile.h
@@ -26,13 +26,13 @@ void xfs_metafile_clear_iflag(struct xfs_trans *tp, struct xfs_inode *ip);
 /* Space reservations for metadata inodes. */
 struct xfs_alloc_arg;
 
-bool xfs_metafile_resv_critical(struct xfs_inode *ip);
+bool xfs_metafile_resv_critical(struct xfs_mount *mp);
 void xfs_metafile_resv_alloc_space(struct xfs_inode *ip,
 		struct xfs_alloc_arg *args);
 void xfs_metafile_resv_free_space(struct xfs_inode *ip, struct xfs_trans *tp,
 		xfs_filblks_t len);
-void xfs_metafile_resv_free(struct xfs_inode *ip);
-int xfs_metafile_resv_init(struct xfs_inode *ip, xfs_filblks_t ask);
+void xfs_metafile_resv_free(struct xfs_mount *mp);
+int xfs_metafile_resv_init(struct xfs_mount *mp);
 
 /* Code specific to kernel/userspace; must be provided externally. */
 
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index b32fb233cf84..cb66918832a9 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -932,13 +932,17 @@ xrep_reap_metadir_fsblocks(
 	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
 
 	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
-	if (error)
+	if (error || !xreap_dirty(&rs))
 		return error;
 
-	if (xreap_dirty(&rs))
-		return xrep_defer_finish(sc);
+	error = xrep_defer_finish(sc);
+	if (error)
+		return error;
 
-	return 0;
+	/*
+	 * Resize the reservations so that we don't fail to expand the btree.
+	 */
+	return xfs_metafile_resv_init(sc->mp);
 }
 
 /*
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3b5288d3ef4e..5cdaf82aee7b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1380,57 +1380,3 @@ xrep_inode_set_nblocks(
 		xfs_trans_mod_dquot_byino(sc->tp, sc->ip, XFS_TRANS_DQ_BCOUNT,
 				delta);
 }
-
-/* Reset the block reservation for a metadata inode. */
-int
-xrep_reset_metafile_resv(
-	struct xfs_scrub	*sc)
-{
-	struct xfs_inode	*ip = sc->ip;
-	int64_t			delta;
-	int			error;
-
-	delta = ip->i_nblocks + ip->i_delayed_blks - ip->i_meta_resv_asked;
-	if (delta == 0)
-		return 0;
-
-	/*
-	 * Too many blocks have been reserved, transfer some from the incore
-	 * reservation back to the filesystem.
-	 */
-	if (delta > 0) {
-		int64_t		give_back;
-
-		give_back = min_t(uint64_t, delta, ip->i_delayed_blks);
-		if (give_back > 0) {
-			xfs_mod_delalloc(ip, 0, -give_back);
-			xfs_add_fdblocks(ip->i_mount, give_back);
-			ip->i_delayed_blks -= give_back;
-		}
-
-		return 0;
-	}
-
-	/*
-	 * Not enough reservation; try to take some blocks from the filesystem
-	 * to the metadata inode.  @delta is negative here, so invert the sign.
-	 */
-	delta = -delta;
-	error = xfs_dec_fdblocks(sc->mp, delta, true);
-	while (error == -ENOSPC) {
-		delta--;
-		if (delta == 0) {
-			xfs_warn(sc->mp,
-"Insufficient free space to reset space reservation for inode 0x%llx after repair.",
-					ip->i_ino);
-			return 0;
-		}
-		error = xfs_dec_fdblocks(sc->mp, delta, true);
-	}
-	if (error)
-		return error;
-
-	xfs_mod_delalloc(ip, 0, delta);
-	ip->i_delayed_blks += delta;
-	return 0;
-}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 823c00d1a502..342bae348b47 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -186,7 +186,6 @@ void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
 
 bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 void xrep_inode_set_nblocks(struct xfs_scrub *sc, int64_t new_blocks);
-int xrep_reset_metafile_resv(struct xfs_scrub *sc);
 
 #else
 
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index 257cfb24beb4..983362447826 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -697,32 +697,6 @@ xrep_rtrefc_build_new_tree(
 	return error;
 }
 
-/*
- * Now that we've logged the roots of the new btrees, invalidate all of the
- * old blocks and free them.
- */
-STATIC int
-xrep_rtrefc_remove_old_tree(
-	struct xrep_rtrefc	*rr)
-{
-	int			error;
-
-	/*
-	 * Free all the extents that were allocated to the former rtrefcountbt
-	 * and aren't cross-linked with something else.
-	 */
-	error = xrep_reap_metadir_fsblocks(rr->sc,
-			&rr->old_rtrefcountbt_blocks);
-	if (error)
-		return error;
-
-	/*
-	 * Ensure the proper reservation for the rtrefcount inode so that we
-	 * don't fail to expand the btree.
-	 */
-	return xrep_reset_metafile_resv(rr->sc);
-}
-
 /* Rebuild the rt refcount btree. */
 int
 xrep_rtrefcountbt(
@@ -769,8 +743,12 @@ xrep_rtrefcountbt(
 	if (error)
 		goto out_bitmap;
 
-	/* Kill the old tree. */
-	error = xrep_rtrefc_remove_old_tree(rr);
+	/*
+	 * Free all the extents that were allocated to the former rtrefcountbt
+	 * and aren't cross-linked with something else.
+	 */
+	error = xrep_reap_metadir_fsblocks(rr->sc,
+			&rr->old_rtrefcountbt_blocks);
 	if (error)
 		goto out_bitmap;
 
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index f2fdd7a9fc24..fc2592c53af5 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -810,28 +810,6 @@ xrep_rtrmap_build_new_tree(
 
 /* Reaping the old btree. */
 
-/* Reap the old rtrmapbt blocks. */
-STATIC int
-xrep_rtrmap_remove_old_tree(
-	struct xrep_rtrmap	*rr)
-{
-	int			error;
-
-	/*
-	 * Free all the extents that were allocated to the former rtrmapbt and
-	 * aren't cross-linked with something else.
-	 */
-	error = xrep_reap_metadir_fsblocks(rr->sc, &rr->old_rtrmapbt_blocks);
-	if (error)
-		return error;
-
-	/*
-	 * Ensure the proper reservation for the rtrmap inode so that we don't
-	 * fail to expand the new btree.
-	 */
-	return xrep_reset_metafile_resv(rr->sc);
-}
-
 static inline bool
 xrep_rtrmapbt_want_live_update(
 	struct xchk_iscan		*iscan,
@@ -995,8 +973,11 @@ xrep_rtrmapbt(
 	if (error)
 		goto out_records;
 
-	/* Kill the old tree. */
-	error = xrep_rtrmap_remove_old_tree(rr);
+	/*
+	 * Free all the extents that were allocated to the former rtrmapbt and
+	 * aren't cross-linked with something else.
+	 */
+	error = xrep_reap_metadir_fsblocks(rr->sc, &rr->old_rtrmapbt_blocks);
 	if (error)
 		goto out_records;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 73275d7a6ec0..22d50f8acd92 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -24,6 +24,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_metafile.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -561,15 +562,13 @@ xfs_fs_reserve_ag_blocks(
 		return error;
 	}
 
-	if (xfs_has_realtime(mp)) {
-		err2 = xfs_rt_resv_init(mp);
-		if (err2 && err2 != -ENOSPC) {
-			xfs_warn(mp,
-		"Error %d reserving realtime metadata reserve pool.", err2);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		}
+	err2 = xfs_metafile_resv_init(mp);
+	if (err2 && err2 != -ENOSPC) {
+		xfs_warn(mp,
+	"Error %d reserving realtime metadata reserve pool.", err2);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 
-		if (err2 && !error)
+		if (!error)
 			error = err2;
 	}
 
@@ -585,9 +584,7 @@ xfs_fs_unreserve_ag_blocks(
 {
 	struct xfs_perag	*pag = NULL;
 
-	if (xfs_has_realtime(mp))
-		xfs_rt_resv_free(mp);
-
+	xfs_metafile_resv_free(mp);
 	while ((pag = xfs_perag_next(mp, pag)))
 		xfs_ag_resv_free(pag);
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c08093a65352..1648dc5a8068 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -25,19 +25,9 @@ struct xfs_dquot;
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
-	union {
-		struct {
-			struct xfs_dquot *i_udquot;	/* user dquot */
-			struct xfs_dquot *i_gdquot;	/* group dquot */
-			struct xfs_dquot *i_pdquot;	/* project dquot */
-		};
-
-		/*
-		 * Space that has been set aside to accomodate expansions of a
-		 * metadata btree rooted in this file.
-		 */
-		uint64_t	i_meta_resv_asked;
-	};
+	struct xfs_dquot	*i_udquot;	/* user dquot */
+	struct xfs_dquot	*i_gdquot;	/* group dquot */
+	struct xfs_dquot	*i_pdquot;	/* project dquot */
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d4a57e2fdcc5..9bfb5e08715d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -263,6 +263,11 @@ typedef struct xfs_mount {
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
 	atomic_t		m_rtgrotor;	/* last rtgroup rtpicked */
 
+	struct mutex		m_metafile_resv_lock;
+	uint64_t		m_metafile_resv_target;
+	uint64_t		m_metafile_resv_used;
+	uint64_t		m_metafile_resv_avail;
+
 	/* Memory shrinker to throttle and reprioritize inodegc */
 	struct shrinker		*m_inodegc_shrinker;
 	/*
@@ -737,5 +742,9 @@ int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
 bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
 void xfs_mod_delalloc(struct xfs_inode *ip, int64_t data_delta,
 		int64_t ind_delta);
+static inline void xfs_mod_sb_delalloc(struct xfs_mount *mp, int64_t delta)
+{
+	percpu_counter_add(&mp->m_delalloc_blks, delta);
+}
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3e778e077d09..fd65e5d7994a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1207,15 +1207,9 @@ xfs_reflink_ag_has_free_space(
 	if (!xfs_has_rmapbt(mp))
 		return 0;
 	if (XFS_IS_REALTIME_INODE(ip)) {
-		struct xfs_rtgroup	*rtg;
-		xfs_rgnumber_t		rgno;
-
-		rgno = xfs_rtb_to_rgno(mp, fsb);
-		rtg = xfs_rtgroup_get(mp, rgno);
-		if (xfs_metafile_resv_critical(rtg_rmap(rtg)))
-			error = -ENOSPC;
-		xfs_rtgroup_put(rtg);
-		return error;
+		if (xfs_metafile_resv_critical(mp))
+			return -ENOSPC;
+		return 0;
 	}
 
 	agno = XFS_FSB_TO_AGNO(mp, fsb);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8da2498417f5..f5a0dbc46a14 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1398,8 +1398,7 @@ xfs_growfs_rt(
 			error = error2;
 
 		/* Reset the rt metadata btree space reservations. */
-		xfs_rt_resv_free(mp);
-		error2 = xfs_rt_resv_init(mp);
+		error2 = xfs_metafile_resv_init(mp);
 		if (error2 && error2 != -ENOSPC)
 			error = error2;
 	}
@@ -1523,46 +1522,6 @@ xfs_rtalloc_reinit_frextents(
 	return 0;
 }
 
-/* Free space reservations for rt metadata inodes. */
-void
-xfs_rt_resv_free(
-	struct xfs_mount	*mp)
-{
-	struct xfs_rtgroup	*rtg = NULL;
-	unsigned int		i;
-
-	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
-		for (i = 0; i < XFS_RTGI_MAX; i++)
-			xfs_metafile_resv_free(rtg->rtg_inodes[i]);
-	}
-}
-
-/* Reserve space for rt metadata inodes' space expansion. */
-int
-xfs_rt_resv_init(
-	struct xfs_mount	*mp)
-{
-	struct xfs_rtgroup	*rtg = NULL;
-	xfs_filblks_t		ask;
-	int			error = 0;
-
-	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
-		int		err2;
-
-		ask = xfs_rtrmapbt_calc_reserves(mp);
-		err2 = xfs_metafile_resv_init(rtg_rmap(rtg), ask);
-		if (err2 && !error)
-			error = err2;
-
-		ask = xfs_rtrefcountbt_calc_reserves(mp);
-		err2 = xfs_metafile_resv_init(rtg_refcount(rtg), ask);
-		if (err2 && !error)
-			error = err2;
-	}
-
-	return error;
-}
-
 /*
  * Read in the bmbt of an rt metadata inode so that we never have to load them
  * at runtime.  This enables the use of shared ILOCKs for rtbitmap scans.  Use
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 0d95b29092c9..78a690b489ed 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -34,9 +34,6 @@ int					/* error */
 xfs_rtmount_inodes(
 	struct xfs_mount	*mp);	/* file system mount structure */
 
-void xfs_rt_resv_free(struct xfs_mount *mp);
-int xfs_rt_resv_init(struct xfs_mount *mp);
-
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -65,8 +62,6 @@ xfs_rtmount_init(
 }
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
 # define xfs_rtunmount_inodes(m)
-# define xfs_rt_resv_free(mp)				((void)0)
-# define xfs_rt_resv_init(mp)				(0)
 
 static inline int
 xfs_growfs_check_rtgeom(const struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5c9a2a0826ff..4414c8542144 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2089,6 +2089,7 @@ xfs_init_fs_context(
 	for (i = 0; i < XG_TYPE_MAX; i++)
 		xa_init(&mp->m_groups[i].xa);
 	mutex_init(&mp->m_growlock);
+	mutex_init(&mp->m_metafile_resv_lock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 740e0a8c3eca..a02129c202b2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5605,11 +5605,10 @@ DEFINE_METADIR_EVENT(xfs_metadir_lookup);
 /* metadata inode space reservations */
 
 DECLARE_EVENT_CLASS(xfs_metafile_resv_class,
-	TP_PROTO(struct xfs_inode *ip, xfs_filblks_t len),
-	TP_ARGS(ip, len),
+	TP_PROTO(struct xfs_mount *mp, xfs_filblks_t len),
+	TP_ARGS(mp, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
 		__field(unsigned long long, freeblks)
 		__field(unsigned long long, reserved)
 		__field(unsigned long long, asked)
@@ -5617,19 +5616,15 @@ DECLARE_EVENT_CLASS(xfs_metafile_resv_class,
 		__field(unsigned long long, len)
 	),
 	TP_fast_assign(
-		struct xfs_mount *mp = ip->i_mount;
-
 		__entry->dev = mp->m_super->s_dev;
-		__entry->ino = ip->i_ino;
 		__entry->freeblks = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS);
-		__entry->reserved = ip->i_delayed_blks;
-		__entry->asked = ip->i_meta_resv_asked;
-		__entry->used = ip->i_nblocks;
+		__entry->reserved = mp->m_metafile_resv_avail;
+		__entry->asked = mp->m_metafile_resv_target;
+		__entry->used = mp->m_metafile_resv_used;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d ino 0x%llx freeblks %llu resv %llu ask %llu used %llu len %llu",
+	TP_printk("dev %d:%d freeblks %llu resv %llu ask %llu used %llu len %llu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
 		  __entry->freeblks,
 		  __entry->reserved,
 		  __entry->asked,
@@ -5638,14 +5633,14 @@ DECLARE_EVENT_CLASS(xfs_metafile_resv_class,
 )
 #define DEFINE_METAFILE_RESV_EVENT(name) \
 DEFINE_EVENT(xfs_metafile_resv_class, name, \
-	TP_PROTO(struct xfs_inode *ip, xfs_filblks_t len), \
-	TP_ARGS(ip, len))
+	TP_PROTO(struct xfs_mount *mp, xfs_filblks_t len), \
+	TP_ARGS(mp, len))
 DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_init);
 DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_free);
 DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_alloc_space);
 DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_free_space);
 DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_critical);
-DEFINE_INODE_ERROR_EVENT(xfs_metafile_resv_init_error);
+DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_init_error);
 
 #ifdef CONFIG_XFS_RT
 TRACE_EVENT(xfs_growfs_check_rtgeom,
-- 
2.45.2

