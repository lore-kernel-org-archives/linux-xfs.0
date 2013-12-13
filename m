Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 536E729E1F
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 08:29:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 481BD304077
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 06:29:27 -0800 (PST)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id sDgnuZ8SQ5SUereM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 06:28:57 -0800 (PST)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Fri, 13 Dec 2013 09:28:25 -0500
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com
	[9.57.198.27])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id C21EA38C8045
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:28:20 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23032.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	rBDESMNY42467424 for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 14:28:22 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	rBDESMkN006623 for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:28:22 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [PATCH 5/5] xfs: allow linkat() on O_TMPFILE files
Date: Fri, 13 Dec 2013 22:27:53 +0800
Message-Id: <1386944873-16796-6-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Enable O_TMPFILE support in linkat().
For more info, please refer to:
  http://oss.sgi.com/archives/xfs/2013-08/msg00341.html

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_inode.c      |   21 ++++++++++++++++++---
 fs/xfs/xfs_trans_resv.c |   20 ++++++++++++++++++++
 fs/xfs/xfs_trans_resv.h |    2 ++
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 48e09c5..2e1fd96 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -62,6 +62,8 @@ kmem_zone_t *xfs_inode_zone;
 
 STATIC int xfs_iflush_int(xfs_inode_t *, xfs_buf_t *);
 
+STATIC int xfs_iunlink_remove(xfs_trans_t *, xfs_inode_t *);
+
 /*
  * helper function to extract extent size hint from inode
  */
@@ -1119,7 +1121,7 @@ xfs_bumplink(
 {
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	ASSERT(ip->i_d.di_nlink > 0);
+	ASSERT(ip->i_d.di_nlink > 0 || (VFS_I(ip)->i_state & I_LINKABLE));
 	ip->i_d.di_nlink++;
 	inc_nlink(VFS_I(ip));
 	if ((ip->i_d.di_version == 1) &&
@@ -1455,6 +1457,7 @@ xfs_link(
 {
 	xfs_mount_t		*mp = tdp->i_mount;
 	xfs_trans_t		*tp;
+	struct xfs_trans_res	*tres;
 	int			error;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
@@ -1480,10 +1483,16 @@ xfs_link(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_LINK);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, resblks, 0);
+
+	if (sip->i_d.di_nlink == 0)
+		tres = &M_RES(mp)->tr_link_tmpfile;
+	else
+		tres = &M_RES(mp)->tr_link;
+
+	error = xfs_trans_reserve(tp, tres, resblks, 0);
 	if (error == ENOSPC) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, 0, 0);
+		error = xfs_trans_reserve(tp, tres, 0, 0);
 	}
 	if (error) {
 		cancel_flags = 0;
@@ -1512,6 +1521,12 @@ xfs_link(
 
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
index 04519a9..f2da7f4 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -228,6 +228,22 @@ xfs_calc_link_reservation(
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
+/* For creating a link to an O_TMPFILE inode, except modifying
+ * those metadata for regular inode, we still need to remove an inode
+ * from unlinked list at first. That is,  we can modify:
+ *    the agi hash list and counters: sector size
+ *    the on disk inode before ours in the agi hash list: inode cluster size
+ */
+STATIC uint
+xfs_calc_link_tmpfile_reservation(
+	struct xfs_mount        *mp)
+{
+	return xfs_calc_link_reservation(mp) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
+		    (__uint16_t)XFS_INODE_CLUSTER_SIZE(mp));
+}
+
 /*
  * For removing a directory entry we can modify:
  *    the parent directory inode: inode size
@@ -743,6 +759,10 @@ xfs_trans_resv_calc(
 	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
 	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_link_tmpfile.tr_logres = xfs_calc_link_tmpfile_reservation(mp);
+	resp->tr_link_tmpfile.tr_logcount = XFS_LINK_TMPFILE_LOG_COUNT;
+	resp->tr_link_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
 	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
 	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
diff --git a/fs/xfs/xfs_trans_resv.h b/fs/xfs/xfs_trans_resv.h
index 285621d..86a0daf 100644
--- a/fs/xfs/xfs_trans_resv.h
+++ b/fs/xfs/xfs_trans_resv.h
@@ -35,6 +35,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_itruncate;	/* truncate trans */
 	struct xfs_trans_res	tr_rename;	/* rename trans */
 	struct xfs_trans_res	tr_link;	/* link trans */
+	struct xfs_trans_res	tr_link_tmpfile; /* link O_TMPFILE trans */
 	struct xfs_trans_res	tr_remove;	/* unlink trans */
 	struct xfs_trans_res	tr_symlink;	/* symlink trans */
 	struct xfs_trans_res	tr_create;	/* create trans */
@@ -106,6 +107,7 @@ struct xfs_trans_resv {
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
