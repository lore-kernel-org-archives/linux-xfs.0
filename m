Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E339B3939DE
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 08:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782117106; cv=none; b=KcO8qyb7cJDlhGVMYXjLPBkZKzsF0CIoFcFDa1Iz4T+/5j6Dz09feCcfPcUh81xfpPYpz652sXa64OJvTv0faJW77YRlAlHvY0GNHKynSRnOsGRg55kRVrSSbwuBlqKJJNr23VNToP5sYsiFAf8VGti89XL12pIo2LBIXaJbg/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782117106; c=relaxed/simple;
	bh=4pBS/GnWBoeo/6woGmAfXV6nvoiXND7HuqQN5DA31b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuuJ3523QLzuNOmasAI04yvZ3cQGqexXiY+oAFW6wNWE6fAxYfNTHfqdb6mUTjS/suHYGV84BpJQ/CgdEqhVNrvhCqBWpKKqlGfk8XB1iB1yZPuaP0IdUfy9GjMEBMLoQ2TPJb1yCuwyxzxzI3e0FSj4Et3jyD9iesVweRmWwcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4gkLyd3Wj9z9tnJ;
	Mon, 22 Jun 2026 10:31:37 +0200 (CEST)
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
	hch@lst.de,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v7 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
Date: Mon, 22 Jun 2026 10:31:06 +0200
Message-ID: <20260622083106.2914092-3-p.raghav@samsung.com>
In-Reply-To: <20260622083106.2914092-1-p.raghav@samsung.com>
References: <20260622083106.2914092-1-p.raghav@samsung.com>
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

Punch the range first so it becomes a hole, update the size via
xfs_falloc_setsize() while it is still a hole (so its xfs_zero_range()
skips it and avoids rezeroing), then convert it to written
zeroed extents. A crash between the size update and the conversion is
safe, as a hole within i_size reads back as zeroes.

Co-developed-by: Lukas Herbolt <lukas@herbolt.com>
Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
I went to back calling xfs_falloc_setsize as using xfs_setfilesize would
involve a lot of repetition in the function. By changing the call order
with xfs_falloc_setsize we reuse most of the code.


 fs/xfs/xfs_bmap_util.c | 19 ++++++++++--
 fs/xfs/xfs_bmap_util.h |  1 +
 fs/xfs/xfs_file.c      | 67 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8dfb3c1e3759..55722b815117 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -643,11 +643,18 @@ xfs_free_eofblocks(
 }
 
 /*
- * Allocate space for a file according to @mode:
+ * Allocate space or convert extents for a file according to @mode:
  *
  * XFS_ALLOC_FILE_SPACE_PREALLOC:
  * Preallocate unwritten extents across the range and mark the inode as
  * preallocated.
+ *
+ * XFS_ALLOC_FILE_SPACE_WRITE_ZEROES:
+ * Allocate written extents over holes and convert unwritten extents in the
+ * range to written extents, initialising both to contain zeroes.
+ *
+ * This function does not update the file size; callers that extend the file
+ * are responsible for updating it once the extents are allocated.
  */
 int
 xfs_alloc_file_space(
@@ -688,6 +695,10 @@ xfs_alloc_file_space(
 		bmapi_flags = XFS_BMAPI_PREALLOC;
 		nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
 		break;
+	case XFS_ALLOC_FILE_SPACE_WRITE_ZEROES:
+		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
+		nr_exts = XFS_IEXT_WRITE_UNWRITTEN_CNT;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -776,8 +787,10 @@ xfs_alloc_file_space(
 			allocatesize_fsb -= imapp->br_blockcount;
 		}
 
-		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		if (mode == XFS_ALLOC_FILE_SPACE_PREALLOC) {
+			ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		}
 
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 232b4c48247e..e3d506ca9610 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -57,6 +57,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 /* preallocation and hole punch interface */
 enum xfs_alloc_file_space_mode {
 	XFS_ALLOC_FILE_SPACE_PREALLOC,
+	XFS_ALLOC_FILE_SPACE_WRITE_ZEROES,
 };
 
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e90ea6ebdc8e..0e1332ccdf79 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1368,6 +1368,68 @@ xfs_falloc_force_zero(
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
+	unsigned int		blksize = i_blocksize(inode);
+	xfs_off_t		offset_aligned = round_up(offset, blksize);
+	xfs_off_t		end_aligned = round_down(offset + len, blksize);
+	xfs_off_t		len_aligned = end_aligned - offset_aligned;
+	int			error;
+
+	if (xfs_is_always_cow_inode(ip) ||
+	    !bdev_write_zeroes_unmap_sectors(xfs_inode_buftarg(ip)->bt_bdev))
+		return -EOPNOTSUPP;
+
+	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
+	if (error)
+		return error;
+
+	/*
+	 *
+	 *    |----------|----------|----------|----------|----------|
+	 *    ^     ^    ^                     ^     ^    ^
+	 *    |     |    |                     |     |    |
+	 *    |   offset |                     |    end   |
+	 *    |          |                     |          |
+	 * offset_rd   offset_ru              end_rd    end_ru
+	 *
+	 * xfs_free_file_space() punches inside from offset_ru -> end_rd. It also
+	 * zeroes offset -> offset_ru and end_rd -> end.
+	 * Only pass offset_ru -> end_rd to be zeroed via xfs_alloc_file_space().
+	 */
+	error = xfs_free_file_space(ip, offset, len, ac);
+	if (error)
+		return error;
+
+	/*
+	 * Publish the new size while the punched range is still a hole, then
+	 * fill it with written zeroes.  Like the other fallocate modes we use
+	 * xfs_falloc_setsize(), but it must run *before* we convert the range
+	 * to written extents: xfs_setattr_size() zeroes [old EOF, new size) via
+	 * xfs_zero_range(), which skips holes, so there is nothing to re-zero.
+	 * It will also writeback partial EOF block before the on-disk size is
+	 * logged.
+	 */
+	error = xfs_falloc_setsize(file, new_size);
+	if (error)
+		return error;
+
+	if (len_aligned > 0)
+		error = xfs_alloc_file_space(ip, offset_aligned, len_aligned,
+				XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);
+
+	return error;
+}
+
 /*
  * Punch a hole and prealloc the range.  We use a hole punch rather than
  * unwritten extent conversion for two reasons:
@@ -1473,7 +1535,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1525,6 +1587,9 @@ __xfs_file_fallocate(
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

