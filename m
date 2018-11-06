Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33326 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbeKFNcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 08:32:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA6499lM037005
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:09:09 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2nh3mpjt39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 04:09:09 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA6495cB010414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:09:05 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA6495ii011115
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:09:05 GMT
Subject: [PATCH 8/8] xfs: scrub big block inode btrees correctly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Nov 2018 20:08:59 -0800
Message-ID: <154147733964.32496.6293258964746388898.stgit@magnolia>
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

Teach scrub how to handle the case that there are one or more inobt
records covering a given inode cluster.  This fixes the operation on big
block filesystems (e.g. 64k blocks, 512 byte inodes).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 10c3aaefc2a3..5a5f8ae31803 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -169,6 +169,7 @@ xchk_iallocbt_check_cluster_ifree(
 	xfs_ino_t			fsino;
 	xfs_agino_t			agino;
 	unsigned int			offset;
+	unsigned int			cluster_ioff;
 	bool				irec_free;
 	bool				ino_inuse;
 	bool				freemask_ok;
@@ -181,11 +182,13 @@ xchk_iallocbt_check_cluster_ifree(
 	 * Given an inobt record, an offset of a cluster within the record,
 	 * and an offset of an inode within a cluster, compute which fs inode
 	 * we're talking about and the offset of the inode record within the
-	 * inode buffer.
+	 * inode buffer, being careful about inobt records that don't align
+	 * with the start of the inode buffer when block sizes are large.
 	 */
 	agino = irec->ir_startino + chunk_ioff + loop_ioff;
 	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
-	offset = loop_ioff * mp->m_sb.sb_inodesize;
+	cluster_ioff = XFS_INO_TO_OFFSET(mp, irec->ir_startino + chunk_ioff);
+	offset = (cluster_ioff + loop_ioff) * mp->m_sb.sb_inodesize;
 	if (offset >= BBTOB(bp->b_length)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		goto out;
