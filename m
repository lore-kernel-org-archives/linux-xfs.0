Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbeKII6U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 03:58:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA8NJNQO066198
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:28 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2nh4ar47vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Nov 2018 23:20:28 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA8NKSSF029633
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:28 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA8NKRYv013977
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:27 GMT
Subject: [PATCH 3/5] xfs: add a block to inode count converter
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 08 Nov 2018 15:20:27 -0800
Message-ID: <154171922714.30818.15104071877694646829.stgit@magnolia>
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

Add new helpers to convert units of fs blocks into inodes, and AG blocks
into AG inodes, respectively.  Convert all the open-coded conversions
and XFS_OFFBNO_TO_AGINO(, , 0) calls to use them, as appropriate.  The
OFFBNO_TO_AGINO macro is retained for xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    2 ++
 fs/xfs/libxfs/xfs_ialloc.c |   17 ++++++++---------
 fs/xfs/libxfs/xfs_types.c  |    4 ++--
 fs/xfs/scrub/ialloc.c      |    2 +-
 fs/xfs/xfs_fsops.c         |    2 +-
 fs/xfs/xfs_inode.c         |    2 +-
 fs/xfs/xfs_itable.c        |    2 +-
 fs/xfs/xfs_super.c         |    4 ++--
 8 files changed, 18 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9995d5ae380b..52cf83986936 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1083,6 +1083,8 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 	((i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
 #define	XFS_OFFBNO_TO_AGINO(mp,b,o)	\
 	((xfs_agino_t)(((b) << XFS_INO_OFFSET_BITS(mp)) | (o)))
+#define	XFS_FSB_TO_INO(mp, b)	((xfs_ino_t)((b) << (mp)->m_sb.sb_inopblog))
+#define	XFS_AGB_TO_AGINO(mp, b)	((xfs_agino_t)((b) << (mp)->m_sb.sb_inopblog))
 
 #define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 56) - 1ULL))
 #define	XFS_MAXINUMBER_32	((xfs_ino_t)((1ULL << 32) - 1ULL))
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index fcf0d17405d8..cb46141f9d15 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -300,7 +300,7 @@ xfs_ialloc_inode_init(
 	 * blocks size.
 	 */
 	blks_per_cluster = xfs_icluster_size_fsb(mp);
-	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
+	inodes_per_cluster = XFS_FSB_TO_INO(mp, blks_per_cluster);
 	nbufs = length / blks_per_cluster;
 
 	/*
@@ -312,7 +312,7 @@ xfs_ialloc_inode_init(
 	 *
 	 * For v3 inodes, we also need to write the inode number into the inode,
 	 * so calculate the first inode number of the chunk here as
-	 * XFS_OFFBNO_TO_AGINO() only works within a filesystem block, not
+	 * XFS_AGB_TO_AGINO() only works within a filesystem block, not
 	 * across multiple filesystem blocks (such as a cluster) and so cannot
 	 * be used in the cluster buffer loop below.
 	 *
@@ -324,8 +324,7 @@ xfs_ialloc_inode_init(
 	 */
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		version = 3;
-		ino = XFS_AGINO_TO_INO(mp, agno,
-				       XFS_OFFBNO_TO_AGINO(mp, agbno, 0));
+		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
 
 		/*
 		 * log the initialisation that is about to take place as an
@@ -445,7 +444,7 @@ xfs_align_sparse_ino(
 		return;
 
 	/* calculate the inode offset and align startino */
-	offset = mod << mp->m_sb.sb_inopblog;
+	offset = XFS_AGB_TO_AGINO(mp, mod);
 	*startino -= offset;
 
 	/*
@@ -797,7 +796,7 @@ xfs_ialloc_ag_alloc(
 		if (error)
 			return error;
 
-		newlen = args.len << args.mp->m_sb.sb_inopblog;
+		newlen = XFS_AGB_TO_AGINO(args.mp, args.len);
 		ASSERT(newlen <= XFS_INODES_PER_CHUNK);
 		allocmask = (1 << (newlen / XFS_INODES_PER_HOLEMASK_BIT)) - 1;
 	}
@@ -825,7 +824,7 @@ xfs_ialloc_ag_alloc(
 	/*
 	 * Convert the results.
 	 */
-	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
+	newino = XFS_FSB_TO_INO(args.mp, args.agbno);
 
 	if (xfs_inobt_issparse(~allocmask)) {
 		/*
@@ -2724,8 +2723,8 @@ xfs_ialloc_has_inodes_at_extent(
 	xfs_agino_t		low;
 	xfs_agino_t		high;
 
-	low = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno, 0);
-	high = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno + len, 0) - 1;
+	low = XFS_AGB_TO_AGINO(cur->bc_mp, bno);
+	high = XFS_AGB_TO_AGINO(cur->bc_mp, bno + len) - 1;
 
 	return xfs_ialloc_has_inode_record(cur, low, high, exists);
 }
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 33a5ca346baf..895c232d63b7 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -89,14 +89,14 @@ xfs_agino_range(
 	 */
 	bno = round_up(XFS_AGFL_BLOCK(mp) + 1,
 			xfs_ialloc_cluster_alignment(mp));
-	*first = XFS_OFFBNO_TO_AGINO(mp, bno, 0);
+	*first = XFS_AGB_TO_AGINO(mp, bno);
 
 	/*
 	 * Calculate the last inode, which will be at the end of the
 	 * last (aligned) cluster that can be allocated in the AG.
 	 */
 	bno = round_down(eoag, xfs_ialloc_cluster_alignment(mp));
-	*last = XFS_OFFBNO_TO_AGINO(mp, bno, 0) - 1;
+	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;
 }
 
 /*
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 72f45b298fa5..426eb1a5503c 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -200,7 +200,7 @@ xchk_iallocbt_check_freemask(
 
 	/* Make sure the freemask matches the inode records. */
 	blks_per_cluster = xfs_icluster_size_fsb(mp);
-	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
+	nr_inodes = XFS_FSB_TO_INO(mp, blks_per_cluster);
 
 	for (agino = irec->ir_startino;
 	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 093c2b8d7e20..ec2e63a7963b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -252,7 +252,7 @@ xfs_growfs_data(
 	if (mp->m_sb.sb_imax_pct) {
 		uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
 		do_div(icount, 100);
-		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
+		mp->m_maxicount = XFS_FSB_TO_INO(mp, icount);
 	} else
 		mp->m_maxicount = 0;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 05db9540e459..55b865dadfaa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2200,7 +2200,7 @@ xfs_ifree_cluster(
 	inum = xic->first_ino;
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
 	blks_per_cluster = xfs_icluster_size_fsb(mp);
-	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
+	inodes_per_cluster = XFS_FSB_TO_INO(mp, blks_per_cluster);
 	nbufs = mp->m_ialloc_blks / blks_per_cluster;
 
 	for (j = 0; j < nbufs; j++, inum += inodes_per_cluster) {
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index e9508ba01ed1..18d8d3b812a7 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -173,7 +173,7 @@ xfs_bulkstat_ichunk_ra(
 
 	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
 	blks_per_cluster = xfs_icluster_size_fsb(mp);
-	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
+	inodes_per_cluster = XFS_FSB_TO_INO(mp, blks_per_cluster);
 
 	blk_start_plug(&plug);
 	for (i = 0; i < XFS_INODES_PER_CHUNK;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a2e944b80d2a..c9097cb0b955 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -608,7 +608,7 @@ xfs_set_inode_alloc(
 	}
 
 	/* Get the last possible inode in the filesystem */
-	agino =	XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
+	agino =	XFS_AGB_TO_AGINO(mp, sbp->sb_agblocks - 1);
 	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
 
 	/*
@@ -1150,7 +1150,7 @@ xfs_fs_statfs(
 	statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
 	statp->f_bavail = statp->f_bfree;
 
-	fakeinos = statp->f_bfree << sbp->sb_inopblog;
+	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
 	statp->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
 	if (mp->m_maxicount)
 		statp->f_files = min_t(typeof(statp->f_files),
