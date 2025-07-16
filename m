Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5888341AA
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670462; cv=none; b=DnLcL4/1cDnoXxY1BeLdhkBIXp/VTITrwU24K3c5lney/wm3GEQtdejRC7XIoX3Q1JtBnVjcO1N16RjZhg/eenn2TCy7mEO88qE4Lj7SKl7fjCLhSpGaoexRA5jFC5DR4vPFfe5jx6c981F0Jd2kjIgMRvC1a2OdPA/fnpdIaew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670462; c=relaxed/simple;
	bh=+5IM2B0tK/d7qnoILpbbEoCvaUzH7AeMWwvLueG1YuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oy3Ezfpxsxp8VoxTw07mCUJEXxg8PN/ldfAFidzaQoWtxx+sAoCuD5GdV0nKFxe8V82TLb+kRWGAwueHACRFHH3UmUE0xvqXNdnCBfkHgldWnALNHUtCHtu4TNKRneQAk730V2u/lRvjAqEXzBWI4QoPmTR7vaofdPqezQgSV2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ciTK6/1N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ciTK6/1N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3cyIL7XOxPToicJ8Pb4PIeUBoKNeIWxUOw4EiZiQBXo=; b=ciTK6/1NWJ+4m0n9vRdRs4n2wg
	yuUGuH72cnfPcZO68lWfmAVJYRooA9SKL0z0AD7FxqIidInwbhJkGBT8HkDufTRa+Q73z0ALgY2Ls
	N3XUdZwsRloKCxTDirCRkFMm8iXdV9Jc/rRiQuyohk39YxhgWEDLBkrak25fgo0KhHgfSCm9ofq6o
	bT9MzyeEuQ6DVTPzDT6IHXgwqYvr1lSvjuMMjYBDtH0bmSj21F1k0rop8H5IJ20Gl19LxOueQgiYH
	VlbQB3WcgOZVmbMftUF2qbHnjfcAXcl9JIe4X8yKTyWD6/XPNOUNCPNW7LI17TNwa1GeLQs8soj8v
	uaP3vxmA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1eN-00000007iMZ-3dh6;
	Wed, 16 Jul 2025 12:54:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] xfs: don't allocate the xfs_extent_busy structure for zoned RTGs
Date: Wed, 16 Jul 2025 14:54:01 +0200
Message-ID: <20250716125413.2148420-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716125413.2148420-1-hch@lst.de>
References: <20250716125413.2148420-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Busy extent tracking is primarily used to ensure that freed blocks are
not reused for data allocations before the transaction that deleted them
has been committed to stable storage, and secondarily to drive online
discard.  None of the use cases applies to zoned RTGs, as the zoned
allocator can't overwrite blocks before resetting the zone, which already
flushes out all transactions touching the RTGs.

So the busy extent tracking is not needed for zoned RTGs, and also not
called for zoned RTGs.  But somehow the code to skip allocating and
freeing the structure got lost during the zoned XFS upstreaming process.
This not only causes these structures to unessecarily allocated, but can
also lead to memory leaks as the xg_busy_extents pointer in the
xfs_group structure is overlayed with the pointer for the linked list
of to be reset zones.

Stop allocating and freeing the structure to not pointlessly allocate
memory which is then leaked when the zone is reset.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_group.c | 14 +++++++++-----
 fs/xfs/xfs_extent_busy.h  |  8 ++++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index e9d76bcdc820..20ad7c309489 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -163,7 +163,8 @@ xfs_group_free(
 
 	xfs_defer_drain_free(&xg->xg_intents_drain);
 #ifdef __KERNEL__
-	kfree(xg->xg_busy_extents);
+	if (xfs_group_has_extent_busy(xg->xg_mount, xg->xg_type))
+		kfree(xg->xg_busy_extents);
 #endif
 
 	if (uninit)
@@ -189,9 +190,11 @@ xfs_group_insert(
 	xg->xg_type = type;
 
 #ifdef __KERNEL__
-	xg->xg_busy_extents = xfs_extent_busy_alloc();
-	if (!xg->xg_busy_extents)
-		return -ENOMEM;
+	if (xfs_group_has_extent_busy(mp, type)) {
+		xg->xg_busy_extents = xfs_extent_busy_alloc();
+		if (!xg->xg_busy_extents)
+			return -ENOMEM;
+	}
 	spin_lock_init(&xg->xg_state_lock);
 	xfs_hooks_init(&xg->xg_rmap_update_hooks);
 #endif
@@ -210,7 +213,8 @@ xfs_group_insert(
 out_drain:
 	xfs_defer_drain_free(&xg->xg_intents_drain);
 #ifdef __KERNEL__
-	kfree(xg->xg_busy_extents);
+	if (xfs_group_has_extent_busy(xg->xg_mount, xg->xg_type))
+		kfree(xg->xg_busy_extents);
 #endif
 	return error;
 }
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index f069b04e8ea1..3e6e019b6146 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -68,4 +68,12 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
 	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
 }
 
+/*
+ * Zoned RTGs don't need to track busy extents, as the actual block freeing only
+ * happens by a zone reset, which forces out all transactions that touched the
+ * to be reset zone first.
+ */
+#define xfs_group_has_extent_busy(mp, type) \
+	((type) == XG_TYPE_AG || !xfs_has_zoned((mp)))
+
 #endif /* __XFS_EXTENT_BUSY_H__ */
-- 
2.47.2

