Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DF725A358
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185377; cv=none; b=OGvKRo8jz9oYBq0xIiqfxwN42rAoLLRfELZ0RLn8kwJFFhSi2Zi8JLcI7oApl3ZvsOLZ47i5ujuzLdxwE/7fSqL/kqdTY/Fh1wyEsYga0EFtRGokNvsMVU5kX9S7ptuST5Zc4oiMQbu5JMlV9eFXuqGs0Q0IJPCRmIMax43hQPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185377; c=relaxed/simple;
	bh=o+dj42K5qfMcB651qIk/zNtk1nND9Jtg3Pu3VWDgHLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBoWva9dEt1IJt6YcCecA4tZUOHtHwDiD3UXP0XsiRwIflhnryeFgiK+U13cVmmSQkIJdQ6/nMNQJwaSIjRPc1hVgcq0ZBpvYNyN6onaUaMRnBGajE7Qigua5mXJubXjYVsT/dg/v9iWcsmHy3TWcqXEhwwTh3dlOEk+eOFIekE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fAZw5X/O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fAZw5X/O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RjUtcHnUFVQ8PbUbwcE5h5M8ItF+c2qmGU74ECxRTk0=; b=fAZw5X/OEna18vuwVBcEaqMwlG
	sklw18E3vSkS6fQMGiMHgcRGTAtSdsr8RssmyexFdEX1HV1OyvEtt5Bo+epKldR5622vvFetUfwt7
	O2CuehOV3J0whbVLmGjgqIaIgM+IljxqLMC30ZZeE2NBrKJcBnc5B7cLW5k1gdwJIp+LEUfSFILMS
	dB+OnUZwTL3hasm3sG0/6+DM94fhU3LcvgWJS5Z8lD7YLdPFoqSan3Bo59NdIoHP7fhwnkzPwENES
	3iyAVrvcPF4s882lFxjgx5Yrtri9o3U9oQR91D2YFEvtzsZTZvPW04qb7nBRGguPT261E+7bo+p2/
	BD+LbuDA==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QI9-00000006UCq-1oVO;
	Wed, 09 Apr 2025 07:56:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/45] xfs: make metabtree reservations global
Date: Wed,  9 Apr 2025 09:55:06 +0200
Message-ID: <20250409075557.3535745-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 1df8d75030b787a9fae270b59b93eef809dd2011

Currently each metabtree inode has it's own space reservation to ensure
it can be expanded to the maximum size, mirroring what is done for the
AG-based btrees.  But unlike the AG-based btrees the metabtree inodes
aren't restricted to allocate from a single AG but can use free space
form the entire file system.  And unlike AG-based btrees where the
required reservation shrinks with the available free space due to this,
the metabtree reservations for the rtrmap and rtfreflink trees are not
bound in any way by the data device free space as they track RT extent
allocations.  This is not very efficient as it requires a large number
of blocks to be set aside that can't be used at all by other btrees.

Switch to a model that uses a global pool instead in preparation for
reducing the amount of reserved space, which now also removes the
overloading of the i_nblocks field for metabtree inodes, which would
create problems if metabtree inodes ever had a big enough xattr fork
to require xattr blocks outside the inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_metafile.c | 164 ++++++++++++++++++++++++++----------------
 libxfs/xfs_metafile.h |   6 +-
 2 files changed, 107 insertions(+), 63 deletions(-)

diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 7673265510fd..1216a0e5169e 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -19,6 +19,9 @@
 #include "xfs_inode.h"
 #include "xfs_errortag.h"
 #include "xfs_alloc.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 static const struct {
 	enum xfs_metafile_type	mtype;
@@ -72,12 +75,11 @@ xfs_metafile_clear_iflag(
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
@@ -86,43 +88,38 @@ xfs_metafile_resv_can_cover(
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
@@ -131,22 +128,24 @@ xfs_metafile_resv_alloc_space(
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
@@ -173,6 +172,9 @@ xfs_metafile_resv_alloc_space(
 		xfs_trans_mod_sb(args->tp, field, -len);
 	}
 
+	mp->m_metafile_resv_used += args->len;
+	mutex_unlock(&mp->m_metafile_resv_lock);
+
 	ip->i_nblocks += args->len;
 	xfs_trans_log_inode(args->tp, ip, XFS_ILOG_CORE);
 }
@@ -184,26 +186,33 @@ xfs_metafile_resv_free_space(
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
@@ -213,61 +222,96 @@ xfs_metafile_resv_free_space(
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
diff --git a/libxfs/xfs_metafile.h b/libxfs/xfs_metafile.h
index 95af4b52e5a7..ae6f9e779b98 100644
--- a/libxfs/xfs_metafile.h
+++ b/libxfs/xfs_metafile.h
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
 
-- 
2.47.2

