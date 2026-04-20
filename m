Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C95D39B483
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 10:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776682564; cv=none; b=d8AMm8qup5Y8dDw1jRdkZBvZAhiwCie475g6rRrzMhqqV0LrDMTMphI2jaa0S4AXd9qi/PAG1/ordf4sDWfqMS41iSFsIWjzmPm9b9zikqQg40JgY7vxY45AejvAk3RS3zpd3gsRDCX8jMFlf833MI0HlnECkGYb2a7etgWIZxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776682564; c=relaxed/simple;
	bh=jjW38mOuwaDy9WHXOxOwO7ZZNdqJdg0aroVESTYpZj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAZDF35763xx4BVUuSdHfsFGrzhGo3ieygET+xcuSzYYp1dsHgOHM6vOqO5GMsI8fz1pmMaiW+ODMw0OTT3A7JNGPQZ8mQckjP8AG4yEYvhUuoaQD7H8AQ0uM0dhRJSSPEFcPUqu4qqX1Z8wIc3Sb1pQlTWq+0rkojqJFopsP9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4fzj8G6vW6z9trl;
	Mon, 20 Apr 2026 12:55:58 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	dgc@kernel.org,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	andres@anarazel.de,
	kundan.kumar@samsung.com,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v3 2/3] xfs: add support for FALLOC_FL_WRITE_ZEROES
Date: Mon, 20 Apr 2026 12:55:38 +0200
Message-ID: <20260420105539.3644999-3-p.raghav@samsung.com>
In-Reply-To: <20260420105539.3644999-1-p.raghav@samsung.com>
References: <20260420105539.3644999-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the underlying block device supports the unmap write zeroes
operation, this flag allows users to quickly preallocate a file with
written extents that contain zeroes. This is beneficial for subsequent
overwrites as it prevents the need for unwritten-to-written extent
conversions, thereby significantly reducing metadata updates and journal
I/O overhead, improving overwrite performance.

Co-developed-by: Lukas Herbolt <lukas@herbolt.com>
Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
I would like to get feedback on calling xfs_zero_range in
xfs_falloc_write_zeroes function. It gets the job done but I am
wondering if there is a better of handling zeroing out between old EOF
and new offset.

 fs/xfs/xfs_file.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..99a02982154a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1368,6 +1368,57 @@ xfs_falloc_force_zero(
 	return XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE);
 }
 
+static int
+xfs_falloc_write_zeroes(
+	struct file		*file,
+	int			mode,
+	loff_t			offset,
+	loff_t			len,
+	struct xfs_zone_alloc_ctx *ac)
+{
+	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	loff_t			new_size = 0;
+	loff_t			old_size = XFS_ISIZE(ip);
+	int			error;
+	unsigned int		blksize = i_blocksize(inode);
+	loff_t			offset_aligned = round_down(offset, blksize);
+	bool			did_zero;
+
+	if (xfs_is_always_cow_inode(ip) ||
+	    !bdev_write_zeroes_unmap_sectors(
+		    xfs_inode_buftarg(XFS_I(inode))->bt_bdev))
+		return -EOPNOTSUPP;
+
+	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
+	if (error)
+		return error;
+
+	error = xfs_free_file_space(ip, offset, len, ac);
+	if (error)
+		return error;
+
+	/*
+	 * Zero the tail of the old EOF block and any space up to the new
+	 * offset.
+	 * In the usual truncate path, xfs_falloc_setsize takes care of
+	 * zeroing those blocks.
+	 */
+	if (offset_aligned > old_size)
+		error = xfs_zero_range(ip, old_size, offset_aligned - old_size,
+				NULL, &did_zero);
+	if (error)
+		return error;
+
+	error = xfs_bmap_alloc_or_convert_range(ip, offset, len,
+			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO,
+			new_size ? true : false);
+	if (error)
+		return error;
+
+	return error;
+}
+
 /*
  * Punch a hole and prealloc the range.  We use a hole punch rather than
  * unwritten extent conversion for two reasons:
@@ -1470,7 +1521,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1522,6 +1573,9 @@ __xfs_file_fallocate(
 	case FALLOC_FL_ALLOCATE_RANGE:
 		error = xfs_falloc_allocate_range(file, mode, offset, len);
 		break;
+	case FALLOC_FL_WRITE_ZEROES:
+		error = xfs_falloc_write_zeroes(file, mode, offset, len, ac);
+		break;
 	default:
 		error = -EOPNOTSUPP;
 		break;
-- 
2.51.2

