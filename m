Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C366811C
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:03:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C74E2AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:30 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Xs5phyovPFASq0dx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:29 -0800 (PST)
Subject: [PATCH 63/76] xfs: cancel pending CoW reservations when destroying
	inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:03:26 -0800
Message-ID: <20151219090326.12713.34447.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

When destroying the inode, cancel all pending reservations in the CoW
fork so that all the reserved blocks go back to the free pile.  Also
free the reservations whenever we truncate or punch the entire file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    1 +
 fs/xfs/xfs_inode.c     |    5 +++-
 fs/xfs/xfs_reflink.c   |   64 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h   |    1 +
 fs/xfs/xfs_super.c     |   10 ++++++++
 5 files changed, 80 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index dd5a2f7..3e274f6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1393,6 +1393,7 @@ xfs_free_file_space(
 		 * Clear the reflink flag if we freed everything.
 		 */
 		if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
+			xfs_reflink_cancel_pending_cow(ip);
 			ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a323631..59964c3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -48,6 +48,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_reflink.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -1615,8 +1616,10 @@ xfs_itruncate_extents(
 	/*
 	 * Clear the reflink flag if we truncated everything.
 	 */
-	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip))
+	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
+		xfs_reflink_cancel_pending_cow(ip);
 		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+	}
 
 	/*
 	 * Always re-log the inode so that our permanent transaction can keep
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 8594bc4..dcc71b9 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -658,3 +658,67 @@ out:
 	trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
 	return error;
 }
+
+/**
+ * xfs_reflink_cancel_pending_cow() -- Cancel all pending CoW fork reservations.
+ * @ip: The XFS inode.
+ */
+int
+xfs_reflink_cancel_pending_cow(
+	struct xfs_inode	*ip)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_ifork	*ifp;
+	xfs_extnum_t		idx;
+	struct xfs_bmbt_rec_host	*gotp;
+	int			error;
+
+	/*
+	 * If this isn't a reflink inode there had better not be anything
+	 * in the CoW fork!
+	 */
+	if (!xfs_is_reflink_inode(ip)) {
+		ASSERT(ip->i_cowfp == NULL || ip->i_cowfp->if_bytes == 0);
+		return 0;
+	}
+
+	trace_xfs_reflink_cancel_pending_cow(ip);
+
+	ASSERT(ip->i_cowfp != NULL);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	/* Go find the old extent in the CoW fork. */
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	gotp = xfs_iext_bno_to_ext(ifp, 0, &idx);
+	while (gotp) {
+		xfs_bmbt_get_all(gotp, &irec);
+
+		/*
+		 * We should never be asked to cancel allocated CoW extents
+		 * unless the FS is broken, because doing so prevents the
+		 * block remapping after the write finishes.
+		 */
+		ASSERT(isnullstartblock(irec.br_startblock) ||
+		       XFS_FORCED_SHUTDOWN(ip->i_mount));
+		if (!isnullstartblock(irec.br_startblock))
+			goto advloop;
+
+		trace_xfs_reflink_cancel_cow(ip, &irec);
+
+		/* Give the blocks back. */
+		xfs_mod_fdblocks(ip->i_mount, irec.br_blockcount, false);
+		ip->i_delayed_blks -= irec.br_blockcount;
+		error = xfs_bunmapi_cow(ip, &idx, &irec);
+		if (error)
+			break;
+
+		/* Roll on... */
+advloop:
+		idx++;
+		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+			break;
+		gotp = xfs_iext_get_ext(ifp, idx);
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 2d2832b..cf4b43b 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -32,6 +32,7 @@ extern int xfs_reflink_end_cow_failed(struct xfs_inode *ip, xfs_off_t offset,
 		size_t count);
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		size_t count);
+extern int xfs_reflink_cancel_pending_cow(struct xfs_inode *ip);
 
 int	xfs_map_cow_blocks(struct inode *inode, xfs_off_t offset,
 			   struct xfs_bmbt_irec	*imap);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 85e582d..36df40b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -45,6 +45,7 @@
 #include "xfs_filestream.h"
 #include "xfs_quota.h"
 #include "xfs_sysfs.h"
+#include "xfs_reflink.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -920,11 +921,20 @@ xfs_fs_destroy_inode(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
+	int			error;
 
 	trace_xfs_destroy_inode(ip);
 
 	XFS_STATS_INC(ip->i_mount, vn_reclaim);
 
+	/* Cancel the CoW reservations. */
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = xfs_reflink_cancel_pending_cow(ip);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		xfs_warn(ip->i_mount, "Error %d destroying inode %llu.\n",
+				error, ip->i_ino);
+
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
