Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAAF34C9AB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 19:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773171888; cv=none; b=kwM5QxxD8UVUK6wyE8Ig9SOEChRBRNcRltQr5RNdb7VCfx9qodjdWIFlQX7X4NbI11NivzMNsK7l6jsfAOaacmnKtqFi8Esgorjve/hZClmh08PwrzIbvU2sc5IVRTjxWFoISfZwe7ggFGjozuVqTJibZA1e0pSKZnBzT3W2www=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773171888; c=relaxed/simple;
	bh=FH/jvRI5XNfC5QhqostAO2F0JUfr7CMjqG+L3TdcceQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bgPuoNtZGLydZ1TLVZkQVX/iUNNItqQvbq3LySWQLYiAWgjrzecuK+qoU0E/uroq4Qpqf2MFq0rUVt2NiwDsVMDCSo96ktpGy9jH6UXF48xPlZYWX0VUJf9VIQP1oX2olzW8bUbtXbjYruZ04kxAX+p3f/BPUkMhiQwYLVk+cZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id B4F02180F149;
	Tue, 10 Mar 2026 20:44:33 +0100 (CET)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id RShpIaF0sGmtLx8AKEJqOA
	(envelope-from <lukas@herbolt.com>); Tue, 10 Mar 2026 20:44:33 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@infradead.org,
	djwong@kernel.org,
	pankaj.raghav@linux.dev,
	Pankaj Raghav <p.raghav@samsung.com>,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH v12 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Date: Tue, 10 Mar 2026 20:42:46 +0100
Message-ID: <20260310194245.848034-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for FALLOC_FL_WRITE_ZEROES if the underlying device
enable the unmap write zeroes operation.

Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 v12 changes:
	split from xfs_falloc_zero_range() into separate function
 fs/xfs/xfs_file.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index fd049a1fc9c6..ede7be05d83e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1318,6 +1318,49 @@ xfs_falloc_zero_range(
 	return xfs_falloc_setsize(file, new_size);
 }
 
+static int
+xfs_falloc_write_zero_range(
+	struct file		*file,
+	int			mode,
+	loff_t			offset,
+	loff_t			len,
+	struct xfs_zone_alloc_ctx *ac)
+{
+	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	unsigned int		blksize = i_blocksize(inode);
+	loff_t			new_size = 0;
+	int			error;
+
+	if (xfs_is_always_cow_inode(ip) ||
+	    !bdev_write_zeroes_unmap_sectors(
+		    xfs_inode_buftarg(ip)->bt_bdev))
+		return -EOPNOTSUPP;
+
+	trace_xfs_zero_file_space(ip);
+
+	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
+	if (error)
+		return error;
+
+	error = xfs_free_file_space(ip, offset, len, ac);
+	if (error)
+		return error;
+
+	len = round_up(offset + len, blksize) - round_down(offset, blksize);
+	offset = round_down(offset, blksize);
+	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
+	if (error)
+		return error;
+
+	error = xfs_falloc_setsize(file, new_size);
+	if (error)
+		return error;
+
+	return xfs_alloc_file_space(ip, offset, len,
+			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
+}
+
 static int
 xfs_falloc_unshare_range(
 	struct file		*file,
@@ -1377,7 +1420,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1423,6 +1466,10 @@ __xfs_file_fallocate(
 	case FALLOC_FL_ZERO_RANGE:
 		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
 		break;
+	case FALLOC_FL_WRITE_ZEROES:
+		error = xfs_falloc_write_zero_range(file, mode, offset,
+				len, ac);
+		break;
 	case FALLOC_FL_UNSHARE_RANGE:
 		error = xfs_falloc_unshare_range(file, mode, offset, len);
 		break;
-- 
2.53.0

