Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBF6BFYb210862 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 00:11:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E78FF65EB
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 22:11:51 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	ucDXxCGRbBM4COQ6 for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 22:11:51 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10080025-1927428
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 16:41:50 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NKQdR-0001lC-Fh
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 17:11:49 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NKQcy-0000d2-8w
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 17:11:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] XFS: convert remaining direct references to m_perag
Date: Tue, 15 Dec 2009 17:11:15 +1100
Message-Id: <1260857477-2368-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1260857477-2368-1-git-send-email-david@fromorbit.com>
References: <1260857477-2368-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Convert the remaining direct lookups of the per ag structures
to use get/put accesses. Ensure that the loops across AGs and
prior users of the interface balance gets and puts correctly.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_bmap.c   |    8 +++++++-
 fs/xfs/xfs_ialloc.c |   35 +++++++++++++++++++++++++----------
 fs/xfs/xfs_inode.c  |    5 ++++-
 fs/xfs/xfs_mount.c  |    9 ++++++---
 4 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 98251cd..a9b95d9 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2630,11 +2630,12 @@ xfs_bmap_btalloc(
 			startag = ag = 0;
 		notinit = 0;
 		down_read(&mp->m_peraglock);
+		pag = xfs_perag_get(mp, ag);
 		while (blen < ap->alen) {
-			pag = &mp->m_perag[ag];
 			if (!pag->pagf_init &&
 			    (error = xfs_alloc_pagf_init(mp, args.tp,
 				    ag, XFS_ALLOC_FLAG_TRYLOCK))) {
+				xfs_perag_put(pag);
 				up_read(&mp->m_peraglock);
 				return error;
 			}
@@ -2667,6 +2668,7 @@ xfs_bmap_btalloc(
 						break;
 
 					error = xfs_filestream_new_ag(ap, &ag);
+					xfs_perag_put(pag);
 					if (error) {
 						up_read(&mp->m_peraglock);
 						return error;
@@ -2674,6 +2676,7 @@ xfs_bmap_btalloc(
 
 					/* loop again to set 'blen'*/
 					startag = NULLAGNUMBER;
+					pag = xfs_perag_get(mp, ag);
 					continue;
 				}
 			}
@@ -2681,7 +2684,10 @@ xfs_bmap_btalloc(
 				ag = 0;
 			if (ag == startag)
 				break;
+			xfs_perag_put(pag);
+			pag = xfs_perag_get(mp, ag);
 		}
+		xfs_perag_put(pag);
 		up_read(&mp->m_peraglock);
 		/*
 		 * Since the above loop did a BUF_TRYLOCK, it is
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index cb907ba..884ee13 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -253,6 +253,7 @@ xfs_ialloc_ag_alloc(
 	xfs_agino_t	thisino;	/* current inode number, for loop */
 	int		isaligned = 0;	/* inode allocation at stripe unit */
 					/* boundary */
+	struct xfs_perag *pag;
 
 	args.tp = tp;
 	args.mp = tp->t_mountp;
@@ -383,7 +384,9 @@ xfs_ialloc_ag_alloc(
 	be32_add_cpu(&agi->agi_count, newlen);
 	be32_add_cpu(&agi->agi_freecount, newlen);
 	down_read(&args.mp->m_peraglock);
-	args.mp->m_perag[agno].pagi_freecount += newlen;
+	pag = xfs_perag_get(args.mp, agno);
+	pag->pagi_freecount += newlen;
+	xfs_perag_put(pag);
 	up_read(&args.mp->m_peraglock);
 	agi->agi_newino = cpu_to_be32(newino);
 
@@ -488,7 +491,7 @@ xfs_ialloc_ag_select(
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
 	down_read(&mp->m_peraglock);
 	for (;;) {
-		pag = &mp->m_perag[agno];
+		pag = xfs_perag_get(mp, agno);
 		if (!pag->pagi_init) {
 			if (xfs_ialloc_read_agi(mp, tp, agno, &agbp)) {
 				agbp = NULL;
@@ -527,6 +530,7 @@ xfs_ialloc_ag_select(
 					agbp = NULL;
 					goto nextag;
 				}
+				xfs_perag_put(pag);
 				up_read(&mp->m_peraglock);
 				return agbp;
 			}
@@ -535,6 +539,7 @@ unlock_nextag:
 		if (agbp)
 			xfs_trans_brelse(tp, agbp);
 nextag:
+		xfs_perag_put(pag);
 		/*
 		 * No point in iterating over the rest, if we're shutting
 		 * down.
@@ -672,6 +677,7 @@ xfs_dialloc(
 	xfs_agnumber_t	tagno;		/* testing allocation group number */
 	xfs_btree_cur_t	*tcur;		/* temp cursor */
 	xfs_inobt_rec_incore_t trec;	/* temp inode allocation record */
+	struct xfs_perag *pag;
 
 
 	if (*IO_agbp == NULL) {
@@ -772,11 +778,14 @@ nextag:
 			return noroom ? ENOSPC : 0;
 		}
 		down_read(&mp->m_peraglock);
-		if (mp->m_perag[tagno].pagi_inodeok == 0) {
+		pag = xfs_perag_get(mp, tagno);
+		if (pag->pagi_inodeok == 0) {
+			xfs_perag_put(pag);
 			up_read(&mp->m_peraglock);
 			goto nextag;
 		}
 		error = xfs_ialloc_read_agi(mp, tp, tagno, &agbp);
+		xfs_perag_put(pag);
 		up_read(&mp->m_peraglock);
 		if (error)
 			goto nextag;
@@ -790,6 +799,7 @@ nextag:
 	 */
 	agno = tagno;
 	*IO_agbp = NULL;
+	pag = xfs_perag_get(mp, agno);
 
  restart_pagno:
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, be32_to_cpu(agi->agi_seqno));
@@ -808,7 +818,6 @@ nextag:
 	 * If in the same AG as the parent, try to get near the parent.
 	 */
 	if (pagno == agno) {
-		xfs_perag_t	*pag = &mp->m_perag[agno];
 		int		doneleft;	/* done, to the left */
 		int		doneright;	/* done, to the right */
 		int		searchdistance = 10;
@@ -1007,7 +1016,7 @@ alloc_inode:
 	be32_add_cpu(&agi->agi_freecount, -1);
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
 	down_read(&mp->m_peraglock);
-	mp->m_perag[tagno].pagi_freecount--;
+	pag->pagi_freecount--;
 	up_read(&mp->m_peraglock);
 
 	error = xfs_check_agi_freecount(cur, agi);
@@ -1016,12 +1025,14 @@ alloc_inode:
 
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
+	xfs_perag_put(pag);
 	*inop = ino;
 	return 0;
 error1:
 	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
 error0:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_perag_put(pag);
 	return error;
 }
 
@@ -1052,6 +1063,7 @@ xfs_difree(
 	xfs_mount_t	*mp;	/* mount structure for filesystem */
 	int		off;	/* offset of inode in inode chunk */
 	xfs_inobt_rec_incore_t rec;	/* btree record */
+	struct xfs_perag *pag;
 
 	mp = tp->t_mountp;
 
@@ -1158,7 +1170,9 @@ xfs_difree(
 		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
 		down_read(&mp->m_peraglock);
-		mp->m_perag[agno].pagi_freecount -= ilen - 1;
+		pag = xfs_perag_get(mp, agno);
+		pag->pagi_freecount -= ilen - 1;
+		xfs_perag_put(pag);
 		up_read(&mp->m_peraglock);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
@@ -1189,7 +1203,9 @@ xfs_difree(
 		be32_add_cpu(&agi->agi_freecount, 1);
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
 		down_read(&mp->m_peraglock);
-		mp->m_perag[agno].pagi_freecount++;
+		pag = xfs_perag_get(mp, agno);
+		pag->pagi_freecount++;
+		xfs_perag_put(pag);
 		up_read(&mp->m_peraglock);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
 	}
@@ -1379,7 +1395,6 @@ xfs_imap(
 			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
 		return XFS_ERROR(EINVAL);
 	}
-
 	return 0;
 }
 
@@ -1523,8 +1538,7 @@ xfs_ialloc_read_agi(
 		return error;
 
 	agi = XFS_BUF_TO_AGI(*bpp);
-	pag = &mp->m_perag[agno];
-
+	pag = xfs_perag_get(mp, agno);
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
@@ -1537,6 +1551,7 @@ xfs_ialloc_read_agi(
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
 		XFS_FORCED_SHUTDOWN(mp));
+	xfs_perag_put(pag);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1f69dda..c2618db 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2695,7 +2695,7 @@ xfs_iflush_cluster(
 	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
 	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
 	if (!ilist)
-		return 0;
+		goto out_put;
 
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
@@ -2764,6 +2764,8 @@ xfs_iflush_cluster(
 out_free:
 	read_unlock(&pag->pag_ici_lock);
 	kmem_free(ilist);
+out_put:
+	xfs_perag_put(pag);
 	return 0;
 
 
@@ -2807,6 +2809,7 @@ cluster_corrupt_out:
 	 */
 	xfs_iflush_abort(iq);
 	kmem_free(ilist);
+	xfs_perag_put(pag);
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d652d59..4739c2c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -438,18 +438,20 @@ xfs_initialize_perag(
 			}
 
 			/* This ag is preferred for inodes */
-			pag = &mp->m_perag[index];
+			pag = xfs_perag_get(mp, index);
 			pag->pagi_inodeok = 1;
 			if (index < max_metadata)
 				pag->pagf_metadata = 1;
 			xfs_initialize_perag_icache(pag);
+			xfs_perag_put(pag);
 		}
 	} else {
 		/* Setup default behavior for smaller filesystems */
 		for (index = 0; index < agcount; index++) {
-			pag = &mp->m_perag[index];
+			pag = xfs_perag_get(mp, index);
 			pag->pagi_inodeok = 1;
 			xfs_initialize_perag_icache(pag);
+			xfs_perag_put(pag);
 		}
 	}
 	return index;
@@ -731,12 +733,13 @@ xfs_initialize_perag_data(xfs_mount_t *mp, xfs_agnumber_t agcount)
 		error = xfs_ialloc_pagi_init(mp, NULL, index);
 		if (error)
 			return error;
-		pag = &mp->m_perag[index];
+		pag = xfs_perag_get(mp, index);
 		ifree += pag->pagi_freecount;
 		ialloc += pag->pagi_count;
 		bfree += pag->pagf_freeblks;
 		bfreelst += pag->pagf_flcount;
 		btree += pag->pagf_btreeblks;
+		xfs_perag_put(pag);
 	}
 	/*
 	 * Overwrite incore superblock counters with just-read data
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
