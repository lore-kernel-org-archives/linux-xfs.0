Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoK5f153459 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E128A178882C
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	EGAgVBysOV4HYDqi for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xF-0002tj-3g
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:17 +0000
Message-Id: <20110710205017.074624276@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/11] xfs: cleanup struct xfs_dir2_free
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_dir2_free_t
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

Change the bests array to be a proper variable sized entry.  This is done
easily as no one relies on the size of the structure.  Also change
XFS_DIR2_MAX_FREE_BESTS to an inline function while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dir2_format.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_format.h	2011-07-09 13:29:33.488251514 +0200
+++ xfs/fs/xfs/xfs_dir2_format.h	2011-07-09 13:30:38.428248225 +0200
@@ -523,13 +523,15 @@ typedef	struct xfs_dir2_free_hdr {
 
 typedef struct xfs_dir2_free {
 	xfs_dir2_free_hdr_t	hdr;		/* block header */
-	__be16			bests[1];	/* best free counts */
+	__be16			bests[];	/* best free counts */
 						/* unused entries are -1 */
 } xfs_dir2_free_t;
 
-#define	XFS_DIR2_MAX_FREE_BESTS(mp)	\
-	(((mp)->m_dirblksize - (uint)sizeof(struct xfs_dir2_free_hdr)) / \
-	 (uint)sizeof(xfs_dir2_data_off_t))
+static inline int xfs_dir2_free_max_bests(struct xfs_mount *mp)
+{
+	return (mp->m_dirblksize - sizeof(struct xfs_dir2_free_hdr)) /
+		sizeof(xfs_dir2_data_off_t);
+}
 
 /*
  * Convert data space db to the corresponding free db.
@@ -537,7 +539,7 @@ typedef struct xfs_dir2_free {
 static inline xfs_dir2_db_t
 xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
-	return XFS_DIR2_FREE_FIRSTDB(mp) + db / XFS_DIR2_MAX_FREE_BESTS(mp);
+	return XFS_DIR2_FREE_FIRSTDB(mp) + db / xfs_dir2_free_max_bests(mp);
 }
 
 /*
@@ -546,7 +548,7 @@ xfs_dir2_db_to_fdb(struct xfs_mount *mp,
 static inline int
 xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
-	return db % XFS_DIR2_MAX_FREE_BESTS(mp);
+	return db % xfs_dir2_free_max_bests(mp);
 }
 
 /*
Index: xfs/fs/xfs/xfs_dir2_node.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_node.c	2011-07-09 13:29:20.448252173 +0200
+++ xfs/fs/xfs/xfs_dir2_node.c	2011-07-09 13:30:38.428248225 +0200
@@ -408,7 +408,7 @@ xfs_dir2_leafn_lookup_for_addname(
 				ASSERT(be32_to_cpu(free->hdr.magic) ==
 					XFS_DIR2_FREE_MAGIC);
 				ASSERT((be32_to_cpu(free->hdr.firstdb) %
-					XFS_DIR2_MAX_FREE_BESTS(mp)) == 0);
+					xfs_dir2_free_max_bests(mp)) == 0);
 				ASSERT(be32_to_cpu(free->hdr.firstdb) <= curdb);
 				ASSERT(curdb < be32_to_cpu(free->hdr.firstdb) +
 					be32_to_cpu(free->hdr.nvalid));
@@ -924,7 +924,7 @@ xfs_dir2_leafn_remove(
 		free = fbp->data;
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 		ASSERT(be32_to_cpu(free->hdr.firstdb) ==
-		       XFS_DIR2_MAX_FREE_BESTS(mp) *
+		       xfs_dir2_free_max_bests(mp) *
 		       (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
 		/*
 		 * Calculate which entry we need to fix.
@@ -1603,7 +1603,7 @@ xfs_dir2_node_addname_int(
 			free->hdr.magic = cpu_to_be32(XFS_DIR2_FREE_MAGIC);
 			free->hdr.firstdb = cpu_to_be32(
 				(fbno - XFS_DIR2_FREE_FIRSTDB(mp)) *
-				XFS_DIR2_MAX_FREE_BESTS(mp));
+				xfs_dir2_free_max_bests(mp));
 			free->hdr.nvalid = 0;
 			free->hdr.nused = 0;
 		} else {
@@ -1620,7 +1620,7 @@ xfs_dir2_node_addname_int(
 		 * freespace block, extend that table.
 		 */
 		if (findex >= be32_to_cpu(free->hdr.nvalid)) {
-			ASSERT(findex < XFS_DIR2_MAX_FREE_BESTS(mp));
+			ASSERT(findex < xfs_dir2_free_max_bests(mp));
 			free->hdr.nvalid = cpu_to_be32(findex + 1);
 			/*
 			 * Tag new entry so nused will go up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
