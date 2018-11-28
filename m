Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47224 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbeK2Kai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 05:30:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wASNOOKc193637
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:19 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2nxx2ud950-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:19 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wASNRIZI012641
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:18 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wASNRIYN009295
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:18 GMT
Subject: [PATCH 3/9] xfs: check the ir_startino alignment directly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Nov 2018 15:27:17 -0800
Message-ID: <154344763743.3835.2133246210878375647.stgit@magnolia>
In-Reply-To: <154344761877.3835.7785580513047409388.stgit@magnolia>
References: <154344761877.3835.7785580513047409388.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xchk_iallocbt_rec, check the alignment of ir_startino by converting
the inode cluster block alignment into units of inodes instead of the
other way around (converting ir_startino to blocks).  This prevents us
from tripping over off-by-one errors in ir_startino which are obscured
by the inode -> block conversion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index fd431682db0b..ad241807b49a 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -265,6 +265,27 @@ xchk_iallocbt_check_freemask(
 	return error;
 }
 
+/* Make sure this record is aligned to cluster and inoalignmnt size. */
+STATIC void
+xchk_iallocbt_rec_alignment(
+	struct xchk_btree		*bs,
+	struct xfs_inobt_rec_incore	*irec)
+{
+	xfs_agino_t			imask;
+
+	imask = bs->sc->mp->m_cluster_align_inodes - 1;
+	if (irec->ir_startino & imask) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return;
+	}
+
+	imask = bs->sc->mp->m_inodes_per_cluster - 1;
+	if (irec->ir_startino & imask) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return;
+	}
+}
+
 /* Scrub an inobt/finobt record. */
 STATIC int
 xchk_iallocbt_rec(
@@ -277,7 +298,6 @@ xchk_iallocbt_rec(
 	uint64_t			holes;
 	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
 	xfs_agino_t			agino;
-	xfs_agblock_t			agbno;
 	xfs_extlen_t			len;
 	int				holecount;
 	int				i;
@@ -304,11 +324,9 @@ xchk_iallocbt_rec(
 		goto out;
 	}
 
-	/* Make sure this record is aligned to cluster and inoalignmnt size. */
-	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
-	if ((agbno & (mp->m_cluster_align - 1)) ||
-	    (agbno & (mp->m_blocks_per_cluster - 1)))
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+	xchk_iallocbt_rec_alignment(bs, &irec);
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
 
 	iabt->inodes += irec.ir_count;
 
