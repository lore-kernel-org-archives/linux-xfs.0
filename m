Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ECIIhG092215 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 07:18:19 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FNRL20eAVt9pxtZT for
	<xfs@oss.sgi.com>; Fri, 14 Sep 2012 05:19:25 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8ECJPlU003482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:19:25 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8ECJOIg021832
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:19:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 3/8] xfs: create helper to check whether to free eofblocks
	on inode
Date: Fri, 14 Sep 2012 08:19:50 -0400
Message-Id: <1347625195-6369-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
References: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
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
---
 fs/xfs/xfs_vnodeops.c |   19 +++++++------------
 fs/xfs/xfs_vnodeops.h |   40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index d883881..12f5087 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -435,11 +435,7 @@ xfs_release(
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
@@ -515,13 +511,12 @@ xfs_inactive(
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
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 447e146..d5701e3 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -1,6 +1,10 @@
 #ifndef _XFS_VNODEOPS_H
 #define _XFS_VNODEOPS_H 1
 
+#include "xfs_bmap_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+
 struct attrlist_cursor_kern;
 struct file;
 struct iattr;
@@ -9,8 +13,42 @@ struct iovec;
 struct kiocb;
 struct pipe_inode_info;
 struct uio;
-struct xfs_inode;
 
+/*
+ * Test whether it is appropriate to check an inode for and free post EOF
+ * blocks. The 'force' parameter determines whether we should also consider
+ * regular files that are marked preallocated or append-only.
+ */
+static inline bool
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
 
 int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap, int flags);
 int xfs_setattr_size(struct xfs_inode *ip, struct iattr *vap, int flags);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
