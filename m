Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36004 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbdJ0QTk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2017 12:19:40 -0400
Date: Fri, 27 Oct 2017 09:19:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 10/10] misc: fix ubsan warnings
Message-ID: <20171027161935.GJ5483@magnolia>
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905615569.28563.17233201567221670601.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150905615569.28563.17233201567221670601.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Fix all the things ubsan warned about.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/bitops.h   |    8 ++++----
 include/command.h  |    6 +++---
 include/xfs_arch.h |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/bitops.h b/include/bitops.h
index 44599a7..7774950 100644
--- a/include/bitops.h
+++ b/include/bitops.h
@@ -13,19 +13,19 @@ static inline int fls(int x)
 	if (!x)
 		return 0;
 	if (!(x & 0xffff0000u)) {
-		x <<= 16;
+		x = (x & 0xffffu) << 16;
 		r -= 16;
 	}
 	if (!(x & 0xff000000u)) {
-		x <<= 8;
+		x = (x & 0xffffffu) << 8;
 		r -= 8;
 	}
 	if (!(x & 0xf0000000u)) {
-		x <<= 4;
+		x = (x & 0xfffffffu) << 4;
 		r -= 4;
 	}
 	if (!(x & 0xc0000000u)) {
-		x <<= 2;
+		x = (x & 0x3fffffffu) << 2;
 		r -= 2;
 	}
 	if (!(x & 0x80000000u)) {
diff --git a/include/command.h b/include/command.h
index fb3f5c7..a7fe6eb 100644
--- a/include/command.h
+++ b/include/command.h
@@ -25,9 +25,9 @@
  * not iterate the command args function callout and so can be used
  * for functions like "help" that should only ever be run once.
  */
-#define CMD_FLAG_ONESHOT	(1<<31)
-#define CMD_FLAG_FOREIGN_OK	(1<<30)	/* command not restricted to XFS */
-#define CMD_FLAG_LIBRARY	(1<<29)	/* command provided by libxcmd */
+#define CMD_FLAG_ONESHOT	(1u << 31)
+#define CMD_FLAG_FOREIGN_OK	(1u << 30) /* command not restricted to XFS */
+#define CMD_FLAG_LIBRARY	(1u << 29) /* command provided by libxcmd */
 
 typedef int (*cfunc_t)(int argc, char **argv);
 typedef void (*helpfunc_t)(void);
diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index 186cadb..34fcd4d 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -253,7 +253,7 @@ static inline uint16_t get_unaligned_be16(void *p)
 static inline uint32_t get_unaligned_be32(void *p)
 {
 	uint8_t *__p = p;
-        return __p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3];
+        return (uint32_t)__p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3];
 }
 
 static inline uint64_t get_unaligned_be64(void *p)
