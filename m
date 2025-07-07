Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8A428FFE6
	for <linux-xfs@vger.kernel.org>; Mon,  7 Jul 2025 12:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751892817; cv=none; b=YLYsMPcwk7Sc0RrzBi4s0uo/4c9LlJGXWVXmfycnHu/aYUz+1u0mXrcYOMa/dMPM+MvmYXaEDIcXfTNK25mUQ2pB4uD1aPbS0p2gpUY9U1RtZxC3ZD5q+DAWpLGhSySNjfLHzuB5MKQPCSvht3M1c+TCgaURYFJlKhks/iukT1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751892817; c=relaxed/simple;
	bh=RRzz/JN+qvHEH9d7DvvOT9hynW2Qcr/bYulfVPVhcWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ek1A2heK56SA3y3jKzScWh0nGWirITejRuNQoFKGiASL93eEYCQWa2H6a8rPmIoAaNE4jpd9upmXhYsWb44BTd2AJq7sxK6Joc6rvnIskqSttFM0FZcQ10Fa3FJeBSuUMxJyz0rZNKU12lPiJhRWMZxY6YpWKJ7ZL9qdNzIJ/rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=di04YUTi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="di04YUTi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pJJfCuphagvDGzUR4nMjkk3ASI70TFR5NjU6lzCOsEE=; b=di04YUTiCAL5FxaQCKX1dz/vrD
	bVFd6n43Zs7gybIutIXNmVB1Bz9qtNGbgr7yBnhLIZtbJo65ulinDiLOdwA52RrMkFOhW2YrhhYvR
	QZvY/syCgppXNeu4/QuHR2lRs+EWYwLUSsxplvOJgeWcWLMlUmIbkImNl8ifTeGlmGlmHtp+nFcKT
	hW5Sz4/jG90j2cob6mnM8cTGnJU474UZLlAnU/2B45nwmCT4Q5vlcbcehx+UbtPpzXsdLTlfuC43h
	BEQNA6XmZ31sk/vxGqsvdVQ4fuZTXgGdF5yZ7sF5cOG8bYEk9XPm81K/iIeyZ0CZ51ier6JJS5b35
	D8CCCZhg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uYlLj-00000002Shr-1Zft;
	Mon, 07 Jul 2025 12:53:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: add a xfs_group_type_buftarg helper
Date: Mon,  7 Jul 2025 14:53:14 +0200
Message-ID: <20250707125323.3022719-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250707125323.3022719-1-hch@lst.de>
References: <20250707125323.3022719-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Generalize the xfs_group_type helper in the discard code to return a buftarg
and move it to xfs_mount.h, and use the result in xfs_dax_notify_dev_failure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c        | 29 +++++++----------------------
 fs/xfs/xfs_mount.h          | 17 +++++++++++++++++
 fs/xfs/xfs_notify_failure.c |  3 +--
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 94d0873bcd62..603d51365645 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -103,24 +103,6 @@ xfs_discard_endio(
 	bio_put(bio);
 }
 
-static inline struct block_device *
-xfs_group_bdev(
-	const struct xfs_group	*xg)
-{
-	struct xfs_mount	*mp = xg->xg_mount;
-
-	switch (xg->xg_type) {
-	case XG_TYPE_AG:
-		return mp->m_ddev_targp->bt_bdev;
-	case XG_TYPE_RTG:
-		return mp->m_rtdev_targp->bt_bdev;
-	default:
-		ASSERT(0);
-		break;
-	}
-	return NULL;
-}
-
 /*
  * Walk the discard list and issue discards on all the busy extents in the
  * list. We plug and chain the bios so that we only need a single completion
@@ -138,11 +120,14 @@ xfs_discard_extents(
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, &extents->extent_list, list) {
-		trace_xfs_discard_extent(busyp->group, busyp->bno,
-				busyp->length);
+		struct xfs_group	*xg = busyp->group;
+		struct xfs_buftarg	*btp =
+			xfs_group_type_buftarg(xg->xg_mount, xg->xg_type);
+
+		trace_xfs_discard_extent(xg, busyp->bno, busyp->length);
 
-		error = __blkdev_issue_discard(xfs_group_bdev(busyp->group),
-				xfs_gbno_to_daddr(busyp->group, busyp->bno),
+		error = __blkdev_issue_discard(btp->bt_bdev,
+				xfs_gbno_to_daddr(xg, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_KERNEL, &bio);
 		if (error && error != -EOPNOTSUPP) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d85084f9f317..97de44c32272 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -802,4 +802,21 @@ static inline void xfs_mod_sb_delalloc(struct xfs_mount *mp, int64_t delta)
 int xfs_set_max_atomic_write_opt(struct xfs_mount *mp,
 		unsigned long long new_max_bytes);
 
+static inline struct xfs_buftarg *
+xfs_group_type_buftarg(
+	struct xfs_mount	*mp,
+	enum xfs_group_type	type)
+{
+	switch (type) {
+	case XG_TYPE_AG:
+		return mp->m_ddev_targp;
+	case XG_TYPE_RTG:
+		return mp->m_rtdev_targp;
+	default:
+		ASSERT(0);
+		break;
+	}
+	return NULL;
+}
+
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 3545dc1d953c..42e9c72b85c0 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -253,8 +253,7 @@ xfs_dax_notify_dev_failure(
 		return -EOPNOTSUPP;
 	}
 
-	error = xfs_dax_translate_range(type == XG_TYPE_RTG ?
-			mp->m_rtdev_targp : mp->m_ddev_targp,
+	error = xfs_dax_translate_range(xfs_group_type_buftarg(mp, type),
 			offset, len, &daddr, &bblen);
 	if (error)
 		return error;
-- 
2.47.2

