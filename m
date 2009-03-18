Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2I9gM7E224834 for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 04:42:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DD461C4F729
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 02:42:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rdWGWf5frDSOFFPJ for
	<xfs@oss.sgi.com>; Wed, 18 Mar 2009 02:42:03 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LjsHE-0007ez-AX
	for xfs@oss.sgi.com; Wed, 18 Mar 2009 09:41:32 +0000
Message-Id: <20090318094132.224487000@bombadil.infradead.org>
Date: Wed, 18 Mar 2009 05:41:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/5] xfs: remove m_litino
References: <20090318094119.561416000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-m_litino
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

With the upcoming v3 inodes the inode data/attr area size needs to be
calculated for each specific inode, so we can't cache it in the superblock
anymore.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dinode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dinode.h	2009-02-19 20:44:20.755069389 +0100
+++ xfs/fs/xfs/xfs_dinode.h	2009-03-18 07:37:16.652977839 +0100
@@ -103,7 +103,9 @@ typedef enum xfs_dinode_fmt {
 /*
  * Inode size for given fs.
  */
-#define	XFS_LITINO(mp)	((mp)->m_litino)
+#define XFS_LITINO(mp) \
+	((int)(((mp)->m_sb.sb_inodesize) - sizeof(struct xfs_dinode)))
+
 #define	XFS_BROOT_SIZE_ADJ	\
 	(XFS_BTREE_LBLOCK_LEN - sizeof(xfs_bmdr_block_t))
 
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-03-18 07:37:15.633978066 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-03-18 07:37:20.566978952 +0100
@@ -651,7 +651,6 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
 	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	mp->m_litino = sbp->sb_inodesize - sizeof(struct xfs_dinode);
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2009-03-18 07:37:16.077856262 +0100
+++ xfs/fs/xfs/xfs_mount.h	2009-03-18 07:37:20.585978718 +0100
@@ -203,7 +203,6 @@ typedef struct xfs_mount {
 	uint			m_attr_node_ents; /* #entries in attr danode */
 	int			m_ialloc_inos;	/* inodes in inode allocation */
 	int			m_ialloc_blks;	/* blocks in inode allocation */
-	int			m_litino;	/* size of inode union area */
 	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
 	uint			m_qflags;	/* quota status flags */
 	xfs_trans_reservations_t m_reservations;/* precomputed res values */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
