Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A7B0A7F6C
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:57:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98E958F8049
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:57:22 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id HESOjWPXbx5x3eLg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:57:20 -0700 (PDT)
Subject: [PATCH 20/58] xfs: add tracepoints for the rmap-mirrors-bmbt functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:57:17 -0700
Message-ID: <20151007045717.30457.44530.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trace.h |  251 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 251 insertions(+)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4e7a889..f8ec848 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1719,6 +1719,257 @@ DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent);
 DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent_done);
 DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent_error);
 
+/* rmap-mirrors-bmbt traces */
+DECLARE_EVENT_CLASS(xfs_rmap_bmbt3_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_ino_t ino,
+		 int whichfork,
+		 struct xfs_bmbt_irec *left,
+		 struct xfs_bmbt_irec *prev,
+		 struct xfs_bmbt_irec *right),
+	TP_ARGS(mp, agno, ino, whichfork, left, prev, right),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, l_loff)
+		__field(xfs_fsblock_t, l_poff)
+		__field(xfs_filblks_t, l_len)
+		__field(xfs_fileoff_t, p_loff)
+		__field(xfs_fsblock_t, p_poff)
+		__field(xfs_filblks_t, p_len)
+		__field(xfs_fileoff_t, r_loff)
+		__field(xfs_fsblock_t, r_poff)
+		__field(xfs_filblks_t, r_len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->ino = ino;
+		__entry->whichfork = whichfork;
+		__entry->l_loff = left->br_startoff;
+		__entry->l_poff = left->br_startblock;
+		__entry->l_len = left->br_blockcount;
+		__entry->p_loff = prev->br_startoff;
+		__entry->p_poff = prev->br_startblock;
+		__entry->p_len = prev->br_blockcount;
+		__entry->r_loff = right->br_startoff;
+		__entry->r_poff = right->br_startblock;
+		__entry->r_len = right->br_blockcount;
+	),
+	TP_printk("dev %d:%d agno %u ino 0x%llx %s (%llu:%lld:%lld):(%llu:%lld:%lld):(%llu:%lld:%lld)",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->ino,
+		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
+		  __entry->l_poff,
+		  __entry->l_len,
+		  __entry->l_loff,
+		  __entry->p_poff,
+		  __entry->p_len,
+		  __entry->p_loff,
+		  __entry->r_poff,
+		  __entry->r_len,
+		  __entry->r_loff)
+);
+#define DEFINE_RMAP_BMBT3_EVENT(name) \
+DEFINE_EVENT(xfs_rmap_bmbt3_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_ino_t ino, \
+		 int whichfork, \
+		 struct xfs_bmbt_irec *left, \
+		 struct xfs_bmbt_irec *prev, \
+		 struct xfs_bmbt_irec *right), \
+	TP_ARGS(mp, agno, ino, whichfork, left, prev, right))
+
+DECLARE_EVENT_CLASS(xfs_rmap_bmbt2_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_ino_t ino,
+		 int whichfork,
+		 struct xfs_bmbt_irec *left,
+		 struct xfs_bmbt_irec *prev),
+	TP_ARGS(mp, agno, ino, whichfork, left, prev),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, l_loff)
+		__field(xfs_fsblock_t, l_poff)
+		__field(xfs_filblks_t, l_len)
+		__field(xfs_fileoff_t, p_loff)
+		__field(xfs_fsblock_t, p_poff)
+		__field(xfs_filblks_t, p_len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->ino = ino;
+		__entry->whichfork = whichfork;
+		__entry->l_loff = left->br_startoff;
+		__entry->l_poff = left->br_startblock;
+		__entry->l_len = left->br_blockcount;
+		__entry->p_loff = prev->br_startoff;
+		__entry->p_poff = prev->br_startblock;
+		__entry->p_len = prev->br_blockcount;
+	),
+	TP_printk("dev %d:%d agno %u ino 0x%llx %s (%llu:%lld:%lld):(%llu:%lld:%lld)",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->ino,
+		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
+		  __entry->l_poff,
+		  __entry->l_len,
+		  __entry->l_loff,
+		  __entry->p_poff,
+		  __entry->p_len,
+		  __entry->p_loff)
+);
+#define DEFINE_RMAP_BMBT2_EVENT(name) \
+DEFINE_EVENT(xfs_rmap_bmbt2_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_ino_t ino, \
+		 int whichfork, \
+		 struct xfs_bmbt_irec *left, \
+		 struct xfs_bmbt_irec *prev), \
+	TP_ARGS(mp, agno, ino, whichfork, left, prev))
+
+DECLARE_EVENT_CLASS(xfs_rmap_bmbt1_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_ino_t ino,
+		 int whichfork,
+		 struct xfs_bmbt_irec *left),
+	TP_ARGS(mp, agno, ino, whichfork, left),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, l_loff)
+		__field(xfs_fsblock_t, l_poff)
+		__field(xfs_filblks_t, l_len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->ino = ino;
+		__entry->whichfork = whichfork;
+		__entry->l_loff = left->br_startoff;
+		__entry->l_poff = left->br_startblock;
+		__entry->l_len = left->br_blockcount;
+	),
+	TP_printk("dev %d:%d agno %u ino 0x%llx %s (%llu:%lld:%lld)",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->ino,
+		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
+		  __entry->l_poff,
+		  __entry->l_len,
+		  __entry->l_loff)
+);
+#define DEFINE_RMAP_BMBT1_EVENT(name) \
+DEFINE_EVENT(xfs_rmap_bmbt1_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_ino_t ino, \
+		 int whichfork, \
+		 struct xfs_bmbt_irec *left), \
+	TP_ARGS(mp, agno, ino, whichfork, left))
+
+DECLARE_EVENT_CLASS(xfs_rmap_adjust_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_ino_t ino,
+		 int whichfork,
+		 struct xfs_bmbt_irec *left,
+		 long adj),
+	TP_ARGS(mp, agno, ino, whichfork, left, adj),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, l_loff)
+		__field(xfs_fsblock_t, l_poff)
+		__field(xfs_filblks_t, l_len)
+		__field(long, adj)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->ino = ino;
+		__entry->whichfork = whichfork;
+		__entry->l_loff = left->br_startoff;
+		__entry->l_poff = left->br_startblock;
+		__entry->l_len = left->br_blockcount;
+		__entry->adj = adj;
+	),
+	TP_printk("dev %d:%d agno %u ino 0x%llx %s (%llu:%lld:%lld) adj %ld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->ino,
+		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
+		  __entry->l_poff,
+		  __entry->l_len,
+		  __entry->l_loff,
+		  __entry->adj)
+);
+#define DEFINE_RMAP_ADJUST_EVENT(name) \
+DEFINE_EVENT(xfs_rmap_adjust_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_ino_t ino, \
+		 int whichfork, \
+		 struct xfs_bmbt_irec *left, \
+		 long adj), \
+	TP_ARGS(mp, agno, ino, whichfork, left, adj))
+
+DECLARE_EVENT_CLASS(xfs_rmapbt_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 uint64_t owner, uint64_t offset),
+	TP_ARGS(mp, agno, agbno, len, owner, offset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->owner = owner;
+		__entry->offset = offset;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u, owner 0x%llx, offset %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset)
+);
+#define DEFINE_RMAPBT_EVENT(name) \
+DEFINE_EVENT(xfs_rmapbt_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 uint64_t owner, uint64_t offset), \
+	TP_ARGS(mp, agno, agbno, len, owner, offset))
+
+DEFINE_RMAP_BMBT3_EVENT(xfs_rmap_combine);
+DEFINE_RMAP_BMBT2_EVENT(xfs_rmap_lcombine);
+DEFINE_RMAP_BMBT2_EVENT(xfs_rmap_rcombine);
+DEFINE_RMAP_BMBT1_EVENT(xfs_rmap_insert);
+DEFINE_RMAP_BMBT1_EVENT(xfs_rmap_delete);
+DEFINE_RMAP_ADJUST_EVENT(xfs_rmap_move);
+DEFINE_RMAP_ADJUST_EVENT(xfs_rmap_slide);
+DEFINE_RMAP_ADJUST_EVENT(xfs_rmap_resize);
+DEFINE_RMAPBT_EVENT(xfs_rmapbt_update);
+DEFINE_RMAPBT_EVENT(xfs_rmapbt_insert);
+DEFINE_RMAPBT_EVENT(xfs_rmapbt_delete);
+
 DECLARE_EVENT_CLASS(xfs_da_class,
 	TP_PROTO(struct xfs_da_args *args),
 	TP_ARGS(args),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
