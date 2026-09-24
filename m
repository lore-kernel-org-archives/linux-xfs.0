Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBEF4248B2
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244381; cv=none; b=etq7qgVBgl5r1sOKQiVFgSeqGZrh3t6U4MJ0eEelt8r+mkfw//YVuuFq643geWQFroMatCLutHkIl700lBy149dVfLAJqMAAk4Aizl2TdMpGlr/q0RiXXs+MEiFfOhXhDezYW4NNqA0ShpWF3XlWrsIcdspBTY6TeS1jordSC8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244381; c=relaxed/simple;
	bh=KN9uGhswQWT+8lRS7SJ5ZkOg6yeeOr/ZxHNMre+dOek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8Fuku2rxD/d6P3xXizw/jbmWzCsTN6z74Dw7ib0pb0uEPTYeZciuYUdUdWB0uiwkGyunlspnimO/+BjtwJ9RgC4EV9WYwAHujCgRbNWj/ukXJFbAsVBqR3O6wWnv+Ad9mUCZqRhdkwSJFYbNP01uAAwkfqZ4mCZkFZBI/Jdup0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TknblMTP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TknblMTP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KpS5OAfiRPzkBur2QBKIcGJGdyp9p7EKyhyjRJNmtDc=; b=TknblMTPSbQ3lsIL7vdBU1qBMa
	NGEcN7m+GQYk1OhwesfQsKWttHThSKwvuJP1B55ifdP+kpELDhRsJpoH9op1Gpxmuyplw+jbqBM0t
	TBKEmLKsJI9qmUOzgq4bezMd3sgAAnAdEkXd1AOUa7gVo21voE8SK6laGt0wATbJFGR2pA5XwaMZW
	TGbAZLvcy+oeTFJFT7TQXCldS7zaZ9mQAADpuoY/Okcg9W3LCfaYJbUAJ1Kz9Qn7ZaY1UU0JZKy3Q
	f2HTWEkcvAbmPwoQzNT5fFQk2l7wWhsM8FXH/diARsubwBU5Mz4ydK1TlTomwhDZ165D1TUVgK8P7
	2mr2jndQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gLC-0000000AfKx-3zj6;
	Thu, 24 Sep 2026 10:06:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 15/32] xfs: factor out a xfs_rtfile_initialize_buf helper
Date: Thu, 24 Sep 2026 12:04:05 +0200
Message-ID: <20260924100512.2733748-16-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: eb8ab10dddf6e7fbfe602f827f98afe9723e5384

Share the code to initialize the header and buf ops for rtfile blocks
into a single helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.c | 38 ++++++++++++++++++++++++--------------
 libxfs/xfs_rtbitmap.h |  3 +++
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index dda6ef84aeac..245cdd9c22ca 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1375,6 +1375,27 @@ out_trans_cancel:
 	return error;
 }
 
+void
+xfs_rtfile_initialize_buf(
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type,
+	struct xfs_buf		*bp,
+	struct xfs_trans	*tp)
+{
+	bp->b_ops = xfs_rtblock_ops(bp->b_mount, type);
+	if (tp)
+		xfs_trans_buf_set_type(tp, bp, xfs_rtblock_buf_types[type]);
+	if (xfs_has_rtgroups(bp->b_mount)) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		hdr->rt_magic = bp->b_ops->magic[1];
+		hdr->rt_owner = cpu_to_be64(I_INO(rtg->rtg_inodes[type]));
+		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
+		hdr->rt_lsn = 0;
+		uuid_copy(&hdr->rt_uuid, &bp->b_mount->m_sb.sb_meta_uuid);
+	}
+}
+
 /* Get a buffer for the block. */
 static int
 xfs_rtfile_initialize_block(
@@ -1405,21 +1426,10 @@ xfs_rtfile_initialize_block(
 	}
 	bufdata = bp->b_addr;
 
-	xfs_trans_buf_set_type(tp, bp, xfs_rtblock_buf_types[type]);
-	bp->b_ops = xfs_rtblock_ops(mp, type);
-
-	if (xfs_has_rtgroups(mp)) {
-		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
-
-		hdr->rt_magic = bp->b_ops->magic[1];
-		hdr->rt_owner = cpu_to_be64(I_INO(ip));
-		hdr->rt_blkno = cpu_to_be64(XFS_FSB_TO_DADDR(mp, fsbno));
-		hdr->rt_lsn = 0;
-		uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);
-
-		bufdata += sizeof(*hdr);
-	}
+	xfs_rtfile_initialize_buf(rtg, type, bp, tp);
 
+	if (xfs_has_rtgroups(mp))
+		bufdata += sizeof(struct xfs_rtbuf_blkinfo);
 	if (data)
 		memcpy(bufdata, data, copylen);
 	else
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 375cc48e1a53..4a87e1fd3e99 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -408,6 +408,9 @@ xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 
 const struct xfs_buf_ops *xfs_rtblock_ops(struct xfs_mount *mp,
 		enum xfs_rtg_inodes type);
+void xfs_rtfile_initialize_buf(struct xfs_rtgroup *rtg,
+		enum xfs_rtg_inodes type, struct xfs_buf *bp,
+		struct xfs_trans *tp);
 int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
 		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t end_fsb, void *data);
-- 
2.53.0

