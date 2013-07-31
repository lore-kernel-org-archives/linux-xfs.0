Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88F6A7F6F
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 09:42:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B8A48F8037
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 07:42:23 -0700 (PDT)
Received: from mail-pb0-f48.google.com (mail-pb0-f48.google.com
	[209.85.160.48]) by cuda.sgi.com with ESMTP id VJSNnuGB0bMPpwXF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 31 Jul 2013 07:42:22 -0700 (PDT)
Received: by mail-pb0-f48.google.com with SMTP id ma3so846620pbc.7
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 07:42:21 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 2/3] xfs: Implement FALLOC_FL_COLLAPSE_RANGE
Date: Wed, 31 Jul 2013 23:42:14 +0900
Message-Id: <1375281734-15874-1-git-send-email-linkinjeon@gmail.com>
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
To: tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

New fallocate flag FALLOC_FL_COLLAPSE_RANGE implementation for XFS.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/xfs/xfs_bmap.c     |   92 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap.h     |    3 ++
 fs/xfs/xfs_file.c     |   26 ++++++++++++--
 fs/xfs/xfs_iops.c     |   35 +++++++++++++++++++
 fs/xfs/xfs_vnodeops.c |   62 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_vnodeops.h |    2 ++
 6 files changed, 217 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 05c698c..ae677b1 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -6145,3 +6145,95 @@ next_block:
 
 	return error;
 }
+
+/*
+ * xfs_update_logical()
+ *	Updates starting logical block of extents by subtracting
+ *	shift from them. At max XFS_LINEAR_EXTS number extents
+ *	will be updated and *current_ext is the extent number which
+ *	is currently being updated.
+ */
+int
+xfs_update_logical(
+	xfs_trans_t		*tp,
+	struct xfs_inode	*ip,
+	int			*done,
+	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		shift,
+	xfs_extnum_t		*current_ext)
+{
+	xfs_btree_cur_t		*cur;
+	xfs_bmbt_rec_host_t	*gotp;
+	xfs_mount_t		*mp;
+	xfs_ifork_t		*ifp;
+	xfs_extnum_t		nexts = 0;
+	xfs_fileoff_t		startoff;
+	int			error = 0;
+	int			i;
+
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	mp = ip->i_mount;
+
+	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
+		(error = xfs_iread_extents(tp, ip, XFS_DATA_FORK)))
+		return error;
+
+	if (!*current_ext) {
+		gotp = xfs_iext_bno_to_ext(ifp, start_fsb, current_ext);
+		/*
+		 * gotp can be null in 2 cases: 1) if there are no extents
+		 * or 2) start_fsb lies in a hole beyond which there are
+		 * no extents. Either way, we are done.
+		 */
+		if (!gotp) {
+			*done = 1;
+			return 0;
+		}
+	}
+
+	if (ifp->if_flags & XFS_IFBROOT)
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
+	else
+		cur = NULL;
+
+	while (nexts++ < XFS_LINEAR_EXTS &&
+	       *current_ext <  XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK)) {
+		gotp = xfs_iext_get_ext(ifp, (*current_ext)++);
+		startoff = xfs_bmbt_get_startoff(gotp);
+		if (cur) {
+			if ((error = xfs_bmbt_lookup_eq(cur,
+					startoff,
+					xfs_bmbt_get_startblock(gotp),
+					xfs_bmbt_get_blockcount(gotp),
+					&i)))
+				goto del_cursor;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+		}
+		startoff -= shift;
+		xfs_bmbt_set_startoff(gotp, startoff);
+		if (cur) {
+			error = xfs_bmbt_update(cur, startoff,
+						xfs_bmbt_get_startblock(gotp),
+						xfs_bmbt_get_blockcount(gotp),
+						xfs_bmbt_get_state(gotp));
+			if (error)
+				goto del_cursor;
+		}
+	}
+
+	/* Check if we are done */
+	if (*current_ext ==  XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK))
+		*done = 1;
+
+del_cursor:
+	if (cur) {
+		if (!error)
+			cur->bc_private.b.allocated = 0;
+		 xfs_btree_del_cursor(cur,
+				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	}
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE | XFS_ILOG_DEXT);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 1cf1292..f923734 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -204,6 +204,9 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
+int	xfs_update_logical(xfs_trans_t *tp, struct xfs_inode *ip, int *done,
+		xfs_fileoff_t start_fsb, xfs_fileoff_t shift,
+		xfs_extnum_t *current_ext);
 
 #ifdef __KERNEL__
 /* bmap to userspace formatter - copy to user & advance pointer */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index de3dc98..7d871bc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -817,7 +817,12 @@ xfs_file_fallocate(
 	int		cmd = XFS_IOC_RESVSP;
 	int		attr_flags = XFS_ATTR_NOLOCK;
 
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_COLLAPSE_RANGE))
+		return -EOPNOTSUPP;
+
+	/* not just yet for rt inodes */
+	if ((mode & FALLOC_FL_COLLAPSE_RANGE) && XFS_IS_REALTIME_INODE(ip))
 		return -EOPNOTSUPP;
 
 	bf.l_whence = 0;
@@ -826,11 +831,11 @@ xfs_file_fallocate(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
-	if (mode & FALLOC_FL_PUNCH_HOLE)
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE))
 		cmd = XFS_IOC_UNRESVSP;
 
 	/* check the new inode size is valid before allocating */
-	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	if (!(mode & (FALLOC_FL_KEEP_SIZE | FALLOC_FL_COLLAPSE_RANGE)) &&
 	    offset + len > i_size_read(inode)) {
 		new_size = offset + len;
 		error = inode_newsize_ok(inode, new_size);
@@ -845,6 +850,21 @@ xfs_file_fallocate(
 	if (error)
 		goto out_unlock;
 
+	if (mode & FALLOC_FL_COLLAPSE_RANGE) {
+		error = -xfs_collapse_file_space(ip, offset + len, len);
+		if (error || offset >= i_size_read(inode))
+			goto out_unlock;
+
+		/* Shrink size in case of FALLOC_FL_COLLAPSE_RANGE */
+		if ((offset + len) > i_size_read(inode))
+			new_size = offset;
+		else
+			new_size = i_size_read(inode) - len;
+		error = -xfs_update_file_size(ip, new_size);
+
+		goto out_unlock;
+	}
+
 	/* Change file size if needed */
 	if (new_size) {
 		struct iattr iattr;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 96dda62..16b20f1 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1236,3 +1236,38 @@ xfs_setup_inode(
 
 	unlock_new_inode(inode);
 }
+
+/*
+ * xfs_update_file_size()
+ *	Just a simple disk size and time update
+ */
+int
+xfs_update_file_size(
+	struct xfs_inode        *ip,
+	loff_t			newsize)
+{
+	xfs_mount_t		*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	struct xfs_trans	*tp;
+	int			error;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+
+	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (error)
+		return error;
+
+	xfs_trans_ijoin(tp, ip, 0);
+	truncate_setsize(inode, newsize);
+	ip->i_d.di_size = newsize;
+
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+
+	return xfs_trans_commit(tp, 0);
+
+}
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index dc730ac..95b46e7 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1868,3 +1868,65 @@ xfs_change_file_space(
 		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp, 0);
 }
+
+/*
+ * xfs_collapse_file_space()
+ *	This implements the fallocate collapse range functionlaity.
+ *	It removes the hole from file by shifting all the extents which
+ *	lies beyond start block.
+ */
+int
+xfs_collapse_file_space(
+	xfs_inode_t	*ip,
+	loff_t		start,
+	loff_t		shift)
+{
+	int		done = 0;
+	xfs_mount_t	*mp = ip->i_mount;
+	uint		resblks;
+	xfs_trans_t	*tp;
+	int		error = 0;
+	xfs_extnum_t	current_ext = 0;
+	xfs_fileoff_t	start_fsb = XFS_B_TO_FSB(mp, start);
+	xfs_fileoff_t	shift_fsb = XFS_B_TO_FSB(mp, shift);
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+
+	while (!error && !done) {
+		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+		tp->t_flags |= XFS_TRANS_RESERVE;
+		error = xfs_trans_reserve(tp, resblks, XFS_WRITE_LOG_RES(mp),
+					  0, XFS_TRANS_PERM_LOG_RES,
+					  XFS_WRITE_LOG_COUNT);
+		if (error) {
+			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			xfs_trans_cancel(tp, 0);
+			break;
+		}
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
+						ip->i_gdquot, ip->i_pdquot,
+						resblks, 0,
+						XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto out;
+
+		xfs_trans_ijoin(tp, ip, 0);
+
+		error = xfs_update_logical(tp, ip, &done, start_fsb,
+					   shift_fsb, &current_ext);
+		if (error)
+			goto out;
+
+		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	}
+
+	return error;
+
+out:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 38c67c3..a9684c9 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -51,5 +51,7 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 int xfs_iozero(struct xfs_inode *, loff_t, size_t);
 int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
 int xfs_free_eofblocks(struct xfs_mount *, struct xfs_inode *, bool);
+int xfs_collapse_file_space(struct xfs_inode *, loff_t, loff_t);
+int xfs_update_file_size(struct xfs_inode *, loff_t);
 
 #endif /* _XFS_VNODEOPS_H */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
