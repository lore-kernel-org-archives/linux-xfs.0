Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A87A7FB1
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:59:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E06938F8049
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:59:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id nhN6DQzBv1r07lyG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:59:17 -0700 (PDT)
Subject: [PATCH 37/58] xfs: define tracepoints for refcount/reflink activities
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:59:14 -0700
Message-ID: <20151007045913.30457.3278.stgit@birch.djwong.org>
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

Define all the tracepoints we need to inspect the refcount and reflink
runtime operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trace.h |  672 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 672 insertions(+)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f8ec848..2f6015c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2453,6 +2453,678 @@ DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
 DEFINE_DISCARD_EVENT(xfs_discard_exclude);
 DEFINE_DISCARD_EVENT(xfs_discard_busy);
 
+/* reflink/refcount tracepoint classes */
+
+/* reuse the discard trace class for agbno/aglen-based traces */
+#define DEFINE_AG_EXTENT_EVENT(name) DEFINE_DISCARD_EVENT(name)
+
+/* ag btree lookup tracepoint class */
+#define XFS_AG_BTREE_CMP_FORMAT_STR \
+	{ XFS_LOOKUP_EQ,	"eq" }, \
+	{ XFS_LOOKUP_LE,	"le" }, \
+	{ XFS_LOOKUP_GE,	"ge" }
+DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_lookup_t dir),
+	TP_ARGS(mp, agno, agbno, dir),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_lookup_t, dir)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->dir = dir;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u cmp %s(%d)\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __print_symbolic(__entry->dir, XFS_AG_BTREE_CMP_FORMAT_STR),
+		  __entry->dir)
+)
+
+#define DEFINE_AG_BTREE_LOOKUP_EVENT(name) \
+DEFINE_EVENT(xfs_ag_btree_lookup_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_lookup_t dir), \
+	TP_ARGS(mp, agno, agbno, dir))
+
+/* two-file io tracepoint class */
+DECLARE_EVENT_CLASS(xfs_double_io_class,
+	TP_PROTO(struct xfs_inode *src, xfs_off_t soffset, xfs_off_t len,
+		 struct xfs_inode *dest, xfs_off_t doffset),
+	TP_ARGS(src, soffset, len, dest, doffset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, src_ino)
+		__field(loff_t, src_isize)
+		__field(loff_t, src_disize)
+		__field(loff_t, src_offset)
+		__field(size_t, len)
+		__field(xfs_ino_t, dest_ino)
+		__field(loff_t, dest_isize)
+		__field(loff_t, dest_disize)
+		__field(loff_t, dest_offset)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(src)->i_sb->s_dev;
+		__entry->src_ino = src->i_ino;
+		__entry->src_isize = VFS_I(src)->i_size;
+		__entry->src_disize = src->i_d.di_size;
+		__entry->src_offset = soffset;
+		__entry->len = len;
+		__entry->dest_ino = dest->i_ino;
+		__entry->dest_isize = VFS_I(dest)->i_size;
+		__entry->dest_disize = dest->i_d.di_size;
+		__entry->dest_offset = doffset;
+	),
+	TP_printk("dev %d:%d count %zd "
+		  "ino 0x%llx isize 0x%llx disize 0x%llx offset 0x%llx -> "
+		  "ino 0x%llx isize 0x%llx disize 0x%llx offset 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->len,
+		  __entry->src_ino,
+		  __entry->src_isize,
+		  __entry->src_disize,
+		  __entry->src_offset,
+		  __entry->dest_ino,
+		  __entry->dest_isize,
+		  __entry->dest_disize,
+		  __entry->dest_offset)
+)
+
+#define DEFINE_DOUBLE_IO_EVENT(name)	\
+DEFINE_EVENT(xfs_double_io_class, name,	\
+	TP_PROTO(struct xfs_inode *src, xfs_off_t soffset, xfs_off_t len, \
+		 struct xfs_inode *dest, xfs_off_t doffset), \
+	TP_ARGS(src, soffset, len, dest, doffset))
+
+/* two-file vfs io tracepoint class */
+DECLARE_EVENT_CLASS(xfs_double_vfs_io_class,
+	TP_PROTO(struct inode *src, u64 soffset, u64 len,
+		 struct inode *dest, u64 doffset),
+	TP_ARGS(src, soffset, len, dest, doffset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, src_ino)
+		__field(loff_t, src_isize)
+		__field(loff_t, src_offset)
+		__field(size_t, len)
+		__field(unsigned long, dest_ino)
+		__field(loff_t, dest_isize)
+		__field(loff_t, dest_offset)
+	),
+	TP_fast_assign(
+		__entry->dev = src->i_sb->s_dev;
+		__entry->src_ino = src->i_ino;
+		__entry->src_isize = i_size_read(src);
+		__entry->src_offset = soffset;
+		__entry->len = len;
+		__entry->dest_ino = dest->i_ino;
+		__entry->dest_isize = i_size_read(dest);
+		__entry->dest_offset = doffset;
+	),
+	TP_printk("dev %d:%d count %zd "
+		  "ino 0x%lx isize 0x%llx offset 0x%llx -> "
+		  "ino 0x%lx isize 0x%llx offset 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->len,
+		  __entry->src_ino,
+		  __entry->src_isize,
+		  __entry->src_offset,
+		  __entry->dest_ino,
+		  __entry->dest_isize,
+		  __entry->dest_offset)
+)
+
+#define DEFINE_DOUBLE_VFS_IO_EVENT(name)	\
+DEFINE_EVENT(xfs_double_vfs_io_class, name,	\
+	TP_PROTO(struct inode *src, u64 soffset, u64 len, \
+		 struct inode *dest, u64 doffset), \
+	TP_ARGS(src, soffset, len, dest, doffset))
+
+/* CoW write tracepoint */
+DECLARE_EVENT_CLASS(xfs_copy_on_write_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk, xfs_fsblock_t pblk,
+		 xfs_extlen_t len, xfs_fsblock_t new_pblk),
+	TP_ARGS(ip, lblk, pblk, len, new_pblk),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_fsblock_t, pblk)
+		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, new_pblk)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->lblk = lblk;
+		__entry->pblk = pblk;
+		__entry->len = len;
+		__entry->new_pblk = new_pblk;
+	),
+	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx pblk 0x%llx "
+		  "len 0x%x new_pblk %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->lblk,
+		  __entry->pblk,
+		  __entry->len,
+		  __entry->new_pblk)
+)
+
+#define DEFINE_COW_EVENT(name)	\
+DEFINE_EVENT(xfs_copy_on_write_class, name,	\
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk, xfs_fsblock_t pblk, \
+		 xfs_extlen_t len, xfs_fsblock_t new_pblk), \
+	TP_ARGS(ip, lblk, pblk, len, new_pblk))
+
+/* single-rlext tracepoint class */
+DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_refcount_irec *irec),
+	TP_ARGS(mp, agno, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, startblock)
+		__field(xfs_extlen_t, blockcount)
+		__field(xfs_nlink_t, refcount)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startblock = irec->rc_startblock;
+		__entry->blockcount = irec->rc_blockcount;
+		__entry->refcount = irec->rc_refcount;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->startblock,
+		  __entry->blockcount,
+		  __entry->refcount)
+)
+
+#define DEFINE_REFCOUNT_EXTENT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_extent_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 struct xfs_refcount_irec *irec), \
+	TP_ARGS(mp, agno, irec))
+
+/* single-rlext and an agbno tracepoint class */
+DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_refcount_irec *irec, xfs_agblock_t agbno),
+	TP_ARGS(mp, agno, irec, agbno),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, startblock)
+		__field(xfs_extlen_t, blockcount)
+		__field(xfs_nlink_t, refcount)
+		__field(xfs_agblock_t, agbno)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startblock = irec->rc_startblock;
+		__entry->blockcount = irec->rc_blockcount;
+		__entry->refcount = irec->rc_refcount;
+		__entry->agbno = agbno;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u @ agbno %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->startblock,
+		  __entry->blockcount,
+		  __entry->refcount,
+		  __entry->agbno)
+)
+
+#define DEFINE_REFCOUNT_EXTENT_AT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_extent_at_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 struct xfs_refcount_irec *irec, xfs_agblock_t agbno), \
+	TP_ARGS(mp, agno, irec, agbno))
+
+/* double-rlext tracepoint class */
+DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2),
+	TP_ARGS(mp, agno, i1, i2),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, i1_startblock)
+		__field(xfs_extlen_t, i1_blockcount)
+		__field(xfs_nlink_t, i1_refcount)
+		__field(xfs_agblock_t, i2_startblock)
+		__field(xfs_extlen_t, i2_blockcount)
+		__field(xfs_nlink_t, i2_refcount)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->i1_startblock = i1->rc_startblock;
+		__entry->i1_blockcount = i1->rc_blockcount;
+		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_startblock = i2->rc_startblock;
+		__entry->i2_blockcount = i2->rc_blockcount;
+		__entry->i2_refcount = i2->rc_refcount;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
+		  "agbno %u len %u refcount %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->i1_startblock,
+		  __entry->i1_blockcount,
+		  __entry->i1_refcount,
+		  __entry->i2_startblock,
+		  __entry->i2_blockcount,
+		  __entry->i2_refcount)
+)
+
+#define DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_double_extent_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2), \
+	TP_ARGS(mp, agno, i1, i2))
+
+/* double-rlext and an agbno tracepoint class */
+DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2,
+		 xfs_agblock_t agbno),
+	TP_ARGS(mp, agno, i1, i2, agbno),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, i1_startblock)
+		__field(xfs_extlen_t, i1_blockcount)
+		__field(xfs_nlink_t, i1_refcount)
+		__field(xfs_agblock_t, i2_startblock)
+		__field(xfs_extlen_t, i2_blockcount)
+		__field(xfs_nlink_t, i2_refcount)
+		__field(xfs_agblock_t, agbno)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->i1_startblock = i1->rc_startblock;
+		__entry->i1_blockcount = i1->rc_blockcount;
+		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_startblock = i2->rc_startblock;
+		__entry->i2_blockcount = i2->rc_blockcount;
+		__entry->i2_refcount = i2->rc_refcount;
+		__entry->agbno = agbno;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
+		  "agbno %u len %u refcount %u @ agbno %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->i1_startblock,
+		  __entry->i1_blockcount,
+		  __entry->i1_refcount,
+		  __entry->i2_startblock,
+		  __entry->i2_blockcount,
+		  __entry->i2_refcount,
+		  __entry->agbno)
+)
+
+#define DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_double_extent_at_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2, \
+		 xfs_agblock_t agbno), \
+	TP_ARGS(mp, agno, i1, i2, agbno))
+
+/* triple-rlext tracepoint class */
+DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2,
+		 struct xfs_refcount_irec *i3),
+	TP_ARGS(mp, agno, i1, i2, i3),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, i1_startblock)
+		__field(xfs_extlen_t, i1_blockcount)
+		__field(xfs_nlink_t, i1_refcount)
+		__field(xfs_agblock_t, i2_startblock)
+		__field(xfs_extlen_t, i2_blockcount)
+		__field(xfs_nlink_t, i2_refcount)
+		__field(xfs_agblock_t, i3_startblock)
+		__field(xfs_extlen_t, i3_blockcount)
+		__field(xfs_nlink_t, i3_refcount)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->i1_startblock = i1->rc_startblock;
+		__entry->i1_blockcount = i1->rc_blockcount;
+		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_startblock = i2->rc_startblock;
+		__entry->i2_blockcount = i2->rc_blockcount;
+		__entry->i2_refcount = i2->rc_refcount;
+		__entry->i3_startblock = i3->rc_startblock;
+		__entry->i3_blockcount = i3->rc_blockcount;
+		__entry->i3_refcount = i3->rc_refcount;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
+		  "agbno %u len %u refcount %u -- "
+		  "agbno %u len %u refcount %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->i1_startblock,
+		  __entry->i1_blockcount,
+		  __entry->i1_refcount,
+		  __entry->i2_startblock,
+		  __entry->i2_blockcount,
+		  __entry->i2_refcount,
+		  __entry->i3_startblock,
+		  __entry->i3_blockcount,
+		  __entry->i3_refcount)
+);
+
+#define DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_triple_extent_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2, \
+		 struct xfs_refcount_irec *i3), \
+	TP_ARGS(mp, agno, i1, i2, i3))
+
+/* simple AG-based error/%ip tracepoint class */
+DECLARE_EVENT_CLASS(xfs_ag_error_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, agno, error, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, error)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->error = error;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno %u error %d caller %ps",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->error,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_AG_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_ag_error_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, agno, error, caller_ip))
+
+/* simple inode-based error/%ip tracepoint class */
+DECLARE_EVENT_CLASS(xfs_inode_error_class,
+	TP_PROTO(struct xfs_inode *ip, int error, unsigned long caller_ip),
+	TP_ARGS(ip, error, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, error)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->error = error;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d ino %llx error %d caller %ps",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->error,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_INODE_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_inode_error_class, name, \
+	TP_PROTO(struct xfs_inode *ip, int error, \
+		 unsigned long caller_ip), \
+	TP_ARGS(ip, error, caller_ip))
+
+/* refcount/reflink tracepoint definitions */
+
+/* reflink allocator */
+TRACE_EVENT(xfs_reflink_relink_blocks,
+	TP_PROTO(struct xfs_inode *ip, xfs_fsblock_t fsbno,
+		 xfs_extlen_t len),
+	TP_ARGS(ip, fsbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsblock_t, fsbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->fsbno = fsbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d ino 0x%llx fsbno 0x%llx len %x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->fsbno,
+		  __entry->len)
+);
+
+/* refcount btree tracepoints */
+DEFINE_AG_BTREE_LOOKUP_EVENT(xfs_refcountbt_lookup);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcountbt_get);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcountbt_update);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcountbt_insert);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcountbt_delete);
+
+/* refcount adjustment tracepoints */
+DEFINE_AG_EXTENT_EVENT(xfs_refcount_increase);
+DEFINE_AG_EXTENT_EVENT(xfs_refcount_decrease);
+DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(xfs_refcount_merge_center_extents);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_modify_extent);
+DEFINE_REFCOUNT_EXTENT_AT_EVENT(xfs_refcount_split_left_extent);
+DEFINE_REFCOUNT_EXTENT_AT_EVENT(xfs_refcount_split_right_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_left_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_right_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_left_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_right_extent);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_adjust_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_center_extents_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_modify_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_split_left_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_split_right_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_left_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_right_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_find_left_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_find_right_extent_error);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_rec_order_error);
+
+/* reflink tracepoints */
+DEFINE_INODE_EVENT(xfs_reflink_set_inode_flag);
+DEFINE_INODE_EVENT(xfs_reflink_unset_inode_flag);
+DEFINE_ITRUNC_EVENT(xfs_reflink_update_inode_size);
+DEFINE_IOMAP_EVENT(xfs_reflink_read_iomap);
+TRACE_EVENT(xfs_reflink_main_loop,
+	TP_PROTO(struct xfs_inode *src, xfs_fileoff_t soffset,
+		 xfs_filblks_t len, struct xfs_inode *dest,
+		 xfs_fileoff_t doffset),
+	TP_ARGS(src, soffset, len, dest, doffset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, src_ino)
+		__field(xfs_fileoff_t, src_lblk)
+		__field(xfs_filblks_t, len)
+		__field(xfs_ino_t, dest_ino)
+		__field(xfs_fileoff_t, dest_lblk)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(src)->i_sb->s_dev;
+		__entry->src_ino = src->i_ino;
+		__entry->src_lblk = soffset;
+		__entry->len = len;
+		__entry->dest_ino = dest->i_ino;
+		__entry->dest_lblk = doffset;
+	),
+	TP_printk("dev %d:%d len 0x%llx "
+		  "ino 0x%llx offset 0x%llx blocks -> "
+		  "ino 0x%llx offset 0x%llx blocks",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->len,
+		  __entry->src_ino,
+		  __entry->src_lblk,
+		  __entry->dest_ino,
+		  __entry->dest_lblk)
+);
+TRACE_EVENT(xfs_reflink_punch_range,
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
+		 xfs_extlen_t len),
+	TP_ARGS(ip, lblk, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->lblk = lblk;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->lblk,
+		  __entry->len)
+);
+TRACE_EVENT(xfs_reflink_remap_range,
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
+		 xfs_extlen_t len, xfs_fsblock_t new_pblk),
+	TP_ARGS(ip, lblk, len, new_pblk),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, new_pblk)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->lblk = lblk;
+		__entry->len = len;
+		__entry->new_pblk = new_pblk;
+	),
+	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x new_pblk %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->lblk,
+		  __entry->len,
+		  __entry->new_pblk)
+);
+DEFINE_DOUBLE_IO_EVENT(xfs_reflink_range);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_range_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_reflink_main_loop_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_read_iomap_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_punch_range_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
+
+/* dedupe tracepoints */
+DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_compare_extents_error);
+
+/* ioctl tracepoints */
+DEFINE_DOUBLE_VFS_IO_EVENT(xfs_ioctl_reflink);
+DEFINE_DOUBLE_VFS_IO_EVENT(xfs_ioctl_clone_range);
+DEFINE_DOUBLE_VFS_IO_EVENT(xfs_ioctl_file_extent_same);
+TRACE_EVENT(xfs_ioctl_clone,
+	TP_PROTO(struct inode *src, struct inode *dest),
+	TP_ARGS(src, dest),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, src_ino)
+		__field(loff_t, src_isize)
+		__field(unsigned long, dest_ino)
+		__field(loff_t, dest_isize)
+	),
+	TP_fast_assign(
+		__entry->dev = src->i_sb->s_dev;
+		__entry->src_ino = src->i_ino;
+		__entry->src_isize = i_size_read(src);
+		__entry->dest_ino = dest->i_ino;
+		__entry->dest_isize = i_size_read(dest);
+	),
+	TP_printk("dev %d:%d "
+		  "ino 0x%lx isize 0x%llx -> "
+		  "ino 0x%lx isize 0x%llx\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->src_ino,
+		  __entry->src_isize,
+		  __entry->dest_ino,
+		  __entry->dest_isize)
+);
+
+/* unshare tracepoints */
+DEFINE_INODE_EVENT(xfs_reflink_unshare);
+DEFINE_PAGE_EVENT(xfs_reflink_unshare_page);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_dirty_page_error);
+
+/* copy on write events */
+TRACE_EVENT(xfs_reflink_bounce_direct_write,
+	TP_PROTO(struct xfs_inode *ip, struct xfs_bmbt_irec *irec),
+	TP_ARGS(ip, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, pblk)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->lblk = irec->br_startoff;
+		__entry->len = irec->br_blockcount;
+		__entry->pblk = irec->br_startblock;
+	),
+	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x pblk %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->lblk,
+		  __entry->len,
+		  __entry->pblk)
+);
+DEFINE_COW_EVENT(xfs_reflink_reserve_fork_block);
+DEFINE_COW_EVENT(xfs_reflink_write_fork_block);
+DEFINE_COW_EVENT(xfs_reflink_remap_after_io);
+DEFINE_COW_EVENT(xfs_reflink_free_forked);
+DEFINE_COW_EVENT(xfs_reflink_fork_buf);
+DEFINE_COW_EVENT(xfs_reflink_finish_fork_buf);
+DEFINE_RW_EVENT(xfs_reflink_force_getblocks);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_reserve_fork_block_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_after_io_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_free_forked_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_fork_buf_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_finish_fork_buf_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_write_fork_block_error);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
