Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7124C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbiLaCNC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:13:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C771C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:12:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A393D61D17
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9B0C433EF;
        Sat, 31 Dec 2022 02:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452776;
        bh=6+bHbF0P/BLjySRDRPyuBO5Nw5h5ienlJIp0yBsf+uw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ca51Wn0RW+3dQKGMioyk+HRjEwfmIB8AD1vn6M7DAAE9QuuwEKvaq5mhqV46MKJPD
         6w4upbktTiLNfORdrHskIT6mbsFYGbf8ofZzXuzft9GMZ/lWVnX06cxey5w6T48Uh5
         pRWmF/btl8QnQ13uZd2sGuNYmyVm2ljIu/cmfVqhBX3arGY4tr/8gZF+I/2kv2v0GF
         IiUoOCybXVBgaLFdFxx5GQd0z3Lv9y1bWL4SwPVuoi7HmIHHIemO2itxMzPYmXh1Zl
         CkaKny5tADHmkIVDEQ8Uar6EFW6rTwODizsL/lj20dzCjr9NlgFRn429W3TMqG8nEZ
         /FE0d1sCbM9Vg==
Subject: [PATCH 12/46] xfs: read and write metadata inode directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876094.725900.9259540554305315495.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Plumb in the bits we need to look up metadata inode numbers from the
metadata inode directory and save them back.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h      |    8 +
 include/xfs_trace.h      |    6 
 libxfs/inode.c           |   93 ++++++
 libxfs/libxfs_api_defs.h |    1 
 libxfs/libxfs_priv.h     |    2 
 libxfs/xfs_imeta.c       |  699 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h       |   17 +
 libxfs/xfs_inode_util.c  |    2 
 libxfs/xfs_trans_resv.c  |    8 -
 9 files changed, 829 insertions(+), 7 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index b099c036ef2..b8e82090628 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -32,6 +32,11 @@ static inline kgid_t make_kgid(gid_t gid)
 	return v;
 }
 
+#define KUIDT_INIT(value) (kuid_t){ value }
+#define KGIDT_INIT(value) (kgid_t){ value }
+#define GLOBAL_ROOT_UID KUIDT_INIT(0)
+#define GLOBAL_ROOT_GID KGIDT_INIT(0)
+
 /* These match kernel side includes */
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
@@ -320,4 +325,7 @@ extern void	libxfs_irele(struct xfs_inode *ip);
 #define xfs_inherit_nosymlinks	(false)
 #define xfs_inherit_nodefrag	(false)
 
+int libxfs_ifree_cluster(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *free_ip, struct xfs_icluster *xic);
+
 #endif /* __XFS_INODE_H__ */
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 78bce651a6f..fef869dbea3 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -349,6 +349,12 @@
 #define trace_xfs_perag_get_tag(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_put(a,b,c,d)		((c) = (c))
 
+#define trace_xfs_imeta_dir_link(...)		((void) 0)
+#define trace_xfs_imeta_dir_lookup_component(...) ((void) 0)
+#define trace_xfs_imeta_dir_lookup_found(...)	((void) 0)
+#define trace_xfs_imeta_dir_try_create(...)	((void) 0)
+#define trace_xfs_imeta_dir_created(...)	((void) 0)
+#define trace_xfs_imeta_dir_unlinked(...)	((void) 0)
 #define trace_xfs_imeta_end_update(...)		((void) 0)
 #define trace_xfs_imeta_sb_link(...)		((void) 0)
 #define trace_xfs_imeta_sb_lookup(...)		((void) 0)
diff --git a/libxfs/inode.c b/libxfs/inode.c
index db42529e07e..8dabad93247 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -314,3 +314,96 @@ void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
 		inode_fsgid_set(inode, mnt_userns);
 	inode->i_mode = mode;
 }
+
+/*
+ * This call is used to indicate that the buffer is going to
+ * be staled and was an inode buffer. This means it gets
+ * special processing during unpin - where any inodes
+ * associated with the buffer should be removed from ail.
+ * There is also special processing during recovery,
+ * any replay of the inodes in the buffer needs to be
+ * prevented as the buffer may have been reused.
+ */
+static void
+xfs_trans_stale_inode_buf(
+	xfs_trans_t		*tp,
+	struct xfs_buf		*bp)
+{
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+
+	bp->b_flags |= _XBF_INODES;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
+}
+
+/*
+ * A big issue when freeing the inode cluster is that we _cannot_ skip any
+ * inodes that are in memory - they all must be marked stale and attached to
+ * the cluster buffer.
+ */
+int
+libxfs_ifree_cluster(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*free_ip,
+	struct xfs_icluster	*xic)
+{
+	struct xfs_mount	*mp = free_ip->i_mount;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	struct xfs_buf		*bp;
+	xfs_daddr_t		blkno;
+	xfs_ino_t		inum = xic->first_ino;
+	int			nbufs;
+	int			j;
+	int			ioffset;
+	int			error;
+
+	nbufs = igeo->ialloc_blks / igeo->blocks_per_cluster;
+
+	for (j = 0; j < nbufs; j++, inum += igeo->inodes_per_cluster) {
+		/*
+		 * The allocation bitmap tells us which inodes of the chunk were
+		 * physically allocated. Skip the cluster if an inode falls into
+		 * a sparse region.
+		 */
+		ioffset = inum - xic->first_ino;
+		if ((xic->alloc & XFS_INOBT_MASK(ioffset)) == 0) {
+			ASSERT(ioffset % igeo->inodes_per_cluster == 0);
+			continue;
+		}
+
+		blkno = XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, inum),
+					 XFS_INO_TO_AGBNO(mp, inum));
+
+		/*
+		 * We obtain and lock the backing buffer first in the process
+		 * here to ensure dirty inodes attached to the buffer remain in
+		 * the flushing state while we mark them stale.
+		 *
+		 * If we scan the in-memory inodes first, then buffer IO can
+		 * complete before we get a lock on it, and hence we may fail
+		 * to mark all the active inodes on the buffer stale.
+		 */
+		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
+				mp->m_bsize * igeo->blocks_per_cluster,
+				XBF_UNMAPPED, &bp);
+		if (error)
+			return error;
+
+		/*
+		 * This buffer may not have been correctly initialised as we
+		 * didn't read it from disk. That's not important because we are
+		 * only using to mark the buffer as stale in the log, and to
+		 * attach stale cached inodes on it. That means it will never be
+		 * dispatched for IO. If it is, we want to know about it, and we
+		 * want it to fail. We can acheive this by adding a write
+		 * verifier to the buffer.
+		 */
+		bp->b_ops = &xfs_inode_buf_ops;
+
+		xfs_trans_stale_inode_buf(tp, bp);
+		xfs_trans_binval(tp, bp);
+	}
+	return 0;
+}
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c27949e5f48..d4cc059abfb 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -154,6 +154,7 @@
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
 #define xfs_iext_next			libxfs_iext_next
 #define xfs_ifork_zap_attr		libxfs_ifork_zap_attr
+#define xfs_ifree_cluster		libxfs_ifree_cluster
 #define xfs_imap_to_bp			libxfs_imap_to_bp
 
 #define xfs_imeta_create		libxfs_imeta_create
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 85b54f16803..b7885cfea06 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -167,6 +167,8 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
 #define XFS_ERRLEVEL_LOW		1
 #define XFS_ILOCK_EXCL			0
+#define XFS_IOLOCK_SHARED		0
+#define XFS_IOLOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index 8fa0b5a5c1c..9e92186b58c 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -22,6 +22,9 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_trans_space.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_ag.h"
 
 /*
  * Metadata Inode Number Management
@@ -42,9 +45,16 @@
  * this structure must be passed to xfs_imeta_end_update to free resources that
  * cannot be freed during the transaction.
  *
- * Right now we only support callers passing in the predefined metadata inode
- * paths; the goal is that callers will some day locate metadata inodes based
- * on path lookups into a metadata directory structure.
+ * When the metadata directory tree (metadir) feature is enabled, we can create
+ * a complex directory tree in which to store metadata inodes.  Inodes within
+ * the metadata directory tree should have the "metadata" inode flag set to
+ * prevent them from being exposed to the outside world.
+ *
+ * Callers are expected to take the IOLOCK of metadata directories when
+ * performing lookups or updates to the tree.  They are expected to take the
+ * ILOCK of any inode in the metadata directory tree (just like the regular to
+ * synchronize access to that inode.  It is not necessary to take the MMAPLOCK
+ * since metadata inodes should never be exposed to user space.
  */
 
 /* Static metadata inode paths */
@@ -60,6 +70,11 @@ XFS_IMETA_DEFINE_PATH(XFS_IMETA_USRQUOTA,	usrquota_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_GRPQUOTA,	grpquota_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_PRJQUOTA,	prjquota_path);
 
+const struct xfs_imeta_path XFS_IMETA_METADIR = {
+	.im_depth = 0,
+	.im_ftype = XFS_DIR3_FT_DIR,
+};
+
 /* Are these two paths equal? */
 STATIC bool
 xfs_imeta_path_compare(
@@ -117,6 +132,10 @@ static const struct xfs_imeta_sbmap {
 		.path	= &XFS_IMETA_PRJQUOTA,
 		.offset	= offsetof(struct xfs_sb, sb_pquotino),
 	},
+	{
+		.path	= &XFS_IMETA_METADIR,
+		.offset	= offsetof(struct xfs_sb, sb_metadirino),
+	},
 	{ NULL, 0 },
 };
 
@@ -288,6 +307,523 @@ xfs_imeta_sb_link(
 	return 0;
 }
 
+/* Functions for storing and retrieving metadata directory inode values. */
+
+static inline void
+set_xname(
+	struct xfs_name			*xname,
+	const struct xfs_imeta_path	*path,
+	unsigned int			path_idx,
+	unsigned char			ftype)
+{
+	xname->name = (const unsigned char *)path->im_path[path_idx];
+	xname->len = strlen(path->im_path[path_idx]);
+	xname->type = ftype;
+}
+
+/* Look up the inode number and filetype for an exact name in a directory. */
+static inline int
+xfs_imeta_dir_lookup(
+	struct xfs_inode	*dp,
+	struct xfs_name		*xname,
+	xfs_ino_t		*ino)
+{
+	struct xfs_da_args	args = {
+		.dp		= dp,
+		.geo		= dp->i_mount->m_dir_geo,
+		.name		= xname->name,
+		.namelen	= xname->len,
+		.hashval	= xfs_dir2_hashname(dp->i_mount, xname),
+		.whichfork	= XFS_DATA_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.owner		= dp->i_ino,
+	};
+	unsigned int		lock_mode;
+	bool			isblock, isleaf;
+	int			error;
+
+	if (xfs_is_shutdown(dp->i_mount))
+		return -EIO;
+
+	lock_mode = xfs_ilock_data_map_shared(dp);
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		error = xfs_dir2_sf_lookup(&args);
+		goto out_unlock;
+	}
+
+	/* dir2 functions require that the data fork is loaded */
+	error = xfs_iread_extents(NULL, dp, XFS_DATA_FORK);
+	if (error)
+		goto out_unlock;
+
+	error = xfs_dir2_isblock(&args, &isblock);
+	if (error)
+		goto out_unlock;
+
+	if (isblock) {
+		error = xfs_dir2_block_lookup(&args);
+		goto out_unlock;
+	}
+
+	error = xfs_dir2_isleaf(&args, &isleaf);
+	if (error)
+		goto out_unlock;
+
+	if (isleaf) {
+		error = xfs_dir2_leaf_lookup(&args);
+		goto out_unlock;
+	}
+
+	error = xfs_dir2_node_lookup(&args);
+
+out_unlock:
+	xfs_iunlock(dp, lock_mode);
+	if (error == -EEXIST)
+		error = 0;
+	if (error)
+		return error;
+
+	*ino = args.inumber;
+	xname->type = args.filetype;
+	return 0;
+}
+/*
+ * Given a parent directory @dp, a metadata inode @path and component
+ * @path_idx, and the expected file type @ftype of the path component, fill out
+ * the @xname and look up the inode number in the directory, returning it in
+ * @ino.
+ */
+static inline int
+xfs_imeta_dir_lookup_component(
+	struct xfs_inode		*dp,
+	struct xfs_name			*xname,
+	xfs_ino_t			*ino)
+{
+	int				type_wanted = xname->type;
+	int				error;
+
+	trace_xfs_imeta_dir_lookup_component(dp, xname, NULLFSINO);
+
+	if (!S_ISDIR(VFS_I(dp)->i_mode))
+		return -EFSCORRUPTED;
+
+	error = xfs_imeta_dir_lookup(dp, xname, ino);
+	if (error)
+		return error;
+	if (!xfs_verify_ino(dp->i_mount, *ino))
+		return -EFSCORRUPTED;
+	if (type_wanted != XFS_DIR3_FT_UNKNOWN && xname->type != type_wanted)
+		return -EFSCORRUPTED;
+
+	trace_xfs_imeta_dir_lookup_found(dp, xname, *ino);
+	return 0;
+}
+
+/*
+ * Traverse a metadata directory tree path, returning the inode corresponding
+ * to the parent of the last path component.  If any of the path components do
+ * not exist, return -ENOENT.
+ */
+STATIC int
+xfs_imeta_dir_parent(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		**dpp)
+{
+	struct xfs_name			xname;
+	struct xfs_inode		*dp;
+	xfs_ino_t			ino;
+	unsigned int			i;
+	int				error;
+
+	if (mp->m_metadirip == NULL)
+		return -ENOENT;
+
+	/* Grab the metadir root. */
+	error = xfs_imeta_iget(mp, mp->m_metadirip->i_ino, XFS_DIR3_FT_DIR,
+			&dp);
+	if (error)
+		return error;
+
+	/* Caller wanted the root, we're done! */
+	if (path->im_depth == 0) {
+		*dpp = dp;
+		return 0;
+	}
+
+	for (i = 0; i < path->im_depth - 1; i++) {
+		struct xfs_inode	*ip = NULL;
+
+		xfs_ilock(dp, XFS_IOLOCK_SHARED);
+
+		/* Look up the name in the current directory. */
+		set_xname(&xname, path, i, XFS_DIR3_FT_DIR);
+		error = xfs_imeta_dir_lookup_component(dp, &xname, &ino);
+		if (error)
+			goto out_rele;
+
+		/*
+		 * Grab the child inode while we still have the parent
+		 * directory locked.
+		 */
+		error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_DIR, &ip);
+		if (error)
+			goto out_rele;
+
+		xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+		xfs_imeta_irele(dp);
+		dp = ip;
+	}
+
+	*dpp = dp;
+	return 0;
+
+out_rele:
+	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+	xfs_imeta_irele(dp);
+	return error;
+}
+
+/*
+ * Look up a metadata inode from the metadata directory.  If the last path
+ * component doesn't exist, return NULLFSINO.  If any other part of the path
+ * does not exist, return -ENOENT so we can distinguish the two.
+ */
+STATIC int
+xfs_imeta_dir_lookup_int(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			*inop)
+{
+	struct xfs_name			xname;
+	struct xfs_inode		*dp = NULL;
+	xfs_ino_t			ino;
+	int				error;
+
+	/* metadir ino is recorded in superblock */
+	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR))
+		return xfs_imeta_sb_lookup(mp, path, inop);
+
+	ASSERT(path->im_depth > 0);
+
+	/* Find the parent of the last path component. */
+	error = xfs_imeta_dir_parent(mp, path, &dp);
+	if (error)
+		return error;
+
+	xfs_ilock(dp, XFS_IOLOCK_SHARED);
+
+	/* Look up the name in the current directory. */
+	set_xname(&xname, path, path->im_depth - 1, path->im_ftype);
+	error = xfs_imeta_dir_lookup_component(dp, &xname, &ino);
+	switch (error) {
+	case 0:
+		*inop = ino;
+		break;
+	case -ENOENT:
+		*inop = NULLFSINO;
+		error = 0;
+		break;
+	}
+
+	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+	xfs_imeta_irele(dp);
+	return error;
+}
+
+/*
+ * Load all the metadata inode pointers that are cached in the in-core
+ * superblock but live somewhere in the metadata directory tree.
+ */
+STATIC int
+xfs_imeta_dir_mount(
+	struct xfs_mount		*mp)
+{
+	const struct xfs_imeta_sbmap	*p;
+	xfs_ino_t			*sb_inop;
+	int				err2;
+	int				error = 0;
+
+	for (p = xfs_imeta_sbmaps; p->path && p->path->im_depth > 0; p++) {
+		if (p->path == &XFS_IMETA_METADIR)
+			continue;
+		sb_inop = xfs_imeta_sbmap_to_inop(mp, p);
+		err2 = xfs_imeta_dir_lookup_int(mp, p->path, sb_inop);
+		if (err2 == -ENOENT) {
+			*sb_inop = NULLFSINO;
+			continue;
+		}
+		if (!error && err2)
+			error = err2;
+	}
+
+	return error;
+}
+
+/* Set up an inode to be recognized as a metadata inode. */
+void
+xfs_imeta_set_metaflag(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	VFS_I(ip)->i_mode &= ~0777;
+	VFS_I(ip)->i_uid = GLOBAL_ROOT_UID;
+	VFS_I(ip)->i_gid = GLOBAL_ROOT_GID;
+	ip->i_projid = 0;
+	ip->i_diflags |= (XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_SYNC |
+			  XFS_DIFLAG_NOATIME | XFS_DIFLAG_NODUMP |
+			  XFS_DIFLAG_NODEFRAG);
+	if (S_ISDIR(VFS_I(ip)->i_mode))
+		ip->i_diflags |= XFS_DIFLAG_NOSYMLINKS;
+	ip->i_diflags2 &= ~XFS_DIFLAG2_DAX;
+	ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+/*
+ * Create a new metadata inode accessible via the given metadata directory path.
+ * Callers must ensure that the directory entry does not already exist; a new
+ * one will be created.
+ */
+STATIC int
+xfs_imeta_dir_create(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	umode_t				mode,
+	unsigned int			flags,
+	struct xfs_inode		**ipp,
+	struct xfs_imeta_update		*upd)
+{
+	struct xfs_icreate_args		args = {
+		.nlink			= S_ISDIR(mode) ? 2 : 1,
+	};
+	struct xfs_name			xname;
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	struct xfs_inode		*dp = upd->dp;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	xfs_icreate_args_rootfile(&args, mode);
+
+	/* metadir ino is recorded in superblock; only mkfs gets to do this */
+	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR)) {
+		error = xfs_imeta_sb_create(tpp, path, mode, flags, ipp);
+		if (error)
+			return error;
+
+		/* Set the metadata iflag, initialize directory. */
+		xfs_imeta_set_metaflag(*tpp, *ipp);
+		return xfs_dir_init(*tpp, *ipp, *ipp);
+	}
+
+	ASSERT(path->im_depth > 0);
+
+	/* Check that the name does not already exist in the directory. */
+	set_xname(&xname, path, path->im_depth - 1, XFS_DIR3_FT_UNKNOWN);
+	error = xfs_imeta_dir_lookup_component(dp, &xname, &ino);
+	switch (error) {
+	case -ENOENT:
+		break;
+	case 0:
+		error = -EEXIST;
+		fallthrough;
+	default:
+		return error;
+	}
+
+	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+	args.pip = dp;
+
+	/*
+	 * A newly created regular or special file just has one directory
+	 * entry pointing to them, but a directory also the "." entry
+	 * pointing to itself.
+	 */
+	error = xfs_dialloc(tpp, dp->i_ino, mode, &ino);
+	if (error)
+		goto out_ilock;
+	error = xfs_icreate(*tpp, ino, &args, ipp);
+	if (error)
+		goto out_ilock;
+	xfs_imeta_set_metaflag(*tpp, *ipp);
+
+	/*
+	 * Once we join the parent directory to the transaction we can't
+	 * release it until after the transaction commits or cancels, so we
+	 * must defer releasing it to end_update.  This is different from
+	 * regular file creation, where the vfs holds the parent dir reference
+	 * and will free it.  The caller is always responsible for releasing
+	 * ipp, even if we failed.
+	 */
+	xfs_trans_ijoin(*tpp, dp, XFS_ILOCK_EXCL);
+
+	/* Create the entry. */
+	if (S_ISDIR(args.mode))
+		resblks = XFS_MKDIR_SPACE_RES(mp, xname.len);
+	else
+		resblks = XFS_CREATE_SPACE_RES(mp, xname.len);
+	xname.type = xfs_mode_to_ftype(args.mode);
+	trace_xfs_imeta_dir_try_create(dp, &xname, NULLFSINO);
+	error = xfs_dir_create_new_child(*tpp, resblks, dp, &xname, *ipp);
+	if (error)
+		return error;
+	trace_xfs_imeta_dir_created(*ipp, &xname, ino);
+
+	/* Attach dquots to this file.  Caller should have allocated them! */
+	if (!(flags & XFS_IMETA_CREATE_NOQUOTA)) {
+		error = xfs_qm_dqattach_locked(*ipp, false);
+		if (error)
+			return error;
+		xfs_trans_mod_dquot_byino(*tpp, *ipp, XFS_TRANS_DQ_ICOUNT, 1);
+	}
+
+	/* Update the in-core superblock value if there is one. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (sb_inop)
+		*sb_inop = ino;
+	return 0;
+
+out_ilock:
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	return error;
+}
+
+/*
+ * Remove the given entry from the metadata directory and drop the link count
+ * of the metadata inode.
+ */
+STATIC int
+xfs_imeta_dir_unlink(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip,
+	struct xfs_imeta_update		*upd)
+{
+	struct xfs_name			xname;
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	struct xfs_inode		*dp = upd->dp;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	/* Metadata directory root cannot be unlinked. */
+	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	ASSERT(path->im_depth > 0);
+
+	/* Look up the name in the current directory. */
+	set_xname(&xname, path, path->im_depth - 1,
+			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
+	error = xfs_imeta_dir_lookup_component(dp, &xname, &ino);
+	switch (error) {
+	case 0:
+		if (ino != ip->i_ino)
+			error = -ENOENT;
+		break;
+	case -ENOENT:
+		error = -EFSCORRUPTED;
+		break;
+	}
+	if (error)
+		return error;
+
+	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * Once we join the parent directory to the transaction we can't
+	 * release it until after the transaction commits or cancels, so we
+	 * must defer releasing it to end_update.  This is different from
+	 * regular file removal, where the vfs holds the parent dir reference
+	 * and will free it.  The unlink caller is always responsible for
+	 * releasing ip, so we don't need to take care of that.
+	 */
+	xfs_trans_ijoin(*tpp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(*tpp, ip, XFS_ILOCK_EXCL);
+
+	resblks = XFS_REMOVE_SPACE_RES(mp);
+	error = xfs_dir_remove_child(*tpp, resblks, dp, &xname, ip);
+	if (error)
+		return error;
+	trace_xfs_imeta_dir_unlinked(dp, &xname, ip->i_ino);
+
+	/* Update the in-core superblock value if there is one. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (sb_inop)
+		*sb_inop = NULLFSINO;
+	return 0;
+}
+
+/* Set the given path in the metadata directory to point to an inode. */
+STATIC int
+xfs_imeta_dir_link(
+	struct xfs_trans		*tp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip,
+	struct xfs_imeta_update		*upd)
+{
+	struct xfs_name			xname;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_inode		*dp = upd->dp;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	/* Metadata directory root cannot be linked. */
+	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	ASSERT(path->im_depth > 0);
+
+	/* Look up the name in the current directory. */
+	set_xname(&xname, path, path->im_depth - 1,
+			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
+	error = xfs_imeta_dir_lookup_component(dp, &xname, &ino);
+	switch (error) {
+	case -ENOENT:
+		break;
+	case 0:
+		error = -EEXIST;
+		fallthrough;
+	default:
+		return error;
+	}
+
+	xfs_lock_two_inodes(ip, XFS_ILOCK_EXCL, dp, XFS_ILOCK_EXCL);
+
+	/*
+	 * Once we join the parent directory to the transaction we can't
+	 * release it until after the transaction commits or cancels, so we
+	 * must defer releasing it to end_update.  This is different from
+	 * regular file removal, where the vfs holds the parent dir reference
+	 * and will free it.  The link caller is always responsible for
+	 * releasing ip, so we don't need to take care of that.
+	 */
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+
+	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
+	error = xfs_dir_link_existing_child(tp, resblks, dp, &xname, ip);
+	if (error)
+		return error;
+
+	trace_xfs_imeta_dir_link(dp, &xname, ip->i_ino);
+
+	/* Update the in-core superblock value if there is one. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (sb_inop)
+		*sb_inop = ip->i_ino;
+	return 0;
+}
+
 /* General functions for managing metadata inode pointers */
 
 /*
@@ -317,7 +853,13 @@ xfs_imeta_lookup(
 
 	ASSERT(xfs_imeta_path_check(path));
 
-	error = xfs_imeta_sb_lookup(mp, path, &ino);
+	if (xfs_has_metadir(mp)) {
+		error = xfs_imeta_dir_lookup_int(mp, path, &ino);
+		if (error == -ENOENT)
+			return -EFSCORRUPTED;
+	} else {
+		error = xfs_imeta_sb_lookup(mp, path, &ino);
+	}
 	if (error)
 		return error;
 
@@ -350,12 +892,49 @@ xfs_imeta_create(
 	struct xfs_inode		**ipp,
 	struct xfs_imeta_update		*upd)
 {
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+
 	ASSERT(xfs_imeta_path_check(path));
 	*ipp = NULL;
 
+	if (xfs_has_metadir(mp))
+		return xfs_imeta_dir_create(tpp, path, mode, flags, ipp,
+				upd);
 	return xfs_imeta_sb_create(tpp, path, mode, flags, ipp);
 }
 
+/* Free a file from the metadata directory tree. */
+STATIC int
+xfs_imeta_ifree(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	struct xfs_icluster	xic = { 0 };
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(ip->i_df.if_nextents == 0);
+	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
+	ASSERT(ip->i_nblocks == 0);
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
+	error = xfs_dir_ifree(tp, pag, ip, &xic);
+	if (error)
+		goto out;
+
+	/* Metadata files do not support ownership changes or DMAPI. */
+
+	if (xic.deleted)
+		error = xfs_ifree_cluster(tp, pag, ip, &xic);
+out:
+	xfs_perag_put(pag);
+	return error;
+}
+
 /*
  * Unlink a metadata inode @ip from the metadata directory given by @path.  The
  * metadata inode must not be ILOCKed.  Upon return, the inode will be ijoined
@@ -369,10 +948,28 @@ xfs_imeta_unlink(
 	struct xfs_inode		*ip,
 	struct xfs_imeta_update		*upd)
 {
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	int				error;
+
 	ASSERT(xfs_imeta_path_check(path));
 	ASSERT(xfs_imeta_verify((*tpp)->t_mountp, ip->i_ino));
 
-	return xfs_imeta_sb_unlink(tpp, path, ip);
+	if (xfs_has_metadir(mp))
+		error = xfs_imeta_dir_unlink(tpp, path, ip, upd);
+	else
+		error = xfs_imeta_sb_unlink(tpp, path, ip);
+	if (error)
+		return error;
+
+	/*
+	 * Metadata files require explicit resource cleanup.  In other words,
+	 * the inactivation system will not touch these files, so we must free
+	 * the ondisk inode by ourselves if warranted.
+	 */
+	if (VFS_I(ip)->i_nlink > 0)
+		return 0;
+
+	return xfs_imeta_ifree(*tpp, ip);
 }
 
 /*
@@ -387,8 +984,12 @@ xfs_imeta_link(
 	struct xfs_inode		*ip,
 	struct xfs_imeta_update		*upd)
 {
+	struct xfs_mount		*mp = tp->t_mountp;
+
 	ASSERT(xfs_imeta_path_check(path));
 
+	if (xfs_has_metadir(mp))
+		return xfs_imeta_dir_link(tp, path, ip, upd);
 	return xfs_imeta_sb_link(tp, path, ip);
 }
 
@@ -403,6 +1004,14 @@ xfs_imeta_end_update(
 	int				error)
 {
 	trace_xfs_imeta_end_update(mp, error, __return_address);
+
+	if (upd->dp) {
+		if (upd->lock_mode)
+			xfs_iunlock(upd->dp, upd->lock_mode);
+		xfs_imeta_irele(upd->dp);
+	}
+	upd->lock_mode = 0;
+	upd->dp = NULL;
 }
 
 /* Start setting up for a metadata directory tree operation. */
@@ -412,9 +1021,32 @@ xfs_imeta_start_update(
 	const struct xfs_imeta_path	*path,
 	struct xfs_imeta_update		*upd)
 {
+	int				error;
+
 	trace_xfs_imeta_start_update(mp, 0, __return_address);
 
 	memset(upd, 0, sizeof(struct xfs_imeta_update));
+
+	/* Metadir root directory does not have a parent. */
+	if (!xfs_has_metadir(mp) ||
+	    xfs_imeta_path_compare(path, &XFS_IMETA_METADIR))
+		return 0;
+
+	ASSERT(path->im_depth > 0);
+
+	/*
+	 * Find the parent of the last path component.  If the parent path does
+	 * not exist, we consider this corruption because paths are supposed
+	 * to exist.
+	 */
+	error = xfs_imeta_dir_parent(mp, path, &upd->dp);
+	if (error == -ENOENT)
+		return -EFSCORRUPTED;
+	if (error)
+		return error;
+
+	xfs_ilock(upd->dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
+	upd->lock_mode = XFS_IOLOCK_EXCL;
 	return 0;
 }
 
@@ -441,6 +1073,9 @@ int
 xfs_imeta_mount(
 	struct xfs_mount	*mp)
 {
+	if (xfs_has_metadir(mp))
+		return xfs_imeta_dir_mount(mp);
+
 	return 0;
 }
 
@@ -449,6 +1084,9 @@ unsigned int
 xfs_imeta_create_space_res(
 	struct xfs_mount	*mp)
 {
+	if (xfs_has_metadir(mp))
+		return max(XFS_MKDIR_SPACE_RES(mp, NAME_MAX),
+			   XFS_CREATE_SPACE_RES(mp, NAME_MAX));
 	return XFS_IALLOC_SPACE_RES(mp);
 }
 
@@ -459,3 +1097,54 @@ xfs_imeta_unlink_space_res(
 {
 	return XFS_REMOVE_SPACE_RES(mp);
 }
+
+/* Clear the metadata iflag if we're unlinking this inode. */
+void
+xfs_imeta_droplink(
+	struct xfs_inode	*ip)
+{
+	if (VFS_I(ip)->i_nlink == 0 &&
+	    xfs_has_metadir(ip->i_mount) &&
+	    xfs_is_metadata_inode(ip))
+		ip->i_diflags2 &= ~XFS_DIFLAG2_METADATA;
+}
+
+/*
+ * Given a metadata directory update, look up the inode number of the last
+ * component in the path.
+ */
+int
+xfs_imeta_lookup_update(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_imeta_update		*upd,
+	xfs_ino_t			*inop)
+{
+	struct xfs_name			xname;
+	xfs_ino_t			ino;
+	int				error;
+
+	ASSERT(xfs_isilocked(upd->dp, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
+
+	/* metadir ino is recorded in superblock */
+	if (!xfs_has_metadir(mp) ||
+	    xfs_imeta_path_compare(path, &XFS_IMETA_METADIR))
+		return xfs_imeta_sb_lookup(mp, path, inop);
+
+	ASSERT(path->im_depth > 0);
+
+	/* Check that the name does not already exist in the directory. */
+	set_xname(&xname, path, path->im_depth - 1, XFS_DIR3_FT_UNKNOWN);
+	error = xfs_imeta_dir_lookup_component(upd->dp, &xname, &ino);
+	switch (error) {
+	case 0:
+		*inop = ino;
+		break;
+	case -ENOENT:
+		*inop = NULLFSINO;
+		error = 0;
+		break;
+	}
+
+	return error;
+}
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index 631a88120a7..9b139f6809f 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
@@ -13,6 +13,7 @@
 #define XFS_IMETA_DEFINE_PATH(name, path) \
 const struct xfs_imeta_path name = { \
 	.im_path = (path), \
+	.im_ftype = XFS_DIR3_FT_REG_FILE, \
 	.im_depth = ARRAY_SIZE(path), \
 }
 
@@ -23,11 +24,18 @@ struct xfs_imeta_path {
 
 	/* Number of strings in path. */
 	unsigned int	im_depth;
+
+	/* Expected file type. */
+	unsigned int	im_ftype;
 };
 
 /* Cleanup widget for metadata inode creation and deletion. */
 struct xfs_imeta_update {
-	/* empty for now */
+	/* Parent directory */
+	struct xfs_inode	*dp;
+
+	/* Parent directory lock mode */
+	unsigned int		lock_mode;
 };
 
 /* Lookup keys for static metadata inodes. */
@@ -36,9 +44,15 @@ extern const struct xfs_imeta_path XFS_IMETA_RTSUMMARY;
 extern const struct xfs_imeta_path XFS_IMETA_USRQUOTA;
 extern const struct xfs_imeta_path XFS_IMETA_GRPQUOTA;
 extern const struct xfs_imeta_path XFS_IMETA_PRJQUOTA;
+extern const struct xfs_imeta_path XFS_IMETA_METADIR;
 
 int xfs_imeta_lookup(struct xfs_mount *mp, const struct xfs_imeta_path *path,
 		     xfs_ino_t *ino);
+int xfs_imeta_lookup_update(struct xfs_mount *mp,
+			    const struct xfs_imeta_path *path,
+			    struct xfs_imeta_update *upd, xfs_ino_t *inop);
+
+void xfs_imeta_set_metaflag(struct xfs_trans *tp, struct xfs_inode *ip);
 
 /* Don't allocate quota for this file. */
 #define XFS_IMETA_CREATE_NOQUOTA	(1 << 0)
@@ -57,6 +71,7 @@ int xfs_imeta_start_update(struct xfs_mount *mp,
 
 bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
 int xfs_imeta_mount(struct xfs_mount *mp);
+void xfs_imeta_droplink(struct xfs_inode *ip);
 
 unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index cc203321dad..9f92af3274b 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -19,6 +19,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
+#include "xfs_imeta.h"
 #include "iunlink.h"
 
 uint16_t
@@ -624,6 +625,7 @@ xfs_droplink(
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	drop_nlink(VFS_I(ip));
+	xfs_imeta_droplink(ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (VFS_I(ip)->i_nlink)
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 67008bb4b72..2835d7754a8 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -920,7 +920,10 @@ xfs_calc_imeta_create_resv(
 	unsigned int		ret;
 
 	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-	ret += resp->tr_create.tr_logres;
+	if (xfs_has_metadir(mp))
+		ret += max(resp->tr_create.tr_logres, resp->tr_mkdir.tr_logres);
+	else
+		ret += resp->tr_create.tr_logres;
 	return ret;
 }
 
@@ -930,6 +933,9 @@ xfs_calc_imeta_create_count(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
+	if (xfs_has_metadir(mp))
+		return max(resp->tr_create.tr_logcount,
+			   resp->tr_mkdir.tr_logcount);
 	return resp->tr_create.tr_logcount;
 }
 

