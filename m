Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1500A7F5E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:29:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAB35304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:01 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3dZlk5SHvvHDjYNd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:28:58 -0700 (PDT)
Subject: [PATCH 102/119] xfs: garbage collect old cowextsz reservations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:28:50 -0700
Message-ID: <146612692996.12839.9621556119809112650.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Trim CoW reservations made on behalf of a cowextsz hint if they get too
old or we run low on quota, so long as we don't have dirty data awaiting
writeback or directio operations in progress.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    3 +
 fs/xfs/xfs_file.c      |    3 +
 fs/xfs/xfs_globals.c   |    5 +
 fs/xfs/xfs_icache.c    |  238 ++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_icache.h    |    7 +
 fs/xfs/xfs_inode.c     |    4 +
 fs/xfs/xfs_iomap.c     |    2 
 fs/xfs/xfs_linux.h     |    1 
 fs/xfs/xfs_mount.c     |    1 
 fs/xfs/xfs_mount.h     |    2 
 fs/xfs/xfs_reflink.c   |   35 +++++++
 fs/xfs/xfs_reflink.h   |    2 
 fs/xfs/xfs_super.c     |    1 
 fs/xfs/xfs_sysctl.c    |    9 ++
 fs/xfs/xfs_sysctl.h    |    1 
 fs/xfs/xfs_trace.h     |    5 +
 16 files changed, 287 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b0c2c6d5..584f276 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1222,6 +1222,7 @@ xfs_free_cow_space(
 	 */
 	if (ip->i_d.di_nblocks == 0) {
 		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+		xfs_inode_clear_cowblocks_tag(ip);
 		xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
 	}
 out:
@@ -1966,6 +1967,8 @@ xfs_swap_extents(
 		cowfp = ip->i_cowfp;
 		ip->i_cowfp = tip->i_cowfp;
 		tip->i_cowfp = cowfp;
+		xfs_inode_set_cowblocks_tag(ip);
+		xfs_inode_set_cowblocks_tag(tip);
 	}
 
 	xfs_trans_log_inode(tp, ip,  src_log_flags);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 618bd12..ad6a467 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -859,6 +859,9 @@ write_retry:
 		enospc = xfs_inode_free_quota_eofblocks(ip);
 		if (enospc)
 			goto write_retry;
+		enospc = xfs_inode_free_quota_cowblocks(ip);
+		if (enospc)
+			goto write_retry;
 	} else if (ret == -ENOSPC && !enospc) {
 		struct xfs_eofblocks eofb = {0};
 
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 4d41b24..f3f6aa9 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -21,8 +21,8 @@
 /*
  * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
  * other XFS code uses these values.  Times are measured in centisecs (i.e.
- * 100ths of a second) with the exception of eofb_timer, which is measured in
- * seconds.
+ * 100ths of a second) with the exception of eofb_timer and cowb_timer, which
+ * are measured in seconds.
  */
 xfs_param_t xfs_params = {
 			  /*	MIN		DFLT		MAX	*/
@@ -42,6 +42,7 @@ xfs_param_t xfs_params = {
 	.inherit_nodfrg	= {	0,		1,		1	},
 	.fstrm_timer	= {	1,		30*100,		3600*100},
 	.eofb_timer	= {	1,		300,		3600*24},
+	.cowb_timer	= {	1,		300,		3600*24},
 };
 
 struct xfs_globals xfs_globals = {
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 06f3b8c..884b570 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -33,6 +33,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
+#include "xfs_reflink.h"
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -792,6 +793,33 @@ xfs_eofblocks_worker(
 	xfs_queue_eofblocks(mp);
 }
 
+/*
+ * Background scanning to trim preallocated CoW space. This is queued
+ * based on the 'speculative_cow_prealloc_lifetime' tunable (5m by default).
+ * (We'll just piggyback on the post-EOF prealloc space workqueue.)
+ */
+STATIC void
+xfs_queue_cowblocks(
+	struct xfs_mount *mp)
+{
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_COWBLOCKS_TAG))
+		queue_delayed_work(mp->m_eofblocks_workqueue,
+				   &mp->m_cowblocks_work,
+				   msecs_to_jiffies(xfs_cowb_secs * 1000));
+	rcu_read_unlock();
+}
+
+void
+xfs_cowblocks_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+				struct xfs_mount, m_cowblocks_work);
+	xfs_icache_free_cowblocks(mp, NULL);
+	xfs_queue_cowblocks(mp);
+}
+
 int
 xfs_inode_ag_iterator(
 	struct xfs_mount	*mp,
@@ -1348,18 +1376,30 @@ xfs_inode_free_eofblocks(
 	return ret;
 }
 
-int
-xfs_icache_free_eofblocks(
+static int
+__xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_eofblocks	*eofb,
+	int			(*execute)(struct xfs_inode *ip, int flags,
+					   void *args),
+	int			tag)
 {
 	int flags = SYNC_TRYLOCK;
 
 	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))
 		flags = SYNC_WAIT;
 
-	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_eofblocks, flags,
-					 eofb, XFS_ICI_EOFBLOCKS_TAG);
+	return xfs_inode_ag_iterator_tag(mp, execute, flags,
+					 eofb, tag);
+}
+
+int
+xfs_icache_free_eofblocks(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	return __xfs_icache_free_eofblocks(mp, eofb, xfs_inode_free_eofblocks,
+			XFS_ICI_EOFBLOCKS_TAG);
 }
 
 /*
@@ -1368,9 +1408,11 @@ xfs_icache_free_eofblocks(
  * failure. We make a best effort by including each quota under low free space
  * conditions (less than 1% free space) in the scan.
  */
-int
-xfs_inode_free_quota_eofblocks(
-	struct xfs_inode *ip)
+static int
+__xfs_inode_free_quota_eofblocks(
+	struct xfs_inode	*ip,
+	int			(*execute)(struct xfs_mount *mp,
+					   struct xfs_eofblocks	*eofb))
 {
 	int scan = 0;
 	struct xfs_eofblocks eofb = {0};
@@ -1406,14 +1448,25 @@ xfs_inode_free_quota_eofblocks(
 	}
 
 	if (scan)
-		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+		execute(ip->i_mount, &eofb);
 
 	return scan;
 }
 
-void
-xfs_inode_set_eofblocks_tag(
-	xfs_inode_t	*ip)
+int
+xfs_inode_free_quota_eofblocks(
+	struct xfs_inode *ip)
+{
+	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_eofblocks);
+}
+
+static void
+__xfs_inode_set_eofblocks_tag(
+	xfs_inode_t	*ip,
+	void		(*execute)(struct xfs_mount *mp),
+	void		(*set_tp)(struct xfs_mount *mp, xfs_agnumber_t agno,
+				  int error, unsigned long caller_ip),
+	int		tag)
 {
 	struct xfs_mount *mp = ip->i_mount;
 	struct xfs_perag *pag;
@@ -1421,26 +1474,22 @@ xfs_inode_set_eofblocks_tag(
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
-	trace_xfs_inode_set_eofblocks_tag(ip);
 
-	tagged = radix_tree_tagged(&pag->pag_ici_root,
-				   XFS_ICI_EOFBLOCKS_TAG);
+	tagged = radix_tree_tagged(&pag->pag_ici_root, tag);
 	radix_tree_tag_set(&pag->pag_ici_root,
-			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
-			   XFS_ICI_EOFBLOCKS_TAG);
+			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino), tag);
 	if (!tagged) {
 		/* propagate the eofblocks tag up into the perag radix tree */
 		spin_lock(&ip->i_mount->m_perag_lock);
 		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
 				   XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				   XFS_ICI_EOFBLOCKS_TAG);
+				   tag);
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* kick off background trimming */
-		xfs_queue_eofblocks(ip->i_mount);
+		execute(ip->i_mount);
 
-		trace_xfs_perag_set_eofblocks(ip->i_mount, pag->pag_agno,
-					      -1, _RET_IP_);
+		set_tp(ip->i_mount, pag->pag_agno, -1, _RET_IP_);
 	}
 
 	spin_unlock(&pag->pag_ici_lock);
@@ -1448,31 +1497,162 @@ xfs_inode_set_eofblocks_tag(
 }
 
 void
-xfs_inode_clear_eofblocks_tag(
+xfs_inode_set_eofblocks_tag(
 	xfs_inode_t	*ip)
 {
+	trace_xfs_inode_set_eofblocks_tag(ip);
+	return __xfs_inode_set_eofblocks_tag(ip, xfs_queue_eofblocks,
+			trace_xfs_perag_set_eofblocks,
+			XFS_ICI_EOFBLOCKS_TAG);
+}
+
+static void
+__xfs_inode_clear_eofblocks_tag(
+	xfs_inode_t	*ip,
+	void		(*clear_tp)(struct xfs_mount *mp, xfs_agnumber_t agno,
+				    int error, unsigned long caller_ip),
+	int		tag)
+{
 	struct xfs_mount *mp = ip->i_mount;
 	struct xfs_perag *pag;
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
-	trace_xfs_inode_clear_eofblocks_tag(ip);
 
 	radix_tree_tag_clear(&pag->pag_ici_root,
-			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
-			     XFS_ICI_EOFBLOCKS_TAG);
-	if (!radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_EOFBLOCKS_TAG)) {
+			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino), tag);
+	if (!radix_tree_tagged(&pag->pag_ici_root, tag)) {
 		/* clear the eofblocks tag from the perag radix tree */
 		spin_lock(&ip->i_mount->m_perag_lock);
 		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
 				     XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				     XFS_ICI_EOFBLOCKS_TAG);
+				     tag);
 		spin_unlock(&ip->i_mount->m_perag_lock);
-		trace_xfs_perag_clear_eofblocks(ip->i_mount, pag->pag_agno,
-					       -1, _RET_IP_);
+		clear_tp(ip->i_mount, pag->pag_agno, -1, _RET_IP_);
 	}
 
 	spin_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
 }
 
+void
+xfs_inode_clear_eofblocks_tag(
+	xfs_inode_t	*ip)
+{
+	trace_xfs_inode_clear_eofblocks_tag(ip);
+	return __xfs_inode_clear_eofblocks_tag(ip,
+			trace_xfs_perag_clear_eofblocks, XFS_ICI_EOFBLOCKS_TAG);
+}
+
+/*
+ * Automatic CoW Reservation Freeing
+ *
+ * These functions automatically garbage collect leftover CoW reservations
+ * that were made on behalf of a cowextsize hint when we start to run out
+ * of quota or when the reservations sit around for too long.  If the file
+ * has dirty pages or is undergoing writeback, its CoW reservations will
+ * be retained.
+ *
+ * The actual garbage collection piggybacks off the same code that runs
+ * the speculative EOF preallocation garbage collector.
+ */
+STATIC int
+xfs_inode_free_cowblocks(
+	struct xfs_inode	*ip,
+	int			flags,
+	void			*args)
+{
+	int ret;
+	struct xfs_eofblocks *eofb = args;
+	bool need_iolock = true;
+	int match;
+
+	ASSERT(!eofb || (eofb && eofb->eof_scan_owner != 0));
+
+	if (!xfs_reflink_has_real_cow_blocks(ip)) {
+		trace_xfs_inode_free_cowblocks_invalid(ip);
+		xfs_inode_clear_cowblocks_tag(ip);
+		return 0;
+	}
+
+	/*
+	 * If the mapping is dirty or under writeback we cannot touch the
+	 * CoW fork.  Leave it alone if we're in the midst of a directio.
+	 */
+	if (mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
+	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
+	    atomic_read(&VFS_I(ip)->i_dio_count))
+		return 0;
+
+	if (eofb) {
+		if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
+			match = xfs_inode_match_id_union(ip, eofb);
+		else
+			match = xfs_inode_match_id(ip, eofb);
+		if (!match)
+			return 0;
+
+		/* skip the inode if the file size is too small */
+		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
+		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
+			return 0;
+
+		/*
+		 * A scan owner implies we already hold the iolock. Skip it in
+		 * xfs_free_eofblocks() to avoid deadlock. This also eliminates
+		 * the possibility of EAGAIN being returned.
+		 */
+		if (eofb->eof_scan_owner == ip->i_ino)
+			need_iolock = false;
+	}
+
+	/* Free the CoW blocks */
+	if (need_iolock) {
+		xfs_ilock(ip, XFS_IOLOCK_EXCL);
+		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+	}
+
+	ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
+
+	if (need_iolock) {
+		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	}
+
+	return ret;
+}
+
+int
+xfs_icache_free_cowblocks(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	return __xfs_icache_free_eofblocks(mp, eofb, xfs_inode_free_cowblocks,
+			XFS_ICI_COWBLOCKS_TAG);
+}
+
+int
+xfs_inode_free_quota_cowblocks(
+	struct xfs_inode *ip)
+{
+	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_cowblocks);
+}
+
+void
+xfs_inode_set_cowblocks_tag(
+	xfs_inode_t	*ip)
+{
+	trace_xfs_inode_set_eofblocks_tag(ip);
+	return __xfs_inode_set_eofblocks_tag(ip, xfs_queue_cowblocks,
+			trace_xfs_perag_set_eofblocks,
+			XFS_ICI_COWBLOCKS_TAG);
+}
+
+void
+xfs_inode_clear_cowblocks_tag(
+	xfs_inode_t	*ip)
+{
+	trace_xfs_inode_clear_eofblocks_tag(ip);
+	return __xfs_inode_clear_eofblocks_tag(ip,
+			trace_xfs_perag_clear_eofblocks, XFS_ICI_COWBLOCKS_TAG);
+}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 62f1f91..a22ac92 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -40,6 +40,7 @@ struct xfs_eofblocks {
 					   in xfs_inode_ag_iterator */
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
 #define XFS_ICI_EOFBLOCKS_TAG	1	/* inode has blocks beyond EOF */
+#define XFS_ICI_COWBLOCKS_TAG	2	/* inode can have cow blocks to gc */
 
 /*
  * Flags for xfs_iget()
@@ -69,6 +70,12 @@ int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
 int xfs_inode_free_quota_eofblocks(struct xfs_inode *ip);
 void xfs_eofblocks_worker(struct work_struct *);
 
+void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
+void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
+int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
+int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
+void xfs_cowblocks_worker(struct work_struct *);
+
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, int flags, void *args),
 	int flags, void *args);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 480e48a..fb9c2d7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1631,8 +1631,10 @@ xfs_itruncate_extents(
 	/*
 	 * Clear the reflink flag if we truncated everything.
 	 */
-	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip))
+	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
 		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+		xfs_inode_clear_cowblocks_tag(ip);
+	}
 
 	/*
 	 * Always re-log the inode so that our permanent transaction can keep
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3914f0f..58240b5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -668,6 +668,8 @@ retry:
 	 */
 	if (prealloc)
 		xfs_inode_set_eofblocks_tag(ip);
+	if (whichfork == XFS_COW_FORK && extsz > 0)
+		xfs_inode_set_cowblocks_tag(ip);
 
 	*ret_imap = imap[0];
 	return 0;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index a8192dc..f05e2cf5 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -116,6 +116,7 @@ typedef __u32			xfs_nlink_t;
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
 #define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
 #define xfs_eofb_secs		xfs_params.eofb_timer.val
+#define xfs_cowb_secs		xfs_params.cowb_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index db80832..e53853d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1015,6 +1015,7 @@ xfs_unmountfs(
 	int			error;
 
 	cancel_delayed_work_sync(&mp->m_eofblocks_work);
+	cancel_delayed_work_sync(&mp->m_cowblocks_work);
 
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a516a1f..6b06d24 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -158,6 +158,8 @@ typedef struct xfs_mount {
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct delayed_work	m_eofblocks_work; /* background eof blocks
 						     trimming */
+	struct delayed_work	m_cowblocks_work; /* background cow blocks
+						     trimming */
 	bool			m_update_sb;	/* sb needs update in mount */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f5195b7..9b14eb5 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1727,6 +1727,7 @@ next:
 	/* Clear the inode flag. */
 	trace_xfs_reflink_unset_inode_flag(ip);
 	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+	xfs_inode_clear_cowblocks_tag(ip);
 	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
@@ -1864,3 +1865,37 @@ xfs_reflink_check_flag_adjust(
 	}
 	return 0;
 }
+
+/*
+ * Does this inode have any real CoW reservations?
+ */
+bool
+xfs_reflink_has_real_cow_blocks(
+	struct xfs_inode		*ip)
+{
+	struct xfs_bmbt_irec		irec;
+	struct xfs_ifork		*ifp;
+	struct xfs_bmbt_rec_host	*gotp;
+	xfs_extnum_t			idx;
+
+	if (!xfs_is_reflink_inode(ip))
+		return false;
+
+	/* Go find the old extent in the CoW fork. */
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	gotp = xfs_iext_bno_to_ext(ifp, 0, &idx);
+	while (gotp) {
+		xfs_bmbt_get_all(gotp, &irec);
+
+		if (!isnullstartblock(irec.br_startblock))
+			return true;
+
+		/* Roll on... */
+		idx++;
+		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+			break;
+		gotp = xfs_iext_get_ext(ifp, idx);
+	}
+
+	return false;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 97e8705..12c2bc6 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -56,6 +56,8 @@ extern void xfs_reflink_get_lxflags(struct xfs_inode *ip, unsigned int *flags);
 extern int xfs_reflink_check_flag_adjust(struct xfs_inode *ip,
 		unsigned int *xflags);
 
+extern bool xfs_reflink_has_real_cow_blocks(struct xfs_inode *ip);
+
 /* xfs_aops.c */
 extern int xfs_map_cow_blocks(struct inode *inode, xfs_off_t offset,
 		struct xfs_bmbt_irec *imap);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 10a0f721..93d159a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1504,6 +1504,7 @@ xfs_fs_fill_super(
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
+	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 
 	mp->m_super = sb;
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index aed74d3..afe1f66 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -184,6 +184,15 @@ static struct ctl_table xfs_table[] = {
 		.extra1		= &xfs_params.eofb_timer.min,
 		.extra2		= &xfs_params.eofb_timer.max,
 	},
+	{
+		.procname	= "speculative_cow_prealloc_lifetime",
+		.data		= &xfs_params.cowb_timer.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.cowb_timer.min,
+		.extra2		= &xfs_params.cowb_timer.max,
+	},
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
 	{
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index ffef453..984a349 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -48,6 +48,7 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
 	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
 	xfs_sysctl_val_t eofb_timer;	/* Interval between eofb scan wakeups */
+	xfs_sysctl_val_t cowb_timer;	/* Interval between cowb scan wakeups */
 } xfs_param_t;
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fe4a5be..1d89f8f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -136,6 +136,8 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_eofblocks);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_eofblocks);
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_cowblocks);
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_cowblocks);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
@@ -687,6 +689,9 @@ DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
 DEFINE_INODE_EVENT(xfs_inode_set_eofblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_eofblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
+DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
+DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
+DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
 
 DEFINE_INODE_EVENT(xfs_filemap_fault);
 DEFINE_INODE_EVENT(xfs_filemap_pmd_fault);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
