Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFBF4204E
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 09:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771837958; cv=none; b=Ufd6FvzpoKVcoqiNgCnK77RZRHN/8LV0DXi1xeNymPPKpEOpuT0RAGFTenlilJVcDX44wpkWwCJzLcq7hsJScLe+PO+6abLhn1ov8wO7rvFb+YEpE2zPXXe+6AicH3tB2gzSJpPsaLZhtwHT+0SM/sE8xVx0sAEC2koURQwYQQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771837958; c=relaxed/simple;
	bh=MoTZ9iuRvTgTagDVtZ7Gl6j8AdXwmGrHUPQhBvIzMMo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nWYl+V+kv8GcsVzAkI5pvJQB8U0LjM5G/hdLdg0q/B0Txzr7ThOVIYJsjkuy8brQU4WbGMewgnwXEwWrAhsm+eznVro2qTkqQSYQusSsvL7kpaV0mHvJV2+006J3XXiRrCUNL77NEvvDX24bBf6hs/OGXQzvFuUDMyv3ntrfO4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 6B494180F24F;
	Mon, 23 Feb 2026 10:12:23 +0100 (CET)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id OVlMD/cZnGnhaw0AKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 23 Feb 2026 10:12:23 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Cc: cem@kernel.org,
	hch@infradead.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH v9] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Date: Mon, 23 Feb 2026 10:11:07 +0100
Message-ID: <20260223091106.296338-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
the unmap write zeroes operation.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 fs/xfs/xfs_bmap_util.c |  5 +++--
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_file.c      | 39 ++++++++++++++++++++++++++-------------
 3 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2208a720ec3f..0c1b1fa82f8b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -646,7 +646,8 @@ int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len)
+	xfs_off_t		len,
+	uint32_t		bmapi_flags)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
@@ -748,7 +749,7 @@ xfs_alloc_file_space(
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
index 7874cf745af3..83c45ada3cc8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1293,6 +1293,7 @@ xfs_falloc_zero_range(
 	unsigned int		blksize = i_blocksize(inode);
 	loff_t			new_size = 0;
 	int			error;
+	uint32_t                bmapi_flags;
 
 	trace_xfs_zero_file_space(ip);
 
@@ -1300,18 +1301,27 @@ xfs_falloc_zero_range(
 	if (error)
 		return error;
 
-	if (xfs_falloc_force_zero(ip, ac)) {
-		error = xfs_zero_range(ip, offset, len, ac, NULL);
-	} else {
-		error = xfs_free_file_space(ip, offset, len, ac);
-		if (error)
-			return error;
 
-		len = round_up(offset + len, blksize) -
-			round_down(offset, blksize);
-		offset = round_down(offset, blksize);
-		error = xfs_alloc_file_space(ip, offset, len);
+	if (mode & FALLOC_FL_WRITE_ZEROES) {
+		if (xfs_is_always_cow_inode(ip) ||
+		    !bdev_write_zeroes_unmap_sectors(
+				xfs_inode_buftarg(ip)->bt_bdev))
+			return -EOPNOTSUPP;
+		bmapi_flags = XFS_BMAPI_ZERO;
+	} else {
+		if (xfs_falloc_force_zero(ip, ac)) {
+			error = xfs_zero_range(ip, offset, len, ac, NULL);
+			goto set_filesize;
+		}
+		bmapi_flags = XFS_BMAPI_PREALLOC;
 	}
+
+	len = round_up(offset + len, blksize) - round_down(offset, blksize);
+	offset = round_down(offset, blksize);
+
+	error = xfs_alloc_file_space(ip, offset, len, bmapi_flags);
+
+set_filesize:
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1336,7 +1346,8 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1364,7 +1375,8 @@ xfs_falloc_allocate_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1374,7 +1386,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1417,6 +1429,7 @@ __xfs_file_fallocate(
 	case FALLOC_FL_INSERT_RANGE:
 		error = xfs_falloc_insert_range(file, offset, len);
 		break;
+	case FALLOC_FL_WRITE_ZEROES:
 	case FALLOC_FL_ZERO_RANGE:
 		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
 		break;
-- 
2.53.0

