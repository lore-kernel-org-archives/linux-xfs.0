Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C070F23958F
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596257; cv=none; b=qsbbf1hX14rUfCPthThGTEGZbmRje3ilyoVGAHNVKcsScjvsUwkvmjsHZ9BKUlg5mVU+rdZv6YhRON6dBMhI5M2JYxpL0lH7Gn1j2eou6nd6BMs9UK3NUv1yzMKmjgazzxAPv68lRLs5bqXgZ8jEHnY4H9k0upal0EoBXZ/n848=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596257; c=relaxed/simple;
	bh=+zNkolnJcNK4OfYqc9+a81ddN3LPK2eBP9EfpDHa4Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nS6V/L+EYcPTvyJnXqgWkkpE+QOVXQq7qzhp9yLdG2b/tA9K9nOXdWF/raQGBhCCHAOKKctJCoVexUSYB0ozpzOkT0vCA/FrX3nj5DKjMf234vKVC8FSj6+EkNqw+vqLIp/odDr2P3G2aQLMx3kRlrphe//eXIk/fdnzd2EtnD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r3cv7pTk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r3cv7pTk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rca43ilGus7vL3Pavz9Gxuc11hGjxrLOjoVH6QMwRfw=; b=r3cv7pTkN5nEXD9+eqhd6AIGGg
	5/IxOLBZnKjteBMkHv9aq6C2IXTJyNh5VU8Db7eJNFhicqs7Ex4X0ViQzGHkSC2E3tThf/zUyfYPA
	XkKZLV4e7GirJa8/HG8rD8M5fpy6vgUdVGAyQEYvQJjp0qtDKBIoX+W13GNsP8oHcnMJymW+Wlu5s
	CYx3IxHWmJXxNLYuHC8GuBQ2TKsvwaRpBgYAC8fPWYbNW2m0ynRMGGCNwmyEdEd34fJclrqMdiSPs
	7Xa1hPtIvxtsjrJ/M3Scl+zQgP1YmNhpO0naQoJ9DBmD+2C4VWFlFDiByYI2urpiWPJ1kxd2xG+ux
	9p5ZbCaA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb9-000000053xG-1ysx;
	Wed, 26 Feb 2025 18:57:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 37/44] xfs: enable the zoned RT device feature
Date: Wed, 26 Feb 2025 10:57:09 -0800
Message-ID: <20250226185723.518867-38-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Enable the zoned RT device directory feature.  With this feature, RT
groups are written sequentially and always emptied before rewriting
the blocks.  This perfectly maps to zoned devices, but can also be
used on conventional block devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f67380a25805..cee7e26f23bd 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -408,7 +408,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
 		 XFS_SB_FEAT_INCOMPAT_PARENT | \
-		 XFS_SB_FEAT_INCOMPAT_METADIR)
+		 XFS_SB_FEAT_INCOMPAT_METADIR | \
+		 XFS_SB_FEAT_INCOMPAT_ZONED)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.45.2

