Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8FBCC800B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:30:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F6148F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:52 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id efYMYlt6G9hC5zAc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:49 -0700 (PDT)
Subject: [PATCH 119/119] xfs: add btree scrub tracepoints
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:30:41 -0700
Message-ID: <146612704152.12839.9204196958776547302.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_scrub.c |   14 ++++++++++++++
 fs/xfs/xfs_trace.h        |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_scrub.c b/fs/xfs/libxfs/xfs_scrub.c
index d43d5c5..d43e742 100644
--- a/fs/xfs/libxfs/xfs_scrub.c
+++ b/fs/xfs/libxfs/xfs_scrub.c
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
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9fe812f..e295374 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3428,6 +3428,46 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
+/* scrub */
+DECLARE_EVENT_CLASS(xfs_scrub_sbtree_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t bno,
+		 xfs_btnum_t btnum, int level, int nlevels, int ptr),
+	TP_ARGS(mp, agno, bno, btnum, level, nlevels, ptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_btnum_t, btnum)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(int, level)
+		__field(int, nlevels)
+		__field(int, ptr)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->btnum = btnum;
+		__entry->bno = bno;
+		__entry->level = level;
+		__entry->nlevels = nlevels;
+		__entry->ptr = ptr;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u btnum %d level %d nlevels %d ptr %d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->btnum,
+		  __entry->level,
+		  __entry->nlevels,
+		  __entry->ptr)
+)
+#define DEFINE_SCRUB_SBTREE_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_sbtree_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t bno, \
+		 xfs_btnum_t btnum, int level, int nlevels, int ptr), \
+	TP_ARGS(mp, agno, bno, btnum, level, nlevels, ptr))
+DEFINE_SCRUB_SBTREE_EVENT(xfs_btree_scrub_rec);
+DEFINE_SCRUB_SBTREE_EVENT(xfs_btree_scrub_key);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
