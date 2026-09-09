Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF57A322C88
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934006; cv=none; b=huSOnrHYskxFmXZeFDAwDizohU3x0S6+ASjnRlJQVB294whLhvqOAMkC+XxNL/+vK3wAfvA6oszeR3jNV6dkcZWxoXmILkqLURTqjY5hioxDwUPJPjYGcknI+mL0k4XVSnTgIylZBqZ4EXK/OvtfDOHSPvNg5QG1xYCsbZ7isXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934006; c=relaxed/simple;
	bh=ttUY8rOmP/wrjtUWH2JotWIxLe0K2lRDuyBE/g1RE6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+GZetN4iZguDsdxwKwN6HKkkt6Mdi0M+P1QV86HC8ZQvgp1xF3apxtJpLpEqGg5NAbmXlU4tEctkyjrZcyols2gJ7HQFusytmF5p03hJAxFXvMcBQUjhl+rFKOq4SE+qYGeksKP/AiiCp1E7lZWK60aHLlQkdSU229NIT/2jMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mUIqjZGT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mUIqjZGT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I/O8tJSa6fSeZuCsvJW63HePV+OMSNxQ0R4EY7xnsF4=; b=mUIqjZGT3teGDYIIhMBjn8jX0F
	ewtxgRcvIDdzLhM/rdFmfbOAwAtEPAOI2vLA7Pn2pvr/5+mAU4GquiH7V5g7XkFJ3zLuV7B1AcQA7
	dlqm4zuPV9d8iPBo0Jq0cpx8EjaNv7Oo/QVECdDbXvhTvWciEPCVKT3Nb3JAlf7KbphJEKZ2+RqpT
	lP43Wh0DGzJTms3J5hgIxwSkCGEh/SxqX2s9IUva4J+Z+gg0ludaow2antzh5d0aEcmOetuYs56Kh
	KWieKGvqJ5cFmgONtrQUX6EHL6/6A7j1gggmtT0zZqG6xRFN4ZxOo5X61td7K/EhkZoSN2/oNe/YD
	kpuqzrkw==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BS7-0000000AqKA-10N5;
	Wed, 09 Sep 2026 06:06:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: convert all !XFS_RT stubs to inline functions
Date: Wed,  9 Sep 2026 09:05:26 +0300
Message-ID: <20260909060619.1101875-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909060619.1101875-1-hch@lst.de>
References: <20260909060619.1101875-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Avoid random compiler warnings about unused variables when CONFIG_XFS_RT
is not set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.h | 49 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 78a690b489ed..1d5108861acd 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -46,10 +46,34 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 int xfs_growfs_check_rtgeom(const struct xfs_mount *mp, xfs_rfsblock_t dblocks,
 		xfs_rfsblock_t rblocks, xfs_agblock_t rextsize);
 #else
-# define xfs_growfs_rt(mp,in)				(-ENOSYS)
-# define xfs_rtalloc_reinit_frextents(m)		(0)
-# define xfs_rtmount_readsb(mp)				(0)
-# define xfs_rtmount_freesb(mp)				((void)0)
+static inline int
+xfs_growfs_rt(
+	struct xfs_mount	*mp,
+	struct xfs_growfs_rt	*in)
+{
+	return -ENOSYS;
+}
+
+static inline int
+xfs_rtalloc_reinit_frextents(
+	struct xfs_mount	*mp)
+{
+	return 0;
+}
+
+static inline int
+xfs_rtmount_readsb(
+	struct xfs_mount	*mp)
+{
+	return 0;
+}
+
+static inline void
+xfs_rtmount_freesb(
+	struct xfs_mount	*mp)
+{
+}
+
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
@@ -60,8 +84,21 @@ xfs_rtmount_init(
 	xfs_warn(mp, "Not built with CONFIG_XFS_RT");
 	return -ENOSYS;
 }
-# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
-# define xfs_rtunmount_inodes(m)
+
+static inline int
+xfs_rtmount_inodes(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_sb.sb_rblocks)
+		return -ENOSYS;
+	return 0;
+}
+
+static inline void
+xfs_rtunmount_inodes(
+	struct xfs_mount	*mp)
+{
+}
 
 static inline int
 xfs_growfs_check_rtgeom(const struct xfs_mount *mp,
-- 
2.53.0

