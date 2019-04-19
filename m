Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34830 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfDSAV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Apr 2019 20:21:26 -0400
Subject: [PATCH 4/5] xfs: scrub should check incore counters against ondisk
 headers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 18 Apr 2019 17:21:23 -0700
Message-ID: <155563328320.112668.15619698497236667722.stgit@magnolia>
In-Reply-To: <155563325882.112668.3605935077532891922.stgit@magnolia>
References: <155563325882.112668.3605935077532891922.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

In theory, the incore per-AG structure counters should match the ones on
disk, so check that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index ddf06bfaa29d..adaeabdefdd3 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -514,6 +514,7 @@ xchk_agf(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_agf		*agf;
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	xfs_agblock_t		eoag;
@@ -586,6 +587,16 @@ xchk_agf(
 	if (agfl_count != 0 && fl_count != agfl_count)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
+	/* Do the incore counters match? */
+	pag = xfs_perag_get(mp, agno);
+	if (pag->pagf_freeblks != be32_to_cpu(agf->agf_freeblks))
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
+	if (pag->pagf_flcount != be32_to_cpu(agf->agf_flcount))
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
+	if (pag->pagf_btreeblks != be32_to_cpu(agf->agf_btreeblks))
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
+	xfs_perag_put(pag);
+
 	xchk_agf_xref(sc);
 out:
 	return error;
@@ -811,6 +822,7 @@ xchk_agi(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_agi		*agi;
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	xfs_agblock_t		eoag;
@@ -881,6 +893,14 @@ xchk_agi(
 	if (agi->agi_pad32 != cpu_to_be32(0))
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
+	/* Do the incore counters match? */
+	pag = xfs_perag_get(mp, agno);
+	if (pag->pagi_count != be32_to_cpu(agi->agi_count))
+		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+	if (pag->pagi_freecount != be32_to_cpu(agi->agi_freecount))
+		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+	xfs_perag_put(pag);
+
 	xchk_agi_xref(sc);
 out:
 	return error;
