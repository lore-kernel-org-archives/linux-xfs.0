Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BF41F0E20
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907408; cv=none; b=MAJqkIUtHVA09mLLy49aRDJK4lGEb/YW2je3nwEh/byFOUI5PmyKwBd0rNHJsuARWu6hKUCWV3WEKBgElaz1wUOaPST0fBeIDynLjaQLojwlmgCDVafeHVDdF7cbVoWZ6+SXtRpVEBv0UOFu3mbJQ7q7VcKQXLj4d5fD2Uv+Uko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907408; c=relaxed/simple;
	bh=hpwIOShxbAvj64wzEuztsmpC6qTEcQw8kTL+lezQ4ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NF/xRjHuwogQRnuxpro87dwJa7v1hb/AL9ly7gIpjfdj5UOKo16mEKTILLWOApUEStfiqg6iinR4JFSmHleVtmbvP5TEvU0009AIvgl7YrSetONq4l8H3h6CUQSaXYvdaHWZvduJDbW3aOnM77p8w5rKyE17YniPlm16sVG1uxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nN7cuLT9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nN7cuLT9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5aSdKOXfNuYuAXIng7xTgwCqoM93o3efJT7Vj3Huc1E=; b=nN7cuLT9lUo/2K2Z2dKLTc9Cro
	LftjY4WwxvylK85LtmZRbwRBBtQg8BUQJ5Mlanf5OANUBWUHjCz6A451qe1RUcxytt9u0LttRser0
	CW1PlqySpe8vFU8PclZ+yafuw9W5ePs+N8g8Zwah9ABGURbbq81fFk20zQOam+9aCchJmJvLBka54
	Zzv0j3TT39wbKd0554XRJmgBi/11OJGQCaDsLwTDNktFpbD3nIiEAJ4XgZajk/nBGEiLttuuP+cSI
	lvBV7E/redXgbQsPqwTNnsGz7bLGY2OMk1P2ZXtgy10hCq3EfywlqwKoxzh1bL7bmerjLAcBWqHbM
	z2MdGuWA==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWU-0000000EIz4-0xw5;
	Wed, 11 Dec 2024 08:56:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/43] xfs: add a rtg_blocks helper
Date: Wed, 11 Dec 2024 09:54:28 +0100
Message-ID: <20241211085636.1380516-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Shortcut dereferencing the xg_block_count field in the generic group
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c | 2 +-
 fs/xfs/libxfs/xfs_rtgroup.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index d84d32f1b48f..97aad8967149 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -270,7 +270,7 @@ xfs_rtgroup_get_geometry(
 	/* Fill out form. */
 	memset(rgeo, 0, sizeof(*rgeo));
 	rgeo->rg_number = rtg_rgno(rtg);
-	rgeo->rg_length = rtg_group(rtg)->xg_block_count;
+	rgeo->rg_length = rtg_blocks(rtg);
 	xfs_rtgroup_geom_health(rtg, rgeo);
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index de4eeb381fc9..0e1d9474ab77 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
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
2.45.2

