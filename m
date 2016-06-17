Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B8ED08442
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:46:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 34812AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:46:03 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id gas3F75qtwui3ZmZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:46:01 -0700 (PDT)
Subject: [PATCH 144/145] xfs: add btree scrub tracepoints
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:45:54 -0700
Message-ID: <146612795427.16048.13096589914276724799.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trace.h |    3 +++
 libxfs/xfs_scrub.c  |   14 ++++++++++++++
 2 files changed, 17 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index ce973ba..206e550 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -276,6 +276,9 @@
 #define trace_xfs_rmap_map_done(...)		((void) 0)
 #define trace_xfs_rmap_map_error(...)		((void) 0)
 
+#define trace_xfs_btree_scrub_key(...)		((void) 0)
+#define trace_xfs_btree_scrub_rec(...)		((void) 0)
+
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_get_tag(a,b,c,d) ((c) = (c))
diff --git a/libxfs/xfs_scrub.c b/libxfs/xfs_scrub.c
index 750c482..bd9669d 100644
--- a/libxfs/xfs_scrub.c
+++ b/libxfs/xfs_scrub.c
@@ -34,6 +34,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
+#include "xfs_trace.h"
 #include "xfs_scrub.h"
 
 static const char * const btree_types[] = {
@@ -88,6 +89,12 @@ xfs_btree_scrub_rec(
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*keyblock;
 
+	trace_xfs_btree_scrub_rec(cur->bc_mp, cur->bc_private.a.agno,
+			XFS_FSB_TO_AGBNO(cur->bc_mp,
+				XFS_DADDR_TO_FSB(cur->bc_mp,
+					cur->bc_bufs[0]->b_bn)),
+			cur->bc_btnum, 0, cur->bc_nlevels, cur->bc_ptrs[0]);
+
 	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[0]);
 	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
 
@@ -135,6 +142,13 @@ xfs_btree_scrub_key(
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*keyblock;
 
+	trace_xfs_btree_scrub_key(cur->bc_mp, cur->bc_private.a.agno,
+			XFS_FSB_TO_AGBNO(cur->bc_mp,
+				XFS_DADDR_TO_FSB(cur->bc_mp,
+					cur->bc_bufs[level]->b_bn)),
+			cur->bc_btnum, level, cur->bc_nlevels,
+			cur->bc_ptrs[level]);
+
 	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[level]);
 	key = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
