Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49448 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030394AbeEYWMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 18:12:34 -0400
Subject: [PATCH 7/7] libxfs: remove crc32 functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 May 2018 15:12:20 -0700
Message-ID: <152728634020.22515.16684194597988861920.stgit@magnolia>
In-Reply-To: <152728629694.22515.17699396814561914788.stgit@magnolia>
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

XFS uses crc32c, not crc32.  Remove the unnecessary crc32 code, which
decreases binary size by the 8K crc32 table.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h        |    3 ---
 libxfs/crc32.c          |   16 ++++++++++------
 libxfs/gen_crc32table.c |    8 +++++++-
 libxfs/libxfs_priv.h    |    3 ---
 4 files changed, 17 insertions(+), 13 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index fbaae089..109866de 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -43,10 +43,7 @@
 
 
 /* CRC stuff, buffer API dependent on it */
-extern uint32_t crc32_le(uint32_t crc, unsigned char const *p, size_t len);
 extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
-
-#define crc32(c,p,l)	crc32_le((c),(unsigned char const *)(p),(l))
 #define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
 
 #include "xfs_cksum.h"
diff --git a/libxfs/crc32.c b/libxfs/crc32.c
index 783d62e9..8fe5c42c 100644
--- a/libxfs/crc32.c
+++ b/libxfs/crc32.c
@@ -176,20 +176,26 @@ static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
 }
 
 #if CRC_LE_BITS == 1
+/*
+ * not used by xfs.
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len, NULL, CRCPOLY_LE);
 }
+ */
 u32 __pure crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len, NULL, CRC32C_POLY_LE);
 }
 #else
+/*
+ * not used by xfs.
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len,
 			(const u32 (*)[256])crc32table_le, CRCPOLY_LE);
 }
+ */
 u32 __pure crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len,
@@ -970,6 +976,7 @@ static int crc32c_test(void)
 	return errors;
 }
 
+#if 0	/* not used by xfs */
 static int crc32_test(void)
 {
 	int i;
@@ -989,10 +996,8 @@ static int crc32_test(void)
 		crc ^= crc32_le(test[i].crc, test_buf +
 		    test[i].start, test[i].length);
 
-#if 0 /* not used */
 		crc ^= crc32_be(test[i].crc, test_buf +
 		    test[i].start, test[i].length);
-#endif
 	}
 
 	gettimeofday(&start, NULL);
@@ -1001,11 +1006,9 @@ static int crc32_test(void)
 		    test[i].start, test[i].length))
 			errors++;
 
-#if 0 /* not used */
 		if (test[i].crc_be != crc32_be(test[i].crc, test_buf +
 		    test[i].start, test[i].length))
 			errors++;
-#endif
 	}
 	gettimeofday(&stop, NULL);
 
@@ -1021,6 +1024,8 @@ static int crc32_test(void)
 
 	return errors;
 }
+#endif
+
 /*
  * make sure we always return 0 for a successful test run, and non-zero for a
  * failed run. The build infrastructure is looking for this information to
@@ -1032,8 +1037,7 @@ int main(int argc, char **argv)
 
 	printf("CRC_LE_BITS = %d\n", CRC_LE_BITS);
 
-	errors = crc32_test();
-	errors += crc32c_test();
+	errors = crc32c_test();
 
 	return errors != 0;
 }
diff --git a/libxfs/gen_crc32table.c b/libxfs/gen_crc32table.c
index 574a2d1a..d81164b7 100644
--- a/libxfs/gen_crc32table.c
+++ b/libxfs/gen_crc32table.c
@@ -20,7 +20,10 @@
 # define BE_TABLE_SIZE (1 << CRC_BE_BITS)
 #endif
 
+/*
+ * crc32 not used by xfs.
 static uint32_t crc32table_le[LE_TABLE_ROWS][256];
+ */
 static uint32_t crc32ctable_le[LE_TABLE_ROWS][256];
 
 /*
@@ -57,10 +60,13 @@ static void crc32init_le_generic(const uint32_t polynomial,
 	}
 }
 
+/*
+ * crc32 not used by xfs.
 static void crc32init_le(void)
 {
 	crc32init_le_generic(CRCPOLY_LE, crc32table_le);
 }
+ */
 
 static void crc32cinit_le(void)
 {
@@ -112,6 +118,7 @@ int main(int argc, char** argv)
 {
 	printf("/* this file is generated - do not edit */\n\n");
 
+#if 0	/* not used by xfsprogs */
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
 		printf("static u32 crc32table_le[%d][%d] = {",
@@ -121,7 +128,6 @@ int main(int argc, char** argv)
 		printf("};\n");
 	}
 
-#if 0	/* not used by xfsprogs */
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
 		printf("static u32 crc32table_be[%d][%d] = {",
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index e5eb3de1..fae32411 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -67,10 +67,7 @@
 #include "xfs_fs.h"
 
 /* CRC stuff, buffer API dependent on it */
-extern uint32_t crc32_le(uint32_t crc, unsigned char const *p, size_t len);
 extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
-
-#define crc32(c,p,l)	crc32_le((c),(unsigned char const *)(p),(l))
 #define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
 
 #include "xfs_cksum.h"

