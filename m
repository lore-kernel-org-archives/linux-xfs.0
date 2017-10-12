Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27876 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752803AbdJLBlr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:41:47 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1fjS6032136
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1fjbJ028955
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:45 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1fjc2020105
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:45 GMT
Subject: [PATCH 09/30] xfs: create helpers to record and deal with scrub
 problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:41:44 -0700
Message-ID: <150777250403.1724.2736736810868971865.stgit@magnolia>
In-Reply-To: <150777244315.1724.6916081372861799350.stgit@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create helper functions to record crc and corruption problems, and
deal with any other runtime errors that arise.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |  190 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h |   23 +++++
 fs/xfs/scrub/trace.h  |  215 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 428 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index d2c8f94..709d491 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -47,6 +47,196 @@
 
 /* Common code for the metadata scrubbers. */
 
+/*
+ * Handling operational errors.
+ *
+ * The *_process_error() family of functions are used to process error return
+ * codes from functions called as part of a scrub operation.
+ *
+ * If there's no error, we return true to tell the caller that it's ok
+ * to move on to the next check in its list.
+ *
+ * For non-verifier errors (e.g. ENOMEM) we return false to tell the
+ * caller that something bad happened, and we preserve *error so that
+ * the caller can return the *error up the stack to userspace.
+ *
+ * Verifier errors (EFSBADCRC/EFSCORRUPTED) are recorded by setting
+ * OFLAG_CORRUPT in sm_flags and the *error is cleared.  In other words,
+ * we track verifier errors (and failed scrub checks) via OFLAG_CORRUPT,
+ * not via return codes.  We return false to tell the caller that
+ * something bad happened.  Since the error has been cleared, the caller
+ * will (presumably) return that zero and scrubbing will move on to
+ * whatever's next.
+ *
+ * ftrace can be used to record the precise metadata location and the
+ * approximate code location of the failed operation.
+ */
+
+/* Check for operational errors. */
+bool
+xfs_scrub_process_error(
+	struct xfs_scrub_context	*sc,
+	xfs_agnumber_t			agno,
+	xfs_agblock_t			bno,
+	int				*error)
+{
+	switch (*error) {
+	case 0:
+		return true;
+	case -EDEADLOCK:
+		/* Used to restart an op with deadlock avoidance. */
+		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
+		break;
+	case -EFSBADCRC:
+	case -EFSCORRUPTED:
+		/* Note the badness but don't abort. */
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		*error = 0;
+		/* fall through */
+	default:
+		trace_xfs_scrub_op_error(sc, agno, bno, *error,
+				__return_address);
+		break;
+	}
+	return false;
+}
+
+/* Check for operational errors for a file offset. */
+bool
+xfs_scrub_fblock_process_error(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	int				*error)
+{
+	switch (*error) {
+	case 0:
+		return true;
+	case -EDEADLOCK:
+		/* Used to restart an op with deadlock avoidance. */
+		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
+		break;
+	case -EFSBADCRC:
+	case -EFSCORRUPTED:
+		/* Note the badness but don't abort. */
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		*error = 0;
+		/* fall through */
+	default:
+		trace_xfs_scrub_file_op_error(sc, whichfork, offset, *error,
+				__return_address);
+		break;
+	}
+	return false;
+}
+
+/*
+ * Handling scrub corruption/optimization/warning checks.
+ *
+ * The *_set_{corrupt,preen,warning}() family of functions are used to
+ * record the presence of metadata that is incorrect (corrupt), could be
+ * optimized somehow (preen), or should be flagged for administrative
+ * review but is not incorrect (warn).
+ *
+ * ftrace can be used to record the precise metadata location and
+ * approximate code location of the failed check.
+ */
+
+/* Record a block which could be optimized. */
+void
+xfs_scrub_block_set_preen(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	trace_xfs_scrub_block_preen(sc, bp->b_bn, __return_address);
+}
+
+/*
+ * Record an inode which could be optimized.  The trace data will
+ * include the block given by bp if bp is given; otherwise it will use
+ * the block location of the inode record itself.
+ */
+void
+xfs_scrub_ino_set_preen(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	trace_xfs_scrub_ino_preen(sc, sc->ip->i_ino, bp ? bp->b_bn : 0,
+			__return_address);
+}
+
+/* Record a corrupt block. */
+void
+xfs_scrub_block_set_corrupt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	trace_xfs_scrub_block_error(sc, bp->b_bn, __return_address);
+}
+
+/*
+ * Record a corrupt inode.  The trace data will include the block given
+ * by bp if bp is given; otherwise it will use the block location of the
+ * inode record itself.
+ */
+void
+xfs_scrub_ino_set_corrupt(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_buf			*bp)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	trace_xfs_scrub_ino_error(sc, ino, bp ? bp->b_bn : 0, __return_address);
+}
+
+/* Record corruption in a block indexed by a file fork. */
+void
+xfs_scrub_fblock_set_corrupt(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	trace_xfs_scrub_fblock_error(sc, whichfork, offset, __return_address);
+}
+
+/*
+ * Warn about inodes that need administrative review but is not
+ * incorrect.
+ */
+void
+xfs_scrub_ino_set_warning(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
+	trace_xfs_scrub_ino_warning(sc, sc->ip->i_ino, bp ? bp->b_bn : 0,
+			__return_address);
+}
+
+/* Warn about a block indexed by a file fork that needs review. */
+void
+xfs_scrub_fblock_set_warning(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
+	trace_xfs_scrub_fblock_warning(sc, whichfork, offset, __return_address);
+}
+
+/* Signal an incomplete scrub. */
+void
+xfs_scrub_set_incomplete(
+	struct xfs_scrub_context	*sc)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_INCOMPLETE;
+	trace_xfs_scrub_incomplete(sc, __return_address);
+}
+
 /* Per-scrubber setup functions */
 
 /* Set us up with a transaction and an empty context. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index f3d5865..a7c3361 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -33,6 +33,29 @@ xfs_scrub_trans_alloc(
 	return xfs_trans_alloc_empty(mp, tpp);
 }
 
+bool xfs_scrub_process_error(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+		xfs_agblock_t bno, int *error);
+bool xfs_scrub_fblock_process_error(struct xfs_scrub_context *sc, int whichfork,
+		xfs_fileoff_t offset, int *error);
+
+void xfs_scrub_block_set_preen(struct xfs_scrub_context *sc,
+		struct xfs_buf *bp);
+void xfs_scrub_ino_set_preen(struct xfs_scrub_context *sc, struct xfs_buf *bp);
+
+void xfs_scrub_block_set_corrupt(struct xfs_scrub_context *sc,
+		struct xfs_buf *bp);
+void xfs_scrub_ino_set_corrupt(struct xfs_scrub_context *sc, xfs_ino_t ino,
+		struct xfs_buf *bp);
+void xfs_scrub_fblock_set_corrupt(struct xfs_scrub_context *sc, int whichfork,
+		xfs_fileoff_t offset);
+
+void xfs_scrub_ino_set_warning(struct xfs_scrub_context *sc,
+		struct xfs_buf *bp);
+void xfs_scrub_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
+		xfs_fileoff_t offset);
+
+void xfs_scrub_set_incomplete(struct xfs_scrub_context *sc);
+
 /* Setup functions */
 int xfs_scrub_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 688517e..d970659 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -24,6 +24,7 @@
 #define _TRACE_XFS_SCRUB_TRACE_H
 
 #include <linux/tracepoint.h>
+#include "xfs_bit.h"
 
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
@@ -67,6 +68,220 @@ DEFINE_EVENT(xfs_scrub_class, name, \
 
 DEFINE_SCRUB_EVENT(xfs_scrub_start);
 DEFINE_SCRUB_EVENT(xfs_scrub_done);
+DEFINE_SCRUB_EVENT(xfs_scrub_deadlock_retry);
+
+TRACE_EVENT(xfs_scrub_op_error,
+	TP_PROTO(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+		 xfs_agblock_t bno, int error, void *ret_ip),
+	TP_ARGS(sc, agno, bno, error, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, type)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(int, error)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->type = sc->sm->sm_type;
+		__entry->agno = agno;
+		__entry->bno = bno;
+		__entry->error = error;
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d type %u agno %u agbno %u error %d ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->error,
+		  __entry->ret_ip)
+);
+
+TRACE_EVENT(xfs_scrub_file_op_error,
+	TP_PROTO(struct xfs_scrub_context *sc, int whichfork,
+		 xfs_fileoff_t offset, int error, void *ret_ip),
+	TP_ARGS(sc, whichfork, offset, error, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(unsigned int, type)
+		__field(xfs_fileoff_t, offset)
+		__field(int, error)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->ip->i_mount->m_super->s_dev;
+		__entry->ino = sc->ip->i_ino;
+		__entry->whichfork = whichfork;
+		__entry->type = sc->sm->sm_type;
+		__entry->offset = offset;
+		__entry->error = error;
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu error %d ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->whichfork,
+		  __entry->type,
+		  __entry->offset,
+		  __entry->error,
+		  __entry->ret_ip)
+);
+
+DECLARE_EVENT_CLASS(xfs_scrub_block_error_class,
+	TP_PROTO(struct xfs_scrub_context *sc, xfs_daddr_t daddr, void *ret_ip),
+	TP_ARGS(sc, daddr, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, type)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		xfs_fsblock_t	fsbno;
+		xfs_agnumber_t	agno;
+		xfs_agblock_t	bno;
+
+		fsbno = XFS_DADDR_TO_FSB(sc->mp, daddr);
+		agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
+		bno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->type = sc->sm->sm_type;
+		__entry->agno = agno;
+		__entry->bno = bno;
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d type %u agno %u agbno %u ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->ret_ip)
+)
+
+#define DEFINE_SCRUB_BLOCK_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_block_error_class, name, \
+	TP_PROTO(struct xfs_scrub_context *sc, xfs_daddr_t daddr, \
+		 void *ret_ip), \
+	TP_ARGS(sc, daddr, ret_ip))
+
+DEFINE_SCRUB_BLOCK_ERROR_EVENT(xfs_scrub_block_error);
+DEFINE_SCRUB_BLOCK_ERROR_EVENT(xfs_scrub_block_preen);
+
+DECLARE_EVENT_CLASS(xfs_scrub_ino_error_class,
+	TP_PROTO(struct xfs_scrub_context *sc, xfs_ino_t ino, xfs_daddr_t daddr,
+		 void *ret_ip),
+	TP_ARGS(sc, ino, daddr, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, type)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		xfs_fsblock_t	fsbno;
+		xfs_agnumber_t	agno;
+		xfs_agblock_t	bno;
+
+		if (daddr) {
+			fsbno = XFS_DADDR_TO_FSB(sc->mp, daddr);
+			agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
+			bno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+		} else {
+			agno = XFS_INO_TO_AGNO(sc->mp, ino);
+			bno = XFS_AGINO_TO_AGBNO(sc->mp,
+					XFS_INO_TO_AGINO(sc->mp, ino));
+		}
+
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = ino;
+		__entry->type = sc->sm->sm_type;
+		__entry->agno = agno;
+		__entry->bno = bno;
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d ino %llu type %u agno %u agbno %u ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->type,
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->ret_ip)
+)
+
+#define DEFINE_SCRUB_INO_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_ino_error_class, name, \
+	TP_PROTO(struct xfs_scrub_context *sc, xfs_ino_t ino, \
+		 xfs_daddr_t daddr, void *ret_ip), \
+	TP_ARGS(sc, ino, daddr, ret_ip))
+
+DEFINE_SCRUB_INO_ERROR_EVENT(xfs_scrub_ino_error);
+DEFINE_SCRUB_INO_ERROR_EVENT(xfs_scrub_ino_preen);
+DEFINE_SCRUB_INO_ERROR_EVENT(xfs_scrub_ino_warning);
+
+DECLARE_EVENT_CLASS(xfs_scrub_fblock_error_class,
+	TP_PROTO(struct xfs_scrub_context *sc, int whichfork,
+		 xfs_fileoff_t offset, void *ret_ip),
+	TP_ARGS(sc, whichfork, offset, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(unsigned int, type)
+		__field(xfs_fileoff_t, offset)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->ip->i_mount->m_super->s_dev;
+		__entry->ino = sc->ip->i_ino;
+		__entry->whichfork = whichfork;
+		__entry->type = sc->sm->sm_type;
+		__entry->offset = offset;
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->whichfork,
+		  __entry->type,
+		  __entry->offset,
+		  __entry->ret_ip)
+);
+
+#define DEFINE_SCRUB_FBLOCK_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_fblock_error_class, name, \
+	TP_PROTO(struct xfs_scrub_context *sc, int whichfork, \
+		 xfs_fileoff_t offset, void *ret_ip), \
+	TP_ARGS(sc, whichfork, offset, ret_ip))
+
+DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xfs_scrub_fblock_error);
+DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xfs_scrub_fblock_warning);
+
+TRACE_EVENT(xfs_scrub_incomplete,
+	TP_PROTO(struct xfs_scrub_context *sc, void *ret_ip),
+	TP_ARGS(sc, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, type)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->type = sc->sm->sm_type;
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d type %u ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->ret_ip)
+);
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
 

