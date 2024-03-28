Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27D73A1B5
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 07:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711609391; cv=none; b=X2wb3YQqkDq0wGloTBSyaxP34qSgLsyjAv4OgDANnMqG9SMNqM0wRtfBvCXhHyWPmhm+7vSJw8O+l62negR7YFORVWXrVT5xe6uMP226KVoharp63t/Qg/VHrBUjIzsqpslfiLLS1hmyMvYnG5xy4+OTOaxOkfaIQTz+/FSg9bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711609391; c=relaxed/simple;
	bh=EZ/63uNM41RcxSaG1Vz+qtKwxk8Fbf5dGZUrV3e5Few=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xpg43X75VWj/SkfbchDO/MbuJePqqyYOQgEx6kz1OSRjoCvVweLu/h1pu70NTD08eFxbwjJurvS+3mJVRQmISepnSrbfw2Rwz3R7fUYdwGMGsxWY5bzrcKMoWWWZKPEp8n1lRbRA1ZApDMSwX9pdU3I31x5yGkGQNNlxQDoyhro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=5GZesAZR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="5GZesAZR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NY1rB4A181l973gxs5Rpgvnt5SnkYJLrnyaw3ppCCIM=; b=5GZesAZRDnINXezT0ru6Nazi/+
	OOL/ocqtGpVdIfaqCGTtzfiYzSFUdOKdMTKVGiAjXJr0WTc7VcG7gwUvC5KYR4z6a5+Z0BDmkRPcm
	79DQalMdrI6qoztSScMHMKPLlo0/JHWfy0OTa0B1c78E7HHrk4e5OPaP81Z+HpGGWjSw1scA8G2zs
	fybhm/9Cmg6/19CDfloTyZ0WvCcWZT51eGXo58ey2pji9s5R+1HFWxDSt+dZL8bkuQVjIqn9s5w5L
	FThk7LtNVB7gDZSH4XuZ3HMTekc38LdCNju5PJnleelHe8mUk9vaZjW8865M+Q+AkbDaKrRmdX7Gz
	YFlNLMWg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpjn3-0000000Cng7-0D7N;
	Thu, 28 Mar 2024 07:03:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: simplify iext overflow checking and upgrade
Date: Thu, 28 Mar 2024 08:02:54 +0100
Message-Id: <20240328070256.2918605-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240328070256.2918605-1-hch@lst.de>
References: <20240328070256.2918605-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the calls to xfs_iext_count_may_overflow and
xfs_iext_count_upgrade are always paired.  Merge them into a single
function to simplify the callers and the actual check and upgrade
logic itself.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c       |  5 +--
 fs/xfs/libxfs/xfs_bmap.c       |  5 +--
 fs/xfs/libxfs/xfs_inode_fork.c | 62 ++++++++++++++++------------------
 fs/xfs/libxfs/xfs_inode_fork.h |  4 +--
 fs/xfs/xfs_bmap_item.c         |  4 +--
 fs/xfs/xfs_bmap_util.c         | 24 +++----------
 fs/xfs/xfs_dquot.c             |  5 +--
 fs/xfs/xfs_iomap.c             |  9 ++---
 fs/xfs/xfs_reflink.c           |  9 ++---
 fs/xfs/xfs_rtalloc.c           |  5 +--
 10 files changed, 44 insertions(+), 88 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 673a4b6d2e8d1e..6fd0b0a08bfee8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -985,11 +985,8 @@ xfs_attr_set(
 		return error;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
-		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+		error = xfs_iext_count_upgrade(args->trans, dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(args->trans, dp,
-					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error)
 			goto out_trans_cancel;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6c752e55a52724..89e171d59965bc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4630,11 +4630,8 @@ xfs_bmapi_convert_delalloc(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, whichfork,
+	error = xfs_iext_count_upgrade(tp, ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7d660a9739090a..235c41eca5edd7 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -765,53 +765,49 @@ xfs_ifork_verify_local_attr(
 	return 0;
 }
 
+/*
+ * Check if the inode fork supports adding nr_to_add more extents.
+ *
+ * If it doesn't but we can upgrade it to large extent counters, do the upgrade.
+ * If we can't upgrade or are already using big counters but still can't fit the
+ * additional extents, return -EFBIG.
+ */
 int
-xfs_iext_count_may_overflow(
+xfs_iext_count_upgrade(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	int			whichfork,
-	int			nr_to_add)
+	uint			nr_to_add)
 {
+	struct xfs_mount	*mp = ip->i_mount;
+	bool			has_large =
+		xfs_inode_has_large_extent_counts(ip);
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	uint64_t		max_exts;
 	uint64_t		nr_exts;
 
+	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
+
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(xfs_inode_has_large_extent_counts(ip),
-				whichfork);
-
-	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
-		max_exts = 10;
-
 	nr_exts = ifp->if_nextents + nr_to_add;
-	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
+	if (nr_exts < ifp->if_nextents) {
+		/* no point in upgrading if if_nextents overflows */
 		return -EFBIG;
+	}
 
-	return 0;
-}
-
-/*
- * Upgrade this inode's extent counter fields to be able to handle a potential
- * increase in the extent count by nr_to_add.  Normally this is the same
- * quantity that caused xfs_iext_count_may_overflow() to return -EFBIG.
- */
-int
-xfs_iext_count_upgrade(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	uint			nr_to_add)
-{
-	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
-
-	if (!xfs_has_large_extent_counts(ip->i_mount) ||
-	    xfs_inode_has_large_extent_counts(ip) ||
-	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
-		return -EFBIG;
-
-	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+		max_exts = 10;
+	else
+		max_exts = xfs_iext_max_nextents(has_large, whichfork);
+	if (nr_exts > max_exts) {
+		if (has_large || !xfs_has_large_extent_counts(mp) ||
+		    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+			return -EFBIG;
+		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	}
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index bd53eb951b6515..61e35fa239b46f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -256,10 +256,8 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
 int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
-int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
-		int nr_to_add);
 int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
-		uint nr_to_add);
+		int whichfork, uint nr_to_add);
 bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index d27859a684aa69..4f467f9389e674 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -524,9 +524,7 @@ xfs_bmap_recover_work(
 	else
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
-	error = xfs_iext_count_may_overflow(ip, work->bi_whichfork, iext_delta);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
+	error = xfs_iext_count_upgrade(tp, ip, work->bi_whichfork, iext_delta);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2be52d8265db91..035e4419e73200 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -710,11 +710,8 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_upgrade(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto error;
 
@@ -772,10 +769,8 @@ xfs_unmap_extent(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_upgrade(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1051,10 +1046,8 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_upgrade(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1280,23 +1273,16 @@ xfs_swap_extent_rmap(
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
 			if (xfs_bmap_is_real_extent(&uirec)) {
-				error = xfs_iext_count_may_overflow(ip,
-						XFS_DATA_FORK,
+				error = xfs_iext_count_upgrade(tp, ip, XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error == -EFBIG)
-					error = xfs_iext_count_upgrade(tp, ip,
-							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
 
 			if (xfs_bmap_is_real_extent(&irec)) {
-				error = xfs_iext_count_may_overflow(tip,
+				error = xfs_iext_count_upgrade(tp, ip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error == -EFBIG)
-					error = xfs_iext_count_upgrade(tp, ip,
-							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c98cb468c35780..82ac6ad9d1596a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -341,11 +341,8 @@ xfs_dquot_disk_alloc(
 		goto err_cancel;
 	}
 
-	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
+	error = xfs_iext_count_upgrade(tp, quotip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, quotip,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ba359bee2c2256..d4a85a934b967e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -298,9 +298,7 @@ xfs_iomap_write_direct(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, nr_exts);
+	error = xfs_iext_count_upgrade(tp, ip, XFS_DATA_FORK, nr_exts);
 	if (error)
 		goto out_trans_cancel;
 
@@ -606,11 +604,8 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return error;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_upgrade(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_WRITE_UNWRITTEN_CNT);
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 83f243cfa40571..3c35cd3b2dec5d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -746,11 +746,8 @@ xfs_reflink_end_cow_extent(
 		goto out_cancel;
 	}
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_upgrade(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_REFLINK_END_COW_CNT);
 	if (error)
 		goto out_cancel;
 
@@ -1278,9 +1275,7 @@ xfs_reflink_remap_extent(
 	if (dmap_written)
 		++iext_delta;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
+	error = xfs_iext_count_upgrade(tp, ip, XFS_DATA_FORK, iext_delta);
 	if (error)
 		goto out_cancel;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e66f9bd5de5cff..655e42cca7e4d8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -695,11 +695,8 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_upgrade(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto out_trans_cancel;
 
-- 
2.39.2

