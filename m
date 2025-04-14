Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C986F1401C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609068; cv=none; b=BP6MiOEqmoD4rs0XDpHLzvIFazikfaHzjnDudhMzUqOtjg5/L6f0gNOh48QsTLVSufBCuxgaUduyIccuQKoaUL+C6rQXaRBt446ighfQBTYT4Dko5unMU25qqNyTC/b84YFjE1OgsTgmPpHyQJ8fcVMhqyPUmSwImIEp0u9/KrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609068; c=relaxed/simple;
	bh=uhKjziA3zNlUPJK/ACQoJSBvofyNYUDgpv+EskfA99M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVrQvUUky4ul89mUe15lPzl09TfcUO7+ghKCGuqpUevAShqBD9vRDUUgkqWEyIx7mvjyXNln0qnXP9U7P5uq/ySGu+BH8+7wAnevheLiBSuTWMSL7kQrnq4UV8BtNC8JW+QRXl54wjtYL+NJU7PpY3z9cXYTnln3PXQ3n9V7UiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SPRQVdgl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SPRQVdgl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yaSiqkiqR+DhJNXrhGVnBWmJuIs4cwN4Vzdgvd5FvSs=; b=SPRQVdglVaBEjuGbVJP7mV3g5t
	D4V4oZyMRm7UEoodwRrRnwngUjpyzlyZQIpUpbzzLBVZfZc3mGJZ/O4h1pX/UANzoCW/CSgr0h9wc
	E9ME/hlryDcNbUkEMmdXKfS8L3C3OUNhonfn43+P9QQCsgHha5Ogo3dzAbxnBUwVxKy5fSFYPG5o+
	HtnctTaUSTWbEGicWJqQCqEKlz6kRiv1l+Y3Fs2lhKyyJcXWH7XZVZ6DiZPhMI3V18kQopAD/1B5X
	6f7qune+I/hmBVtkWjLQbmPwc/npEvJyUBb5dSpLsy3ZCpGoOVqd7/zj/VrrC09sZflqa8ZKR6k2j
	6FuSqm3Q==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVu-00000000iKn-0Gec;
	Mon, 14 Apr 2025 05:37:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 25/43] FIXUP: xfs: support zone gaps
Date: Mon, 14 Apr 2025 07:36:08 +0200
Message-ID: <20250414053629.360672-26-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

