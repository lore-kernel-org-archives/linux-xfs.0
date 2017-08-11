Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18241 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751932AbdHKHLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:11:49 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7Bmi7019258
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7Bmpt024312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:48 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7B7BmTF020941
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:48 GMT
Subject: [PATCH 15/16] xfs: cross-reference the block mappings when possible
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:11:47 -0700
Message-ID: <150243550695.29473.2019252707151205272.stgit@magnolia>
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

Use an inode's block mappings to cross-reference inode block counters
and (if possible) cross reference rmapbt records against the bmbt to
ensure that the bmbt isn't missing any records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/inode.c |   63 +++++++++++++++++++
 fs/xfs/scrub/rmap.c  |  162 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 224 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 9a689cc..67c9366 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -38,6 +38,8 @@
 #include "xfs_trans_priv.h"
 #include "xfs_reflink.h"
 #include "xfs_rmap.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -122,6 +124,62 @@ xfs_scrub_inode_xref_rmap(
 	return error;
 }
 
+/* Cross reference the inode fields with the forks. */
+STATIC void
+xfs_scrub_inode_xref_bmap(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip,
+	uint16_t			mode,
+	uint16_t			flags)
+{
+	struct xfs_bmbt_irec		got;
+	struct xfs_ifork		*ifp;
+	struct xfs_mount		*mp = sc->mp;
+	xfs_fileoff_t			lblk;
+	xfs_extnum_t			idx;
+	xfs_extnum_t			nextents;
+	xfs_filblks_t			count;
+	xfs_filblks_t			acount;
+	bool				found;
+	int				error;
+
+	/* Walk all the extents to check nextents/naextents/nblocks. */
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (!xfs_scrub_should_xref(sc, &error, NULL))
+		return;
+	xfs_scrub_ino_xref_check_ok(sc, sc->ip->i_ino, NULL,
+			nextents >= be32_to_cpu(dip->di_nextents));
+
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &acount);
+	if (!xfs_scrub_should_xref(sc, &error, NULL))
+		return;
+	xfs_scrub_ino_xref_check_ok(sc, sc->ip->i_ino, NULL,
+			nextents == be16_to_cpu(dip->di_anextents));
+
+	/* Check nblocks against the inode. */
+	xfs_scrub_ino_xref_check_ok(sc, sc->ip->i_ino, NULL,
+			count + acount == be64_to_cpu(dip->di_nblocks));
+
+	/* Make sure we don't have any written extents after EOF. */
+	if (S_ISREG(mode) && !(flags & XFS_DIFLAG_PREALLOC) &&
+	    (dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+	     dip->di_format == XFS_DINODE_FMT_BTREE)) {
+		lblk = XFS_B_TO_FSB(mp, i_size_read(VFS_I(sc->ip)));
+		ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+		found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+		while (found) {
+			xfs_scrub_fblock_xref_check_ok(sc, XFS_DATA_FORK,
+					got.br_startoff,
+					got.br_startoff < lblk ||
+					got.br_state != XFS_EXT_NORM);
+			lblk = got.br_startoff + got.br_blockcount;
+			found = xfs_iext_get_extent(ifp, ++idx, &got);
+		}
+	}
+}
+
 /* Scrub an inode. */
 int
 xfs_scrub_inode(
@@ -136,7 +194,7 @@ xfs_scrub_inode(
 	size_t				fork_recs;
 	unsigned long long		isize;
 	uint64_t			flags2;
-	uint32_t			nextents;
+	xfs_extnum_t			nextents;
 	uint32_t			extsize;
 	uint32_t			cowextsize;
 	uint16_t			flags;
@@ -371,6 +429,9 @@ xfs_scrub_inode(
 			goto out;
 	}
 
+	/* Cross reference the inode fields with the forks. */
+	xfs_scrub_inode_xref_bmap(sc, dip, mode, flags);
+
 out:
 	if (bp)
 		xfs_trans_brelse(sc->tp, bp);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index c11401b..e3129ed 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -29,9 +29,12 @@
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
@@ -112,6 +115,161 @@ xfs_scrub_rmapbt_xref_refc(
 			crec.rc_refcount == 1);
 }
 
+struct xfs_scrub_rmapbt_xref_bmbt {
+	xfs_fsblock_t		fsb;
+	xfs_extlen_t		len;
+};
+
+/* Is this the bmbt block we're looking for? */
+STATIC int
+xfs_scrub_rmapbt_xref_bmap_find_bmbt_block(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*data)
+{
+	struct xfs_buf		*bp;
+	struct xfs_scrub_rmapbt_xref_bmbt	*x = data;
+	xfs_fsblock_t		fsb;
+
+	xfs_btree_get_block(cur, level, &bp);
+	if (!bp)
+		return 0;
+
+	fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+	if (fsb >= x->fsb && fsb < x->fsb + x->len)
+		return XFS_BTREE_QUERY_RANGE_ABORT;
+	return 0;
+}
+
+/* Try to find a matching bmap extent for this inode data/attr fork rmap. */
+STATIC void
+xfs_scrub_rmapbt_xref_bmap(
+	struct xfs_scrub_btree	*bs,
+	struct xfs_rmap_irec	*irec,
+	bool			is_attr,
+	bool			is_bmbt,
+	bool			is_unwritten)
+{
+	struct xfs_scrub_rmapbt_xref_bmbt	x;
+	struct xfs_bmbt_irec	got;
+	struct xfs_inode	*ip;
+	struct xfs_ifork	*ifp;
+	struct xfs_btree_cur	*cur;
+	xfs_fileoff_t		off;
+	xfs_fileoff_t		endoff;
+	xfs_fsblock_t		fsb;
+	xfs_extnum_t		idx;
+	xfs_agnumber_t		agno;
+	uint			lockflags;
+	bool			found;
+	int			whichfork;
+	int			error;
+	uint8_t			fmt;
+
+	fsb = XFS_AGB_TO_FSB(bs->sc->mp, bs->sc->sa.agno, irec->rm_startblock);
+
+	/*
+	 * We can't access the AGI of a lower AG due to locking rules,
+	 * so skip this check if inodes aren't aligned and the inode is
+	 * in a lower AG.
+	 */
+	agno = XFS_INO_TO_AGNO(bs->sc->mp, irec->rm_owner);
+	if (!xfs_scrub_check_thoroughness(bs->sc,
+			bs->sc->mp->m_inoalign_mask != 0 ||
+			agno >= bs->sc->sa.agno))
+		return;
+
+	/* Grab the inode. */
+	error = xfs_iget(bs->sc->mp, bs->sc->tp, irec->rm_owner, 0, 0, &ip);
+	if (!xfs_scrub_should_xref(bs->sc, &error, NULL))
+		return;
+
+	whichfork = is_attr ? XFS_ATTR_FORK : XFS_DATA_FORK;
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	lockflags = XFS_IOLOCK_SHARED | XFS_MMAPLOCK_SHARED | XFS_ILOCK_SHARED;
+
+lock_again:
+	/*
+	 * Try to grab the inode lock.  We cannot block here because the
+	 * usual XFS locking order is inode -> AGF, whereas here we have
+	 * the AGF but want an inode.  Blocking here could result in
+	 * deadlock, so we'll take an incomplete check over that.
+	 */
+	if (!xfs_ilock_nowait(ip, lockflags))
+		goto out_rele;
+
+	/* Inode had better have extent maps. */
+	fmt = XFS_IFORK_FORMAT(ip, whichfork);
+	if (!xfs_scrub_btree_xref_check_ok(bs->sc, bs->cur, 0,
+			ifp != NULL &&
+			(fmt == XFS_DINODE_FMT_BTREE ||
+			 fmt == XFS_DINODE_FMT_EXTENTS)))
+		goto out_unlock;
+
+	/* If we haven't loaded the extent list, try to relock with excl. */
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		if (!(lockflags & XFS_ILOCK_EXCL)) {
+			xfs_iunlock(ip, lockflags);
+			lockflags |= XFS_ILOCK_EXCL;
+			lockflags &= ~XFS_ILOCK_SHARED;
+			goto lock_again;
+		}
+		error = xfs_iread_extents(bs->sc->tp, ip, whichfork);
+		if (error)
+			goto out_unlock;
+	}
+
+	/* If this is a bmbt record, see if we can find it. */
+	if (is_bmbt) {
+		x.fsb = fsb;
+		x.len = irec->rm_blockcount;
+		cur = xfs_bmbt_init_cursor(bs->sc->mp, bs->sc->tp, ip,
+				whichfork);
+		error = xfs_btree_visit_blocks(cur,
+				xfs_scrub_rmapbt_xref_bmap_find_bmbt_block,
+				&x);
+		xfs_scrub_btree_xref_check_ok(bs->sc, cur, 0,
+				error == XFS_BTREE_QUERY_RANGE_ABORT);
+		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+				XFS_BTREE_NOERROR);
+		goto out_unlock;
+	}
+
+	/* Now go make sure we find a bmap extent to cover this rmap. */
+	off = irec->rm_offset;
+	endoff = irec->rm_offset + irec->rm_blockcount - 1;
+	found = xfs_iext_lookup_extent(ip, ifp, off, &idx, &got);
+	xfs_scrub_btree_xref_check_ok(bs->sc, bs->cur, 0, found);
+	while (found) {
+		if (!xfs_scrub_btree_xref_check_ok(bs->sc, bs->cur, 0,
+				got.br_startoff <= off &&
+				got.br_startoff <= endoff))
+			goto out_unlock;
+		xfs_scrub_btree_xref_check_ok(bs->sc, bs->cur, 0,
+				(got.br_state == XFS_EXT_NORM ||
+				 is_unwritten) &&
+				(got.br_state == XFS_EXT_UNWRITTEN ||
+				 !is_unwritten) &&
+				got.br_startblock + (off - got.br_startoff) ==
+				fsb);
+
+		off = got.br_startoff + got.br_blockcount;
+		fsb = got.br_startblock + got.br_blockcount;
+		if (off >= endoff)
+			break;
+		found = xfs_iext_get_extent(ifp, ++idx, &got);
+		xfs_scrub_btree_xref_check_ok(bs->sc, bs->cur, 0,
+				found &&
+				got.br_startoff == off &&
+				got.br_startblock == fsb);
+	}
+
+out_unlock:
+	xfs_iunlock(ip, lockflags);
+out_rele:
+	iput(VFS_I(ip));
+}
+
 /* Scrub an rmapbt record. */
 STATIC int
 xfs_scrub_rmapbt_helper(
@@ -223,6 +381,10 @@ xfs_scrub_rmapbt_helper(
 		xfs_scrub_rmapbt_xref_refc(bs, &irec, non_inode, is_attr,
 				is_bmbt, is_unwritten);
 
+	/* Cross-reference with an inode's bmbt if possible. */
+	if (!non_inode)
+		xfs_scrub_rmapbt_xref_bmap(bs, &irec, is_attr, is_bmbt,
+				is_unwritten);
 out:
 	return error;
 }

