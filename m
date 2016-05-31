Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3DF3A7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 12:37:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADF90AC007
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 10:37:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BQnqbzNA4ztePJjP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 10:37:27 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 2FC0C7F6A2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 17:37:26 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-61-108.rdu2.redhat.com
	[10.10.61.108])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4VHbPDg025164
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 13:37:25 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH V2] xfs_repair: further improvement on secondary superblock
	search method
Date: Tue, 31 May 2016 12:37:24 -0500
Message-Id: <1464716244-2401-1-git-send-email-billodo@redhat.com>
In-Reply-To: <1463085496-17919-1-git-send-email-billodo@redhat.com>
References: <1463085496-17919-1-git-send-email-billodo@redhat.com>
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

v2: simplify verify_sb_blocksize function.
    remove unneeded parentheses.
    remove redundant warns about attempt to find secondary sb.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 repair/sb.c | 78 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

diff --git a/repair/sb.c b/repair/sb.c
index 7e4708c..3965953 100644
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
@@ -85,6 +83,21 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	memset(source->sb_fname, 0, 12);
 }
 
+int
+verify_sb_blocksize(xfs_sb_t *sb)
+{
+	/* check to make sure blocksize is legal 2^N, 9 <= N <= 16 */
+	if (sb->sb_blocksize == 0)
+		return XR_BAD_BLOCKSIZE;
+	if (sb->sb_blocksize != (1 << sb->sb_blocklog))
+		return XR_BAD_BLOCKLOG;
+	if (sb->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG ||
+	    sb->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG)
+		return XR_BAD_BLOCKLOG;
+
+	return 0;
+}
+
 /*
  * find a secondary superblock, copy it into the sb buffer.
  * start is the point to begin reading BSIZE bytes.
@@ -106,8 +119,6 @@ __find_secondary_sb(
 	int		retval;
 	int		bsize;
 
-	do_warn(_("\nattempting to find secondary superblock...\n"));
-
 	sb = (xfs_sb_t *)memalign(libxfs_device_alignment(), BSIZE);
 	if (!sb) {
 		do_error(
@@ -205,29 +216,36 @@ guess_default_geometry(
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
+	do_warn(_("\nattempting to find secondary superblock...\n"));
 
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
+		if (skip >= XFS_AG_MIN_BYTES && skip <= XFS_AG_MAX_BYTES)
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
 
@@ -328,6 +346,7 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 {
 	__uint32_t	bsize;
 	int		i;
+	int		ret;
 
 	/* check magic number and version number */
 
@@ -369,23 +388,10 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
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
