Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20454 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759368AbcLCBky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:40:54 -0500
Subject: [PATCH 51/55] xfs: online repair of inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:40:51 -0800
Message-ID: <148072925094.12995.4297607183192140405.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Wire up the only online inode repair that we know how to do --
clearing the reflink flag when it's no longer needed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/repair/common.c |    2 -
 fs/xfs/repair/common.h |    1 
 fs/xfs/repair/inode.c  |  151 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.c |    4 +
 fs/xfs/xfs_reflink.c   |   15 +++--
 fs/xfs/xfs_reflink.h   |    6 +-
 6 files changed, 166 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index 401f8ec..f6e6325 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -1092,7 +1092,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, xfs_repair_iallocbt, xfs_sb_version_hasfinobt},
 	{xfs_scrub_setup_ag_header_freeze, xfs_scrub_rmapbt, xfs_repair_rmapbt, xfs_sb_version_hasrmapbt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, xfs_repair_refcountbt, xfs_sb_version_hasreflink},
-	{xfs_scrub_setup_inode_raw, xfs_scrub_inode, NULL, NULL},
+	{xfs_scrub_setup_inode_raw, xfs_scrub_inode, xfs_repair_inode, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_data, NULL, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_attr, NULL, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_cow, NULL, NULL},
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 65c533b..7865c19 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -291,5 +291,6 @@ int xfs_repair_allocbt(struct xfs_scrub_context *sc);
 int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
 int xfs_repair_rmapbt(struct xfs_scrub_context *sc);
 int xfs_repair_refcountbt(struct xfs_scrub_context *sc);
+int xfs_repair_inode(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/repair/inode.c b/fs/xfs/repair/inode.c
index 8b50736..54726db 100644
--- a/fs/xfs/repair/inode.c
+++ b/fs/xfs/repair/inode.c
@@ -39,6 +39,7 @@
 #include "xfs_rmap.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_reflink.h"
 #include "repair/common.h"
 
 /* Inode core */
@@ -324,3 +325,153 @@ xfs_scrub_inode(
 #undef XFS_SCRUB_INODE_OP_ERROR_GOTO
 #undef XFS_SCRUB_INODE_GOTO
 #undef XFS_SCRUB_INODE_CHECK
+
+/* Repair an inode's fields. */
+int
+xfs_repair_inode(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_imap			imap;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_buf			*bp;
+	struct xfs_dinode		*dip;
+	struct xfs_inode		*ip;
+	xfs_ino_t			ino;
+	unsigned long long		count;
+	uint64_t			flags2;
+	uint32_t			nextents;
+	uint16_t			flags;
+	int				error = 0;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	/* Are we fixing this thing manually? */
+	if (!sc->ip) {
+		/* Map & read inode. */
+		ino = sc->sm->sm_ino;
+		error = xfs_imap(mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
+		if (error)
+			goto out;
+
+		error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+				imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp,
+				NULL);
+		if (error)
+			goto out;
+
+		/* Fix everything the verifier will complain about. */
+		bp->b_ops = &xfs_inode_buf_ops;
+		dip = xfs_buf_offset(bp, imap.im_boffset);
+		dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+		if (!xfs_dinode_good_version(mp, dip->di_version))
+			dip->di_version = 3;
+		dip->di_ino = cpu_to_be64(ino);
+		uuid_copy(&dip->di_uuid, &mp->m_sb.sb_meta_uuid);
+		flags = be16_to_cpu(dip->di_flags);
+		flags2 = be64_to_cpu(dip->di_flags2);
+		if (xfs_sb_version_hasreflink(&mp->m_sb))
+			flags2 |= XFS_DIFLAG2_REFLINK;
+		else
+			flags2 &= ~(XFS_DIFLAG2_REFLINK |
+				    XFS_DIFLAG2_COWEXTSIZE);
+		if (flags & XFS_DIFLAG_REALTIME)
+			flags2 &= ~XFS_DIFLAG2_REFLINK;
+		if (flags2 & XFS_DIFLAG2_REFLINK)
+			flags2 &= ~XFS_DIFLAG2_DAX;
+		dip->di_flags = cpu_to_be16(flags);
+		dip->di_flags2 = cpu_to_be64(flags2);
+		dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
+		if (be64_to_cpu(dip->di_size) & (1ULL << 63))
+			dip->di_size = cpu_to_be64((1ULL << 63) - 1);
+
+		/* Write out the inode... */
+		xfs_dinode_calc_crc(mp, dip);
+		xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_DINO_BUF);
+		xfs_trans_log_buf(sc->tp, bp, imap.im_boffset,
+				imap.im_boffset + mp->m_sb.sb_inodesize - 1);
+		error = xfs_trans_roll(&sc->tp, NULL);
+		if (error)
+			goto out;
+
+		/* ...and reload it? */
+		error = xfs_iget(mp, sc->tp, ino,
+				XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE,
+				0, &sc->ip);
+		if (error)
+			goto out;
+		xfs_ilock(sc->ip, XFS_MMAPLOCK_EXCL);
+		xfs_ilock(sc->ip, XFS_IOLOCK_EXCL);
+		xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+	}
+
+	ip = sc->ip;
+	xfs_trans_ijoin(sc->tp, ip, 0);
+
+	/* di_size */
+	if (!S_ISDIR(VFS_I(ip)->i_mode) && !S_ISREG(VFS_I(ip)->i_mode) &&
+	    !S_ISLNK(VFS_I(ip)->i_mode)) {
+		i_size_write(VFS_I(ip), 0);
+		ip->i_d.di_size = 0;
+	}
+
+	/* di_flags */
+	flags = ip->i_d.di_flags;
+	if ((flags & XFS_DIFLAG_IMMUTABLE) && (flags & XFS_DIFLAG_APPEND))
+		flags &= ~XFS_DIFLAG_APPEND;
+
+	if ((flags & XFS_DIFLAG_FILESTREAM) && (flags & XFS_DIFLAG_REALTIME))
+		flags &= ~XFS_DIFLAG_FILESTREAM;
+	ip->i_d.di_flags = flags;
+
+	/* di_nblocks/di_nextents/di_anextents */
+	count = 0;
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (error)
+		goto out;
+	ip->i_d.di_nextents = nextents;
+
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &count);
+	if (error)
+		goto out;
+	ip->i_d.di_anextents = nextents;
+	ip->i_d.di_nblocks = count;
+	if (ip->i_d.di_anextents != 0 && ip->i_d.di_forkoff == 0)
+		ip->i_d.di_anextents = 0;
+
+	/* Do we have prealloc blocks? */
+	if (S_ISREG(VFS_I(ip)->i_mode) && !(flags & XFS_DIFLAG_PREALLOC) &&
+	    (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS ||
+	     ip->i_d.di_format == XFS_DINODE_FMT_BTREE)) {
+		struct xfs_bmbt_irec		got;
+		struct xfs_ifork		*ifp;
+		xfs_fileoff_t			lblk;
+		xfs_extnum_t			lastx;
+
+		ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+		lblk = XFS_B_TO_FSB(mp, i_size_read(VFS_I(sc->ip)));
+		while (xfs_iext_lookup_extent(sc->ip, ifp, lblk, &lastx,
+				&got)) {
+			if (got.br_startoff >= lblk &&
+			    got.br_state == XFS_EXT_NORM) {
+				ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+				break;
+			}
+			lblk = got.br_startoff + got.br_blockcount;
+		}
+	}
+
+	/* Commit inode core changes. */
+	xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_roll(&sc->tp, ip);
+	if (error)
+		goto out;
+
+	if (xfs_is_reflink_inode(sc->ip))
+		return xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+
+out:
+	return error;
+}
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d983f28..cfba408 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -481,8 +481,8 @@ xfs_getbmap_adjust_shared(
 
 	agno = XFS_FSB_TO_AGNO(mp, map->br_startblock);
 	agbno = XFS_FSB_TO_AGBNO(mp, map->br_startblock);
-	error = xfs_reflink_find_shared(mp, agno, agbno, map->br_blockcount,
-			&ebno, &elen, true);
+	error = xfs_reflink_find_shared(mp, NULL, agno, agbno,
+			map->br_blockcount, &ebno, &elen, true);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 88fd03c..69a7b70 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -128,6 +128,7 @@
 int
 xfs_reflink_find_shared(
 	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen,
@@ -139,18 +140,18 @@ xfs_reflink_find_shared(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
-	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (error)
 		return error;
 
-	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
 
 	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
 			find_end_of_shared);
 
 	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 
-	xfs_buf_relse(agbp);
+	xfs_trans_brelse(tp, agbp);
 	return error;
 }
 
@@ -194,7 +195,7 @@ xfs_reflink_trim_around_shared(
 	agbno = XFS_FSB_TO_AGBNO(ip->i_mount, irec->br_startblock);
 	aglen = irec->br_blockcount;
 
-	error = xfs_reflink_find_shared(ip->i_mount, agno, agbno,
+	error = xfs_reflink_find_shared(ip->i_mount, NULL, agno, agbno,
 			aglen, &fbno, &flen, true);
 	if (error)
 		return error;
@@ -1457,8 +1458,8 @@ xfs_reflink_dirty_extents(
 			agbno = XFS_FSB_TO_AGBNO(mp, map[1].br_startblock);
 			aglen = map[1].br_blockcount;
 
-			error = xfs_reflink_find_shared(mp, agno, agbno, aglen,
-					&rbno, &rlen, true);
+			error = xfs_reflink_find_shared(mp, NULL, agno, agbno,
+					aglen, &rbno, &rlen, true);
 			if (error)
 				goto out;
 			if (rbno == NULLAGBLOCK)
@@ -1531,7 +1532,7 @@ xfs_reflink_clear_inode_flag(
 		agbno = XFS_FSB_TO_AGBNO(mp, map.br_startblock);
 		aglen = map.br_blockcount;
 
-		error = xfs_reflink_find_shared(mp, agno, agbno, aglen,
+		error = xfs_reflink_find_shared(mp, *tpp, agno, agbno, aglen,
 				&rbno, &rlen, false);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index aa6a4d6..2a18e4d 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -20,9 +20,9 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
-extern int xfs_reflink_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
-		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
-		xfs_extlen_t *flen, bool find_maximal);
+extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_agnumber_t agno, xfs_agblock_t agbno, xfs_extlen_t aglen,
+		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
 

