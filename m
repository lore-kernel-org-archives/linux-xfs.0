Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDE83A4F4F
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 13:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768915276; cv=none; b=alF3vwPSoMMjQ0QWOlJqeoJ9rzzWEHBlXzqDTOXZ3bBxG5BZSJKCtkOfh5D8aMp2M0d/fG+cMeFvM0xiBYHyl3IQRXS2mBMWCzPKNlxBva3h5XrVjhAx+pX+o+KlSkGqy8s2keeswBoN9mwGzw6E2Qnt90JttSMmmqWBJjl4YDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768915276; c=relaxed/simple;
	bh=+ynZvzI+ULNQkR/PChrmSwTOtXzGJWZIkimhtXUrORo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H9jul0Kr7v0iEb6RLiBqNIRbd0adKWuSNVOG+kPBI4C9XSB/qSjEE4cbSJHZM3UxR9yDOjiQ1iXUnh1GkeA37G0G0Um8S14g1VICEhnrZyeOq6rlawtJslXzmQQ1atNRwdXFLjz6pM9QaOWC1a/DJXnonEoGcASxuq1C2GV1R/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfP59wh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfP59wh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B14C19422;
	Tue, 20 Jan 2026 13:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768915276;
	bh=+ynZvzI+ULNQkR/PChrmSwTOtXzGJWZIkimhtXUrORo=;
	h=From:To:Cc:Subject:Date:From;
	b=WfP59wh1cTHw3NlQiQR9zMlPuvNKQNiWoSztEzyNtVtWhaaobu4Q7DBz9eBlJXUHh
	 1nmho48pze5SF+D0imb19ORrekru4POItHtdDSj9cDIeV904GUEG3ozLVUPLlBHSK8
	 wlJc4QfvtLdyxnyQkBN24UhgBNPJTLuHwDyU4CacRxG5e6z6Z/Vo1X/5aiT3ZzrEkj
	 kcJqyTSThVwlHYyFLQu7waIJanYWSJSB0fAj+I2A7tr64NUOXPPVjYQJvArBWmeftX
	 Gn029hGRx37EfjRlzOQWsdFj2YrIWqjFTYPZDgSkVJ8zXpBV3YyC2bAJdBFzRu2g//
	 lUMcW2miJn8Fg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	djwong@kernel.org,
	lukas@herbolt.com
Subject: [PATCH v7] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Date: Tue, 20 Jan 2026 14:20:50 +0100
Message-ID: <20260120132056.534646-2-cem@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lukas Herbolt <lukas@herbolt.com>

Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
the unmap write zeroes operation.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
[cem: rewrite xfs_falloc_zero_range() bits]
---

Christoph, Darrick, could you please review/ack this patch again? I
needed to rewrite the xfs_falloc_zero_range() bits, because it
conflicted with 66d78a11479c and 8dc15b7a6e59. This version aims mostly
to remove one of the if-else nested levels to keep it a bit cleaner.

please let me know if you agree with this version, otherwise I'll ask
Lukas to rebase it on top of the new code.

Thanks!

 fs/xfs/xfs_bmap_util.c | 10 ++++++++--
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_file.c      | 38 +++++++++++++++++++++++++++-----------
 3 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0ab00615f1ad..74a7597d0998 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -642,11 +642,17 @@ xfs_free_eofblocks(
 	return error;
 }
 
+/*
+ * Callers can specify bmapi_flags, if XFS_BMAPI_ZERO is used there are no
+ * further checks whether the hard ware supports and it can fallback to
+ * software zeroing.
+ */
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len)
+	xfs_off_t		len,
+	uint32_t		bmapi_flags)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
@@ -748,7 +754,7 @@ xfs_alloc_file_space(
 		 * will eventually reach the requested range.
 		 */
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
+				allocatesize_fsb, bmapi_flags, 0, imapp,
 				&nimaps);
 		if (error) {
 			if (error != -ENOSR)
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b3361630..2895cc97a572 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -56,7 +56,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 
 /* preallocation and hole punch interface */
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
-		xfs_off_t len);
+		xfs_off_t len, uint32_t bmapi_flags);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d36a9aafa8ab..b23f1373116e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1302,16 +1302,29 @@ xfs_falloc_zero_range(
 
 	if (xfs_falloc_force_zero(ip, ac)) {
 		error = xfs_zero_range(ip, offset, len, ac, NULL);
-	} else {
-		error = xfs_free_file_space(ip, offset, len, ac);
-		if (error)
-			return error;
+		goto out;
+	}
 
-		len = round_up(offset + len, blksize) -
-			round_down(offset, blksize);
-		offset = round_down(offset, blksize);
-		error = xfs_alloc_file_space(ip, offset, len);
+	error = xfs_free_file_space(ip, offset, len, ac);
+	if (error)
+		return error;
+
+	len = round_up(offset + len, blksize) - round_down(offset, blksize);
+	offset = round_down(offset, blksize);
+
+	if (mode & FALLOC_FL_WRITE_ZEROES) {
+		if (xfs_is_always_cow_inode(ip) ||
+		    !bdev_write_zeroes_unmap_sectors(
+				xfs_inode_buftarg(ip)->bt_bdev))
+			return -EOPNOTSUPP;
+		error = xfs_alloc_file_space(ip, offset, len,
+					     XFS_BMAPI_ZERO);
+	} else {
+		error = xfs_alloc_file_space(ip, offset, len,
+					     XFS_BMAPI_PREALLOC);
 	}
+
+out:
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1336,7 +1349,8 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1364,7 +1378,8 @@ xfs_falloc_allocate_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1374,7 +1389,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1417,6 +1432,7 @@ __xfs_file_fallocate(
 	case FALLOC_FL_INSERT_RANGE:
 		error = xfs_falloc_insert_range(file, offset, len);
 		break;
+	case FALLOC_FL_WRITE_ZEROES:
 	case FALLOC_FL_ZERO_RANGE:
 		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
 		break;
-- 
2.52.0

