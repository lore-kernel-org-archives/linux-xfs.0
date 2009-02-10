Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUGQB073458 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B8BB1911719
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id b8adkmVlPtuGaA0S for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:39 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWzEh-0005kj-8L
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 20:29:39 +0000
Message-Id: <20090210202939.043803000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/13] xfs: remove m_attroffset
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-xfs_default_attroffset
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

With the upcoming v3 inodes the default attroffset needs to be calculated
for each specific inode, so we can't cache it in the superblock anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-02-09 19:15:29.083069118 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-02-09 19:15:35.578944518 +0100
@@ -566,6 +566,9 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 STATIC void
 xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
 {
+	ASSERT(sbp->sb_inodesize ==  256 || sbp->sb_inodesize ==  512 ||
+	       sbp->sb_inodesize == 1024 || sbp->sb_inodesize == 2048);
+
 	mp->m_agfrotor = mp->m_agirotor = 0;
 	spin_lock_init(&mp->m_agirotor_lock);
 	mp->m_maxagi = mp->m_sb.sb_agcount;
@@ -578,27 +581,6 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
 
-	/*
-	 * Setup for attributes, in case they get created.
-	 * This value is for inodes getting attributes for the first time,
-	 * the per-inode value is for old attribute values.
-	 */
-	ASSERT(sbp->sb_inodesize >= 256 && sbp->sb_inodesize <= 2048);
-	switch (sbp->sb_inodesize) {
-	case 256:
-		mp->m_attroffset = XFS_LITINO(mp) -
-				   XFS_BMDR_SPACE_CALC(MINABTPTRS);
-		break;
-	case 512:
-	case 1024:
-	case 2048:
-		mp->m_attroffset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
-		break;
-	default:
-		ASSERT(0);
-	}
-	ASSERT(mp->m_attroffset < XFS_LITINO(mp));
-
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
 	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2009-02-09 19:15:18.754098923 +0100
+++ xfs/fs/xfs/xfs_attr_leaf.c	2009-02-09 19:15:35.580944493 +0100
@@ -155,7 +155,8 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 		 * minimum offset only needs to be the space required for 
 		 * the btree root.
 		 */ 
-		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes > mp->m_attroffset)
+		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes >
+		    xfs_default_attroffset(dp))
 			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 		break;
 		
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2009-02-09 19:15:18.758069609 +0100
+++ xfs/fs/xfs/xfs_bmap.c	2009-02-09 19:15:35.583944247 +0100
@@ -3577,6 +3577,27 @@ xfs_bmap_extents_to_btree(
 }
 
 /*
+ * Calculate the default attribute fork offset for newly created inodes.
+ */
+uint
+xfs_default_attroffset(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	uint			offset;
+
+	if (mp->m_sb.sb_inodesize == 256) {
+		offset = XFS_LITINO(mp) -
+				XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	} else {
+		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
+	}
+
+	ASSERT(offset < XFS_LITINO(mp));
+	return offset;
+}
+
+/*
  * Helper routine to reset inode di_forkoff field when switching
  * attribute fork from local to extent format - we reset it where
  * possible to make space available for inline data fork extents.
@@ -3588,15 +3609,18 @@ xfs_bmap_forkoff_reset(
 	int		whichfork)
 {
 	if (whichfork == XFS_ATTR_FORK &&
-	    (ip->i_d.di_format != XFS_DINODE_FMT_DEV) &&
-	    (ip->i_d.di_format != XFS_DINODE_FMT_UUID) &&
-	    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
-	    ((mp->m_attroffset >> 3) > ip->i_d.di_forkoff)) {
-		ip->i_d.di_forkoff = mp->m_attroffset >> 3;
-		ip->i_df.if_ext_max = XFS_IFORK_DSIZE(ip) /
-					(uint)sizeof(xfs_bmbt_rec_t);
-		ip->i_afp->if_ext_max = XFS_IFORK_ASIZE(ip) /
-					(uint)sizeof(xfs_bmbt_rec_t);
+	    ip->i_d.di_format != XFS_DINODE_FMT_DEV &&
+	    ip->i_d.di_format != XFS_DINODE_FMT_UUID &&
+	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE) {
+		uint	dfl_forkoff = xfs_default_attroffset(ip) >> 3;
+
+		if (dfl_forkoff > ip->i_d.di_forkoff) {
+			ip->i_d.di_forkoff = dfl_forkoff;
+			ip->i_df.if_ext_max =
+				XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t);
+			ip->i_afp->if_ext_max =
+				XFS_IFORK_ASIZE(ip) / sizeof(xfs_bmbt_rec_t);
+		}
 	}
 }
 
@@ -4065,7 +4089,7 @@ xfs_bmap_add_attrfork(
 	case XFS_DINODE_FMT_BTREE:
 		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
 		if (!ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = mp->m_attroffset >> 3;
+			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
 		else if (mp->m_flags & XFS_MOUNT_ATTR2)
 			version = 2;
 		break;
@@ -4212,12 +4236,12 @@ xfs_bmap_compute_maxlevels(
 	 * (a signed 16-bit number, xfs_aextnum_t).
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that
-	 * the fork offset of all the inodes will be (m_attroffset >> 3)
-	 * because we could have mounted with ATTR2 and then mounted back
-	 * with ATTR1, keeping the di_forkoff's fixed but probably at
-	 * various positions. Therefore, for both ATTR1 and ATTR2
-	 * we have to assume the worst case scenario of a minimum size
-	 * available.
+	 * the fork offset of all the inodes will be
+	 * (xfs_default_attroffset(ip) >> 3) because we could have mounted
+	 * with ATTR2 and then mounted back with ATTR1, keeping the
+	 * di_forkoff's fixed but probably at various positions. Therefore,
+	 * for both ATTR1 and ATTR2 we have to assume the worst case scenario
+	 * of a minimum size available.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
 		maxleafents = MAXEXTNUM;
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2009-02-09 19:15:18.763069338 +0100
+++ xfs/fs/xfs/xfs_bmap.h	2009-02-09 19:15:35.583944247 +0100
@@ -338,6 +338,10 @@ xfs_check_nostate_extents(
 	xfs_extnum_t		idx,
 	xfs_extnum_t		num);
 
+uint
+xfs_default_attroffset(
+	struct xfs_inode	*ip);
+
 #ifdef __KERNEL__
 
 /*
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2009-02-09 19:15:29.084069385 +0100
+++ xfs/fs/xfs/xfs_mount.h	2009-02-09 19:15:35.584944583 +0100
@@ -276,7 +276,6 @@ typedef struct xfs_mount {
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_dmevmask;	/* DMI events for this FS */
 	__uint64_t		m_flags;	/* global mount flags */
-	uint			m_attroffset;	/* inode attribute offset */
 	uint			m_dir_node_ents; /* #entries in a dir danode */
 	uint			m_attr_node_ents; /* #entries in attr danode */
 	int			m_ialloc_inos;	/* inodes in inode allocation */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
