Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFD507CBA
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 13:04:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C30A98F8035
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:04:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9GKh1HWOLpWW9mIo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:03:59 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id BDA1F106E
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 19:03:58 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-59-18.rdu2.redhat.com
	[10.10.59.18])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u1CJ3vCX023782
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 14:03:58 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v4 2/2] xfs_repair: new secondary superblock search method
Date: Fri, 12 Feb 2016 13:03:31 -0600
Message-Id: <1455303811-9874-3-git-send-email-billodo@redhat.com>
In-Reply-To: <1455303811-9874-1-git-send-email-billodo@redhat.com>
References: <1455303811-9874-1-git-send-email-billodo@redhat.com>
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
 Makefile           |  2 +-
 include/libxcmd.h  |  6 +++++-
 libxcmd/topology.c | 27 +++++++++++++++++++++++++++
 repair/Makefile    |  4 ++--
 repair/sb.c        | 49 +++++++++++++++++++++++++++++++++++++++++--------
 5 files changed, 76 insertions(+), 12 deletions(-)

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
diff --git a/include/libxcmd.h b/include/libxcmd.h
index a912534..eb16cd5 100644
--- a/include/libxcmd.h
+++ b/include/libxcmd.h
@@ -51,6 +51,10 @@ extern int
 check_overwrite(
 	char		*device);
 
-
+extern int
+guess_default_geometry(
+	__uint64_t	*agsize,
+	__uint64_t	*agcount,
+	libxfs_init_t	x);
 
 #endif	/* __LIBXCMD_H__ */
diff --git a/libxcmd/topology.c b/libxcmd/topology.c
index 4cbe4b1..ec9695c 100644
--- a/libxcmd/topology.c
+++ b/libxcmd/topology.c
@@ -339,3 +339,30 @@ get_topology(
 				   &lsectorsize, &psectorsize, force_overwrite);
 	}
 }
+
+int
+guess_default_geometry(
+	__uint64_t	*agsize,
+	__uint64_t	*agcount,
+	libxfs_init_t	x)
+{
+	struct fs_topology	ft;
+	int			blocklog;
+	__uint64_t		dblocks;
+	int			multidisk;
+
+	memset(&ft, 0, sizeof(ft));
+	get_topology(&x, &ft, 1);
+
+	/*
+	 * get geometry from get_topology result.
+	 * Use default block size (2^12)
+	 */
+	blocklog = 12;
+	multidisk = ft.dswidth | ft.dsunit;
+	dblocks = x.dsize >> (blocklog - BBSHIFT);
+	calc_default_ag_geometry(blocklog, dblocks, multidisk,
+				 agsize, agcount);
+
+	return blocklog;
+}
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
index 4eef14a..8dcad5f 100644
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
+	xfs_sb_t *rsb,
+	__uint64_t start,
+	__uint64_t skip)
 {
 	xfs_off_t	off;
 	xfs_sb_t	*sb;
@@ -101,7 +107,6 @@ find_secondary_sb(xfs_sb_t *rsb)
 	int		bsize;
 
 	do_warn(_("\nattempting to find secondary superblock...\n"));
-
 	sb = (xfs_sb_t *)memalign(libxfs_device_alignment(), BSIZE);
 	if (!sb) {
 		do_error(
@@ -117,7 +122,7 @@ find_secondary_sb(xfs_sb_t *rsb)
 	/*
 	 * skip first sector since we know that's bad
 	 */
-	for (done = 0, off = XFS_AG_MIN_BYTES; !done ; off += bsize)  {
+	for (done = 0, off = start; !done ; off += skip)  {
 		/*
 		 * read disk 1 MByte at a time.
 		 */
@@ -128,9 +133,7 @@ find_secondary_sb(xfs_sb_t *rsb)
 		if (!done && (bsize = read(x.dfd, sb, BSIZE)) <= 0)  {
 			done = 1;
 		}
-
 		do_warn(".");
-
 		/*
 		 * check the buffer 512 bytes at a time since
 		 * we don't know how big the sectors really are.
@@ -166,7 +169,37 @@ find_secondary_sb(xfs_sb_t *rsb)
 	}
 
 	free(sb);
-	return(retval);
+	return retval;
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
+	 * Attempt to find secondary sb with a coarse approach,
+	 * using a large skip (agsize in bytes). Failing that,
+	 * fallback to the fine-grained approach using min agsize.
+	 */
+	blocklog = guess_default_geometry(&agsize, &agcount, x);
+
+	/*
+	 * use found ag geometry to quickly find secondary sb
+	 */
+	skip = agsize << blocklog;
+	retval = __find_secondary_sb(rsb, skip, skip);
+	if (!retval)  {
+		/*
+		 * fallback: use minimum agsize for skipsize
+		 */
+		retval = __find_secondary_sb(rsb, XFS_AG_MIN_BYTES, BSIZE);
+	}
+	return retval;
 }
 
 /*
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
