Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6EkwVH065725 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 08:46:58 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KnzjzxEnNk1LWpfS for
	<xfs@oss.sgi.com>; Tue, 06 Nov 2012 06:48:54 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA6Ems77024879
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:48:54 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qA6Emr4n032463
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:48:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 03/10] xfs: create helper to check whether to free
	eofblocks on inode
Date: Tue,  6 Nov 2012 09:50:40 -0500
Message-Id: <1352213447-59791-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
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

This check is used in multiple places to determine whether we
should check for (and potentially free) post EOF blocks on an
inode. Add a helper to consolidate the check.

Note that when we remove an inode from the cache (xfs_inactive()),
we are required to trim post-EOF blocks even if the inode is marked
preallocated or append-only to maintain correct space accounting.
The 'force' parameter to xfs_can_free_eofblocks() specifies whether
we should ignore the prealloc/append-only status of the inode.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely<tinguely@sgi.com>
---
 fs/xfs/xfs_inode.c    |   37 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h    |    1 +
 fs/xfs/xfs_vnodeops.c |   19 +++++++------------
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 95f7a73..cc7468b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3911,3 +3911,40 @@ xfs_iext_irec_update_extoffs(
 		ifp->if_u1.if_ext_irec[i].er_extoff += ext_diff;
 	}
 }
+
+/*
+ * Test whether it is appropriate to check an inode for and free post EOF
+ * blocks. The 'force' parameter determines whether we should also consider
+ * regular files that are marked preallocated or append-only.
+ */
+bool
+xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
+{
+	/* prealloc/delalloc exists only on regular files */
+	if (!S_ISREG(ip->i_d.di_mode))
+		return false;
+
+	/*
+	 * Zero sized files with no cached pages and delalloc blocks will not
+	 * have speculative prealloc/delalloc blocks to remove.
+	 */
+	if (VFS_I(ip)->i_size == 0 &&
+	    VN_CACHED(VFS_I(ip)) == 0 &&
+	    ip->i_delayed_blks == 0)
+		return false;
+
+	/* If we haven't read in the extent list, then don't do it now. */
+	if (!(ip->i_df.if_flags & XFS_IFEXTENTS))
+		return false;
+
+	/*
+	 * Do not free real preallocated or append-only files unless the file
+	 * has delalloc blocks and we are forced to remove them.
+	 */
+	if (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
+		if (!force || ip->i_delayed_blks == 0)
+			return false;
+
+	return true;
+}
+
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1fc2065..21b4de3 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -585,6 +585,7 @@ void		xfs_iext_irec_compact(xfs_ifork_t *);
 void		xfs_iext_irec_compact_pages(xfs_ifork_t *);
 void		xfs_iext_irec_compact_full(xfs_ifork_t *);
 void		xfs_iext_irec_update_extoffs(xfs_ifork_t *, int, int);
+bool		xfs_can_free_eofblocks(struct xfs_inode *, bool);
 
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index e6e1d11..c4c1539 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -436,11 +436,7 @@ xfs_release(
 	if (ip->i_d.di_nlink == 0)
 		return 0;
 
-	if ((S_ISREG(ip->i_d.di_mode) &&
-	     (VFS_I(ip)->i_size > 0 ||
-	      (VN_CACHED(VFS_I(ip)) > 0 || ip->i_delayed_blks > 0)) &&
-	     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
-	    (!(ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
+	if (xfs_can_free_eofblocks(ip, false)) {
 
 		/*
 		 * If we can't get the iolock just skip truncating the blocks
@@ -516,13 +512,12 @@ xfs_inactive(
 		goto out;
 
 	if (ip->i_d.di_nlink != 0) {
-		if ((S_ISREG(ip->i_d.di_mode) &&
-		    (VFS_I(ip)->i_size > 0 ||
-		     (VN_CACHED(VFS_I(ip)) > 0 || ip->i_delayed_blks > 0)) &&
-		    (ip->i_df.if_flags & XFS_IFEXTENTS) &&
-		    (!(ip->i_d.di_flags &
-				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
-		     ip->i_delayed_blks != 0))) {
+		/*
+		 * force is true because we are evicting an inode from the
+		 * cache. Post-eof blocks must be freed, lest we end up with
+		 * broken free space accounting.
+		 */
+		if (xfs_can_free_eofblocks(ip, true)) {
 			error = xfs_free_eofblocks(mp, ip, false);
 			if (error)
 				return VN_INACTIVE_CACHE;
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
