Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KNAxBK252533 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 18:10:59 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107202310.p6KNAtQa026739@stout.americas.sgi.com>
Date: Wed, 20 Jul 2011 18:10:55 -0500
Subject: [PATCH] xfstests: simplify TRIM_OFF_LEN() in "ltp/fsx.c"
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

A recent commit added a TRIM_OFF_LEN() macro in "ltp/fsx.c":
    5843147e xfstests: fsx fallocate support is b0rked
A later commit fixed a problem with that macro:
    c47d7a51 xfstests: fix modulo-by-zero error in fsx

There is an extra flag parameter in that macro that I didn't like
in either version.  When looking at it the second time around I
concluded that there was no need for the flag after all.

Going back to the first commit, the code that TRIM_OFF_LEN()
replaced had one of two forms:
  - For OP_READ and OP_MAP_READ:
	if (file_size)
		offset %= file_size;
	else
		offset = 0;
	if (offset + size > file_size)
		size = file_size - offset;

  - For all other cases (except OP_TRUNCATE):
	offset %= maxfilelen;
	if (offset + size > maxfilelen)
		size = maxfilelen - offset;

There's no harm in ensuring maxfilelen is non-zero (and doing so
is safer than what's done above).  So both of the above can be
generalized this way:
	if (SIZE_LIMIT)
		offset %= SIZE_LIMIT;
	else
		offset = 0;
	if (offset + size > SIZE_LIMIT)
		size = SIZE_LIMIT - offset;

In other words, there is no need for the extra flag in the macro.

The following patch just does away with it.  It uses the value of
the "size" parameter directly in avoiding a divide-by-zero, and in
the process avoids referencing the global "file_size" within the
macro expansion.

One more thing...  It seems like OP_HOLE_PUNCH should be
limited to the file size rather than to maximum file size
(but that's a separate discussion).

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 ltp/fsx.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: b/ltp/fsx.c
===================================================================
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -987,14 +987,14 @@ docloseopen(void)
 	}
 }
 
-#define TRIM_OFF_LEN(off, len, size, allow_zero_file_size)	\
-do {						\
-	if (allow_zero_file_size || file_size)	\
-		offset %= size;			\
-	else					\
-		offset = 0;			\
-	if (offset + len > size)		\
-		len = size - offset;		\
+#define TRIM_OFF_LEN(off, len, size)	\
+do {					\
+	if (size)			\
+		offset %= size;		\
+	else				\
+		offset = 0;		\
+	if (offset + len > size)	\
+		len = size - offset;	\
 } while (0)
 
 void
@@ -1054,22 +1054,22 @@ test(void)
 
 	switch (op) {
 	case OP_READ:
-		TRIM_OFF_LEN(offset, size, file_size, 0);
+		TRIM_OFF_LEN(offset, size, file_size);
 		doread(offset, size);
 		break;
 
 	case OP_WRITE:
-		TRIM_OFF_LEN(offset, size, maxfilelen, 1);
+		TRIM_OFF_LEN(offset, size, maxfilelen);
 		dowrite(offset, size);
 		break;
 
 	case OP_MAPREAD:
-		TRIM_OFF_LEN(offset, size, file_size, 0);
+		TRIM_OFF_LEN(offset, size, file_size);
 		domapread(offset, size);
 		break;
 
 	case OP_MAPWRITE:
-		TRIM_OFF_LEN(offset, size, maxfilelen, 1);
+		TRIM_OFF_LEN(offset, size, maxfilelen);
 		domapwrite(offset, size);
 		break;
 
@@ -1080,12 +1080,12 @@ test(void)
 		break;
 
 	case OP_FALLOCATE:
-		TRIM_OFF_LEN(offset, size, maxfilelen, 1);
+		TRIM_OFF_LEN(offset, size, maxfilelen);
 		do_preallocate(offset, size);
 		break;
 
 	case OP_PUNCH_HOLE:
-		TRIM_OFF_LEN(offset, size, maxfilelen, 1);
+		TRIM_OFF_LEN(offset, size, maxfilelen);
 		do_punch_hole(offset, size);
 		break;
 	default:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
