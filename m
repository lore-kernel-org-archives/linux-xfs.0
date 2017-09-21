Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43342 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdIUASQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 20:18:16 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8L0IFho016041
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0IFT2014670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:15 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0IFhq032055
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:15 GMT
Subject: [PATCH 06/27] xfs: create helpers to record and deal with scrub
 problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Sep 2017 17:18:14 -0700
Message-ID: <150595309448.18473.17367425546613617113.stgit@magnolia>
In-Reply-To: <150595305131.18473.16572195821331601191.stgit@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
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
 fs/xfs/scrub/common.c |  243 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h |   39 ++++++++
 fs/xfs/scrub/trace.h  |  193 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 475 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 13ccb36..cf3f1365 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -47,6 +47,249 @@
 
 /* Common code for the metadata scrubbers. */
 
+/* Check for operational errors. */
+bool
+xfs_scrub_op_ok(
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
+xfs_scrub_fblock_op_ok(
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
+/* Check for metadata block optimization possibilities. */
+bool
+xfs_scrub_block_preen_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	bool				fs_ok)
+{
+	struct xfs_mount		*mp = sc->mp;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+
+	if (fs_ok)
+		return fs_ok;
+
+	fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	bno = XFS_FSB_TO_AGBNO(mp, fsbno);
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	trace_xfs_scrub_block_preen(sc, agno, bno, __return_address);
+	return fs_ok;
+}
+
+/* Check for inode metadata optimization possibilities. */
+bool
+xfs_scrub_ino_preen_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	bool				fs_ok)
+{
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_mount		*mp = sc->mp;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+
+	if (fs_ok)
+		return fs_ok;
+
+	if (bp) {
+		fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+		agno = XFS_FSB_TO_AGNO(mp, fsbno);
+		bno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	} else {
+		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+		bno = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	}
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	trace_xfs_scrub_ino_preen(sc, ip->i_ino, agno, bno, __return_address);
+	return fs_ok;
+}
+
+/* Check for metadata block corruption. */
+bool
+xfs_scrub_block_check_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	bool				fs_ok)
+{
+	struct xfs_mount		*mp = sc->mp;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+
+	if (fs_ok)
+		return fs_ok;
+
+	fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	bno = XFS_FSB_TO_AGBNO(mp, fsbno);
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	trace_xfs_scrub_block_error(sc, agno, bno, __return_address);
+	return fs_ok;
+}
+
+/* Check for inode metadata corruption. */
+bool
+xfs_scrub_ino_check_ok(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_buf			*bp,
+	bool				fs_ok)
+{
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_mount		*mp = sc->mp;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+
+	if (fs_ok)
+		return fs_ok;
+
+	if (bp) {
+		fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+		agno = XFS_FSB_TO_AGNO(mp, fsbno);
+		bno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	} else {
+		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+		bno = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	}
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	trace_xfs_scrub_ino_error(sc, ino, agno, bno, __return_address);
+	return fs_ok;
+}
+
+/* Check for file fork block corruption. */
+bool
+xfs_scrub_fblock_check_ok(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	bool				fs_ok)
+{
+	if (fs_ok)
+		return fs_ok;
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	trace_xfs_scrub_fblock_error(sc, whichfork, offset, __return_address);
+	return fs_ok;
+}
+
+/* Check for inode metadata non-corruption problems. */
+bool
+xfs_scrub_ino_warn_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	bool				fs_ok)
+{
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_mount		*mp = sc->mp;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+
+	if (fs_ok)
+		return fs_ok;
+
+	if (bp) {
+		fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+		agno = XFS_FSB_TO_AGNO(mp, fsbno);
+		bno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	} else {
+		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+		bno = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	}
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
+	trace_xfs_scrub_ino_warning(sc, ip->i_ino, agno, bno, __return_address);
+	return fs_ok;
+}
+
+/* Check for file fork block non-corruption problems. */
+bool
+xfs_scrub_fblock_warn_ok(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	bool				fs_ok)
+{
+	if (fs_ok)
+		return fs_ok;
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
+	trace_xfs_scrub_fblock_warning(sc, whichfork, offset, __return_address);
+	return fs_ok;
+}
+
+/* Signal an incomplete scrub. */
+bool
+xfs_scrub_check_thoroughness(
+	struct xfs_scrub_context	*sc,
+	bool				fs_ok)
+{
+	if (fs_ok)
+		return fs_ok;
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_INCOMPLETE;
+	trace_xfs_scrub_incomplete(sc, __return_address);
+	return fs_ok;
+}
+
 /* Per-scrubber setup functions */
 
 /* Set us up with a transaction and an empty context. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index b97df8c..e1bb14b 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -38,6 +38,45 @@ xfs_scrub_trans_alloc(
 	return xfs_trans_alloc_empty(mp, tpp);
 }
 
+/* Check for operational errors for a block check. */
+bool xfs_scrub_op_ok(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+		     xfs_agblock_t bno, int *error);
+
+/* Check for operational errors for a file offset check. */
+bool xfs_scrub_fblock_op_ok(struct xfs_scrub_context *sc, int whichfork,
+			  xfs_fileoff_t offset, int *error);
+
+/* Check for metadata block optimization possibilities. */
+bool xfs_scrub_block_preen_ok(struct xfs_scrub_context *sc, struct xfs_buf *bp,
+			      bool fs_ok);
+
+/* Check for inode metadata optimization possibilities. */
+bool xfs_scrub_ino_preen_ok(struct xfs_scrub_context *sc, struct xfs_buf *bp,
+			    bool fs_ok);
+
+/* Check for metadata block corruption. */
+bool xfs_scrub_block_check_ok(struct xfs_scrub_context *sc, struct xfs_buf *bp,
+			      bool fs_ok);
+
+/* Check for inode metadata corruption. */
+bool xfs_scrub_ino_check_ok(struct xfs_scrub_context *sc, xfs_ino_t ino,
+			    struct xfs_buf *bp, bool fs_ok);
+
+/* Check for file fork block corruption. */
+bool xfs_scrub_fblock_check_ok(struct xfs_scrub_context *sc, int whichfork,
+			       xfs_fileoff_t offset, bool fs_ok);
+
+/* Check for inode metadata non-corruption weirdness problems. */
+bool xfs_scrub_ino_warn_ok(struct xfs_scrub_context *sc, struct xfs_buf *bp,
+			   bool fs_ok);
+
+/* Check for file data block non-corruption weirdness problems. */
+bool xfs_scrub_fblock_warn_ok(struct xfs_scrub_context *sc, int whichfork,
+			      xfs_fileoff_t offset, bool fs_ok);
+
+/* Signal an incomplete scrub. */
+bool xfs_scrub_check_thoroughness(struct xfs_scrub_context *sc, bool fs_ok);
+
 /* Setup functions */
 int xfs_scrub_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 688517e..8d67a85 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -67,6 +67,199 @@ DEFINE_EVENT(xfs_scrub_class, name, \
 
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
+	TP_PROTO(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+		 xfs_agblock_t bno, void *ret_ip),
+	TP_ARGS(sc, agno, bno, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, type)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
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
+	TP_PROTO(struct xfs_scrub_context *sc, xfs_agnumber_t agno, \
+		 xfs_agblock_t bno, void *ret_ip), \
+	TP_ARGS(sc, agno, bno, ret_ip))
+
+DEFINE_SCRUB_BLOCK_ERROR_EVENT(xfs_scrub_block_error);
+DEFINE_SCRUB_BLOCK_ERROR_EVENT(xfs_scrub_block_preen);
+
+DECLARE_EVENT_CLASS(xfs_scrub_ino_error_class,
+	TP_PROTO(struct xfs_scrub_context *sc, xfs_ino_t ino,
+		 xfs_agnumber_t agno, xfs_agblock_t bno, void *ret_ip),
+	TP_ARGS(sc, ino, agno, bno, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, type)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
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
+		 xfs_agnumber_t agno, xfs_agblock_t bno, void *ret_ip), \
+	TP_ARGS(sc, ino, agno, bno, ret_ip))
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
 

