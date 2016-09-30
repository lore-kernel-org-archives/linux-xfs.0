Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42293 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752533AbcI3DIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:08:02 -0400
Subject: [PATCH 21/63] xfs: map an inode's offset to an exact physical block
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:07:56 -0700
Message-ID: <147520487612.29434.3808077462465308754.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Teach the bmap routine to know how to map a range of file blocks to a
specific range of physical blocks, instead of simply allocating fresh
blocks.  This enables reflink to map a file to blocks that are already
in use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |   10 +++++++
 fs/xfs/xfs_trace.h       |   54 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 126 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 907d7b8d..9f145ed 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3877,6 +3877,55 @@ xfs_bmap_btalloc(
 }
 
 /*
+ * For a remap operation, just "allocate" an extent at the address that the
+ * caller passed in, and ensure that the AGFL is the right size.  The caller
+ * will then map the "allocated" extent into the file somewhere.
+ */
+STATIC int
+xfs_bmap_remap_alloc(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_trans	*tp = ap->tp;
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_agblock_t		bno;
+	struct xfs_alloc_arg	args;
+	int			error;
+
+	/*
+	 * validate that the block number is legal - the enables us to detect
+	 * and handle a silent filesystem corruption rather than crashing.
+	 */
+	memset(&args, 0, sizeof(struct xfs_alloc_arg));
+	args.tp = ap->tp;
+	args.mp = ap->tp->t_mountp;
+	bno = *ap->firstblock;
+	args.agno = XFS_FSB_TO_AGNO(mp, bno);
+	ASSERT(args.agno < mp->m_sb.sb_agcount);
+	args.agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	ASSERT(args.agbno < mp->m_sb.sb_agblocks);
+
+	/* "Allocate" the extent from the range we passed in. */
+	trace_xfs_bmap_remap_alloc(ap->ip, *ap->firstblock, ap->length);
+	ap->blkno = bno;
+	ap->ip->i_d.di_nblocks += ap->length;
+	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+
+	/* Fix the freelist, like a real allocator does. */
+	args.datatype = ap->datatype;
+	args.pag = xfs_perag_get(args.mp, args.agno);
+	ASSERT(args.pag);
+
+	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
+	if (error)
+		goto error0;
+error0:
+	xfs_perag_put(args.pag);
+	if (error)
+		trace_xfs_bmap_remap_alloc_error(ap->ip, error, _RET_IP_);
+	return error;
+}
+
+/*
  * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
  * It figures out where to ask the underlying allocator to put the new extent.
  */
@@ -3884,6 +3933,8 @@ STATIC int
 xfs_bmap_alloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
+	if (ap->flags & XFS_BMAPI_REMAP)
+		return xfs_bmap_remap_alloc(ap);
 	if (XFS_IS_REALTIME_INODE(ap->ip) &&
 	    xfs_alloc_is_userdata(ap->datatype))
 		return xfs_bmap_rtalloc(ap);
@@ -4442,6 +4493,12 @@ xfs_bmapi_write(
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (whichfork == XFS_ATTR_FORK)
+		ASSERT(!(flags & XFS_BMAPI_REMAP));
+	if (flags & XFS_BMAPI_REMAP) {
+		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
+		ASSERT(!(flags & XFS_BMAPI_CONVERT));
+	}
 
 	/* zeroing is for currently only for data extents, not metadata */
 	ASSERT((flags & (XFS_BMAPI_METADATA | XFS_BMAPI_ZERO)) !=
@@ -4503,6 +4560,12 @@ xfs_bmapi_write(
 		wasdelay = !inhole && isnullstartblock(bma.got.br_startblock);
 
 		/*
+		 * Make sure we only reflink into a hole.
+		 */
+		if (flags & XFS_BMAPI_REMAP)
+			ASSERT(inhole);
+
+		/*
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
 		 */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index fcdb094..877b6f9 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -97,6 +97,13 @@ struct xfs_extent_free_item
  */
 #define XFS_BMAPI_ZERO		0x080
 
+/*
+ * Map the inode offset to the block given in ap->firstblock.  Primarily
+ * used for reflink.  The range must be in a hole, and this flag cannot be
+ * turned on with PREALLOC or CONVERT, and cannot be used on the attr fork.
+ */
+#define XFS_BMAPI_REMAP		0x100
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -105,7 +112,8 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
 	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
-	{ XFS_BMAPI_ZERO,	"ZERO" }
+	{ XFS_BMAPI_ZERO,	"ZERO" }, \
+	{ XFS_BMAPI_REMAP,	"REMAP" }
 
 
 static inline int xfs_bmapi_aflag(int w)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 195a168..8485984 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2965,6 +2965,60 @@ TRACE_EVENT(xfs_refcount_finish_one_leftover,
 		  __entry->adjusted)
 );
 
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
+/* reflink allocator */
+TRACE_EVENT(xfs_bmap_remap_alloc,
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
+DEFINE_INODE_ERROR_EVENT(xfs_bmap_remap_alloc_error);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

