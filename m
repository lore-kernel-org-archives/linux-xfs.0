Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF16C2147F9
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 14:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765376594; cv=none; b=PKJGY2kYmdh+lY0jHfXS5U5l1qyKpbqo/TLB/OeAW/5XJ58Rvz1FqD7elF0BXYRuz7Q0NmQxrJJYP6Rx+JMluXlSErY7I0vBVSTJAlGVM1Q4xCd4m9r78lWiiWj0Wms8FLnc1yY/jfC0tYa7ki2MSc0HEX6zFgB7NFTAG1UucFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765376594; c=relaxed/simple;
	bh=Z0eWoncCwHAV99hv/RdNln04Ifki9KoTIcRwnVZrdZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SGxzEvfbu29pISoa7OXgPZASBX/bRcXy3nIPDNFA8FCABKSl89cxjGX9AmMLM/XmPWFNP30peGypkQbCpTxIebnFJBogCbNF5+2DjzzcxhyzJeEBd8sHOw1UyuSAsSRKv8qtPQnbmOYk8A/2znqRAatDXrBxZXaAOU7juVFUCAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eBEM0rLq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eBEM0rLq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=AEr4LrrbgzIDX4ND/4Qn/8FlcL/sJspQ6xVX4SgAn7s=; b=eBEM0rLq+qo4Yy4ublBvo4UDOY
	w0P1/EWo941esxjM6tIUToTYJ7BbV5Dkfoz/y+ue/SpuhqvxrgDSLTpumOFpeQCfQCXQ82BHYtvxc
	gZVU1NqJPxjaAceG7LdkbaYzew8gRE7OyeCaX1euOBHVkK/gwuBCBf+yicuNOmaTskNsAWwCdmCCV
	nLyLeDgPUfZius6A259QJBn6v9JYJCCo4jSC23LucMpfA1ERDtUqlM0Ec4R5sBd4XCNF9tx7JWZgu
	oV8jXTWhzuG2Mjv4yig295NzBxnW3OBGjx0McMFtvu7AqpUqmPina1v//WN23c9c82Rf+YQqbb4x0
	L7Vh9v1A==;
Received: from [2001:4bb8:2cc:a2a4:c4df:8bbe:2b62:c9f4] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTL5x-0000000FWAY-23rY;
	Wed, 10 Dec 2025 14:23:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: validate that zoned RT devices are zone aligned
Date: Wed, 10 Dec 2025 15:23:05 +0100
Message-ID: <20251210142305.3660710-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
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

