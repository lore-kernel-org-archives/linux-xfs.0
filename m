Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFF807F62
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 03:35:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A64D304051
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 01:35:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mGNuQk4a2m2Yrt7e for <xfs@oss.sgi.com>;
	Mon, 09 Sep 2013 01:34:58 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VIwvx-0002GP-2E
	for xfs@oss.sgi.com; Mon, 09 Sep 2013 18:34:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VIwvx-0005E7-16
	for xfs@oss.sgi.com; Mon, 09 Sep 2013 18:34:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] [RFC] xfs: support larger inode clusters on v5 filesystems
Date: Mon,  9 Sep 2013 18:34:57 +1000
Message-Id: <1378715697-20059-1-git-send-email-david@fromorbit.com>
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
 include/libxfs.h | 2 +-
 mkfs/xfs_mkfs.c  | 6 +++++-
 repair/sb.c      | 7 ++++---
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 90f9a75..a074e58 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -180,7 +180,7 @@ typedef struct xfs_mount {
 	__uint8_t		m_sectbb_log;	/* sectorlog - BBSHIFT */
 	__uint8_t		m_agno_log;	/* log #ag's */
 	__uint8_t		m_agino_log;	/* #bits for agino in inum */
-	__uint16_t		m_inode_cluster_size;/* min inode buf size */
+	uint			m_inode_cluster_size;/* min inode buf size */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 66d8833..36e6215 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2545,7 +2545,11 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	} else
 		sbp->sb_logsunit = 0;
 	if (iaflag) {
-		sbp->sb_inoalignmt = XFS_INODE_BIG_CLUSTER_SIZE >> blocklog;
+		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
+		if (crcs_enabled)
+			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
+		sbp->sb_inoalignmt = cluster_size >> blocklog;
+		printf("inoalignmt = %d (%d)\n", sbp->sb_inoalignmt, cluster_size);
 		iaflag = sbp->sb_inoalignmt != 0;
 	} else
 		sbp->sb_inoalignmt = 0;
diff --git a/repair/sb.c b/repair/sb.c
index e2f5933..a2231e4 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -175,11 +175,12 @@ find_secondary_sb(xfs_sb_t *rsb)
 static int
 calc_ino_align(xfs_sb_t *sb)
 {
-	xfs_extlen_t align;
+	xfs_extlen_t align = XFS_INODE_BIG_CLUSTER_SIZE;
 
-	align = XFS_INODE_BIG_CLUSTER_SIZE >> sb->sb_blocklog;
+	if (xfs_sb_version_hascrc(sb))
+		align *= sb->sb_inodesize / XFS_DINODE_MIN_SIZE;
 
-	return(align);
+	return align >> sb->sb_blocklog;
 }
 
 /*
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
