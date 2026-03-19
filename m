Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B18D3F7AB4;
	Thu, 19 Mar 2026 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939805; cv=none; b=DeGGoPeJC72+WBupIpD7DpCxlisnkMDWWVX+xx7/zGJtyusVjOl2lzGAPSaPcIP1tar6r7o1y8AbUiDEcCdENmfLcFj+XTJeM7Vhm+e+SJ8rewHhpgt8AQLtTN8hFUBSihvuhfrMXy5aJGvmxDEO0AbiBk3Wu/53DPziOpzsBTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939805; c=relaxed/simple;
	bh=f6qwwcVBWozlaoLCoS3IaAM30K9YakFflKa2Do8C3t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUhphq02X5xUdeozc0C5o/AVJmulcPSX917iBbCeThnz5qenmJEchJt1+UN5ey0upHILIBfXMgnqBGnLg3iZ7dq4MxXEClBGwdDXuHGNxmKe8FxBKpnpPSXu0U1KByaky8dHhrgl7mgs05rxaZih9dJHCJB3OJT3ABaZ5IWGlgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NAHnwvC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAHnwvC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966DCC19425;
	Thu, 19 Mar 2026 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939804;
	bh=f6qwwcVBWozlaoLCoS3IaAM30K9YakFflKa2Do8C3t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAHnwvC1v2x5XwO04zmvPptpjxdyRU24sX+Ca2pjZ7bxcR5WXgtQaPemsDbWwlalr
	 b0ICWQJ42/buIvWTTWH0xjzE8UK2R+McJxTKx5equEnCApbtoifEfbMgv3Na7yjpNs
	 wVr2hzi75v0q832qjN7tOkriwTC6zPRT9SzF4u2V/f1KopbxZzNCaPHCYGsTlQnXqS
	 9j2QTI8IU9iijSAKPkhdyae8S5j7NCyiFQqoFVLqLw5gsqabG1dwDzN5S2fKaiOpue
	 9hgIqAn7jHxK4bGhH0I/KDWl8OcpNCtemt/Nj2h+oxkPyn8BtMgGvGjgg8dE+7omZJ
	 W8OzhMZ2QipIA==
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
Subject: [PATCH v5 17/25] xfs: use read ioend for fsverity data verification
Date: Thu, 19 Mar 2026 18:02:04 +0100
Message-ID: <20260319170231.1455553-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
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

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_aops.c     | 46 ++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_fsverity.c |  9 +++++++++
 fs/xfs/xfs_fsverity.h |  6 ++++++
 3 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9503252a0fa4..ecb07f250956 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -24,6 +24,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_fsverity.h"
 #include <linux/bio-integrity.h>
+#include <linux/fsverity.h>
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -171,6 +172,23 @@ xfs_end_ioend_write(
 	memalloc_nofs_restore(nofs_flag);
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
@@ -205,8 +223,7 @@ xfs_end_io(
 		list_del_init(&ioend->io_list);
 		iomap_ioend_try_merge(ioend, &tmp);
 		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
-			iomap_finish_ioends(ioend,
-				blk_status_to_errno(ioend->io_bio.bi_status));
+			xfs_end_ioend_read(ioend);
 		else
 			xfs_end_ioend_write(ioend);
 		cond_resched();
@@ -232,9 +249,14 @@ xfs_end_bio(
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
@@ -764,9 +786,13 @@ xfs_bio_submit_read(
 	struct iomap_read_folio_ctx	*ctx)
 {
 	struct bio			*bio = ctx->read_ctx;
+	struct iomap_ioend		*ioend;
 
 	/* defer read completions to the ioend workqueue */
-	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
+	ioend = iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset,
+			0);
+	ioend->io_vi = ctx->vi;
+
 	bio->bi_end_io = xfs_end_bio;
 	submit_bio(bio);
 }
@@ -779,11 +805,13 @@ static const struct iomap_read_ops xfs_iomap_read_ops = {
 
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
@@ -795,7 +823,7 @@ xfs_vm_read_folio(
 {
 	struct iomap_read_folio_ctx	ctx = { .cur_folio = folio };
 
-	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
+	ctx.ops = xfs_get_iomap_read_ops(folio->mapping, folio_pos(folio));
 	iomap_read_folio(&xfs_read_iomap_ops, &ctx, NULL);
 	return 0;
 }
@@ -806,7 +834,7 @@ xfs_vm_readahead(
 {
 	struct iomap_read_folio_ctx	ctx = { .rac = rac };
 
-	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
+	ctx.ops = xfs_get_iomap_read_ops(rac->mapping, readahead_pos(rac));
 	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
 }
 
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index 6e6a8636a577..b983e20bb5e1 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -19,3 +19,12 @@ xfs_fsverity_metadata_offset(
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
2.51.2

