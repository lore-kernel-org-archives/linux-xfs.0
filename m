Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6E23264D8
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 10:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780568116; cv=none; b=GWChnkiN1ftsor8h6DgDxSzhDgh2ifq3FXaEHRuDg6GeqkWNXml0ZJVWykCFcxR/+/rfmFawQLkg5e1Ph69ilqPtvMcq7TAhv+wvvF83krp45PCcpHYTcVyABFBtg761QEkxjVhqeuJt3wXrV0pk9HGbFO0vHRlRR9aSFi28v5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780568116; c=relaxed/simple;
	bh=HmkirvdHWBQSnzzpxQh/91zGNBQ0p8yCLme1mREyhuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/q8FpQG6/reR65teQn4EYP0s6cOzlWwKiT81ciivIRYpcMvXfFKwbcN7cSNHxe/pGVIxzeJW0WXUWghLDBtcky7jQgfkAp9P+08XI+NK8uK1VIpMrlQ13josA37FNEfNxnDu9VSjKaj7VWCR9ZonDRIFc6CF/dKJKdP8CKKEUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4gWL6R5CGHz9vGY;
	Thu,  4 Jun 2026 12:15:11 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
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
Subject: [PATCH v5 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
Date: Thu,  4 Jun 2026 12:14:42 +0200
Message-ID: <20260604101442.2613872-3-p.raghav@samsung.com>
In-Reply-To: <20260604101442.2613872-1-p.raghav@samsung.com>
References: <20260604101442.2613872-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4gWL6R5CGHz9vGY

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
 fs/xfs/xfs_bmap_util.c | 19 ++++++++++--
 fs/xfs/xfs_bmap_util.h |  1 +
 fs/xfs/xfs_file.c      | 66 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7466267f6c60..d175a1057f13 100644
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
index e90ea6ebdc8e..37623baaaed6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1368,6 +1368,67 @@ xfs_falloc_force_zero(
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
+	    !bdev_write_zeroes_unmap_sectors(xfs_inode_buftarg(ip)->bt_bdev))
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
+	if (offset_aligned > old_size) {
+		trace_xfs_zero_eof(ip, old_size, offset_aligned - old_size);
+		error = xfs_zero_range(ip, old_size, offset_aligned - old_size,
+				NULL, &did_zero);
+		if (error)
+			return error;
+
+	}
+
+	error = xfs_alloc_file_space(ip, offset, len,
+			XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);
+	if (error)
+		return error;
+
+	/*
+	 * xfs_falloc_setsize() would re-zero the written extents via
+	 * iomap_zero_range(). Use xfs_setfilesize() instead.
+	 * Update in-core i_size first as xfs_setfilesize() clamps the on-disk
+	 * size to it.
+	 */
+	if (new_size > i_size_read(inode))
+		i_size_write(inode, new_size);
+
+	return xfs_setfilesize(ip, offset, len);
+}
+
 /*
  * Punch a hole and prealloc the range.  We use a hole punch rather than
  * unwritten extent conversion for two reasons:
@@ -1473,7 +1534,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1525,6 +1586,9 @@ __xfs_file_fallocate(
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

