Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D76B81C5
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:06:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7DC9B304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:06:12 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id fyPvGIhMq80uvu2Y (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:06:10 -0800 (PST)
Subject: [PATCH 12/53] libxfs: propagate a bunch of case changes to mkfs and
	repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:06:07 -0800
Message-ID: <20151219090607.14255.58411.stgit@birch.djwong.org>
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

A few macros got replaced with functions, so update mkfs and repair
to use the new symbol names.  Fix a duplicate #define too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_format.h |   12 ------------
 mkfs/xfs_mkfs.c     |   16 ++++++++--------
 2 files changed, 8 insertions(+), 20 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 52b1d06..9a4f328 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1359,24 +1359,12 @@ typedef __be32 xfs_rmap_ptr_t;
 /*
  * block numbers in the AG.
  */
-#define	XFS_IBT_BLOCK(mp)		((xfs_agblock_t)(XFS_CNT_BLOCK(mp) + 1))
-#define	XFS_FIBT_BLOCK(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
 #define	XFS_RMAP_BLOCK(mp) \
 	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
 /*
- * The first data block of an AG depends on whether the filesystem was formatted
- * with the optional btree features. These need to be accounted for
- * appropriately.
- *
- * XXX: this should be calculated once at mount time and stored in the struct
- * xfs_mount rather than calculated every time it is used.
- */
-#define XFS_PREALLOC_BLOCKS(mp)	xfs_prealloc_blocks(mp)
-
-/*
  * BMAP Btree format definitions
  *
  * This includes both the root block definition that sits inside an inode fork
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7cba41a..934d7c0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2482,7 +2482,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	/*
 	 * sb_versionnum and finobt flags must be set before we use
-	 * XFS_PREALLOC_BLOCKS().
+	 * xfs_prealloc_blocks().
 	 */
 	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
 					attrversion == 2, !projid16bit, 0,
@@ -2511,12 +2511,12 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 */
 		if (!logsize) {
 			logblocks = MIN(logblocks,
-					XFS_ALLOC_AG_MAX_USABLE(mp));
+					xfs_alloc_ag_max_usable(mp));
 
 			/* revalidate the log size is valid if we changed it */
 			validate_log_size(logblocks, blocklog, min_logblocks);
 		}
-		if (logblocks > agsize - XFS_PREALLOC_BLOCKS(mp)) {
+		if (logblocks > agsize - xfs_prealloc_blocks(mp)) {
 			fprintf(stderr,
 	_("internal log size %lld too large, must fit in allocation group\n"),
 				(long long)logblocks);
@@ -2533,7 +2533,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		} else
 			logagno = (xfs_agnumber_t)(agcount / 2);
 
-		logstart = XFS_AGB_TO_FSB(mp, logagno, XFS_PREALLOC_BLOCKS(mp));
+		logstart = XFS_AGB_TO_FSB(mp, logagno, xfs_prealloc_blocks(mp));
 		/*
 		 * Align the logstart at stripe unit boundary.
 		 */
@@ -2616,7 +2616,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_imax_pct = imaxpct;
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
-	sbp->sb_fdblocks = dblocks - agcount * XFS_PREALLOC_BLOCKS(mp) -
+	sbp->sb_fdblocks = dblocks - agcount * xfs_prealloc_blocks(mp) -
 		(loginternal ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
 	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
@@ -2767,7 +2767,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
-		nbmblocks = (xfs_extlen_t)(agsize - XFS_PREALLOC_BLOCKS(mp));
+		nbmblocks = (xfs_extlen_t)(agsize - xfs_prealloc_blocks(mp));
 		agf->agf_freeblks = cpu_to_be32(nbmblocks);
 		agf->agf_longest = cpu_to_be32(nbmblocks);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
@@ -2848,7 +2848,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
+		arec->ar_startblock = cpu_to_be32(xfs_prealloc_blocks(mp));
 		if (loginternal && agno == logagno) {
 			if (lalign) {
 				/*
@@ -2903,7 +2903,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
+		arec->ar_startblock = cpu_to_be32(xfs_prealloc_blocks(mp));
 		if (loginternal && agno == logagno) {
 			if (lalign) {
 				arec->ar_blockcount = cpu_to_be32(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
