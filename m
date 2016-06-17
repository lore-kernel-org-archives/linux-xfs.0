Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4768E80E5
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:33:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3380AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id UQz22uCkfYCZUdOT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:34 -0700 (PDT)
Subject: [PATCH 026/145] xfs: add tracepoints and error injection for
	deferred extent freeing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:33:27 -0700
Message-ID: <146612720745.16048.11281695022246629048.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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

Add a couple of tracepoints for the deferred extent free operation and
a site for injecting errors while finishing the operation.  This makes
it easier to debug deferred ops and test log redo.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trace.h |    3 +++
 libxfs/xfs_alloc.c  |    7 +++++++
 libxfs/xfs_bmap.c   |    2 ++
 3 files changed, 12 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index dd0d46f..cdabd18 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -184,6 +184,9 @@
 #define trace_xfs_defer_pending_cancel(...)	((void) 0)
 #define trace_xfs_defer_init(...)		((void) 0)
 
+#define trace_xfs_bmap_free_deferred(...)	((void) 0)
+#define trace_xfs_bmap_free_defer(...)		((void) 0)
+
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_get_tag(a,b,c,d) ((c) = (c))
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 8454816..06133c0 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2700,6 +2700,13 @@ xfs_free_extent(
 
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
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5385800..33e181c 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -588,6 +588,8 @@ xfs_bmap_add_free(
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xbfi_startblock = bno;
 	new->xbfi_blockcount = (xfs_extlen_t)len;
+	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
+			XFS_FSB_TO_AGBNO(mp, bno), len);
 	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xbfi_list);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
