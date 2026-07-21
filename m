Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A075A46D094;
	Tue, 21 Jul 2026 18:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659480; cv=none; b=YoKlqK3m3eXq0s7Wz4uAVg5tTWbvUtapJ9+dI/VByVBaWrVHcsKWnfZep+MTpBHWxlvCE88IMbdyxYT7TgCfDt/UrKY00OI4jZ5D4WSfj4NlgQ08Ll9gH/iOwlGVuP1qC/CNpgpXCBLl2wc5t8M0HwmfqKcugkvxdtVCNYlK7U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659480; c=relaxed/simple;
	bh=WbmPEmGzdrA9hTyWEZMTNMNxhJmUgk2kI/ITpryAokU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eP0NIhdstcz8mvUvPwyHTs30MGxYmv3RkEfztRQ3ixsodAJ/Wc6O/MQt6VpJug+86FBiLpaGTBwqNtVrzW0WdONnxWwyN8Rrqa9a7NzL6KOahUlUJ7wUca6feTLRJ8Rb+lJtPdK+9ISYP6tgmLz0gN751czZYkpPeI1Jx/6Qw3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G/IgPmpf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/IgPmpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B721F00A3A;
	Tue, 21 Jul 2026 18:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659479;
	bh=/iiQ9eZI+F7yguJJPqGVpU2t2qOI832e7x766g0ZyfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/IgPmpfQMbaCJphn4JSVxK6lb+cqthI8uFq5I7qm6zIn1zp81lWUM/j232hFNyS8
	 xmEGzK0i5NcvEq/lUC+6fCmIMueGXEBiODuRKHHUDL2PDHsL99G3ZY68wloAsqYq3L
	 MdBDbCu4zM4LR78/CNll5gX1BSo9DBpTsaryNoJjbgyrQhFxCR6rHUuUKsZy/AbcFb
	 nuFoGSmG/sXlkjG5VGmwmJKwokJmWTtutKppsLwDyfGAsVHN4MIk5veUzsuHuBxAcQ
	 z0e0zUmdY63S2eTURgdwU2OOEHmQJTsph8907U0uIZVey00fBFCS3FilzQl2G71CG/
	 KDUtkgkd/yMww==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v13 15/23] xfs: use read ioend for fsverity data verification
Date: Tue, 21 Jul 2026 20:40:52 +0200
Message-ID: <20260721184346.416657-16-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use read ioends for fsverity verification. Do not issues fsverity
metadata I/O through the same workqueue due to risk of a deadlock by a
filled workqueue.

Pass fsverity_info from iomap context down to the ioend as hashtable
lookups are expensive.

Add a simple helper to check that this is not fsverity metadata but file
data that needs verification.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_aops.c     | 45 ++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_fsverity.c |  9 +++++++++
 fs/xfs/xfs_fsverity.h |  6 ++++++
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c7843a8776b0..135be711f9a4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -24,6 +24,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_fsverity.h"
 #include <linux/bio-integrity.h>
+#include <linux/fsverity.h>
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -208,6 +209,23 @@ xfs_read_ioend_compare(
 	return 0;
 }
 
+/*
+ * IO read completion.
+ */
+static void
+xfs_end_ioend_read(
+	struct iomap_ioend	*ioend)
+{
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+
+	if (!ioend->io_bio.bi_status &&
+			xfs_fsverity_is_file_data(ip, ioend->io_offset))
+		fsverity_verify_bio(ioend->io_vi,
+				    &ioend->io_bio);
+	iomap_finish_ioends(ioend,
+		blk_status_to_errno(ioend->io_bio.bi_status));
+}
+
 /*
  * Finish all pending IO completions that require transactional modifications.
  *
@@ -246,8 +264,7 @@ xfs_end_io(
 		list_del_init(&ioend->io_list);
 		iomap_ioend_try_merge(ioend, &tmp);
 		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
-			iomap_finish_ioends(ioend,
-				blk_status_to_errno(ioend->io_bio.bi_status));
+			xfs_end_ioend_read(ioend);
 		else
 			xfs_end_ioend_write(ioend);
 		cond_resched();
@@ -273,9 +290,14 @@ xfs_end_bio(
 	}
 
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
-	if (list_empty(&ip->i_ioend_list))
-		WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
+	if (list_empty(&ip->i_ioend_list)) {
+		if (IS_ENABLED(CONFIG_FS_VERITY) && ioend->io_vi &&
+		    ioend->io_offset < xfs_fsverity_metadata_offset(ip))
+			fsverity_enqueue_verify_work(&ip->i_ioend_work);
+		else
+			WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
 					 &ip->i_ioend_work));
+	}
 	list_add_tail(&ioend->io_list, &ip->i_ioend_list);
 	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
 }
@@ -816,9 +838,12 @@ xfs_bio_submit_read(
 	struct iomap_read_folio_ctx	*ctx)
 {
 	struct bio			*bio = ctx->read_ctx;
+	struct iomap_ioend		*ioend;
 
 	/* defer read completions to the ioend workqueue */
-	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
+	ioend = iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset,
+			0);
+	ioend->io_vi = ctx->vi;
 	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
 }
 
@@ -830,11 +855,13 @@ static const struct iomap_read_ops xfs_iomap_read_ops = {
 
 static inline const struct iomap_read_ops *
 xfs_get_iomap_read_ops(
-	const struct address_space	*mapping)
+	const struct address_space	*mapping,
+	loff_t				position)
 {
 	struct xfs_inode		*ip = XFS_I(mapping->host);
 
-	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
+	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev) ||
+			xfs_fsverity_is_file_data(ip, position))
 		return &xfs_iomap_read_ops;
 	return &iomap_bio_read_ops;
 }
@@ -846,7 +873,7 @@ xfs_vm_read_folio(
 {
 	struct iomap_read_folio_ctx	ctx = { .cur_folio = folio };
 
-	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
+	ctx.ops = xfs_get_iomap_read_ops(folio->mapping, folio_pos(folio));
 	iomap_read_folio(&xfs_read_iomap_ops, &ctx, NULL);
 	return 0;
 }
@@ -857,7 +884,7 @@ xfs_vm_readahead(
 {
 	struct iomap_read_folio_ctx	ctx = { .rac = rac };
 
-	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
+	ctx.ops = xfs_get_iomap_read_ops(rac->mapping, readahead_pos(rac));
 	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
 }
 
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index 0971d2f983db..e3c8ac51c43f 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -18,3 +18,12 @@ xfs_fsverity_metadata_offset(
 {
 	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
 }
+
+bool
+xfs_fsverity_is_file_data(
+	const struct xfs_inode	*ip,
+	loff_t			offset)
+{
+	return fsverity_active(VFS_IC(ip)) &&
+			offset < xfs_fsverity_metadata_offset(ip);
+}
diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
index 5771db2cd797..ec77ba571106 100644
--- a/fs/xfs/xfs_fsverity.h
+++ b/fs/xfs/xfs_fsverity.h
@@ -9,12 +9,18 @@
 
 #ifdef CONFIG_FS_VERITY
 loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
+bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
 #else
 static inline loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip)
 {
 	WARN_ON_ONCE(1);
 	return ULLONG_MAX;
 }
+static inline bool xfs_fsverity_is_file_data(const struct xfs_inode *ip,
+					    loff_t offset)
+{
+	return false;
+}
 #endif	/* CONFIG_FS_VERITY */
 
 #endif	/* __XFS_FSVERITY_H__ */
-- 
2.54.0

