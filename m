Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8C02AEE1
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185462; cv=none; b=HOMShN1/2tfukXZvXHfBFD4IAysJg6a/2mDSkXtRSmYda8+52GcFxwbC7yQz+HYCEmQG0RW6C5Arybt5MXxEmv4CGOurgtceBzeIwHEMC319oXCTZFVAqRj1c6DmQIqFgBStMsyvk9hXmnDmLDJRKNlb7oBYNkYsubwWtsAbJz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185462; c=relaxed/simple;
	bh=KEw9Jr14l4OJBtsR/Onps0G1iAO5+PHglNpTCuZPzKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfISVPkcazsPtQ2+WnzvdUxVfevGGt7+ltHS4AT7ly6gd5cGIWjGlFcMjfmZCzK89sKDzvknwYG0YXc3JQA0x7ERmIuiKhYyIaP+HpPQvGtgLuGgTkUCJ7liWyiHgUIaOo+cPdj7AlVHOeGR3mtGP7MYVSdTLO+5HvpMGoQc+Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=onN+Dgch; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="onN+Dgch"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oAjPs0RUrRzMHCS/ukGDw0Up+3dQrYdhIvlaQky8hBQ=; b=onN+DgchbiDSmk/laldWj21oZn
	xGl4bq2HxAqEwayCq59nF7pncyyp8k++tm1j7DlMOlspoN9fj6FJA/Y2z3KGRj/zdsWzL1SWoX/AZ
	RUGoRpMhgFvVTu0HmwVtYgcgNQgusD4ErOX1tmN/4DjYoLgpHbOluslOUvDAs82CQP8OWhuAn8mcJ
	FaOKon6g7UhotWRa46EZXmHU9eN84ysyRaYZc+D6N3TL53M9EsiSwLBmQ3zyqSLa2DjuFPhsmnTsZ
	o2bMuz90gqy5WGQMz+P1deGYgUS9fPA2mFJG5jUWJkeys+GjVRon041FpHFueiIOOsrjBv9yKeiMx
	bNn7jFXQ==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QJY-00000006UaU-27D6;
	Wed, 09 Apr 2025 07:57:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 25/45] FIXUP: xfs: support zone gaps
Date: Wed,  9 Apr 2025 09:55:28 +0200
Message-ID: <20250409075557.3535745-26-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/convert.c        | 6 +++++-
 include/xfs_mount.h | 9 +++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/db/convert.c b/db/convert.c
index 47d3e86fdc4e..3eec4f224f51 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -44,10 +44,14 @@ xfs_daddr_to_rgno(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		daddr)
 {
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+
 	if (!xfs_has_rtgroups(mp))
 		return 0;
 
-	return XFS_BB_TO_FSBT(mp, daddr) / mp->m_groups[XG_TYPE_RTG].blocks;
+	if (g->has_daddr_gaps)
+		return XFS_BB_TO_FSBT(mp, daddr) / (1 << g->blklog);
+	return XFS_BB_TO_FSBT(mp, daddr) / g->blocks;
 }
 
 typedef enum {
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index bf9ebc25fc79..5a714333c16e 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -47,6 +47,15 @@ struct xfs_groups {
 	 */
 	uint8_t			blklog;
 
+	/*
+	 * Zoned devices can have gaps beyoned the usable capacity of a zone
+	 * and the end in the LBA/daddr address space.  In other words, the
+	 * hardware equivalent to the RT groups already takes care of the power
+	 * of 2 alignment for us.  In this case the sparse FSB/RTB address space
+	 * maps 1:1 to the device address space.
+	 */
+	bool			has_daddr_gaps;
+
 	/*
 	 * Mask to extract the group-relative block number from a FSB.
 	 * For a pre-rtgroups filesystem we pretend to have one very large
-- 
2.47.2

