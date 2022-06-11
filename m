Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B005C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347629AbiFKB1l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347234AbiFKB1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:21 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB9063A482B
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AA8585EC7E0
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005AQR-Ku
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELOV-Jb
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 49/50] xfs: refactor the filestreams allocator pick functions
Date:   Sat, 11 Jun 2022 11:26:58 +1000
Message-Id: <20220611012659.3418072-50-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=w6-1Nq94jRNdTWLmbD0A:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the filestreams allocator is largely rewritten,
restructure the main entry point and pick function to seperate out
the different operations cleanly. The MRU lookup function should not
handle the start AG selection on MRU lookup failure, and nor should
the pick function handle building the association that is inserted
into the MRU.

This leaves the filestreams allocator fairly clean and easy to
understand, returning to the caller with an active perag reference
and a target block to allocate at.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 219 ++++++++++++++++++++--------------------
 fs/xfs/xfs_trace.h      |   9 +-
 2 files changed, 116 insertions(+), 112 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 2c02950efc22..f746c616f497 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -48,19 +48,19 @@ xfs_fstrm_free_func(
 }
 
 /*
- * Scan the AGs starting at startag looking for an AG that isn't in use and has
- * at least minlen blocks free.
+ * Scan the AGs starting at start_agno looking for an AG that isn't in use and
+ * has at least minlen blocks free. If no AG is found to match the allocation
+ * requirements, pick the AG with the most free space in it.
  */
 static int
 xfs_filestream_pick_ag(
 	struct xfs_alloc_arg	*args,
-	struct xfs_inode	*ip,
+	xfs_ino_t		pino,
 	xfs_agnumber_t		start_agno,
 	int			flags,
 	xfs_extlen_t		*longest)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_fstrm_item	*item;
+	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag;
 	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
@@ -68,8 +68,6 @@ xfs_filestream_pick_ag(
 	xfs_agnumber_t		agno;
 	int			err, trylock;
 
-	ASSERT(S_ISDIR(VFS_I(ip)->i_mode));
-
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
 
@@ -78,7 +76,7 @@ xfs_filestream_pick_ag(
 
 restart:
 	for_each_perag_wrap(mp, start_agno, agno, pag) {
-		trace_xfs_filestream_scan(pag, ip->i_ino);
+		trace_xfs_filestream_scan(pag, pino);
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
@@ -87,7 +85,7 @@ xfs_filestream_pick_ag(
 				break;
 			/* Couldn't lock the AGF, skip this AG. */
 			err = 0;
-			goto next_ag;
+			continue;
 		}
 
 		/* Keep track of the AG with the most free blocks. */
@@ -148,9 +146,9 @@ xfs_filestream_pick_ag(
 		 * grab.
 		 */
 		if (!max_pag) {
-			for_each_perag_wrap(mp, start_agno, agno, pag)
+			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
 				break;
-			atomic_inc(&pag->pagf_fstrms);
+			atomic_inc(&args->pag->pagf_fstrms);
 			*longest = 0;
 		} else {
 			pag = max_pag;
@@ -161,44 +159,10 @@ xfs_filestream_pick_ag(
 		xfs_perag_rele(max_pag);
 	}
 
-	trace_xfs_filestream_pick(ip, pag, free);
-
-	err = -ENOMEM;
-	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
-	if (!item)
-		goto out_put_ag;
-
-
-	/*
-	 * We are going to use this perag now, so take another ref to it for the
-	 * allocation context returned to the caller. If we raced to create and
-	 * insert the filestreams item into the MRU (-EEXIST), then we still
-	 * keep this reference but free the item reference we gained above. On
-	 * any other failure, we have to drop both.
-	 */
-	atomic_inc(&pag->pag_active_ref);
-	item->pag = pag;
+	trace_xfs_filestream_pick(pag, pino, free);
 	args->pag = pag;
-
-	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, &item->mru);
-	if (err) {
-		if (err == -EEXIST) {
-			err = 0;
-		} else {
-			xfs_perag_rele(args->pag);
-			args->pag = NULL;
-		}
-		goto out_free_item;
-	}
-
 	return 0;
 
-out_free_item:
-	kmem_free(item);
-out_put_ag:
-	atomic_dec(&pag->pagf_fstrms);
-	xfs_perag_rele(pag);
-	return err;
 }
 
 static struct xfs_inode *
@@ -227,29 +191,29 @@ xfs_filestream_get_parent(
 
 /*
  * Lookup the mru cache for an existing association. If one exists and we can
- * use it, return with the agno and blen indicating that the allocation will
- * proceed with that association.
+ * use it, return with an active perag reference indicating that the allocation
+ * will proceed with that association.
  *
  * If we have no association, or we cannot use the current one and have to
- * destroy it, return with blen = 0 and agno pointing at the next agno to try.
+ * destroy it, return with longest = 0 to tell the caller to create a new
+ * association.
  */
-int
-xfs_filestream_select_ag_mru(
+static int
+xfs_filestream_lookup_association(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
-	struct xfs_inode	*pip,
-	xfs_agnumber_t		*agno,
-	xfs_extlen_t		*blen)
+	xfs_ino_t		pino,
+	xfs_extlen_t		*longest)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag;
 	struct xfs_mru_cache_elem *mru;
 	int			error;
 
-	*blen = 0;
-	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+	*longest = 0;
+	mru = xfs_mru_cache_lookup(mp->m_filestream, pino);
 	if (!mru)
-		goto out_default_agno;
+		return 0;
 
 	/*
 	 * Grab the pag and take an extra active reference for the caller whilst
@@ -266,86 +230,127 @@ xfs_filestream_select_ag_mru(
 	ap->blkno = XFS_AGB_TO_FSB(args->mp, pag->pag_agno, 0);
 	xfs_bmap_adjacent(ap);
 
-	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-	if (error) {
+	error = xfs_bmap_longest_free_extent(pag, args->tp, longest);
+	if (error == -EAGAIN)
+		error = 0;
+	if (*longest < args->maxlen) {
 		/* We aren't going to use this perag */
+		*longest = 0;
 		xfs_perag_rele(pag);
-		if (error != -EAGAIN)
-			return error;
-		*blen = 0;
+		return error;
 	}
 
-	if (*blen >= args->maxlen) {
-		args->pag = pag;
-		return 0;
-	}
+	args->pag = pag;
+	return 0;
+}
+
+static int
+xfs_filestream_create_association(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_ino_t		pino,
+	xfs_extlen_t		*longest)
+{
+	struct xfs_mount	*mp = args->mp;
+	struct xfs_mru_cache_elem *mru;
+	struct xfs_fstrm_item	*item;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, pino);
+	int			flags = 0;
+	int			error;
 
 	/* Changing parent AG association now, so remove the existing one. */
-	xfs_perag_rele(pag);
-	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
+	mru = xfs_mru_cache_remove(mp->m_filestream, pino);
 	if (mru) {
 		struct xfs_fstrm_item *item =
 			container_of(mru, struct xfs_fstrm_item, mru);
-		*agno = (item->pag->pag_agno + 1) % mp->m_sb.sb_agcount;
-		xfs_fstrm_free_func(mp, mru);
-		return 0;
-	}
 
-out_default_agno:
-	if (xfs_is_inode32(mp)) {
+		agno = (item->pag->pag_agno + 1) % mp->m_sb.sb_agcount;
+		xfs_fstrm_free_func(mp, mru);
+	} else if (xfs_is_inode32(mp)) {
 		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
-		*agno = (mp->m_agfrotor / rotorstep) %
-				mp->m_sb.sb_agcount;
+
+		agno = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
 		mp->m_agfrotor = (mp->m_agfrotor + 1) %
 				 (mp->m_sb.sb_agcount * rotorstep);
-		return 0;
 	}
-	*agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
+
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
+	xfs_bmap_adjacent(ap);
+
+	if (ap->datatype & XFS_ALLOC_USERDATA)
+		flags |= XFS_PICK_USERDATA;
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
+		flags |= XFS_PICK_LOWSPACE;
+
+	*longest = ap->length;
+	error = xfs_filestream_pick_ag(args, pino, agno, flags, longest);
+	if (error)
+		return error;
+
+	/*
+	 * We are going to use this perag now, so create an assoication for it.
+	 * xfs_filestream_pick_ag() has already bumped the perag fstrms counter
+	 * for us, so all we need to do here is take another active reference to
+	 * the perag for the cached association.
+	 *
+	 * If we fail to store the association, we need to drop the fstrms
+	 * counter as well as drop the perag reference we take here for the
+	 * item. We do not need to return an error for this failure - as long as
+	 * we return a referenced AG, the allocation can still go ahead just
+	 * fine.
+	 */
+	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
+	if (!item)
+		goto out_put_fstrms;
+
+	atomic_inc(&args->pag->pag_active_ref);
+	item->pag = args->pag;
+	error = xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
+	if (error)
+		goto out_free_item;
 	return 0;
 
+out_free_item:
+	xfs_perag_rele(item->pag);
+	kmem_free(item);
+out_put_fstrms:
+	atomic_dec(&args->pag->pagf_fstrms);
+	return 0;
 }
 
 /*
  * Search for an allocation group with a single extent large enough for
- * the request.  If one isn't found, then adjust the minimum allocation
- * size to the largest space found.
+ * the request. First we look for an existing association and use that if it
+ * is found. Otherwise, we create a new association by selecting an AG that fits
+ * the allocation criteria.
+ *
+ * We return with a referenced perag in args->pag to indicate which AG we are
+ * allocating into or an error with no references held.
  */
 int
 xfs_filestream_select_ag(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		*blen)
+	xfs_extlen_t		*longest)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_inode	*pip = NULL;
-	xfs_agnumber_t		agno;
-	int			flags = 0;
-	int			error;
+	struct xfs_mount	*mp = args->mp;
+	struct xfs_inode	*pip;
+	xfs_ino_t		ino = 0;
+	int			error = 0;
 
+	*longest = 0;
 	args->total = ap->total;
 	pip = xfs_filestream_get_parent(ap->ip);
-	if (!pip) {
-		agno = 0;
-		goto out_select;
+	if (pip) {
+		ino = pip->i_ino;
+		error = xfs_filestream_lookup_association(ap, args, ino,
+				longest);
+		xfs_irele(pip);
 	}
 
-	error = xfs_filestream_select_ag_mru(ap, args, pip, &agno, blen);
-	if (error || *blen >= args->maxlen)
-		goto out_rele;
-
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
-	xfs_bmap_adjacent(ap);
-
-	if (ap->datatype & XFS_ALLOC_USERDATA)
-		flags |= XFS_PICK_USERDATA;
-	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
-		flags |= XFS_PICK_LOWSPACE;
-
-	*blen = ap->length;
-	error = xfs_filestream_pick_ag(args, pip, agno, flags, blen);
-out_rele:
-	xfs_irele(pip);
-out_select:
+	if (!error && *longest < args->maxlen)
+		error = xfs_filestream_create_association(ap, args, ino,
+				longest);
 	if (!error)
 		ap->blkno = XFS_AGB_TO_FSB(mp, args->pag->pag_agno, 0);
 	return error;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 95d5bc7d9030..a0bdcb601605 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -667,9 +667,8 @@ DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
 
 TRACE_EVENT(xfs_filestream_pick,
-	TP_PROTO(struct xfs_inode *ip, struct xfs_perag *pag,
-		 xfs_extlen_t free),
-	TP_ARGS(ip, pag, free),
+	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino, xfs_extlen_t free),
+	TP_ARGS(pag, ino, free),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -678,8 +677,8 @@ TRACE_EVENT(xfs_filestream_pick,
 		__field(xfs_extlen_t, free)
 	),
 	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->ino = ino;
 		if (pag) {
 			__entry->agno = pag->pag_agno;
 			__entry->streams = atomic_read(&pag->pagf_fstrms);
-- 
2.35.1

