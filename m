Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D80F12D754;
	Thu,  7 Mar 2024 15:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824326; cv=none; b=IRLK2hhgwY0K2Chj0TVm1O1OaSg+5WBFfNLGjYcN049cN1BXT503BGz4HrPHoimAUM8wiCpCpfP9p013eMMXBA/pHTE7LZdCduDQd0a7eg4Dn/JtAHQ0uiqX7oaQuGNLMy+Uj6kGR2iLAVR58fiuYYr7xojsCl4LIfOeJu3X1z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824326; c=relaxed/simple;
	bh=34S+Vs1AXtLkKF30u7Kh5py7cvXsPdolDUs25WsCHyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KZA+LR5wNoTdGT/7pD05nSmq2dLzNMkI1F0t2626pWYahQ3FAR4cLLnJXelIv3jmFa/2gitK6lAKJFMGJuaKOxWEw6sc6CQwLOofP2G+TAA7egiuBF1nRevC92RSnj6EVPFpJNWd0HLm0pc7Hethm9IVLwpXN4e4DC/0ZrUfYgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s84SBvaB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s84SBvaB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E17RS1gXdmfEVxJtjtbtf9HhycP12pKLgfmDFXFlsBQ=; b=s84SBvaBVgBPA8Qermc8KbFWr2
	ui8KcScwvmtz3+zxPp8H6BOB/Ogrv/l4LoZXCSm+SlYjvjG25LVlGSmpN1n6/nGAfEMgLjL+94ZDb
	VeXURA6tiAyyeaY5O1r5yq1mZF0oPzfDe3fWnMcvfCfuNgW+em1bhZR4MHTH9ZBcnNJr+zgfw40kb
	w/WQ0rFNDnrb48cL7tndRT+o+Alv81PtA8qctB+23TFaGLT56wIRJlopVKWuA8gJB+Ptz43qP8g1L
	R4vBHnE2qS1O3Sr5IFb/mi6EdlVgMk0Efxgb5PhTAnTUhtOnrTgTpF0Ucvc3kXlDWjrWcGSASXfOe
	fsLdHU+g==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFPf-00000005D8W-46ov;
	Thu, 07 Mar 2024 15:12:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/10] xfs: switch to using blk_next_discard_bio directly
Date: Thu,  7 Mar 2024 08:11:51 -0700
Message-Id: <20240307151157.466013-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240307151157.466013-1-hch@lst.de>
References: <20240307151157.466013-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This fixes fatal signals getting into the way and corrupting the bio
chain and removes the need to handle synchronous errors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c | 47 ++++++++++++++------------------------------
 fs/xfs/xfs_discard.h |  2 +-
 2 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d5787991bb5b46..6396a4e14809a2 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -102,33 +102,26 @@ xfs_discard_endio(
  * list. We plug and chain the bios so that we only need a single completion
  * call to clear all the busy extents once the discards are complete.
  */
-int
+void
 xfs_discard_extents(
 	struct xfs_mount	*mp,
 	struct xfs_busy_extents	*extents)
 {
+	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
 	struct xfs_extent_busy	*busyp;
 	struct bio		*bio = NULL;
 	struct blk_plug		plug;
-	int			error = 0;
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, &extents->extent_list, list) {
+		sector_t sector = XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno);
+		sector_t nr_sects = XFS_FSB_TO_BB(mp, busyp->length);
+
 		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
 					 busyp->length);
-
-		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
-				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
-				XFS_FSB_TO_BB(mp, busyp->length),
-				GFP_NOFS, &bio);
-		if (error && error != -EOPNOTSUPP) {
-			xfs_info(mp,
-	 "discard failed for extent [0x%llx,%u], error %d",
-				 (unsigned long long)busyp->bno,
-				 busyp->length,
-				 error);
-			break;
-		}
+		while (blk_next_discard_bio(bdev, &bio, &sector, &nr_sects,
+				GFP_NOFS))
+			;
 	}
 
 	if (bio) {
@@ -139,11 +132,8 @@ xfs_discard_extents(
 		xfs_discard_endio_work(&extents->endio_work);
 	}
 	blk_finish_plug(&plug);
-
-	return error;
 }
 
-
 static int
 xfs_trim_gather_extents(
 	struct xfs_perag	*pag,
@@ -306,16 +296,14 @@ xfs_trim_extents(
 		.ar_blockcount = pag->pagf_longest,
 		.ar_startblock = NULLAGBLOCK,
 	};
-	int			error = 0;
 
 	do {
 		struct xfs_busy_extents	*extents;
+		int			error;
 
 		extents = kzalloc(sizeof(*extents), GFP_KERNEL);
-		if (!extents) {
-			error = -ENOMEM;
-			break;
-		}
+		if (!extents)
+			return -ENOMEM;
 
 		extents->mount = pag->pag_mount;
 		extents->owner = extents;
@@ -325,7 +313,7 @@ xfs_trim_extents(
 				&tcur, extents, blocks_trimmed);
 		if (error) {
 			kfree(extents);
-			break;
+			return error;
 		}
 
 		/*
@@ -338,17 +326,12 @@ xfs_trim_extents(
 		 * list  after this function call, as it may have been freed by
 		 * the time control returns to us.
 		 */
-		error = xfs_discard_extents(pag->pag_mount, extents);
-		if (error)
-			break;
-
+		xfs_discard_extents(pag->pag_mount, extents);
 		if (xfs_trim_should_stop())
-			break;
-
+			return 0;
 	} while (tcur.ar_blockcount != 0);
 
-	return error;
-
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_discard.h b/fs/xfs/xfs_discard.h
index 2b1a85223a56c6..8c5cc4af6a0787 100644
--- a/fs/xfs/xfs_discard.h
+++ b/fs/xfs/xfs_discard.h
@@ -6,7 +6,7 @@ struct fstrim_range;
 struct xfs_mount;
 struct xfs_busy_extents;
 
-int xfs_discard_extents(struct xfs_mount *mp, struct xfs_busy_extents *busy);
+void xfs_discard_extents(struct xfs_mount *mp, struct xfs_busy_extents *busy);
 int xfs_ioc_trim(struct xfs_mount *mp, struct fstrim_range __user *fstrim);
 
 #endif /* XFS_DISCARD_H */
-- 
2.39.2

