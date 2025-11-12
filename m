Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868C221CC62
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 21:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762982180; cv=none; b=Y7tqfSZMIiwrtWODg5cvLLj2uAmJfsVJaTaVm6Glj6zI+emJpLkHA7Xpa270wtzEbMdtdef82+/bFl7/8pXTz1RbYWDXwLDCK4aJwUkDjkH2Cl3SwxGR44MWbzffExC9HztcDQ8YaozRO6xEIf/fmFOtzXkGS4tebAH/WLytuE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762982180; c=relaxed/simple;
	bh=MyzdmlsVzDUM+ctSvyrsY4+hd/A66UIPWx9xoD1XWmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E12dsvTS9p7QBGAqhNEYs/LCgbYW2RcprpQQ/Zco0rtkykXv1M56dYMdjN1XcNYLR3BEfWuprzOn0s9mE8y0L01npq5kdNmrzvUrc9rNul15ifLd/uuJZRf6z3W+dt0dmjWJIZRYUD1FI6oRC7x4z0QQVFQVypxqNOx9pZ4Ywyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 60D61180F2C0;
	Wed, 12 Nov 2025 22:07:24 +0100 (CET)
Received: from trufa.intra.herbolt.com.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id yZu5DAz3FGnUDDMAKEJqOA
	(envelope-from <lukas@herbolt.com>); Wed, 12 Nov 2025 22:07:24 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: hch@infradead.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH v4] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Date: Wed, 12 Nov 2025 22:02:45 +0100
Message-ID: <20251112210244.1377664-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <aQMTYZTZIA2LF4h0@infradead.org>
References: <aQMTYZTZIA2LF4h0@infradead.org>
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
v4 changes:
	check if xfs_is_always_cow_inode
	rename flags -> bmapi_flags
	note about XFS_BMAPI_ZERO can cause software zeroing 

 fs/xfs/xfs_bmap_util.c | 10 ++++++++--
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_file.c      | 25 +++++++++++++++++++------
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06ca11731e430..ced34ce4597b4 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -642,11 +642,17 @@ xfs_free_eofblocks(
 	return error;
 }
 
+/*
+ * Callers can specify bmapi_flags, if XFS_BMAPI_ZERO is used
+ * there are no further checks whether the hardware supports it
+ * and it can fallback to software zeroing.
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
index f96fbf5c54c99..d52db0d7af8ff 100644
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
+				!bdev_write_zeroes_unmap_sectors(
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

