Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1B1C37F59
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 03:34:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE4438F8040
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 01:34:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mlzQKsS0JC0P1bLn for <xfs@oss.sgi.com>;
	Mon, 09 Sep 2013 01:34:30 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VIwvQ-0002GL-9A
	for xfs@oss.sgi.com; Mon, 09 Sep 2013 18:34:24 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VIwvQ-0005Cf-84
	for xfs@oss.sgi.com; Mon, 09 Sep 2013 18:34:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] [RFC] xfs: increase inode cluster size for v5 filesystems
Date: Mon,  9 Sep 2013 18:34:24 +1000
Message-Id: <1378715664-19969-1-git-send-email-david@fromorbit.com>
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

v5 filesystems use 512 byte inodes as a minimum, so read inodes in
clusters that are effectively half the size of a v4 filesystem with
256 byte inodes. For v5 fielsystems, scale the inode cluster size
with the size of the inode so that we keep a constant 32 inodes per
cluster ratio for all inode IO.

This only works if mkfs.xfs sets the inode alignment appropriately
for larger inode clusters, so this functionality is made conditional
on mkfs doing the right thing. xfs_repair needs to know about
the inode alignment changes, too.

FWIW, results with lookaside cache size of 37 entries with this
patch are (Note: finobt enabled on v5 filesystems, v4 using defaults
including 256 byte inode size):

Wall time:
	create	bulkstat	find+stat	ls -R	unlink
v4	237s	161s		173s		201s	299s
v5	235s	163s		205s		 31s	356s
patched	234s	160s		182s		 29s	317s

System time:
	create	bulkstat	find+stat	ls -R	unlink
v4	2601s	2490s		1653s		1656s	2960s
v5	2637s	2497s		1681s		  20s	3216s
patched	2613s	2451s		1658s		  20s	3007s

Lookaside cache hit rate:
	create	bulkstat	find+stat	ls -R	unlink
v4	0.73	0.91		0.71		0.70	0.71
v5	0.76	0.88		0.68		0.10	0.75
patched	0.81	0.93		0.70		0.08	0.84

So, wall time same or down across the board, system time same or
down across the board, and cache hit rates all improve except for
the ls -R case which is a pure cold cache directory read workload
on v5 filesystems...

So, this patch removes most of the performance and CPU usage
differential between v4 and v5 filesystems on traversal related
workloads.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c      | 14 ++++++++++++++
 fs/xfs/xfs_mount.h      |  2 +-
 fs/xfs/xfs_trans_resv.c |  3 +--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8ac98c7..788d666d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -722,8 +722,22 @@ xfs_mountfs(
 	 * Set the inode cluster size.
 	 * This may still be overridden by the file system
 	 * block size if it is larger than the chosen cluster size.
+	 *
+	 * For v5 filesystems, scale the cluster size with the inode size to
+	 * keep a constant ratio of inode per cluster buffer, but only if mkfs
+	 * has set the inode alignment value appropriately for larger cluster
+	 * sizes.
 	 */
 	mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		int	new_size = mp->m_inode_cluster_size;
+
+		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
+		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
+			mp->m_inode_cluster_size = new_size;
+		xfs_info(mp, "Using inode cluster size of %d bytes",
+			 mp->m_inode_cluster_size);
+	}
 
 	/*
 	 * Set inode alignment fields
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2a997dc..a4f7f94 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -111,7 +111,7 @@ typedef struct xfs_mount {
 	__uint8_t		m_blkbb_log;	/* blocklog - BBSHIFT */
 	__uint8_t		m_agno_log;	/* log #ag's */
 	__uint8_t		m_agino_log;	/* #bits for agino in inum */
-	__uint16_t		m_inode_cluster_size;/* min inode buf size */
+	uint			m_inode_cluster_size;/* min inode buf size */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index ae7a185..1494f62 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -403,8 +403,7 @@ xfs_calc_ifree_reservation(
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(2, XFS_FSB_TO_B(mp, 1)) +
-		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
-		    XFS_INODE_CLUSTER_SIZE(mp)) +
+		MAX(XFS_FSB_TO_B(mp, 1), XFS_INODE_CLUSTER_SIZE(mp)) +
 		xfs_calc_buf_res(1, 0) +
 		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
 				 mp->m_in_maxlevels, 0) +
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
