Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FD0C29E15
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BCE9AC001
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	E3W8GEWD1VGN632a for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:53 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phW-0004Xi-TK
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phW-00061K-S9
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 11/50] xfs: split out transaction
	reservation code
Date: Mon, 12 Aug 2013 20:49:32 +1000
Message-Id: <1376304611-22994-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The transaction reservation size calculations is used by both kernel
and userspace, but most of the transaction code in xfs_trans.c is
kernel specific. Split all the transaction reservation code out into
it's own files to make sharing with userspace simpler. This just
leaves kernel-only definitions in xfs_trans.h, so it doesn't need to
be shared with userspace anymore, either.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/Makefile         |   3 +-
 fs/xfs/xfs_acl.c        |   1 +
 fs/xfs/xfs_buf.c        |   1 +
 fs/xfs/xfs_discard.c    |   4 +-
 fs/xfs/xfs_mount.h      |  42 +--
 fs/xfs/xfs_quotaops.c   |   3 +-
 fs/xfs/xfs_trans.c      | 654 +-------------------------------------------
 fs/xfs/xfs_trans.h      |  77 +-----
 fs/xfs/xfs_trans_resv.c | 701 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans_resv.h | 137 ++++++++++
 10 files changed, 851 insertions(+), 772 deletions(-)
 create mode 100644 fs/xfs/xfs_trans_resv.c
 create mode 100644 fs/xfs/xfs_trans_resv.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 4a45080..dc72b6b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -47,6 +47,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mru_cache.o \
 				   xfs_rename.o \
 				   xfs_super.o \
+				   xfs_trans.o \
 				   xfs_utils.o \
 				   xfs_vnodeops.o \
 				   xfs_xattr.o \
@@ -76,7 +77,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_log_recover.o \
 				   xfs_mount.o \
 				   xfs_symlink.o \
-				   xfs_trans.o
+				   xfs_trans_resv.o
 
 # low-level transaction/log code
 xfs-y				+= xfs_log.o \
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 695606a..150c670 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -17,6 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_bmap_btree.h"
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1b2472a..c8136d0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -35,6 +35,7 @@
 #include <linux/freezer.h>
 
 #include "xfs_sb.h"
+#include "xfs_trans_resv.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 65831f9..45560ee 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -17,12 +17,12 @@
  */
 #include "xfs.h"
 #include "xfs_format.h"
-#include "xfs_sb.h"
 #include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_quota.h"
-#include "xfs_trans.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_ialloc_btree.h"
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 4e374d4..27d0d5c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -18,45 +18,7 @@
 #ifndef __XFS_MOUNT_H__
 #define	__XFS_MOUNT_H__
 
-typedef struct xfs_trans_reservations {
-	uint	tr_write;	/* extent alloc trans */
-	uint	tr_itruncate;	/* truncate trans */
-	uint	tr_rename;	/* rename trans */
-	uint	tr_link;	/* link trans */
-	uint	tr_remove;	/* unlink trans */
-	uint	tr_symlink;	/* symlink trans */
-	uint	tr_create;	/* create trans */
-	uint	tr_mkdir;	/* mkdir trans */
-	uint	tr_ifree;	/* inode free trans */
-	uint	tr_ichange;	/* inode update trans */
-	uint	tr_growdata;	/* fs data section grow trans */
-	uint	tr_swrite;	/* sync write inode trans */
-	uint	tr_addafork;	/* cvt inode to attributed trans */
-	uint	tr_writeid;	/* write setuid/setgid file */
-	uint	tr_attrinval;	/* attr fork buffer invalidation */
-	uint	tr_attrsetm;	/* set/create an attribute at mount time */
-	uint	tr_attrsetrt;	/* set/create an attribute at runtime */
-	uint	tr_attrrm;	/* remove an attribute */
-	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
-	uint	tr_growrtalloc;	/* grow realtime allocations */
-	uint	tr_growrtzero;	/* grow realtime zeroing */
-	uint	tr_growrtfree;	/* grow realtime freeing */
-	uint	tr_qm_sbchange;	/* change quota flags */
-	uint	tr_qm_setqlim;	/* adjust quota limits */
-	uint	tr_qm_dqalloc;	/* allocate quota on disk */
-	uint	tr_qm_quotaoff;	/* turn quota off */
-	uint	tr_qm_equotaoff;/* end of turn quota off */
-	uint	tr_sb;		/* modify superblock */
-} xfs_trans_reservations_t;
-
-#ifndef __KERNEL__
-
-#define xfs_daddr_to_agno(mp,d) \
-	((xfs_agnumber_t)(XFS_BB_TO_FSBT(mp, d) / (mp)->m_sb.sb_agblocks))
-#define xfs_daddr_to_agbno(mp,d) \
-	((xfs_agblock_t)(XFS_BB_TO_FSBT(mp, d) % (mp)->m_sb.sb_agblocks))
-
-#else /* __KERNEL__ */
+#ifdef __KERNEL__
 
 struct xlog;
 struct xfs_inode;
@@ -174,7 +136,7 @@ typedef struct xfs_mount {
 	int			m_ialloc_blks;	/* blocks in inode allocation */
 	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
 	uint			m_qflags;	/* quota status flags */
-	xfs_trans_reservations_t m_reservations;/* precomputed res values */
+	struct xfs_trans_resv	m_reservations;	/* precomputed res values */
 	__uint64_t		m_maxicount;	/* maximum inode count */
 	__uint64_t		m_resblks;	/* total reserved blocks */
 	__uint64_t		m_resblks_avail;/* available reserved blocks */
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index acf5071..446a2fc 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -17,8 +17,9 @@
  */
 #include "xfs.h"
 #include "xfs_format.h"
-#include "xfs_sb.h"
+#include "xfs_trans_resv.h"
 #include "xfs_log.h"
+#include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 9b70df3..cc824eff 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -49,629 +49,6 @@ kmem_zone_t	*xfs_trans_zone;
 kmem_zone_t	*xfs_log_item_desc_zone;
 
 /*
- * A buffer has a format structure overhead in the log in addition
- * to the data, so we need to take this into account when reserving
- * space in a transaction for a buffer.  Round the space required up
- * to a multiple of 128 bytes so that we don't change the historical
- * reservation that has been used for this overhead.
- */
-STATIC uint
-xfs_buf_log_overhead(void)
-{
-	return round_up(sizeof(struct xlog_op_header) +
-			sizeof(struct xfs_buf_log_format), 128);
-}
-
-/*
- * Calculate out transaction log reservation per item in bytes.
- *
- * The nbufs argument is used to indicate the number of items that
- * will be changed in a transaction.  size is used to tell how many
- * bytes should be reserved per item.
- */
-STATIC uint
-xfs_calc_buf_res(
-	uint		nbufs,
-	uint		size)
-{
-	return nbufs * (size + xfs_buf_log_overhead());
-}
-
-/*
- * Various log reservation values.
- *
- * These are based on the size of the file system block because that is what
- * most transactions manipulate.  Each adds in an additional 128 bytes per
- * item logged to try to account for the overhead of the transaction mechanism.
- *
- * Note:  Most of the reservations underestimate the number of allocation
- * groups into which they could free extents in the xfs_bmap_finish() call.
- * This is because the number in the worst case is quite high and quite
- * unusual.  In order to fix this we need to change xfs_bmap_finish() to free
- * extents in only a single AG at a time.  This will require changes to the
- * EFI code as well, however, so that the EFI for the extents not freed is
- * logged again in each transaction.  See SGI PV #261917.
- *
- * Reservation functions here avoid a huge stack in xfs_trans_init due to
- * register overflow from temporaries in the calculations.
- */
-
-
-/*
- * In a write transaction we can allocate a maximum of 2
- * extents.  This gives:
- *    the inode getting the new extents: inode size
- *    the inode's bmap btree: max depth * block size
- *    the agfs of the ags from which the extents are allocated: 2 * sector
- *    the superblock free block counter: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- * And the bmap_finish transaction can free bmap blocks in a join:
- *    the agfs of the ags containing the blocks: 2 * sector size
- *    the agfls of the ags containing the blocks: 2 * sector size
- *    the super block free block counter: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-STATIC uint
-xfs_calc_write_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
-		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
-}
-
-/*
- * In truncating a file we free up to two extents at once.  We can modify:
- *    the inode being truncated: inode size
- *    the inode's bmap btree: (max depth + 1) * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks:
- *    the agf for each of the ags: 4 * sector size
- *    the agfl for each of the ags: 4 * sector size
- *    the super block to reflect the freed blocks: sector size
- *    worst case split in allocation btrees per extent assuming 4 extents:
- *		4 exts * 2 trees * (2 * max depth - 1) * block size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-STATIC uint
-xfs_calc_itruncate_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
-		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 4),
-				      XFS_FSB_TO_B(mp, 1)) +
-		    xfs_calc_buf_res(5, 0) +
-		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				     XFS_FSB_TO_B(mp, 1)) +
-		    xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
-				     mp->m_in_maxlevels, 0)));
-}
-
-/*
- * In renaming a files we can modify:
- *    the four inodes involved: 4 * inode size
- *    the two directory btrees: 2 * (max depth + v2) * dir block size
- *    the two directory bmap btrees: 2 * max depth * block size
- * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
- *    the agf for the ags in which the blocks live: 3 * sector size
- *    the agfl for the ags in which the blocks live: 3 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
- */
-STATIC uint
-xfs_calc_rename_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_buf_res(4, mp->m_sb.sb_inodesize) +
-		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 3),
-				      XFS_FSB_TO_B(mp, 1))));
-}
-
-/*
- * For creating a link to an inode:
- *    the parent directory inode: inode size
- *    the linked inode: inode size
- *    the directory btree could split: (max depth + v2) * dir block size
- *    the directory bmap btree could join or split: (max depth + v2) * blocksize
- * And the bmap_finish transaction can free some bmap blocks giving:
- *    the agf for the ag in which the blocks live: sector size
- *    the agfl for the ag in which the blocks live: sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
- */
-STATIC uint
-xfs_calc_link_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
-}
-
-/*
- * For removing a directory entry we can modify:
- *    the parent directory inode: inode size
- *    the removed inode: inode size
- *    the directory btree could join: (max depth + v2) * dir block size
- *    the directory bmap btree could join or split: (max depth + v2) * blocksize
- * And the bmap_finish transaction can free the dir and bmap blocks giving:
- *    the agf for the ag in which the blocks live: 2 * sector size
- *    the agfl for the ag in which the blocks live: 2 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-STATIC uint
-xfs_calc_remove_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
-}
-
-/*
- * For create, break it in to the two cases that the transaction
- * covers. We start with the modify case - allocation done by modification
- * of the state of existing inodes - and the allocation case.
- */
-
-/*
- * For create we can modify:
- *    the parent directory inode: inode size
- *    the new inode: inode size
- *    the inode btree entry: block size
- *    the superblock for the nlink flag: sector size
- *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode's bmap btree: (max depth + v2) * block size
- */
-STATIC uint
-xfs_calc_create_resv_modify(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		(uint)XFS_FSB_TO_B(mp, 1) +
-		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
-}
-
-/*
- * For create we can allocate some inodes giving:
- *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
- *    the superblock for the nlink flag: sector size
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-STATIC uint
-xfs_calc_create_resv_alloc(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		mp->m_sb.sb_sectsize +
-		xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp), XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
-}
-
-STATIC uint
-__xfs_calc_create_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		MAX(xfs_calc_create_resv_alloc(mp),
-		    xfs_calc_create_resv_modify(mp));
-}
-
-/*
- * For icreate we can allocate some inodes giving:
- *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
- *    the superblock for the nlink flag: sector size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-STATIC uint
-xfs_calc_icreate_resv_alloc(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		mp->m_sb.sb_sectsize +
-		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
-}
-
-STATIC uint
-xfs_calc_icreate_reservation(xfs_mount_t *mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		MAX(xfs_calc_icreate_resv_alloc(mp),
-		    xfs_calc_create_resv_modify(mp));
-}
-
-STATIC uint
-xfs_calc_create_reservation(
-	struct xfs_mount	*mp)
-{
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return xfs_calc_icreate_reservation(mp);
-	return __xfs_calc_create_reservation(mp);
-
-}
-
-/*
- * Making a new directory is the same as creating a new file.
- */
-STATIC uint
-xfs_calc_mkdir_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_create_reservation(mp);
-}
-
-
-/*
- * Making a new symplink is the same as creating a new file, but
- * with the added blocks for remote symlink data which can be up to 1kB in
- * length (MAXPATHLEN).
- */
-STATIC uint
-xfs_calc_symlink_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_create_reservation(mp) +
-	       xfs_calc_buf_res(1, MAXPATHLEN);
-}
-
-/*
- * In freeing an inode we can modify:
- *    the inode being freed: inode size
- *    the super block free inode counter: sector size
- *    the agi hash list and counters: sector size
- *    the inode btree entry: block size
- *    the on disk inode before ours in the agi hash list: inode cluster size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-STATIC uint
-xfs_calc_ifree_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
-		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
-		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
-		    XFS_INODE_CLUSTER_SIZE(mp)) +
-		xfs_calc_buf_res(1, 0) +
-		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
-				 mp->m_in_maxlevels, 0) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
-}
-
-/*
- * When only changing the inode we log the inode and possibly the superblock
- * We also add a bit of slop for the transaction stuff.
- */
-STATIC uint
-xfs_calc_ichange_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		mp->m_sb.sb_inodesize +
-		mp->m_sb.sb_sectsize +
-		512;
-
-}
-
-/*
- * Growing the data section of the filesystem.
- *	superblock
- *	agi and agf
- *	allocation btrees
- */
-STATIC uint
-xfs_calc_growdata_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
-}
-
-/*
- * Growing the rt section of the filesystem.
- * In the first set of transactions (ALLOC) we allocate space to the
- * bitmap or summary files.
- *	superblock: sector size
- *	agf of the ag from which the extent is allocated: sector size
- *	bmap btree for bitmap/summary inode: max depth * blocksize
- *	bitmap/summary inode: inode size
- *	allocation btrees for 1 block alloc: 2 * (2 * maxdepth - 1) * blocksize
- */
-STATIC uint
-xfs_calc_growrtalloc_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
-				 XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
-}
-
-/*
- * Growing the rt section of the filesystem.
- * In the second set of transactions (ZERO) we zero the new metadata blocks.
- *	one bitmap/summary block: blocksize
- */
-STATIC uint
-xfs_calc_growrtzero_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_blocksize);
-}
-
-/*
- * Growing the rt section of the filesystem.
- * In the third set of transactions (FREE) we update metadata without
- * allocating any new blocks.
- *	superblock: sector size
- *	bitmap inode: inode size
- *	summary inode: inode size
- *	one bitmap block: blocksize
- *	summary blocks: new summary size
- */
-STATIC uint
-xfs_calc_growrtfree_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_blocksize) +
-		xfs_calc_buf_res(1, mp->m_rsumsize);
-}
-
-/*
- * Logging the inode modification timestamp on a synchronous write.
- *	inode
- */
-STATIC uint
-xfs_calc_swrite_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_inodesize);
-}
-
-/*
- * Logging the inode mode bits when writing a setuid/setgid file
- *	inode
- */
-STATIC uint
-xfs_calc_writeid_reservation(xfs_mount_t *mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_inodesize);
-}
-
-/*
- * Converting the inode from non-attributed to attributed.
- *	the inode being converted: inode size
- *	agf block and superblock (for block allocation)
- *	the new block (directory sized)
- *	bmap blocks for the new directory block
- *	allocation btrees
- */
-STATIC uint
-xfs_calc_addafork_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
-		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(1, mp->m_dirblksize) +
-		xfs_calc_buf_res(XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1,
-				 XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
-}
-
-/*
- * Removing the attribute fork of a file
- *    the inode being truncated: inode size
- *    the inode's bmap btree: max depth * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks:
- *    the agf for each of the ags: 4 * sector size
- *    the agfl for each of the ags: 4 * sector size
- *    the super block to reflect the freed blocks: sector size
- *    worst case split in allocation btrees per extent assuming 4 extents:
- *		4 exts * 2 trees * (2 * max depth - 1) * block size
- */
-STATIC uint
-xfs_calc_attrinval_reservation(
-	struct xfs_mount	*mp)
-{
-	return MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
-		    xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
-				     XFS_FSB_TO_B(mp, 1))),
-		   (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
-		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 4),
-				     XFS_FSB_TO_B(mp, 1))));
-}
-
-/*
- * Setting an attribute at mount time.
- *	the inode getting the attribute
- *	the superblock for allocations
- *	the agfs extents are allocated from
- *	the attribute btree * max depth
- *	the inode allocation btree
- * Since attribute transaction space is dependent on the size of the attribute,
- * the calculation is done partially at mount time and partially at runtime(see
- * below).
- */
-STATIC uint
-xfs_calc_attrsetm_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
-}
-
-/*
- * Setting an attribute at runtime, transaction space unit per block.
- * 	the superblock for allocations: sector size
- *	the inode bmap btree could join or split: max depth * block size
- * Since the runtime attribute transaction space is dependent on the total
- * blocks needed for the 1st bmap, here we calculate out the space unit for
- * one block so that the caller could figure out the total space according
- * to the attibute extent length in blocks by: ext * XFS_ATTRSETRT_LOG_RES(mp).
- */
-STATIC uint
-xfs_calc_attrsetrt_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
-				 XFS_FSB_TO_B(mp, 1));
-}
-
-/*
- * Removing an attribute.
- *    the inode: inode size
- *    the attribute btree could join: max depth * block size
- *    the inode bmap btree could join or split: max depth * block size
- * And the bmap_finish transaction can free the attr blocks freed giving:
- *    the agf for the ag in which the blocks live: 2 * sector size
- *    the agfl for the ag in which the blocks live: 2 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-STATIC uint
-xfs_calc_attrrm_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
-		     xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH,
-				      XFS_FSB_TO_B(mp, 1)) +
-		     (uint)XFS_FSB_TO_B(mp,
-					XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
-		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), 0)),
-		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
-}
-
-/*
- * Clearing a bad agino number in an agi hash bucket.
- */
-STATIC uint
-xfs_calc_clear_agi_bucket_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-}
-
-/*
- * Clearing the quotaflags in the superblock.
- *	the super block for changing quota flags: sector size
- */
-STATIC uint
-xfs_calc_qm_sbchange_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-}
-
-/*
- * Adjusting quota limits.
- *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
- */
-STATIC uint
-xfs_calc_qm_setqlim_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, sizeof(struct xfs_disk_dquot));
-}
-
-/*
- * Allocating quota on disk if needed.
- *	the write transaction log space: XFS_WRITE_LOG_RES(mp)
- *	the unit of quota allocation: one system block size
- */
-STATIC uint
-xfs_calc_qm_dqalloc_reservation(
-	struct xfs_mount	*mp)
-{
-	return XFS_WRITE_LOG_RES(mp) +
-		xfs_calc_buf_res(1,
-			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
-}
-
-/*
- * Turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
- *    the superblock for the quota flags: sector size
- */
-STATIC uint
-xfs_calc_qm_quotaoff_reservation(
-	struct xfs_mount	*mp)
-{
-	return sizeof(struct xfs_qoff_logitem) * 2 +
-		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-}
-
-/*
- * End of turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
- */
-STATIC uint
-xfs_calc_qm_quotaoff_end_reservation(
-	struct xfs_mount	*mp)
-{
-	return sizeof(struct xfs_qoff_logitem) * 2;
-}
-
-/*
- * Syncing the incore super block changes to disk.
- *     the super block to reflect the changes: sector size
- */
-STATIC uint
-xfs_calc_sb_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-}
-
-/*
  * Initialize the precomputed transaction reservation values
  * in the mount structure.
  */
@@ -679,36 +56,7 @@ void
 xfs_trans_init(
 	struct xfs_mount	*mp)
 {
-	struct xfs_trans_reservations *resp = &mp->m_reservations;
-
-	resp->tr_write = xfs_calc_write_reservation(mp);
-	resp->tr_itruncate = xfs_calc_itruncate_reservation(mp);
-	resp->tr_rename = xfs_calc_rename_reservation(mp);
-	resp->tr_link = xfs_calc_link_reservation(mp);
-	resp->tr_remove = xfs_calc_remove_reservation(mp);
-	resp->tr_symlink = xfs_calc_symlink_reservation(mp);
-	resp->tr_create = xfs_calc_create_reservation(mp);
-	resp->tr_mkdir = xfs_calc_mkdir_reservation(mp);
-	resp->tr_ifree = xfs_calc_ifree_reservation(mp);
-	resp->tr_ichange = xfs_calc_ichange_reservation(mp);
-	resp->tr_growdata = xfs_calc_growdata_reservation(mp);
-	resp->tr_swrite = xfs_calc_swrite_reservation(mp);
-	resp->tr_writeid = xfs_calc_writeid_reservation(mp);
-	resp->tr_addafork = xfs_calc_addafork_reservation(mp);
-	resp->tr_attrinval = xfs_calc_attrinval_reservation(mp);
-	resp->tr_attrsetm = xfs_calc_attrsetm_reservation(mp);
-	resp->tr_attrsetrt = xfs_calc_attrsetrt_reservation(mp);
-	resp->tr_attrrm = xfs_calc_attrrm_reservation(mp);
-	resp->tr_clearagi = xfs_calc_clear_agi_bucket_reservation(mp);
-	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
-	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
-	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
-	resp->tr_qm_sbchange = xfs_calc_qm_sbchange_reservation(mp);
-	resp->tr_qm_setqlim = xfs_calc_qm_setqlim_reservation(mp);
-	resp->tr_qm_dqalloc = xfs_calc_qm_dqalloc_reservation(mp);
-	resp->tr_qm_quotaoff = xfs_calc_qm_quotaoff_reservation(mp);
-	resp->tr_qm_equotaoff = xfs_calc_qm_quotaoff_end_reservation(mp);
-	resp->tr_sb = xfs_calc_sb_reservation(mp);
+	xfs_trans_resv_calc(mp, &mp->m_reservations);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 772d5ae..b5dc61e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -20,80 +20,9 @@
 
 struct xfs_log_item;
 
-/*
- * Per-extent log reservation for the allocation btree changes
- * involved in freeing or allocating an extent.
- * 2 trees * (2 blocks/level * max depth - 1)
- */
-#define	XFS_ALLOCFREE_LOG_COUNT(mp,nx) \
-	((nx) * (2 * (2 * XFS_AG_MAXLEVELS(mp) - 1)))
+#include "xfs_trans_resv.h"
 
-/*
- * Per-directory log reservation for any directory change.
- * dir blocks: (1 btree block per level + data block + free block)
- * bmap btree: (levels + 2) * max depth
- * v2 directory blocks can be fragmented below the dirblksize down to the fsb
- * size, so account for that in the DAENTER macros.
- */
-#define	XFS_DIROP_LOG_COUNT(mp)	\
-	(XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK) + \
-	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
-
-
-#define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write)
-#define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate)
-#define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename)
-#define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link)
-#define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove)
-#define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink)
-#define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create)
-#define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir)
-#define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree)
-#define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange)
-#define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata)
-#define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc)
-#define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero)
-#define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree)
-#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
-/*
- * Logging the inode timestamps on an fsync -- same as SWRITE
- * as long as SWRITE logs the entire inode core
- */
-#define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
-#define	XFS_WRITEID_LOG_RES(mp)		((mp)->m_reservations.tr_swrite)
-#define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
-#define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
-#define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm)
-#define	XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
-#define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm)
-#define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
-#define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
-#define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
-#define XFS_QM_DQALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_qm_dqalloc)
-#define XFS_QM_QUOTAOFF_LOG_RES(mp)	((mp)->m_reservations.tr_qm_quotaoff)
-#define XFS_QM_QUOTAOFF_END_LOG_RES(mp)	((mp)->m_reservations.tr_qm_equotaoff)
-#define XFS_SB_LOG_RES(mp)		((mp)->m_reservations.tr_sb)
-
-/*
- * Various log count values.
- */
-#define	XFS_DEFAULT_LOG_COUNT		1
-#define	XFS_DEFAULT_PERM_LOG_COUNT	2
-#define	XFS_ITRUNCATE_LOG_COUNT		2
-#define XFS_INACTIVE_LOG_COUNT		2
-#define	XFS_CREATE_LOG_COUNT		2
-#define	XFS_MKDIR_LOG_COUNT		3
-#define	XFS_SYMLINK_LOG_COUNT		3
-#define	XFS_REMOVE_LOG_COUNT		2
-#define	XFS_LINK_LOG_COUNT		2
-#define	XFS_RENAME_LOG_COUNT		2
-#define	XFS_WRITE_LOG_COUNT		2
-#define	XFS_ADDAFORK_LOG_COUNT		2
-#define	XFS_ATTRINVAL_LOG_COUNT		1
-#define	XFS_ATTRSET_LOG_COUNT		3
-#define	XFS_ATTRRM_LOG_COUNT		3
-
-#ifdef __KERNEL__
+/* kernel only transaction subsystem defines */
 
 struct xfs_buf;
 struct xfs_buftarg;
@@ -323,6 +252,4 @@ void		xfs_trans_ail_destroy(struct xfs_mount *);
 extern kmem_zone_t	*xfs_trans_zone;
 extern kmem_zone_t	*xfs_log_item_desc_zone;
 
-#endif	/* __KERNEL__ */
-
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
new file mode 100644
index 0000000..5a1537e
--- /dev/null
+++ b/fs/xfs/xfs_trans_resv.c
@@ -0,0 +1,701 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (C) 2010 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log.h"
+#include "xfs_trans_resv.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_error.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_alloc.h"
+#include "xfs_extent_busy.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "xfs_qm.h"
+#include "xfs_trans_space.h"
+#include "xfs_trace.h"
+
+/*
+ * A buffer has a format structure overhead in the log in addition
+ * to the data, so we need to take this into account when reserving
+ * space in a transaction for a buffer.  Round the space required up
+ * to a multiple of 128 bytes so that we don't change the historical
+ * reservation that has been used for this overhead.
+ */
+STATIC uint
+xfs_buf_log_overhead(void)
+{
+	return round_up(sizeof(struct xlog_op_header) +
+			sizeof(struct xfs_buf_log_format), 128);
+}
+
+/*
+ * Calculate out transaction log reservation per item in bytes.
+ *
+ * The nbufs argument is used to indicate the number of items that
+ * will be changed in a transaction.  size is used to tell how many
+ * bytes should be reserved per item.
+ */
+STATIC uint
+xfs_calc_buf_res(
+	uint		nbufs,
+	uint		size)
+{
+	return nbufs * (size + xfs_buf_log_overhead());
+}
+
+/*
+ * Various log reservation values.
+ *
+ * These are based on the size of the file system block because that is what
+ * most transactions manipulate.  Each adds in an additional 128 bytes per
+ * item logged to try to account for the overhead of the transaction mechanism.
+ *
+ * Note:  Most of the reservations underestimate the number of allocation
+ * groups into which they could free extents in the xfs_bmap_finish() call.
+ * This is because the number in the worst case is quite high and quite
+ * unusual.  In order to fix this we need to change xfs_bmap_finish() to free
+ * extents in only a single AG at a time.  This will require changes to the
+ * EFI code as well, however, so that the EFI for the extents not freed is
+ * logged again in each transaction.  See SGI PV #261917.
+ *
+ * Reservation functions here avoid a huge stack in xfs_trans_init due to
+ * register overflow from temporaries in the calculations.
+ */
+
+
+/*
+ * In a write transaction we can allocate a maximum of 2
+ * extents.  This gives:
+ *    the inode getting the new extents: inode size
+ *    the inode's bmap btree: max depth * block size
+ *    the agfs of the ags from which the extents are allocated: 2 * sector
+ *    the superblock free block counter: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ * And the bmap_finish transaction can free bmap blocks in a join:
+ *    the agfs of the ags containing the blocks: 2 * sector size
+ *    the agfls of the ags containing the blocks: 2 * sector size
+ *    the super block free block counter: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_write_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
+				      XFS_FSB_TO_B(mp, 1)) +
+		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+				      XFS_FSB_TO_B(mp, 1))));
+}
+
+/*
+ * In truncating a file we free up to two extents at once.  We can modify:
+ *    the inode being truncated: inode size
+ *    the inode's bmap btree: (max depth + 1) * block size
+ * And the bmap_finish transaction can free the blocks and bmap blocks:
+ *    the agf for each of the ags: 4 * sector size
+ *    the agfl for each of the ags: 4 * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    worst case split in allocation btrees per extent assuming 4 extents:
+ *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_itruncate_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 4),
+				      XFS_FSB_TO_B(mp, 1)) +
+		    xfs_calc_buf_res(5, 0) +
+		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				     XFS_FSB_TO_B(mp, 1)) +
+		    xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
+				     mp->m_in_maxlevels, 0)));
+}
+
+/*
+ * In renaming a files we can modify:
+ *    the four inodes involved: 4 * inode size
+ *    the two directory btrees: 2 * (max depth + v2) * dir block size
+ *    the two directory bmap btrees: 2 * max depth * block size
+ * And the bmap_finish transaction can free dir and bmap blocks (two sets
+ *	of bmap blocks) giving:
+ *    the agf for the ags in which the blocks live: 3 * sector size
+ *    the agfl for the ags in which the blocks live: 3 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_rename_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((xfs_calc_buf_res(4, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 3),
+				      XFS_FSB_TO_B(mp, 1))));
+}
+
+/*
+ * For creating a link to an inode:
+ *    the parent directory inode: inode size
+ *    the linked inode: inode size
+ *    the directory btree could split: (max depth + v2) * dir block size
+ *    the directory bmap btree could join or split: (max depth + v2) * blocksize
+ * And the bmap_finish transaction can free some bmap blocks giving:
+ *    the agf for the ag in which the blocks live: sector size
+ *    the agfl for the ag in which the blocks live: sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_link_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				      XFS_FSB_TO_B(mp, 1))));
+}
+
+/*
+ * For removing a directory entry we can modify:
+ *    the parent directory inode: inode size
+ *    the removed inode: inode size
+ *    the directory btree could join: (max depth + v2) * dir block size
+ *    the directory bmap btree could join or split: (max depth + v2) * blocksize
+ * And the bmap_finish transaction can free the dir and bmap blocks giving:
+ *    the agf for the ag in which the blocks live: 2 * sector size
+ *    the agfl for the ag in which the blocks live: 2 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_remove_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+				      XFS_FSB_TO_B(mp, 1))));
+}
+
+/*
+ * For create, break it in to the two cases that the transaction
+ * covers. We start with the modify case - allocation done by modification
+ * of the state of existing inodes - and the allocation case.
+ */
+
+/*
+ * For create we can modify:
+ *    the parent directory inode: inode size
+ *    the new inode: inode size
+ *    the inode btree entry: block size
+ *    the superblock for the nlink flag: sector size
+ *    the directory btree: (max depth + v2) * dir block size
+ *    the directory inode's bmap btree: (max depth + v2) * block size
+ */
+STATIC uint
+xfs_calc_create_resv_modify(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		(uint)XFS_FSB_TO_B(mp, 1) +
+		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * For create we can allocate some inodes giving:
+ *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the superblock for the nlink flag: sector size
+ *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_create_resv_alloc(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		mp->m_sb.sb_sectsize +
+		xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp), XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+STATIC uint
+__xfs_calc_create_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX(xfs_calc_create_resv_alloc(mp),
+		    xfs_calc_create_resv_modify(mp));
+}
+
+/*
+ * For icreate we can allocate some inodes giving:
+ *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the superblock for the nlink flag: sector size
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_icreate_resv_alloc(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		mp->m_sb.sb_sectsize +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+STATIC uint
+xfs_calc_icreate_reservation(xfs_mount_t *mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX(xfs_calc_icreate_resv_alloc(mp),
+		    xfs_calc_create_resv_modify(mp));
+}
+
+STATIC uint
+xfs_calc_create_reservation(
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return xfs_calc_icreate_reservation(mp);
+	return __xfs_calc_create_reservation(mp);
+
+}
+
+/*
+ * Making a new directory is the same as creating a new file.
+ */
+STATIC uint
+xfs_calc_mkdir_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_create_reservation(mp);
+}
+
+
+/*
+ * Making a new symplink is the same as creating a new file, but
+ * with the added blocks for remote symlink data which can be up to 1kB in
+ * length (MAXPATHLEN).
+ */
+STATIC uint
+xfs_calc_symlink_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_create_reservation(mp) +
+	       xfs_calc_buf_res(1, MAXPATHLEN);
+}
+
+/*
+ * In freeing an inode we can modify:
+ *    the inode being freed: inode size
+ *    the super block free inode counter: sector size
+ *    the agi hash list and counters: sector size
+ *    the inode btree entry: block size
+ *    the on disk inode before ours in the agi hash list: inode cluster size
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_ifree_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
+		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
+		    XFS_INODE_CLUSTER_SIZE(mp)) +
+		xfs_calc_buf_res(1, 0) +
+		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
+				 mp->m_in_maxlevels, 0) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * When only changing the inode we log the inode and possibly the superblock
+ * We also add a bit of slop for the transaction stuff.
+ */
+STATIC uint
+xfs_calc_ichange_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize +
+		512;
+
+}
+
+/*
+ * Growing the data section of the filesystem.
+ *	superblock
+ *	agi and agf
+ *	allocation btrees
+ */
+STATIC uint
+xfs_calc_growdata_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * Growing the rt section of the filesystem.
+ * In the first set of transactions (ALLOC) we allocate space to the
+ * bitmap or summary files.
+ *	superblock: sector size
+ *	agf of the ag from which the extent is allocated: sector size
+ *	bmap btree for bitmap/summary inode: max depth * blocksize
+ *	bitmap/summary inode: inode size
+ *	allocation btrees for 1 block alloc: 2 * (2 * maxdepth - 1) * blocksize
+ */
+STATIC uint
+xfs_calc_growrtalloc_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * Growing the rt section of the filesystem.
+ * In the second set of transactions (ZERO) we zero the new metadata blocks.
+ *	one bitmap/summary block: blocksize
+ */
+STATIC uint
+xfs_calc_growrtzero_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_blocksize);
+}
+
+/*
+ * Growing the rt section of the filesystem.
+ * In the third set of transactions (FREE) we update metadata without
+ * allocating any new blocks.
+ *	superblock: sector size
+ *	bitmap inode: inode size
+ *	summary inode: inode size
+ *	one bitmap block: blocksize
+ *	summary blocks: new summary size
+ */
+STATIC uint
+xfs_calc_growrtfree_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_blocksize) +
+		xfs_calc_buf_res(1, mp->m_rsumsize);
+}
+
+/*
+ * Logging the inode modification timestamp on a synchronous write.
+ *	inode
+ */
+STATIC uint
+xfs_calc_swrite_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_inodesize);
+}
+
+/*
+ * Logging the inode mode bits when writing a setuid/setgid file
+ *	inode
+ */
+STATIC uint
+xfs_calc_writeid_reservation(xfs_mount_t *mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_inodesize);
+}
+
+/*
+ * Converting the inode from non-attributed to attributed.
+ *	the inode being converted: inode size
+ *	agf block and superblock (for block allocation)
+ *	the new block (directory sized)
+ *	bmap blocks for the new directory block
+ *	allocation btrees
+ */
+STATIC uint
+xfs_calc_addafork_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(1, mp->m_dirblksize) +
+		xfs_calc_buf_res(XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1,
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * Removing the attribute fork of a file
+ *    the inode being truncated: inode size
+ *    the inode's bmap btree: max depth * block size
+ * And the bmap_finish transaction can free the blocks and bmap blocks:
+ *    the agf for each of the ags: 4 * sector size
+ *    the agfl for each of the ags: 4 * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    worst case split in allocation btrees per extent assuming 4 extents:
+ *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_attrinval_reservation(
+	struct xfs_mount	*mp)
+{
+	return MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		    xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
+				     XFS_FSB_TO_B(mp, 1))),
+		   (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
+		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 4),
+				     XFS_FSB_TO_B(mp, 1))));
+}
+
+/*
+ * Setting an attribute at mount time.
+ *	the inode getting the attribute
+ *	the superblock for allocations
+ *	the agfs extents are allocated from
+ *	the attribute btree * max depth
+ *	the inode allocation btree
+ * Since attribute transaction space is dependent on the size of the attribute,
+ * the calculation is done partially at mount time and partially at runtime(see
+ * below).
+ */
+STATIC uint
+xfs_calc_attrsetm_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * Setting an attribute at runtime, transaction space unit per block.
+ * 	the superblock for allocations: sector size
+ *	the inode bmap btree could join or split: max depth * block size
+ * Since the runtime attribute transaction space is dependent on the total
+ * blocks needed for the 1st bmap, here we calculate out the space unit for
+ * one block so that the caller could figure out the total space according
+ * to the attibute extent length in blocks by: ext * XFS_ATTRSETRT_LOG_RES(mp).
+ */
+STATIC uint
+xfs_calc_attrsetrt_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * Removing an attribute.
+ *    the inode: inode size
+ *    the attribute btree could join: max depth * block size
+ *    the inode bmap btree could join or split: max depth * block size
+ * And the bmap_finish transaction can free the attr blocks freed giving:
+ *    the agf for the ag in which the blocks live: 2 * sector size
+ *    the agfl for the ag in which the blocks live: 2 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_attrrm_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH,
+				      XFS_FSB_TO_B(mp, 1)) +
+		     (uint)XFS_FSB_TO_B(mp,
+					XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
+		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), 0)),
+		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+				      XFS_FSB_TO_B(mp, 1))));
+}
+
+/*
+ * Clearing a bad agino number in an agi hash bucket.
+ */
+STATIC uint
+xfs_calc_clear_agi_bucket_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+}
+
+/*
+ * Clearing the quotaflags in the superblock.
+ *	the super block for changing quota flags: sector size
+ */
+STATIC uint
+xfs_calc_qm_sbchange_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+}
+
+/*
+ * Adjusting quota limits.
+ *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
+ */
+STATIC uint
+xfs_calc_qm_setqlim_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, sizeof(struct xfs_disk_dquot));
+}
+
+/*
+ * Allocating quota on disk if needed.
+ *	the write transaction log space: XFS_WRITE_LOG_RES(mp)
+ *	the unit of quota allocation: one system block size
+ */
+STATIC uint
+xfs_calc_qm_dqalloc_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_WRITE_LOG_RES(mp) +
+		xfs_calc_buf_res(1,
+			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
+}
+
+/*
+ * Turning off quotas.
+ *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    the superblock for the quota flags: sector size
+ */
+STATIC uint
+xfs_calc_qm_quotaoff_reservation(
+	struct xfs_mount	*mp)
+{
+	return sizeof(struct xfs_qoff_logitem) * 2 +
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+}
+
+/*
+ * End of turning off quotas.
+ *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ */
+STATIC uint
+xfs_calc_qm_quotaoff_end_reservation(
+	struct xfs_mount	*mp)
+{
+	return sizeof(struct xfs_qoff_logitem) * 2;
+}
+
+/*
+ * Syncing the incore super block changes to disk.
+ *     the super block to reflect the changes: sector size
+ */
+STATIC uint
+xfs_calc_sb_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+}
+
+void
+xfs_trans_resv_calc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	resp->tr_write = xfs_calc_write_reservation(mp);
+	resp->tr_itruncate = xfs_calc_itruncate_reservation(mp);
+	resp->tr_rename = xfs_calc_rename_reservation(mp);
+	resp->tr_link = xfs_calc_link_reservation(mp);
+	resp->tr_remove = xfs_calc_remove_reservation(mp);
+	resp->tr_symlink = xfs_calc_symlink_reservation(mp);
+	resp->tr_create = xfs_calc_create_reservation(mp);
+	resp->tr_mkdir = xfs_calc_mkdir_reservation(mp);
+	resp->tr_ifree = xfs_calc_ifree_reservation(mp);
+	resp->tr_ichange = xfs_calc_ichange_reservation(mp);
+	resp->tr_growdata = xfs_calc_growdata_reservation(mp);
+	resp->tr_swrite = xfs_calc_swrite_reservation(mp);
+	resp->tr_writeid = xfs_calc_writeid_reservation(mp);
+	resp->tr_addafork = xfs_calc_addafork_reservation(mp);
+	resp->tr_attrinval = xfs_calc_attrinval_reservation(mp);
+	resp->tr_attrsetm = xfs_calc_attrsetm_reservation(mp);
+	resp->tr_attrsetrt = xfs_calc_attrsetrt_reservation(mp);
+	resp->tr_attrrm = xfs_calc_attrrm_reservation(mp);
+	resp->tr_clearagi = xfs_calc_clear_agi_bucket_reservation(mp);
+	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
+	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
+	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
+	resp->tr_qm_sbchange = xfs_calc_qm_sbchange_reservation(mp);
+	resp->tr_qm_setqlim = xfs_calc_qm_setqlim_reservation(mp);
+	resp->tr_qm_dqalloc = xfs_calc_qm_dqalloc_reservation(mp);
+	resp->tr_qm_quotaoff = xfs_calc_qm_quotaoff_reservation(mp);
+	resp->tr_qm_equotaoff = xfs_calc_qm_quotaoff_end_reservation(mp);
+	resp->tr_sb = xfs_calc_sb_reservation(mp);
+}
diff --git a/fs/xfs/xfs_trans_resv.h b/fs/xfs/xfs_trans_resv.h
new file mode 100644
index 0000000..cc8260e
--- /dev/null
+++ b/fs/xfs/xfs_trans_resv.h
@@ -0,0 +1,137 @@
+/*
+ * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef	__XFS_TRANS_RESV_H__
+#define	__XFS_TRANS_RESV_H__
+
+struct xfs_mount;
+
+/*
+ * structure for maintaining pre-calculated transaction reservations.
+ */
+struct xfs_trans_resv {
+	uint	tr_write;	/* extent alloc trans */
+	uint	tr_itruncate;	/* truncate trans */
+	uint	tr_rename;	/* rename trans */
+	uint	tr_link;	/* link trans */
+	uint	tr_remove;	/* unlink trans */
+	uint	tr_symlink;	/* symlink trans */
+	uint	tr_create;	/* create trans */
+	uint	tr_mkdir;	/* mkdir trans */
+	uint	tr_ifree;	/* inode free trans */
+	uint	tr_ichange;	/* inode update trans */
+	uint	tr_growdata;	/* fs data section grow trans */
+	uint	tr_swrite;	/* sync write inode trans */
+	uint	tr_addafork;	/* cvt inode to attributed trans */
+	uint	tr_writeid;	/* write setuid/setgid file */
+	uint	tr_attrinval;	/* attr fork buffer invalidation */
+	uint	tr_attrsetm;	/* set/create an attribute at mount time */
+	uint	tr_attrsetrt;	/* set/create an attribute at runtime */
+	uint	tr_attrrm;	/* remove an attribute */
+	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
+	uint	tr_growrtalloc;	/* grow realtime allocations */
+	uint	tr_growrtzero;	/* grow realtime zeroing */
+	uint	tr_growrtfree;	/* grow realtime freeing */
+	uint	tr_qm_sbchange;	/* change quota flags */
+	uint	tr_qm_setqlim;	/* adjust quota limits */
+	uint	tr_qm_dqalloc;	/* allocate quota on disk */
+	uint	tr_qm_quotaoff;	/* turn quota off */
+	uint	tr_qm_equotaoff;/* end of turn quota off */
+	uint	tr_sb;		/* modify superblock */
+};
+
+/*
+ * Per-extent log reservation for the allocation btree changes
+ * involved in freeing or allocating an extent.
+ * 2 trees * (2 blocks/level * max depth - 1) * block size
+ */
+#define	XFS_ALLOCFREE_LOG_RES(mp,nx) \
+	((nx) * (2 * XFS_FSB_TO_B((mp), 2 * XFS_AG_MAXLEVELS(mp) - 1)))
+#define	XFS_ALLOCFREE_LOG_COUNT(mp,nx) \
+	((nx) * (2 * (2 * XFS_AG_MAXLEVELS(mp) - 1)))
+
+/*
+ * Per-directory log reservation for any directory change.
+ * dir blocks: (1 btree block per level + data block + free block) * dblock size
+ * bmap btree: (levels + 2) * max depth * block size
+ * v2 directory blocks can be fragmented below the dirblksize down to the fsb
+ * size, so account for that in the DAENTER macros.
+ */
+#define	XFS_DIROP_LOG_RES(mp)	\
+	(XFS_FSB_TO_B(mp, XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK)) + \
+	 (XFS_FSB_TO_B(mp, XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)))
+#define	XFS_DIROP_LOG_COUNT(mp)	\
+	(XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK) + \
+	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
+
+
+#define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write)
+#define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate)
+#define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename)
+#define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link)
+#define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove)
+#define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink)
+#define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create)
+#define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir)
+#define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree)
+#define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange)
+#define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata)
+#define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc)
+#define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero)
+#define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree)
+#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
+/*
+ * Logging the inode timestamps on an fsync -- same as SWRITE
+ * as long as SWRITE logs the entire inode core
+ */
+#define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
+#define	XFS_WRITEID_LOG_RES(mp)		((mp)->m_reservations.tr_swrite)
+#define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
+#define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
+#define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm)
+#define	XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
+#define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm)
+#define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
+#define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
+#define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
+#define XFS_QM_DQALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_qm_dqalloc)
+#define XFS_QM_QUOTAOFF_LOG_RES(mp)	((mp)->m_reservations.tr_qm_quotaoff)
+#define XFS_QM_QUOTAOFF_END_LOG_RES(mp)	((mp)->m_reservations.tr_qm_equotaoff)
+#define XFS_SB_LOG_RES(mp)		((mp)->m_reservations.tr_sb)
+
+/*
+ * Various log count values.
+ */
+#define	XFS_DEFAULT_LOG_COUNT		1
+#define	XFS_DEFAULT_PERM_LOG_COUNT	2
+#define	XFS_ITRUNCATE_LOG_COUNT		2
+#define XFS_INACTIVE_LOG_COUNT		2
+#define	XFS_CREATE_LOG_COUNT		2
+#define	XFS_MKDIR_LOG_COUNT		3
+#define	XFS_SYMLINK_LOG_COUNT		3
+#define	XFS_REMOVE_LOG_COUNT		2
+#define	XFS_LINK_LOG_COUNT		2
+#define	XFS_RENAME_LOG_COUNT		2
+#define	XFS_WRITE_LOG_COUNT		2
+#define	XFS_ADDAFORK_LOG_COUNT		2
+#define	XFS_ATTRINVAL_LOG_COUNT		1
+#define	XFS_ATTRSET_LOG_COUNT		3
+#define	XFS_ATTRRM_LOG_COUNT		3
+
+void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
+
+#endif	/* __XFS_TRANS_RESV_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
