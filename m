Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39538 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeHKSJp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Aug 2018 14:09:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7BFYbM2078116
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:11 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2ksq7t0que-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:11 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7BFZA3C024879
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:10 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7BFZAmA011267
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:10 GMT
Subject: [PATCH 2/6] xfs: xrep_findroot_block should reject root blocks with
 siblings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 11 Aug 2018 08:35:09 -0700
Message-ID: <153400170977.27471.4053607329690572828.stgit@magnolia>
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

In xrep_findroot_block, if we find a candidate root block with sibling
pointers or sibling blocks on the same tree level, we should not return
that block as a tree root because root blocks cannot have siblings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 17cf48564390..42d8c798ce7d 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -690,6 +690,7 @@ xrep_findroot_block(
 	struct xfs_buf			*bp;
 	struct xfs_btree_block		*btblock;
 	xfs_daddr_t			daddr;
+	int				block_level;
 	int				error;
 
 	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.agno, agbno);
@@ -727,17 +728,51 @@ xrep_findroot_block(
 		goto out;
 	bp->b_ops = fab->buf_ops;
 
-	/* Ignore this block if it's lower in the tree than we've seen. */
-	if (fab->root != NULLAGBLOCK &&
-	    xfs_btree_get_level(btblock) < fab->height)
-		goto out;
-
 	/* Make sure we pass the verifiers. */
 	bp->b_ops->verify_read(bp);
 	if (bp->b_error)
 		goto out;
+
+	/* If we've recorded a root candidate... */
+	block_level = xfs_btree_get_level(btblock);
+	if (fab->root != NULLAGBLOCK) {
+		/*
+		 * ...and this no-sibling root block candidate has the same
+		 * level as the recorded candidate, there's no way we're going
+		 * to accept any candidates at this tree level.  Stash a root
+		 * block of zero because the height is still valid, but no
+		 * AG btree can root at agblock 0.  Callers should verify the
+		 * root agbno with xfs_verify_agbno...
+		 */
+		if (block_level + 1 == fab->height) {
+			fab->root = 0;
+			goto out;
+		}
+
+		/*
+		 * ...and this no-sibling root block is lower in the tree than
+		 * the recorded root block candidate, just ignore it.  There's
+		 * still a strong chance that something is wrong with the btree
+		 * itself, but that's not what we're fixing right now.
+		 */
+		if (block_level < fab->height)
+			goto out;
+	}
+
+	/*
+	 * Root blocks can't have siblings.  This level can't be the root, so
+	 * record the tree height (but not the ag block pointer) to force us to
+	 * look for a higher level in the tree.
+	 */
+	if (btblock->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) ||
+	    btblock->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)) {
+		fab->root = 0;
+		fab->height = block_level + 1;
+		goto out;
+	}
+
 	fab->root = agbno;
-	fab->height = xfs_btree_get_level(btblock) + 1;
+	fab->height = block_level + 1;
 	*found_it = true;
 
 	trace_xrep_findroot_block(mp, ri->sc->sa.agno, agbno,
