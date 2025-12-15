Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A967432ABF1
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 09:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792137; cv=none; b=hJa+8HJzNnkzIC1UMPa9e3tQFa4SLB5W8qBX/+yqkOWr5G+hQnhtLSzf2c8K7bfRz8mfix0S5hoai86gIeY/CaRmjR85fAtcFntmOnu2wUg9s4ogUhgxoSgvMKVqVSneDUv2J2E2QzLfzoMxHP/7opEHU5i6ZG5S9bWXRizujYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792137; c=relaxed/simple;
	bh=Z0eWoncCwHAV99hv/RdNln04Ifki9KoTIcRwnVZrdZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpmIszqSR2hTwEooz3HFOqi+mSwsAQ/zBcAmxTy139jbUQq1l3pjkH7IczW+dgvMLHV5d69m5v6bj8J5ObwJBxSliqmi7YXs8H5cmHk+Fo/+8kzFGwsWKLJV5V4k78RORAwlJnfBSt+dxfKd4jNZnsGRIoti0gGs3BSED0JW5gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qy/eUl41; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qy/eUl41"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AEr4LrrbgzIDX4ND/4Qn/8FlcL/sJspQ6xVX4SgAn7s=; b=Qy/eUl41MbbiZFDsH/Kpnx643/
	EqfeGcZWAKdJi4U78tGCsh/Y4ZzdwDMqhG1IZfr68HdxDJE2HcdkP/NOUSdVkN7wjj8Hnggv9ZNgF
	jKmIx+7yXjfXvAi2DwUjwdbHlftX2ZiYZUC5po/6f7IPFGZh2e/7cxPZfIaxE/Z5s+ANOQhH799J2
	+6q8fEGliZA7nTrQhViXzTa9GelPJPhHEv/5sWl1dh70WVrEyx+yHqrn8aspB1DmivVPELvnr0oC7
	JJlCY2ng6mbiujPkqAfeWHbyiEYsgzlle/u2goaiQrDhAr9EavpwbTZnjgjQ/mxhQFD0H5bi6cLF9
	AUnpte3w==;
Received: from [2001:4bb8:2d3:f4f4:dcee:db:50a:ae71] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV5CG-00000003Okm-2FKz;
	Mon, 15 Dec 2025 09:48:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: validate that zoned RT devices are zone aligned
Date: Mon, 15 Dec 2025 10:48:36 +0100
Message-ID: <20251215094843.537721-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251215094843.537721-1-hch@lst.de>
References: <20251215094843.537721-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Garbage collection assumes all zones contain the full amount of blocks.
Mkfs already ensures this happens, but make the kernel check it as well
to avoid getting into trouble due to fuzzers or mkfs bugs.

Fixes: 2167eaabe2fa ("xfs: define the zoned on-disk format")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index cdd16dd805d7..db5231f846ea 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -301,6 +301,19 @@ xfs_validate_rt_geometry(
 	    sbp->sb_rbmblocks != xfs_expected_rbmblocks(sbp))
 		return false;
 
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
+		uint32_t		mod;
+
+		/*
+		 * Zoned RT devices must be aligned to the rtgroup size, because
+		 * garbage collection can't deal with rump RT groups.
+		 */
+		div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
+		if (mod)
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.47.3

