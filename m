Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1097CD28D
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 04:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714366176; cv=none; b=sTiNCVQvLJ1F9b56HNUAJrzS+wzSkZ2uHNbiQr+5ijCIcGleNRIfIL/fbh84E6C9sbrH5WALQqMm9Xx7QxV4mELB/qpBVYtGbPobRFKV5T5Z3Hsl/dB1SQ3XYELZ1ojaVr9/fLxJSQpnohcbORVEJLC4rvByDznVsO+BHb31lrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714366176; c=relaxed/simple;
	bh=vYPJzDhtJrQ4GqbUFLnFxal4ZS2ZJ1kQnnZZd9Uw98o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eVUmhoj8R6U1iXYg712zD90e7VDKqCIGA+Ugzq15SJSWBD18KvUt9guMeLj4T2ywAURlzp7PEQVWvktCFN0AZEoKt6BycD/HXk9k62Iu8yPbyXEg5fU1gHfphXyi5ABNanQGB8UcKufdaYU8+8qXcfSSXaKdL2PIKYzf3JLc/zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UOnwUiZi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UOnwUiZi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fcOT4wJJ3e74OZATUKDXVm07h2YoLmukK07PhSiXTNY=; b=UOnwUiZivKiABrtihWdkVC5nuo
	G/CcRKdbLNk6EyzGKdpvhfsBUSqgL0A3KJZLWogEPzOffmiAxtMXkxfcqSdru9g237ocLhI20HTvI
	pOgDJA3coNDhCSk1BPMYsX77eumZyCrwnl3n2tyofIvMd9UZtdzrNn0uHCqS0pNuu8FtRxHURoyux
	veUhpNGywnREK+Ugur6xtu5ApMGsoRt6Qy6hgW/7MaDZ0b6zE7i4xrBNpw0YDmbuNuvexuwyyZMoF
	5XUwOmoEXzuIMYIzskq86IUGUf+rh5UhyJzYf/VkdzbZ2ZOc5b18g/261OMVt74ImhbAqXGVcD31c
	LMj+sDhA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1IxK-00000001S6b-13rS;
	Mon, 29 Apr 2024 04:49:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: simplify iext overflow checking and upgrade
Date: Mon, 29 Apr 2024 06:49:14 +0200
Message-Id: <20240429044917.1504566-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429044917.1504566-1-hch@lst.de>
References: <20240429044917.1504566-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_inode_fork.c | 57 +++++++++++++++-------------------
 fs/xfs/libxfs/xfs_inode_fork.h |  6 ++--
 fs/xfs/xfs_bmap_item.c         |  4 +--
 fs/xfs/xfs_bmap_util.c         | 24 +++-----------
 fs/xfs/xfs_dquot.c             |  5 +--
 fs/xfs/xfs_iomap.c             |  9 ++----
 fs/xfs/xfs_reflink.c           |  9 ++----
 fs/xfs/xfs_rtalloc.c           |  5 +--
 10 files changed, 41 insertions(+), 88 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1c2a27fce08a9d..ded92ccefe9f6d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1050,11 +1050,8 @@ xfs_attr_set(
 		return error;
 
 	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
-		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+		error = xfs_iext_count_ensure(args->trans, dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(args->trans, dp,
-					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error)
 			goto out_trans_cancel;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 68e80e8eaaeebe..9a55ce4f1f0d45 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4621,11 +4621,8 @@ xfs_bmapi_convert_delalloc(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, whichfork,
+	error = xfs_iext_count_ensure(tp, ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7d660a9739090a..82e670dd1212c4 100644
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
+xfs_iext_count_ensure(
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
index bd53eb951b6515..9e1456f5cc2c85 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -256,10 +256,8 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
 int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
-int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
-		int nr_to_add);
-int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
-		uint nr_to_add);
+int xfs_iext_count_ensure(struct xfs_trans *tp, struct xfs_inode *ip,
+		int whichfork, uint nr_to_add);
 bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index d27859a684aa69..38067d02ee3ca7 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -524,9 +524,7 @@ xfs_bmap_recover_work(
 	else
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
-	error = xfs_iext_count_may_overflow(ip, work->bi_whichfork, iext_delta);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
+	error = xfs_iext_count_ensure(tp, ip, work->bi_whichfork, iext_delta);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index df370d7112dc54..cad3b3e4f1c33e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -710,11 +710,8 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
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
+	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1051,10 +1046,8 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
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
+				error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error == -EFBIG)
-					error = xfs_iext_count_upgrade(tp, ip,
-							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
 
 			if (xfs_bmap_is_real_extent(&irec)) {
-				error = xfs_iext_count_may_overflow(tip,
+				error = xfs_iext_count_ensure(tp, tip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error == -EFBIG)
-					error = xfs_iext_count_upgrade(tp, ip,
-							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 13aba84bd64afb..c2e66d392399dd 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -341,11 +341,8 @@ xfs_dquot_disk_alloc(
 		goto err_cancel;
 	}
 
-	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
+	error = xfs_iext_count_ensure(tp, quotip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, quotip,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c06fca2e751c7c..128ad834ca69b1 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -299,9 +299,7 @@ xfs_iomap_write_direct(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, nr_exts);
+	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK, nr_exts);
 	if (error)
 		goto out_trans_cancel;
 
@@ -625,11 +623,8 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return error;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_WRITE_UNWRITTEN_CNT);
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 02cb6c2b257058..af388f2caef304 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -768,11 +768,8 @@ xfs_reflink_end_cow_extent(
 	del = got;
 	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_REFLINK_END_COW_CNT);
 	if (error)
 		goto out_cancel;
 
@@ -1272,9 +1269,7 @@ xfs_reflink_remap_extent(
 	if (dmap_written)
 		++iext_delta;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
+	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK, iext_delta);
 	if (error)
 		goto out_cancel;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b476a876478d93..37edf4c5ce73ad 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -695,11 +695,8 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto out_trans_cancel;
 
-- 
2.39.2

