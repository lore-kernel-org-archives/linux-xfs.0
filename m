Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43255 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdBBH4j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:56:39 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/19] xfs: make the ASSERT() condition likely
Date: Thu,  2 Feb 2017 08:55:58 +0100
Message-Id: <1486022171-8076-7-git-send-email-hch@lst.de>
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

From: Amir Goldstein <amir73il@gmail.com>

commit bf46ecc3d8cca05f2907cf482755c42c2b11a79d upstream.

The ASSERT() condition is the normal case, not the exception,
so testing the condition should be likely(), not unlikely().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_linux.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 68640fb..1455b2520 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -330,11 +330,11 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
 }
 
 #define ASSERT_ALWAYS(expr)	\
-	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
 #ifdef DEBUG
 #define ASSERT(expr)	\
-	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
 #ifndef STATIC
 # define STATIC noinline
@@ -345,7 +345,7 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
 #ifdef XFS_WARN
 
 #define ASSERT(expr)	\
-	(unlikely(expr) ? (void)0 : asswarn(#expr, __FILE__, __LINE__))
+	(likely(expr) ? (void)0 : asswarn(#expr, __FILE__, __LINE__))
 
 #ifndef STATIC
 # define STATIC static noinline
-- 
2.1.4

