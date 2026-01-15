Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C561E5714
	for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 09:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768469750; cv=none; b=bbe+i1w6TLVoGkOlJ3JXUH4S8SA0ujezENGP5l1NvISnNE71X+dNVaSs1Wtb30rw1RB8uF7rYbiVcoVEE4Q9q7JfYPRD8VrBhL6HS32M+x7pgGqI1Gc1pebfKxGqirUbKXxTqOgFsVWUiOJH+8bQw253h1AC6PcqmQ0Eh1b6H7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768469750; c=relaxed/simple;
	bh=bI5HqKrWHxkx8FKjf9psW76dxIgAKd5fmdUTQ7d772Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i7Dm9XSzaTVD3Ou9QzWY/hWDJq925b0T9kP/qXA/rQle2rdUfhugR6LU4LQ7C+CBYJrNkZ/2EDrTogbCIXRH2//vCf2blDEnw7e3hyekXj4YaM8/d9FiYxK5cEn3ZqFX6tl7A2s40l0bNNGLkhV0FJwd44tvjV25UQ9Jvzny0o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 89B34180F2D6;
	Thu, 15 Jan 2026 10:26:43 +0100 (CET)
Received: from trufa.intra.herbolt.com.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 4QW6FtOyaGlKTg0AKEJqOA
	(envelope-from <lukas@herbolt.com>); Thu, 15 Jan 2026 10:26:43 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	Lukas Herbolt <lukas@herbolt.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH RESEND v6] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Date: Thu, 15 Jan 2026 10:26:15 +0100
Message-ID: <20260115092615.21110-1-lukas@herbolt.com>
X-Mailer: git-send-email 2.52.0
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 10 ++++++++--
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_file.c      | 25 +++++++++++++++++++------
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06ca11731e430..ee5765bf52944 100644
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
index c477b33616304..2895cc97a5728 100644
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
index f96fbf5c54c99..040e4407a8a07 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1261,23 +1261,33 @@ xfs_falloc_zero_range(
 	struct xfs_zone_alloc_ctx *ac)
 {
 	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
 	unsigned int		blksize = i_blocksize(inode);
 	loff_t			new_size = 0;
 	int			error;
 
-	trace_xfs_zero_file_space(XFS_I(inode));
+	trace_xfs_zero_file_space(ip);
 
 	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
 	if (error)
 		return error;
 
-	error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
+	error = xfs_free_file_space(ip, offset, len, ac);
 	if (error)
 		return error;
 
 	len = round_up(offset + len, blksize) - round_down(offset, blksize);
 	offset = round_down(offset, blksize);
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	if (mode & FALLOC_FL_WRITE_ZEROES) {
+		if (xfs_is_always_cow_inode(ip) ||
+		    !bdev_write_zeroes_unmap_sectors(
+				xfs_inode_buftarg(ip)->bt_bdev))
+			return -EOPNOTSUPP;
+		error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_ZERO);
+	} else {
+		error = xfs_alloc_file_space(ip, offset, len,
+				XFS_BMAPI_PREALLOC);
+	}
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1302,7 +1312,8 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1330,7 +1341,8 @@ xfs_falloc_allocate_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1340,7 +1352,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1383,6 +1395,7 @@ __xfs_file_fallocate(
 	case FALLOC_FL_INSERT_RANGE:
 		error = xfs_falloc_insert_range(file, offset, len);
 		break;
+	case FALLOC_FL_WRITE_ZEROES:
 	case FALLOC_FL_ZERO_RANGE:
 		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
 		break;
-- 
2.51.1

