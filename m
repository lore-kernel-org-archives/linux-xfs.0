Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50362 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdHKHKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:10:46 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7AjYc031308
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7AjjK029088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:45 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7Aikt026839
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:45 GMT
Subject: [PATCH 05/16] xfs: set up scrub cross-referencing helpers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:10:43 -0700
Message-ID: <150243544370.29473.8325083071465885311.stgit@magnolia>
In-Reply-To: <150243541274.29473.1227559008347544526.stgit@magnolia>
References: <150243541274.29473.1227559008347544526.stgit@magnolia>
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
 fs/xfs/scrub/btree.c  |   73 +++++++++++++++---
 fs/xfs/scrub/btree.h  |   10 ++
 fs/xfs/scrub/common.c |  204 +++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/scrub/common.h |   30 +++++++
 fs/xfs/scrub/scrub.c  |   10 ++
 fs/xfs/scrub/trace.h  |   22 +++++
 6 files changed, 312 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 9470575..6f63523 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -44,12 +44,14 @@ static const union xfs_btree_ptr nullptr = {
 };
 
 /* Check for btree operation errors . */
-bool
-xfs_scrub_btree_op_ok(
+static bool
+__xfs_scrub_btree_op_ok(
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
@@ -62,43 +64,89 @@ xfs_scrub_btree_op_ok(
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
 
-/* Check for btree corruption. */
 bool
-xfs_scrub_btree_check_ok(
+xfs_scrub_btree_op_ok(
 	struct xfs_scrub_context	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level,
-	bool				fs_ok)
+	int				*error)
+{
+	return __xfs_scrub_btree_op_ok(sc, cur, level, error, false,
+			__return_address);
+}
+
+bool
+xfs_scrub_btree_xref_op_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	int				level,
+	int				*error)
+{
+	return __xfs_scrub_btree_op_ok(sc, cur, level, error, true,
+			__return_address);
+}
+
+/* Check for btree corruption. */
+static bool
+__xfs_scrub_btree_check_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	int				level,
+	bool				fs_ok,
+	bool				xref,
+	void				*ret_ip)
 {
 	if (fs_ok)
 		return fs_ok;
 
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
 	return fs_ok;
 }
 
+bool
+xfs_scrub_btree_check_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	int				level,
+	bool				fs_ok)
+{
+	return __xfs_scrub_btree_check_ok(sc, cur, level, fs_ok, false,
+			__return_address);
+}
+
+bool
+xfs_scrub_btree_xref_check_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	int				level,
+	bool				fs_ok)
+{
+	return __xfs_scrub_btree_check_ok(sc, cur, level, fs_ok, true,
+			__return_address);
+}
+
 /*
  * Make sure this record is in order and doesn't stray outside of the parent
  * keys.
@@ -464,5 +512,6 @@ xfs_scrub_btree(
 	}
 
 out:
+
 	return error;
 }
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index 133e33d..0faba6c 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -30,6 +30,16 @@ bool xfs_scrub_btree_op_ok(struct xfs_scrub_context *sc,
 bool xfs_scrub_btree_check_ok(struct xfs_scrub_context *sc,
 			      struct xfs_btree_cur *cur, int level, bool fs_ok);
 
+/* Check for btree xref operation errors. */
+bool xfs_scrub_btree_xref_op_ok(struct xfs_scrub_context *sc,
+				struct xfs_btree_cur *cur, int level,
+				int *error);
+
+/* Check for btree xref discrepancies. */
+bool xfs_scrub_btree_xref_check_ok(struct xfs_scrub_context *sc,
+				   struct xfs_btree_cur *cur, int level,
+				   bool fs_ok);
+
 struct xfs_scrub_btree;
 typedef int (*xfs_scrub_btree_rec_fn)(
 	struct xfs_scrub_btree	*bs,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index a332610..b80c771 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -51,12 +51,14 @@
 /* Common code for the metadata scrubbers. */
 
 /* Check for operational errors. */
-bool
-xfs_scrub_op_ok(
+static bool
+__xfs_scrub_op_ok(
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
@@ -68,24 +70,46 @@ xfs_scrub_op_ok(
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
-xfs_scrub_fblock_op_ok(
+xfs_scrub_op_ok(
+	struct xfs_scrub_context	*sc,
+	xfs_agnumber_t			agno,
+	xfs_agblock_t			bno,
+	int				*error)
+{
+	return __xfs_scrub_op_ok(sc, agno, bno, error, false, __return_address);
+}
+
+bool
+xfs_scrub_xref_op_ok(
+	struct xfs_scrub_context	*sc,
+	xfs_agnumber_t			agno,
+	xfs_agblock_t			bno,
+	int				*error)
+{
+	return __xfs_scrub_op_ok(sc, agno, bno, error, true, __return_address);
+}
+
+/* Check for operational errors for a file offset. */
+static bool
+__xfs_scrub_fblock_op_ok(
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
@@ -97,17 +121,39 @@ xfs_scrub_fblock_op_ok(
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
+xfs_scrub_fblock_op_ok(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	int				*error)
+{
+	return __xfs_scrub_fblock_op_ok(sc, whichfork, offset, error, false,
+			__return_address);
+}
+
+bool
+xfs_scrub_fblock_xref_op_ok(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	int				*error)
+{
+	return __xfs_scrub_fblock_op_ok(sc, whichfork, offset, error, true,
+			__return_address);
+}
+
 /* Check for metadata block optimization possibilities. */
 bool
 xfs_scrub_block_preen_ok(
@@ -163,11 +209,13 @@ xfs_scrub_ino_preen_ok(
 }
 
 /* Check for metadata block corruption. */
-bool
-xfs_scrub_block_check_ok(
+static bool
+__xfs_scrub_block_check_ok(
 	struct xfs_scrub_context	*sc,
 	struct xfs_buf			*bp,
-	bool				fs_ok)
+	bool				fs_ok,
+	bool				xref,
+	void				*ret_ip)
 {
 	struct xfs_mount		*mp = sc->mp;
 	xfs_fsblock_t			fsbno;
@@ -181,19 +229,41 @@ xfs_scrub_block_check_ok(
 	agno = XFS_FSB_TO_AGNO(mp, fsbno);
 	bno = XFS_FSB_TO_AGBNO(mp, fsbno);
 
-	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
-	trace_xfs_scrub_block_error(sc, agno, bno, __return_address);
+	sc->sm->sm_flags |= xfs_scrub_corrupt_flag(xref);
+	trace_xfs_scrub_block_error(sc, agno, bno, ret_ip);
 	return fs_ok;
 }
 
-/* Check for inode metadata corruption. */
 bool
-xfs_scrub_ino_check_ok(
+xfs_scrub_block_check_ok(
 	struct xfs_scrub_context	*sc,
-	xfs_ino_t			ino,
 	struct xfs_buf			*bp,
 	bool				fs_ok)
 {
+	return __xfs_scrub_block_check_ok(sc, bp, fs_ok, false,
+			__return_address);
+}
+
+bool
+xfs_scrub_block_xref_check_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	bool				fs_ok)
+{
+	return __xfs_scrub_block_check_ok(sc, bp, fs_ok, true,
+			__return_address);
+}
+
+/* Check for inode metadata corruption. */
+static bool
+__xfs_scrub_ino_check_ok(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_buf			*bp,
+	bool				fs_ok,
+	bool				xref,
+	void				*ret_ip)
+{
 	struct xfs_inode		*ip = sc->ip;
 	struct xfs_mount		*mp = sc->mp;
 	xfs_fsblock_t			fsbno;
@@ -212,27 +282,73 @@ xfs_scrub_ino_check_ok(
 		bno = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	}
 
-	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
-	trace_xfs_scrub_ino_error(sc, ino, agno, bno, __return_address);
+	sc->sm->sm_flags |= xfs_scrub_corrupt_flag(xref);
+	trace_xfs_scrub_ino_error(sc, ino, agno, bno, ret_ip);
 	return fs_ok;
 }
 
-/* Check for file fork block corruption. */
 bool
-xfs_scrub_fblock_check_ok(
+xfs_scrub_ino_check_ok(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_buf			*bp,
+	bool				fs_ok)
+{
+	return __xfs_scrub_ino_check_ok(sc, ino, bp, fs_ok, false,
+			__return_address);
+}
+
+bool
+xfs_scrub_ino_xref_check_ok(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_buf			*bp,
+	bool				fs_ok)
+{
+	return __xfs_scrub_ino_check_ok(sc, ino, bp, fs_ok, true,
+			__return_address);
+}
+
+/* Check for file fork block corruption. */
+static bool
+__xfs_scrub_fblock_check_ok(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset,
-	bool				fs_ok)
+	bool				fs_ok,
+	bool				xref,
+	void				*ret_ip)
 {
 	if (fs_ok)
 		return fs_ok;
 
-	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
-	trace_xfs_scrub_fblock_error(sc, whichfork, offset, __return_address);
+	sc->sm->sm_flags |= xfs_scrub_corrupt_flag(xref);
+	trace_xfs_scrub_fblock_error(sc, whichfork, offset, ret_ip);
 	return fs_ok;
 }
 
+bool
+xfs_scrub_fblock_check_ok(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	bool				fs_ok)
+{
+	return __xfs_scrub_fblock_check_ok(sc, whichfork, offset, fs_ok,
+			false, __return_address);
+}
+
+bool
+xfs_scrub_fblock_xref_check_ok(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	bool				fs_ok)
+{
+	return __xfs_scrub_fblock_check_ok(sc, whichfork, offset, fs_ok,
+			true, __return_address);
+}
+
 /* Check for inode metadata non-corruption problems. */
 bool
 xfs_scrub_ino_warn_ok(
@@ -634,3 +750,41 @@ xfs_scrub_setup_inode_contents(
 	sc->ip = NULL;
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
index a4a2ca5..c463c9b 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -59,6 +59,14 @@ bool xfs_scrub_op_ok(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 bool xfs_scrub_fblock_op_ok(struct xfs_scrub_context *sc, int whichfork,
 			  xfs_fileoff_t offset, int *error);
 
+/* Check for operational xref errors for a block check. */
+bool xfs_scrub_xref_op_ok(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+			  xfs_agblock_t bno, int *error);
+
+/* Check for operational xref errors for a file offset check. */
+bool xfs_scrub_fblock_xref_op_ok(struct xfs_scrub_context *sc, int whichfork,
+				 xfs_fileoff_t offset, int *error);
+
 /* Check for metadata block optimization possibilities. */
 bool xfs_scrub_block_preen_ok(struct xfs_scrub_context *sc, struct xfs_buf *bp,
 			      bool fs_ok);
@@ -79,6 +87,18 @@ bool xfs_scrub_ino_check_ok(struct xfs_scrub_context *sc, xfs_ino_t ino,
 bool xfs_scrub_fblock_check_ok(struct xfs_scrub_context *sc, int whichfork,
 			       xfs_fileoff_t offset, bool fs_ok);
 
+/* Check for metadata block xref discrepancies. */
+bool xfs_scrub_block_xref_check_ok(struct xfs_scrub_context *sc,
+				   struct xfs_buf *bp, bool fs_ok);
+
+/* Check for inode metadata xref discrepancies. */
+bool xfs_scrub_ino_xref_check_ok(struct xfs_scrub_context *sc, xfs_ino_t ino,
+				 struct xfs_buf *bp, bool fs_ok);
+
+/* Check for file fork block xref discrepancies. */
+bool xfs_scrub_fblock_xref_check_ok(struct xfs_scrub_context *sc, int whichfork,
+				    xfs_fileoff_t offset, bool fs_ok);
+
 /* Check for inode metadata non-corruption weirdness problems. */
 bool xfs_scrub_ino_warn_ok(struct xfs_scrub_context *sc, struct xfs_buf *bp,
 			   bool fs_ok);
@@ -87,6 +107,10 @@ bool xfs_scrub_ino_warn_ok(struct xfs_scrub_context *sc, struct xfs_buf *bp,
 bool xfs_scrub_fblock_warn_ok(struct xfs_scrub_context *sc, int whichfork,
 			      xfs_fileoff_t offset, bool fs_ok);
 
+/* Are we set up for a cross-referencing operation? */
+bool xfs_scrub_should_xref(struct xfs_scrub_context *sc, int *error,
+			   struct xfs_btree_cur **curpp);
+
 /* Signal an incomplete scrub. */
 bool xfs_scrub_check_thoroughness(struct xfs_scrub_context *sc, bool fs_ok);
 
@@ -141,4 +165,10 @@ int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
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
index 8cddfcd..b59e004 100644
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
index a78c8d1..6769e02 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -467,6 +467,28 @@ DEFINE_EVENT(xfs_scrub_sbtree_class, name, \
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

