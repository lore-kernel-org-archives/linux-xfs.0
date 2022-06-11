Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54805CCA47E
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347234AbiFKB1m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349211AbiFKB1W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:22 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5D633FB123
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CD8845EC7FC
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005AQ6-Bf
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELNw-AV
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 42/50] xfs: merge new filestream AG selection into xfs_filestream_select_ag()
Date:   Sat, 11 Jun 2022 11:26:51 +1000
Message-Id: <20220611012659.3418072-43-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a3ef6a
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=NL0YZy4wweFwZ4PMF_YA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is largely a wrapper around xfs_filestream_pick_ag() that
repeats a lot of the lookups that we just merged back into
xfs_filestream_select_ag() from the lookup code. Merge the
xfs_filestream_new_ag() code back into _select_ag() to get rid
of all the unnecessary logic.

Indeed, this makes it obvious that if we have no parent inode,
the filestreams allocator always selects AG 0 regardless of whether
it is fit for purpose or not.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 120 +++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 996191273ea0..4c0392dedeb9 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -98,16 +98,18 @@ xfs_fstrm_free_func(
 static int
 xfs_filestream_pick_ag(
 	struct xfs_inode	*ip,
-	xfs_agnumber_t		startag,
 	xfs_agnumber_t		*agp,
 	int			flags,
-	xfs_extlen_t		minlen)
+	xfs_extlen_t		*longest)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_fstrm_item	*item;
 	struct xfs_perag	*pag;
-	xfs_extlen_t		longest, free = 0, minfree, maxfree = 0;
-	xfs_agnumber_t		ag, max_ag = NULLAGNUMBER;
+	xfs_extlen_t		minlen = *longest;
+	xfs_extlen_t		free = 0, minfree, maxfree = 0;
+	xfs_agnumber_t		startag = *agp;
+	xfs_agnumber_t		ag = startag;
+	xfs_agnumber_t		max_ag = NULLAGNUMBER;
 	int			err, trylock, nscan;
 
 	ASSERT(S_ISDIR(VFS_I(ip)->i_mode));
@@ -115,7 +117,6 @@ xfs_filestream_pick_ag(
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
 
-	ag = startag;
 	*agp = NULLAGNUMBER;
 
 	/* For the first pass, don't sleep trying to init the per-AG. */
@@ -125,8 +126,8 @@ xfs_filestream_pick_ag(
 		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
 
 		pag = xfs_perag_get(mp, ag);
-		longest = 0;
-		err = xfs_bmap_longest_free_extent(pag, NULL, &longest);
+		*longest = 0;
+		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
 			xfs_perag_put(pag);
 			if (err != -EAGAIN)
@@ -152,7 +153,7 @@ xfs_filestream_pick_ag(
 			goto next_ag;
 		}
 
-		if (((minlen && longest >= minlen) ||
+		if (((minlen && *longest >= minlen) ||
 		     (!minlen && pag->pagf_freeblks >= minfree)) &&
 		    (!xfs_perag_prefers_metadata(pag) ||
 		     !(flags & XFS_PICK_USERDATA) ||
@@ -258,58 +259,6 @@ xfs_filestream_get_parent(
 	return dir ? XFS_I(dir) : NULL;
 }
 
-/*
- * Pick a new allocation group for the current file and its file stream.
- *
- * This is called when the allocator can't find a suitable extent in the
- * current AG, and we have to move the stream into a new AG with more space.
- */
-static int
-xfs_filestream_new_ag(
-	struct xfs_bmalloca	*ap,
-	xfs_agnumber_t		*agp)
-{
-	struct xfs_inode	*ip = ap->ip, *pip;
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_extlen_t		minlen = ap->length;
-	xfs_agnumber_t		startag = 0;
-	int			flags = 0;
-	int			err = 0;
-	struct xfs_mru_cache_elem *mru;
-
-	*agp = NULLAGNUMBER;
-
-	pip = xfs_filestream_get_parent(ip);
-	if (!pip)
-		goto exit;
-
-	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
-	if (mru) {
-		struct xfs_fstrm_item *item =
-			container_of(mru, struct xfs_fstrm_item, mru);
-		startag = (item->ag + 1) % mp->m_sb.sb_agcount;
-	}
-
-	if (ap->datatype & XFS_ALLOC_USERDATA)
-		flags |= XFS_PICK_USERDATA;
-	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
-		flags |= XFS_PICK_LOWSPACE;
-
-	err = xfs_filestream_pick_ag(pip, startag, agp, flags, minlen);
-
-	/*
-	 * Only free the item here so we skip over the old AG earlier.
-	 */
-	if (mru)
-		xfs_fstrm_free_func(mp, mru);
-
-	xfs_irele(pip);
-exit:
-	if (*agp == NULLAGNUMBER)
-		*agp = 0;
-	return err;
-}
-
 /*
  * Search for an allocation group with a single extent large enough for
  * the request.  If one isn't found, then adjust the minimum allocation
@@ -326,6 +275,7 @@ xfs_filestream_select_ag(
 	struct xfs_inode	*pip = NULL;
 	xfs_agnumber_t		agno = NULLAGNUMBER;
 	struct xfs_mru_cache_elem *mru;
+	int			flags = 0;
 	int			error;
 
 	args->total = ap->total;
@@ -334,18 +284,18 @@ xfs_filestream_select_ag(
 	pip = xfs_filestream_get_parent(ap->ip);
 	if (!pip) {
 		agno = 0;
-		goto new_ag;
+		goto out_select;
 	}
 
 	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
 	if (mru) {
 		agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
 		xfs_mru_cache_done(mp->m_filestream);
+		mru = NULL;
 
-		trace_xfs_filestream_lookup(mp, ap->ip->i_ino, start_agno);
-		xfs_irele(pip);
+		trace_xfs_filestream_lookup(mp, ap->ip->i_ino, agno);
 
-		ap->blkno = XFS_AGB_TO_FSB(args->mp, start_agno, 0);
+		ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
 		xfs_bmap_adjacent(ap);
 
 		pag = xfs_perag_grab(mp, agno);
@@ -354,7 +304,7 @@ xfs_filestream_select_ag(
 			xfs_perag_rele(pag);
 			if (error) {
 				if (error != -EAGAIN)
-					return error;
+					goto out_error;
 				*blen = 0;
 			}
 		}
@@ -366,37 +316,59 @@ xfs_filestream_select_ag(
 				mp->m_sb.sb_agcount;
 		mp->m_agfrotor = (mp->m_agfrotor + 1) %
 				 (mp->m_sb.sb_agcount * rotorstep);
-		xfs_irele(pip);
 	} else {
 		agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
-		xfs_irele(pip);
 	}
 
-new_ag:
+	/* Changing parent AG association now, so remove the existing one. */
+	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
+	if (mru) {
+		struct xfs_fstrm_item *item =
+			container_of(mru, struct xfs_fstrm_item, mru);
+		agno = (item->ag + 1) % mp->m_sb.sb_agcount;
+	}
 	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
 	xfs_bmap_adjacent(ap);
 
-	error = xfs_filestream_new_ag(ap, &agno);
+	if (ap->datatype & XFS_ALLOC_USERDATA)
+		flags |= XFS_PICK_USERDATA;
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
+		flags |= XFS_PICK_LOWSPACE;
+
+	*blen = ap->length;
+	error = xfs_filestream_pick_ag(pip, &agno, flags, blen);
 	if (error)
-		return error;
-	if (agno == NULLAGNUMBER)
-		goto out_select;
+		goto out_error;
+	if (agno == NULLAGNUMBER) {
+		agno = 0;
+		goto out_irele;
+	}
 
 	pag = xfs_perag_grab(mp, agno);
 	if (!pag)
-		goto out_select;
+		goto out_irele;
 
 	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
 	xfs_perag_rele(pag);
 	if (error) {
 		if (error != -EAGAIN)
-			return error;
+			goto out_error;
 		*blen = 0;
 	}
 
+out_irele:
+	if (mru)
+		xfs_fstrm_free_func(mp, mru);
+	xfs_irele(pip);
 out_select:
 	ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
 	return 0;
+out_error:
+	if (mru)
+		xfs_fstrm_free_func(mp, mru);
+	xfs_irele(pip);
+	return error;
+
 }
 
 void
-- 
2.35.1

