Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59578 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfAACIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:08:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0124VSh167890
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:08:42 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2pp1jqx3s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:08:42 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0128fqJ013700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:08:41 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0128elw029686
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:08:41 GMT
Subject: [PATCH 2/8] xfs: check the ir_startino alignment directly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:08:39 -0800
Message-ID: <154630851978.14372.12986942629611980027.stgit@magnolia>
In-Reply-To: <154630850739.14372.14000129432637481206.stgit@magnolia>
References: <154630850739.14372.14000129432637481206.stgit@magnolia>
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
 fs/xfs/scrub/ialloc.c |   45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index fd431682db0b..5082331d6c03 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -265,6 +265,42 @@ xchk_iallocbt_check_freemask(
 	return error;
 }
 
+/* Make sure this inode btree record is aligned properly. */
+STATIC void
+xchk_iallocbt_rec_alignment(
+	struct xchk_btree		*bs,
+	struct xfs_inobt_rec_incore	*irec)
+{
+	struct xfs_mount		*mp = bs->sc->mp;
+
+	/*
+	 * finobt records have different positioning requirements than inobt
+	 * records: each finobt record must have a corresponding inobt record.
+	 * That is checked in the xref function, so for now we only catch the
+	 * obvious case where the record isn't even chunk-aligned.
+	 *
+	 * Note also that if a fs block contains more than a single chunk of
+	 * inodes, we will have finobt records only for those chunks containing
+	 * free inodes.
+	 */
+	if (bs->cur->bc_btnum == XFS_BTNUM_FINO) {
+		if (irec->ir_startino & (XFS_INODES_PER_CHUNK - 1))
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return;
+	}
+
+	/* inobt records must be aligned to cluster and inoalignmnt size. */
+	if (irec->ir_startino & (mp->m_cluster_align_inodes - 1)) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return;
+	}
+
+	if (irec->ir_startino & (mp->m_inodes_per_cluster - 1)) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return;
+	}
+}
+
 /* Scrub an inobt/finobt record. */
 STATIC int
 xchk_iallocbt_rec(
@@ -277,7 +313,6 @@ xchk_iallocbt_rec(
 	uint64_t			holes;
 	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
 	xfs_agino_t			agino;
-	xfs_agblock_t			agbno;
 	xfs_extlen_t			len;
 	int				holecount;
 	int				i;
@@ -304,11 +339,9 @@ xchk_iallocbt_rec(
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
 
