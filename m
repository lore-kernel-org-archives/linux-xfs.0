Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54256 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/12] uapi/fs: add O_ATOMIC to the open flags
Date: Tue, 28 Feb 2017 06:57:26 -0800
Message-Id: <20170228145737.19016-2-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fcntl.c                       | 3 ++-
 include/uapi/asm-generic/fcntl.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index e1c54f20325c..ca5d228be7ea 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -741,7 +741,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(22 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
@@ -749,6 +749,7 @@ static int __init fcntl_init(void)
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
 		__FMODE_EXEC	| O_PATH	| __O_TMPFILE	|
+		O_ATOMIC	|
 		__FMODE_NONOTIFY
 		));
 
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index e063effe0cc1..26ab7622238a 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -92,6 +92,8 @@
 #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
 #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT)      
 
+#define O_ATOMIC	040000000
+
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
-- 
2.11.0

