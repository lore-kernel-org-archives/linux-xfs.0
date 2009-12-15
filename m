Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBF6BFZY210868 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 00:11:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4879F65ED
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 22:11:52 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	B29853kXjaOISaHe for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 22:11:52 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10080026-1927428
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 16:41:51 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NKQdR-0001l8-BA
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 17:11:49 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NKQcy-0000cw-4a
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 17:11:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] XFS: Don't directly reference m_perag in allocation code
Date: Tue, 15 Dec 2009 17:11:13 +1100
Message-Id: <1260857477-2368-3-git-send-email-david@fromorbit.com>
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

Start abstracting the perag references so that the indexing of the
structures is not directly coded into all the places that uses the
perag structures. This will allow us to separate the use of the
perag structure and the way it is indexed and hence avoid the known
deadlocks related to growing a busy filesystem.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_alloc.c       |   81 +++++++++++++++++++++++++--------------------
 fs/xfs/xfs_alloc_btree.c |    9 ++++-
 2 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index a1c65fc..3cb533c 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1662,11 +1662,13 @@ xfs_free_ag_extent(
 		xfs_agf_t	*agf;
 		xfs_perag_t	*pag;		/* per allocation group data */
 
+		pag = xfs_perag_get(mp, agno);
+		pag->pagf_freeblks += len;
+		xfs_perag_put(pag);
+
 		agf = XFS_BUF_TO_AGF(agbp);
-		pag = &mp->m_perag[agno];
 		be32_add_cpu(&agf->agf_freeblks, len);
 		xfs_trans_agblocks_delta(tp, len);
-		pag->pagf_freeblks += len;
 		XFS_WANT_CORRUPTED_GOTO(
 			be32_to_cpu(agf->agf_freeblks) <=
 			be32_to_cpu(agf->agf_length),
@@ -1969,7 +1971,8 @@ xfs_alloc_get_freelist(
 	xfs_trans_brelse(tp, agflbp);
 	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
 		agf->agf_flfirst = 0;
-	pag = &mp->m_perag[be32_to_cpu(agf->agf_seqno)];
+
+	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
 	be32_add_cpu(&agf->agf_flcount, -1);
 	xfs_trans_agflist_delta(tp, -1);
 	pag->pagf_flcount--;
@@ -2078,7 +2081,8 @@ xfs_alloc_put_freelist(
 	be32_add_cpu(&agf->agf_fllast, 1);
 	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
 		agf->agf_fllast = 0;
-	pag = &mp->m_perag[be32_to_cpu(agf->agf_seqno)];
+
+	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
 	be32_add_cpu(&agf->agf_flcount, 1);
 	xfs_trans_agflist_delta(tp, 1);
 	pag->pagf_flcount++;
@@ -2089,6 +2093,7 @@ xfs_alloc_put_freelist(
 		pag->pagf_btreeblks--;
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
+	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
@@ -2152,7 +2157,6 @@ xfs_read_agf(
 		xfs_trans_brelse(tp, *bpp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
-
 	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGF, XFS_AGF_REF);
 	return 0;
 }
@@ -2184,7 +2188,7 @@ xfs_alloc_read_agf(
 	ASSERT(!XFS_BUF_GETERROR(*bpp));
 
 	agf = XFS_BUF_TO_AGF(*bpp);
-	pag = &mp->m_perag[agno];
+	pag = xfs_perag_get(mp, agno);
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
@@ -2211,6 +2215,7 @@ xfs_alloc_read_agf(
 		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
 	}
 #endif
+	xfs_perag_put(pag);
 	return 0;
 }
 
@@ -2271,7 +2276,7 @@ xfs_alloc_vextent(
 		 */
 		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 		down_read(&mp->m_peraglock);
-		args->pag = &mp->m_perag[args->agno];
+		args->pag = xfs_perag_get(mp, args->agno);
 		args->minleft = 0;
 		error = xfs_alloc_fix_freelist(args, 0);
 		args->minleft = minleft;
@@ -2341,7 +2346,7 @@ xfs_alloc_vextent(
 		 */
 		down_read(&mp->m_peraglock);
 		for (;;) {
-			args->pag = &mp->m_perag[args->agno];
+			args->pag = xfs_perag_get(mp, args->agno);
 			if (no_min) args->minleft = 0;
 			error = xfs_alloc_fix_freelist(args, flags);
 			args->minleft = minleft;
@@ -2400,6 +2405,7 @@ xfs_alloc_vextent(
 					}
 				}
 			}
+			xfs_perag_put(args->pag);
 		}
 		up_read(&mp->m_peraglock);
 		if (bump_rotor || (type == XFS_ALLOCTYPE_ANY_AG)) {
@@ -2427,8 +2433,10 @@ xfs_alloc_vextent(
 			args->len);
 #endif
 	}
+	xfs_perag_put(args->pag);
 	return 0;
 error0:
+	xfs_perag_put(args->pag);
 	up_read(&mp->m_peraglock);
 	return error;
 }
@@ -2455,7 +2463,7 @@ xfs_free_extent(
 	ASSERT(args.agno < args.mp->m_sb.sb_agcount);
 	args.agbno = XFS_FSB_TO_AGBNO(args.mp, bno);
 	down_read(&args.mp->m_peraglock);
-	args.pag = &args.mp->m_perag[args.agno];
+	args.pag = xfs_perag_get(args.mp, args.agno);
 	if ((error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING)))
 		goto error0;
 #ifdef DEBUG
@@ -2465,6 +2473,7 @@ xfs_free_extent(
 #endif
 	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
 error0:
+	xfs_perag_put(args.pag);
 	up_read(&args.mp->m_peraglock);
 	return error;
 }
@@ -2486,15 +2495,15 @@ xfs_alloc_mark_busy(xfs_trans_t *tp,
 		    xfs_agblock_t bno,
 		    xfs_extlen_t len)
 {
-	xfs_mount_t		*mp;
 	xfs_perag_busy_t	*bsy;
+	struct xfs_perag	*pag;
 	int			n;
 
-	mp = tp->t_mountp;
-	spin_lock(&mp->m_perag[agno].pagb_lock);
+	pag = xfs_perag_get(tp->t_mountp, agno);
+	spin_lock(&pag->pagb_lock);
 
 	/* search pagb_list for an open slot */
-	for (bsy = mp->m_perag[agno].pagb_list, n = 0;
+	for (bsy = pag->pagb_list, n = 0;
 	     n < XFS_PAGB_NUM_SLOTS;
 	     bsy++, n++) {
 		if (bsy->busy_tp == NULL) {
@@ -2502,11 +2511,11 @@ xfs_alloc_mark_busy(xfs_trans_t *tp,
 		}
 	}
 
-	trace_xfs_alloc_busy(mp, agno, bno, len, n);
+	trace_xfs_alloc_busy(tp->t_mountp, agno, bno, len, n);
 
 	if (n < XFS_PAGB_NUM_SLOTS) {
-		bsy = &mp->m_perag[agno].pagb_list[n];
-		mp->m_perag[agno].pagb_count++;
+		bsy = &pag->pagb_list[n];
+		pag->pagb_count++;
 		bsy->busy_start = bno;
 		bsy->busy_length = len;
 		bsy->busy_tp = tp;
@@ -2521,7 +2530,8 @@ xfs_alloc_mark_busy(xfs_trans_t *tp,
 		xfs_trans_set_sync(tp);
 	}
 
-	spin_unlock(&mp->m_perag[agno].pagb_lock);
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
 }
 
 void
@@ -2529,24 +2539,23 @@ xfs_alloc_clear_busy(xfs_trans_t *tp,
 		     xfs_agnumber_t agno,
 		     int idx)
 {
-	xfs_mount_t		*mp;
+	struct xfs_perag	*pag;
 	xfs_perag_busy_t	*list;
 
-	mp = tp->t_mountp;
-
-	spin_lock(&mp->m_perag[agno].pagb_lock);
-	list = mp->m_perag[agno].pagb_list;
-
 	ASSERT(idx < XFS_PAGB_NUM_SLOTS);
+	pag = xfs_perag_get(tp->t_mountp, agno);
+	spin_lock(&pag->pagb_lock);
+	list = pag->pagb_list;
 
-	trace_xfs_alloc_unbusy(mp, agno, idx, list[idx].busy_tp == tp);
+	trace_xfs_alloc_unbusy(tp->t_mountp, agno, idx, list[idx].busy_tp == tp);
 
 	if (list[idx].busy_tp == tp) {
 		list[idx].busy_tp = NULL;
-		mp->m_perag[agno].pagb_count--;
+		pag->pagb_count--;
 	}
 
-	spin_unlock(&mp->m_perag[agno].pagb_lock);
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
 }
 
 
@@ -2560,21 +2569,20 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 		    xfs_agblock_t bno,
 		    xfs_extlen_t len)
 {
-	xfs_mount_t		*mp;
+	struct xfs_perag	*pag;
 	xfs_perag_busy_t	*bsy;
 	xfs_agblock_t		uend, bend;
 	xfs_lsn_t		lsn;
 	int			cnt;
 
-	mp = tp->t_mountp;
-
-	spin_lock(&mp->m_perag[agno].pagb_lock);
-	cnt = mp->m_perag[agno].pagb_count;
+	pag = xfs_perag_get(tp->t_mountp, agno);
+	spin_lock(&pag->pagb_lock);
+	cnt = pag->pagb_count;
 
 	uend = bno + len - 1;
 
 	/* search pagb_list for this slot, skipping open slots */
-	for (bsy = mp->m_perag[agno].pagb_list; cnt; bsy++) {
+	for (bsy = pag->pagb_list; cnt; bsy++) {
 
 		/*
 		 * (start1,length1) within (start2, length2)
@@ -2589,7 +2597,7 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 		}
 	}
 
-	trace_xfs_alloc_busysearch(mp, agno, bno, len, !!cnt);
+	trace_xfs_alloc_busysearch(tp->t_mountp, agno, bno, len, !!cnt);
 
 	/*
 	 * If a block was found, force the log through the LSN of the
@@ -2597,9 +2605,10 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	 */
 	if (cnt) {
 		lsn = bsy->busy_tp->t_commit_lsn;
-		spin_unlock(&mp->m_perag[agno].pagb_lock);
-		xfs_log_force(mp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
+		spin_unlock(&pag->pagb_lock);
+		xfs_log_force(tp->t_mountp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
 	} else {
-		spin_unlock(&mp->m_perag[agno].pagb_lock);
+		spin_unlock(&pag->pagb_lock);
 	}
+	xfs_perag_put(pag);
 }
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index adbd914..b726e10 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -61,12 +61,14 @@ xfs_allocbt_set_root(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
+	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
 
 	ASSERT(ptr->s != 0);
 
 	agf->agf_roots[btnum] = ptr->s;
 	be32_add_cpu(&agf->agf_levels[btnum], inc);
-	cur->bc_mp->m_perag[seqno].pagf_levels[btnum] += inc;
+	pag->pagf_levels[btnum] += inc;
+	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -150,6 +152,7 @@ xfs_allocbt_update_lastrec(
 {
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	struct xfs_perag	*pag;
 	__be32			len;
 	int			numrecs;
 
@@ -193,7 +196,9 @@ xfs_allocbt_update_lastrec(
 	}
 
 	agf->agf_longest = len;
-	cur->bc_mp->m_perag[seqno].pagf_longest = be32_to_cpu(len);
+	pag = xfs_perag_get(cur->bc_mp, seqno);
+	pag->pagf_longest = be32_to_cpu(len);
+	xfs_perag_put(pag);
 	xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp, XFS_AGF_LONGEST);
 }
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
