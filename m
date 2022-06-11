Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A568CCA47B
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348016AbiFKB1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346475AbiFKB1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:12 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C4C23A4817
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 79CBB10E7203
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005AOs-Gi
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELLv-FX
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/50] xfs: convert xfs_imap() to take a perag
Date:   Sat, 11 Jun 2022 11:26:26 +1000
Message-Id: <20220611012659.3418072-18-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=rChGdRRAqzpzq4-x-fMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Callers have referenced perags but they don't pass it into
xfs_imap() so it takes it's own reference. Fix that so we can change
inode allocation over to using active references.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 43 +++++++++++++-------------------------
 fs/xfs/libxfs/xfs_ialloc.h |  3 ++-
 fs/xfs/scrub/common.c      | 13 ++++++++----
 fs/xfs/xfs_icache.c        |  2 +-
 fs/xfs/xfs_inode.c         |  9 ++++----
 5 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 6cdfd64bc56b..5782aa74c688 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2200,15 +2200,15 @@ xfs_difree(
 
 STATIC int
 xfs_imap_lookup(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
 	xfs_agino_t		agino,
 	xfs_agblock_t		agbno,
 	xfs_agblock_t		*chunk_agbno,
 	xfs_agblock_t		*offset_agbno,
 	int			flags)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
@@ -2263,12 +2263,13 @@ xfs_imap_lookup(
  */
 int
 xfs_imap(
-	struct xfs_mount	 *mp,	/* file system mount structure */
+	struct xfs_perag	*pag,
 	struct xfs_trans	 *tp,	/* transaction pointer */
 	xfs_ino_t		ino,	/* inode to locate */
 	struct xfs_imap		*imap,	/* location map structure */
 	uint			flags)	/* flags for inode btree lookup */
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	xfs_agblock_t		agbno;	/* block number of inode in the alloc group */
 	xfs_agino_t		agino;	/* inode number within alloc group */
 	xfs_agblock_t		chunk_agbno;	/* first block in inode chunk */
@@ -2276,17 +2277,15 @@ xfs_imap(
 	int			error;	/* error code */
 	int			offset;	/* index of inode in its buffer */
 	xfs_agblock_t		offset_agbno;	/* blks from chunk start to inode */
-	struct xfs_perag	*pag;
 
 	ASSERT(ino != NULLFSINO);
 
 	/*
 	 * Split up the inode number into its parts.
 	 */
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
 	agino = XFS_INO_TO_AGINO(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (!pag || agbno >= mp->m_sb.sb_agblocks ||
+	if (agbno >= mp->m_sb.sb_agblocks ||
 	    ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
 		error = -EINVAL;
 #ifdef DEBUG
@@ -2295,20 +2294,14 @@ xfs_imap(
 		 * as they can be invalid without implying corruption.
 		 */
 		if (flags & XFS_IGET_UNTRUSTED)
-			goto out_drop;
-		if (!pag) {
-			xfs_alert(mp,
-				"%s: agno (%d) >= mp->m_sb.sb_agcount (%d)",
-				__func__, XFS_INO_TO_AGNO(mp, ino),
-				mp->m_sb.sb_agcount);
-		}
+			return error;
 		if (agbno >= mp->m_sb.sb_agblocks) {
 			xfs_alert(mp,
 		"%s: agbno (0x%llx) >= mp->m_sb.sb_agblocks (0x%lx)",
 				__func__, (unsigned long long)agbno,
 				(unsigned long)mp->m_sb.sb_agblocks);
 		}
-		if (pag && ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
+		if (ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
 			xfs_alert(mp,
 		"%s: ino (0x%llx) != XFS_AGINO_TO_INO() (0x%llx)",
 				__func__, ino,
@@ -2316,7 +2309,7 @@ xfs_imap(
 		}
 		xfs_stack_trace();
 #endif /* DEBUG */
-		goto out_drop;
+		return error;
 	}
 
 	/*
@@ -2327,10 +2320,10 @@ xfs_imap(
 	 * in all cases where an untrusted inode number is passed.
 	 */
 	if (flags & XFS_IGET_UNTRUSTED) {
-		error = xfs_imap_lookup(mp, tp, pag, agino, agbno,
+		error = xfs_imap_lookup(pag, tp, agino, agbno,
 					&chunk_agbno, &offset_agbno, flags);
 		if (error)
-			goto out_drop;
+			return error;
 		goto out_map;
 	}
 
@@ -2346,8 +2339,7 @@ xfs_imap(
 		imap->im_len = XFS_FSB_TO_BB(mp, 1);
 		imap->im_boffset = (unsigned short)(offset <<
 							mp->m_sb.sb_inodelog);
-		error = 0;
-		goto out_drop;
+		return 0;
 	}
 
 	/*
@@ -2359,10 +2351,10 @@ xfs_imap(
 		offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
 		chunk_agbno = agbno - offset_agbno;
 	} else {
-		error = xfs_imap_lookup(mp, tp, pag, agino, agbno,
+		error = xfs_imap_lookup(pag, tp, agino, agbno,
 					&chunk_agbno, &offset_agbno, flags);
 		if (error)
-			goto out_drop;
+			return error;
 	}
 
 out_map:
@@ -2390,14 +2382,9 @@ xfs_imap(
 			__func__, (unsigned long long) imap->im_blkno,
 			(unsigned long long) imap->im_len,
 			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
-		error = -EINVAL;
-		goto out_drop;
+		return -EINVAL;
 	}
-	error = 0;
-out_drop:
-	if (pag)
-		xfs_perag_put(pag);
-	return error;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 9bbbca6ac4ed..4cfce2eebe7e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -12,6 +12,7 @@ struct xfs_imap;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_btree_cur;
+struct xfs_perag;
 
 /* Move inodes in clusters of this size */
 #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
@@ -47,7 +48,7 @@ int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
  */
 int
 xfs_imap(
-	struct xfs_mount *mp,		/* file system mount structure */
+	struct xfs_perag *pag,
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	ino,		/* inode to locate */
 	struct xfs_imap	*imap,		/* location map structure */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9bbbf20f401b..70aebc12734a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -644,6 +644,7 @@ xchk_get_inode(
 {
 	struct xfs_imap		imap;
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag;
 	struct xfs_inode	*ip_in = XFS_I(file_inode(sc->file));
 	struct xfs_inode	*ip = NULL;
 	int			error;
@@ -679,10 +680,14 @@ xchk_get_inode(
 		 * Otherwise, we really couldn't find it so tell userspace
 		 * that it no longer exists.
 		 */
-		error = xfs_imap(sc->mp, sc->tp, sc->sm->sm_ino, &imap,
-				XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE);
-		if (error)
-			return -ENOENT;
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, sc->sm->sm_ino));
+		if (pag) {
+			error = xfs_imap(pag, sc->tp, sc->sm->sm_ino, &imap,
+					XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE);
+			xfs_perag_put(pag);
+			if (error)
+				return -ENOENT;
+		}
 		error = -EFSCORRUPTED;
 		fallthrough;
 	default:
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1ca6cfeccbb8..d5e594fa56c3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -579,7 +579,7 @@ xfs_iget_cache_miss(
 	if (!ip)
 		return -ENOMEM;
 
-	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, flags);
+	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, flags);
 	if (error)
 		goto out_destroy;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0a2424ef38a3..0ec0075f529f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2207,8 +2207,8 @@ xfs_iunlink(
 /* Return the imap, dinode pointer, and buffer for an inode. */
 STATIC int
 xfs_iunlink_map_ino(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
 	xfs_agino_t		agino,
 	struct xfs_imap		*imap,
 	struct xfs_dinode	**dipp,
@@ -2218,7 +2218,8 @@ xfs_iunlink_map_ino(
 	int			error;
 
 	imap->im_blkno = 0;
-	error = xfs_imap(mp, tp, XFS_AGINO_TO_INO(mp, agno, agino), imap, 0);
+	error = xfs_imap(pag, tp, XFS_AGINO_TO_INO(mp, pag->pag_agno, agino),
+			imap, 0);
 	if (error) {
 		xfs_warn(mp, "%s: xfs_imap returned error %d.",
 				__func__, error);
@@ -2267,7 +2268,7 @@ xfs_iunlink_map_prev(
 	/* See if our backref cache can find it faster. */
 	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
 	if (*agino != NULLAGINO) {
-		error = xfs_iunlink_map_ino(tp, pag->pag_agno, *agino, imap,
+		error = xfs_iunlink_map_ino(pag, tp, *agino, imap,
 				dipp, bpp);
 		if (error)
 			return error;
@@ -2295,7 +2296,7 @@ xfs_iunlink_map_prev(
 			xfs_trans_brelse(tp, *bpp);
 
 		*agino = next_agino;
-		error = xfs_iunlink_map_ino(tp, pag->pag_agno, next_agino, imap,
+		error = xfs_iunlink_map_ino(pag, tp, next_agino, imap,
 				dipp, bpp);
 		if (error)
 			return error;
-- 
2.35.1

