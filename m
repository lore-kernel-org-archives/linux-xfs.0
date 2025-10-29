Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B0928C5DE
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761760430; cv=none; b=WMUZz3vj1SMzwbcmKlZB7YExUbpa0aKWZqlOkfEs+y0wREHs4qr6WY9mPyn5GzeLw2SXu4q4fp4MyZutMVcSml6lYuogHrkl8a1CkV3NHSclZUasT7aXtl/nZhf095pDd/stmt3btO5mS5F2bCWUyqhJP2rtKXos1TVKZpc2qqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761760430; c=relaxed/simple;
	bh=omML1QeVAyxxRlwnqsBGBBz1Bdi70FQgjDwDHoZ2VvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awzA3AI8fXNE/OINK59f6+y0b8Uxi2dJK/NWbsTRjHe/tjJsSsy5Z5e57nH2LRnbS0ydyzJG21bt4u08bjYBpVn0XGFrRe5Yd7Ppy11CZD/N70UZiyMtXSDM4X4x0tgVjiDkPNPXmVaB5izESGUD9bmRfjeKXUWpEj16RgE6QyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 3A90B180F2C0;
	Wed, 29 Oct 2025 18:53:32 +0100 (CET)
Received: from trufa.intra.herbolt.com.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id uHGeA5xUAmlTbiMAKEJqOA
	(envelope-from <lukas@herbolt.com>); Wed, 29 Oct 2025 18:53:32 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: yi.zhang@huaweicloud.com
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH v3] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Date: Wed, 29 Oct 2025 18:53:14 +0100
Message-ID: <20251029175313.3644646-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <0e89b047-cacb-4c23-aa83-27de1eb235a5@huaweicloud.com>
References: <0e89b047-cacb-4c23-aa83-27de1eb235a5@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
the unmap write zeroes operation.

v3 changes:
 - fix formating
 - fix check  on the return value of xfs_alloc_file_space
 - add check if inode COW and return -EOPNOTSUPP

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 fs/xfs/xfs_bmap_util.c |  6 +++---
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_file.c      | 24 ++++++++++++++++++------
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06ca11731e430..ddbcf4b0cea17 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -646,7 +646,8 @@ int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len)
+	xfs_off_t		len,
+	uint32_t		flags)	/* XFS_BMAPI_... */
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
@@ -748,8 +749,7 @@ xfs_alloc_file_space(
 		 * will eventually reach the requested range.
 		 */
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
-				&nimaps);
+				allocatesize_fsb, flags, 0, imapp, &nimaps);
 		if (error) {
 			if (error != -ENOSR)
 				goto error;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b33616304..1fd4844d4ec64 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -56,7 +56,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 
 /* preallocation and hole punch interface */
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
-		xfs_off_t len);
+		xfs_off_t len, uint32_t flags);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f96fbf5c54c99..38de47ffb8d39 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1261,23 +1261,32 @@ xfs_falloc_zero_range(
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
+		if (xfs_is_cow_inode(ip) || !bdev_write_zeroes_unmap_sectors(
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
@@ -1302,7 +1311,8 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode),	offset, len,
+			XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1330,7 +1340,8 @@ xfs_falloc_allocate_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1340,7 +1351,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1383,6 +1394,7 @@ __xfs_file_fallocate(
 	case FALLOC_FL_INSERT_RANGE:
 		error = xfs_falloc_insert_range(file, offset, len);
 		break;
+	case FALLOC_FL_WRITE_ZEROES:
 	case FALLOC_FL_ZERO_RANGE:
 		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
 		break;
-- 
2.51.0

