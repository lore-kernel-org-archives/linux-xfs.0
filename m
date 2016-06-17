Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 528CF7CB4
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:23:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D35B8AC004
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:23:28 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id yo7VkwSnJh5tz0Ew (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:23:27 -0700 (PDT)
Subject: [PATCH 051/119] xfs: introduce tracepoints for AG reservation code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:23:18 -0700
Message-ID: <146612659841.12839.7635720851652960531.stgit@birch.djwong.org>
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
 fs/xfs/xfs_trace.h |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6466adc..c50479a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2558,6 +2558,75 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_map_gtrec);
 DEFINE_RMAPBT_EVENT(xfs_rmap_convert_gtrec);
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
