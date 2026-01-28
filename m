Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB18719E97F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 04:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769574810; cv=none; b=UNfq+KQAa51f5fmGN5GaHT4j8gxrH1X5X8um7E2Err88ICrroIWowzs4k9NSXbfp7loq80Iap7hQCHsqCcmcKdqQxB4FfgVCKzsdg4HntpXq+dnqspOq6WzlkMCf2Etj4PqBFpI172S/Ecrjq5w9gplQBvkNsGaKi5guwprB/dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769574810; c=relaxed/simple;
	bh=MlaWmnGFUPSjkWXdOvoxa9xGIEt9lGGZotOwV8tNuv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jd0UGKSIgJvNJPmKK5QlwX70KKVxBsuODgRsuO2A2aYNO+0ppkMcxEsnlerKh7/g0qP/cNwzam+U28h0pSH0I67hBbX6BRhND6wCFEFnPDaHKtqkhWunoBeDWi/Tb3FPvOzKusdj9KVySNEfBfS9+rtFa7nMNEb3fcCX0105m4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kUnskSkR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kUnskSkR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=K19yzn7/Mk0oaI5SVEhkUDQovJ22cOUTUhGVJJdBMdA=; b=kUnskSkRk7lcBUe2bYeOyg7eGl
	DqsYYCpwQFSKERhL+jTbL57nS2N0g9LJCkGM3CxQX6inFzL1aBZgo4vgK607KeYj/ng4C7IFf60OJ
	5BSPT7kopFtOTSPIl/sbBI8I/N8qOgZOLk3Zh4OYWKkQRYmrlA0wsG0K2LI3hJJUNodPy/Sp2kTdV
	zBSAJMP98aRuxOGAg1iN01cI6OjQ0pjhfRWbF6QGVzL4bLG7KF0iUxZ+w7EYRgjTP/B6FoqccIyHA
	9e0INaW1R+NVbpPuDZuhcM5G28P+p695EaDR4LGwwnsGmGGeyN3aIuRqVn4M9vHYfpY5Epwo4MIrw
	fiH1Ak7A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkxF8-0000000FQaj-3KUz;
	Wed, 28 Jan 2026 04:33:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] include blkzoned.h in platform_defs.h
Date: Wed, 28 Jan 2026 05:32:55 +0100
Message-ID: <20260128043318.522432-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128043318.522432-1-hch@lst.de>
References: <20260128043318.522432-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We'll need to conditionally add definitions added in later version of
blkzoned.h soon.  The right place for that is platform_defs.h, which
means blkzoned.h needs to be included there for cpp trickery to work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h   | 1 +
 libxfs/xfs_zones.c        | 1 -
 mdrestore/xfs_mdrestore.c | 1 -
 mkfs/xfs_mkfs.c           | 1 -
 repair/zoned.c            | 1 -
 5 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/platform_defs.h b/include/platform_defs.h
index da966490b0f5..1152f0622ccf 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -24,6 +24,7 @@
 #include <stdbool.h>
 #include <libgen.h>
 #include <urcu.h>
+#include <linux/blkzoned.h>
 
 /* long and pointer must be either 32 bit or 64 bit */
 #define BITS_PER_LONG (sizeof(long) * CHAR_BIT)
diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
index 7a81d83f5b3e..c1ad7075329c 100644
--- a/libxfs/xfs_zones.c
+++ b/libxfs/xfs_zones.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include <linux/blkzoned.h>
 #include "libxfs_priv.h"
 #include "xfs.h"
 #include "xfs_fs.h"
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index b6e8a6196a79..eece58977f97 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -8,7 +8,6 @@
 #include "xfs_metadump.h"
 #include <libfrog/platform.h>
 #include "libfrog/div64.h"
-#include <linux/blkzoned.h>
 
 union mdrestore_headers {
 	__be32				magic;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b34407725f76..46f4faf4de5a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6,7 +6,6 @@
 #include "libfrog/util.h"
 #include "libxfs.h"
 #include <ctype.h>
-#include <linux/blkzoned.h>
 #include "libxfs/xfs_zones.h"
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
diff --git a/repair/zoned.c b/repair/zoned.c
index 206b0158f95f..49cc43984883 100644
--- a/repair/zoned.c
+++ b/repair/zoned.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2024 Christoph Hellwig.
  */
 #include <ctype.h>
-#include <linux/blkzoned.h>
 #include "libxfs_priv.h"
 #include "libxfs.h"
 #include "xfs_zones.h"
-- 
2.47.3

