Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8B14611CE;
	Fri, 14 Aug 2026 09:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699587; cv=none; b=dwtmwjw1bWMi/i4xgbhRpgzvIWZy5MkOxD+g/RZ1KoxlmS6f6EKTtM97dnRFvlEBoGmAdQG1IiKrjbtjXPDzDX0L4V7AGz7RItL9y7P1xpdWg88Js+UB2KxAl3H4KPvDHfV6oRj0uWwSEa6jfNtzJ3bHngwK4/Qmip7plPk5vPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699587; c=relaxed/simple;
	bh=zXTQarBtIkuHn11IccJSyuGSp3V66wQDsCRnuaDmW3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZgJv6lSKGoGkJ1S9pTRFnK4cIywjJOVYRYLHqS3Ut5GVFo+CDdSgwSLd0BN/vi0pE9YEfDfQmjD+lNiLe3va1131Ie8EFaK9bGoFamzbE9EU3m18NQ97T9u0fzMY1CkVCgKPJhiOA6MUP7U4osBWxkf89UpqSwp9/324oZzp/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UEgGk0Ni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UEgGk0Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E84A1F00A3D;
	Fri, 14 Aug 2026 09:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699582;
	bh=lGL8NsZlcEAeC8jVNcrKN+dXzs/Q/Uw4+7q/XmRaGvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEgGk0NiozQwdsLlSYm5AiE2L6bFnzuxoQZoPHQzW9t65o3GrzP9mOePOsDtqg8hS
	 h4GsOaXx8kvLw/kAC0X58mqMNsKPtHxo2auzdnTGwEElvdDGEmDBCgHiI1sxD3ea/P
	 DcUgCLAGow7GSqI34XIyP+g4TgHxqf7/TytR6AK0DKJgRq7D7QYKMEVS+zl1ZJIWZd
	 qM2Zsc7On9RwOXsvP/1n67ztqbEfabTNBdwkdRWa5IxHbxT5hBZAFniBUk1+fayQrb
	 J7x4gVzYzunl0e7kfUb0nd85eqbGFcN+w6MStKnXlzqt7AN23mMvVJHMIpqCmUDQZu
	 PpR9DfcTrrjpA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 10/25] iomap: add a IOMAP_IOEND_INTEGRITY flag
Date: Fri, 14 Aug 2026 11:24:27 +0200
Message-ID: <20260814092448.1818082-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

This will make it easier to share code for the various submit callback
provided by the file system to iomap.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/ioend.c      |  2 +-
 fs/xfs/xfs_aops.c     |  5 +++--
 fs/xfs/xfs_file.c     |  5 +++--
 include/linux/iomap.h | 11 ++++++++++-
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index d71e7f5609c6..dece11397cd7 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -149,7 +149,7 @@ int iomap_ioend_writeback_submit(struct iomap_writepage_ctx *wpc, int error)
 		return error;
 	}
 
-	if (wpc->iomap.flags & IOMAP_F_INTEGRITY)
+	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_generate(&ioend->io_bio);
 	submit_bio(&ioend->io_bio);
 	return 0;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6f21e207a0ad..a39dcd8c9a1c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -491,7 +491,7 @@ xfs_zoned_writeback_submit(
 		bio_endio(&ioend->io_bio);
 		return error;
 	}
-	if (wpc->iomap.flags & IOMAP_F_INTEGRITY)
+	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_generate(&ioend->io_bio);
 	xfs_zone_alloc_and_submit(ioend, &XFS_ZWPC(wpc)->open_zone);
 	return 0;
@@ -581,7 +581,8 @@ xfs_bio_submit_read(
 	struct bio			*bio = ctx->read_ctx;
 
 	/* defer read completions to the ioend workqueue */
-	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
+	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset,
+		iomap_ioend_flags(&iter->iomap));
 	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ef29dba6e38e..6d989bd1696b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -235,7 +235,8 @@ xfs_dio_read_bounce_submit_io(
 	struct bio		*bio,
 	loff_t			file_offset)
 {
-	iomap_init_ioend(iter->inode, bio, file_offset, IOMAP_IOEND_DIRECT);
+	iomap_init_ioend(iter->inode, bio, file_offset,
+		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
 	bio->bi_end_io = xfs_end_bio;
 	submit_bio(bio);
 }
@@ -724,7 +725,7 @@ xfs_dio_zoned_submit_io(
 
 	bio->bi_end_io = xfs_end_bio;
 	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
-			IOMAP_IOEND_DIRECT);
+		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
 	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 7328e30fb8ad..0959b97e641b 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -406,6 +406,12 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_DIRECT		(1U << 3)
 /* is DONTCACHE I/O */
 #define IOMAP_IOEND_DONTCACHE		(1U << 4)
+/* generate integrity (PI) information */
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+#define IOMAP_IOEND_INTEGRITY		(1U << 5)
+#else
+#define IOMAP_IOEND_INTEGRITY		0
+#endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
@@ -413,7 +419,7 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
 	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
-	 IOMAP_IOEND_DONTCACHE)
+	 IOMAP_IOEND_DONTCACHE | IOMAP_IOEND_INTEGRITY)
 
 /* ioend flags directly implied by iomap flags */
 static inline u16 iomap_ioend_flags(const struct iomap *iomap)
@@ -424,6 +430,9 @@ static inline u16 iomap_ioend_flags(const struct iomap *iomap)
 		flags |= IOMAP_IOEND_UNWRITTEN;
 	if (iomap->flags & IOMAP_F_SHARED)
 		flags |= IOMAP_IOEND_SHARED;
+	if (iomap->flags & IOMAP_F_INTEGRITY)
+		flags |= IOMAP_IOEND_INTEGRITY;
+
 	return flags;
 }
 
-- 
2.54.0

