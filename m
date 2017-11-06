Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38506 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbdKFOfD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 09:35:03 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eBiUR-0000tc-Cc
        for linux-xfs@vger.kernel.org; Mon, 06 Nov 2017 14:35:03 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] xfs: always define STATIC to static noinline
Date: Mon,  6 Nov 2017 15:34:49 +0100
Message-Id: <20171106143456.13567-2-hch@lst.de>
In-Reply-To: <20171106143456.13567-1-hch@lst.de>
References: <20171106143456.13567-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Ever since we added the noinline tag there is no good reason to define
away the static for debug builds - we'll get just as good debug
information with our without it, so don't mess up sparse and other
checkers due to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs.h       |  1 -
 fs/xfs/xfs_linux.h | 14 ++------------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index 80cd0fd86783..5ff7f228d616 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -19,7 +19,6 @@
 #define __XFS_H__
 
 #ifdef CONFIG_XFS_DEBUG
-#define STATIC
 #define DEBUG 1
 #define XFS_BUF_LOCK_TRACKING 1
 #endif
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 00a5efeec496..6282bfc1afa9 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -250,10 +250,6 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
-#ifndef STATIC
-# define STATIC noinline
-#endif
-
 #else	/* !DEBUG */
 
 #ifdef XFS_WARN
@@ -261,21 +257,15 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : asswarn(#expr, __FILE__, __LINE__))
 
-#ifndef STATIC
-# define STATIC static noinline
-#endif
-
 #else	/* !DEBUG && !XFS_WARN */
 
 #define ASSERT(expr)	((void)0)
 
-#ifndef STATIC
-# define STATIC static noinline
-#endif
-
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
+#define STATIC static noinline
+
 #ifdef CONFIG_XFS_RT
 
 /*
-- 
2.14.2

