Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Feb 2007 12:26:09 -0800 (PST)
Received: from Perches.com (DSL022.labridge.com [206.117.136.22])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1JKQ1m7032046
	for <linux-xfs@oss.sgi.com>; Mon, 19 Feb 2007 12:26:02 -0800
Received: from [192.168.1.128] ([192.168.1.128])
	by Perches.com (8.9.3/8.9.3) with ESMTP id KAA01908
	for <linux-xfs@oss.sgi.com>; Mon, 19 Feb 2007 10:43:03 -0800
Subject: [PATCH] - remove local random function, use lib/random.c random32()
From: Joe Perches <joe@perches.com>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 11:25:37 -0800
Message-Id: <1171913137.32497.30.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

reducing the number of random number functions

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
index 4363512..200b701 100644
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -78,20 +78,3 @@ assfail(char *expr, char *file, int line)
 	printk("Assertion failed: %s, file: %s, line: %d\n", expr, file, line);
 	BUG();
 }
-
-#if ((defined(DEBUG) || defined(INDUCE_IO_ERRROR)) && !defined(NO_WANT_RANDOM))
-unsigned long random(void)
-{
-	static unsigned long	RandomValue = 1;
-	/* cycles pseudo-randomly through all values between 1 and 2^31 - 2 */
-	register long	rv = RandomValue;
-	register long	lo;
-	register long	hi;
-
-	hi = rv / 127773;
-	lo = rv % 127773;
-	rv = 16807 * lo - 2836 * hi;
-	if (rv <= 0) rv += 2147483647;
-	return RandomValue = rv;
-}
-#endif /* DEBUG || INDUCE_IO_ERRROR || !NO_WANT_RANDOM */
diff --git a/fs/xfs/support/debug.h b/fs/xfs/support/debug.h
index 4f54dca..2cdb4cd 100644
--- a/fs/xfs/support/debug.h
+++ b/fs/xfs/support/debug.h
@@ -40,7 +40,7 @@ extern void assfail(char *expr, char *f, int l);
 # define ASSERT(expr)	((void)0)
 #else
 # define ASSERT(expr)	ASSERT_ALWAYS(expr)
-extern unsigned long random(void);
+# include <linux/random.h>
 #endif
 
 #ifndef STATIC
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index e80dda3..8e9a40a 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -764,7 +764,7 @@ xfs_alloc_ag_vextent_near(
 	 */
 	int		dofirst;	/* set to do first algorithm */
 
-	dofirst = random() & 1;
+	dofirst = random32() & 1;
 #endif
 	/*
 	 * Get a cursor for the by-size btree.
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index b95681b..35df82d 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -80,7 +80,7 @@ xfs_error_test(int error_tag, int *fsidp, char *expression,
 	int i;
 	int64_t fsid;
 
-	if (random() % randfactor)
+	if (random32() % randfactor)
 		return 0;
 
 	memcpy(&fsid, fsidp, sizeof(xfs_fsid_t));
