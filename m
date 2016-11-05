Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38719 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbcKEAVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:21:17 -0400
Subject: [PATCH 20/41] xfs: scrub inode block mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:21:12 -0700
Message-ID: <147830527224.2155.3293645617520807735.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Scrub an individual inode's block mappings to make sure they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |   26 +++
 fs/xfs/libxfs/xfs_fs.h         |    5 +
 fs/xfs/xfs_scrub.c             |  301 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h             |    5 +
 4 files changed, 331 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 049fa59..54dd7a7 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -623,6 +623,16 @@ xfs_bmbt_init_key_from_rec(
 }
 
 STATIC void
+xfs_bmbt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->bmbt.br_startoff = cpu_to_be64(
+			xfs_bmbt_disk_get_startoff(&rec->bmbt) +
+			xfs_bmbt_disk_get_blockcount(&rec->bmbt) - 1);
+}
+
+STATIC void
 xfs_bmbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -647,6 +657,16 @@ xfs_bmbt_key_diff(
 				      cur->bc_rec.b.br_startoff;
 }
 
+STATIC __int64_t
+xfs_bmbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be64_to_cpu(k1->bmbt.br_startoff) -
+			  be64_to_cpu(k2->bmbt.br_startoff);
+}
+
 static bool
 xfs_bmbt_verify(
 	struct xfs_buf		*bp)
@@ -737,7 +757,6 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 };
 
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_bmbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -758,7 +777,6 @@ xfs_bmbt_recs_inorder(
 		xfs_bmbt_disk_get_blockcount(&r1->bmbt) <=
 		xfs_bmbt_disk_get_startoff(&r2->bmbt);
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
@@ -772,14 +790,14 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.get_minrecs		= xfs_bmbt_get_minrecs,
 	.get_dmaxrecs		= xfs_bmbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
+	.diff_two_keys		= xfs_bmbt_diff_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 251db32..5c80264 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -586,7 +586,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
 #define XFS_SCRUB_TYPE_INODE	11	/* inode record */
-#define XFS_SCRUB_TYPE_MAX	11
+#define XFS_SCRUB_TYPE_BMBTD	12	/* data fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTA	13	/* attr fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
+#define XFS_SCRUB_TYPE_MAX	14
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 3723c06..4e7b4b4 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1426,6 +1426,26 @@ xfs_scrub_setup_inode(
 	return error;
 }
 
+/* Set us up with an inode and AG headers, if needed. */
+STATIC int
+xfs_scrub_setup_inode_bmap(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	int				error;
+
+	error = xfs_scrub_setup_inode(sc, ip, sm, retry_deadlocked);
+	if (error || !retry_deadlocked)
+		return error;
+
+	error = xfs_scrub_ag_lock_all(sc);
+	if (error)
+		return xfs_scrub_teardown(sc, ip, error);
+	return 0;
+}
+
 /* Metadata scrubbers */
 
 #define XFS_SCRUB_SB_CHECK(fs_ok) \
@@ -2161,6 +2181,284 @@ xfs_scrub_inode(
 #undef XFS_SCRUB_INODE_GOTO
 #undef XFS_SCRUB_INODE_CHECK
 
+/*
+ * Inode fork block mapping (BMBT) scrubber.
+ * More complex than the others because we have to scrub
+ * all the extents regardless of whether or not the fork
+ * is in btree format.
+ */
+
+struct xfs_scrub_bmap_info {
+	struct xfs_scrub_context	*sc;
+	const char			*type;
+	xfs_daddr_t			eofs;
+	xfs_fileoff_t			lastoff;
+	bool				is_rt;
+	bool				is_shared;
+	bool				scrub_btrec;
+	int				whichfork;
+};
+
+#define XFS_SCRUB_BMAP_CHECK(fs_ok) \
+	XFS_SCRUB_INO_CHECK(info->sc, bp, info->type, fs_ok)
+#define XFS_SCRUB_BMAP_GOTO(fs_ok, label) \
+	XFS_SCRUB_INO_GOTO(info->sc, bp, info->type, fs_ok, label)
+#define XFS_SCRUB_BMAP_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_OP_ERROR_GOTO(info->sc, agno, 0, "bmap", &error, label);
+/* Scrub a single extent record. */
+STATIC int
+xfs_scrub_bmap_extent(
+	struct xfs_inode		*ip,
+	struct xfs_btree_cur		*cur,
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_bmbt_irec		*irec)
+{
+	struct xfs_scrub_ag		sa = {0};
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_buf			*bp = NULL;
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			dlen;
+	xfs_agnumber_t			agno;
+	int				error = 0;
+
+	if (cur)
+		xfs_btree_get_block(cur, 0, &bp);
+
+	XFS_SCRUB_BMAP_CHECK(irec->br_startoff >= info->lastoff);
+	XFS_SCRUB_BMAP_CHECK(irec->br_startblock != HOLESTARTBLOCK);
+
+	if (isnullstartblock(irec->br_startblock)) {
+		XFS_SCRUB_BMAP_CHECK(irec->br_state == XFS_EXT_NORM);
+		goto out;
+	}
+
+	/* Actual mapping, so check the block ranges. */
+	if (info->is_rt) {
+		daddr = XFS_FSB_TO_BB(mp, irec->br_startblock);
+		agno = NULLAGNUMBER;
+	} else {
+		daddr = XFS_FSB_TO_DADDR(mp, irec->br_startblock);
+		agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
+	}
+	dlen = XFS_FSB_TO_BB(mp, irec->br_blockcount);
+	XFS_SCRUB_BMAP_CHECK(daddr < info->eofs);
+	XFS_SCRUB_BMAP_CHECK(daddr + dlen < info->eofs);
+	XFS_SCRUB_BMAP_CHECK(irec->br_state != XFS_EXT_UNWRITTEN ||
+			xfs_sb_version_hasextflgbit(&mp->m_sb));
+	if (error)
+		goto out;
+
+	/* Set ourselves up for cross-referencing later. */
+	if (!info->is_rt) {
+		if (!xfs_scrub_ag_can_lock(info->sc, agno))
+			return -EDEADLOCK;
+		error = xfs_scrub_ag_init(info->sc, agno, &sa);
+		XFS_SCRUB_BMAP_OP_ERROR_GOTO(out);
+	}
+
+	xfs_scrub_ag_free(&sa);
+out:
+	info->lastoff = irec->br_startoff + irec->br_blockcount;
+	return error;
+}
+#undef XFS_SCRUB_BMAP_OP_ERROR_GOTO
+#undef XFS_SCRUB_BMAP_GOTO
+#undef XFS_SCRUB_BMAP_CHECK
+
+/* Scrub a bmbt record. */
+STATIC int
+xfs_scrub_bmapbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_bmbt_rec_host	ihost;
+	struct xfs_bmbt_irec		irec;
+	struct xfs_scrub_bmap_info	*info = bs->private;
+
+	if (!info->scrub_btrec)
+		return 0;
+
+	/* Set up the in-core record and scrub it. */
+	ihost.l0 = be64_to_cpu(rec->bmbt.l0);
+	ihost.l1 = be64_to_cpu(rec->bmbt.l1);
+	xfs_bmbt_get_all(&ihost, &irec);
+	return xfs_scrub_bmap_extent(bs->cur->bc_private.b.ip, bs->cur,
+			info, &irec);
+}
+
+#define XFS_SCRUB_FORK_CHECK(fs_ok) \
+	XFS_SCRUB_INO_CHECK(sc, NULL, info.type, fs_ok);
+#define XFS_SCRUB_FORK_GOTO(fs_ok, label) \
+	XFS_SCRUB_INO_GOTO(sc, NULL, info.type, fs_ok, label);
+#define XFS_SCRUB_FORK_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_OP_ERROR_GOTO(sc, \
+			XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino), \
+			XFS_INO_TO_AGBNO(ip->i_mount, ip->i_ino), \
+			info.type, &error, label)
+/* Scrub an inode fork's block mappings. */
+STATIC int
+xfs_scrub_bmap(
+	struct xfs_scrub_context	*sc,
+	int				whichfork)
+{
+	struct xfs_bmbt_irec		irec;
+	struct xfs_scrub_bmap_info	info = {0};
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_ifork		*ifp;
+	struct xfs_btree_cur		*cur;
+	xfs_fileoff_t			off;
+	xfs_fileoff_t			endoff;
+	int				nmaps;
+	int				flags = 0;
+	int				error = 0;
+	int				err2 = 0;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		info.type = "data fork";
+		break;
+	case XFS_ATTR_FORK:
+		info.type = "attr fork";
+		break;
+	case XFS_COW_FORK:
+		info.type = "CoW fork";
+		break;
+	}
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+
+	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
+	info.eofs = XFS_FSB_TO_BB(mp, info.is_rt ? mp->m_sb.sb_rblocks :
+					      mp->m_sb.sb_dblocks);
+	info.whichfork = whichfork;
+	info.is_shared = whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(ip);
+	info.sc = sc;
+
+	switch (whichfork) {
+	case XFS_COW_FORK:
+		/* Non-existent CoW forks are ignorable. */
+		if (!ifp)
+			goto out_unlock;
+		/* No CoW forks on non-reflink inodes/filesystems. */
+		XFS_SCRUB_FORK_GOTO(xfs_is_reflink_inode(ip), out_unlock);
+		break;
+	case XFS_ATTR_FORK:
+		if (!ifp)
+			goto out_unlock;
+		XFS_SCRUB_FORK_CHECK(xfs_sb_version_hasattr(&mp->m_sb));
+		break;
+	}
+
+	/* Check the fork values */
+	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
+	case XFS_DINODE_FMT_UUID:
+	case XFS_DINODE_FMT_DEV:
+	case XFS_DINODE_FMT_LOCAL:
+		/* No mappings to check. */
+		goto out_unlock;
+	case XFS_DINODE_FMT_EXTENTS:
+		XFS_SCRUB_FORK_GOTO(ifp->if_flags & XFS_IFEXTENTS, out_unlock);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		XFS_SCRUB_FORK_CHECK(whichfork != XFS_COW_FORK);
+		/*
+		 * Scan the btree.  If extents aren't loaded, have the btree
+		 * scrub routine examine the extent records.
+		 */
+		info.scrub_btrec = !(ifp->if_flags & XFS_IFEXTENTS);
+
+		cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
+		xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
+		err2 = xfs_scrub_btree(sc, cur, xfs_scrub_bmapbt_helper,
+				&oinfo, &info);
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+		if (err2 == -EDEADLOCK)
+			return err2;
+		else if (err2)
+			goto out_unlock;
+		/* Skip in-core extent checking if we did it in the btree */
+		if (info.scrub_btrec)
+			goto out_unlock;
+		break;
+	default:
+		XFS_SCRUB_FORK_GOTO(false, out_unlock);
+		break;
+	}
+
+	/* Extent data is in memory, so scrub that. */
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
+		flags |= XFS_BMAPI_ATTRFORK;
+		break;
+	case XFS_COW_FORK:
+		flags |= XFS_BMAPI_COWFORK;
+		break;
+	default:
+		break;
+	}
+
+	/* Find the offset of the last extent in the mapping. */
+	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
+	XFS_SCRUB_FORK_OP_ERROR_GOTO(out_unlock);
+
+	/* Scrub extent records. */
+	off = 0;
+	while (true) {
+		nmaps = 1;
+		err2 = xfs_bmapi_read(ip, off, endoff - off, &irec,
+				&nmaps, flags);
+		if (err2 || nmaps == 0 || irec.br_startoff > endoff)
+			break;
+		/* Scrub non-hole extent. */
+		if (irec.br_startblock != HOLESTARTBLOCK) {
+			err2 = xfs_scrub_bmap_extent(ip, NULL, &info, &irec);
+			if (err2 == -EDEADLOCK)
+				return err2;
+			else if (!error && err2)
+				error = err2;
+			if (xfs_scrub_should_terminate(&error))
+				break;
+		}
+
+		off += irec.br_blockcount;
+	}
+
+out_unlock:
+	if (error == 0 && err2 != 0)
+		error = err2;
+	return error;
+}
+#undef XFS_SCRUB_FORK_CHECK
+#undef XFS_SCRUB_FORK_GOTO
+
+/* Scrub an inode's data fork. */
+STATIC int
+xfs_scrub_bmap_data(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_bmap(sc, XFS_DATA_FORK);
+}
+
+/* Scrub an inode's attr fork. */
+STATIC int
+xfs_scrub_bmap_attr(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_bmap(sc, XFS_ATTR_FORK);
+}
+
+/* Scrub an inode's CoW fork. */
+STATIC int
+xfs_scrub_bmap_cow(
+	struct xfs_scrub_context	*sc)
+{
+	if (!xfs_is_reflink_inode(sc->ip))
+		return -ENOENT;
+
+	return xfs_scrub_bmap(sc, XFS_COW_FORK);
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -2184,6 +2482,9 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_rmapbt, NULL, xfs_sb_version_hasrmapbt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, NULL, xfs_sb_version_hasreflink},
 	{xfs_scrub_setup_inode, xfs_scrub_inode, NULL, NULL},
+	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_data, NULL, NULL},
+	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_attr, NULL, NULL},
+	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_cow, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e37c8bc..dd48b5a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3473,7 +3473,10 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
 	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
 	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }, \
-	{ XFS_SCRUB_TYPE_INODE,		"inode" }
+	{ XFS_SCRUB_TYPE_INODE,		"inode" }, \
+	{ XFS_SCRUB_TYPE_BMBTD, 	"bmapbtd" }, \
+	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
+	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

