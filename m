Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8DD48EC60
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789046959; cv=none; b=FQOTnnNhzflrzsgZHI0TsNveE7xRQ7EWcBG/3ycJnkWjvWK4Y5hmtrg8cllzYDBeamS8kWznBjCaY+wcx4IWp4clEmpz4OR3lPLrgunApYNEoUHcXwsPDzmqRMjA8oYBswxpRIyjSAWKcIsUk1PzcuAowvexaTGMFYEUwto0kXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789046959; c=relaxed/simple;
	bh=LWkDQBAmP3+gZsHJbLGwBIXG3Qnl+HN5trITcpDh9HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnrDEyud3iF5gJ/hThxdhc6CddYehskS4N+yds8/XkVmDMW9w3mgnQu9mt6qTwUkIxCM/6eVDTDMT1xBgtkCX3dxvOFvIcIIXBI8zuh6KY7nCUuQAMCV51nqdJ9GH1jrgGktCL02cCDQqiDtpRcRYujSffqbjgoLd+xPuBxE7f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IxsxLJDI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IxsxLJDI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ADfgy3apcE6LFQyys3Nu4vW10g85oq0aNFmQhTTT2cs=; b=IxsxLJDIYbFfNodLNxfh+b2Bvy
	edhkhKonD2vPebU7tGCoUlgWzB55AoOMe2ctrQGPPKofPjS8EeV39P76SmFpDMYH+6QUp7Tz+kq/h
	flJfqNbJrP7ZqOE9M9SO3RDwh2pfxX9Jn9B6uyoA7dUA1imr8Iqw562ItN2tMUXCEx+fYO5o2mK92
	K8YWlYb5XvMsY2dh5OZzJXfSh1VbcisS8XaK+omZjkVLUbkTASEu36CGd6n3I2/i0mgYE5WPNgPaw
	q09ehBvb7Dtxsz2Ni3jrFlhhec8FgCuUWkUUPxOjb+1Ow5JlrwlPtg7s1EyQ11jJ1plz3D1p7XVDp
	gBkKD86Q==;
Received: from [2001:4bb8:2c4:6e16:7921:e451:555c:a765] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4eq4-0000000ESvE-2zDH;
	Thu, 10 Sep 2026 13:29:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] libxfs: provide xfs_error.h
Date: Thu, 10 Sep 2026 15:28:36 +0200
Message-ID: <20260910132840.1541283-7-hch@lst.de>
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

This removes a lot of divergence in the include statements compared to the
kernel version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/Makefile               |  1 +
 libxfs/defer_item.c           |  1 +
 libxfs/stubs/xfs_error.h      | 34 ++++++++++++++++++++++++++++++++++
 libxfs/xfs_ag.c               |  1 +
 libxfs/xfs_ag_resv.c          |  1 +
 libxfs/xfs_alloc.c            |  1 +
 libxfs/xfs_alloc_btree.c      |  1 +
 libxfs/xfs_attr_leaf.c        |  1 +
 libxfs/xfs_attr_remote.c      |  1 +
 libxfs/xfs_bmap.c             |  1 +
 libxfs/xfs_bmap_btree.c       |  1 +
 libxfs/xfs_btree.c            |  1 +
 libxfs/xfs_btree_mem.c        |  1 +
 libxfs/xfs_da_btree.c         |  2 ++
 libxfs/xfs_dir2.c             |  1 +
 libxfs/xfs_dir2_block.c       |  1 +
 libxfs/xfs_dir2_data.c        |  1 +
 libxfs/xfs_dir2_leaf.c        |  1 +
 libxfs/xfs_dir2_node.c        |  1 +
 libxfs/xfs_dquot_buf.c        |  1 +
 libxfs/xfs_exchmaps.c         |  1 +
 libxfs/xfs_group.c            |  1 +
 libxfs/xfs_ialloc.c           |  1 +
 libxfs/xfs_ialloc_btree.c     |  1 +
 libxfs/xfs_inode_buf.c        |  1 +
 libxfs/xfs_inode_fork.c       |  1 +
 libxfs/xfs_inode_util.c       |  1 +
 libxfs/xfs_metadir.c          |  1 +
 libxfs/xfs_metafile.c         |  1 +
 libxfs/xfs_parent.c           |  1 +
 libxfs/xfs_platform.h         | 27 ---------------------------
 libxfs/xfs_refcount.c         |  1 +
 libxfs/xfs_refcount_btree.c   |  1 +
 libxfs/xfs_rmap.c             |  1 +
 libxfs/xfs_rmap_btree.c       |  1 +
 libxfs/xfs_rtbitmap.c         |  1 +
 libxfs/xfs_rtgroup.c          |  1 +
 libxfs/xfs_rtrefcount_btree.c |  1 +
 libxfs/xfs_rtrmap_btree.c     |  1 +
 libxfs/xfs_sb.c               |  2 +-
 libxfs/xfs_symlink_remote.c   |  1 +
 41 files changed, 74 insertions(+), 28 deletions(-)
 create mode 100644 libxfs/stubs/xfs_error.h

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 7af5db81b0c3..d173a2c4b13b 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -74,6 +74,7 @@ HFILES = \
 	xfs_dir2_priv.h \
 	xfs_zones.h \
 	stubs/xfs_buf_mem.h \
+	stubs/xfs_error.h \
 	stubs/xfs_inode.h \
 	stubs/xfs_mount.h \
 	stubs/xfs_trace.h \
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 14ee41525517..fada5b6db2a6 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -21,6 +21,7 @@
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_error.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "libxfs.h"
diff --git a/libxfs/stubs/xfs_error.h b/libxfs/stubs/xfs_error.h
new file mode 100644
index 000000000000..94d597fced71
--- /dev/null
+++ b/libxfs/stubs/xfs_error.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __XFS_ERROR_H__
+#define __XFS_ERROR_H__
+
+#define XFS_ERRLEVEL_LOW		1
+
+/* stop unused var warnings by assigning mp to itself */
+
+#define xfs_corruption_error(e,l,mp,b,sz,fi,ln,fa)	do { \
+	(mp) = (mp); \
+	cmn_err(CE_ALERT, "%s: XFS_CORRUPTION_ERROR", (e));  \
+} while (0)
+
+#define XFS_CORRUPTION_ERROR(e, lvl, mp, buf, bufsize)	do { \
+	(mp) = (mp); \
+	cmn_err(CE_ALERT, "%s: XFS_CORRUPTION_ERROR", (e));  \
+} while (0)
+
+#define XFS_ERROR_REPORT(e,l,mp)	do { \
+	(mp) = (mp); \
+	cmn_err(CE_ALERT, "%s: XFS_ERROR_REPORT", (e));  \
+} while (0)
+
+#define XFS_WARN_CORRUPT(mp, expr) \
+	( xfs_is_reporting_corruption(mp) ? \
+	   (printf("%s: XFS_WARN_CORRUPT at %s:%d", #expr, \
+		   __func__, __LINE__), true) : true)
+
+#define XFS_IS_CORRUPT(mp, expr)	\
+	(unlikely(expr) ? XFS_WARN_CORRUPT((mp), (expr)) : false)
+
+#define XFS_TEST_ERROR(mp, expr)		(false)
+
+#endif  /* __XFS_ERROR_H__ */
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 2f47a02cc6fd..7eeb1f24b24a 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -22,6 +22,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
+#include "xfs_error.h"
 #include "xfs_bmap.h"
 #include "xfs_defer.h"
 #include "xfs_log_format.h"
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 052d18733046..c4cdcc570d61 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -12,6 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_alloc.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 695ed830d139..cf517d4a938a 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -17,6 +17,7 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_ag.h"
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index f62565bb55a1..04e028194e8c 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -14,6 +14,7 @@
 #include "xfs_btree_staging.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_error.h"
 #include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index c621ccedaa48..0ac2ae28efa6 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -22,6 +22,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
 #include "xfs_ag.h"
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 89d01aa7b051..e6c8dd1a997a 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -21,6 +21,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
 #include "xfs_health.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 330325004106..1d3460da84ca 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -21,6 +21,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_leaf.h"
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index a12ba6918c7b..5b82e732d3ad 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -18,6 +18,7 @@
 #include "xfs_btree_staging.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index fe565b84903c..3f820e7999a6 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -15,6 +15,7 @@
 #include "xfs_trans.h"
 #include "xfs_btree.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_alloc.h"
 #include "xfs_btree_staging.h"
diff --git a/libxfs/xfs_btree_mem.c b/libxfs/xfs_btree_mem.c
index d65be63df88c..c2fa836a2ae2 100644
--- a/libxfs/xfs_btree_mem.c
+++ b/libxfs/xfs_btree_mem.c
@@ -12,6 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_btree.h"
+#include "xfs_error.h"
 #include "xfs_buf_mem.h"
 #include "xfs_btree_mem.h"
 #include "xfs_ag.h"
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index b51b10f916ab..9f25f1658b07 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -18,7 +18,9 @@
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_errortag.h"
 #include "xfs_health.h"
 
 /*
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index fce2d847c760..0c0402a29b6b 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -16,6 +16,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_health.h"
 #include "xfs_bmap_btree.h"
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 29b5b158c80d..0e9dd19eafae 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -16,6 +16,7 @@
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_health.h"
 
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 93540a7549ed..0fafe7826ec9 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -14,6 +14,7 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_health.h"
 
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index b89350b03b87..ea8ab6d46c6c 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -15,6 +15,7 @@
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_health.h"
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 97b8860be942..a0aaa21b12cf 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -15,6 +15,7 @@
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_health.h"
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 5022073e0c4a..b0cb2a2b1cc4 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -14,6 +14,7 @@
 #include "xfs_quota_defs.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_error.h"
 #include "xfs_health.h"
 #include "xfs_metadir.h"
 #include "xfs_metafile.h"
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 78bd421b26d5..7b9bba1d971c 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -18,6 +18,7 @@
 #include "xfs_trace.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
+#include "xfs_error.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
 #include "defer_item.h"
diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index cb8415147509..12ce312d1e50 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -8,6 +8,7 @@
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_group.h"
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index f2669dc4907e..aa895c0decbc 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -17,6 +17,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 85b24b8449c7..1376e8630449 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -16,6 +16,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_error.h"
 #include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 9990aaeef5fd..8ea12f82ad81 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -13,6 +13,7 @@
 #include "xfs_ag.h"
 #include "xfs_inode.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 46699896da24..df89ae420617 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -16,6 +16,7 @@
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index cef34004dbe7..9de455088568 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -17,6 +17,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_health.h"
 #include "xfs_bmap.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "iunlink.h"
diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
index bfb261e3f72d..aecffb11a310 100644
--- a/libxfs/xfs_metadir.c
+++ b/libxfs/xfs_metadir.c
@@ -29,6 +29,7 @@
 #include "xfs_parent.h"
 #include "xfs_health.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_btree.h"
 #include "xfs_alloc.h"
 
diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index bab5d7e29ae9..7973feb3b411 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -18,6 +18,7 @@
 #include "xfs_trace.h"
 #include "xfs_inode.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_alloc.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index ef4061035171..9420d8089e8c 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -13,6 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_da_btree.h"
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 5cddfbb82cc8..7c62a40af458 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -147,39 +147,12 @@ extern char    *progname;
 #define xfs_mod_delalloc(a,b,c)		((void) 0)
 #define xfs_mod_sb_delalloc(sb, d)	((void) 0)
 
-/* stop unused var warnings by assigning mp to itself */
-
-#define xfs_corruption_error(e,l,mp,b,sz,fi,ln,fa)	do { \
-	(mp) = (mp); \
-	cmn_err(CE_ALERT, "%s: XFS_CORRUPTION_ERROR", (e));  \
-} while (0)
-
-#define XFS_CORRUPTION_ERROR(e, lvl, mp, buf, bufsize)	do { \
-	(mp) = (mp); \
-	cmn_err(CE_ALERT, "%s: XFS_CORRUPTION_ERROR", (e));  \
-} while (0)
-
-#define XFS_ERROR_REPORT(e,l,mp)	do { \
-	(mp) = (mp); \
-	cmn_err(CE_ALERT, "%s: XFS_ERROR_REPORT", (e));  \
-} while (0)
-
-#define XFS_WARN_CORRUPT(mp, expr) \
-	( xfs_is_reporting_corruption(mp) ? \
-	   (printf("%s: XFS_WARN_CORRUPT at %s:%d", #expr, \
-		   __func__, __LINE__), true) : true)
-
-#define XFS_IS_CORRUPT(mp, expr)	\
-	(unlikely(expr) ? XFS_WARN_CORRUPT((mp), (expr)) : false)
-
-#define XFS_ERRLEVEL_LOW		1
 #define XFS_ILOCK_EXCL			0
 #define XFS_ILOCK_SHARED		0
 #define XFS_IOLOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
-#define XFS_TEST_ERROR(a,b)		(false)
 
 #define __section(section)	__attribute__((__section__(section)))
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 1d45160789f0..3615f747f82a 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -16,6 +16,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_bit.h"
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 6738a68ffa49..7e5f92c1ac56 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -15,6 +15,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_alloc.h"
+#include "xfs_error.h"
 #include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index e65f4d7808be..74600c99172d 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -20,6 +20,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_inode.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 98b16dc83f84..6e2a32d8382c 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -18,6 +18,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_health.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_buf_mem.h"
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 1681e4a91d7a..d46a1617d076 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -16,6 +16,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans.h"
+#include "xfs_error.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
 #include "xfs_sb.h"
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index d127ac0d6110..c1f8d2cb186a 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -20,6 +20,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
+#include "xfs_error.h"
 #include "xfs_bmap.h"
 #include "xfs_defer.h"
 #include "xfs_log_format.h"
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 02230c8ef0f0..6a6e85c413e0 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -22,6 +22,7 @@
 #include "xfs_refcount.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_error.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 091221743b8a..81d517b94e46 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -23,6 +23,7 @@
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_error.h"
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 7097bb61d48d..ea99f8b5eee5 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -14,7 +14,7 @@
 #include "xfs_mount.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
-#include "xfs_trace.h"
+#include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 7b62dba485a5..de487b1caa4b 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -12,6 +12,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_bit.h"
-- 
2.53.0

