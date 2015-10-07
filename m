Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A93CF29E6E
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:06:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45EB1AC006
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:06:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id DSxuAhV4tOLnvxcZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:06:39 -0700 (PDT)
Subject: [PATCH 13/51] libxfs: propagate a bunch of case changes to mkfs and
	repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:06:37 -0700
Message-ID: <20151007050637.1504.40088.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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
index 4931198..afa9885 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1351,24 +1351,12 @@ typedef __be32 xfs_rmap_ptr_t;
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
index d993fc0..b326116 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2438,7 +2438,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	/*
 	 * sb_versionnum and finobt flags must be set before we use
-	 * XFS_PREALLOC_BLOCKS().
+	 * xfs_prealloc_blocks().
 	 */
 	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
 					attrversion == 2, !projid16bit, 0,
@@ -2467,12 +2467,12 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
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
@@ -2489,7 +2489,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		} else
 			logagno = (xfs_agnumber_t)(agcount / 2);
 
-		logstart = XFS_AGB_TO_FSB(mp, logagno, XFS_PREALLOC_BLOCKS(mp));
+		logstart = XFS_AGB_TO_FSB(mp, logagno, xfs_prealloc_blocks(mp));
 		/*
 		 * Align the logstart at stripe unit boundary.
 		 */
@@ -2573,7 +2573,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_imax_pct = imaxpct;
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
-	sbp->sb_fdblocks = dblocks - agcount * XFS_PREALLOC_BLOCKS(mp) -
+	sbp->sb_fdblocks = dblocks - agcount * xfs_prealloc_blocks(mp) -
 		(loginternal ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
 	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
@@ -2724,7 +2724,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
-		nbmblocks = (xfs_extlen_t)(agsize - XFS_PREALLOC_BLOCKS(mp));
+		nbmblocks = (xfs_extlen_t)(agsize - xfs_prealloc_blocks(mp));
 		agf->agf_freeblks = cpu_to_be32(nbmblocks);
 		agf->agf_longest = cpu_to_be32(nbmblocks);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
@@ -2805,7 +2805,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
+		arec->ar_startblock = cpu_to_be32(xfs_prealloc_blocks(mp));
 		if (loginternal && agno == logagno) {
 			if (lalign) {
 				/*
@@ -2860,7 +2860,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
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
