Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3Nefxh067643 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:41 -0600
Message-Id: <20121203144310.465551719@sgi.com>
Date: Mon, 03 Dec 2012 17:42:26 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 18/36] xfs: dont assert on delalloc regions beyond
	EOF
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=078
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: 58e20770646932fe9b758c94e8c278ea9ec93878

When we are doing speculative delayed allocation beyond EOF,
conversion of the region allocated beyond EOF is dependent on the
largest free space extent available. If the largest free extent is
smaller than the delalloc range, then after allocation we leave
a delalloc extent that starts beyond EOF. This extent cannot *ever*
be converted by flushing data, and so will remain there until either
the EOF moves into the extent or it is truncated away.

Hence if xfs_getbmap() runs on such an inode and is asked to return
extents beyond EOF, it will assert fail on this extent even though
there is nothing xfs_getbmap() can do to convert it to a real
extent. Hence we should simply report these delalloc extents rather
than assert that there should be none.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

A modified XFS_ISIZE() inline function came from:

From: Christoph Hellwig <hch@infradead.org>
upstream commit: ce7ae151ddada3dbf67301464343c154903166b3
xfs: remove the i_size field in struct xfs_inode

---
 fs/xfs/xfs_bmap.c  |   19 +++++++++++++++----
 fs/xfs/xfs_inode.h |    8 ++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -53,7 +53,6 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 
-
 #ifdef DEBUG
 STATIC void
 xfs_bmap_check_leaf_extents(xfs_btree_cur_t *cur, xfs_inode_t *ip, int whichfork);
@@ -5543,9 +5542,21 @@ xfs_getbmap(
 				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			out[cur_ext].bmv_unused1 = 0;
 			out[cur_ext].bmv_unused2 = 0;
-			ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
-			      (map[i].br_startblock != DELAYSTARTBLOCK));
-                        if (map[i].br_startblock == HOLESTARTBLOCK &&
+
+			/*
+			 * delayed allocation extents that start beyond EOF can
+			 * occur due to speculative EOF allocation when the
+			 * delalloc extent is larger than the largest freespace
+			 * extent at conversion time. These extents cannot be
+			 * converted by data writeback, so can exist here even
+			 * if we are not supposed to be finding delalloc
+			 * extents.
+			 */
+			if (map[i].br_startblock == DELAYSTARTBLOCK &&
+			    map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
+
+			if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
 				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
Index: b/fs/xfs/xfs_inode.h
===================================================================
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -264,8 +264,12 @@ typedef struct xfs_inode {
 	struct inode		i_vnode;	/* embedded VFS inode */
 } xfs_inode_t;
 
-#define XFS_ISIZE(ip)	(((ip)->i_d.di_mode & S_IFMT) == S_IFREG) ? \
-				(ip)->i_size : (ip)->i_d.di_size;
+static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
+{
+	if (S_ISREG(ip->i_d.di_mode))
+		return ip->i_size;
+	return ip->i_d.di_size;
+}
 
 /* Convert from vfs inode to xfs inode */
 static inline struct xfs_inode *XFS_I(struct inode *inode)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
