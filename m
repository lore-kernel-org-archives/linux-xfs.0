Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3749389106
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780991829; cv=none; b=jEsrTvSldMrlPJvJUxTS53hHlhgircC5RCpATN3qL5DlM5FyYP0KE0qm3dKUE1vea8Nbfb2sd4gm10gnKCWLraCf6Dj2RqXGiSQiP/yTQVq4Ls+05CwVnkOxXufCndG+CYJpvqlH2yg0cESHg9p+KztZ+K2VoTIKzSReRXC1kQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780991829; c=relaxed/simple;
	bh=/TK3ZTsH4FtS7pAqkq2nfI3qeTnPmcD/8UzMFrwFv6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwA/ZEl1U8dwHYANb8wAp6c8C4TixAKuI1LSeOYOxknuonXGOcuLGhYqS4myJyjHW2+VkZjFcE0mtu8WdKeetOrUY7m7GzxeKlBKv3IQV7H6PpRt0g2DoV7LknlOTDmXkLAACEXGNtjapOxrK6663DK+gC/WfmG+iCww9z9tHU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YOMhZM3K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YOMhZM3K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I/QNtNaJUKFI2D42sEpgYQ0+flLERXSlYVaW2jE1sBU=; b=YOMhZM3KMHJ/f0SMV4t6nChBqN
	CaiJaMaMN+0ak8CCDlmqH63IYdzCDQXQ8g4LtUvTMORJKTe2aXsVd0iXXGZ3kHcRgSzltRi+WqHgM
	stmw6P0Pwi9Q75lByoIvATY+LColHUSgk/hkGTRvyZtCZvhHqSrS2ozmU43OQTGCoDRn6WL1/E7sp
	++srNCvsEdqPhsGMQmM4wsgJ0aLqjipUrn3YmBj0zwTjvcmPfitdPNuVbHA6ng89P7J0M/TiAmljx
	CNNV5nsWsA8i2G7D73GrcPvmUatIZxcCLKDtP01ooKbZhI4SC2gP/LZdN0feh4wOLvftE30g8LWOD
	+4I/gvBg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWrKe-0000000510o-0hqs;
	Tue, 09 Jun 2026 07:57:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: only log freed extents for the current RTG in zoned growfs
Date: Tue,  9 Jun 2026 09:56:43 +0200
Message-ID: <20260609075655.1698743-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260609075655.1698743-1-hch@lst.de>
References: <20260609075655.1698743-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Otherwise a power fail or crash during growfs could lead to an
elevated sb_rblocks counter.

Note that the step function is much simpler compared to the classic RT
allocator, as zoned RT sections must be allocated to zone and thus
realtime group boundaries, and also because the rtextsize is fixed to a
single FSB.

Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index fd07c1a18615..728f444fbc30 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -890,8 +890,7 @@ xfs_growfs_rt_sb_fields(
 
 static int
 xfs_growfs_rt_zoned(
-	struct xfs_rtgroup	*rtg,
-	xfs_rfsblock_t		nrblocks)
+	struct xfs_rtgroup	*rtg)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_mount	*nmp;
@@ -903,7 +902,8 @@ xfs_growfs_rt_zoned(
 	 * Calculate new sb and mount fields for this round.  Also ensure the
 	 * rtg_extents value is uptodate as the rtbitmap code relies on it.
 	 */
-	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks,
+	nmp = xfs_growfs_rt_alloc_fake_mount(mp,
+			mp->m_sb.sb_rgextents * (rtg_rgno(rtg) + 1),
 			mp->m_sb.sb_rextsize);
 	if (!nmp)
 		return -ENOMEM;
@@ -1219,7 +1219,7 @@ xfs_growfs_rtg(
 	}
 
 	if (xfs_has_zoned(mp)) {
-		error = xfs_growfs_rt_zoned(rtg, nrblocks);
+		error = xfs_growfs_rt_zoned(rtg);
 		goto out_rele;
 	}
 
-- 
2.53.0

