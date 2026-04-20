Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1C13939C9
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 10:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776682559; cv=none; b=CId6Er/Dv+0R2LZ7HoBvBxqwv4K7Hv4VGquS+k4CTuGGmG2ALe1RhuaM08s54/YK0awlqomOg79+dpf/JQ+BBRduMOOvRoAHoqtE96Erx0ahvRc/++j8+U4/zQMJ5SspTT2ypG4I/uzMpvwTV6Wg49DBJWDaWFYbMaHSOxGxn9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776682559; c=relaxed/simple;
	bh=2bQ+SfTduYti7xRqGU1WgIddLZlG4xudZKMHztZnnN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3ndQPWUvNAcjz3bSxH2IZ+QSkdC43cI8YHdFPAGo8aIa0osQ+k+PgKayhoBZgHIr/kYcCfAt2zRZxUGyclt8QKoljl1ygpNVwa3WNIGoVmM21i4TXvjReoJtNNpfJzXt2H3d3MFE6rMguN9VpcX4l48F0o60gYnSfPJxKzSyCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4fzj8B0Hcjz9thn;
	Mon, 20 Apr 2026 12:55:54 +0200 (CEST)
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
Subject: [PATCH v3 1/3] xfs: add xfs_bmap_alloc_or_convert_range function
Date: Mon, 20 Apr 2026 12:55:37 +0200
Message-ID: <20260420105539.3644999-2-p.raghav@samsung.com>
In-Reply-To: <20260420105539.3644999-1-p.raghav@samsung.com>
References: <20260420105539.3644999-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add xfs_bmap_alloc_or_convert_range() that can either allocate a range
and/or convert unwritten extents to written extents.

This function is based on xfs_iomap_write_unwritten() but we add an
extra flag parameter. Only XFS_BMAPI_CONVERT and/or XFS_BMAPI_ZERO is
accepted as flags to this function. This function also additionally
accounts while starting the transaction for the blocks that might
be created because of XFS_BMAPI_ZERO.

This is done as a preparation to add FALLOC_FL_WRITE_ZEROES flag.

xfs_iomap_write_unwritten() function will now just call
xfs_bmap_alloc_or_convert_range() with flag set to XFS_BMAPI_CONVERT.

Suggested-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/xfs/xfs_bmap_util.c | 165 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h |   3 +
 fs/xfs/xfs_iomap.c     | 113 +---------------------------
 fs/xfs/xfs_iomap.h     |   1 +
 4 files changed, 172 insertions(+), 110 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0ab00615f1ad..5a6abca12982 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -20,6 +20,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_health.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
@@ -642,6 +643,170 @@ xfs_free_eofblocks(
 	return error;
 }
 
+/*
+ * This function is used to allocate written extents over holes
+ * and/or convert unwritten extents to written extents based on the
+ * @flags passed to it.
+ *
+ * If @flags is zero, it will allocate written extents for holes and
+ * delalloc extents across the range.
+ *
+ * If XFS_BMAPI_CONVERT is specified in @flags, then it will also do
+ * conversion of unwritten extents in the range to written extents.
+ *
+ * If XFS_BMAPI_ZERO is specified in @flags, then both newly
+ * allocated extents and converted unwritten extents will be
+ * initialised to contain zeroes.
+ *
+ * If @update_isize is true, then if the range we are operating on
+ * extends beyond the current EOF, extend i_size to offset+len
+ * incrementally as extents in the range are allocated/converted.
+ */
+int
+xfs_bmap_alloc_or_convert_range(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		count,
+	uint32_t		flags,
+	bool			update_isize)
+{
+	xfs_mount_t	*mp = ip->i_mount;
+	xfs_fileoff_t	offset_fsb;
+	xfs_filblks_t	count_fsb;
+	xfs_filblks_t	numblks_fsb;
+	int		nimaps;
+	xfs_trans_t	*tp;
+	xfs_bmbt_irec_t imap;
+	struct inode	*inode = VFS_I(ip);
+	xfs_fsize_t	i_size;
+	int		error;
+
+	ASSERT((flags & ~(XFS_BMAPI_ZERO | XFS_BMAPI_CONVERT)) == 0);
+
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
+	count_fsb = (xfs_filblks_t)(count_fsb - offset_fsb);
+
+	/* Attach dquots so that bmbt splits are accounted correctly. */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
+	do {
+
+		uint	resblks, dblocks;
+		uint	bmapi_total = 0;
+		int bmapi_error;
+
+		if (flags == XFS_BMAPI_CONVERT) {
+			/*
+			 * Pure unwritten conversion. No data blocks needed.
+			 * Reserve enough for two full b-tree splits.
+			 */
+			resblks = 0;
+			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
+			bmapi_total = dblocks;
+		} else {
+			/*
+			 * We might allocate data blocks (needs resblks + 1 split) or
+			 * convert an unwritten extent (needs 0 data blocks + 2 splits).
+			 * Ensure we have enough block reservation for the worst case.
+			 */
+			resblks = XFS_FILBLKS_MIN(count_fsb, XFS_MAX_BMBT_EXTLEN);
+			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
+			dblocks += (XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1);
+			bmapi_total = 0;
+		}
+
+		/*
+		 * Set up a transaction to convert the range of extents
+		 * based on the flags. Do allocations in a loop until
+		 * we have covered the range passed in.
+		 *
+		 * Note that we can't risk to recursing back into the filesystem
+		 * here as we might be asked to write out the same inode that we
+		 * complete here and might deadlock on the iolock.
+		 */
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
+				0, true, &tp);
+		if (error)
+			return error;
+
+		if (flags & XFS_BMAPI_CONVERT)
+			error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+					XFS_IEXT_WRITE_UNWRITTEN_CNT);
+		else
+			error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+					XFS_IEXT_ADD_NOSPLIT_CNT);
+
+		if (error)
+			goto error_on_bmapi_transaction;
+
+		nimaps = 1;
+		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
+					flags, bmapi_total, &imap, &nimaps);
+		bmapi_error = error;
+
+		if (error) {
+			if (error != -ENOSR)
+				goto error_on_bmapi_transaction;
+			/*
+			 * Keep searching until we get one contiguous
+			 * extent if we get ENOSR
+			 */
+			error = 0;
+		} else {
+			/*
+			 * Log the updated inode size as we go.  We have to be careful
+			 * to only log it up to the actual write offset if it is
+			 * halfway into a block.
+			 */
+			i_size = XFS_FSB_TO_B(mp, offset_fsb + count_fsb);
+			if (i_size > offset + count)
+				i_size = offset + count;
+			if (update_isize && i_size > i_size_read(inode))
+				i_size_write(inode, i_size);
+			i_size = xfs_new_eof(ip, i_size);
+			if (i_size) {
+				ip->i_disk_size = i_size;
+				xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+			}
+
+		}
+
+		error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+		if (!bmapi_error) {
+			if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock))) {
+				xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
+				return xfs_alert_fsblock_zero(ip, &imap);
+			}
+			if ((numblks_fsb = imap.br_blockcount) == 0) {
+				/*
+				 * The numblks_fsb value should always get
+				 * smaller, otherwise the loop is stuck.
+				 */
+				ASSERT(imap.br_blockcount);
+				break;
+			}
+			offset_fsb += numblks_fsb;
+			count_fsb -= numblks_fsb;
+		}
+
+		if (error)
+			return error;
+
+	} while (count_fsb > 0);
+
+	return 0;
+
+error_on_bmapi_transaction:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b3361630..0bf84130f49d 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -57,7 +57,10 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 /* preallocation and hole punch interface */
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len);
+int	xfs_bmap_alloc_or_convert_range(struct xfs_inode *ip, xfs_off_t offset,
+		xfs_off_t count, uint32_t flags, bool update_isize);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
+
 		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
 		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f20a02f49ed9..4524907f91e3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -36,7 +36,7 @@
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
 
-static int
+int
 xfs_alert_fsblock_zero(
 	xfs_inode_t	*ip,
 	xfs_bmbt_irec_t	*imap)
@@ -616,115 +616,8 @@ xfs_iomap_write_unwritten(
 	xfs_off_t	count,
 	bool		update_isize)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_fileoff_t	offset_fsb;
-	xfs_filblks_t	count_fsb;
-	xfs_filblks_t	numblks_fsb;
-	int		nimaps;
-	xfs_trans_t	*tp;
-	xfs_bmbt_irec_t imap;
-	struct inode	*inode = VFS_I(ip);
-	xfs_fsize_t	i_size;
-	uint		resblks;
-	int		error;
-
-	trace_xfs_unwritten_convert(ip, offset, count);
-
-	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
-	count_fsb = (xfs_filblks_t)(count_fsb - offset_fsb);
-
-	/*
-	 * Reserve enough blocks in this transaction for two complete extent
-	 * btree splits.  We may be converting the middle part of an unwritten
-	 * extent and in this case we will insert two new extents in the btree
-	 * each of which could cause a full split.
-	 *
-	 * This reservation amount will be used in the first call to
-	 * xfs_bmbt_split() to select an AG with enough space to satisfy the
-	 * rest of the operation.
-	 */
-	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
-
-	/* Attach dquots so that bmbt splits are accounted correctly. */
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		return error;
-
-	do {
-		/*
-		 * Set up a transaction to convert the range of extents
-		 * from unwritten to real. Do allocations in a loop until
-		 * we have covered the range passed in.
-		 *
-		 * Note that we can't risk to recursing back into the filesystem
-		 * here as we might be asked to write out the same inode that we
-		 * complete here and might deadlock on the iolock.
-		 */
-		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks,
-				0, true, &tp);
-		if (error)
-			return error;
-
-		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
-				XFS_IEXT_WRITE_UNWRITTEN_CNT);
-		if (error)
-			goto error_on_bmapi_transaction;
-
-		/*
-		 * Modify the unwritten extent state of the buffer.
-		 */
-		nimaps = 1;
-		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-					XFS_BMAPI_CONVERT, resblks, &imap,
-					&nimaps);
-		if (error)
-			goto error_on_bmapi_transaction;
-
-		/*
-		 * Log the updated inode size as we go.  We have to be careful
-		 * to only log it up to the actual write offset if it is
-		 * halfway into a block.
-		 */
-		i_size = XFS_FSB_TO_B(mp, offset_fsb + count_fsb);
-		if (i_size > offset + count)
-			i_size = offset + count;
-		if (update_isize && i_size > i_size_read(inode))
-			i_size_write(inode, i_size);
-		i_size = xfs_new_eof(ip, i_size);
-		if (i_size) {
-			ip->i_disk_size = i_size;
-			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		}
-
-		error = xfs_trans_commit(tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (error)
-			return error;
-
-		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock))) {
-			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
-			return xfs_alert_fsblock_zero(ip, &imap);
-		}
-
-		if ((numblks_fsb = imap.br_blockcount) == 0) {
-			/*
-			 * The numblks_fsb value should always get
-			 * smaller, otherwise the loop is stuck.
-			 */
-			ASSERT(imap.br_blockcount);
-			break;
-		}
-		offset_fsb += numblks_fsb;
-		count_fsb -= numblks_fsb;
-	} while (count_fsb > 0);
-
-	return 0;
-
-error_on_bmapi_transaction:
-	xfs_trans_cancel(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
+	return xfs_bmap_alloc_or_convert_range(ip, offset, count,
+					XFS_BMAPI_CONVERT, update_isize);
 }
 
 static inline bool
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index ebcce7d49446..d59428277376 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -16,6 +16,7 @@ int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t count_fsb, unsigned int flags,
 		struct xfs_bmbt_irec *imap, u64 *sequence);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
+int xfs_alert_fsblock_zero(struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
 
-- 
2.51.2

