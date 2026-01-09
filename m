Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A151D5141
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971947; cv=none; b=sSpdCaFcE3zhBCUTEKUeaA1+yHEcUgCQAfoFF3Aji1Xt8xfHrYAjDnlJQKnTgZXZkuAxCHNOluJlzgo5ykG4pn9PZfeyDL0HAljjUKIu7uKhPim8Dd7SNf6XEA8kQ0Urx1nL2IjUwY/xLTSnLJVhVvi6zH+vex7atGNmjGxi7QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971947; c=relaxed/simple;
	bh=yjVf02dV11CfzajCi7SesbK0JFFoa0Vy4RuNLx8kAkE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WfkLRlDwyhQ6oDZIW1L4ruxx1jIlHjSwB+vVXnAHdsLLMO863WTY/9WR4WjO0Gr7XxUa3P2JL1sPOceAVvZMID5Dw0z7Bafb4XLAjGqgtF0j3NRcgERc1hdLv38Vav2E/KhFObQcqUz41OwcDd3hItbPKOf0MKfMoPegCXkyD/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EO+sRI3e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EO+sRI3e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=8N4RLVEgCQo8L8bIhQDur5t8vyN56vgPSEx/Cj9autk=; b=EO+sRI3eHDZZLTVaSUTwQpx+CM
	We+SPUIh1rd/PtM+Sr3f+iLxj2dR8fG0k2IDBdn4fukHxs60MRI5919WyFWpqemZGtixo6Xq+munY
	Faj+QmR1ZI1QWKvJyJ1hm6zeU9NVRGj8tw5AV1Oamx2V4dbcLSBJuuBiQsH6mi4uoKwtKOK7Kb/Yg
	OHbZmvUBptWGjRsh0LoK3OZfCXDZa39nqsMwntoX94VkQbhwjdjy/MT+GKVTCSB6/+MmynM2mDUdJ
	ljzQLTkH8tNevmReB/t3hzf89xweoYWSoPUtGT9wkihH6t+uJhPFAQ/HyDj8lwrKqS6TBDC09wDZM
	RMh7vabQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veEGW-00000002SuQ-3gsu;
	Fri, 09 Jan 2026 15:19:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: mark __xfs_rtgroup_extents static
Date: Fri,  9 Jan 2026 16:18:53 +0100
Message-ID: <20260109151901.2376971-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

__xfs_rtgroup_extents is not used outside of xfs_rtgroup.c, so mark it
static.  Move it and xfs_rtgroup_extents up in the file to avoid forward
declarations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c | 50 ++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_rtgroup.h |  2 --
 2 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 9186c58e83d5..5a3d0dc6ae1b 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -48,6 +48,31 @@ xfs_rtgroup_min_block(
 	return 0;
 }
 
+/* Compute the number of rt extents in this realtime group. */
+static xfs_rtxnum_t
+__xfs_rtgroup_extents(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	xfs_rgnumber_t		rgcount,
+	xfs_rtbxlen_t		rextents)
+{
+	ASSERT(rgno < rgcount);
+	if (rgno == rgcount - 1)
+		return rextents - ((xfs_rtxnum_t)rgno * mp->m_sb.sb_rgextents);
+
+	ASSERT(xfs_has_rtgroups(mp));
+	return mp->m_sb.sb_rgextents;
+}
+
+xfs_rtxnum_t
+xfs_rtgroup_extents(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	return __xfs_rtgroup_extents(mp, rgno, mp->m_sb.sb_rgcount,
+			mp->m_sb.sb_rextents);
+}
+
 /* Precompute this group's geometry */
 void
 xfs_rtgroup_calc_geometry(
@@ -136,31 +161,6 @@ xfs_initialize_rtgroups(
 	return error;
 }
 
-/* Compute the number of rt extents in this realtime group. */
-xfs_rtxnum_t
-__xfs_rtgroup_extents(
-	struct xfs_mount	*mp,
-	xfs_rgnumber_t		rgno,
-	xfs_rgnumber_t		rgcount,
-	xfs_rtbxlen_t		rextents)
-{
-	ASSERT(rgno < rgcount);
-	if (rgno == rgcount - 1)
-		return rextents - ((xfs_rtxnum_t)rgno * mp->m_sb.sb_rgextents);
-
-	ASSERT(xfs_has_rtgroups(mp));
-	return mp->m_sb.sb_rgextents;
-}
-
-xfs_rtxnum_t
-xfs_rtgroup_extents(
-	struct xfs_mount	*mp,
-	xfs_rgnumber_t		rgno)
-{
-	return __xfs_rtgroup_extents(mp, rgno, mp->m_sb.sb_rgcount,
-			mp->m_sb.sb_rextents);
-}
-
 /*
  * Update the rt extent count of the previous tail rtgroup if it changed during
  * recovery (i.e. recovery of a growfs).
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 03f1e2493334..73cace4d25c7 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -285,8 +285,6 @@ void xfs_free_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
 int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
 		xfs_rgnumber_t end_rgno, xfs_rtbxlen_t rextents);
 
-xfs_rtxnum_t __xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno,
-		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
 xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
 void xfs_rtgroup_calc_geometry(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
 		xfs_rgnumber_t rgno, xfs_rgnumber_t rgcount,
-- 
2.47.3

