Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A1B9D29E1B
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 14:31:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 30530AC004
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 12:31:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Mww1WP4djIivHbH5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 12:31:29 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Vp23c-0004v6-JF
	for xfs@oss.sgi.com; Fri, 06 Dec 2013 20:31:28 +0000
Message-Id: <20131206203128.511935311@bombadil.infradead.org>
Date: Fri, 06 Dec 2013 12:30:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/11] xfs: rename xfs_ilock_map_shared
References: <20131206203006.914776999@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-rename-xfs_ilock_map_shared
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

Make it clear that we're only locking against the extent map on the data
fork.  Also clean the function up a little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2013-12-06 19:57:22.371138392 +0100
+++ xfs/fs/xfs/xfs_aops.c	2013-12-06 19:58:15.755137296 +0100
@@ -1217,7 +1217,7 @@ __xfs_get_blocks(
 		lockmode = XFS_ILOCK_EXCL;
 		xfs_ilock(ip, lockmode);
 	} else {
-		lockmode = xfs_ilock_map_shared(ip);
+		lockmode = xfs_ilock_data_map_shared(ip);
 	}
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2013-12-06 19:57:22.371138392 +0100
+++ xfs/fs/xfs/xfs_file.c	2013-12-06 19:58:15.759137296 +0100
@@ -912,7 +912,7 @@ xfs_dir_open(
 	 * If there are any blocks, read-ahead block 0 as we're almost
 	 * certain to have the next operation be a read there.
 	 */
-	mode = xfs_ilock_map_shared(ip);
+	mode = xfs_ilock_data_map_shared(ip);
 	if (ip->i_d.di_nextents > 0)
 		xfs_dir3_data_readahead(NULL, ip, 0, -1);
 	xfs_iunlock(ip, mode);
@@ -1215,7 +1215,7 @@ xfs_seek_data(
 	uint			lock;
 	int			error;
 
-	lock = xfs_ilock_map_shared(ip);
+	lock = xfs_ilock_data_map_shared(ip);
 
 	isize = i_size_read(inode);
 	if (start >= isize) {
@@ -1319,7 +1319,7 @@ xfs_seek_hole(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
 
-	lock = xfs_ilock_map_shared(ip);
+	lock = xfs_ilock_data_map_shared(ip);
 
 	isize = i_size_read(inode);
 	if (start >= isize) {
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2013-12-06 19:57:33.199138169 +0100
+++ xfs/fs/xfs/xfs_inode.c	2013-12-06 19:58:41.667136764 +0100
@@ -91,20 +91,15 @@ xfs_get_extsz_hint(
  * xfs_iunlock() call.
  */
 uint
-xfs_ilock_map_shared(
-	xfs_inode_t	*ip)
+xfs_ilock_data_map_shared(
+	struct xfs_inode	*ip)
 {
-	uint	lock_mode;
+	uint			lock_mode = XFS_ILOCK_SHARED;
 
-	if ((ip->i_d.di_format == XFS_DINODE_FMT_BTREE) &&
-	    ((ip->i_df.if_flags & XFS_IFEXTENTS) == 0)) {
+	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
+	    (ip->i_df.if_flags & XFS_IFEXTENTS) == 0)
 		lock_mode = XFS_ILOCK_EXCL;
-	} else {
-		lock_mode = XFS_ILOCK_SHARED;
-	}
-
 	xfs_ilock(ip, lock_mode);
-
 	return lock_mode;
 }
 
@@ -575,7 +570,7 @@ xfs_lookup(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
 
-	lock_mode = xfs_ilock_map_shared(dp);
+	lock_mode = xfs_ilock_data_map_shared(dp);
 	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
 	xfs_iunlock(dp, lock_mode);
 
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2013-12-06 19:57:22.371138392 +0100
+++ xfs/fs/xfs/xfs_inode.h	2013-12-06 19:58:15.759137296 +0100
@@ -337,7 +337,7 @@ int		xfs_ilock_nowait(xfs_inode_t *, uin
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
 int		xfs_isilocked(xfs_inode_t *, uint);
-uint		xfs_ilock_map_shared(xfs_inode_t *);
+uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
 			   xfs_nlink_t, xfs_dev_t, prid_t, int,
 			   struct xfs_buf **, xfs_inode_t **);
Index: xfs/fs/xfs/xfs_bmap_util.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-12-06 19:57:22.371138392 +0100
+++ xfs/fs/xfs/xfs_bmap_util.c	2013-12-06 19:58:15.759137296 +0100
@@ -632,7 +632,7 @@ xfs_getbmap(
 		 */
 	}
 
-	lock = xfs_ilock_map_shared(ip);
+	lock = xfs_ilock_data_map_shared(ip);
 
 	/*
 	 * Don't let nex be bigger than the number of extents

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
