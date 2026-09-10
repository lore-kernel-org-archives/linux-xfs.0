Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3DE48F854
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789046969; cv=none; b=rWVIe6XQ2yQsMfoduQ1O8673gVaTrOP7pYo23enfSA/ZA11PdQ53Bex33k5tYYtduwR48joZ/ejUOQTxNHEluw7vfh1v9x36f2kd54vlQTrj/B8EQkMZWyDo8TB9Q0g9jHkKCCUfrq9vB3GKZDzRRe97s4mVW284TOMZWrAAee8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789046969; c=relaxed/simple;
	bh=IusIMd5tv3oiABgmeGFUYaMf3616lPNJyDcPWHsiPvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFkrW6tNj7BLrga1xakWmiIMnkwZIiEV0kdkZItSMW2o8+NPXuklVw8H81+2OA/SkoOCr5+zz6pxdsH52xEg1OvcTklxS2YaNYVWquFi0PYNhyBoLHiH3Mbxo4NNcSuLyQPT11nGPrOCYpQKlcCnWfT5Y9MwMfeg5tm1IHLGe70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IE0clsk2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IE0clsk2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nyVhWMkRzes2MlqozW9YBbBqnICyKhwUfao3LZ9pdoM=; b=IE0clsk2VoHarTUI6uW/Gay/si
	97SM4x2KwnGQu5NlmbOUPVs+LUks8W/Lpm8JcmMR7cL/CZXYDumC/1if4WStfxPaNPRqDR/AD1tpu
	LK3C788IavyuFamCrS9/hXwla4wOQZgPHeYbTwu9NGfunlTeELeTT4tlRldWWaxqi4uKpKqgXhX4X
	UORIDEnAijE9qeH1ft0RveyDYne2PPYd46yLSoOam4b2n7oCtqfJSGTUr9qE51wRof4aae44zbG1I
	uY89iWaWMU1eoW6qwy3ijB+j5jZOm3j66vuCt9ty79APrvP25jl0pNdgHMu4UbzNNNDR0+U8COFUK
	ftGL2aAg==;
Received: from [2001:4bb8:2c4:6e16:7921:e451:555c:a765] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4eqE-0000000ESvX-19g3;
	Thu, 10 Sep 2026 13:29:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] libxfs: provide xfs_quota.h
Date: Thu, 10 Sep 2026 15:28:38 +0200
Message-ID: <20260910132840.1541283-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910132840.1541283-1-hch@lst.de>
References: <20260910132840.1541283-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Reduce spurious include differences to the kernel files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/Makefile          |  1 +
 libxfs/stubs/xfs_quota.h | 20 ++++++++++++++++++++
 libxfs/xfs_attr.c        |  2 +-
 libxfs/xfs_bmap.c        |  2 +-
 libxfs/xfs_bmap_btree.c  |  2 +-
 libxfs/xfs_btree.c       |  1 +
 libxfs/xfs_dquot_buf.c   |  2 +-
 libxfs/xfs_exchmaps.c    |  1 +
 libxfs/xfs_metadir.c     |  1 +
 libxfs/xfs_metafile.c    |  1 +
 libxfs/xfs_platform.h    | 15 ---------------
 libxfs/xfs_trans_resv.c  |  2 +-
 12 files changed, 30 insertions(+), 20 deletions(-)
 create mode 100644 libxfs/stubs/xfs_quota.h

diff --git a/libxfs/Makefile b/libxfs/Makefile
index bf681435969c..9795982b0e83 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -78,6 +78,7 @@ HFILES = \
 	stubs/xfs_extent_busy.h \
 	stubs/xfs_inode.h \
 	stubs/xfs_mount.h \
+	stubs/xfs_quota.h \
 	stubs/xfs_trace.h \
 	stubs/xfs_trans.h
 
diff --git a/libxfs/stubs/xfs_quota.h b/libxfs/stubs/xfs_quota.h
new file mode 100644
index 000000000000..7bc545bd5449
--- /dev/null
+++ b/libxfs/stubs/xfs_quota.h
@@ -0,0 +1,20 @@
+#ifndef __XFS_QUOTA_H__
+#define __XFS_QUOTA_H__
+
+#include "xfs_quota_defs.h"
+
+#define xfs_trans_mod_dquot_byino(t,i,f,d)		({ \
+	uint _f = (f); \
+	_f = _f; /* shut up gcc */ \
+})
+#define xfs_trans_reserve_quota_nblks(t,i,b,n,f)	(0)
+
+/* hack too silence gcc */
+static inline int retzero(void) { return 0; }
+#define xfs_trans_unreserve_quota_nblks(t,i,b,n,f)	retzero()
+#define xfs_quota_unreserve_blkres(i,b) 		retzero()
+
+#define xfs_quota_reserve_blkres(i,b)		(0)
+#define xfs_qm_dqattach(i)			(0)
+
+#endif  /* __XFS_QUOTA_H__ */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index bff809676701..57a0a175c286 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -21,7 +21,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
-#include "xfs_quota_defs.h"
+#include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "defer_item.h"
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1d3460da84ca..cec59446711b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -22,10 +22,10 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_leaf.h"
-#include "xfs_quota_defs.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 5b82e732d3ad..758a4b1ccf5b 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -19,10 +19,10 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
+#include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
-#include "xfs_quota_defs.h"
 
 static struct kmem_cache	*xfs_bmbt_cur_cache;
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 3f820e7999a6..425fbefc31ad 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -31,6 +31,7 @@
 #include "xfs_rtrmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_rmap.h"
+#include "xfs_quota.h"
 #include "xfs_metafile.h"
 #include "xfs_rtrefcount_btree.h"
 
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index b0cb2a2b1cc4..0e59106303c4 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -11,8 +11,8 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_quota_defs.h"
 #include "xfs_inode.h"
+#include "xfs_quota.h"
 #include "xfs_trans.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 7b9bba1d971c..7d6f949aa1f3 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -14,6 +14,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
+#include "xfs_quota.h"
 #include "xfs_exchmaps.h"
 #include "xfs_trace.h"
 #include "xfs_bmap_btree.h"
diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
index aecffb11a310..74c4596ee4cf 100644
--- a/libxfs/xfs_metadir.c
+++ b/libxfs/xfs_metadir.c
@@ -18,6 +18,7 @@
 #include "xfs_metadir.h"
 #include "xfs_trace.h"
 #include "xfs_inode.h"
+#include "xfs_quota.h"
 #include "xfs_ialloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_da_format.h"
diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 7973feb3b411..71f004e9dc64 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -17,6 +17,7 @@
 #include "xfs_metafile.h"
 #include "xfs_trace.h"
 #include "xfs_inode.h"
+#include "xfs_quota.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_alloc.h"
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 542e633f0ffe..d09fb0aae00f 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -394,21 +394,6 @@ xfs_buf_readahead(
 
 #define xfs_trans_inode_buf(tp, bp)		((void) 0)
 
-/* quota bits */
-#define xfs_trans_mod_dquot_byino(t,i,f,d)		({ \
-	uint _f = (f); \
-	_f = _f; /* shut up gcc */ \
-})
-#define xfs_trans_reserve_quota_nblks(t,i,b,n,f)	(0)
-
-/* hack too silence gcc */
-static inline int retzero(void) { return 0; }
-#define xfs_trans_unreserve_quota_nblks(t,i,b,n,f)	retzero()
-#define xfs_quota_unreserve_blkres(i,b) 		retzero()
-
-#define xfs_quota_reserve_blkres(i,b)		(0)
-#define xfs_qm_dqattach(i)			(0)
-
 #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
 #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
 
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 9294b72e61b7..5b7660b1cd8a 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -15,9 +15,9 @@
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_quota.h"
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
-#include "xfs_quota_defs.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_trace.h"
 #include "defer_item.h"
-- 
2.53.0

