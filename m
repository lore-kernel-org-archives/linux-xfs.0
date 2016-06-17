Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4CFF77D21
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:20:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 11AF6304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:20:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id irKx1wMM0KwyqXP6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:20:18 -0700 (PDT)
Subject: [PATCH 022/119] xfs: add tracepoints and error injection for
	deferred extent freeing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:20:13 -0700
Message-ID: <146612641307.12839.12827584555660167380.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Add a couple of tracepoints for the deferred extent free operation and
a site for injecting errors while finishing the operation.  This makes
it easier to debug deferred ops and test log redo.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    7 +++++++
 fs/xfs/libxfs/xfs_bmap.c  |    2 ++
 fs/xfs/xfs_error.h        |    4 +++-
 fs/xfs/xfs_trace.h        |    5 ++++-
 4 files changed, 16 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c06b463..56c8690 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2704,6 +2704,13 @@ xfs_free_extent(
 
 	ASSERT(len != 0);
 
+	trace_xfs_bmap_free_deferred(mp, agno, 0, agbno, len);
+
+	if (XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_FREE_EXTENT,
+			XFS_RANDOM_FREE_EXTENT))
+		return -EIO;
+
 	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 85061a0..3a6d3e3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -596,6 +596,8 @@ xfs_bmap_add_free(
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xbfi_startblock = bno;
 	new->xbfi_blockcount = (xfs_extlen_t)len;
+	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
+			XFS_FSB_TO_AGBNO(mp, bno), len);
 	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xbfi_list);
 }
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 4ed3042..ee4680e 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -90,7 +90,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_ERRTAG_STRATCMPL_IOERR			19
 #define XFS_ERRTAG_DIOWRITE_IOERR			20
 #define XFS_ERRTAG_BMAPIFORMAT				21
-#define XFS_ERRTAG_MAX					22
+#define XFS_ERRTAG_FREE_EXTENT				22
+#define XFS_ERRTAG_MAX					23
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -117,6 +118,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_STRATCMPL_IOERR			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_DIOWRITE_IOERR			(XFS_RANDOM_DEFAULT/10)
 #define	XFS_RANDOM_BMAPIFORMAT				XFS_RANDOM_DEFAULT
+#define XFS_RANDOM_FREE_EXTENT				1
 
 #ifdef DEBUG
 extern int xfs_error_test_active;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5923014..777a89c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2415,9 +2415,12 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_cancel);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
 
-DEFINE_PHYS_EXTENT_DEFERRED_EVENT(xfs_defer_phys_extent);
 DEFINE_MAP_EXTENT_DEFERRED_EVENT(xfs_defer_map_extent);
 
+#define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
+DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
+DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
