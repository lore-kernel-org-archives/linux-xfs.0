Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50254 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeHKSJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Aug 2018 14:09:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7BFYiKL094464
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:17 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2ksnacrvn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:17 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7BFZGrq029646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:17 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7BFZGoh031748
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:16 GMT
Subject: [PATCH 3/6] xfs: sanity check ag header values in
 xrep_calc_ag_resblks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 11 Aug 2018 08:35:15 -0700
Message-ID: <153400171586.27471.17428651076544146314.stgit@magnolia>
In-Reply-To: <153400169747.27471.4044680761841034489.stgit@magnolia>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the values we read in from the AG headers when calculating the
block reservations for a repair transaction.  If they're obviously
wrong, substitute worst case assumptions (rather than ENOSPC on a bogus
reservatoin request).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 42d8c798ce7d..97c3077fb005 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -195,8 +195,8 @@ xrep_calc_ag_resblks(
 	struct xfs_scrub_metadata	*sm = sc->sm;
 	struct xfs_perag		*pag;
 	struct xfs_buf			*bp;
-	xfs_agino_t			icount = 0;
-	xfs_extlen_t			aglen = 0;
+	xfs_agino_t			icount = NULLAGINO;
+	xfs_extlen_t			aglen = NULLAGBLOCK;
 	xfs_extlen_t			usedlen;
 	xfs_extlen_t			freelen;
 	xfs_extlen_t			bnobt_sz;
@@ -208,20 +208,14 @@ xrep_calc_ag_resblks(
 	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
 		return 0;
 
-	/* Use in-core counters if possible. */
 	pag = xfs_perag_get(mp, sm->sm_agno);
-	if (pag->pagi_init)
+	if (pag->pagi_init) {
+		/* Use in-core icount if possible. */
 		icount = pag->pagi_count;
-
-	/*
-	 * Otherwise try to get the actual counters from disk; if not, make
-	 * some worst case assumptions.
-	 */
-	if (icount == 0) {
+	} else {
+		/* Try to get the actual counters from disk. */
 		error = xfs_ialloc_read_agi(mp, NULL, sm->sm_agno, &bp);
-		if (error) {
-			icount = mp->m_sb.sb_agblocks / mp->m_sb.sb_inopblock;
-		} else {
+		if (!error) {
 			icount = pag->pagi_count;
 			xfs_buf_relse(bp);
 		}
@@ -229,18 +223,32 @@ xrep_calc_ag_resblks(
 
 	/* Now grab the block counters from the AGF. */
 	error = xfs_alloc_read_agf(mp, NULL, sm->sm_agno, 0, &bp);
-	if (error) {
-		aglen = mp->m_sb.sb_agblocks;
-		freelen = aglen;
-		usedlen = aglen;
-	} else {
+	if (!error) {
 		aglen = be32_to_cpu(XFS_BUF_TO_AGF(bp)->agf_length);
-		freelen = pag->pagf_freeblks;
+		freelen = be32_to_cpu(XFS_BUF_TO_AGF(bp)->agf_freeblks);
 		usedlen = aglen - freelen;
 		xfs_buf_relse(bp);
 	}
 	xfs_perag_put(pag);
 
+	/* If the icount is impossible, make some worst-case assumptions. */
+	if (icount == NULLAGINO ||
+	    !xfs_verify_agino(mp, sm->sm_agno, icount)) {
+		xfs_agino_t	first, last;
+
+		xfs_agino_range(mp, sm->sm_agno, &first, &last);
+		icount = last - first + 1;
+	}
+
+	/* If the block counts are impossible, make worst-case assumptions. */
+	if (aglen == NULLAGBLOCK ||
+	    aglen != xfs_ag_block_count(mp, sm->sm_agno) ||
+	    freelen >= aglen) {
+		aglen = xfs_ag_block_count(mp, sm->sm_agno);
+		freelen = aglen;
+		usedlen = aglen;
+	}
+
 	trace_xrep_calc_ag_resblks(mp, sm->sm_agno, icount, aglen,
 			freelen, usedlen);
 
