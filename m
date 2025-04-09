Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94A625B664
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185389; cv=none; b=noKVYwhHzYYldkmF+YHknUOWeqA5/AttHhjbAG8BJ7b6t0sSnJ0sLsMigP1mJxc7PiNO+tqcfvgj6pBkMnw+Slad4Vdbxc/EwbmzoulVeIcSxalg+8Xg5Jtf6BxSRJrwRczllfZFgwgWcLFAn9OXE7J01WXS44UoM8cq/TIrCog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185389; c=relaxed/simple;
	bh=dIFIP7Y88h2q46GzxcAKEkUZ3eX3rQUix0gyFAPZmIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1tMSmNZhYLbKFtfCoEjcsVjkXbn8MId0l4P7f2bxvBoJJN2Pg7dzgUfqUyazolSmANRXQiFXhFKl8R61AhG6oRQlfw2ZlMRKbTtUWY2jRzP/MZGL99mlUeyuBoTXoqwQs8i4zc471ecOObKN26X4taXo9G9vDMm+wD3jgEvhuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B7fXOJCS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B7fXOJCS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=STuM/sqjJc9PfP6YopoqFgI/wbgFj3MI/U4YXlO1S/o=; b=B7fXOJCSQEf5Kmxe5W2Zjwoeem
	cqqj7TcPMYWpSzE8vd7f5w9y/lxULBya1uIGJMuu8vWOod46gsVP5KmSruF5cIWZj4/yHolxiGMKc
	46xsOiq5MyCBWHssJclV6AFIVO769zUnOxGxc9eEt3DXdvQKZZaGS+7TtrR4l+9tTIwbNu8Wty3J1
	igHNm08NcNrjDA0/eh9x5HsJ7SasxkFQIawakOOxe2oPSZ/BYDpwJt1P2OuI0Csq0nSwp9oMu/2Kb
	JsamRyzln3qxtcMMo3LNtItXwAPG5lzw1fbYbEvPNIuKWTl+rmvTfYP1TsWRkx6jH/zY2tMTjwfen
	CS/MbPaw==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QIN-00000006UGP-0N53;
	Wed, 09 Apr 2025 07:56:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/45] xfs: add a rtg_blocks helper
Date: Wed,  9 Apr 2025 09:55:09 +0200
Message-ID: <20250409075557.3535745-7-hch@lst.de>
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

Source kernel commit: 012482b3308a49a84c2a7df08218dd4ad081e1da

Shortcut dereferencing the xg_block_count field in the generic group
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtgroup.c | 2 +-
 libxfs/xfs_rtgroup.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 24fb160b8067..6f65ecc3015d 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -267,7 +267,7 @@ xfs_rtgroup_get_geometry(
 	/* Fill out form. */
 	memset(rgeo, 0, sizeof(*rgeo));
 	rgeo->rg_number = rtg_rgno(rtg);
-	rgeo->rg_length = rtg_group(rtg)->xg_block_count;
+	rgeo->rg_length = rtg_blocks(rtg);
 	xfs_rtgroup_geom_health(rtg, rgeo);
 	return 0;
 }
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 03f39d4e43fc..9c7e03f913cb 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -66,6 +66,11 @@ static inline xfs_rgnumber_t rtg_rgno(const struct xfs_rtgroup *rtg)
 	return rtg->rtg_group.xg_gno;
 }
 
+static inline xfs_rgblock_t rtg_blocks(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_group.xg_block_count;
+}
+
 static inline struct xfs_inode *rtg_bitmap(const struct xfs_rtgroup *rtg)
 {
 	return rtg->rtg_inodes[XFS_RTGI_BITMAP];
-- 
2.47.2

