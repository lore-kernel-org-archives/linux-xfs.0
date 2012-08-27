Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RJo3w0237187 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 14:50:03 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rDoxsXPvBVU0yblx for
	<xfs@oss.sgi.com>; Mon, 27 Aug 2012 12:50:52 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7RJopti031232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 15:50:51 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q7RJopn6002754
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 15:50:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 2/4] xfs: create function to scan and clear EOFBLOCKS
	inodes
Date: Mon, 27 Aug 2012 15:51:49 -0400
Message-Id: <1346097111-4476-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_inodes_free_eofblocks() implements scanning functionality for
EOFBLOCKS inodes. It scans the radix tree and frees post-EOF blocks
for inodes that meet particular criteria. The scan can be filtered
by a particular quota type/id and minimum file size. The scan can
also be invoked in trylock mode or wait (force) mode.

The xfs_free_eofblocks() helper is invoked to clear post-EOF space.
It is slightly modified to support an output parameter that
indicates whether space was freed and helps decide whether the
EOFBLOCKS tag should be cleared in trylock scans.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_sync.c     |  168 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sync.h     |    3 +
 fs/xfs/xfs_vnodeops.c |   17 +++--
 fs/xfs/xfs_vnodeops.h |    2 +
 4 files changed, 184 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 5e14741..27c3c46 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -971,6 +971,174 @@ xfs_reclaim_inodes_count(
 	return reclaimable;
 }
 
+/*
+ * Handle an EOFBLOCKS tagged inode. If this is a forced scan, we wait on the
+ * iolock ourselves rather than rely on the trylock in xfs_free_eofblocks(). 
+ *
+ * We rely on the output parameter from xfs_free_eofblocks() to determine
+ * whether we should clear the tag because in the trylock case, it could have
+ * skipped the inode due to lock contention.
+ */
+STATIC int
+xfs_inode_free_eofblocks(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	int ret = 0;
+	bool freed = false;
+	bool wait_iolock = (flags & EOFBLOCKS_WAIT) ? true : false;
+
+	if (wait_iolock)
+		xfs_ilock(ip, XFS_IOLOCK_EXCL);
+
+	if ((S_ISREG(ip->i_d.di_mode) &&
+	     (VFS_I(ip)->i_size > 0 ||
+	     (VN_CACHED(VFS_I(ip)) > 0 || ip->i_delayed_blks > 0)) &&
+	     (ip->i_df.if_flags & XFS_IFEXTENTS)) &&
+	    (!(ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
+		/* !wait_iolock == need_iolock in xfs_free_eofblocks() */
+		ret = xfs_free_eofblocks(ip->i_mount, ip, !wait_iolock, &freed);
+		if (freed)
+			xfs_inode_clear_eofblocks_tag(ip);
+	} else {
+		/* inode could be preallocated or append-only */
+		xfs_inode_clear_eofblocks_tag(ip);
+	}
+
+	if (wait_iolock)
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+
+	return ret;
+}
+
+/*
+ * Determine whether an inode matches a particular qouta id.
+ */
+STATIC int
+xfs_inode_match_quota_id(
+	struct xfs_inode	*ip,
+	int			qtype,
+	uint32_t		id)
+{
+	switch (qtype) {
+	case XFS_DQ_USER:
+		return ip->i_d.di_uid == id;
+	case XFS_DQ_GROUP:
+		return ip->i_d.di_gid == id;
+	default:
+		return xfs_get_projid(ip) == id;
+	}
+
+	return 0;
+}
+
+/*
+ * This is mostly copied from xfs_reclaim_inodes_ag().
+ *
+ * TODO:
+ * - Could we enhance ag_iterator to support a tag and use it instead of this?
+ */
+int
+xfs_inodes_free_eofblocks(
+	struct xfs_mount	*mp,
+	int			qtype,
+	uint32_t		id,
+	uint64_t		min_file_size,
+	int			flags)
+{
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			last_error = 0;
+	xfs_agnumber_t		ag;
+
+	ag = 0;
+	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_EOFBLOCKS_TAG))) {
+		unsigned long	first_index = 0;
+		int		nr_found = 0;
+		int		done = 0;
+
+		ag = pag->pag_agno + 1;
+
+		do {
+			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
+			int	i;
+
+			rcu_read_lock();
+			nr_found = radix_tree_gang_lookup_tag(
+					&pag->pag_ici_root,
+					(void **)batch, first_index,
+					XFS_LOOKUP_BATCH,
+					XFS_ICI_EOFBLOCKS_TAG);
+			if (!nr_found) {
+				rcu_read_unlock();
+				break;
+			}
+
+			/*
+			 * Grab the inodes before we drop the lock. if we found
+			 * nothing, nr == 0 and the loop will be skipped.
+			 */
+			for (i = 0; i < nr_found; i++) {
+				struct xfs_inode *ip = batch[i];
+
+				if (done || xfs_inode_ag_walk_grab(ip))
+					batch[i] = NULL;
+
+				/*
+				 * Update the index for the next lookup. Catch
+				 * overflows into the next AG range which can occur if
+				 * we have inodes in the last block of the AG and we
+				 * are currently pointing to the last inode.
+				 *
+				 * Because we may see inodes that are from the wrong AG
+				 * due to RCU freeing and reallocation, only update the
+				 * index if it lies in this AG. It was a race that lead
+				 * us to see this inode, so another lookup from the
+				 * same index will not find it again.
+				 */
+				if (XFS_INO_TO_AGNO(mp, ip->i_ino) !=
+								pag->pag_agno)
+					continue;
+				first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+				if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+					done = 1;
+			}
+
+			/* unlock now we've grabbed the inodes. */
+			rcu_read_unlock();
+
+			for (i = 0; i < nr_found; i++) {
+				if (!batch[i])
+					continue;
+
+				/* default projid represents a full scan */
+				if ((!(qtype == XFS_DQ_PROJ &&
+				       id == XFS_PROJID_DEFAULT) &&
+				     !xfs_inode_match_quota_id(batch[i], qtype,
+							       id)) ||
+				    (min_file_size && XFS_ISIZE(batch[i]) < 
+								min_file_size)
+				   ) {
+					IRELE(batch[i]);
+					continue;
+				}
+
+				error = xfs_inode_free_eofblocks(batch[i], flags);
+				IRELE(batch[i]);
+				if (error)
+					last_error = error;
+			}
+
+			cond_resched();
+
+		} while (nr_found && !done);
+
+		xfs_perag_put(pag);
+	}
+
+	return XFS_ERROR(last_error);
+}
+
 STATIC void
 __xfs_inode_set_eofblocks_tag(
 	struct xfs_perag	*pag,
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 4486491..78aca41 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -43,8 +43,11 @@ void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
 
+#define EOFBLOCKS_WAIT		0x0001
+
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
+int xfs_inodes_free_eofblocks(struct xfs_mount *, int, uint32_t, uint64_t, int);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 658ee2e..53460f3 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -150,11 +150,12 @@ xfs_readlink(
  * when the link count isn't zero and by xfs_dm_punch_hole() when
  * punching a hole to EOF.
  */
-STATIC int
+int
 xfs_free_eofblocks(
 	xfs_mount_t	*mp,
 	xfs_inode_t	*ip,
-	bool		need_iolock)
+	bool		need_iolock,
+	bool		*blocks_freed)
 {
 	xfs_trans_t	*tp;
 	int		error;
@@ -237,6 +238,9 @@ xfs_free_eofblocks(
 		} else {
 			error = xfs_trans_commit(tp,
 						XFS_TRANS_RELEASE_LOG_RES);
+			if (blocks_freed)
+				*blocks_freed = true;
+
 		}
 
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -391,6 +395,7 @@ xfs_release(
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	int		error;
+	bool		freed = false;
 
 	if (!S_ISREG(ip->i_d.di_mode) || (ip->i_d.di_mode == 0))
 		return 0;
@@ -463,11 +468,11 @@ xfs_release(
 		if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
 			return 0;
 
-		error = xfs_free_eofblocks(mp, ip, true);
+		error = xfs_free_eofblocks(mp, ip, true, &freed);
 		if (error)
 			return error;
-
-		xfs_inode_clear_eofblocks_tag(ip);
+		if (freed)
+			xfs_inode_clear_eofblocks_tag(ip);
 
 		/* delalloc blocks after truncation means it really is dirty */
 		if (ip->i_delayed_blks)
@@ -522,7 +527,7 @@ xfs_inactive(
 		    (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
 		     ip->i_delayed_blks != 0))) {
-			error = xfs_free_eofblocks(mp, ip, false);
+			error = xfs_free_eofblocks(mp, ip, false, NULL);
 			if (error)
 				return VN_INACTIVE_CACHE;
 			xfs_inode_clear_eofblocks_tag(ip);
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 447e146..918d24d 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -57,5 +57,7 @@ int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
 int xfs_wait_on_pages(struct xfs_inode *ip, xfs_off_t first, xfs_off_t last);
 
 int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
+int xfs_free_eofblocks(struct xfs_mount *, struct xfs_inode *, bool, bool *);
+
 
 #endif /* _XFS_VNODEOPS_H */
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
