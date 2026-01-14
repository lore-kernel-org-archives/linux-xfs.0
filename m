Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99610368264
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 06:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768373644; cv=none; b=KJiKzMsAEZsK067Yu5ZtidvjBWjh9OSBbRfyKWszgFy4QCKStiSs6KqEfUEDUgtnwiVWkojp1oP1ajwSxUu15rmUHsL2t5052rlrtvvCSgnAHbj0mAI0auJCI1U4ydsekQsuR56dURiJMG5gJZGnB2O1iQM1Ll1z1SJQwOWfA/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768373644; c=relaxed/simple;
	bh=dwCPuovAlxhiurDhpEVVW5vP96DxmK9g5nbiL+q1EGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkgkRGeOqieYk95UD+1N7LM7QEaOWrU2O5ywlAlEyBq5ZWvVJ5zZhHP/Kld3+Imp+jHtoxpCZ5yeFzn+hiLeeAWKhHgYev/EZrd4KkK0Ap4pc6WxFS8zb4EVl1wyZB6Jak2hwRinWMKUhdXvyzQovv0ZDLIZKp3r1k7+b5RbjTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xAWkU1Cy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xAWkU1Cy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MkhU8I+Jb0r9et8izHhCVYyUzXeCdyXR+au2IclXKq8=; b=xAWkU1CyswGemMHNF281bl5g/g
	D1jPIS1CJyp42p3DSmpdzRkvvFsFwis7KLsMd2XOYHUkaTPw2xdQ2kJbwfsZm51gXQVAGGgxTxfsP
	J2rDTjL3MCuafgx6ERVXcNFG/MZ4rGRzl90YP6pLUxHRpeMpW3wEt559O91wjZB0rnCFT0yQSuIz7
	B/s1/j3PtPBhSoms4jQ06/vf455Ja7ic3iQ4dQukzejzQ8gOGhjukB0VlRU0iChiWKgfcQyYr0eBq
	fkm2njsfeFnrKdwnZ/wJGIohZf0cxAgghIpHRiLaQq8qew5aNkXHfHGcTNYp03S4FnLye9KTPAnAf
	5P3jctTg==;
Received: from 85-127-106-146.dsl.dynamic.surfer.at ([85.127.106.146] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfulK-000000089hF-1hmy;
	Wed, 14 Jan 2026 06:53:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: add a xfs_rtgroup_raw_size helper
Date: Wed, 14 Jan 2026 07:53:25 +0100
Message-ID: <20260114065339.3392929-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114065339.3392929-1-hch@lst.de>
References: <20260114065339.3392929-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to figure the on-disk size of a group, accounting for the
XFS_SB_FEAT_INCOMPAT_ZONE_GAPS feature if needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 73cace4d25c7..c0b9f9f2c413 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -371,4 +371,19 @@ xfs_rtgs_to_rfsbs(
 	return xfs_groups_to_rfsbs(mp, nr_groups, XG_TYPE_RTG);
 }
 
+/*
+ * Return the "raw" size of a group on the hardware device.  This includes the
+ * daddr gaps present for XFS_SB_FEAT_INCOMPAT_ZONE_GAPS file systems.
+ */
+static inline xfs_rgblock_t
+xfs_rtgroup_raw_size(
+	struct xfs_mount	*mp)
+{
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+
+	if (g->has_daddr_gaps)
+		return 1U << g->blklog;
+	return g->blocks;
+}
+
 #endif /* __LIBXFS_RTGROUP_H */
-- 
2.47.3

