Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C26C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377741AbhLCAFB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:05:01 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58518 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377767AbhLCAE7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:59 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 8AC47606A14
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1KV-Mu
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00BkhF-Lv
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/36] xfs: replace xfs_ag_block_count() with perag accesses
Date:   Fri,  3 Dec 2021 11:00:48 +1100
Message-Id: <20211203000111.2800982-14-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61a95e4c
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=lvI39o05NRYNU6UdGCYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Many of the places that call xfs_ag_block_count() have a perag
available. These places can just read pag->block_count directly
instead of calculating the AG block count from first principles.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c | 10 +++++-----
 fs/xfs/scrub/agheader_repair.c   |  6 ++----
 fs/xfs/scrub/repair.c            |  8 ++++----
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index aa4367a0a0de..2e0ff99d9f0b 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -683,10 +683,10 @@ xfs_inobt_rec_check_count(
 
 static xfs_extlen_t
 xfs_inobt_max_size(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
+	struct xfs_perag	*pag)
 {
-	xfs_agblock_t		agblocks = xfs_ag_block_count(mp, agno);
+	struct xfs_mount	*mp = pag->pag_mount;
+	xfs_agblock_t		agblocks = pag->block_count;
 
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
 	if (M_IGEO(mp)->inobt_mxr[0] == 0)
@@ -698,7 +698,7 @@ xfs_inobt_max_size(
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
 	if (mp->m_sb.sb_logstart &&
-	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == pag->pag_agno)
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	return xfs_btree_calc_size(M_IGEO(mp)->inobt_mnr,
@@ -800,7 +800,7 @@ xfs_finobt_calc_reserves(
 	if (error)
 		return error;
 
-	*ask += xfs_inobt_max_size(mp, pag->pag_agno);
+	*ask += xfs_inobt_max_size(pag);
 	*used += tree_len;
 	return 0;
 }
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index b32bb6bb3bc5..384fbef097e8 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -186,8 +186,7 @@ xrep_agf_init_header(
 	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
 	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
 	agf->agf_seqno = cpu_to_be32(sc->sa.pag->pag_agno);
-	agf->agf_length = cpu_to_be32(xfs_ag_block_count(mp,
-							sc->sa.pag->pag_agno));
+	agf->agf_length = cpu_to_be32(sc->sa.pag->block_count);
 	agf->agf_flfirst = old_agf->agf_flfirst;
 	agf->agf_fllast = old_agf->agf_fllast;
 	agf->agf_flcount = old_agf->agf_flcount;
@@ -765,8 +764,7 @@ xrep_agi_init_header(
 	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
 	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
 	agi->agi_seqno = cpu_to_be32(sc->sa.pag->pag_agno);
-	agi->agi_length = cpu_to_be32(xfs_ag_block_count(mp,
-							sc->sa.pag->pag_agno));
+	agi->agi_length = cpu_to_be32(sc->sa.pag->block_count);
 	agi->agi_newino = cpu_to_be32(NULLAGINO);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
 	if (xfs_has_crc(mp))
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index d8da7f994669..992d66453264 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -208,7 +208,7 @@ xrep_calc_ag_resblks(
 	/* Now grab the block counters from the AGF. */
 	error = xfs_alloc_read_agf(pag, NULL, 0, &bp);
 	if (error) {
-		aglen = xfs_ag_block_count(mp, sm->sm_agno);
+		aglen = pag->block_count;
 		freelen = aglen;
 		usedlen = aglen;
 	} else {
@@ -225,16 +225,16 @@ xrep_calc_ag_resblks(
 	    !xfs_verify_agino(pag, icount)) {
 		icount = pag->agino_max - pag->agino_min + 1;
 	}
-	xfs_perag_put(pag);
 
 	/* If the block counts are impossible, make worst-case assumptions. */
 	if (aglen == NULLAGBLOCK ||
-	    aglen != xfs_ag_block_count(mp, sm->sm_agno) ||
+	    aglen != pag->block_count ||
 	    freelen >= aglen) {
-		aglen = xfs_ag_block_count(mp, sm->sm_agno);
+		aglen = pag->block_count;
 		freelen = aglen;
 		usedlen = aglen;
 	}
+	xfs_perag_put(pag);
 
 	trace_xrep_calc_ag_resblks(mp, sm->sm_agno, icount, aglen,
 			freelen, usedlen);
-- 
2.33.0

