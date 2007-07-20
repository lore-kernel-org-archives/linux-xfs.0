Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 21:12:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K4C1bm027745
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 21:12:02 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 412821801056F
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 23:12:03 -0500 (CDT)
Message-ID: <46A03612.6030806@sandeen.net>
Date: Thu, 19 Jul 2007 23:12:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/7] - remove m_nreadaheads
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Dave pointed this out...

m_nreadaheads in the mount struct is never used;
remove it and the various macros assigned to it.

Also remove a couple other unused macros in the same areas.

Removes one user of xfs_physmem.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/linux-2.4/xfs_lrw.h
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_lrw.h
+++ linux/fs/xfs/linux-2.4/xfs_lrw.h
@@ -69,11 +69,6 @@ extern void xfs_inval_cached_trace(struc
 #define xfs_inval_cached_trace(io, offset, len, first, last)
 #endif
 
-/*
- * Maximum count of bmaps used by read and write paths.
- */
-#define	XFS_MAX_RW_NBMAPS	4
-
 extern int xfs_bmap(struct bhv_desc *, xfs_off_t, ssize_t, int,
 			struct xfs_iomap *, int *);
 extern int xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
Index: linux/fs/xfs/linux-2.6/xfs_lrw.h
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_lrw.h
+++ linux/fs/xfs/linux-2.6/xfs_lrw.h
@@ -71,11 +71,6 @@ extern void xfs_inval_cached_trace(struc
 #define xfs_inval_cached_trace(io, offset, len, first, last)
 #endif
 
-/*
- * Maximum count of bmaps used by read and write paths.
- */
-#define	XFS_MAX_RW_NBMAPS	4
-
 extern int xfs_bmap(struct bhv_desc *, xfs_off_t, ssize_t, int,
 			struct xfs_iomap *, int *);
 extern int xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
Index: linux/fs/xfs/xfs_mount.c
===================================================================
--- linux.orig/fs/xfs/xfs_mount.c
+++ linux/fs/xfs/xfs_mount.c
@@ -871,16 +871,6 @@ xfs_mountfs(
 		writeio_log = mp->m_writeio_log;
 	}
 
-	/*
-	 * Set the number of readahead buffers to use based on
-	 * physical memory size.
-	 */
-	if (xfs_physmem <= 4096)		/* <= 16MB */
-		mp->m_nreadaheads = XFS_RW_NREADAHEAD_16MB;
-	else if (xfs_physmem <= 8192)	/* <= 32MB */
-		mp->m_nreadaheads = XFS_RW_NREADAHEAD_32MB;
-	else
-		mp->m_nreadaheads = XFS_RW_NREADAHEAD_K32;
 	if (sbp->sb_blocklog > readio_log) {
 		mp->m_readio_log = sbp->sb_blocklog;
 	} else {
Index: linux/fs/xfs/xfs_mount.h
===================================================================
--- linux.orig/fs/xfs/xfs_mount.h
+++ linux/fs/xfs/xfs_mount.h
@@ -362,7 +362,6 @@ typedef struct xfs_mount {
 	__uint8_t		m_blkbb_log;	/* blocklog - BBSHIFT */
 	__uint8_t		m_agno_log;	/* log #ag's */
 	__uint8_t		m_agino_log;	/* #bits for agino in inum */
-	__uint8_t		m_nreadaheads;	/* #readahead buffers */
 	__uint16_t		m_inode_cluster_size;/* min inode buf size */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
Index: linux/fs/xfs/xfs_rw.h
===================================================================
--- linux.orig/fs/xfs/xfs_rw.h
+++ linux/fs/xfs/xfs_rw.h
@@ -23,32 +23,6 @@ struct xfs_inode;
 struct xfs_mount;
 
 /*
- * Maximum count of bmaps used by read and write paths.
- */
-#define	XFS_MAX_RW_NBMAPS	4
-
-/*
- * Counts of readahead buffers to use based on physical memory size.
- * None of these should be more than XFS_MAX_RW_NBMAPS.
- */
-#define	XFS_RW_NREADAHEAD_16MB	2
-#define	XFS_RW_NREADAHEAD_32MB	3
-#define	XFS_RW_NREADAHEAD_K32	4
-#define	XFS_RW_NREADAHEAD_K64	4
-
-/*
- * Maximum size of a buffer that we\'ll map.  Making this
- * too big will degrade performance due to the number of
- * pages which need to be gathered.  Making it too small
- * will prevent us from doing large I/O\'s to hardware that
- * needs it.
- *
- * This is currently set to 512 KB.
- */
-#define	XFS_MAX_BMAP_LEN_BB	1024
-#define	XFS_MAX_BMAP_LEN_BYTES	524288
-
-/*
  * Convert the given file system block to a disk block.
  * We have to treat it differently based on whether the
  * file is a real time file or not, because the bmap code
Index: linux/fs/xfs/xfsidbg.c
===================================================================
--- linux.orig/fs/xfs/xfsidbg.c
+++ linux/fs/xfs/xfsidbg.c
@@ -6702,9 +6702,8 @@ xfsidbg_xmount(xfs_mount_t *mp)
 	kdb_printf("dircook_elog %d blkbit_log %d blkbb_log %d agno_log %d\n",
 		mp->m_dircook_elog, mp->m_blkbit_log, mp->m_blkbb_log,
 		mp->m_agno_log);
-	kdb_printf("agino_log %d nreadaheads %d inode cluster size %d\n",
-		mp->m_agino_log, mp->m_nreadaheads,
-		mp->m_inode_cluster_size);
+	kdb_printf("agino_log %d inode cluster size %d\n",
+		mp->m_agino_log, mp->m_inode_cluster_size);
 	kdb_printf("blockmask 0x%x blockwsize 0x%x blockwmask 0x%x\n",
 		mp->m_blockmask, mp->m_blockwsize, mp->m_blockwmask);
 	kdb_printf("alloc_mxr[lf,nd] %d %d alloc_mnr[lf,nd] %d %d\n",
