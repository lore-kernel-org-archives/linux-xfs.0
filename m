Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A962F472538;
	Tue, 21 Jul 2026 18:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659477; cv=none; b=rKyY8M/9abZJNPHn9pcggtlxwEVmie165qUu802xe7qgv3K/GggP9S5vaUUjkByOXqYKAkcyvnzuZBR76m/QtctdHzlbfdeJVpPXuAkVEP0rNF94qWYOoDgQjq0YBnfa+RWTR7WwSie9+SJtDFw42oYMD874SC6V5Uq/KNpD8rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659477; c=relaxed/simple;
	bh=mR/hFSygtGr3j3RN0ocaT7I/5kok3kT0D391TUt636I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDZs7srct1pnoNUmzJYNPVgTLD+3izbogFqnJ8eIG07g5FqgAutBYrQQ9ULp0TTiXLnZKW3VhopjuNnlNNDyPiLAxoMIKYO99azFvs6JlKKnPXXcc1DPPSSZhYHiBd5ggLOOKEnuv0CD9ZbtfbmHK5rNUstvZTawlEwo2H2YNX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUzlk21A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUzlk21A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B251F00A3D;
	Tue, 21 Jul 2026 18:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659476;
	bh=u81BkS3jMnJue5L3AYROT1gE9HvtANvaiLqhCodO2vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUzlk21AkPgwRnGJ7YHdWcJ3/MayMTE/pkXp/BJYB3anwkYcZ+NZ1lmBYxWgyaSes
	 R329cBnCzJc941GqD3IQ2eenkpoFaMgr6XtRCkkg0vvdvZvb0w+0qhulleoNPEy0Vn
	 b98Gs7a6oz7J9xWPIdfqLt3T5ko6t/cbPz+hLvvY1ckOAB5tU7i6r/zrEUMIht/Z9N
	 mEiQ5d1xc2Erp9gYLQ1Axz9UGw79dh3lhSziOlLvrW4YQ3SIXsD865d3Yd6stnc9Zy
	 cBAbX5uQFLWTTes0ehpttDtj93qSEU3foDqZ92wwQyueKANPfkU1sqZkS9QD2nNZ5i
	 XxcavDrg08H8w==
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
Subject: [PATCH v13 14/23] xfs: always prioritize fsverity metadata ioends in ioend completion
Date: Tue, 21 Jul 2026 20:40:51 +0200
Message-ID: <20260721184346.416657-15-aalbersh@kernel.org>
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

When both block device integrity checksums and fsverity are used, all
read ioends end up in the ioend processing. This means that fsverity
data and metadata ioends could both get on ioend queue ip->i_ioend_list.

Then, when worker pick ups the work, it will process all ioends in the
queue. Before, processing ioends are sorted based on file offset,
meaning data ioend first, metadata second. Metadata ioend already
holding folio lock, if data ioend needs this exact folio the worker will
self deadlock.

Fix this by prioritizing fsverity metadata while sorting read ioends.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/ioend.c      |  8 ++++----
 fs/xfs/xfs_aops.c     | 32 +++++++++++++++++++++++++++++++-
 include/linux/iomap.h |  5 ++++-
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 0565328764c1..8e46b7f1aa6a 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -4,7 +4,6 @@
  */
 #include <linux/bio-integrity.h>
 #include <linux/iomap.h>
-#include <linux/list_sort.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/fserror.h>
@@ -425,7 +424,7 @@ void iomap_ioend_try_merge(struct iomap_ioend *ioend,
 }
 EXPORT_SYMBOL_GPL(iomap_ioend_try_merge);
 
-static int iomap_ioend_compare(void *priv, const struct list_head *a,
+int iomap_ioend_compare(void *priv, const struct list_head *a,
 		const struct list_head *b)
 {
 	struct iomap_ioend *ia = container_of(a, struct iomap_ioend, io_list);
@@ -437,10 +436,11 @@ static int iomap_ioend_compare(void *priv, const struct list_head *a,
 		return 1;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(iomap_ioend_compare);
 
-void iomap_sort_ioends(struct list_head *ioend_list)
+void iomap_sort_ioends(struct list_head *ioend_list, list_cmp_func_t cmp)
 {
-	list_sort(NULL, ioend_list, iomap_ioend_compare);
+	list_sort(NULL, ioend_list, cmp);
 }
 EXPORT_SYMBOL_GPL(iomap_sort_ioends);
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 34d0ff7c7086..c7843a8776b0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -182,6 +182,32 @@ xfs_end_ioend_write(
 	memalloc_nofs_restore(nofs_flag);
 }
 
+/*
+ * Prioritize fsverity metadata over file data. Sort based on i_size as fsverity
+ * metadata is always beyond EOF
+ */
+static int
+xfs_read_ioend_compare(
+	void			*priv,
+	const struct list_head	*a,
+	const struct list_head	*b)
+{
+	struct iomap_ioend	*ia = container_of(a, struct iomap_ioend,
+			io_list);
+	struct iomap_ioend	*ib = container_of(b, struct iomap_ioend,
+			io_list);
+	loff_t			i_size = i_size_read(ia->io_inode);
+
+	if (!IS_VERITY(ia->io_inode))
+		return iomap_ioend_compare(priv, a, b);
+
+	if (ia->io_offset > i_size && ib->io_offset < i_size)
+		return -1;
+	if (ia->io_offset < i_size && ib->io_offset > i_size)
+		return 1;
+	return 0;
+}
+
 /*
  * Finish all pending IO completions that require transactional modifications.
  *
@@ -210,7 +236,11 @@ xfs_end_io(
 	list_replace_init(&ip->i_ioend_list, &tmp);
 	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
 
-	iomap_sort_ioends(&tmp);
+	ioend = list_first_entry_or_null(&tmp, struct iomap_ioend, io_list);
+	if (bio_op(&ioend->io_bio) == REQ_OP_READ)
+		iomap_sort_ioends(&tmp, xfs_read_ioend_compare);
+	else
+		iomap_sort_ioends(&tmp, iomap_ioend_compare);
 	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
 			io_list))) {
 		list_del_init(&ioend->io_list);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 56b43d594e6e..36fc931382a8 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -10,6 +10,7 @@
 #include <linux/mm_types.h>
 #include <linux/blkdev.h>
 #include <linux/folio_batch.h>
+#include <linux/list_sort.h>
 
 struct address_space;
 struct fiemap_extent_info;
@@ -488,7 +489,9 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
 void iomap_finish_ioends(struct iomap_ioend *ioend, int error);
 void iomap_ioend_try_merge(struct iomap_ioend *ioend,
 		struct list_head *more_ioends);
-void iomap_sort_ioends(struct list_head *ioend_list);
+int iomap_ioend_compare(void *priv, const struct list_head *a,
+		const struct list_head *b);
+void iomap_sort_ioends(struct list_head *ioend_list, list_cmp_func_t cmp);
 ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 		loff_t pos, loff_t end_pos, unsigned int dirty_len);
 int iomap_ioend_writeback_submit(struct iomap_writepage_ctx *wpc, int error);
-- 
2.54.0

