Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F5D681AB
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:05:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 47A748F8066
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:52 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id yB0qvm8Q5Iwzzb9U (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:51 -0800 (PST)
Subject: [PATCH 09/53] libxfs: resync xfs_prealloc_blocks with the kernel
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:05:48 -0800
Message-ID: <20151219090548.14255.15706.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Move xfs_prealloc_blocks() to the same line as in the kernel code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c |   22 +++++++++++-----------
 libxfs/xfs_alloc.h |    4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index fb6c705..fea94c8 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -46,6 +46,17 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
 
+xfs_extlen_t
+xfs_prealloc_blocks(
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return XFS_RMAP_BLOCK(mp) + 1;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		return XFS_FIBT_BLOCK(mp) + 1;
+	return XFS_IBT_BLOCK(mp) + 1;
+}
+
 /*
  * Lookup the record equal to [bno, len] in the btree given by cur.
  */
@@ -2715,14 +2726,3 @@ error0:
 	xfs_perag_put(args.pag);
 	return error;
 }
-
-xfs_extlen_t
-xfs_prealloc_blocks(
-	struct xfs_mount	*mp)
-{
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		return XFS_RMAP_BLOCK(mp) + 1;
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
-		return XFS_FIBT_BLOCK(mp) + 1;
-	return XFS_IBT_BLOCK(mp) + 1;
-}
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index a9d8e97..35b60ae 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -94,8 +94,6 @@ typedef unsigned int xfs_alloctype_t;
 #define XFS_ALLOC_AG_MAX_USABLE(mp)	\
 	((mp)->m_sb.sb_agblocks - XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)) - 7)
 
-xfs_extlen_t	xfs_prealloc_blocks(struct xfs_mount *mp);
-
 /*
  * Argument structure for xfs_alloc routines.
  * This is turned into a structure to avoid having 20 arguments passed
@@ -241,4 +239,6 @@ int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 
+xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
+
 #endif	/* __XFS_ALLOC_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
