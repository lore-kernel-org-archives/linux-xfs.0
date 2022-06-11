Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91A2C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348881AbiFKB1o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349153AbiFKB1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:23 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CED2F3FB11B
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DC60A5EC7EA
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:10 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005AQ3-AT
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELNr-8o
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 41/50] xfs: merge filestream AG lookup into xfs_filestream_select_ag()
Date:   Sat, 11 Jun 2022 11:26:50 +1000
Message-Id: <20220611012659.3418072-42-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef6e
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=j8ySbwcqsO3cM9aUnH8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It currently either returns the cached filestream AG or it looks up
a new one. It has to be verified on return, which means the
returning code then might have to look up a new AG anyway.
Merge the initial lookup functionality so that we only need to do a
single pick loop on lookup or verification failure.

This does make xfs_filestream_select_ag() messier and I've ignored
the long lines, because it's got to get worse before it can get
better...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 140 +++++++++++++++++-----------------------
 1 file changed, 59 insertions(+), 81 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 458df92fd9a6..996191273ea0 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -258,55 +258,6 @@ xfs_filestream_get_parent(
 	return dir ? XFS_I(dir) : NULL;
 }
 
-/*
- * Find the right allocation group for a file, either by finding an
- * existing file stream or creating a new one.
- *
- * Returns NULLAGNUMBER in case of an error.
- */
-static xfs_agnumber_t
-xfs_filestream_lookup_ag(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_inode	*pip = NULL;
-	xfs_agnumber_t		startag, ag = NULLAGNUMBER;
-	struct xfs_mru_cache_elem *mru;
-
-	ASSERT(S_ISREG(VFS_I(ip)->i_mode));
-
-	pip = xfs_filestream_get_parent(ip);
-	if (!pip)
-		return NULLAGNUMBER;
-
-	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
-	if (mru) {
-		ag = container_of(mru, struct xfs_fstrm_item, mru)->ag;
-		xfs_mru_cache_done(mp->m_filestream);
-
-		trace_xfs_filestream_lookup(mp, ip->i_ino, ag);
-		goto out;
-	}
-
-	/*
-	 * Set the starting AG using the rotor for inode32, otherwise
-	 * use the directory inode's AG.
-	 */
-	if (xfs_is_inode32(mp)) {
-		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
-		startag = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
-		mp->m_agfrotor = (mp->m_agfrotor + 1) %
-		                 (mp->m_sb.sb_agcount * rotorstep);
-	} else
-		startag = XFS_INO_TO_AGNO(mp, pip->i_ino);
-
-	if (xfs_filestream_pick_ag(pip, startag, &ag, 0, 0))
-		ag = NULLAGNUMBER;
-out:
-	xfs_irele(pip);
-	return ag;
-}
-
 /*
  * Pick a new allocation group for the current file and its file stream.
  *
@@ -372,52 +323,79 @@ xfs_filestream_select_ag(
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	struct xfs_perag	*pag;
-	xfs_agnumber_t		start_agno = xfs_filestream_lookup_ag(ap->ip);
+	struct xfs_inode	*pip = NULL;
+	xfs_agnumber_t		agno = NULLAGNUMBER;
+	struct xfs_mru_cache_elem *mru;
 	int			error;
 
-	/* Determine the initial block number we will target for allocation. */
-	if (start_agno == NULLAGNUMBER)
-		start_agno = 0;
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, start_agno, 0);
-	xfs_bmap_adjacent(ap);
 	args->total = ap->total;
+	*blen = 0;
 
-	pag = xfs_perag_grab(mp, start_agno);
-	if (pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-		xfs_perag_rele(pag);
-		if (error) {
-			if (error != -EAGAIN)
-				return error;
-			*blen = 0;
-		}
+	pip = xfs_filestream_get_parent(ap->ip);
+	if (!pip) {
+		agno = 0;
+		goto new_ag;
 	}
 
-	if (*blen < args->maxlen) {
-		xfs_agnumber_t	agno = start_agno;
+	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+	if (mru) {
+		agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
+		xfs_mru_cache_done(mp->m_filestream);
 
-		error = xfs_filestream_new_ag(ap, &agno);
-		if (error)
-			return error;
-		if (agno == NULLAGNUMBER)
-			goto out_select;
+		trace_xfs_filestream_lookup(mp, ap->ip->i_ino, start_agno);
+		xfs_irele(pip);
+
+		ap->blkno = XFS_AGB_TO_FSB(args->mp, start_agno, 0);
+		xfs_bmap_adjacent(ap);
 
 		pag = xfs_perag_grab(mp, agno);
-		if (!pag)
+		if (pag) {
+			error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+			xfs_perag_rele(pag);
+			if (error) {
+				if (error != -EAGAIN)
+					return error;
+				*blen = 0;
+			}
+		}
+		if (*blen >= args->maxlen)
 			goto out_select;
+	} else if (xfs_is_inode32(mp)) {
+		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
+		agno = (mp->m_agfrotor / rotorstep) %
+				mp->m_sb.sb_agcount;
+		mp->m_agfrotor = (mp->m_agfrotor + 1) %
+				 (mp->m_sb.sb_agcount * rotorstep);
+		xfs_irele(pip);
+	} else {
+		agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
+		xfs_irele(pip);
+	}
 
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-		xfs_perag_rele(pag);
-		if (error) {
-			if (error != -EAGAIN)
-				return error;
-			*blen = 0;
-		}
-		start_agno = agno;
+new_ag:
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
+	xfs_bmap_adjacent(ap);
+
+	error = xfs_filestream_new_ag(ap, &agno);
+	if (error)
+		return error;
+	if (agno == NULLAGNUMBER)
+		goto out_select;
+
+	pag = xfs_perag_grab(mp, agno);
+	if (!pag)
+		goto out_select;
+
+	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+	xfs_perag_rele(pag);
+	if (error) {
+		if (error != -EAGAIN)
+			return error;
+		*blen = 0;
 	}
 
 out_select:
-	ap->blkno = XFS_AGB_TO_FSB(mp, start_agno, 0);
+	ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
 	return 0;
 }
 
-- 
2.35.1

