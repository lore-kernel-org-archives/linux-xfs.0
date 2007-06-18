Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 12:47:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5IJkvdu002574
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 12:47:13 -0700
Date: Mon, 18 Jun 2007 11:53:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 2 of 3] Multi-File Data Streams V3 - quota inode avoidance
Message-ID: <20070618015344.GX86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


The quota inodes should have no parent inode. If we have a
fake parent inode we then and up with reference counting
issues due to filestreams associations to non-existent inodes.

---
 fs/xfs/quota/xfs_qm.c |    3 +--
 fs/xfs/xfs_inode.c    |   13 +++++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_qm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_qm.c	2007-06-18 10:43:41.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_qm.c	2007-06-18 10:44:59.388520480 +1000
@@ -65,7 +65,6 @@ kmem_zone_t	*qm_dqtrxzone;
 static struct shrinker *xfs_qm_shaker;
 
 static cred_t	xfs_zerocr;
-static xfs_inode_t	xfs_zeroino;
 
 STATIC void	xfs_qm_list_init(xfs_dqlist_t *, char *, int);
 STATIC void	xfs_qm_list_destroy(xfs_dqlist_t *);
@@ -1415,7 +1414,7 @@ xfs_qm_qino_alloc(
 		return error;
 	}
 
-	if ((error = xfs_dir_ialloc(&tp, &xfs_zeroino, S_IFREG, 1, 0,
+	if ((error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
 				   &xfs_zerocr, 0, 1, ip, &committed))) {
 		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
 				 XFS_TRANS_ABORT);
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-06-18 10:40:22.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-06-18 10:58:42.521950934 +1000
@@ -1077,6 +1077,11 @@ xfs_iread_extents(
  * also returns the [locked] bp pointing to the head of the freelist
  * as ialloc_context.  The caller should hold this buffer across
  * the commit and pass it back into this routine on the second call.
+ *
+ * If we are allocating quota inodes, we do not have a parent inode
+ * to attach to or associate with (i.e. pip == NULL) because they
+ * are not linked into the directory structure - they are attached
+ * directly to the superblock - and so have no parent.
  */
 int
 xfs_ialloc(
@@ -1102,7 +1107,7 @@ xfs_ialloc(
 	 * Call the space management code to pick
 	 * the on-disk inode to be allocated.
 	 */
-	error = xfs_dialloc(tp, pip->i_ino, mode, okalloc,
+	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode, okalloc,
 			    ialloc_context, call_again, &ino);
 	if (error != 0) {
 		return error;
@@ -1156,7 +1161,7 @@ xfs_ialloc(
 	if ((prid != 0) && (ip->i_d.di_version == XFS_DINODE_VERSION_1))
 		xfs_bump_ino_vers2(tp, ip);
 
-	if (XFS_INHERIT_GID(pip, vp->v_vfsp)) {
+	if (pip && XFS_INHERIT_GID(pip, vp->v_vfsp)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((pip->i_d.di_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR) {
 			ip->i_d.di_mode |= S_ISGID;
@@ -1198,7 +1203,7 @@ xfs_ialloc(
 		flags |= XFS_ILOG_DEV;
 		break;
 	case S_IFREG:
-		if (xfs_inode_is_filestream(pip)) {
+		if (pip && xfs_inode_is_filestream(pip)) {
 			error = xfs_filestream_associate(pip, ip);
 			if (error)
 				return error;
@@ -1206,7 +1211,7 @@ xfs_ialloc(
 		}
 		/* fall through */
 	case S_IFDIR:
-		if (pip->i_d.di_flags & XFS_DIFLAG_ANY) {
+		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
 			uint	di_flags = 0;
 
 			if ((mode & S_IFMT) == S_IFDIR) {
