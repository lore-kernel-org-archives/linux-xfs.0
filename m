Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 83A197F47
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 00:10:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 491278F804B
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 22:10:26 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2XjZSHjzYxlfD4z6 for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2016 22:10:21 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aJb68-0002OW-NQ
	for xfs@oss.sgi.com; Thu, 14 Jan 2016 17:09:28 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aJb68-0001VB-Mf
	for xfs@oss.sgi.com; Thu, 14 Jan 2016 17:09:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: use vfs inode nlink field everywhere
Date: Thu, 14 Jan 2016 17:09:22 +1100
Message-Id: <1452751765-4420-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1452751765-4420-1-git-send-email-david@fromorbit.com>
References: <1452751765-4420-1-git-send-email-david@fromorbit.com>
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

The Vfs tracks the inodenlink just like the xfs_icdinode. We can
remove the variable from the icdinode and use the vfs inode variable
everywhere, reducing the size of the xfs_icdinode by a further 4
bytes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  6 ++--
 fs/xfs/libxfs/xfs_inode_buf.h |  1 -
 fs/xfs/xfs_inode.c            | 73 ++++++++++++++++++++-----------------------
 fs/xfs/xfs_inode.h            |  2 --
 fs/xfs/xfs_inode_item.c       |  2 +-
 fs/xfs/xfs_iops.c             |  3 +-
 fs/xfs/xfs_itable.c           |  2 +-
 fs/xfs/xfs_log_recover.c      |  2 +-
 8 files changed, 41 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 8a1b460..0dcaa9a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -210,12 +210,12 @@ xfs_inode_from_disk(
 	 * minimum inode version format we support in the rest of the code.
 	 */
 	if (to->di_version == 1) {
-		to->di_nlink = be16_to_cpu(from->di_onlink);
+		set_nlink(inode, be16_to_cpu(from->di_onlink));
 		to->di_projid_lo = 0;
 		to->di_projid_hi = 0;
 		to->di_version = 2;
 	} else {
-		to->di_nlink = be32_to_cpu(from->di_nlink);
+		set_nlink(inode, be32_to_cpu(from->di_nlink));
 		to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
 		to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
 	}
@@ -275,7 +275,6 @@ xfs_inode_to_disk(
 	to->di_format = from->di_format;
 	to->di_uid = cpu_to_be32(from->di_uid);
 	to->di_gid = cpu_to_be32(from->di_gid);
-	to->di_nlink = cpu_to_be32(from->di_nlink);
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 
@@ -286,6 +285,7 @@ xfs_inode_to_disk(
 	to->di_mtime.t_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
 	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
 	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
+	to->di_nlink = cpu_to_be32(inode->i_nlink);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index feb04e6..774d71f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -34,7 +34,6 @@ struct xfs_icdinode {
 	__uint16_t	di_flushiter;	/* incremented on flush */
 	__uint32_t	di_uid;		/* owner's user id */
 	__uint32_t	di_gid;		/* owner's group id */
-	__uint32_t	di_nlink;	/* number of links to file */
 	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 914ec41..9ee766b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -58,7 +58,7 @@ kmem_zone_t *xfs_inode_zone;
 #define	XFS_ITRUNC_MAX_EXTENTS	2
 
 STATIC int xfs_iflush_int(xfs_inode_t *, xfs_buf_t *);
-
+STATIC int xfs_iunlink(xfs_trans_t *, xfs_inode_t *, bool);
 STATIC int xfs_iunlink_remove(xfs_trans_t *, xfs_inode_t *);
 
 /*
@@ -794,7 +794,7 @@ xfs_ialloc(
 		ip->i_d.di_version = 2;
 
 	ip->i_d.di_mode = mode;
-	ip->i_d.di_nlink = nlink;
+	set_nlink(inode, nlink);
 	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
 	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
 	xfs_set_projid(ip, prid);
@@ -1072,35 +1072,24 @@ xfs_dir_ialloc(
 }
 
 /*
- * Decrement the link count on an inode & log the change.
- * If this causes the link count to go to zero, initiate the
- * logging activity required to truncate a file.
+ * Decrement the link count on an inode & log the change.  If this causes the
+ * link count to go to zero, move the inode to AGI unlinked list so that it can
+ * be freed when the last active reference goes away via xfs_inactive().
  */
 int				/* error */
 xfs_droplink(
 	xfs_trans_t *tp,
 	xfs_inode_t *ip)
 {
-	int	error;
-
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	ASSERT (ip->i_d.di_nlink > 0);
-	ip->i_d.di_nlink--;
 	drop_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = 0;
-	if (ip->i_d.di_nlink == 0) {
-		/*
-		 * We're dropping the last link to this file.
-		 * Move the on-disk inode to the AGI unlinked list.
-		 * From xfs_inactive() we will pull the inode from
-		 * the list and free it.
-		 */
-		error = xfs_iunlink(tp, ip);
-	}
-	return error;
+	if (VFS_I(ip)->i_nlink)
+		return 0;
+
+	return xfs_iunlink(tp, ip, false);
 }
 
 /*
@@ -1114,8 +1103,6 @@ xfs_bumplink(
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	ASSERT(ip->i_d.di_version > 1);
-	ASSERT(ip->i_d.di_nlink > 0 || (VFS_I(ip)->i_state & I_LINKABLE));
-	ip->i_d.di_nlink++;
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	return 0;
@@ -1373,8 +1360,7 @@ xfs_create_tmpfile(
 	 */
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
-	ip->i_d.di_nlink--;
-	error = xfs_iunlink(tp, ip);
+	error = xfs_iunlink(tp, ip, true);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1472,7 +1458,10 @@ xfs_link(
 
 	xfs_bmap_init(&free_list, &first_block);
 
-	if (sip->i_d.di_nlink == 0) {
+	/*
+	 * Handle initial link state of O_TMPFILE inode
+	 */
+	if (VFS_I(sip)->i_nlink == 0) {
 		error = xfs_iunlink_remove(tp, sip);
 		if (error)
 			goto error_return;
@@ -1659,7 +1648,7 @@ xfs_release(
 		}
 	}
 
-	if (ip->i_d.di_nlink == 0)
+	if (VFS_I(ip)->i_nlink == 0)
 		return 0;
 
 	if (xfs_can_free_eofblocks(ip, false)) {
@@ -1875,7 +1864,7 @@ xfs_inactive(
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return;
 
-	if (ip->i_d.di_nlink != 0) {
+	if (VFS_I(ip)->i_nlink != 0) {
 		/*
 		 * force is true because we are evicting an inode from the
 		 * cache. Post-eof blocks must be freed, lest we end up with
@@ -1932,14 +1921,20 @@ xfs_inactive(
 }
 
 /*
- * This is called when the inode's link count goes to 0.
- * We place the on-disk inode on a list in the AGI.  It
- * will be pulled from this list when the inode is freed.
+ * This is called when the inode's link count goes to 0 or we are creating a
+ * tmpfile via O_TMPFILE. In the case of a tmpfile, @ignore_linkcount will be
+ * set to true as the link count is dropped to zero by the VFS after we've
+ * created the file successfully, so we have to add it to the unlinked list
+ * while the link count is non-zero.
+ *
+ * We place the on-disk inode on a list in the AGI.  It will be pulled from this
+ * list when the inode is freed.
  */
-int
+STATIC int
 xfs_iunlink(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip)
+	struct xfs_trans *tp,
+	struct xfs_inode *ip,
+	bool		ignore_linkcount)
 {
 	xfs_mount_t	*mp;
 	xfs_agi_t	*agi;
@@ -1951,7 +1946,7 @@ xfs_iunlink(
 	int		offset;
 	int		error;
 
-	ASSERT(ip->i_d.di_nlink == 0);
+	ASSERT(VFS_I(ip)->i_nlink == 0 || ignore_linkcount);
 	ASSERT(ip->i_d.di_mode != 0);
 
 	mp = tp->t_mountp;
@@ -2392,7 +2387,7 @@ xfs_ifree(
 	struct xfs_icluster	xic = { 0 };
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(ip->i_d.di_nlink == 0);
+	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(ip->i_d.di_nextents == 0);
 	ASSERT(ip->i_d.di_anextents == 0);
 	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(ip->i_d.di_mode));
@@ -2560,8 +2555,8 @@ xfs_remove(
 	 * If we're removing a directory perform some additional validation.
 	 */
 	if (is_dir) {
-		ASSERT(ip->i_d.di_nlink >= 2);
-		if (ip->i_d.di_nlink != 2) {
+		ASSERT(VFS_I(ip)->i_nlink >= 2);
+		if (VFS_I(ip)->i_nlink != 2) {
 			error = -ENOTEMPTY;
 			goto out_trans_cancel;
 		}
@@ -3017,7 +3012,7 @@ xfs_rename(
 			 * Make sure target dir is empty.
 			 */
 			if (!(xfs_dir_isempty(target_ip)) ||
-			    (target_ip->i_d.di_nlink > 2)) {
+			    (VFS_I(target_ip)->i_nlink > 2)) {
 				error = -EEXIST;
 				goto out_trans_cancel;
 			}
@@ -3124,7 +3119,7 @@ xfs_rename(
 	 * intermediate state on disk.
 	 */
 	if (wip) {
-		ASSERT(VFS_I(wip)->i_nlink == 0 && wip->i_d.di_nlink == 0);
+		ASSERT(VFS_I(wip)->i_nlink == 0);
 		error = xfs_bumplink(tp, wip);
 		if (error)
 			goto out_bmap_cancel;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index aef5452..e74d13d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -405,8 +405,6 @@ int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
 			   struct xfs_bmap_free *);
 int		xfs_itruncate_extents(struct xfs_trans **, struct xfs_inode *,
 				      int, xfs_fsize_t);
-int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
-
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 
 void		xfs_iunpin_wait(xfs_inode_t *);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d777b7a..4e3611d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -338,7 +338,6 @@ xfs_inode_to_log_dinode(
 	to->di_format = from->di_format;
 	to->di_uid = from->di_uid;
 	to->di_gid = from->di_gid;
-	to->di_nlink = from->di_nlink;
 	to->di_projid_lo = from->di_projid_lo;
 	to->di_projid_hi = from->di_projid_hi;
 
@@ -350,6 +349,7 @@ xfs_inode_to_log_dinode(
 	to->di_mtime.t_nsec = inode->i_mtime.tv_nsec;
 	to->di_ctime.t_sec = inode->i_ctime.tv_sec;
 	to->di_ctime.t_nsec = inode->i_ctime.tv_nsec;
+	to->di_nlink = inode->i_nlink;
 
 	to->di_size = from->di_size;
 	to->di_nblocks = from->di_nblocks;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b008677..c424d4b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -455,7 +455,7 @@ xfs_vn_getattr(
 	stat->size = XFS_ISIZE(ip);
 	stat->dev = inode->i_sb->s_dev;
 	stat->mode = ip->i_d.di_mode;
-	stat->nlink = ip->i_d.di_nlink;
+	stat->nlink = inode->i_nlink;
 	stat->uid = inode->i_uid;
 	stat->gid = inode->i_gid;
 	stat->ino = ip->i_ino;
@@ -1212,7 +1212,6 @@ xfs_setup_inode(
 	hlist_add_fake(&inode->i_hash);
 
 	inode->i_mode	= ip->i_d.di_mode;
-	set_nlink(inode, ip->i_d.di_nlink);
 	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
 	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 2acda42..cfb6527 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -85,7 +85,6 @@ xfs_bulkstat_one_int(
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
-	buf->bs_nlink = dic->di_nlink;
 	buf->bs_projid_lo = dic->di_projid_lo;
 	buf->bs_projid_hi = dic->di_projid_hi;
 	buf->bs_ino = ino;
@@ -94,6 +93,7 @@ xfs_bulkstat_one_int(
 	buf->bs_gid = dic->di_gid;
 	buf->bs_size = dic->di_size;
 
+	buf->bs_nlink = inode->i_nlink;
 	buf->bs_atime.tv_sec = inode->i_atime.tv_sec;
 	buf->bs_atime.tv_nsec = inode->i_atime.tv_nsec;
 	buf->bs_mtime.tv_sec = inode->i_mtime.tv_sec;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4b79cf0..611c25c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4337,7 +4337,7 @@ xlog_recover_process_one_iunlink(
 	if (error)
 		goto fail_iput;
 
-	ASSERT(ip->i_d.di_nlink == 0);
+	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(ip->i_d.di_mode != 0);
 
 	/* setup for the next pass */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
