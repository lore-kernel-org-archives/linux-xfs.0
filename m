Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7683612C7
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 15:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971949; cv=none; b=W7ZQwrUif6zV++fXSnQ2liSrSoLjKTB6QHNwvE5vHR/bpV1vAZbnHwlFHvrd8Gx41FEd9BxGzR8MHyWF+Q0k7RhrgfMCC2syZgKrMoF0JYbQh7OT2uVUJkyKtYvFSsGw/kdCO5B1/r1xk5wwuKhR5eOIQF0HAlCHhLeFob9kkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971949; c=relaxed/simple;
	bh=pVNX2QUQ4PYy4BE39C9vNo3Xd2yWYG/qfDTnLUZ4mIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEezjaIUy9dq7ZK4m3zvjfKBvr65hsN10QiNAGQo5rp4/bXSQmkNVAJ6WtSdPnP9QYRxJOmPjztwxvgxvu+WmXDYxt+emSe5QffnN3q3We0nZJvzsf3yDccOATWwwNFS2iDv8FTPtrb0jALAIGPN/+xm8j51toKzCtDO4cpkDgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OWpfpCrX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OWpfpCrX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Qibd/5uEqDQxO6mjiNL6CAhcNFpzjbxg488LFmPIiJw=; b=OWpfpCrXotjSXwqzY8TxAcdmPz
	E9vnNB4lgBteYB8i5urUpcgsgOdUczX+bDkr4zwnCz2U9ISuSbgZu/et2kA7uP8aHQ+UY8IwDDfp4
	piTT8eiqMLlWxj/NOHR82Bka1y5F8v5Br2+vZSXRWltVMnZ4PR3bDaVn/1tIS4jZkjQh6kkOVgCt1
	aLi76/BXoVeLp/1ORWJBnnWfR4FJWMGrKbM8GYFxRSN6l6igR2p5x0mIHMNbML2iFIexA6sZXlkBf
	HPDfFUfIEyHxsS6ZSsNgLnRMOeHUn3n+YYaWFAxeZS+QL/gCR/D16PSwuK4AkGmlaT7gPvuddDRc9
	J2mdMu3g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veEGZ-00000002SuZ-2Qyb;
	Fri, 09 Jan 2026 15:19:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: fix an overly long line in xfs_rtgroup_calc_geometry
Date: Fri,  9 Jan 2026 16:18:54 +0100
Message-ID: <20260109151901.2376971-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109151901.2376971-1-hch@lst.de>
References: <20260109151901.2376971-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_rtgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 5a3d0dc6ae1b..be16efaa6925 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -83,7 +83,8 @@ xfs_rtgroup_calc_geometry(
 	xfs_rtbxlen_t		rextents)
 {
 	rtg->rtg_extents = __xfs_rtgroup_extents(mp, rgno, rgcount, rextents);
-	rtg_group(rtg)->xg_block_count = rtg->rtg_extents * mp->m_sb.sb_rextsize;
+	rtg_group(rtg)->xg_block_count =
+		rtg->rtg_extents * mp->m_sb.sb_rextsize;
 	rtg_group(rtg)->xg_min_gbno = xfs_rtgroup_min_block(mp, rgno);
 }
 
-- 
2.47.3

