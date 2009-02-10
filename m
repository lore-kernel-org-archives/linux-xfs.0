Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUjMa073582 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C014F191172C
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nKo0xHlXwbXkN7EH for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:09 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWzEg-0005kD-UF
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 20:29:39 +0000
Message-Id: <20090210202938.766470000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/13] xfs: remove m_litino
References: <20090210202241.546501000@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/xfs_dinode.h	2009-02-09 19:15:18.816069935 +0100
+++ xfs/fs/xfs/xfs_dinode.h	2009-02-09 19:15:29.082068921 +0100
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
--- xfs.orig/fs/xfs/xfs_mount.c	2009-02-09 19:15:18.820068559 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-02-09 19:15:29.083069118 +0100
@@ -574,7 +574,6 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
 	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	mp->m_litino = sbp->sb_inodesize - sizeof(struct xfs_dinode);
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2009-02-09 19:15:18.826069182 +0100
+++ xfs/fs/xfs/xfs_mount.h	2009-02-09 19:15:29.084069385 +0100
@@ -281,7 +281,6 @@ typedef struct xfs_mount {
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
