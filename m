Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 291D47D22
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:32:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E113D8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:32:36 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5oP2cHL8ScRC68xe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:32:35 -0700 (PDT)
Subject: [PATCH 05/71] xfs: introduce tracepoints for AG reservation code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:32:31 -0700
Message-ID: <147216795137.867.2930536284130968371.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trace.h |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7e88bec..6eae816 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2558,6 +2558,75 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_lookup_le_range_result);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);
 
+/* dummy definitions to avoid breaking bisectability; will be removed later */
+#ifndef XFS_AG_RESV_DUMMY
+#define XFS_AG_RESV_DUMMY
+enum xfs_ag_resv_type {
+	XFS_AG_RESV_NONE = 0,
+	XFS_AG_RESV_METADATA,
+	XFS_AG_RESV_AGFL,
+};
+struct xfs_ag_resv {
+	xfs_extlen_t	ar_reserved;
+	xfs_extlen_t	ar_asked;
+};
+#define xfs_perag_resv(...)	NULL
+#endif
+
+/* per-AG reservation */
+DECLARE_EVENT_CLASS(xfs_ag_resv_class,
+	TP_PROTO(struct xfs_perag *pag, enum xfs_ag_resv_type resv,
+		 xfs_extlen_t len),
+	TP_ARGS(pag, resv, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, resv)
+		__field(xfs_extlen_t, freeblks)
+		__field(xfs_extlen_t, flcount)
+		__field(xfs_extlen_t, reserved)
+		__field(xfs_extlen_t, asked)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		struct xfs_ag_resv	*r = xfs_perag_resv(pag, resv);
+
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->resv = resv;
+		__entry->freeblks = pag->pagf_freeblks;
+		__entry->flcount = pag->pagf_flcount;
+		__entry->reserved = r ? r->ar_reserved : 0;
+		__entry->asked = r ? r->ar_asked : 0;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d agno %u resv %d freeblks %u flcount %u resv %u ask %u len %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->resv,
+		  __entry->freeblks,
+		  __entry->flcount,
+		  __entry->reserved,
+		  __entry->asked,
+		  __entry->len)
+)
+#define DEFINE_AG_RESV_EVENT(name) \
+DEFINE_EVENT(xfs_ag_resv_class, name, \
+	TP_PROTO(struct xfs_perag *pag, enum xfs_ag_resv_type type, \
+		 xfs_extlen_t len), \
+	TP_ARGS(pag, type, len))
+
+/* per-AG reservation tracepoints */
+DEFINE_AG_RESV_EVENT(xfs_ag_resv_init);
+DEFINE_AG_RESV_EVENT(xfs_ag_resv_free);
+DEFINE_AG_RESV_EVENT(xfs_ag_resv_alloc_extent);
+DEFINE_AG_RESV_EVENT(xfs_ag_resv_free_extent);
+DEFINE_AG_RESV_EVENT(xfs_ag_resv_critical);
+DEFINE_AG_RESV_EVENT(xfs_ag_resv_needed);
+
+DEFINE_AG_ERROR_EVENT(xfs_ag_resv_free_error);
+DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
