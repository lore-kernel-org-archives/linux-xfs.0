Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F3EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8167461101
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhIOXMR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232882AbhIOXMQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D3AA610A6;
        Wed, 15 Sep 2021 23:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747457;
        bh=V3E2oxp9pQNEe+cWw9Td85AspWxSds+EBeV4kpQbmg0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rEJNgaZb+6znQ3E4JFKQTTQ1J/P4gCDmh588VbpmJVod5fEMM9MtjXdNvArEkILaI
         TSnMLkWgJJE0FZkB34fpE6Upz9JpSL30gpWjOgPx8BDhboYZlyDEcNOckhz50Dclj4
         TPynKJv24mT1/FQ2Re4R1LnkDrjeyHGrfdhHl0zxkhIK7aHlgXNcv5DgsO6ACjh5Ui
         nWoLtwN33dnilRFcpmj4MPdoBA8Z73eSpOnPKY1tPwgR+srCNIT5R1aeiyU3sTW2kY
         z6Z9tMZsXt6jomnBNxrRnBvcjt158x/Mqr4Dan3h0G65eB3SQzxoE2CoiDh2HOEwoI
         gTCmt4aRpHvVQ==
Subject: [PATCH 48/61] xfs: drop the AGI being passed to
 xfs_check_agi_freecount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Chinner <dchinner@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:56 -0700
Message-ID: <163174745691.350433.12542735475665641852.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <david@fromorbit.com>

Source kernel commit: 9ba0889e2272294bfbb5589b1b180ad2e782b2a4

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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index e24136a4..d14437bf 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -209,10 +209,9 @@ xfs_inobt_insert(
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
@@ -238,12 +237,12 @@ xfs_check_agi_freecount(
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
@@ -1009,7 +1008,7 @@ xfs_dialloc_ag_inobt(
 	if (!pagino)
 		pagino = be32_to_cpu(agi->agi_newino);
 
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error0;
 
@@ -1229,7 +1228,7 @@ xfs_dialloc_ag_inobt(
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
 	pag->pagi_freecount--;
 
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error0;
 
@@ -1456,7 +1455,7 @@ xfs_dialloc_ag(
 
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_FINO);
 
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error_cur;
 
@@ -1499,7 +1498,7 @@ xfs_dialloc_ag(
 	 */
 	icur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
 
-	error = xfs_check_agi_freecount(icur, agi);
+	error = xfs_check_agi_freecount(icur);
 	if (error)
 		goto error_icur;
 
@@ -1517,10 +1516,10 @@ xfs_dialloc_ag(
 
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
 
-	error = xfs_check_agi_freecount(icur, agi);
+	error = xfs_check_agi_freecount(icur);
 	if (error)
 		goto error_icur;
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error_icur;
 
@@ -1906,7 +1905,7 @@ xfs_difree_inobt(
 	 */
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
 
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error0;
 
@@ -1999,7 +1998,7 @@ xfs_difree_inobt(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
 	}
 
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error0;
 
@@ -2024,7 +2023,6 @@ xfs_difree_finobt(
 	xfs_agino_t			agino,
 	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
 {
-	struct xfs_agi			*agi = agbp->b_addr;
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
 	int				offset = agino - ibtrec->ir_startino;
@@ -2109,7 +2107,7 @@ xfs_difree_finobt(
 	}
 
 out:
-	error = xfs_check_agi_freecount(cur, agi);
+	error = xfs_check_agi_freecount(cur);
 	if (error)
 		goto error;
 

