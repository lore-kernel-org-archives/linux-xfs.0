Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 271B77F66
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:42:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE9568F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:03 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zCxlrkJWiximpiQB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:01 -0700 (PDT)
Subject: [PATCH 16/25] xfs: scrub inode block mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:41:56 -0700
Message-ID: <147216851666.3108.9311932165996955396.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Scrub an individual inode's block mappings to make sure they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |    2 
 fs/xfs/libxfs/xfs_bmap.h       |    6 +
 fs/xfs/libxfs/xfs_bmap_btree.c |   26 +++-
 fs/xfs/libxfs/xfs_fs.h         |    5 +
 fs/xfs/xfs_scrub.c             |  296 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 329 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9ae4a3a..7a91618 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1425,7 +1425,7 @@ xfs_bmap_search_multi_extents(
  * Else, *lastxp will be set to the index of the found
  * entry; *gotp will contain the entry.
  */
-STATIC xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
+xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
 xfs_bmap_search_extents(
 	xfs_inode_t     *ip,            /* incore inode pointer */
 	xfs_fileoff_t   bno,            /* block number searched for */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 134ea00..4afa21c 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -259,4 +259,10 @@ int	xfs_bmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
 
+struct xfs_bmbt_rec_host *
+	xfs_bmap_search_extents(struct xfs_inode *ip, xfs_fileoff_t bno,
+				int fork, int *eofp, xfs_extnum_t *lastxp,
+				struct xfs_bmbt_irec *gotp,
+				struct xfs_bmbt_irec *prevp);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 8007d2b..1fc3eed 100644
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
index 30903d1..c688deb 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -546,7 +546,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_RMAPBT	8	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	9	/* reference count btree */
 #define XFS_SCRUB_TYPE_INODE	10	/* inode record */
-#define XFS_SCRUB_TYPE_MAX	10
+#define XFS_SCRUB_TYPE_BMBTD	11	/* data fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTA	12	/* attr fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTC	13	/* CoW fork block mapping */
+#define XFS_SCRUB_TYPE_MAX	13
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 383a00e..573acd4 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1381,6 +1381,299 @@ out:
 	return error;
 }
 
+/*
+ * Inode fork block mapping (BMBT) scrubber.
+ * More complex than the others because we have to scrub
+ * all the extents regardless of whether or not the fork
+ * is in btree format.
+ */
+
+struct xfs_scrub_bmap_info {
+	struct xfs_scrub_btree	bs;
+	struct xfs_inode	*ip;
+	const char		*type;
+	xfs_daddr_t		eofs;
+	xfs_fileoff_t		lastoff;
+	bool			is_rt;
+	bool			is_shared;
+	bool			scrub_btrec;
+	int			whichfork;
+};
+
+/* Scrub a single extent record. */
+STATIC int
+xfs_scrub_bmap_extent(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_bmbt_irec		*irec)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_buf			*bp = NULL;
+	struct xfs_buf			*agi_bp = NULL;
+	struct xfs_buf			*agf_bp = NULL;
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			dlen;
+	xfs_agnumber_t			agno;
+	xfs_fsblock_t			bno;
+	int				error = 0;
+	int				err2 = 0;
+
+	if (info->bs.cur)
+		xfs_btree_get_block(info->bs.cur, 0, &bp);
+
+	XFS_INO_SCRUB_CHECK(ip, bp, info->type,
+			irec->br_startoff >= info->lastoff);
+	XFS_INO_SCRUB_CHECK(ip, bp, info->type,
+			irec->br_startblock != HOLESTARTBLOCK);
+
+	if (irec->br_startblock == DELAYSTARTBLOCK) {
+		XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+				irec->br_state == XFS_EXT_NORM);
+		goto out;
+	}
+
+	/* Actual mapping, so check the block ranges. */
+	if (info->is_rt) {
+		daddr = XFS_FSB_TO_BB(mp, irec->br_startblock);
+		agno = NULLAGNUMBER;
+		bno = irec->br_startblock;
+	} else {
+		daddr = XFS_FSB_TO_DADDR(mp, irec->br_startblock);
+		agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
+		bno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
+	}
+	dlen = XFS_FSB_TO_BB(mp, irec->br_blockcount);
+	XFS_INO_SCRUB_CHECK(ip, bp, info->type, daddr < info->eofs);
+	XFS_INO_SCRUB_CHECK(ip, bp, info->type,
+			daddr + dlen < info->eofs);
+	XFS_INO_SCRUB_CHECK(ip, bp, info->type,
+			irec->br_state != XFS_EXT_UNWRITTEN ||
+			xfs_sb_version_hasextflgbit(&mp->m_sb));
+
+	/* Set ourselves up for cross-referencing later. */
+	if (!info->is_rt) {
+		err2 = xfs_scrub_get_ag_headers(mp, agno, &agi_bp, &agf_bp);
+		if (err2)
+			goto out;
+	}
+
+out:
+	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
+	info->lastoff = irec->br_startoff + irec->br_blockcount;
+	if (!error && err2)
+		error = err2;
+	return error;
+}
+
+/* Scrub a bmbt record. */
+STATIC int
+xfs_scrub_bmapbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_bmbt_rec_host	ihost;
+	struct xfs_bmbt_irec		irec;
+	struct xfs_scrub_bmap_info	*info;
+	int				error;
+
+	info = container_of(bs, struct xfs_scrub_bmap_info, bs);
+	if (!info->scrub_btrec)
+		return 0;
+
+	/* Set up the in-core record and scrub it. */
+	ihost.l0 = be64_to_cpu(rec->bmbt.l0);
+	ihost.l1 = be64_to_cpu(rec->bmbt.l1);
+	xfs_bmbt_get_all(&ihost, &irec);
+	error = xfs_scrub_bmap_extent(info->ip, info, &irec);
+
+	/* Record the error, but keep going. */
+	if (bs->error == 0 && error != 0)
+		bs->error = error;
+	return 0;
+}
+
+/* Scrub an inode fork's block mappings. */
+STATIC int
+xfs_scrub_bmap(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	int				whichfork)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp;
+	struct xfs_bmbt_irec		irec;
+	struct xfs_bmbt_irec		imap;
+	struct xfs_scrub_bmap_info	info;
+	xfs_fileoff_t			off;
+	xfs_fileoff_t			endoff;
+	xfs_extnum_t			extnum;
+	int				eof;
+	int				nmaps;
+	int				flags = 0;
+	int				error = 0;
+	int				err2 = 0;
+
+	if (sm->control || sm->flags)
+		return -EINVAL;
+
+	memset(&info, 0, sizeof(info));
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
+	default:
+		info.type = NULL;
+		ASSERT(0);
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+
+	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
+	info.eofs = XFS_FSB_TO_BB(mp, info.is_rt ? mp->m_sb.sb_rblocks :
+					      mp->m_sb.sb_dblocks);
+	info.ip = ip;
+	info.whichfork = whichfork;
+	info.is_shared = whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(ip);
+
+	switch (whichfork) {
+	case XFS_COW_FORK:
+		/* Non-existent CoW forks are ignorable. */
+		if (!ifp)
+			goto out_unlock;
+		/* No CoW forks on non-reflink inodes/filesystems. */
+		XFS_INO_SCRUB_GOTO(ip, NULL, info.type,
+				xfs_is_reflink_inode(ip), out_unlock);
+		break;
+	case XFS_ATTR_FORK:
+		if (!ifp)
+			goto out_unlock;
+		XFS_INO_SCRUB_CHECK(ip, NULL, info.type,
+				xfs_sb_version_hasattr(&mp->m_sb));
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
+		XFS_INO_SCRUB_GOTO(ip, NULL, info.type,
+				ifp->if_flags & XFS_IFEXTENTS, out_unlock);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		XFS_INO_SCRUB_CHECK(ip, NULL, info.type,
+				whichfork != XFS_COW_FORK);
+		/*
+		 * Scan the btree.  If extents aren't loaded, have the btree
+		 * scrub routine examine the extent records.
+		 */
+		info.scrub_btrec = !(ifp->if_flags & XFS_IFEXTENTS);
+
+		info.bs.cur = xfs_bmbt_init_cursor(mp, NULL, ip, whichfork);
+		info.bs.scrub_rec = xfs_scrub_bmapbt_helper;
+		xfs_rmap_ino_bmbt_owner(&info.bs.oinfo, ip->i_ino, whichfork);
+		err2 = xfs_scrub_btree(&info.bs);
+		xfs_btree_del_cursor(info.bs.cur,
+			err2 ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+		info.bs.cur = NULL;
+		if (err2)
+			goto out_unlock;
+		if (error == 0 && info.bs.error != 0)
+			error = info.bs.error;
+		if (info.scrub_btrec)
+			goto out_unlock;
+		break;
+	default:
+		XFS_INO_SCRUB_GOTO(ip, NULL, info.type, false, out_unlock);
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
+	xfs_bmap_search_extents(ip, -1ULL, whichfork, &eof, &extnum,
+			&irec, &imap);
+
+	/* Scrub extent records. */
+	off = 0;
+	endoff = irec.br_startoff + irec.br_blockcount;
+	while (true) {
+		nmaps = 1;
+		err2 = xfs_bmapi_read(ip, off, endoff - off, &irec,
+				&nmaps, flags);
+		if (err2 || nmaps == 0 || irec.br_startoff > endoff)
+			break;
+
+		/* Scrub non-hole extent. */
+		if (irec.br_startblock != HOLESTARTBLOCK) {
+			err2 = xfs_scrub_bmap_extent(ip, &info, &irec);
+			if (!error && err2)
+				error = err2;
+			if (xfs_scrub_should_terminate(&error))
+				break;
+		}
+
+		off += irec.br_blockcount;
+	}
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	if (error == 0 && err2 != 0)
+		error = err2;
+	return error;
+}
+
+/* Scrub an inode's data fork. */
+STATIC int
+xfs_scrub_bmap_data(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	return xfs_scrub_bmap(ip, sm, XFS_DATA_FORK);
+}
+
+/* Scrub an inode's attr fork. */
+STATIC int
+xfs_scrub_bmap_attr(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	return xfs_scrub_bmap(ip, sm, XFS_ATTR_FORK);
+}
+
+/* Scrub an inode's CoW fork. */
+STATIC int
+xfs_scrub_bmap_cow(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	if (!xfs_is_reflink_inode(ip))
+		return -ENOENT;
+
+	return xfs_scrub_bmap(ip, sm, XFS_COW_FORK);
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -1400,6 +1693,9 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_rmapbt,	xfs_sb_version_hasrmapbt},
 	{xfs_scrub_refcountbt,	xfs_sb_version_hasreflink},
 	{xfs_scrub_inode,	NULL},
+	{xfs_scrub_bmap_data,	NULL},
+	{xfs_scrub_bmap_attr,	NULL},
+	{xfs_scrub_bmap_cow,	NULL},
 };
 
 /* Dispatch metadata scrubbing. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
