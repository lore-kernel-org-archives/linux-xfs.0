Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CDF48E0FA
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789046955; cv=none; b=RaO0mT9afTCro4r/5zBczj8urvWmPZiv4wXLL8nX4rrKHNMNwlVyo6HavySohi7XE5/Lvp5YX0tMFOXjMhH1ZVmI5cpoUG2/qdMvmjcOu6v4fMsNIxodZQnr8F3mMfWbz5IOWCubyXynuWbvmC0DodxBHgt17TYqfp3LZxRDmoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789046955; c=relaxed/simple;
	bh=lukoMQWWw/vY6KEESXGEnpUEp5wjvcOrbcyqJwbdZ+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbNtJaZUGOf+WyW7sduoPTSEO8gztnAZ4SnS8xBLqNRSDiIWvVYqWtm93O8kuoXcfFQHEIBWlOBXZ49Vy0/jrChP5g/vgLfvltJ2s9T3cY/LNqh2UQZ+m876cKABnSRXcBw1AiaOkHFNDwFNKfAFpj/PaBi9T2TkLkLpexkVeA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iHYPXGXS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iHYPXGXS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+l7UFL8SjMxoDVzKK0BsQaVsr3XBLUlx4CmbcB51oSk=; b=iHYPXGXSRqOb9s4aBzgRUGZSf4
	ZjHWiFgUOFULcKo2CUoMBMpVau5SIkQV4/mbxYSBGLr/sQGEQAicEJDKxxkdYX2GBmvn4voq2ub3m
	pejzTUF4e2cv7izcASMOaoSn0hgp6v0gmS93Li0hGeQFh3ITzzRak1N+lMMI4knvDEVP2YRrzacfL
	eg1mbKnN1hcg/17RJlbSwYjnwvOpVnem/Z1k/IUlP/essuxG7sR/ZguykDuLRiLDSokPxW76gYMO/
	D/y1h+eTpGsyPrYVZQJZR4Nz5YyRbGHAzVh5pADzHRUwgrdPIDE8fy841SJlIKqB1kACeAEDsWPLo
	xq3KRcxQ==;
Received: from [2001:4bb8:2c4:6e16:7921:e451:555c:a765] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4eq0-0000000ESuj-3r9h;
	Thu, 10 Sep 2026 13:29:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] libxfs: rename buf_mem.h to xfs_buf_mem.h
Date: Thu, 10 Sep 2026 15:28:35 +0200
Message-ID: <20260910132840.1541283-6-hch@lst.de>
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

Give the file the same name as in the kernel to avoid spurious include
differences.  Also include xfile.h as in the kernel to avoid further
spurious differences.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h                          | 3 +--
 libxfs/Makefile                           | 2 +-
 libxfs/buf_mem.c                          | 3 +--
 libxfs/init.c                             | 3 +--
 libxfs/rdwr.c                             | 3 +--
 libxfs/{buf_mem.h => stubs/xfs_buf_mem.h} | 2 ++
 libxfs/xfs_btree.c                        | 3 +--
 libxfs/xfs_btree_mem.c                    | 3 +--
 libxfs/xfs_rmap_btree.c                   | 3 +--
 libxfs/xfs_rtrmap_btree.c                 | 3 +--
 10 files changed, 11 insertions(+), 17 deletions(-)
 rename libxfs/{buf_mem.h => stubs/xfs_buf_mem.h} (97%)

diff --git a/include/libxfs.h b/include/libxfs.h
index 68d1f351f700..7f0c22ef4991 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -92,8 +92,7 @@ struct iomap;
 #include "xfs_btree_staging.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_symlink_remote.h"
-#include "libxfs/xfile.h"
-#include "libxfs/buf_mem.h"
+#include "xfs_buf_mem.h"
 #include "xfs_btree_mem.h"
 #include "xfs_parent.h"
 #include "xfs_ag_resv.h"
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 24ff07e961aa..7af5db81b0c3 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -29,7 +29,6 @@ HFILES = \
 	xfs_platform.h \
 	linux-err.h \
 	topology.h \
-	buf_mem.h \
 	xfblob.h \
 	xfile.h \
 	xfs_ag_resv.h \
@@ -74,6 +73,7 @@ HFILES = \
 	xfs_trans_space.h \
 	xfs_dir2_priv.h \
 	xfs_zones.h \
+	stubs/xfs_buf_mem.h \
 	stubs/xfs_inode.h \
 	stubs/xfs_mount.h \
 	stubs/xfs_trace.h \
diff --git a/libxfs/buf_mem.c b/libxfs/buf_mem.c
index 15c61966db43..3c8452de9689 100644
--- a/libxfs/buf_mem.c
+++ b/libxfs/buf_mem.c
@@ -5,8 +5,7 @@
  */
 #include "xfs_platform.h"
 #include "libxfs.h"
-#include "libxfs/xfile.h"
-#include "libxfs/buf_mem.h"
+#include "xfs_buf_mem.h"
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/wait.h>
diff --git a/libxfs/init.c b/libxfs/init.c
index 5d8b4a153e28..b89c9fe360d4 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -22,10 +22,9 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_metafile.h"
+#include "xfs_buf_mem.h"
 #include "libfrog/platform.h"
 #include "libfrog/util.h"
-#include "libxfs/xfile.h"
-#include "libxfs/buf_mem.h"
 
 #include "xfs_format.h"
 #include "xfs_da_format.h"
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 6c57bedef548..90f2d56687ca 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -17,9 +17,8 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_buf_mem.h"
 #include "libfrog/platform.h"
-#include "libxfs/xfile.h"
-#include "libxfs/buf_mem.h"
 #include "libxfs.h"
 
 static void libxfs_brelse(struct cache_node *node);
diff --git a/libxfs/buf_mem.h b/libxfs/stubs/xfs_buf_mem.h
similarity index 97%
rename from libxfs/buf_mem.h
rename to libxfs/stubs/xfs_buf_mem.h
index 6e4b2d3503b8..98564e67d5bd 100644
--- a/libxfs/buf_mem.h
+++ b/libxfs/stubs/xfs_buf_mem.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_BUF_MEM_H__
 #define __XFS_BUF_MEM_H__
 
+#include "xfile.h"
+
 extern unsigned int		XMBUF_BLOCKSIZE;
 extern unsigned int		XMBUF_BLOCKSHIFT;
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index ec77f325aab6..fe565b84903c 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -25,8 +25,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_health.h"
-#include "xfile.h"
-#include "buf_mem.h"
+#include "xfs_buf_mem.h"
 #include "xfs_btree_mem.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_bmap.h"
diff --git a/libxfs/xfs_btree_mem.c b/libxfs/xfs_btree_mem.c
index 5fa4a9787c99..d65be63df88c 100644
--- a/libxfs/xfs_btree_mem.c
+++ b/libxfs/xfs_btree_mem.c
@@ -12,8 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_btree.h"
-#include "xfile.h"
-#include "buf_mem.h"
+#include "xfs_buf_mem.h"
 #include "xfs_btree_mem.h"
 #include "xfs_ag.h"
 #include "xfs_trace.h"
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index f63d2df45070..98b16dc83f84 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -20,8 +20,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
-#include "xfile.h"
-#include "buf_mem.h"
+#include "xfs_buf_mem.h"
 #include "xfs_btree_mem.h"
 
 static struct kmem_cache	*xfs_rmapbt_cur_cache;
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 7fbe6c19c454..091221743b8a 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -26,8 +26,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
-#include "xfile.h"
-#include "buf_mem.h"
+#include "xfs_buf_mem.h"
 #include "xfs_btree_mem.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
-- 
2.53.0

