Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbeKII6c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 03:58:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA8NJalw066249
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:40 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2nh4ar47w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Nov 2018 23:20:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA8NKdur030015
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:40 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA8NKdpW007734
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:39 GMT
Subject: [PATCH 5/5] xfs: precalculate cluster alignment in inodes and blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 08 Nov 2018 15:20:39 -0800
Message-ID: <154171923920.30818.16202775253577895387.stgit@magnolia>
In-Reply-To: <154171920164.30818.2178553842722589349.stgit@magnolia>
References: <154171920164.30818.2178553842722589349.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Store the inode cluster alignment information in units of inodes and
blocks in the mount data so that we don't have to keep recalculating
them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |    8 ++++----
 fs/xfs/libxfs/xfs_types.c  |    5 ++---
 fs/xfs/scrub/ialloc.c      |    2 +-
 fs/xfs/xfs_mount.c         |    2 ++
 fs/xfs/xfs_mount.h         |    2 ++
 5 files changed, 11 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index dfcd739edcec..e69ce96e83e1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -690,7 +690,7 @@ xfs_ialloc_ag_alloc(
 		 * but not to use them in the actual exact allocation.
 		 */
 		args.alignment = 1;
-		args.minalignslop = xfs_ialloc_cluster_alignment(args.mp) - 1;
+		args.minalignslop = args.mp->m_cluster_align - 1;
 
 		/* Allow space for the inode btree to split. */
 		args.minleft = args.mp->m_in_maxlevels - 1;
@@ -725,7 +725,7 @@ xfs_ialloc_ag_alloc(
 			args.alignment = args.mp->m_dalign;
 			isaligned = 1;
 		} else
-			args.alignment = xfs_ialloc_cluster_alignment(args.mp);
+			args.alignment = args.mp->m_cluster_align;
 		/*
 		 * Need to figure out where to allocate the inode blocks.
 		 * Ideally they should be spaced out through the a.g.
@@ -754,7 +754,7 @@ xfs_ialloc_ag_alloc(
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.agbno = be32_to_cpu(agi->agi_root);
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
-		args.alignment = xfs_ialloc_cluster_alignment(args.mp);
+		args.alignment = args.mp->m_cluster_align;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
@@ -1017,7 +1017,7 @@ xfs_ialloc_ag_select(
 		 */
 		ineed = mp->m_ialloc_min_blks;
 		if (flags && ineed > 1)
-			ineed += xfs_ialloc_cluster_alignment(mp);
+			ineed += mp->m_cluster_align;
 		longest = pag->pagf_longest;
 		if (!longest)
 			longest = pag->pagf_flcount > 0;
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 895c232d63b7..3306fc42cfad 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -87,15 +87,14 @@ xfs_agino_range(
 	 * Calculate the first inode, which will be in the first
 	 * cluster-aligned block after the AGFL.
 	 */
-	bno = round_up(XFS_AGFL_BLOCK(mp) + 1,
-			xfs_ialloc_cluster_alignment(mp));
+	bno = round_up(XFS_AGFL_BLOCK(mp) + 1, mp->m_cluster_align);
 	*first = XFS_AGB_TO_AGINO(mp, bno);
 
 	/*
 	 * Calculate the last inode, which will be at the end of the
 	 * last (aligned) cluster that can be allocated in the AG.
 	 */
-	bno = round_down(eoag, xfs_ialloc_cluster_alignment(mp));
+	bno = round_down(eoag, mp->m_cluster_align);
 	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;
 }
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 332ac7b61789..26b07e0abc0c 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -300,7 +300,7 @@ xchk_iallocbt_rec(
 
 	/* Make sure this record is aligned to cluster and inoalignmnt size. */
 	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
-	if ((agbno & (xfs_ialloc_cluster_alignment(mp) - 1)) ||
+	if ((agbno & (mp->m_cluster_align - 1)) ||
 	    (agbno & (mp->m_blocks_per_cluster - 1)))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 56d374675fd5..b4d8c318be3c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -800,6 +800,8 @@ xfs_mountfs(
 	}
 	mp->m_blocks_per_cluster = xfs_icluster_size_fsb(mp);
 	mp->m_inodes_per_cluster = XFS_FSB_TO_INO(mp, mp->m_blocks_per_cluster);
+	mp->m_cluster_align = xfs_ialloc_cluster_alignment(mp);
+	mp->m_cluster_align_inodes = XFS_FSB_TO_INO(mp, mp->m_cluster_align);
 
 	/*
 	 * If enabled, sparse inode chunk alignment is expected to match the
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 58a037bfac22..0ad025e7f3cf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -103,6 +103,8 @@ typedef struct xfs_mount {
 	uint			m_inode_cluster_size;/* min inode buf size */
 	unsigned int		m_inodes_per_cluster;
 	unsigned int		m_blocks_per_cluster;
+	unsigned int		m_cluster_align;
+	unsigned int		m_cluster_align_inodes;
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
