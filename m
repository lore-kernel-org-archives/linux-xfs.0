Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6003C126BF1
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 14:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761056309; cv=none; b=AInUJr8HQdCKqCUuYwJGjTaJDHSvfVpUv989+ImKhWzDlvG0l6z54/CB1JOLyjTPyLEuLyfDAh78junTus0Beku/4AWWjtoRk875v3rZ+Oi1D1dZc+k4D2Ua56iN8/VePpR9r8MExlwiojkelJrgpY/CXOEVAw8f7DAOC1+kAx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761056309; c=relaxed/simple;
	bh=mIGBfdg00jEgSeJI1OjlhlN5MNrRFOqypywTBsee3+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idyVmUGZ6EsCWYteLA52bkWP73lwKnqFKO2G7h4hzPkB/jP4WInc6aSOCzG8Md1GSi9cxgp2/YmCfXukondZZQNNvUbMBxNAChBGfJA0v0/asoLZGOsKmx3vmBLngg1o9jQk11ZlgM7NWGlvybPHvTJ4Vy+LsDzOQmSgPjygF+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 29354180F2C2;
	Tue, 21 Oct 2025 16:18:23 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 24M5EyKW92ioeRoAKEJqOA:T2
	(envelope-from <lukas@herbolt.com>); Tue, 21 Oct 2025 16:18:23 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Date: Tue, 21 Oct 2025 16:17:44 +0200
Message-ID: <20251021141744.1375627-3-lukas@herbolt.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021141744.1375627-1-lukas@herbolt.com>
References: <20251021141744.1375627-1-lukas@herbolt.com>
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
 fs/xfs/xfs_bmap_util.c |  6 +++---
 fs/xfs/xfs_bmap_util.h |  4 ++--
 fs/xfs/xfs_file.c      | 25 ++++++++++++++++++-------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06ca11731e430..fd43c9db79a8d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -645,6 +645,7 @@ xfs_free_eofblocks(
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
+	uint32_t		flags,		/* XFS_BMAPI_... */
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
@@ -747,9 +748,8 @@ xfs_alloc_file_space(
 		 * startoffset_fsb so that one of the following allocations
 		 * will eventually reach the requested range.
 		 */
-		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
-				&nimaps);
+		error = xfs_bmapi_write(tp, ip, startoffset_fsb, allocatesize_fsb,
+				flags, 0, imapp, &nimaps);
 		if (error) {
 			if (error != -ENOSR)
 				goto error;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b33616304..67770830eb245 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -55,8 +55,8 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 			     int *is_empty);
 
 /* preallocation and hole punch interface */
-int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
-		xfs_off_t len);
+int	xfs_alloc_file_space(struct xfs_inode *ip, uint32_t flags,
+		xfs_off_t offset, xfs_off_t len);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f96fbf5c54c99..b7e8cda62bb73 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1255,29 +1255,37 @@ xfs_falloc_insert_range(
 static int
 xfs_falloc_zero_range(
 	struct file		*file,
-	int			mode,
+	int				mode,
 	loff_t			offset,
 	loff_t			len,
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
+		if (!bdev_write_zeroes_unmap_sectors(xfs_inode_buftarg(ip)->bt_bdev))
+			return -EOPNOTSUPP;
+		xfs_alloc_file_space(ip, XFS_BMAPI_ZERO, offset, len);
+	} else {
+		error = xfs_alloc_file_space(ip, XFS_BMAPI_PREALLOC,
+				offset, len);
+	}
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1302,7 +1310,8 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_PREALLOC,
+			offset, len);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1330,7 +1339,8 @@ xfs_falloc_allocate_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_PREALLOC,
+			offset, len);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1340,7 +1350,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1383,6 +1393,7 @@ __xfs_file_fallocate(
 	case FALLOC_FL_INSERT_RANGE:
 		error = xfs_falloc_insert_range(file, offset, len);
 		break;
+	case FALLOC_FL_WRITE_ZEROES:
 	case FALLOC_FL_ZERO_RANGE:
 		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
 		break;
-- 
2.51.0

