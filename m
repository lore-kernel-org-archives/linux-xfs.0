Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19893 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbdK2BZ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:25:57 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT1Pu0T014958
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:25:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1PtEg011490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:25:56 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAT1Ptrg025680
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:25:55 GMT
Subject: [PATCH 05/16] xfs: set up scrub cross-referencing helpers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Nov 2017 17:25:54 -0800
Message-ID: <151191875457.8553.996068921490786157.stgit@magnolia>
In-Reply-To: <151191872395.8553.15627872818207535470.stgit@magnolia>
References: <151191872395.8553.15627872818207535470.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create some helper functions that we'll use later to deal with problems
we might encounter while cross referencing metadata with other metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/btree.c  |   69 ++++++++++++++++++++-----
 fs/xfs/scrub/btree.h  |    9 +++
 fs/xfs/scrub/common.c |  138 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/common.h |   22 ++++++++
 fs/xfs/scrub/scrub.c  |   10 ++++
 fs/xfs/scrub/trace.h  |   22 ++++++++
 6 files changed, 248 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index df07661..8d48b5b1 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -42,12 +42,14 @@
  * Check for btree operation errors.  See the section about handling
  * operational errors in common.c.
  */
-bool
-xfs_scrub_btree_process_error(
+static bool
+__xfs_scrub_btree_process_error(
 	struct xfs_scrub_context	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level,
-	int				*error)
+	int				*error,
+	bool				xref,
+	void				*ret_ip)
 {
 	if (*error == 0)
 		return true;
@@ -60,36 +62,78 @@ xfs_scrub_btree_process_error(
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
-		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		sc->sm->sm_flags |= xfs_scrub_corrupt_flag(xref);
 		*error = 0;
 		/* fall through */
 	default:
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			trace_xfs_scrub_ifork_btree_op_error(sc, cur, level,
-					*error, __return_address);
+					*error, ret_ip);
 		else
 			trace_xfs_scrub_btree_op_error(sc, cur, level,
-					*error, __return_address);
+					*error, ret_ip);
 		break;
 	}
 	return false;
 }
 
+bool
+xfs_scrub_btree_process_error(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	int				level,
+	int				*error)
+{
+	return __xfs_scrub_btree_process_error(sc, cur, level, error, false,
+			__return_address);
+}
+
+bool
+xfs_scrub_btree_xref_process_error(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	int				level,
+	int				*error)
+{
+	return __xfs_scrub_btree_process_error(sc, cur, level, error, true,
+			__return_address);
+}
+
 /* Record btree block corruption. */
-void
-xfs_scrub_btree_set_corrupt(
+static void
+__xfs_scrub_btree_set_corrupt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_btree_cur		*cur,
-	int				level)
+	int				level,
+	bool				xref,
+	void				*ret_ip)
 {
-	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	sc->sm->sm_flags |= xfs_scrub_corrupt_flag(xref);
 
 	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 		trace_xfs_scrub_ifork_btree_error(sc, cur, level,
-				__return_address);
+				ret_ip);
 	else
 		trace_xfs_scrub_btree_error(sc, cur, level,
-				__return_address);
+				ret_ip);
+}
+
+void
+xfs_scrub_btree_set_corrupt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	int				level)
+{
+	__xfs_scrub_btree_set_corrupt(sc, cur, level, false, __return_address);
+}
+
+void
+xfs_scrub_btree_xref_set_corrupt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	int				level)
+{
+	__xfs_scrub_btree_set_corrupt(sc, cur, level, true, __return_address);
 }
 
 /*
@@ -512,5 +556,6 @@ xfs_scrub_btree(
 	}
 
 out:
+
 	return error;
 }
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index 4de825a6..e2b868e 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -26,10 +26,19 @@
 bool xfs_scrub_btree_process_error(struct xfs_scrub_context *sc,
 		struct xfs_btree_cur *cur, int level, int *error);
 
+/* Check for btree xref operation errors. */
+bool xfs_scrub_btree_xref_process_error(struct xfs_scrub_context *sc,
+				struct xfs_btree_cur *cur, int level,
+				int *error);
+
 /* Check for btree corruption. */
 void xfs_scrub_btree_set_corrupt(struct xfs_scrub_context *sc,
 		struct xfs_btree_cur *cur, int level);
 
+/* Check for btree xref discrepancies. */
+void xfs_scrub_btree_xref_set_corrupt(struct xfs_scrub_context *sc,
+		struct xfs_btree_cur *cur, int level);
+
 struct xfs_scrub_btree;
 typedef int (*xfs_scrub_btree_rec_fn)(
 	struct xfs_scrub_btree	*bs,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index ac95fe9..9d6730f 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -78,12 +78,14 @@
  */
 
 /* Check for operational errors. */
-bool
-xfs_scrub_process_error(
+static bool
+__xfs_scrub_process_error(
 	struct xfs_scrub_context	*sc,
 	xfs_agnumber_t			agno,
 	xfs_agblock_t			bno,
-	int				*error)
+	int				*error,
+	bool				xref,
+	void				*ret_ip)
 {
 	switch (*error) {
 	case 0:
@@ -95,24 +97,48 @@ xfs_scrub_process_error(
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
-		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		sc->sm->sm_flags |= xfs_scrub_corrupt_flag(xref);
 		*error = 0;
 		/* fall through */
 	default:
 		trace_xfs_scrub_op_error(sc, agno, bno, *error,
-				__return_address);
+				ret_ip);
 		break;
 	}
 	return false;
 }
 
-/* Check for operational errors for a file offset. */
 bool
-xfs_scrub_fblock_process_error(
+xfs_scrub_process_error(
+	struct xfs_scrub_context	*sc,
+	xfs_agnumber_t			agno,
+	xfs_agblock_t			bno,
+	int				*error)
+{
+	return __xfs_scrub_process_error(sc, agno, bno, error, false,
+			__return_address);
+}
+
+bool
+xfs_scrub_xref_process_error(
+	struct xfs_scrub_context	*sc,
+	xfs_agnumber_t			agno,
+	xfs_agblock_t			bno,
+	int				*error)
+{
+	return __xfs_scrub_process_error(sc, agno, bno, error, true,
+			__return_address);
+}
+
+/* Check for operational errors for a file offset. */
+static bool
+__xfs_scrub_fblock_process_error(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset,
-	int				*error)
+	int				*error,
+	bool				xref,
+	void				*ret_ip)
 {
 	switch (*error) {
 	case 0:
@@ -124,17 +150,39 @@ xfs_scrub_fblock_process_error(
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
-		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		sc->sm->sm_flags |= xfs_scrub_corrupt_flag(xref);
 		*error = 0;
 		/* fall through */
 	default:
 		trace_xfs_scrub_file_op_error(sc, whichfork, offset, *error,
-				__return_address);
+				ret_ip);
 		break;
 	}
 	return false;
 }
 
+bool
+xfs_scrub_fblock_process_error(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	int				*error)
+{
+	return __xfs_scrub_fblock_process_error(sc, whichfork, offset, error,
+			false, __return_address);
+}
+
+bool
+xfs_scrub_fblock_xref_process_error(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	int				*error)
+{
+	return __xfs_scrub_fblock_process_error(sc, whichfork, offset, error,
+			true, __return_address);
+}
+
 /*
  * Handling scrub corruption/optimization/warning checks.
  *
@@ -183,6 +231,16 @@ xfs_scrub_block_set_corrupt(
 	trace_xfs_scrub_block_error(sc, bp->b_bn, __return_address);
 }
 
+/* Record a corruption while cross-referencing. */
+void
+xfs_scrub_block_xref_set_corrupt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
+	trace_xfs_scrub_block_error(sc, bp->b_bn, __return_address);
+}
+
 /*
  * Record a corrupt inode.  The trace data will include the block given
  * by bp if bp is given; otherwise it will use the block location of the
@@ -198,6 +256,17 @@ xfs_scrub_ino_set_corrupt(
 	trace_xfs_scrub_ino_error(sc, ino, bp ? bp->b_bn : 0, __return_address);
 }
 
+/* Record a corruption while cross-referencing with an inode. */
+void
+xfs_scrub_ino_xref_set_corrupt(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_buf			*bp)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
+	trace_xfs_scrub_ino_error(sc, ino, bp ? bp->b_bn : 0, __return_address);
+}
+
 /* Record corruption in a block indexed by a file fork. */
 void
 xfs_scrub_fblock_set_corrupt(
@@ -209,6 +278,17 @@ xfs_scrub_fblock_set_corrupt(
 	trace_xfs_scrub_fblock_error(sc, whichfork, offset, __return_address);
 }
 
+/* Record a corruption while cross-referencing a fork block. */
+void
+xfs_scrub_fblock_xref_set_corrupt(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
+	trace_xfs_scrub_fblock_error(sc, whichfork, offset, __return_address);
+}
+
 /*
  * Warn about inodes that need administrative review but is not
  * incorrect.
@@ -572,3 +652,41 @@ xfs_scrub_setup_inode_contents(
 	/* scrub teardown will unlock and release the inode for us */
 	return error;
 }
+
+/*
+ * Predicate that decides if we need to evaluate the cross-reference check.
+ * If there was an error accessing the cross-reference btree, just delete
+ * the cursor and skip the check.
+ */
+bool
+xfs_scrub_should_xref(
+	struct xfs_scrub_context	*sc,
+	int				*error,
+	struct xfs_btree_cur		**curpp)
+{
+	/* If not a btree cross-reference, just check the error code. */
+	if (curpp == NULL) {
+		if (*error == 0)
+			return true;
+		goto fail;
+	}
+
+	ASSERT(*curpp != NULL);
+	/* If no error or we've already given up on xref, just bail out. */
+	if (*error == 0 || *curpp == NULL)
+		return true;
+
+	/* xref error, delete cursor and bail out. */
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
+	xfs_btree_del_cursor(*curpp, XFS_BTREE_ERROR);
+	*curpp = NULL;
+fail:
+	trace_xfs_scrub_xref_error(sc, *error, __return_address);
+
+	/*
+	 * Errors encountered during cross-referencing with another
+	 * data structure should not cause this scrubber to abort.
+	 */
+	*error = 0;
+	return false;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 5c04385..47576d9 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -56,6 +56,11 @@ bool xfs_scrub_process_error(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 bool xfs_scrub_fblock_process_error(struct xfs_scrub_context *sc, int whichfork,
 		xfs_fileoff_t offset, int *error);
 
+bool xfs_scrub_xref_process_error(struct xfs_scrub_context *sc,
+		xfs_agnumber_t agno, xfs_agblock_t bno, int *error);
+bool xfs_scrub_fblock_xref_process_error(struct xfs_scrub_context *sc,
+		int whichfork, xfs_fileoff_t offset, int *error);
+
 void xfs_scrub_block_set_preen(struct xfs_scrub_context *sc,
 		struct xfs_buf *bp);
 void xfs_scrub_ino_set_preen(struct xfs_scrub_context *sc, xfs_ino_t ino,
@@ -68,6 +73,13 @@ void xfs_scrub_ino_set_corrupt(struct xfs_scrub_context *sc, xfs_ino_t ino,
 void xfs_scrub_fblock_set_corrupt(struct xfs_scrub_context *sc, int whichfork,
 		xfs_fileoff_t offset);
 
+void xfs_scrub_block_xref_set_corrupt(struct xfs_scrub_context *sc,
+		struct xfs_buf *bp);
+void xfs_scrub_ino_xref_set_corrupt(struct xfs_scrub_context *sc, xfs_ino_t ino,
+		struct xfs_buf *bp);
+void xfs_scrub_fblock_xref_set_corrupt(struct xfs_scrub_context *sc,
+		int whichfork, xfs_fileoff_t offset);
+
 void xfs_scrub_ino_set_warning(struct xfs_scrub_context *sc, xfs_ino_t ino,
 		struct xfs_buf *bp);
 void xfs_scrub_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
@@ -76,6 +88,10 @@ void xfs_scrub_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
 void xfs_scrub_set_incomplete(struct xfs_scrub_context *sc);
 int xfs_scrub_checkpoint_log(struct xfs_mount *mp);
 
+/* Are we set up for a cross-referencing operation? */
+bool xfs_scrub_should_xref(struct xfs_scrub_context *sc, int *error,
+			   struct xfs_btree_cur **curpp);
+
 /* Setup functions */
 int xfs_scrub_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 int xfs_scrub_setup_ag_header(struct xfs_scrub_context *sc,
@@ -141,4 +157,10 @@ int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
 int xfs_scrub_setup_inode_contents(struct xfs_scrub_context *sc,
 				   struct xfs_inode *ip, unsigned int resblks);
 
+/* Figure out the correct corruption flag for whatever's wrong. */
+static inline __u32 xfs_scrub_corrupt_flag(bool xref)
+{
+	return xref ? XFS_SCRUB_OFLAG_XCORRUPT : XFS_SCRUB_OFLAG_CORRUPT;
+}
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9c42c4e..c4ad1b7 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -111,6 +111,16 @@
  * structure itself is corrupt, the CORRUPT flag will be set.  If
  * the metadata is correct but otherwise suboptimal, the PREEN flag
  * will be set.
+ *
+ * We perform secondary validation of filesystem metadata by
+ * cross-referencing every record with all other available metadata.
+ * For example, for block mapping extents, we verify that there are no
+ * records in the free space and inode btrees corresponding to that
+ * space extent and that there is a corresponding entry in the reverse
+ * mapping btree.  Inconsistent metadata is noted by setting the
+ * XCORRUPT flag; btree query function errors are noted by setting the
+ * XFAIL flag and deleting the cursor to prevent further attempts to
+ * cross-reference with a defective btree.
  */
 
 /*
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c4ebfb5..81becf6 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -491,6 +491,28 @@ DEFINE_EVENT(xfs_scrub_sbtree_class, name, \
 DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_rec);
 DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_key);
 
+TRACE_EVENT(xfs_scrub_xref_error,
+	TP_PROTO(struct xfs_scrub_context *sc, int error, void *ret_ip),
+	TP_ARGS(sc, error, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, type)
+		__field(int, error)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->type = sc->sm->sm_type;
+		__entry->error = error;
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d type %u xref error %d ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->error,
+		  __entry->ret_ip)
+);
+
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH

