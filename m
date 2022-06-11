Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA88FC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbiFKB1g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348229AbiFKB1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:21 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 728533FB110
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7116B5EC7DC
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005AQC-E3
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELO7-Cq
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 44/50] xfs: factor out MRU hit case in xfs_filestream_select_ag
Date:   Sat, 11 Jun 2022 11:26:53 +1000
Message-Id: <20220611012659.3418072-45-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=IRmtLSMBjInKpA2dfjAA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because it now stands out like a sore thumb and factoring out this
special case will simplify xfs_filestream_select_ag() again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 127 ++++++++++++++++++++++++----------------
 1 file changed, 78 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index d251f78ffc95..fcc30e8ebb90 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -260,73 +260,106 @@ xfs_filestream_get_parent(
 }
 
 /*
- * Search for an allocation group with a single extent large enough for
- * the request.  If one isn't found, then adjust the minimum allocation
- * size to the largest space found.
+ * Lookup the mru cache for an existing association. If one exists and we can
+ * use it, return with the agno and blen indicating that the allocation will
+ * proceed with that association.
+ *
+ * If we have no association, or we cannot use the current one and have to
+ * destroy it, return with blen = 0 and agno pointing at the next agno to try.
  */
 int
-xfs_filestream_select_ag(
+xfs_filestream_select_ag_mru(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
+	struct xfs_inode	*pip,
+	xfs_agnumber_t		*agno,
 	xfs_extlen_t		*blen)
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	struct xfs_perag	*pag;
-	struct xfs_inode	*pip = NULL;
-	xfs_agnumber_t		agno = NULLAGNUMBER;
 	struct xfs_mru_cache_elem *mru;
-	int			flags = 0;
 	int			error;
 
-	args->total = ap->total;
 	*blen = 0;
+	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+	if (!mru)
+		goto out_default_agno;
 
-	pip = xfs_filestream_get_parent(ap->ip);
-	if (!pip) {
-		agno = 0;
-		goto out_select;
+	*agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
+	xfs_mru_cache_done(mp->m_filestream);
+
+	trace_xfs_filestream_lookup(mp, ap->ip->i_ino, *agno);
+
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, *agno, 0);
+	xfs_bmap_adjacent(ap);
+
+	pag = xfs_perag_grab(mp, *agno);
+	if (!pag)
+		goto out_default_agno;
+
+	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+	xfs_perag_rele(pag);
+	if (error) {
+		if (error != -EAGAIN)
+			return error;
+		*blen = 0;
 	}
 
-	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+	if (*blen >= args->maxlen)
+		return 0;
+
+	/* Changing parent AG association now, so remove the existing one. */
+	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
 	if (mru) {
-		agno = container_of(mru, struct xfs_fstrm_item, mru)->ag;
-		xfs_mru_cache_done(mp->m_filestream);
-		mru = NULL;
-
-		trace_xfs_filestream_lookup(mp, ap->ip->i_ino, agno);
-
-		ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
-		xfs_bmap_adjacent(ap);
-
-		pag = xfs_perag_grab(mp, agno);
-		if (pag) {
-			error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-			xfs_perag_rele(pag);
-			if (error) {
-				if (error != -EAGAIN)
-					goto out_error;
-				*blen = 0;
-			}
-		}
-		if (*blen >= args->maxlen)
-			goto out_select;
-	} else if (xfs_is_inode32(mp)) {
+		struct xfs_fstrm_item *item =
+			container_of(mru, struct xfs_fstrm_item, mru);
+		*agno = (item->ag + 1) % mp->m_sb.sb_agcount;
+		xfs_fstrm_free_func(mp, mru);
+		return 0;
+	}
+
+out_default_agno:
+	if (xfs_is_inode32(mp)) {
 		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
-		agno = (mp->m_agfrotor / rotorstep) %
+		*agno = (mp->m_agfrotor / rotorstep) %
 				mp->m_sb.sb_agcount;
 		mp->m_agfrotor = (mp->m_agfrotor + 1) %
 				 (mp->m_sb.sb_agcount * rotorstep);
-	} else {
-		agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
+		return 0;
 	}
+	*agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
+	return 0;
 
-	/* Changing parent AG association now, so remove the existing one. */
-	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
-	if (mru) {
-		struct xfs_fstrm_item *item =
-			container_of(mru, struct xfs_fstrm_item, mru);
-		agno = (item->ag + 1) % mp->m_sb.sb_agcount;
+}
+
+/*
+ * Search for an allocation group with a single extent large enough for
+ * the request.  If one isn't found, then adjust the minimum allocation
+ * size to the largest space found.
+ */
+int
+xfs_filestream_select_ag(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		*blen)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_inode	*pip = NULL;
+	xfs_agnumber_t		agno;
+	int			flags = 0;
+	int			error;
+
+	args->total = ap->total;
+	pip = xfs_filestream_get_parent(ap->ip);
+	if (!pip) {
+		agno = 0;
+		goto out_select;
 	}
+
+	error = xfs_filestream_select_ag_mru(ap, args, pip, &agno, blen);
+	if (error || *blen >= args->maxlen)
+		goto out_rele;
+
 	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
 	xfs_bmap_adjacent(ap);
 
@@ -337,16 +370,12 @@ xfs_filestream_select_ag(
 
 	*blen = ap->length;
 	error = xfs_filestream_pick_ag(pip, &agno, flags, blen);
-	if (error)
-		goto out_error;
 	if (agno == NULLAGNUMBER) {
 		agno = 0;
 		*blen = 0;
 	}
 
-out_error:
-	if (mru)
-		xfs_fstrm_free_func(mp, mru);
+out_rele:
 	xfs_irele(pip);
 out_select:
 	if (!error)
-- 
2.35.1

