Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4673101B5
	for <linux-xfs@vger.kernel.org>; Thu,  2 Oct 2025 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759408137; cv=none; b=Pb5YFCrycMqBdn6wYkZEPEj6NMenn7Y7rCz/p3tjDY197FvvMyMc99dIrCLTIMUmieIgjamdbB+/Bo6DVVyGSMoWuCFOiUn6s4IYBXZgFvqmUg1ymKeC55rBwasM1OgIM5slJIdnl/HWN1ce0hE68qP2sc9kUYV+hqXxEDpinqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759408137; c=relaxed/simple;
	bh=6YOAl+dUkgqHJsDQ90ZQorWFIGKEA/tEAhMjHocT8JI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jAF9s4ubf4OjuP0qF57kAlz5GlWz9yL8NhRZnkEob24x7f+7d5VcH+nr+aPZ8uGBkYv8QIhs7gKL5AdbJBUbVnhlaByTK6st53oUYb0arLLTOxMIT8Zomy/5MGvL8ouqm7KqYnL46CWW+4BpJs3FxGHr//JqSwCw6OZSy/2iyXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 5F3C3180FCC3;
	Thu, 02 Oct 2025 14:28:42 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id WVC0CPpv3mjlOgUAKEJqOA
	(envelope-from <lukas@herbolt.com>); Thu, 02 Oct 2025 14:28:42 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org
Cc: Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH RFC] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Date: Thu,  2 Oct 2025 14:28:24 +0200
Message-ID: <20251002122823.1875398-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
the unmap write zeroes operation.

Inspired by the Ext4 implementation of the FALLOC_FL_WRITE_ZEROES. It
can speed up some patterns on specific hardware.

time ( ./fallocate -l 360M /mnt/test.file; dd if=/dev/zero of=/mnt/test.file \
bs=1M count=360 conv=notrunc,nocreat oflag=direct,dsync)

360+0 records in
360+0 records out
377487360 bytes (377 MB, 360 MiB) copied, 22.0027 s, 17.2 MB/s

real	0m22.114s
user	0m0.006s
sys		0m3.085s

time (./fallocate -wl 360M /mnt/test.file; dd if=/dev/zero of=/mnt/test.file \
bs=1M count=360 conv=notrunc,nocreat oflag=direct,dsync );
360+0 records in
360+0 records out
377487360 bytes (377 MB, 360 MiB) copied, 2.02512 s, 186 MB/s

real	0m6.384s
user	0m0.002s
sys		0m5.823s



Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 fs/xfs/xfs_bmap_util.c |  5 +++--
 fs/xfs/xfs_bmap_util.h |  4 ++--
 fs/xfs/xfs_file.c      | 23 ++++++++++++++++++-----
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06ca11731e430..a91596a280ba5 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -645,6 +645,7 @@ xfs_free_eofblocks(
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
+    uint32_t        flags,      /* XFS_BMAPI_... */
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
@@ -748,8 +749,8 @@ xfs_alloc_file_space(
 		 * will eventually reach the requested range.
 		 */
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
-				&nimaps);
+				allocatesize_fsb, flags, 0, imapp, &nimaps);
+
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
index f96fbf5c54c99..48559a011e9b4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1255,7 +1255,7 @@ xfs_falloc_insert_range(
 static int
 xfs_falloc_zero_range(
 	struct file		*file,
-	int			mode,
+	int				mode,
 	loff_t			offset,
 	loff_t			len,
 	struct xfs_zone_alloc_ctx *ac)
@@ -1277,7 +1277,16 @@ xfs_falloc_zero_range(
 
 	len = round_up(offset + len, blksize) - round_down(offset, blksize);
 	offset = round_down(offset, blksize);
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	if (mode & FALLOC_FL_WRITE_ZEROES) {
+		if (!bdev_write_zeroes_unmap_sectors(inode->i_sb->s_bdev))
+	        return -EOPNOTSUPP;
+		error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_ZERO,
+				offset, len);
+	}
+	else
+		error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_PREALLOC,
+				offset, len);
+
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1302,7 +1311,8 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_PREALLOC,
+			offset, len);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1330,7 +1340,9 @@ xfs_falloc_allocate_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_PREALLOC,
+			offset, len);
+
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1340,7 +1352,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES )
 
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
2.51.0

