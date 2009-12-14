Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBENBEcY185755 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 17:11:14 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B388D12E2FC5
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 15:11:49 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	dnbJySKP37LzYflD for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 15:11:49 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10057596-1927428
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 09:41:48 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NKK4w-0001Io-2V
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 10:11:46 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NKK4b-0003sc-QG
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 10:11:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] XFS: Replace per-ag array with a radix tree
Date: Tue, 15 Dec 2009 10:11:09 +1100
Message-Id: <1260832270-14762-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1260832270-14762-1-git-send-email-david@fromorbit.com>
References: <1260832270-14762-1-git-send-email-david@fromorbit.com>
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

The use of an array for the per-ag structures requires reallocation of the
array when growing the filesystem. This requires locking access to the array to
avoid use after free situations, and the locking is difficult to get right. To
avoid needing to reallocate an array, change the per-ag structures to an
allocated object per ag and index them using a tree structure.

The AGs are always densely indexed (hence the use of an array), but the number
supported is 2^32 and lookups tend to be random and hence indexing needs to
scale. A simple choice is a radix tree - it works well with this sort of index.
This change also removes another large contiguous allocation from the
mount/growfs path in XFS.

The growing process now needs to change to only initialise the new AGs required
for the extra space, and as such only needs to exclusively lock the tree for
inserts. The rest of the code only needs to lock the tree while doing lookups,
and hence this will remove all the deadlocks that currently occur on the
m_perag_lock as it is now an innermost lock. The lock is also changed to a
spinlock from a read/write lock as the hold time is now extremely short.

To complete the picture, the per-ag structures will need to be reference
counted to ensure that we don't free/modify them while they are still in use.
This will be done in subsequent patch.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_alloc.c      |    8 ------
 fs/xfs/xfs_bmap.c       |    7 +----
 fs/xfs/xfs_filestream.c |   13 +++------
 fs/xfs/xfs_fsops.c      |   42 +++++++++++++++---------------
 fs/xfs/xfs_ialloc.c     |   25 +----------------
 fs/xfs/xfs_itable.c     |    4 ---
 fs/xfs/xfs_mount.c      |   65 +++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_mount.h      |   14 +++++++---
 8 files changed, 87 insertions(+), 91 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 34873ac..d1349b1 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2419,7 +2419,6 @@ xfs_alloc_vextent(
 		 * These three force us into a single a.g.
 		 */
 		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-		down_read(&mp->m_peraglock);
 		args->pag = xfs_perag_get(mp, args->agno);
 		args->minleft = 0;
 		error = xfs_alloc_fix_freelist(args, 0);
@@ -2429,14 +2428,12 @@ xfs_alloc_vextent(
 			goto error0;
 		}
 		if (!args->agbp) {
-			up_read(&mp->m_peraglock);
 			TRACE_ALLOC("noagbp", args);
 			break;
 		}
 		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 		if ((error = xfs_alloc_ag_vextent(args)))
 			goto error0;
-		up_read(&mp->m_peraglock);
 		break;
 	case XFS_ALLOCTYPE_START_BNO:
 		/*
@@ -2488,7 +2485,6 @@ xfs_alloc_vextent(
 		 * Loop over allocation groups twice; first time with
 		 * trylock set, second time without.
 		 */
-		down_read(&mp->m_peraglock);
 		for (;;) {
 			args->pag = xfs_perag_get(mp, args->agno);
 			if (no_min) args->minleft = 0;
@@ -2549,7 +2545,6 @@ xfs_alloc_vextent(
 			}
 			xfs_perag_put(args->pag);
 		}
-		up_read(&mp->m_peraglock);
 		if (bump_rotor || (type == XFS_ALLOCTYPE_ANY_AG)) {
 			if (args->agno == sagno)
 				mp->m_agfrotor = (mp->m_agfrotor + 1) %
@@ -2579,7 +2574,6 @@ xfs_alloc_vextent(
 	return 0;
 error0:
 	xfs_perag_put(args->pag);
-	up_read(&mp->m_peraglock);
 	return error;
 }
 
@@ -2604,7 +2598,6 @@ xfs_free_extent(
 	args.agno = XFS_FSB_TO_AGNO(args.mp, bno);
 	ASSERT(args.agno < args.mp->m_sb.sb_agcount);
 	args.agbno = XFS_FSB_TO_AGBNO(args.mp, bno);
-	down_read(&args.mp->m_peraglock);
 	args.pag = xfs_perag_get(args.mp, args.agno);
 	if ((error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING)))
 		goto error0;
@@ -2616,7 +2609,6 @@ xfs_free_extent(
 	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
 error0:
 	xfs_perag_put(args.pag);
-	up_read(&args.mp->m_peraglock);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 719fa11..4847fb0 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2780,14 +2780,12 @@ xfs_bmap_btalloc(
 		if (startag == NULLAGNUMBER)
 			startag = ag = 0;
 		notinit = 0;
-		down_read(&mp->m_peraglock);
 		pag = xfs_perag_get(mp, ag);
 		while (blen < ap->alen) {
 			if (!pag->pagf_init &&
 			    (error = xfs_alloc_pagf_init(mp, args.tp,
 				    ag, XFS_ALLOC_FLAG_TRYLOCK))) {
 				xfs_perag_put(pag);
-				up_read(&mp->m_peraglock);
 				return error;
 			}
 			/*
@@ -2820,10 +2818,8 @@ xfs_bmap_btalloc(
 
 					error = xfs_filestream_new_ag(ap, &ag);
 					xfs_perag_put(pag);
-					if (error) {
-						up_read(&mp->m_peraglock);
+					if (error)
 						return error;
-					}
 
 					/* loop again to set 'blen'*/
 					startag = NULLAGNUMBER;
@@ -2839,7 +2835,6 @@ xfs_bmap_btalloc(
 			pag = xfs_perag_get(mp, ag);
 		}
 		xfs_perag_put(pag);
-		up_read(&mp->m_peraglock);
 		/*
 		 * Since the above loop did a BUF_TRYLOCK, it is
 		 * possible that there is space for this request.
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 08c27ba..bfe9777 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -252,8 +252,7 @@ next_ag:
 
 /*
  * Set the allocation group number for a file or a directory, updating inode
- * references and per-AG references as appropriate.  Must be called with the
- * m_peraglock held in read mode.
+ * references and per-AG references as appropriate.
  */
 static int
 _xfs_filestream_update_ag(
@@ -460,10 +459,10 @@ xfs_filestream_unmount(
 }
 
 /*
- * If the mount point's m_perag array is going to be reallocated, all
+ * If the mount point's m_perag tree is going to be modified, all
  * outstanding cache entries must be flushed to avoid accessing reference count
  * addresses that have been freed.  The call to xfs_filestream_flush() must be
- * made inside the block that holds the m_peraglock in write mode to do the
+ * made inside the block that holds the m_perag_lock in write mode to do the
  * reallocation.
  */
 void
@@ -535,7 +534,6 @@ xfs_filestream_associate(
 
 	mp = pip->i_mount;
 	cache = mp->m_filestream;
-	down_read(&mp->m_peraglock);
 
 	/*
 	 * We have a problem, Houston.
@@ -552,10 +550,8 @@ xfs_filestream_associate(
 	 *
 	 * So, if we can't get the iolock without sleeping then just give up
 	 */
-	if (!xfs_ilock_nowait(pip, XFS_IOLOCK_EXCL)) {
-		up_read(&mp->m_peraglock);
+	if (!xfs_ilock_nowait(pip, XFS_IOLOCK_EXCL))
 		return 1;
-	}
 
 	/* If the parent directory is already in the cache, use its AG. */
 	item = xfs_mru_cache_lookup(cache, pip->i_ino);
@@ -610,7 +606,6 @@ exit_did_pick:
 
 exit:
 	xfs_iunlock(pip, XFS_IOLOCK_EXCL);
-	up_read(&mp->m_peraglock);
 	return -err;
 }
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 36079aa..c0fcad8 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -166,27 +166,14 @@ xfs_growfs_data_private(
 	}
 	new = nb - mp->m_sb.sb_dblocks;
 	oagcount = mp->m_sb.sb_agcount;
-	if (nagcount > oagcount) {
-		void *new_perag, *old_perag;
-
-		xfs_filestream_flush(mp);
-
-		new_perag = kmem_zalloc(sizeof(xfs_perag_t) * nagcount,
-					KM_MAYFAIL);
-		if (!new_perag)
-			return XFS_ERROR(ENOMEM);
-
-		down_write(&mp->m_peraglock);
-		memcpy(new_perag, mp->m_perag, sizeof(xfs_perag_t) * oagcount);
-		old_perag = mp->m_perag;
-		mp->m_perag = new_perag;
-
-		mp->m_flags |= XFS_MOUNT_32BITINODES;
-		nagimax = xfs_initialize_perag(mp, nagcount);
-		up_write(&mp->m_peraglock);
 
-		kmem_free(old_perag);
+	/* allocate the new per-ag structures */
+	if (nagcount > oagcount) {
+		error = xfs_initialize_perag(mp, nagcount, &nagimax);
+		if (error)
+			return error;
 	}
+
 	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
 	tp->t_flags |= XFS_TRANS_RESERVE;
 	if ((error = xfs_trans_reserve(tp, XFS_GROWFS_SPACE_RES(mp),
@@ -195,6 +182,11 @@ xfs_growfs_data_private(
 		return error;
 	}
 
+	/*
+	 * Write new AG headers to disk. Non-transactional, but written
+	 * synchronously so they are completed prior to the growfs transaction
+	 * being logged.
+	 */
 	nfree = 0;
 	for (agno = nagcount - 1; agno >= oagcount; agno--, new -= agsize) {
 		/*
@@ -357,6 +349,12 @@ xfs_growfs_data_private(
 			goto error0;
 		}
 	}
+
+	/*
+	 * Update changed superblock fields transactionally. These are not
+	 * seen by the rest of the world until the transaction commit applies
+	 * them atomically to the superblock.
+	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
 	if (nb > mp->m_sb.sb_dblocks)
@@ -367,9 +365,9 @@ xfs_growfs_data_private(
 	if (dpct)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
 	error = xfs_trans_commit(tp, 0);
-	if (error) {
+	if (error)
 		return error;
-	}
+
 	/* New allocation groups fully initialized, so update mount struct */
 	if (nagimax)
 		mp->m_maxagi = nagimax;
@@ -379,6 +377,8 @@ xfs_growfs_data_private(
 		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
 	} else
 		mp->m_maxicount = 0;
+
+	/* update secondary superblocks. */
 	for (agno = 1; agno < nagcount; agno++) {
 		error = xfs_read_buf(mp, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 884ee13..52c9d00 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -383,11 +383,9 @@ xfs_ialloc_ag_alloc(
 	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
 	be32_add_cpu(&agi->agi_count, newlen);
 	be32_add_cpu(&agi->agi_freecount, newlen);
-	down_read(&args.mp->m_peraglock);
 	pag = xfs_perag_get(args.mp, agno);
 	pag->pagi_freecount += newlen;
 	xfs_perag_put(pag);
-	up_read(&args.mp->m_peraglock);
 	agi->agi_newino = cpu_to_be32(newino);
 
 	/*
@@ -489,7 +487,6 @@ xfs_ialloc_ag_select(
 	 */
 	agno = pagno;
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
-	down_read(&mp->m_peraglock);
 	for (;;) {
 		pag = xfs_perag_get(mp, agno);
 		if (!pag->pagi_init) {
@@ -531,7 +528,6 @@ xfs_ialloc_ag_select(
 					goto nextag;
 				}
 				xfs_perag_put(pag);
-				up_read(&mp->m_peraglock);
 				return agbp;
 			}
 		}
@@ -544,18 +540,14 @@ nextag:
 		 * No point in iterating over the rest, if we're shutting
 		 * down.
 		 */
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			up_read(&mp->m_peraglock);
+		if (XFS_FORCED_SHUTDOWN(mp))
 			return NULL;
-		}
 		agno++;
 		if (agno >= agcount)
 			agno = 0;
 		if (agno == pagno) {
-			if (flags == 0) {
-				up_read(&mp->m_peraglock);
+			if (flags == 0)
 				return NULL;
-			}
 			flags = 0;
 		}
 	}
@@ -777,16 +769,13 @@ nextag:
 			*inop = NULLFSINO;
 			return noroom ? ENOSPC : 0;
 		}
-		down_read(&mp->m_peraglock);
 		pag = xfs_perag_get(mp, tagno);
 		if (pag->pagi_inodeok == 0) {
 			xfs_perag_put(pag);
-			up_read(&mp->m_peraglock);
 			goto nextag;
 		}
 		error = xfs_ialloc_read_agi(mp, tp, tagno, &agbp);
 		xfs_perag_put(pag);
-		up_read(&mp->m_peraglock);
 		if (error)
 			goto nextag;
 		agi = XFS_BUF_TO_AGI(agbp);
@@ -1015,9 +1004,7 @@ alloc_inode:
 		goto error0;
 	be32_add_cpu(&agi->agi_freecount, -1);
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
-	down_read(&mp->m_peraglock);
 	pag->pagi_freecount--;
-	up_read(&mp->m_peraglock);
 
 	error = xfs_check_agi_freecount(cur, agi);
 	if (error)
@@ -1100,9 +1087,7 @@ xfs_difree(
 	/*
 	 * Get the allocation group header.
 	 */
-	down_read(&mp->m_peraglock);
 	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
-	up_read(&mp->m_peraglock);
 	if (error) {
 		cmn_err(CE_WARN,
 			"xfs_difree: xfs_ialloc_read_agi() returned an error %d on %s.  Returning error.",
@@ -1169,11 +1154,9 @@ xfs_difree(
 		be32_add_cpu(&agi->agi_count, -ilen);
 		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
-		down_read(&mp->m_peraglock);
 		pag = xfs_perag_get(mp, agno);
 		pag->pagi_freecount -= ilen - 1;
 		xfs_perag_put(pag);
-		up_read(&mp->m_peraglock);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
 
@@ -1202,11 +1185,9 @@ xfs_difree(
 		 */
 		be32_add_cpu(&agi->agi_freecount, 1);
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
-		down_read(&mp->m_peraglock);
 		pag = xfs_perag_get(mp, agno);
 		pag->pagi_freecount++;
 		xfs_perag_put(pag);
-		up_read(&mp->m_peraglock);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
 	}
 
@@ -1328,9 +1309,7 @@ xfs_imap(
 		xfs_buf_t	*agbp;	/* agi buffer */
 		int		i;	/* temp state */
 
-		down_read(&mp->m_peraglock);
 		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
-		up_read(&mp->m_peraglock);
 		if (error) {
 			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
 					"xfs_ialloc_read_agi() returned "
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 62efab2..940307a 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -420,9 +420,7 @@ xfs_bulkstat(
 	while (XFS_BULKSTAT_UBLEFT(ubleft) && agno < mp->m_sb.sb_agcount) {
 		cond_resched();
 		bp = NULL;
-		down_read(&mp->m_peraglock);
 		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
-		up_read(&mp->m_peraglock);
 		if (error) {
 			/*
 			 * Skip this allocation group and go to the next one.
@@ -849,9 +847,7 @@ xfs_inumbers(
 	agbp = NULL;
 	while (left > 0 && agno < mp->m_sb.sb_agcount) {
 		if (agbp == NULL) {
-			down_read(&mp->m_peraglock);
 			error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
-			up_read(&mp->m_peraglock);
 			if (error) {
 				/*
 				 * If we can't read the AGI of this ag,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3727104..1ab9495 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -207,13 +207,16 @@ STATIC void
 xfs_free_perag(
 	xfs_mount_t	*mp)
 {
-	if (mp->m_perag) {
-		int	agno;
+	xfs_agnumber_t	agno;
+	struct xfs_perag *pag;
 
-		for (agno = 0; agno < mp->m_maxagi; agno++)
-			if (mp->m_perag[agno].pagb_list)
-				kmem_free(mp->m_perag[agno].pagb_list);
-		kmem_free(mp->m_perag);
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		spin_lock(&mp->m_perag_lock);
+		pag = radix_tree_delete(&mp->m_perag_tree, agno);
+		spin_unlock(&mp->m_perag_lock);
+		ASSERT(pag);
+		kmem_free(pag->pagb_list);
+		kmem_free(pag);
 	}
 }
 
@@ -387,10 +390,11 @@ xfs_initialize_perag_icache(
 	}
 }
 
-xfs_agnumber_t
+int
 xfs_initialize_perag(
 	xfs_mount_t	*mp,
-	xfs_agnumber_t	agcount)
+	xfs_agnumber_t	agcount,
+	xfs_agnumber_t	*maxagi)
 {
 	xfs_agnumber_t	index, max_metadata;
 	xfs_perag_t	*pag;
@@ -403,6 +407,33 @@ xfs_initialize_perag(
 	agino = XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
 	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
 
+	/*
+	 * Walk the current per-ag tree so we don't try to initialise AGs
+	 * that already exist (growfs case). Allocate and insert all the
+	 * AGs we don't find ready for initialisation.
+	 */
+	for (index = 0; index < agcount; index++) {
+		pag = xfs_perag_get(mp, index);
+		if (pag) {
+			xfs_perag_put(pag);
+			continue;
+		}
+		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
+		if (!pag)
+			return -ENOMEM;
+		if (radix_tree_preload(GFP_NOFS))
+			return -ENOMEM;
+		spin_lock(&mp->m_perag_lock);
+		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
+			BUG();
+			spin_unlock(&mp->m_perag_lock);
+			kmem_free(pag);
+			return -EEXIST;
+		}
+		spin_unlock(&mp->m_perag_lock);
+		radix_tree_preload_end();
+	}
+
 	/* Clear the mount flag if no inode can overflow 32 bits
 	 * on this filesystem, or if specifically requested..
 	 */
@@ -452,7 +483,9 @@ xfs_initialize_perag(
 			xfs_perag_put(pag);
 		}
 	}
-	return index;
+	if (maxagi)
+		*maxagi = index;
+	return 0;
 }
 
 void
@@ -1153,13 +1186,13 @@ xfs_mountfs(
 	/*
 	 * Allocate and initialize the per-ag data.
 	 */
-	init_rwsem(&mp->m_peraglock);
-	mp->m_perag = kmem_zalloc(sbp->sb_agcount * sizeof(xfs_perag_t),
-				  KM_MAYFAIL);
-	if (!mp->m_perag)
+	spin_lock_init(&mp->m_perag_lock);
+	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_NOFS);
+	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
+	if (error) {
+		cmn_err(CE_WARN, "XFS: Failed per-ag init: %d", error);
 		goto out_remove_uuid;
-
-	mp->m_maxagi = xfs_initialize_perag(mp, sbp->sb_agcount);
+	}
 
 	if (!sbp->sb_logblocks) {
 		cmn_err(CE_WARN, "XFS: no log defined");
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f8a68a2..cfa7a5d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -207,8 +207,8 @@ typedef struct xfs_mount {
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* max inobt btree levels. */
-	struct xfs_perag	*m_perag;	/* per-ag accounting info */
-	struct rw_semaphore	m_peraglock;	/* lock for m_perag (pointer) */
+	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
+	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	struct mutex		m_growlock;	/* growfs mutex */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_dmevmask;	/* DMI events for this FS */
@@ -389,7 +389,12 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 static inline struct xfs_perag *
 xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 {
-	return &mp->m_perag[agno];
+	struct xfs_perag	*pag;
+
+	spin_lock(&mp->m_perag_lock);
+	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	spin_unlock(&mp->m_perag_lock);
+	return pag;
 }
 
 static inline void
@@ -450,7 +455,8 @@ extern struct xfs_dmops xfs_dmcore_xfs;
 #endif	/* __KERNEL__ */
 
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
-extern xfs_agnumber_t	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t);
+extern int	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t,
+					xfs_agnumber_t *);
 extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
