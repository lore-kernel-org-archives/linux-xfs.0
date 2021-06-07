Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A219C47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 04:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58F3D6121E
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 04:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhFGERg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 00:17:36 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:37222 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230172AbhFGERf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 00:17:35 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 7AB4669F34
        for <linux-xfs@vger.kernel.org>; Mon,  7 Jun 2021 14:15:30 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lq6fh-009sHD-Fd
        for linux-xfs@vger.kernel.org; Mon, 07 Jun 2021 14:15:29 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lq6fh-001e6c-Br
        for linux-xfs@vger.kernel.org; Mon, 07 Jun 2021 14:15:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: drop the AGI being passed to xfs_check_agi_freecount
Date:   Mon,  7 Jun 2021 14:15:29 +1000
Message-Id: <20210607041529.392451-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=rOUgymgbAAAA:8
        a=_DxQJrri6HIFmNCLg2gA:9 a=MP9ZtiD8KjrkvI0BhSjB:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Stephen Rothwell reported this compiler warning from linux-next:

fs/xfs/libxfs/xfs_ialloc.c: In function 'xfs_difree_finobt':
fs/xfs/libxfs/xfs_ialloc.c:2032:20: warning: unused variable 'agi' [-Wunused-variable]
 2032 |  struct xfs_agi   *agi = agbp->b_addr;

Which is fallout from agno -> perag conversions that were done in
this function. xfs_check_agi_freecount() is the only user of "agi"
in xfs_difree_finobt() now, and it only uses the agi to get the
current free inode count. We hold that in the perag structure, so
there's not need to directly reference the raw AGI to get this
information.

The btree cursor being passed to xfs_check_agi_freecount() has a
reference to the perag being operated on, so use that directly in
xfs_check_agi_freecount() rather than passing an AGI.

Fixes: 7b13c5155182 ("xfs: use perag for ialloc btree cursors")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 2ed6de6faf8a..654a8d9681e1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -214,10 +214,9 @@ xfs_inobt_insert(
  * Verify that the number of free inodes in the AGI is correct.
  */
 #ifdef DEBUG
-STATIC int
+static int
 xfs_check_agi_freecount(
-	struct xfs_btree_cur	*cur,
-	struct xfs_agi		*agi)
+	struct xfs_btree_cur	*cur)
 {
 	if (cur->bc_nlevels == 1) {
 		xfs_inobt_rec_incore_t rec;
@@ -243,12 +242,12 @@ xfs_check_agi_freecount(
 		} while (i == 1);
 
 		if (!XFS_FORCED_SHUTDOWN(cur->bc_mp))
-			ASSERT(freecount == be32_to_cpu(agi->agi_freecount));
+			ASSERT(freecount == cur->bc_ag.pag->pagi_freecount);
 	}
 	return 0;
 }
 #else
-#define xfs_check_agi_freecount(cur, agi)	0
+#define xfs_check_agi_freecount(cur)	0
 #endif
 
 /*
@@ -1014,7 +1013,7 @@ xfs_dialloc_ag_inobt(
 	if (!pagino)
 		pagino = be32_to_cpu(agi->agi_newino);
 
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error0;
 
@@ -1234,7 +1233,7 @@ xfs_dialloc_ag_inobt(
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
 	pag->pagi_freecount--;
 
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error0;
 
@@ -1461,7 +1460,7 @@ xfs_dialloc_ag(
 
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_FINO);
 
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error_cur;
 
@@ -1504,7 +1503,7 @@ xfs_dialloc_ag(
 	 */
 	icur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
 
-	error = xfs_check_agi_freecount(icur, agi);
+	error = xfs_check_agi_freecount(icur);
 	if (error)
 		goto error_icur;
 
@@ -1522,10 +1521,10 @@ xfs_dialloc_ag(
 
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
 
-	error = xfs_check_agi_freecount(icur, agi);
+	error = xfs_check_agi_freecount(icur);
 	if (error)
 		goto error_icur;
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error_icur;
 
@@ -1911,7 +1910,7 @@ xfs_difree_inobt(
 	 */
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
 
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error0;
 
@@ -2004,7 +2003,7 @@ xfs_difree_inobt(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
 	}
 
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error0;
 
@@ -2029,7 +2028,6 @@ xfs_difree_finobt(
 	xfs_agino_t			agino,
 	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
 {
-	struct xfs_agi			*agi = agbp->b_addr;
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
 	int				offset = agino - ibtrec->ir_startino;
@@ -2114,7 +2112,7 @@ xfs_difree_finobt(
 	}
 
 out:
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error;
 
-- 
2.31.1

