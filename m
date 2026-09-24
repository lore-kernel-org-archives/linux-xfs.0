Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2793BE627
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244365; cv=none; b=GIOUf31pm4fLcoUi6IXbpa6bPDbYKV9yJG2MpkFdyB1goXNZzXGWmUSsCW0salCVDT94egXIdkiEOp3/RAF9J1Cc+fuwIb2rxhg+yu/iP/KD03SeX+060IsNx2bvfQoQ28+mlll+B+Xe6i/HxXWkLvTh2/PgNDu6/Q4xeej3V94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244365; c=relaxed/simple;
	bh=D8U6pvQ2P8l2XOrxhZTOXoJQqH2RU0KyC79G9pr3wUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOK+m57kscAVnl9dXf87N7Ogpj2bV7/dm9Pv/AsiRQtusjVE5ywiB9riZmG7Ao/Z9FcIwlwIf27l69HJg9q4fl4QKy3GSaj8XmdgqeyTv76EzX5fEKM4StQoh0/ngeKOY8E2ESJ717rmX/W3v0FXWORHf9ZupOos/k/IHY1iiIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=36B0FE/b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="36B0FE/b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QaIgezNaOF947QznQl4sK7pFaZdDYI1xhDkEOP9KLnI=; b=36B0FE/bhnymKd3MYUzUqHvmWp
	9aePQ0gF53ZLRpk9AH+kg8AmROb7Konp14gTvZodgToOj8GRgOXxh7MtaS9Y585cgjSG8RVSuNKRL
	uCNHcKcXcM/z2qI/qYv02s9LHhIpowNKkIakxh4x4hgSGUTxK/rgY7f1THcLm+hiDGpWK6mh2Lx/j
	6zs2nwIGE612IHn5HQ8IqaK+M5PfXTAb+cMQjBa/eOB60KdEQpI4pCyhYZ7cHeAsSCW4o0NIZ5B1E
	usOKyepVQEblQMMOEmjc3335ehB7RKLNSzyb0YA2OAiGtGAG1w6FhybPRJS5Pnr0IY4Ak7meI5Kix
	fLW+I28w==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKx-0000000AfHr-1WA9;
	Thu, 24 Sep 2026 10:05:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/32] xfs: add xfs_daddr_to_rgno and xfs_daddr_to_rgbno helpers
Date: Thu, 24 Sep 2026 12:04:01 +0200
Message-ID: <20260924100512.2733748-12-hch@lst.de>
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

Source kernel commit: 128ec674f28f15b8c4697e45a5446c545b1e6f36

Translate from a disk address to the realtime group and group-relative
block numbers.  This will be needed by the data checksumming code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtgroup.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index c0b9f9f2c413..2aa6d4e59cc3 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -386,4 +386,24 @@ xfs_rtgroup_raw_size(
 	return g->blocks;
 }
 
+static inline xfs_rgnumber_t
+xfs_daddr_to_rgno(struct xfs_mount *mp, xfs_daddr_t d)
+{
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	xfs_rfsblock_t		rbno = XFS_BB_TO_FSBT(mp, d) - g->start_fsb;
+
+	ASSERT(xfs_has_rtgroups(mp));
+	return div_u64(rbno, xfs_rtgroup_raw_size(mp));
+}
+
+static inline xfs_rgblock_t
+xfs_daddr_to_rgbno(struct xfs_mount *mp, xfs_daddr_t d)
+{
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	xfs_rfsblock_t		rbno = XFS_BB_TO_FSBT(mp, d) - g->start_fsb;
+
+	ASSERT(xfs_has_rtgroups(mp));
+	return do_div(rbno, xfs_rtgroup_raw_size(mp));
+}
+
 #endif /* __LIBXFS_RTGROUP_H */
-- 
2.53.0

