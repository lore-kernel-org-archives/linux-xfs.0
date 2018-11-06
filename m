Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60972 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbeKFNbj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 08:31:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA63xbsJ030585
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:26 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2nh3mpjt1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 04:08:26 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA648QPL032406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:26 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA648QZs027072
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:26 GMT
Subject: [PATCH 3/8] xfs: check the ir_startino alignment directly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Nov 2018 20:08:25 -0800
Message-ID: <154147730502.32496.4086322277755351139.stgit@magnolia>
In-Reply-To: <154147728649.32496.4515247239602322709.stgit@magnolia>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
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
 fs/xfs/scrub/ialloc.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 3c12a0fe3b38..f498dfca3312 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -278,6 +278,29 @@ xchk_iallocbt_check_freemask(
 	return error;
 }
 
+/* Make sure this record is aligned to cluster and inoalignmnt size. */
+STATIC void
+xchk_iallocbt_rec_alignment(
+	struct xchk_btree		*bs,
+	struct xfs_inobt_rec_incore	*irec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xchk_iallocbt		*iabt = bs->private;
+	xfs_agino_t			imask;
+
+	imask = XFS_OFFBNO_TO_AGINO(mp, iabt->cluster_align, 0) - 1;
+	if (irec->ir_startino & imask) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return;
+	}
+
+	imask = XFS_OFFBNO_TO_AGINO(mp, iabt->blocks_per_cluster, 0) - 1;
+	if (irec->ir_startino & imask) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return;
+	}
+}
+
 /* Scrub an inobt/finobt record. */
 STATIC int
 xchk_iallocbt_rec(
@@ -290,7 +313,6 @@ xchk_iallocbt_rec(
 	uint64_t			holes;
 	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
 	xfs_agino_t			agino;
-	xfs_agblock_t			agbno;
 	xfs_extlen_t			len;
 	int				holecount;
 	int				i;
@@ -317,11 +339,9 @@ xchk_iallocbt_rec(
 		goto out;
 	}
 
-	/* Make sure this record is aligned to cluster and inoalignmnt size. */
-	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
-	if ((agbno & (iabt->cluster_align - 1)) ||
-	    (agbno & (iabt->blocks_per_cluster - 1)))
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+	xchk_iallocbt_rec_alignment(bs, &irec);
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
 
 	iabt->inodes += irec.ir_count;
 
