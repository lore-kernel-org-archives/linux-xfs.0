Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC64D7CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 15:38:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF0D9304043
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 13:38:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id A50AULgYgp50eXLt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 13:38:18 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id BE9596266A
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 20:38:17 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-56-29.rdu2.redhat.com
	[10.10.56.29])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4CKcH1M012172
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 16:38:17 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH] xfs_repair: further improvement on secondary superblock
	search method
Date: Thu, 12 May 2016 15:38:16 -0500
Message-Id: <1463085496-17919-1-git-send-email-billodo@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch is a further optimization of secondary sb search, in order to
handle non-default geometries. Once again, use a similar method to find
fs geometry as that of xfs_mkfs. Refactor verify_sb(), creating new
sub-function that checks sanity of agblocks and agcount: verify_sb_blocksize().

If verify_sb_blocksize verifies sane paramters, use found values for the sb
search. Otherwise, try search with default values. If these faster methods
both fail, fall back to original brute force slower search.

NOTE: patch series "xfs_repair: improved secondary sb search" must be
applied before applying this patch.
(http://oss.sgi.com/archives/xfs/2016-05/msg00269.html)

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 repair/sb.c | 87 ++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 35 deletions(-)

diff --git a/repair/sb.c b/repair/sb.c
index 7e4708c..ebe0c60 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -23,12 +23,10 @@
 #include "globals.h"
 #include "protos.h"
 #include "err_protos.h"
+#include "xfs_multidisk.h"
 
 #define BSIZE	(1024 * 1024)
 
-#define XFS_AG_BYTES(bblog)	((long long)BBSIZE << (bblog))
-#define	XFS_AG_MIN_BYTES	((XFS_AG_BYTES(15)))	/* 16 MB */
-
 /*
  * copy the fields of a superblock that are present in primary and
  * secondaries -- preserve fields that are different in the primary.
@@ -85,6 +83,32 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	memset(source->sb_fname, 0, 12);
 }
 
+int
+verify_sb_blocksize(xfs_sb_t *sb)
+{
+	__uint32_t	bsize;
+	int		i;
+
+	/* check to make sure blocksize is legal 2^N, 9 <= N <= 16 */
+	if (sb->sb_blocksize == 0)
+		return(XR_BAD_BLOCKSIZE);
+
+	bsize = 1;
+
+	for (i = 0; bsize < sb->sb_blocksize &&
+		i < sizeof(sb->sb_blocksize) * NBBY; i++)
+		bsize <<= 1;
+
+	if (i < XFS_MIN_BLOCKSIZE_LOG || i > XFS_MAX_BLOCKSIZE_LOG)
+		return(XR_BAD_BLOCKSIZE);
+
+	/* check sb blocksize field against sb blocklog field */
+	if (i != sb->sb_blocklog)
+		return(XR_BAD_BLOCKLOG);
+
+	return 0;
+}
+
 /*
  * find a secondary superblock, copy it into the sb buffer.
  * start is the point to begin reading BSIZE bytes.
@@ -205,29 +229,34 @@ guess_default_geometry(
 int
 find_secondary_sb(xfs_sb_t *rsb)
 {
-	int		retval;
+	int		retval = 0;
 	__uint64_t	agcount;
 	__uint64_t	agsize;
 	__uint64_t	skip;
 	int		blocklog;
 
 	/*
-	 * Attempt to find secondary sb with a coarse approach.
-	 * Failing that, fallback to a fine-grained approach.
+	 * Attempt to find secondary sb with a coarse approach,
+	 * first trying agblocks and blocksize read from sb, providing
+	 * they're sane.
 	 */
-	blocklog = guess_default_geometry(&agsize, &agcount, &x);
-
-	/*
-	 * use found ag geometry to quickly find secondary sb
-	 */
-	skip = agsize << blocklog;
-	retval = __find_secondary_sb(rsb, skip, skip);
-	if (!retval)  {
-		/*
-		 * fallback: Start at min agsize and scan all blocks
-		 */
-		retval = __find_secondary_sb(rsb, XFS_AG_MIN_BYTES, BSIZE);
+	if (verify_sb_blocksize(rsb) == 0) {
+		skip = rsb->sb_agblocks * rsb->sb_blocksize;
+		if ((skip >= XFS_AG_MIN_BYTES) && (skip <= XFS_AG_MAX_BYTES))
+			retval = __find_secondary_sb(rsb, skip, skip);
 	}
+
+        /* If that failed, retry coarse approach, using default geometry */
+        if (!retval) {
+                blocklog = guess_default_geometry(&agsize, &agcount, &x);
+                skip = agsize << blocklog;
+                retval = __find_secondary_sb(rsb, skip, skip);
+        }
+
+        /* If that failed, fall back to the brute force method */
+        if (!retval)
+                retval = __find_secondary_sb(rsb, XFS_AG_MIN_BYTES, BSIZE);
+
 	return retval;
 }
 
@@ -328,6 +357,7 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 {
 	__uint32_t	bsize;
 	int		i;
+	int		ret;
 
 	/* check magic number and version number */
 
@@ -369,23 +399,10 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 	    !xfs_verify_cksum(sb_buf, sb->sb_sectsize, XFS_SB_CRC_OFF))
 		return XR_BAD_CRC;
 
-	/* check to make sure blocksize is legal 2^N, 9 <= N <= 16 */
-	if (sb->sb_blocksize == 0)
-		return(XR_BAD_BLOCKSIZE);
-
-	bsize = 1;
-
-	for (i = 0; bsize < sb->sb_blocksize &&
-		i < sizeof(sb->sb_blocksize) * NBBY; i++)
-		bsize <<= 1;
-
-	if (i < XFS_MIN_BLOCKSIZE_LOG || i > XFS_MAX_BLOCKSIZE_LOG)
-		return(XR_BAD_BLOCKSIZE);
-
-	/* check sb blocksize field against sb blocklog field */
-
-	if (i != sb->sb_blocklog)
-		return(XR_BAD_BLOCKLOG);
+	/* check to ensure blocksize and blocklog are legal */
+	ret = verify_sb_blocksize(sb);
+	if (ret != 0)
+		return ret;
 
 	/* sanity check ag count, size fields against data size field */
 
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
