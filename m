Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD1E15E96
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 10:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751366501; cv=none; b=R33HuOoCe03m0H7EPstHUkvZ55bR6XCLyAeL+3VpkFeQ21O7Zq/+B7UCqEVfzgPPIMXsN7FF+1kklorYGUI+joaYbke6DNvbm/FrC2EazoYtvTqiVkDJgVsAI7tkBXgmDab+Aed6DR7jzGexHLCvS0krh+BeOV/20ZGWhOgonMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751366501; c=relaxed/simple;
	bh=cdr5DPn/t+/OrAvP9Xm8rSKpT5htb9hRZlmY8pM87m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6ObHfgiYhsYWs92i1m5ITYPcBSDVEB1yN2ovWUJe66bVZE6EApgk6jLbRsrKelfyGSa8R/85XK6nm6A106RfieK/N6HH+9DwVDdV8d9CjMZfgG7pjnTopj9q0klePtCt6j2bN6zFnjifbSaj9jIe56orieP3ysVE4tIOXCvbbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ki5tifYC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ki5tifYC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Oa+G+B/ayFDCk+eeNMFNO0ntSwfMrwtrtKnkWeaHOFU=; b=Ki5tifYCR0AGzsV8ZpH78nv0Ob
	9D56l1kwSD9BWi8KR6TR2c78m0e/Jjlc5GSRTSSPOV+V/ic2WvGXrt6it92i0++jmEnggYZOitV6v
	Tqh71YeGnJXBnvuMg9wcMHC62aNLaVp1S4elWt3w+XJbORQr9cjXxRX4b28wu82/vPXodKKxv84PN
	KkzFd4+o69sMj3a/8uiFPLsmWiOYF1o1cdWNvjBMWM4fj0Qx7ZnguMbKWd5xkTZv2niho2BUnqTU9
	N3LC6HXPN+z5ZxVRRVAPFZNs02NmgimChSQb38ATRAi1y7fT6qu0kQAA+x/5Ugjg7zZ9kIlmS6l9Q
	PMR2o0fQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uWYQl-00000004lzd-0cDG;
	Tue, 01 Jul 2025 10:41:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] xfs: add a xfs_group_type_buftarg helper
Date: Tue,  1 Jul 2025 12:40:37 +0200
Message-ID: <20250701104125.1681798-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250701104125.1681798-1-hch@lst.de>
References: <20250701104125.1681798-1-hch@lst.de>
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

