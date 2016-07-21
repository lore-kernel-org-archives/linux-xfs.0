Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D57EF7CA3
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:59:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A24B304043
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:51 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id f1etl9wtLm124Sso (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:50 -0700 (PDT)
Subject: [PATCH 33/47] xfs: add tracepoints for the rmap functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:59:43 -0700
Message-ID: <146907718334.25461.12980211617938579982.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trace.h |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e69912a..7498c77 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2417,8 +2417,6 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_cancel);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
 
-DEFINE_MAP_EXTENT_DEFERRED_EVENT(xfs_defer_map_extent);
-
 #define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
@@ -2502,8 +2500,57 @@ DEFINE_RMAP_EVENT(xfs_rmap_map);
 DEFINE_RMAP_EVENT(xfs_rmap_map_done);
 DEFINE_AG_ERROR_EVENT(xfs_rmap_map_error);
 
+DECLARE_EVENT_CLASS(xfs_rmapbt_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 uint64_t owner, uint64_t offset, unsigned int flags),
+	TP_ARGS(mp, agno, agbno, len, owner, offset, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->owner = owner;
+		__entry->offset = offset;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+);
+#define DEFINE_RMAPBT_EVENT(name) \
+DEFINE_EVENT(xfs_rmapbt_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 uint64_t owner, uint64_t offset, unsigned int flags), \
+	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
+
+#define DEFINE_RMAP_DEFERRED_EVENT DEFINE_MAP_EXTENT_DEFERRED_EVENT
+DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_defer);
+DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_deferred);
+
 DEFINE_BUSY_EVENT(xfs_rmapbt_alloc_block);
 DEFINE_BUSY_EVENT(xfs_rmapbt_free_block);
+DEFINE_RMAPBT_EVENT(xfs_rmap_update);
+DEFINE_RMAPBT_EVENT(xfs_rmap_insert);
+DEFINE_RMAPBT_EVENT(xfs_rmap_delete);
+DEFINE_AG_ERROR_EVENT(xfs_rmap_insert_error);
+DEFINE_AG_ERROR_EVENT(xfs_rmap_delete_error);
+DEFINE_AG_ERROR_EVENT(xfs_rmap_update_error);
 
 #endif /* _TRACE_XFS_H */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
