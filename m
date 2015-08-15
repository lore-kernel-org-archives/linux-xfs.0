Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 62DD37F66
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:44:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7D4AAC003
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:44:21 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id rM13EKGgWhOH738r (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:44:20 -0700 (PDT)
Subject: [PATCH 06/10] xfs_repair: mark unreachable prefetched metadata
	blocks stale
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Aug 2015 18:44:17 -0700
Message-ID: <20150815014416.1839.40518.stgit@birch.djwong.org>
In-Reply-To: <20150815014338.1839.37405.stgit@birch.djwong.org>
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

When we're running xfs_repair with prefetch enabled, it's possible
that repair will decide to clear an inode without examining all
metadata blocks owned by that inode.  This leaves the unreferenced
prefetched buffers marked UNCHECKED, which will cause a subsequent CRC
error if the block is reallocated to a different structure and read
more than once.  Typically this happens when a large directory is
corrupted and lost+found has to grow to accomodate all the
disconnected inodes.

Therefore, clear the UNCHECKED flag and set the STALE flag to get rid
of the CRC errors and ensure that the blocks aren't written back out
to disk without first being marked dirty.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |    5 +++++
 repair/phase6.c |    4 ++++
 repair/scan.c   |   36 ++++++++++++++++++++++++++++++++++++
 repair/scan.h   |    2 ++
 4 files changed, 47 insertions(+)


diff --git a/repair/phase4.c b/repair/phase4.c
index e0571e8..13b2946 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -30,6 +30,7 @@
 #include "versions.h"
 #include "dir2.h"
 #include "progress.h"
+#include "scan.h"
 
 
 /*
@@ -300,6 +301,10 @@ phase4(xfs_mount_t *mp)
 	 * already in phase 3.
 	 */
 	process_ags(mp);
+
+	/* Mark stale anything we didn't get to. */
+	mark_unchecked_buffers_stale();
+
 	print_final_rpt();
 
 	/*
diff --git a/repair/phase6.c b/repair/phase6.c
index 467f119..5edaa30 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -29,6 +29,7 @@
 #include "dinode.h"
 #include "progress.h"
 #include "versions.h"
+#include "scan.h"
 
 static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
@@ -3312,6 +3313,9 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 	 */
 	traverse_ags(mp);
 
+	/* Mark stale anything we didn't get to. */
+	mark_unchecked_buffers_stale();
+
 	/*
 	 * any directories that had updated ".." entries, rebuild them now
 	 */
diff --git a/repair/scan.c b/repair/scan.c
index 1e7a4da..431fd24 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -29,6 +29,7 @@
 #include "bmap.h"
 #include "progress.h"
 #include "threads.h"
+#include "cache.h"
 
 static xfs_mount_t	*mp = NULL;
 
@@ -1804,3 +1805,38 @@ scan_ags(
 	}
 }
 
+static void
+mark_buf_stale(
+	struct cache_node	*cn)
+{
+	struct xfs_buf		*bp = (struct xfs_buf *)cn;
+
+	if (bp->b_flags & LIBXFS_B_UNCHECKED) {
+		bp->b_flags &= ~LIBXFS_B_UNCHECKED;
+		bp->b_flags |= LIBXFS_B_STALE;
+	}
+}
+
+/*
+ * Find unchecked buffers and mark them checked and stale.
+ *
+ * When prefetch is enabled, buffers will be marked unchecked if they fail
+ * verification.  Actually examining the block clears the unchecked flag, so
+ * any buffer still unchecked at the end of the examination represents an
+ * unreachable block.  A block that was reachable during prefetch but isn't
+ * by the end of the examination was owned by something that was freed as
+ * part of the exam.  Therefore, the buffer can be considered free.  Therefore,
+ * set the stale flag so that getbuf and readbuf know to zero the buffer
+ * contents the next time the buffer is accessed.
+ *
+ * This also fixes the problem that repair reports CRC errors if the block is
+ * subsequently allocated to something else, reinitialized, and re-read.  This
+ * can happen if a directory with a corrupt dir3 leaf block is erased and the
+ * leaf block gets reused to grow lost+found during phase 7.
+ */
+void
+mark_unchecked_buffers_stale(void)
+{
+	cache_walk(libxfs_bcache, mark_buf_stale);
+}
+
diff --git a/repair/scan.h b/repair/scan.h
index ea8c0bf..d232a54 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -70,4 +70,6 @@ scan_ags(
 	struct xfs_mount	*mp,
 	int			scan_threads);
 
+void mark_unchecked_buffers_stale(void);
+
 #endif /* _XR_SCAN_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
