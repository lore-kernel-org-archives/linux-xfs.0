Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbeK2KbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 05:31:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wASNN2tL153138
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:44 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2nxy9rd757-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:44 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wASNRh4C015630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:44 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wASNRhv2027574
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:43 GMT
Subject: [PATCH 7/9] xfs: scrub big block inode btrees correctly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Nov 2018 15:27:42 -0800
Message-ID: <154344766230.3835.4451723560329644769.stgit@magnolia>
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

Teach scrub how to handle the case that there are one or more inobt
records covering a given inode cluster.  This fixes the operation on big
block filesystems (e.g. 64k blocks, 512 byte inodes).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 1d79f12dfce5..26bcf359b326 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -162,6 +162,7 @@ xchk_iallocbt_check_cluster_ifree(
 	xfs_ino_t			fsino;
 	xfs_agino_t			agino;
 	unsigned int			offset;
+	unsigned int			cluster_buf_base;
 	bool				irec_free;
 	bool				ino_inuse;
 	bool				freemask_ok;
@@ -174,11 +175,14 @@ xchk_iallocbt_check_cluster_ifree(
 	 * Given an inobt record, an offset of a cluster within the record,
 	 * and an offset of an inode within a cluster, compute which fs inode
 	 * we're talking about and the offset of the inode record within the
-	 * inode buffer.
+	 * inode buffer, being careful about inobt records that don't align
+	 * with the start of the inode buffer when block sizes are large.
 	 */
 	agino = irec->ir_startino + cluster_base + cluster_index;
 	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
-	offset = cluster_index * mp->m_sb.sb_inodesize;
+	cluster_buf_base = XFS_INO_TO_OFFSET(mp, irec->ir_startino +
+					     cluster_base);
+	offset = (cluster_buf_base + cluster_index) * mp->m_sb.sb_inodesize;
 	if (offset >= BBTOB(cluster_bp->b_length)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		goto out;
