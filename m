Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUkHo073585 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D9D7191172C
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UvrhnWT3CXqj8CsM for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:10 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWzEh-0005lF-Hx
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 20:29:39 +0000
Message-Id: <20090210202939.371379000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/13] xfs: take inode version into account in XFS_LITINO
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-XFS_LITINO-per-inode
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

Add a version argument to XFS_LITINO so that it can return different values
depending on the inode version.  This is required for the upcoming v3 inodes
with a larger fixed layout dinode.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dinode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dinode.h	2009-02-09 19:15:29.082068921 +0100
+++ xfs/fs/xfs/xfs_dinode.h	2009-02-09 19:15:37.179944489 +0100
@@ -103,7 +103,7 @@ typedef enum xfs_dinode_fmt {
 /*
  * Inode size for given fs.
  */
-#define XFS_LITINO(mp) \
+#define XFS_LITINO(version, mp) \
 	((int)(((mp)->m_sb.sb_inodesize) - sizeof(struct xfs_dinode)))
 
 #define	XFS_BROOT_SIZE_ADJ	\
@@ -118,10 +118,10 @@ typedef enum xfs_dinode_fmt {
 #define XFS_DFORK_DSIZE(dip,mp) \
 	(XFS_DFORK_Q(dip) ? \
 		XFS_DFORK_BOFF(dip) : \
-		XFS_LITINO(mp))
+		XFS_LITINO((dip)->di_version, mp))
 #define XFS_DFORK_ASIZE(dip,mp) \
 	(XFS_DFORK_Q(dip) ? \
-		XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : \
+		XFS_LITINO((dip)->di_version, mp) - XFS_DFORK_BOFF(dip) : \
 		0)
 #define XFS_DFORK_SIZE(dip,mp,w) \
 	((w) == XFS_DATA_FORK ? \
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2009-02-09 19:15:35.580944493 +0100
+++ xfs/fs/xfs/xfs_attr_leaf.c	2009-02-09 19:15:37.185944554 +0100
@@ -127,7 +127,8 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 	int dsize;	
 	xfs_mount_t *mp = dp->i_mount;
 
-	offset = (XFS_LITINO(mp) - bytes) >> 3; /* rounded down */
+	/* rounded down */
+	offset = (XFS_LITINO(dp->i_d.di_version, mp) - bytes) >> 3;
 
 	switch (dp->i_d.di_format) {
 	case XFS_DINODE_FMT_DEV:
@@ -185,7 +186,8 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	maxforkoff = XFS_LITINO(dp->i_d.di_version, mp) -
+			XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
 	if (offset >= minforkoff && offset < maxforkoff)
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2009-02-09 19:15:35.583944247 +0100
+++ xfs/fs/xfs/xfs_bmap.c	2009-02-09 19:15:37.192068867 +0100
@@ -3587,13 +3587,13 @@ xfs_default_attroffset(
 	uint			offset;
 
 	if (mp->m_sb.sb_inodesize == 256) {
-		offset = XFS_LITINO(mp) -
+		offset = XFS_LITINO(ip->i_d.di_version, mp) -
 				XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	} else {
 		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
 	}
 
-	ASSERT(offset < XFS_LITINO(mp));
+	ASSERT(offset < XFS_LITINO(ip->i_d.di_version, mp));
 	return offset;
 }
 
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2009-02-09 19:15:18.690944589 +0100
+++ xfs/fs/xfs/xfs_inode.h	2009-02-09 19:15:37.193072276 +0100
@@ -180,10 +180,11 @@ typedef struct xfs_icdinode {
 #define XFS_IFORK_DSIZE(ip) \
 	(XFS_IFORK_Q(ip) ? \
 		XFS_IFORK_BOFF(ip) : \
-		XFS_LITINO((ip)->i_mount))
+		XFS_LITINO((ip)->i_d.di_version, (ip)->i_mount))
 #define XFS_IFORK_ASIZE(ip) \
 	(XFS_IFORK_Q(ip) ? \
-		XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : \
+		XFS_LITINO((ip)->i_d.di_version, (ip)->i_mount) - \
+			XFS_IFORK_BOFF(ip) : \
 		0)
 #define XFS_IFORK_SIZE(ip,w) \
 	((w) == XFS_DATA_FORK ? \
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-02-09 19:15:18.700944674 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2009-02-09 19:15:37.194069750 +0100
@@ -2210,7 +2210,7 @@ xfs_symlink(
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= XFS_LITINO(dp->i_d.di_version, mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = XFS_B_TO_FSB(mp, pathlen);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
