Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AED9368274
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767979312; cv=none; b=Zd9RMZzH1WS5RWjFOIVvMGlpfuvheJgUP1HTKh0VeR4s6DgqNL5MqCuHc8CkDbW0swRhJN4lcy/tNhYR0NYN4SewPLyFA0hbSzKgC5GgQKEOc7vTFjlc9zCZYZvXqsZ4IhWdmpyboYlmyl93GrwBs5CIcYjvkoBqqpvcsMa2/Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767979312; c=relaxed/simple;
	bh=keV+onoSpF8niQb+ve88YAtai/HyqX4iSWvSXT7hM5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7UZ3fZEYqcUKNFeImZt6X8ASnDPW+TctwBhSvnumX3h8EJtOgaHO7u7XEWrPqfoRHazDHUFa5FtUmUgHk2v/Lsw/y/g5cZdwFuOun+RlrLhfTdfU4LoweTcWJ383ZmMVs9GvEtlQxWTcnGq2FhOh5JzMbJhfouqOc3BKGvmcH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3xMQaKSY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3xMQaKSY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SZIDBWXm+VkHNyEO3YgQW8Xtjdqw+QEfgJMjvkIAsHg=; b=3xMQaKSYPZkkwIGoaksMZ6fd3o
	ts5c7ReQfS3xsBJAZbWIrqy4EoVyEPmriiZkgbjdUYJWWPAflzSbKXFB5gDDH69FGRkbWYp2E5JmE
	HZRLjm0L+5j1JhPPlHqu/nhp0ylBDCBNFQeYm6oHPx6Ibfq9FWDhFlh8/HRx7rqwZGc9G7//m+7Kc
	EAJimFgMgdpG/WVn1hHmP+9Y3xxXuTzhrAAfkc/XXw2vvndIaI6lyBYCCqgruAs+amvG1VrsUvHNT
	B0t5HAnJEBKHMPq/hE+gXo19uCG5C2NCVujVTIM+NhS3rObZADLc/0J0yR1bO48AEmJ++PmW9u4h2
	CZZdsD7g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veGBI-00000002nYH-1FRc;
	Fri, 09 Jan 2026 17:21:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: add a xfs_rtgroup_raw_size helper
Date: Fri,  9 Jan 2026 18:20:47 +0100
Message-ID: <20260109172139.2410399-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109172139.2410399-1-hch@lst.de>
References: <20260109172139.2410399-1-hch@lst.de>
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

