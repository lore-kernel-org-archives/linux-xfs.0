Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4EHFpMD234940 for <xfs@oss.sgi.com>; Thu, 14 May 2009 12:15:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 837BD288001
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 10:15:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Peu3gy7Y5ObwlaFx for
	<xfs@oss.sgi.com>; Thu, 14 May 2009 10:15:59 -0700 (PDT)
Message-Id: <20090514171559.029154000@bombadil.infradead.org>
Date: Thu, 14 May 2009 13:12:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/7] xfs: use generic inode iterator in
	xfs_qm_dqrele_all_inodes
References: <20090514171233.942489000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-sync-iterators
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

Use xfs_inode_ag_iterator instead of opencoding the inode walk in the
quota code.  Mark xfs_inode_ag_iterator and xfs_sync_inode_valid non-static
to allow using them from the quota code.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2009-05-13 14:52:54.087659167 +0200
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2009-05-13 14:57:36.531661369 +0200
@@ -846,105 +846,55 @@ xfs_qm_export_flags(
 }
 
 
-/*
- * Release all the dquots on the inodes in an AG.
- */
-STATIC void
-xfs_qm_dqrele_inodes_ag(
-	xfs_mount_t	*mp,
-	int		ag,
-	uint		flags)
+STATIC int
+xfs_dqrele_inode(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			flags)
 {
-	xfs_inode_t	*ip = NULL;
-	xfs_perag_t	*pag = &mp->m_perag[ag];
-	int		first_index = 0;
-	int		nr_found;
-
-	do {
-		/*
-		 * use a gang lookup to find the next inode in the tree
-		 * as the tree is sparse and a gang lookup walks to find
-		 * the number of objects requested.
-		 */
-		read_lock(&pag->pag_ici_lock);
-		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-				(void**)&ip, first_index, 1);
-
-		if (!nr_found) {
-			read_unlock(&pag->pag_ici_lock);
-			break;
-		}
-
-		/*
-		 * Update the index for the next lookup. Catch overflows
-		 * into the next AG range which can occur if we have inodes
-		 * in the last block of the AG and we are currently
-		 * pointing to the last inode.
-		 */
-		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino)) {
-			read_unlock(&pag->pag_ici_lock);
-			break;
-		}
-
-		/* skip quota inodes */
-		if (ip == XFS_QI_UQIP(mp) || ip == XFS_QI_GQIP(mp)) {
-			ASSERT(ip->i_udquot == NULL);
-			ASSERT(ip->i_gdquot == NULL);
-			read_unlock(&pag->pag_ici_lock);
-			continue;
-		}
+	int			error;
 
-		/*
-		 * If we can't get a reference on the inode, it must be
-		 * in reclaim. Leave it for the reclaim code to flush.
-		 */
-		if (!igrab(VFS_I(ip))) {
-			read_unlock(&pag->pag_ici_lock);
-			continue;
-		}
+	/* skip quota inodes */
+	if (ip == XFS_QI_UQIP(ip->i_mount) || ip == XFS_QI_GQIP(ip->i_mount)) {
+		ASSERT(ip->i_udquot == NULL);
+		ASSERT(ip->i_gdquot == NULL);
 		read_unlock(&pag->pag_ici_lock);
+		return 0;
+	}
 
-		/* avoid new inodes though we shouldn't find any here */
-		if (xfs_iflags_test(ip, XFS_INEW)) {
-			IRELE(ip);
-			continue;
-		}
+	error = xfs_sync_inode_valid(ip, pag);
+	if (error)
+		return 0;
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
-			xfs_qm_dqrele(ip->i_udquot);
-			ip->i_udquot = NULL;
-		}
-		if (flags & (XFS_PQUOTA_ACCT|XFS_GQUOTA_ACCT) &&
-		    ip->i_gdquot) {
-			xfs_qm_dqrele(ip->i_gdquot);
-			ip->i_gdquot = NULL;
-		}
-		xfs_iput(ip, XFS_ILOCK_EXCL);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
+		xfs_qm_dqrele(ip->i_udquot);
+		ip->i_udquot = NULL;
+	}
+	if (flags & (XFS_PQUOTA_ACCT|XFS_GQUOTA_ACCT) && ip->i_gdquot) {
+		xfs_qm_dqrele(ip->i_gdquot);
+		ip->i_gdquot = NULL;
+	}
+	xfs_iput(ip, XFS_ILOCK_EXCL);
+	IRELE(ip);
 
-	} while (nr_found);
+	return 0;
 }
 
+
 /*
  * Go thru all the inodes in the file system, releasing their dquots.
+ *
  * Note that the mount structure gets modified to indicate that quotas are off
- * AFTER this, in the case of quotaoff. This also gets called from
- * xfs_rootumount.
+ * AFTER this, in the case of quotaoff.
  */
 void
 xfs_qm_dqrele_all_inodes(
 	struct xfs_mount *mp,
 	uint		 flags)
 {
-	int		i;
-
 	ASSERT(mp->m_quotainfo);
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-		if (!mp->m_perag[i].pag_ici_init)
-			continue;
-		xfs_qm_dqrele_inodes_ag(mp, i, flags);
-	}
+	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, -1);
 }
 
 /*------------------------------------------------------------------------*/
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-05-13 14:52:54.093659302 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-05-13 14:57:18.322814622 +0200
@@ -141,7 +141,7 @@ restart:
 	return last_error;
 }
 
-STATIC int
+int
 xfs_inode_ag_iterator(
 	struct xfs_mount	*mp,
 	int			(*execute)(struct xfs_inode *ip,
@@ -166,7 +166,7 @@ xfs_inode_ag_iterator(
 }
 
 /* must be called with pag_ici_lock held and releases it */
-STATIC int
+int
 xfs_sync_inode_valid(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag)
Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-05-13 14:52:54.100659565 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.h	2009-05-13 14:57:18.331814510 +0200
@@ -56,4 +56,10 @@ void xfs_inode_set_reclaim_tag(struct xf
 void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
+
+int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
+int xfs_inode_ag_iterator(struct xfs_mount *mp,
+	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
+	int flags, int tag);
+
 #endif

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
