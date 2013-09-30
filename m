Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4CFD27F85
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3ED13304032
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:55 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	joLvF1hHvbn4Jtib for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:53 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxa-0006Pi-EW
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxa-0002HV-Du
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 31/32] xfs: support larger inode clusters on v5 filesystems
Date: Mon, 30 Sep 2013 13:15:43 +1000
Message-Id: <1380510944-8571-32-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

To allow the kernel to use larger inode clusters than the standard
8192 bytes, we need to set the inode alignment fields appropriately
so that the kernel is consistent in it's inode to buffer mappings.
We set the alignment to allow a constant 32 inodes per cluster,
instead of a fixed 8k cluster size.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h |  2 +-
 mkfs/xfs_mkfs.c  |  5 ++++-
 repair/sb.c      | 41 ++++++++++++++++++++++++++++-------------
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 049b217..9d7c579 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -182,7 +182,7 @@ typedef struct xfs_mount {
 	__uint8_t		m_sectbb_log;	/* sectorlog - BBSHIFT */
 	__uint8_t		m_agno_log;	/* log #ag's */
 	__uint8_t		m_agino_log;	/* #bits for agino in inum */
-	__uint16_t		m_inode_cluster_size;/* min inode buf size */
+	uint			m_inode_cluster_size;/* min inode buf size */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 60e4d88..feb5bd0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2501,7 +2501,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	} else
 		sbp->sb_logsunit = 0;
 	if (iaflag) {
-		sbp->sb_inoalignmt = XFS_INODE_BIG_CLUSTER_SIZE >> blocklog;
+		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
+		if (crcs_enabled)
+			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
+		sbp->sb_inoalignmt = cluster_size >> blocklog;
 		iaflag = sbp->sb_inoalignmt != 0;
 	} else
 		sbp->sb_inoalignmt = 0;
diff --git a/repair/sb.c b/repair/sb.c
index e2f5933..86404ce 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -169,17 +169,37 @@ find_secondary_sb(xfs_sb_t *rsb)
 }
 
 /*
- * calculate what inode alignment field ought to be
- * based on internal superblock info
+ * Calculate what inode alignment field ought to be
+ * based on internal superblock info and determine if it is valid.
+ *
+ * For v5 superblocks, the inode alignment will either match that of the
+ * standard XFS_INODE_BIG_CLUSTER_SIZE, or it will be scaled based on the inode
+ * size. Either value is valid in this case.
+ *
+ * Return true if the alignment is valid, false otherwise.
  */
-static int
-calc_ino_align(xfs_sb_t *sb)
+static bool
+sb_validate_ino_align(struct xfs_sb *sb)
 {
-	xfs_extlen_t align;
+	xfs_extlen_t	align;
 
+	if (!xfs_sb_version_hasalign(sb))
+		return true;
+
+	/* standard cluster size alignment is always valid */
 	align = XFS_INODE_BIG_CLUSTER_SIZE >> sb->sb_blocklog;
+	if (align == sb->sb_inoalignmt)
+		return true;
+
+	/* alignment scaled by inode size is v5 only for now */
+	if (!xfs_sb_version_hascrc(sb))
+		return false;
 
-	return(align);
+	align *= sb->sb_inodesize / XFS_DINODE_MIN_SIZE;
+	if (align == sb->sb_inoalignmt)
+		return true;
+
+	return false;
 }
 
 /*
@@ -228,7 +248,6 @@ int
 verify_sb(xfs_sb_t *sb, int is_primary_sb)
 {
 	__uint32_t	bsize;
-	xfs_extlen_t	align;
 	int		i;
 
 	/* check magic number and version number */
@@ -364,12 +383,8 @@ verify_sb(xfs_sb_t *sb, int is_primary_sb)
 	/*
 	 * verify correctness of inode alignment if it's there
 	 */
-	if (xfs_sb_version_hasalign(sb))  {
-		align = calc_ino_align(sb);
-
-		if (align != sb->sb_inoalignmt)
-			return(XR_BAD_INO_ALIGN);
-	}
+	if (!sb_validate_ino_align(sb))
+		return(XR_BAD_INO_ALIGN);
 
 	/*
 	 * verify max. % of inodes (sb_imax_pct)
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
