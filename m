Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36827 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939138AbdAJPjc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 10:39:32 -0500
Received: by mail-wm0-f68.google.com with SMTP id r126so10293145wmr.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 07:39:32 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v7 1/6] xfs: make the ASSERT() condition likely
Date: Tue, 10 Jan 2017 17:39:12 +0200
Message-Id: <1484062757-12433-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
References: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

The ASSERT() condition is the normal case, not the exception,
so testing the condition should be likely(), not unlikely().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_linux.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index e467218..7a989de 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -331,11 +331,11 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
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
@@ -346,7 +346,7 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
 #ifdef XFS_WARN
 
 #define ASSERT(expr)	\
-	(unlikely(expr) ? (void)0 : asswarn(#expr, __FILE__, __LINE__))
+	(likely(expr) ? (void)0 : asswarn(#expr, __FILE__, __LINE__))
 
 #ifndef STATIC
 # define STATIC static noinline
-- 
2.7.4

