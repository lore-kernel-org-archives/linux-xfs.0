Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3A3FE7CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 17:45:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0CEB18F804C
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 15:45:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D0S6mzU0tsVlGrD5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 15:45:31 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 476A185367
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 22:45:31 +0000 (UTC)
Received: from localhost.localdomain.com (unused [10.10.52.194] (may be
	forged))
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4BMjTWJ031072
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 18:45:30 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v5 2/2] xfs_repair: new secondary superblock search method
Date: Wed, 11 May 2016 17:45:17 -0500
Message-Id: <1463006717-6104-3-git-send-email-billodo@redhat.com>
In-Reply-To: <1463006717-6104-1-git-send-email-billodo@redhat.com>
References: <1463006717-6104-1-git-send-email-billodo@redhat.com>
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

Optimize secondary sb search, using similar method to find
fs geometry as that of xfs_mkfs. If this faster method fails
in finding a secondary sb, fall back to original brute force
slower search.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 Makefile        |  2 +-
 repair/Makefile |  4 ++--
 repair/sb.c     | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index fca0a42..1d60d9c 100644
--- a/Makefile
+++ b/Makefile
@@ -80,7 +80,7 @@ fsr: libhandle
 growfs: libxcmd
 io: libxcmd libhandle
 quota: libxcmd
-repair: libxlog
+repair: libxlog libxcmd
 copy: libxlog
 
 ifeq ($(HAVE_BUILDDEFS), yes)
diff --git a/repair/Makefile b/repair/Makefile
index 251722b..d24ab1f 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -20,8 +20,8 @@ CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
 	progress.c prefetch.c rt.c sb.c scan.c threads.c \
 	versions.c xfs_repair.c
 
-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
-LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
+LLDLIBS = $(LIBBLKID) $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBXCMD)
+LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD)
 LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
diff --git a/repair/sb.c b/repair/sb.c
index 4eef14a..7e4708c 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -17,6 +17,7 @@
  */
 
 #include "libxfs.h"
+#include "libxcmd.h"
 #include "libxlog.h"
 #include "agheader.h"
 #include "globals.h"
@@ -85,10 +86,15 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 }
 
 /*
- * find a secondary superblock, copy it into the sb buffer
+ * find a secondary superblock, copy it into the sb buffer.
+ * start is the point to begin reading BSIZE bytes.
+ * skip contains a byte-count of how far to advance for next read.
  */
-int
-find_secondary_sb(xfs_sb_t *rsb)
+static int
+__find_secondary_sb(
+	xfs_sb_t	*rsb,
+	__uint64_t	start,
+	__uint64_t	skip)
 {
 	xfs_off_t	off;
 	xfs_sb_t	*sb;
@@ -117,7 +123,7 @@ find_secondary_sb(xfs_sb_t *rsb)
 	/*
 	 * skip first sector since we know that's bad
 	 */
-	for (done = 0, off = XFS_AG_MIN_BYTES; !done ; off += bsize)  {
+	for (done = 0, off = start; !done ; off += skip)  {
 		/*
 		 * read disk 1 MByte at a time.
 		 */
@@ -166,7 +172,63 @@ find_secondary_sb(xfs_sb_t *rsb)
 	}
 
 	free(sb);
-	return(retval);
+	return retval;
+}
+
+static int
+guess_default_geometry(
+	__uint64_t		*agsize,
+	__uint64_t		*agcount,
+	libxfs_init_t		*x)
+{
+	struct fs_topology	ft;
+	int			blocklog;
+	__uint64_t		dblocks;
+	int			multidisk;
+
+	memset(&ft, 0, sizeof(ft));
+	get_topology(x, &ft, 1);
+
+	/*
+	 * get geometry from get_topology result.
+	 * Use default block size (2^12)
+	 */
+	blocklog = 12;
+	multidisk = ft.dswidth | ft.dsunit;
+	dblocks = x->dsize >> (blocklog - BBSHIFT);
+	calc_default_ag_geometry(blocklog, dblocks, multidisk,
+				 agsize, agcount);
+
+	return blocklog;
+}
+
+int
+find_secondary_sb(xfs_sb_t *rsb)
+{
+	int		retval;
+	__uint64_t	agcount;
+	__uint64_t	agsize;
+	__uint64_t	skip;
+	int		blocklog;
+
+	/*
+	 * Attempt to find secondary sb with a coarse approach.
+	 * Failing that, fallback to a fine-grained approach.
+	 */
+	blocklog = guess_default_geometry(&agsize, &agcount, &x);
+
+	/*
+	 * use found ag geometry to quickly find secondary sb
+	 */
+	skip = agsize << blocklog;
+	retval = __find_secondary_sb(rsb, skip, skip);
+	if (!retval)  {
+		/*
+		 * fallback: Start at min agsize and scan all blocks
+		 */
+		retval = __find_secondary_sb(rsb, XFS_AG_MIN_BYTES, BSIZE);
+	}
+	return retval;
 }
 
 /*
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
