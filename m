Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FCCE7EEF
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:40:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C554BAC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:50 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id uWmVaoRoe3Mroq6q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:48 -0700 (PDT)
Subject: [PATCH 05/25] xfs: add scrub tracepoints
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:40:44 -0700
Message-ID: <147216844444.3108.4312125627184435526.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
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
 fs/xfs/xfs_trace.h |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 03b5505..74963a1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3435,6 +3435,83 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
+/* scrub */
+DECLARE_EVENT_CLASS(xfs_scrub_class,
+	TP_PROTO(struct xfs_inode *ip, int type, unsigned long long control,
+		 unsigned int flags, int error),
+	TP_ARGS(ip, type, control, flags, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, type)
+		__field(unsigned long long, control)
+		__field(unsigned int, flags)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->type = type;
+		__entry->control = control;
+		__entry->flags = flags;
+		__entry->error = error;
+	),
+	TP_printk("dev %d:%d ino %llu type %u ctl %llu flags 0x%x error %d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->type,
+		  __entry->control,
+		  __entry->flags,
+		  __entry->error)
+)
+#define DEFINE_SCRUB_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_class, name, \
+	TP_PROTO(struct xfs_inode *ip, int type, unsigned long long control, \
+		 unsigned int flags, int error), \
+	TP_ARGS(ip, type, control, flags, error))
+
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
+
+DEFINE_SCRUB_EVENT(xfs_scrub);
+DEFINE_SCRUB_EVENT(xfs_scrub_done);
+DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_rec);
+DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_key);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
