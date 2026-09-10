Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF28448F03E
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789046964; cv=none; b=juo1ZmxIAXbq7VxNo9Mg/JpFjU6tkWA//G9kT7q/q8DZ/n3QfMJYDgrLioJCp1Iquz18W4AZ9H3E9nws6BzKc8HCUhrGIMGxCNUnAhCLoRrBoC03KuDPK/HTM419WuDuadEU5KJPOsgY7FAVRQQpds8RaT3004Rt834ZkjM7Owk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789046964; c=relaxed/simple;
	bh=8hVxC0lQ3Ki+S3I+qDvS/dCbzWujrw7rMgYIMtMBVFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkpB0QgfK7UNAv2Jvq57WFEhxXLSIUYEGq45Wvr7b71Zet6tcWCl2c9Ylt6VK2R39Ede7Tl2qykQnO2LCS8x228+IuSKA3MhJjHv247TemRrGgVP1wnRiM5eR7p+juPRjnaM5hOZDjqPp2eI16MFlAraS3MDIDXZMesuL1r57Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N0KZ7RhK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N0KZ7RhK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Dpe+vmsjYffXvzkMvjGpmm04fHGVLytPCDuWmRpkatA=; b=N0KZ7RhKO19cErUdwfQkvsVoNy
	waWqLVQxmWGLN8Kca0YD7G0qUZ/Fc271brcmB6CRr9/fQzcelqivQJrxA3TsPOn6/AplbJ3TQB9V4
	uOhW/P+ZU0G4Mo3jqex5mNNA3nkbG0RMjx1ydK7DD2LFtH3UGuc9KiYvv8Jq80z2QNNPQzbFdY1cP
	QF9s89o0yl3JVm2E4W5+4tOLFAdj3KUWf6kxZ/osEjxLgaOCGFz/x/bkR0m+NzCiSdQxN4cpWjacI
	erUjB4yWQg9bI+hrSGVqzUt2vDvPg6EwtUkRU53yB8vReiSIM4IA8xCISpL1YgvqJgLPU9l42V2oe
	/yEhKQpA==;
Received: from [2001:4bb8:2c4:6e16:7921:e451:555c:a765] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4eq9-0000000ESvK-2JqD;
	Thu, 10 Sep 2026 13:29:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] libxfs: provide xfs_extent_busy.h
Date: Thu, 10 Sep 2026 15:28:37 +0200
Message-ID: <20260910132840.1541283-8-hch@lst.de>
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

Reduces various spurious differences with the kernel.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/Makefile                |  1 +
 libxfs/stubs/xfs_extent_busy.h | 20 ++++++++++++++++++++
 libxfs/xfs_alloc.c             |  1 +
 libxfs/xfs_alloc_btree.c       |  1 +
 libxfs/xfs_group.c             |  1 +
 libxfs/xfs_platform.h          | 15 ---------------
 libxfs/xfs_rmap_btree.c        |  1 +
 libxfs/xfs_rtbitmap.c          |  1 +
 libxfs/xfs_rtrefcount_btree.c  |  1 +
 libxfs/xfs_rtrmap_btree.c      |  1 +
 10 files changed, 28 insertions(+), 15 deletions(-)
 create mode 100644 libxfs/stubs/xfs_extent_busy.h

diff --git a/libxfs/Makefile b/libxfs/Makefile
index d173a2c4b13b..bf681435969c 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -75,6 +75,7 @@ HFILES = \
 	xfs_zones.h \
 	stubs/xfs_buf_mem.h \
 	stubs/xfs_error.h \
+	stubs/xfs_extent_busy.h \
 	stubs/xfs_inode.h \
 	stubs/xfs_mount.h \
 	stubs/xfs_trace.h \
diff --git a/libxfs/stubs/xfs_extent_busy.h b/libxfs/stubs/xfs_extent_busy.h
new file mode 100644
index 000000000000..4fbebabca124
--- /dev/null
+++ b/libxfs/stubs/xfs_extent_busy.h
@@ -0,0 +1,20 @@
+#ifndef __XFS_EXTENT_BUSY_H__
+#define __XFS_EXTENT_BUSY_H__
+
+#define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
+#define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
+
+#define xfs_extent_busy_reuse(...)			((void) 0)
+/* avoid unused variable warning */
+#define xfs_extent_busy_insert(tp,xg,bno,len,flags)({ 	\
+	struct xfs_group *__foo = xg;			\
+	__foo = __foo; /* no set-but-unused warning */	\
+})
+#define xfs_extent_busy_trim(group,minlen,maxlen,bno,len,busy_gen) 	({	\
+	unsigned __foo = *(busy_gen);				\
+	*(busy_gen) = __foo;					\
+	false;							\
+})
+#define xfs_extent_busy_flush(tp,pag,busy_gen,alloc_flags)	((int)(0))
+
+#endif /* __XFS_EXTENT_BUSY_H__ */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index cf517d4a938a..4cad09d8be61 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -16,6 +16,7 @@
 #include "xfs_rmap.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_extent_busy.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 04e028194e8c..29f6ec1c3f6f 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -14,6 +14,7 @@
 #include "xfs_btree_staging.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_extent_busy.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
 #include "xfs_trace.h"
diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index 12ce312d1e50..2ff9d1e56b47 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -10,6 +10,7 @@
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_extent_busy.h"
 #include "xfs_group.h"
 
 /*
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 7c62a40af458..542e633f0ffe 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -384,21 +384,6 @@ xfs_buf_readahead(
 #define xfs_sort_inodes(i_tab, nr)			((void) 0)
 
 /* space allocation */
-#define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
-#define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
-
-#define xfs_extent_busy_reuse(...)			((void) 0)
-/* avoid unused variable warning */
-#define xfs_extent_busy_insert(tp,xg,bno,len,flags)({ 	\
-	struct xfs_group *__foo = xg;			\
-	__foo = __foo; /* no set-but-unused warning */	\
-})
-#define xfs_extent_busy_trim(group,minlen,maxlen,bno,len,busy_gen) 	({	\
-	unsigned __foo = *(busy_gen);				\
-	*(busy_gen) = __foo;					\
-	false;							\
-})
-#define xfs_extent_busy_flush(tp,pag,busy_gen,alloc_flags)	((int)(0))
 
 #define xfs_rotorstep				1
 #define xfs_bmap_rtalloc(a)			(-ENOSYS)
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 6e2a32d8382c..10b3272238eb 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -19,6 +19,7 @@
 #include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_extent_busy.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_buf_mem.h"
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index d46a1617d076..6a0fc1032753 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -21,6 +21,7 @@
 #include "xfs_health.h"
 #include "xfs_sb.h"
 #include "xfs_errortag.h"
+#include "xfs_extent_busy.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 6a6e85c413e0..22acc1411aac 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -23,6 +23,7 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_error.h"
+#include "xfs_extent_busy.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 81d517b94e46..c264bc5651c0 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -24,6 +24,7 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_error.h"
+#include "xfs_extent_busy.h"
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
-- 
2.53.0

