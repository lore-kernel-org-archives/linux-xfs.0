Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C45207F55
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 05:32:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1375304051
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 03:32:57 -0800 (PST)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id 32gbp7oRHLiZhkKf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 03:32:56 -0800 (PST)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Mon, 25 Nov 2013 04:32:56 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com
	(b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 2F4983E4003F
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 04:32:53 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08028.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with
	ESMTP id rAP9V4px34930844
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 10:31:04 +0100
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP
	id rAPBWqAQ009790
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 04:32:53 -0700
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [RFC PATCH 4/4] xfs: allow linkat() on O_TMPFILE files
Date: Mon, 25 Nov 2013 19:32:34 +0800
Message-Id: <1385379154-3802-5-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
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

Enable O_TMPFILE support in linkat().

http://oss.sgi.com/archives/xfs/2013-08/msg00341.html

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_inode.c      |   23 +++++++++++++++++++++--
 fs/xfs/xfs_trans_resv.c |   13 +++++++++++++
 fs/xfs/xfs_trans_resv.h |    2 ++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e1832de..7ab029b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -62,6 +62,8 @@ kmem_zone_t *xfs_inode_zone;
 
 STATIC int xfs_iflush_int(xfs_inode_t *, xfs_buf_t *);
 
+STATIC int xfs_iunlink_remove(xfs_trans_t *, xfs_inode_t *);
+
 /*
  * helper function to extract extent size hint from inode
  */
@@ -1119,7 +1121,9 @@ xfs_bumplink(
 {
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	ASSERT(ip->i_d.di_nlink > 0);
+	if ((VFS_I(ip)->i_nlink == 0) &&
+	    !(VFS_I(ip)->i_state & I_LINKABLE))
+		ASSERT(ip->i_d.di_nlink > 0);
 	ip->i_d.di_nlink++;
 	inc_nlink(VFS_I(ip));
 	if ((ip->i_d.di_version == 1) &&
@@ -1473,6 +1477,7 @@ xfs_link(
 {
 	xfs_mount_t		*mp = tdp->i_mount;
 	xfs_trans_t		*tp;
+	struct xfs_trans_res	*tres;
 	int			error;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
@@ -1498,7 +1503,14 @@ xfs_link(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_LINK);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, resblks, 0);
+
+	if ((VFS_I(sip)->i_nlink == 0) &&
+	    (VFS_I(sip)->i_state & I_LINKABLE))
+		tres = &M_RES(mp)->tr_link_tmpfile;
+	else
+		tres = &M_RES(mp)->tr_link;
+
+	error = xfs_trans_reserve(tp, tres, resblks, 0);
 	if (error == ENOSPC) {
 		resblks = 0;
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, 0, 0);
@@ -1530,6 +1542,13 @@ xfs_link(
 
 	xfs_bmap_init(&free_list, &first_block);
 
+	if ((VFS_I(sip)->i_nlink == 0) &&
+	    (VFS_I(sip)->i_state & I_LINKABLE)) {
+		error = xfs_iunlink_remove(tp, sip);
+		if (error)
+			goto abort_return;
+	}
+
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
 					&first_block, &free_list, resblks);
 	if (error)
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index f1eebe4..7c1234e 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -228,6 +228,15 @@ xfs_calc_link_reservation(
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
+STATIC uint
+xfs_calc_link_tmpfile_reservation(
+	struct xfs_mount        *mp)
+{
+	return xfs_calc_link_reservation(mp) +
+		xfs_calc_buf_res(2, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
+}
+
 /*
  * For removing a directory entry we can modify:
  *    the parent directory inode: inode size
@@ -747,6 +756,10 @@ xfs_trans_resv_calc(
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
