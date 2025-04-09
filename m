Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1E725A34A
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185443; cv=none; b=TWFr6xiEKE7Iv6zowzN9B9GKOFefCgc36D6sNlbZUaEVBGvFjMGISAmkJ47bJ3zJtyjeqcSpgsA3i2ewyTYgeivO+Z6Io6/u6udh77EXf6TFf8MQDXWibivWNghxfoIbKpQCevQ4JHXM75ONIaJ1VoAql+H3xcuUVLQb1zK2X6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185443; c=relaxed/simple;
	bh=d4AIU5mohnjkX066Z0WOvyXcP7Quj4E2Xb/x9Fa/sw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ug/b5P+3sBoByEyn2nh7uohxRJKdjLd7KJ4gmFx2VlSPBC62X9Sh4wpBCd6ikY7mbKMSkyYY8u87CckUaXFx/H3eEplZGPqdz9c67GwuSno6SIIbHXS84vaDfzyy89L1WKei1XxY/cJw6vb99Y5IAO8zVyWuI4E2v4d6uKQfG9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XwczGQWx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XwczGQWx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nYx3YjnCT9pVzWF6xcerSSCJ1dpobqa1pgZ0pvft7+s=; b=XwczGQWxvb5l7vfWtnqYZM74IQ
	0ow1o1jvyXj0//M0XlH6Gc0juO6K/DMJI1s2Mk7uMQqrtfbN/UF0+BouXJ5jhnsHoJ82usmS/vusq
	CXPDeRnn1W1O3O9uJCW87avw1i56cU9HfNz1eIPMUR1bDWTVPxxkskcTb/MGwchu7QiBMeji4QzVK
	5Pe40ptFBgE8Rm5iYkW0Hf5pIlLtIkxMYk5qG5HtuOfwecNLKzEq6by7GL1hSwQO95b/PEyWa5zz1
	F9mc6J2Q0kpPDZYgL6a2fYBZ4m9NFgmcToUEbQNKlPr0vUmXR7ExK7znEGBfQERN2aADqP7WHi567
	1hvzdBHg==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QJG-00000006UWH-01Sa;
	Wed, 09 Apr 2025 07:57:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 20/45] FIXUP: xfs: add support for zoned space reservations
Date: Wed,  9 Apr 2025 09:55:23 +0200
Message-ID: <20250409075557.3535745-21-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h | 2 ++
 libxfs/xfs_bmap.c    | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 82952b0db629..d5f7d28e08e2 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -471,6 +471,8 @@ static inline int retzero(void) { return 0; }
 #define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
 #define xlog_calc_iovec_len(len)		roundup(len, sizeof(uint32_t))
 
+#define xfs_zoned_add_available(mp, rtxnum)	do { } while (0)
+
 /*
  * Prototypes for kernel static functions that are aren't in their
  * associated header files.
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3a857181bfa4..3cb47c3c8707 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -35,7 +35,6 @@
 #include "xfs_symlink_remote.h"
 #include "xfs_inode_util.h"
 #include "xfs_rtgroup.h"
-#include "xfs_zone_alloc.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
-- 
2.47.2

