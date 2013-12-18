Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB36329E17
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 18:16:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6AE4304048
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 16:16:11 -0800 (PST)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id Oiksz8MU6Qyh4t4s (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Dec 2013 16:16:10 -0800 (PST)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Tue, 17 Dec 2013 17:16:09 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com
	(b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 603BD3E40026
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 17:16:06 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08025.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with
	ESMTP id rBI0G6qN7405898
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 01:16:06 +0100
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP
	id rBI0G546011918
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 17:16:06 -0700
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [PATCH v2 3/3] xfs: allow linkat() on O_TMPFILE files
Date: Wed, 18 Dec 2013 08:15:45 +0800
Message-Id: <1387325745-22003-4-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1387325745-22003-1-git-send-email-zwu.kernel@gmail.com>
References: <1387325745-22003-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

The VFS allows an anonymous temporary file to be named at a later
time via a linkat() syscall. The inodes for O_TMPFILE files are
are marked with a special flag I_LINKABLE and have a zero link count.

To support this in XFS, xfs_link() detects if this flag I_LINKABLE
is set and behaves appropriately when detected. So in this case,
its transaciton reservation takes into account the additional
overhead of removing the inode from the unlinked list. Then the
inode is removed from the unlinked list and the directory entry
is added. Finally its link count is bumped accordingly.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_inode.c      |   10 +++++++++-
 fs/xfs/xfs_trans_resv.c |   19 +++++++++++++++++--
 fs/xfs/xfs_trans_resv.h |    1 +
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ac133ea..b08b5a8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -61,6 +61,8 @@ kmem_zone_t *xfs_inode_zone;
 
 STATIC int xfs_iflush_int(xfs_inode_t *, xfs_buf_t *);
 
+STATIC int xfs_iunlink_remove(xfs_trans_t *, xfs_inode_t *);
+
 /*
  * helper function to extract extent size hint from inode
  */
@@ -1118,7 +1120,7 @@ xfs_bumplink(
 {
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	ASSERT(ip->i_d.di_nlink > 0);
+	ASSERT(ip->i_d.di_nlink > 0 || (VFS_I(ip)->i_state & I_LINKABLE));
 	ip->i_d.di_nlink++;
 	inc_nlink(VFS_I(ip));
 	if ((ip->i_d.di_version == 1) &&
@@ -1504,6 +1506,12 @@ xfs_link(
 
 	xfs_bmap_init(&free_list, &first_block);
 
+	if (sip->i_d.di_nlink == 0) {
+		error = xfs_iunlink_remove(tp, sip);
+		if (error)
+			goto abort_return;
+	}
+
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
 					&first_block, &free_list, resblks);
 	if (error)
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index bd3b4b7..76f9a02 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -204,6 +204,20 @@ xfs_calc_rename_reservation(
 }
 
 /*
+ * For removing an inode from unlinked list at first, we can modify:
+ *    the agi hash list and counters: sector size
+ *    the on disk inode before ours in the agi hash list: inode cluster size
+ */
+STATIC uint
+xfs_calc_iunlink_remove_reservation(
+	struct xfs_mount        *mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
+			(__uint16_t)XFS_INODE_CLUSTER_SIZE(mp));
+}
+
+/*
  * For creating a link to an inode:
  *    the parent directory inode: inode size
  *    the linked inode: inode size
@@ -220,6 +234,7 @@ xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
+		xfs_calc_iunlink_remove_reservation(mp) +
 		MAX((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
@@ -410,9 +425,9 @@ xfs_calc_ifree_reservation(
 {
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_inode_res(mp, 1) +
-		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
-		max_t(uint, XFS_FSB_TO_B(mp, 1), XFS_INODE_CLUSTER_SIZE(mp)) +
+		xfs_calc_iunlink_remove_reservation(mp) +
 		xfs_calc_buf_res(1, 0) +
 		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
 				 mp->m_in_maxlevels, 0) +
diff --git a/fs/xfs/xfs_trans_resv.h b/fs/xfs/xfs_trans_resv.h
index 285621d..899e2ef 100644
--- a/fs/xfs/xfs_trans_resv.h
+++ b/fs/xfs/xfs_trans_resv.h
@@ -106,6 +106,7 @@ struct xfs_trans_resv {
 #define	XFS_SYMLINK_LOG_COUNT		3
 #define	XFS_REMOVE_LOG_COUNT		2
 #define	XFS_LINK_LOG_COUNT		2
+#define	XFS_LINK_TMPFILE_LOG_COUNT	2
 #define	XFS_RENAME_LOG_COUNT		2
 #define	XFS_WRITE_LOG_COUNT		2
 #define	XFS_ADDAFORK_LOG_COUNT		2
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
