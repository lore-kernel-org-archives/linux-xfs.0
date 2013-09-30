Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D45557F53
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:07:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4ED4304039
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:07:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	kcMwFP4IFB0HAtZ1 for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:07:28 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTpO-0006Lx-Ts
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:19 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTpO-0002Ck-St
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/16] xfs: increase inode cluster size for v5 filesystems
Date: Mon, 30 Sep 2013 13:07:13 +1000
Message-Id: <1380510433-8353-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510433-8353-1-git-send-email-david@fromorbit.com>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
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

So, wall time same or down across the board, system time same or
down across the board, and cache hit rates all improve except for
the ls -R case which is a pure cold cache directory read workload
on v5 filesystems...

So, this patch removes most of the performance and CPU usage
differential between v4 and v5 filesystems on traversal related
workloads.

Note: while this patch is currently for v5 filesystems only, there
is no reason it can't be ported back to v4 filesystems.  This hasn't
been done here because bringing the code back to v4 requires
forwards and backwards kernel compatibility testing.  i.e. to
deterine if older kernels(*) do the right thing with larger inode
alignments but still only using 8k inode cluster sizes. None of this
testing and validation on v4 filesystems has been done, so for the
moment larger inode clusters is limited to v5 superblocks.

(*) a current default config v4 filesystem should mount just fine on
2.6.23 (when lazy-count support was introduced), and so if we change
the alignment emitted by mkfs without a feature bit then we have to
make sure it works properly on all kernels since 2.6.23. And if we
allow it to be changed when the lazy-count bit is not set, then it's
all kernels since v2 logs were introduced that need to be tested for
compatibility...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c      | 15 +++++++++++++++
 fs/xfs/xfs_mount.h      |  2 +-
 fs/xfs/xfs_trans_resv.c |  3 +--
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index da88f16..02df7b4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -41,6 +41,7 @@
 #include "xfs_fsops.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_dinode.h"
 
 
 #ifdef HAVE_PERCPU_SB
@@ -718,8 +719,22 @@ xfs_mountfs(
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
index 1d8101a..a466c5e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -112,7 +112,7 @@ typedef struct xfs_mount {
 	__uint8_t		m_blkbb_log;	/* blocklog - BBSHIFT */
 	__uint8_t		m_agno_log;	/* log #ag's */
 	__uint8_t		m_agino_log;	/* #bits for agino in inum */
-	__uint16_t		m_inode_cluster_size;/* min inode buf size */
+	uint			m_inode_cluster_size;/* min inode buf size */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index d53d9f0..2fd59c0 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -385,8 +385,7 @@ xfs_calc_ifree_reservation(
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
-		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
-		    XFS_INODE_CLUSTER_SIZE(mp)) +
+		max_t(uint, XFS_FSB_TO_B(mp, 1), XFS_INODE_CLUSTER_SIZE(mp)) +
 		xfs_calc_buf_res(1, 0) +
 		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
 				 mp->m_in_maxlevels, 0) +
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
