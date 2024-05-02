Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA00224F2
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 07:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714635248; cv=none; b=Ec58hqBmIxjrpItdZlyqSw6iL8KtRtTnzAhH0pfK0crIhVyLyvnezpZzdwDFYF9BF7X7soWZnDPr792O+k1DHkfuWyMo60vFa099cGHNeHdJO9408/m6zbC7aLK6oIp7tJLHuI0ld/tKhlh5hOays3ccEweNPzIyDX/f0G4516g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714635248; c=relaxed/simple;
	bh=CvleQbHNaciZcKiGNW8Q1aASR3y855/99fPBDIDC3uE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hKX0ReKomt0jLH1HUoVAFgQrdJrkww52ekarAU7OeWdGWGVdcYvTI88h7bdhm6SUJ4O7bHom9UUJtBgVixSVRuN7aYCbZzsyDlbq4E1KcceC5Q7Unrqqr89OgkGvRfc8JfI+Sq6VWUyxoXkgNoZjB4sKR1jSbgQY8TmdWWzTN2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GuyLMTOM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GuyLMTOM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wxLnFTXKOTHp839SgR/7Tto8s1V083/mALP6zRzr8Eo=; b=GuyLMTOMmzR5t+oYD7DkP1vPTf
	PqCxBH083NJQ+am2YvVwkToPHRzwd/W73iPKzK7iHn7tBcK4wjTxejirKLrCXUAHyZ00EO8zTXkyu
	P7PGwkj+JhBvXjl0KdclhP+f033Gz90SQ9zOE9JFOb9CGOoXXveSYKYOiiummUeG7yg6DJHc9oiSd
	We+/JCWxirxxZ1BcyEv+l4DiZc7fr32nVp0L7x+s3QKj2fOUJDv9ibqSl/13dP/e+MNfNZwW8t+Q/
	la5hZpN7RGwJJeX1IqwB1rYjOO8wKFuYP5ItpksChkTQ1C2DTkHV29fv09/Tbb4RLqqpbxXNZYrq/
	omTIZZQg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s2QxB-0000000Bojn-4226;
	Thu, 02 May 2024 07:34:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: simplify iext overflow checking and upgrade
Date: Thu,  2 May 2024 09:33:55 +0200
Message-Id: <20240502073355.1893587-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240502073355.1893587-1-hch@lst.de>
References: <20240502073355.1893587-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |  5 +--
 fs/xfs/libxfs/xfs_bmap.c       |  5 +--
 fs/xfs/libxfs/xfs_inode_fork.c | 57 +++++++++++++++-------------------
 fs/xfs/libxfs/xfs_inode_fork.h |  6 ++--
 fs/xfs/xfs_bmap_item.c         |  4 +--
 fs/xfs/xfs_bmap_util.c         | 23 +++-----------
 fs/xfs/xfs_dquot.c             |  5 +--
 fs/xfs/xfs_iomap.c             |  9 ++----
 fs/xfs/xfs_reflink.c           |  9 ++----
 fs/xfs/xfs_rtalloc.c           |  5 +--
 10 files changed, 41 insertions(+), 87 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1c2a27fce08a9d..c8d1c3ac19dcad 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1050,11 +1050,8 @@ xfs_attr_set(
 		return error;
 
 	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
-		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+		error = xfs_iext_count_extend(args->trans, dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(args->trans, dp,
-					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error)
 			goto out_trans_cancel;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index be515bac8ea1e0..1ea444bef3b1c3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4651,11 +4651,8 @@ xfs_bmapi_convert_one_delalloc(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, whichfork,
+	error = xfs_iext_count_extend(tp, ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7d660a9739090a..9d11ae01590919 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -765,53 +765,46 @@ xfs_ifork_verify_local_attr(
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
+xfs_iext_count_extend(
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
-	uint64_t		max_exts;
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
+	/* no point in upgrading if if_nextents overflows */
 	nr_exts = ifp->if_nextents + nr_to_add;
-	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
+	if (nr_exts < ifp->if_nextents)
 		return -EFBIG;
 
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
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
+	    nr_exts > 10)
 		return -EFBIG;
 
-	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
+	if (nr_exts > xfs_iext_max_nextents(has_large, whichfork)) {
+		if (has_large || !xfs_has_large_extent_counts(mp))
+			return -EFBIG;
+		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	}
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index bd53eb951b6515..2373d12fd474f0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -256,10 +256,8 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
 int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
-int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
-		int nr_to_add);
-int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
-		uint nr_to_add);
+int xfs_iext_count_extend(struct xfs_trans *tp, struct xfs_inode *ip,
+		int whichfork, uint nr_to_add);
 bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index d27859a684aa69..a19d62e78aa1e6 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -524,9 +524,7 @@ xfs_bmap_recover_work(
 	else
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
-	error = xfs_iext_count_may_overflow(ip, work->bi_whichfork, iext_delta);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
+	error = xfs_iext_count_extend(tp, ip, work->bi_whichfork, iext_delta);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2e6f08198c0719..9cafb3cb5817ae 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -713,11 +713,8 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto error;
 
@@ -774,10 +771,8 @@ xfs_unmap_extent(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1053,10 +1048,8 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1282,23 +1275,17 @@ xfs_swap_extent_rmap(
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
 			if (xfs_bmap_is_real_extent(&uirec)) {
-				error = xfs_iext_count_may_overflow(ip,
+				error = xfs_iext_count_extend(tp, ip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error == -EFBIG)
-					error = xfs_iext_count_upgrade(tp, ip,
-							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
 
 			if (xfs_bmap_is_real_extent(&irec)) {
-				error = xfs_iext_count_may_overflow(tip,
+				error = xfs_iext_count_extend(tp, tip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error == -EFBIG)
-					error = xfs_iext_count_upgrade(tp, ip,
-							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 43acb4f0d17433..c1b211c260a9d5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -341,11 +341,8 @@ xfs_dquot_disk_alloc(
 		goto err_cancel;
 	}
 
-	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
+	error = xfs_iext_count_extend(tp, quotip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, quotip,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f5d0ed45721b5c..1bcc2027806810 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -299,9 +299,7 @@ xfs_iomap_write_direct(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, nr_exts);
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, nr_exts);
 	if (error)
 		goto out_trans_cancel;
 
@@ -617,11 +615,8 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return error;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_WRITE_UNWRITTEN_CNT);
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3bb5318f699ddc..2db72a1ac288dd 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -759,11 +759,8 @@ xfs_reflink_end_cow_extent(
 	del = got;
 	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_REFLINK_END_COW_CNT);
 	if (error)
 		goto out_cancel;
 
@@ -1263,9 +1260,7 @@ xfs_reflink_remap_extent(
 	if (dmap_written)
 		++iext_delta;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, iext_delta);
 	if (error)
 		goto out_cancel;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 150f544445ca82..5a7ddfed1bb855 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -695,11 +695,8 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto out_trans_cancel;
 
-- 
2.39.2

