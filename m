Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25229 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdAUIDz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:03:55 -0500
Subject: [PATCH 32/55] xfs: set up cross-referencing helpers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:03:51 -0800
Message-ID: <148498583106.15323.15748962703310410970.stgit@birch.djwong.org>
In-Reply-To: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Create some helper functions that we'll use later to cross reference
metadata with other metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/btree.c  |  102 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/btree.h  |   47 +++++++++++++++++++----
 fs/xfs/scrub/common.c |   63 +++++++++++++++++++++++++-----
 fs/xfs/scrub/common.h |   84 ++++++++++++++++++++++++++++++++++------
 4 files changed, 261 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 06607de..9ea0fbe 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -112,7 +112,8 @@ xfs_scrub_btree_ok(
 	bool				fs_ok,
 	const char			*check,
 	const char			*func,
-	int				line)
+	int				line,
+	bool				xref)
 {
 	char				bt_ptr[24];
 	char				bt_type[48];
@@ -121,7 +122,7 @@ xfs_scrub_btree_ok(
 	if (fs_ok)
 		return fs_ok;
 
-	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	sc->sm->sm_flags |= CORRUPT_FLAG(xref);
 	xfs_scrub_btree_format(cur, level, bt_type, 48, bt_ptr, 24, &fsbno);
 
 	trace_xfs_scrub_btree_error(cur->bc_mp, bt_type, bt_ptr,
@@ -139,7 +140,8 @@ xfs_scrub_btree_op_ok(
 	int				level,
 	int				*error,
 	const char			*func,
-	int				line)
+	int				line,
+	bool				xref)
 {
 	char				bt_ptr[24];
 	char				bt_type[48];
@@ -153,7 +155,7 @@ xfs_scrub_btree_op_ok(
 	return xfs_scrub_op_ok(sc,
 			XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
-			bt_type, error, func, line);
+			bt_type, error, func, line, xref);
 }
 
 /*
@@ -494,6 +496,84 @@ xfs_scrub_btree_sblock_check_siblings(
 	return error;
 }
 
+struct check_owner {
+	struct list_head	list;
+	xfs_fsblock_t		fsb;
+};
+
+/*
+ * Make sure this btree block isn't in the free list and that there's
+ * an rmap record for it.
+ */
+STATIC int
+xfs_scrub_btree_check_block_owner(
+	struct xfs_scrub_btree		*bs,
+	xfs_fsblock_t			fsb)
+{
+	struct xfs_scrub_ag		sa;
+	struct xfs_scrub_ag		*psa;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+	int				error = 0;
+
+	agno = XFS_FSB_TO_AGNO(bs->cur->bc_mp, fsb);
+	bno = XFS_FSB_TO_AGBNO(bs->cur->bc_mp, fsb);
+
+	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (!xfs_scrub_ag_can_lock(bs->sc, agno))
+			return -EDEADLOCK;
+		error = xfs_scrub_ag_init(bs->sc, agno, &sa);
+		if (error)
+			return error;
+		psa = &sa;
+	} else
+		psa = &bs->sc->sa;
+
+	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		xfs_scrub_ag_free(&sa);
+
+	return error;
+}
+
+/* Check the owner of a btree block. */
+STATIC int
+xfs_scrub_btree_check_owner(
+	struct xfs_scrub_btree		*bs,
+	struct xfs_buf			*bp)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	struct check_owner		*co;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) && bp == NULL)
+		return 0;
+
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+	agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
+
+	/* Turn back if we could deadlock. */
+	if ((bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
+	    !xfs_scrub_ag_can_lock(bs->sc, agno))
+		return -EDEADLOCK;
+
+	/*
+	 * We want to cross-reference each btree block with the bnobt
+	 * and the rmapbt.  We cannot cross-reference the bnobt or
+	 * rmapbt while scanning the bnobt or rmapbt, respectively,
+	 * because that would trash the cursor state.  Therefore, save
+	 * the block numbers for later scanning.
+	 */
+	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
+		co = kmem_alloc(sizeof(struct check_owner), KM_SLEEP | KM_NOFS);
+		co->fsb = fsbno;
+		list_add_tail(&co->list, &bs->to_check);
+		return 0;
+	}
+
+	return xfs_scrub_btree_check_block_owner(bs, fsbno);
+}
+
 /* Grab and scrub a btree block. */
 STATIC int
 xfs_scrub_btree_block(
@@ -514,6 +594,10 @@ xfs_scrub_btree_block(
 	if (error)
 		return error;
 
+	error = xfs_scrub_btree_check_owner(bs, *pbp);
+	if (error)
+		return error;
+
 	return bs->check_siblings_fn(bs, *pblock);
 }
 
@@ -539,6 +623,8 @@ xfs_scrub_btree(
 	struct xfs_btree_block		*block;
 	int				level;
 	struct xfs_buf			*bp;
+	struct check_owner		*co;
+	struct check_owner		*n;
 	int				i;
 	int				error = 0;
 
@@ -653,6 +739,14 @@ xfs_scrub_btree(
 		}
 	}
 
+	/* Process deferred owner checks on btree blocks. */
+	list_for_each_entry_safe(co, n, &bs.to_check, list) {
+		if (!error)
+			error = xfs_scrub_btree_check_block_owner(&bs, co->fsb);
+		list_del(&co->list);
+		kmem_free(co);
+	}
+
 out_badcursor:
 	return error;
 }
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index 75e89b1..d8c8186 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -27,41 +27,72 @@ extern const char * const btree_types[];
 /* Check for btree corruption. */
 bool xfs_scrub_btree_ok(struct xfs_scrub_context *sc,
 			struct xfs_btree_cur *cur, int level, bool fs_ok,
-			const char *check, const char *func, int line);
+			const char *check, const char *func, int line,
+			bool xref);
 
 /* Check for btree operation errors. */
 bool xfs_scrub_btree_op_ok(struct xfs_scrub_context *sc,
 			   struct xfs_btree_cur *cur, int level, int *error,
-			   const char *func, int line);
+			   const char *func, int line, bool xref);
 
 #define XFS_SCRUB_BTREC_CHECK(bs, fs_ok) \
 	xfs_scrub_btree_ok((bs)->sc, (bs)->cur, 0, (fs_ok), #fs_ok, \
-			__func__, __LINE__)
+			__func__, __LINE__, false)
 #define XFS_SCRUB_BTREC_GOTO(bs, fs_ok, label) \
 	do { \
 		if (!xfs_scrub_btree_ok((bs)->sc, (bs)->cur, 0, (fs_ok), \
-				#fs_ok, __func__, __LINE__)) \
+				#fs_ok, __func__, __LINE__, false)) \
 			goto label; \
 	} while (0)
 #define XFS_SCRUB_BTREC_OP_ERROR_GOTO(bs, error, label) \
 	do { \
 		if (!xfs_scrub_btree_op_ok((bs)->sc, (bs)->cur, 0, \
-				(error), __func__, __LINE__)) \
+				(error), __func__, __LINE__, false)) \
 			goto label; \
 	} while (0)
 #define XFS_SCRUB_BTKEY_CHECK(bs, level, fs_ok) \
 	xfs_scrub_btree_ok((bs)->sc, (bs)->cur, (level), (fs_ok), #fs_ok, \
-			__func__, __LINE__)
+			__func__, __LINE__, false)
 #define XFS_SCRUB_BTKEY_GOTO(bs, level, fs_ok, label) \
 	do { \
 		if (!xfs_scrub_btree_ok((bs)->sc, (bs)->cur, (level), (fs_ok), \
-				#fs_ok, __func__, __LINE__)) \
+				#fs_ok, __func__, __LINE__, false)) \
 			goto label; \
 	} while (0)
 #define XFS_SCRUB_BTKEY_OP_ERROR_GOTO(bs, level, error, label) \
 	do { \
 		if (!xfs_scrub_btree_op_ok((bs)->sc, (bs)->cur, (level), \
-				(error), __func__, __LINE__)) \
+				(error), __func__, __LINE__, false)) \
+			goto label; \
+	} while (0)
+#define XFS_SCRUB_BTREC_XCHECK(bs, fs_ok) \
+	xfs_scrub_btree_ok((bs)->sc, (bs)->cur, 0, (fs_ok), #fs_ok, \
+			__func__, __LINE__, true)
+#define XFS_SCRUB_BTREC_XGOTO(bs, fs_ok, label) \
+	do { \
+		if (!xfs_scrub_btree_ok((bs)->sc, (bs)->cur, 0, (fs_ok), \
+				#fs_ok, __func__, __LINE__, true)) \
+			goto label; \
+	} while (0)
+#define XFS_SCRUB_BTREC_OP_ERROR_XGOTO(bs, error, label) \
+	do { \
+		if (!xfs_scrub_btree_op_ok((bs)->sc, (bs)->cur, 0, \
+				(error), __func__, __LINE__, true)) \
+			goto label; \
+	} while (0)
+#define XFS_SCRUB_BTKEY_XCHECK(bs, level, fs_ok) \
+	xfs_scrub_btree_ok((bs)->sc, (bs)->cur, (level), (fs_ok), #fs_ok, \
+			__func__, __LINE__, true)
+#define XFS_SCRUB_BTKEY_XGOTO(bs, level, fs_ok, label) \
+	do { \
+		if (!xfs_scrub_btree_ok((bs)->sc, (bs)->cur, (level), (fs_ok), \
+				#fs_ok, __func__, __LINE__, true)) \
+			goto label; \
+	} while (0)
+#define XFS_SCRUB_BTKEY_OP_ERROR_XGOTO(bs, level, error, label) \
+	do { \
+		if (!xfs_scrub_btree_op_ok((bs)->sc, (bs)->cur, (level), \
+				(error), __func__, __LINE__, true)) \
 			goto label; \
 	} while (0)
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index b7ac141..1c20006 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -119,7 +119,8 @@ xfs_scrub_op_ok(
 	const char			*type,
 	int				*error,
 	const char			*func,
-	int				line)
+	int				line,
+	bool				xref)
 {
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 
@@ -128,7 +129,7 @@ xfs_scrub_op_ok(
 
 	trace_xfs_scrub_op_error(mp, agno, bno, type, *error, func, line);
 	if (*error == -EFSBADCRC || *error == -EFSCORRUPTED) {
-		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+		sc->sm->sm_flags |= CORRUPT_FLAG(xref);
 		*error = 0;
 	}
 	return false;
@@ -143,7 +144,8 @@ xfs_scrub_file_op_ok(
 	const char			*type,
 	int				*error,
 	const char			*func,
-	int				line)
+	int				line,
+	bool				xref)
 {
 	if (*error == 0)
 		return true;
@@ -151,7 +153,7 @@ xfs_scrub_file_op_ok(
 	trace_xfs_scrub_file_op_error(sc->ip, whichfork, offset, type, *error,
 			func, line);
 	if (*error == -EFSBADCRC || *error == -EFSCORRUPTED) {
-		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+		sc->sm->sm_flags |= CORRUPT_FLAG(xref);
 		*error = 0;
 	}
 	return false;
@@ -194,7 +196,8 @@ xfs_scrub_block_ok(
 	bool				fs_ok,
 	const char			*check,
 	const char			*func,
-	int				line)
+	int				line,
+	bool				xref)
 {
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	xfs_fsblock_t			fsbno;
@@ -208,7 +211,7 @@ xfs_scrub_block_ok(
 	agno = XFS_FSB_TO_AGNO(mp, fsbno);
 	bno = XFS_FSB_TO_AGBNO(mp, fsbno);
 
-	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	sc->sm->sm_flags |= CORRUPT_FLAG(xref);
 	trace_xfs_scrub_block_error(mp, agno, bno, type, check, func, line);
 	return fs_ok;
 }
@@ -223,7 +226,8 @@ xfs_scrub_ino_ok(
 	bool				fs_ok,
 	const char			*check,
 	const char			*func,
-	int				line)
+	int				line,
+	bool				xref)
 {
 	struct xfs_inode		*ip = sc->ip;
 	struct xfs_mount		*mp = sc->tp->t_mountp;
@@ -243,7 +247,7 @@ xfs_scrub_ino_ok(
 		bno = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	}
 
-	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	sc->sm->sm_flags |= CORRUPT_FLAG(xref);
 	trace_xfs_scrub_ino_error(mp, ino, agno, bno, type, check, func, line);
 	return fs_ok;
 }
@@ -293,12 +297,13 @@ xfs_scrub_data_ok(
 	bool				fs_ok,
 	const char			*check,
 	const char			*func,
-	int				line)
+	int				line,
+	bool				xref)
 {
 	if (fs_ok)
 		return fs_ok;
 
-	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	sc->sm->sm_flags |= CORRUPT_FLAG(xref);
 	trace_xfs_scrub_data_error(sc->ip, whichfork, offset, type, check,
 			func, line);
 	return fs_ok;
@@ -533,6 +538,44 @@ xfs_scrub_ag_lock_all(
 	return error;
 }
 
+/*
+ * Predicate that decides if we need to evaluate the cross-reference check.
+ * If there was an error accessing the cross-reference btree, just delete
+ * the cursor and skip the check.
+ */
+bool
+__xfs_scrub_should_xref(
+	struct xfs_scrub_context	*sc,
+	int				error,
+	struct xfs_btree_cur		**curpp,
+	const char			*func,
+	int				line)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+
+	/* If not a btree cross-reference, just check the error code. */
+	if (curpp == NULL) {
+		if (error == 0)
+			return true;
+		trace_xfs_scrub_xref_error(mp, "unknown", error, func, line);
+		return false;
+	}
+
+	ASSERT(*curpp != NULL);
+	/* If no error or we've already given up on xref, just bail out. */
+	if (error == 0 || *curpp == NULL)
+		return true;
+
+	/* xref error, delete cursor and bail out. */
+	sc->sm->sm_flags |= XFS_SCRUB_FLAG_XFAIL;
+	trace_xfs_scrub_xref_error(mp, btree_types[(*curpp)->bc_btnum],
+			error, func, line);
+	xfs_btree_del_cursor(*curpp, XFS_BTREE_ERROR);
+	*curpp = NULL;
+
+	return false;
+}
+
 /* Dummy scrubber */
 
 STATIC int
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 8dc68b9..4704b38 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -100,25 +100,44 @@ xfs_scrub_trans_alloc(
 	return xfs_trans_alloc_empty(mp, tpp);
 }
 
+static inline __u32
+CORRUPT_FLAG(
+	bool				xref)
+{
+	return xref ? XFS_SCRUB_FLAG_XCORRUPT : XFS_SCRUB_FLAG_CORRUPT;
+}
+
 /* Check for operational errors. */
 bool xfs_scrub_op_ok(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 		     xfs_agblock_t bno, const char *type, int *error,
-		     const char	*func, int line);
+		     const char	*func, int line, bool xref);
 #define XFS_SCRUB_OP_ERROR_GOTO(sc, agno, bno, type, error, label) \
 	do { \
 		if (!xfs_scrub_op_ok((sc), (agno), (bno), (type), \
-				(error), __func__, __LINE__)) \
+				(error), __func__, __LINE__, false)) \
+			goto label; \
+	} while (0)
+#define XFS_SCRUB_OP_ERROR_XGOTO(sc, agno, bno, type, error, label) \
+	do { \
+		if (!xfs_scrub_op_ok((sc), (agno), (bno), (type), \
+				(error), __func__, __LINE__, true)) \
 			goto label; \
 	} while (0)
 
 /* Check for operational errors for a file offset. */
 bool xfs_scrub_file_op_ok(struct xfs_scrub_context *sc, int whichfork,
 			  xfs_fileoff_t offset, const char *type,
-			  int *error, const char *func, int line);
+			  int *error, const char *func, int line, bool xref);
 #define XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, which, off, type, error, label) \
 	do { \
 		if (!xfs_scrub_file_op_ok((sc), (which), (off), (type), \
-				(error), __func__, __LINE__)) \
+				(error), __func__, __LINE__, false)) \
+			goto label; \
+	} while (0)
+#define XFS_SCRUB_FILE_OP_ERROR_XGOTO(sc, which, off, type, error, label) \
+	do { \
+		if (!xfs_scrub_file_op_ok((sc), (which), (off), (type), \
+				(error), __func__, __LINE__, true)) \
 			goto label; \
 	} while (0)
 
@@ -141,44 +160,83 @@ bool xfs_scrub_ino_preen(struct xfs_scrub_context *sc, struct xfs_buf *bp,
 /* Check for metadata block corruption. */
 bool xfs_scrub_block_ok(struct xfs_scrub_context *sc, struct xfs_buf *bp,
 			const char *type, bool fs_ok, const char *check,
-			const char *func, int line);
+			const char *func, int line, bool xref);
 #define XFS_SCRUB_CHECK(sc, bp, type, fs_ok) \
 	xfs_scrub_block_ok((sc), (bp), (type), (fs_ok), #fs_ok, \
-			__func__, __LINE__)
+			__func__, __LINE__, false)
 #define XFS_SCRUB_GOTO(sc, bp, type, fs_ok, label) \
 	do { \
 		if (!xfs_scrub_block_ok((sc), (bp), (type), (fs_ok), \
-				#fs_ok, __func__, __LINE__)) \
+				#fs_ok, __func__, __LINE__, false)) \
+			goto label; \
+	} while (0)
+#define XFS_SCRUB_XCHECK(sc, bp, type, fs_ok) \
+	xfs_scrub_block_ok((sc), (bp), (type), (fs_ok), #fs_ok, \
+			__func__, __LINE__, true)
+#define XFS_SCRUB_XGOTO(sc, bp, type, fs_ok, label) \
+	do { \
+		if (!xfs_scrub_block_ok((sc), (bp), (type), (fs_ok), \
+				#fs_ok, __func__, __LINE__, true)) \
 			goto label; \
 	} while (0)
 
 /* Check for inode metadata corruption. */
 bool xfs_scrub_ino_ok(struct xfs_scrub_context *sc, xfs_ino_t ino,
 		      struct xfs_buf *bp, const char *type, bool fs_ok,
-		      const char *check, const char *func, int line);
+		      const char *check, const char *func, int line,
+		      bool xref);
 #define XFS_SCRUB_INO_CHECK(sc, ino, bp, type, fs_ok) \
 	xfs_scrub_ino_ok((sc), (ino), (bp), (type), (fs_ok), #fs_ok, \
-			__func__, __LINE__)
+			__func__, __LINE__, false)
 #define XFS_SCRUB_INO_GOTO(sc, ino, bp, type, fs_ok, label) \
 	do { \
 		if (!xfs_scrub_ino_ok((sc), (ino), (bp), (type), (fs_ok), \
-				#fs_ok, __func__, __LINE__)) \
+				#fs_ok, __func__, __LINE__, false)) \
+			goto label; \
+	} while(0)
+#define XFS_SCRUB_INO_XCHECK(sc, ino, bp, type, fs_ok) \
+	xfs_scrub_ino_ok((sc), (ino), (bp), (type), (fs_ok), #fs_ok, \
+			__func__, __LINE__, true)
+#define XFS_SCRUB_INO_XGOTO(sc, ino, bp, type, fs_ok, label) \
+	do { \
+		if (!xfs_scrub_ino_ok((sc), (ino), (bp), (type), (fs_ok), \
+				#fs_ok, __func__, __LINE__, true)) \
 			goto label; \
 	} while(0)
 
 /* Check for file data block corruption. */
 bool xfs_scrub_data_ok(struct xfs_scrub_context *sc, int whichfork,
 		       xfs_fileoff_t offset, const char *type, bool fs_ok,
-		       const char *check, const char *func, int line);
+		       const char *check, const char *func, int line,
+		       bool xref);
 #define XFS_SCRUB_DATA_CHECK(sc, whichfork, offset, type, fs_ok) \
 	xfs_scrub_data_ok((sc), (whichfork), (offset), (type), (fs_ok), \
-			#fs_ok, __func__, __LINE__)
+			#fs_ok, __func__, __LINE__, false)
 #define XFS_SCRUB_DATA_GOTO(sc, whichfork, offset, type, fs_ok, label) \
 	do { \
 		if (!xfs_scrub_data_ok((sc), (whichfork), (offset), \
-				(type), (fs_ok), #fs_ok, __func__, __LINE__)) \
+				(type), (fs_ok), #fs_ok, __func__, __LINE__, \
+				false)) \
 			goto label; \
 	} while(0)
+#define XFS_SCRUB_DATA_XCHECK(sc, whichfork, offset, type, fs_ok) \
+	xfs_scrub_data_ok((sc), (whichfork), (offset), (type), (fs_ok), \
+			#fs_ok, __func__, __LINE__, true)
+#define XFS_SCRUB_DATA_XGOTO(sc, whichfork, offset, type, fs_ok, label) \
+	do { \
+		if (!xfs_scrub_data_ok((sc), (whichfork), (offset), \
+				(type), (fs_ok), #fs_ok, __func__, __LINE__, \
+				true)) \
+			goto label; \
+	} while(0)
+
+bool __xfs_scrub_should_xref(struct xfs_scrub_context *sc, int error,
+			     struct xfs_btree_cur **curpp, const char *func,
+			     int line);
+#define xfs_scrub_should_xref(sc, error, curpp) \
+	__xfs_scrub_should_xref((sc), (error), (curpp), __func__, __LINE__)
+#define xfs_scrub_btree_should_xref(bs, error, curpp) \
+	__xfs_scrub_should_xref((bs)->sc, (error), (curpp), __func__, __LINE__)
 
 bool xfs_scrub_ag_can_lock(struct xfs_scrub_context *sc, xfs_agnumber_t agno);
 int xfs_scrub_ag_lock_all(struct xfs_scrub_context *sc);

