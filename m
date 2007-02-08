Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Feb 2007 19:04:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l18349m7010660
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 19:04:10 -0800
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l181Vfn7006818
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 20:31:41 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l181Vft8017243
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 20:31:41 -0500
Received: from [127.0.0.1] (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l181Ve3p019859
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 20:31:40 -0500
Message-ID: <45CA7D7B.3060307@redhat.com>
Date: Wed, 07 Feb 2007 19:31:39 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] don't special-case 32MB machines
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This one may be a bit silly, but:

All the special cases for 32MB machines probably aren't so useful anymore...

Or maybe this points to the need to bump up the scaling points & sizes a bit?

Also remove duplicate, unused XFS_MAX_RW_NBMAPS definitions in linux subdirs.

 linux-2.4/xfs_lrw.h |    5 -----
 linux-2.6/xfs_lrw.h |    5 -----
 xfs_log.c           |   18 ++++--------------
 xfs_mount.c         |   11 +++--------
 xfs_rw.h            |    9 ---------
 5 files changed, 7 insertions(+), 41 deletions(-)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/xfs_log.c
===================================================================
--- linux.orig/fs/xfs/xfs_log.c
+++ linux/fs/xfs/xfs_log.c
@@ -1012,10 +1012,7 @@ xlog_bdstrat_cb(struct xfs_buf *bp)
 /*
  * Return size of each in-core log record buffer.
  *
- * Low memory machines only get 2 16KB buffers.  We don't want to waste
- * memory here.  However, all other machines get at least 2 32KB buffers.
- * The number is hard coded because we don't care about the minimum
- * memory size, just 32MB systems.
+ * All machines get at least 2 32KB buffers.
  *
  * If the filesystem blocksize is too large, we may need to choose a
  * larger size since the directory code currently logs entire blocks.
@@ -1070,17 +1067,10 @@ xlog_get_iclog_buffer_size(xfs_mount_t	*
 	}
 
 	/*
-	 * Special case machines that have less than 32MB of memory.
-	 * All machines with more memory use 32KB buffers.
+	 * All machines use 32KB buffers.
 	 */
-	if (xfs_physmem <= btoc(32*1024*1024)) {
-		/* Don't change; min configuration */
-		log->l_iclog_size = XLOG_RECORD_BSIZE;		/* 16k */
-		log->l_iclog_size_log = XLOG_RECORD_BSHIFT;
-	} else {
-		log->l_iclog_size = XLOG_BIG_RECORD_BSIZE;	/* 32k */
-		log->l_iclog_size_log = XLOG_BIG_RECORD_BSHIFT;
-	}
+	log->l_iclog_size = XLOG_BIG_RECORD_BSIZE;	/* 32k */
+	log->l_iclog_size_log = XLOG_BIG_RECORD_BSHIFT;
 
 	/* the default log size is 16k or 32k which is one header sector */
 	log->l_iclog_hsize = BBSIZE;
Index: linux/fs/xfs/xfs_mount.c
===================================================================
--- linux.orig/fs/xfs/xfs_mount.c
+++ linux/fs/xfs/xfs_mount.c
@@ -802,15 +802,10 @@ xfs_mountfs(
 	}
 
 	/*
-	 * Set the number of readahead buffers to use based on
-	 * physical memory size.
+	 * Set the number of readahead buffers to use.
 	 */
-	if (xfs_physmem <= 4096)		/* <= 16MB */
-		mp->m_nreadaheads = XFS_RW_NREADAHEAD_16MB;
-	else if (xfs_physmem <= 8192)	/* <= 32MB */
-		mp->m_nreadaheads = XFS_RW_NREADAHEAD_32MB;
-	else
-		mp->m_nreadaheads = XFS_RW_NREADAHEAD_K32;
+	mp->m_nreadaheads = XFS_MAX_RW_NBMAPS;
+
 	if (sbp->sb_blocklog > readio_log) {
 		mp->m_readio_log = sbp->sb_blocklog;
 	} else {
Index: linux/fs/xfs/xfs_rw.h
===================================================================
--- linux.orig/fs/xfs/xfs_rw.h
+++ linux/fs/xfs/xfs_rw.h
@@ -28,15 +28,6 @@ struct xfs_mount;
 #define	XFS_MAX_RW_NBMAPS	4
 
 /*
- * Counts of readahead buffers to use based on physical memory size.
- * None of these should be more than XFS_MAX_RW_NBMAPS.
- */
-#define	XFS_RW_NREADAHEAD_16MB	2
-#define	XFS_RW_NREADAHEAD_32MB	3
-#define	XFS_RW_NREADAHEAD_K32	4
-#define	XFS_RW_NREADAHEAD_K64	4
-
-/*
  * Maximum size of a buffer that we\'ll map.  Making this
  * too big will degrade performance due to the number of
  * pages which need to be gathered.  Making it too small

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
