Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBA8fDil205183 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 02:41:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 717C9160F98E
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id J8n7knZmSKLWXGHM for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PQyZC-0006Om-8o
	for xfs@oss.sgi.com; Fri, 10 Dec 2010 08:43:02 +0000
Message-Id: <20101210084302.229951279@bombadil.infradead.org>
Date: Fri, 10 Dec 2010 03:42:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/10] xfs: cleanup the xfs_iomap_write_* helpers
References: <20101210084215.259628825@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-iomap-helpers
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

Remove passing the BMAPI_* flags to these helpers, in xfs_iomap_write_direct
the check BMAPI_DIRECT was always true, and in the xfs_iomap_write_delay
path is was never checked at all.  Remove the nmap return value as
we never make use of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-11-02 11:10:15.000103373 -0400
+++ xfs/fs/xfs/xfs_iomap.c	2010-11-02 11:14:14.640103375 -0400
@@ -51,11 +51,11 @@
 #define XFS_WRITE_IMAPS		XFS_BMAP_MAX_NMAP
 
 STATIC int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
-				  int, struct xfs_bmbt_irec *, int *);
-STATIC int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t, int,
-				 struct xfs_bmbt_irec *, int *);
+				  struct xfs_bmbt_irec *, int);
+STATIC int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
+				 struct xfs_bmbt_irec *);
 STATIC int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t, size_t,
-				struct xfs_bmbt_irec *, int *);
+				struct xfs_bmbt_irec *);
 
 int
 xfs_iomap(
@@ -134,12 +134,12 @@ xfs_iomap(
 		}
 
 		if (flags & BMAPI_DIRECT) {
-			error = xfs_iomap_write_direct(ip, offset, count, flags,
-						       imap, nimaps);
+			error = xfs_iomap_write_direct(ip, offset, count, imap,
+						       *nimaps);
 		} else {
-			error = xfs_iomap_write_delay(ip, offset, count, flags,
-						      imap, nimaps);
+			error = xfs_iomap_write_delay(ip, offset, count, imap);
 		}
+
 		if (!error) {
 			trace_xfs_iomap_alloc(ip, offset, count, flags, imap);
 		}
@@ -155,13 +155,10 @@ xfs_iomap(
 			break;
 		}
 
-		error = xfs_iomap_write_allocate(ip, offset, count,
-						 imap, nimaps);
+		error = xfs_iomap_write_allocate(ip, offset, count, imap);
 		break;
 	}
 
-	ASSERT(*nimaps <= 1);
-
 out:
 	if (lockmode)
 		xfs_iunlock(ip, lockmode);
@@ -241,9 +238,8 @@ xfs_iomap_write_direct(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	size_t		count,
-	int		flags,
 	xfs_bmbt_irec_t *imap,
-	int		*nmaps)
+	int		nmaps)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -279,7 +275,7 @@ xfs_iomap_write_direct(
 		if (error)
 			goto error_out;
 	} else {
-		if (*nmaps && (imap->br_startblock == HOLESTARTBLOCK))
+		if (nmaps && (imap->br_startblock == HOLESTARTBLOCK))
 			last_fsb = MIN(last_fsb, (xfs_fileoff_t)
 					imap->br_blockcount +
 					imap->br_startoff);
@@ -331,7 +327,7 @@ xfs_iomap_write_direct(
 	xfs_trans_ijoin(tp, ip);
 
 	bmapi_flag = XFS_BMAPI_WRITE;
-	if ((flags & BMAPI_DIRECT) && (offset < ip->i_size || extsz))
+	if (offset < ip->i_size || extsz)
 		bmapi_flag |= XFS_BMAPI_PREALLOC;
 
 	/*
@@ -370,7 +366,6 @@ xfs_iomap_write_direct(
 		goto error_out;
 	}
 
-	*nmaps = 1;
 	return 0;
 
 error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
@@ -379,7 +374,6 @@ error0:	/* Cancel bmap, unlock inode, un
 
 error1:	/* Just cancel transaction */
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
-	*nmaps = 0;	/* nothing set-up here */
 
 error_out:
 	return XFS_ERROR(error);
@@ -396,7 +390,6 @@ xfs_iomap_eof_want_preallocate(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	size_t		count,
-	int		ioflag,
 	xfs_bmbt_irec_t *imap,
 	int		nimaps,
 	int		*prealloc)
@@ -440,9 +433,7 @@ xfs_iomap_write_delay(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	size_t		count,
-	int		ioflag,
-	xfs_bmbt_irec_t *ret_imap,
-	int		*nmaps)
+	xfs_bmbt_irec_t *ret_imap)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -470,7 +461,7 @@ xfs_iomap_write_delay(
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
 	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
-				ioflag, imap, XFS_WRITE_IMAPS, &prealloc);
+				imap, XFS_WRITE_IMAPS, &prealloc);
 	if (error)
 		return error;
 
@@ -523,8 +514,6 @@ retry:
 		return xfs_cmn_err_fsblock_zero(ip, &imap[0]);
 
 	*ret_imap = imap[0];
-	*nmaps = 1;
-
 	return 0;
 }
 
@@ -543,8 +532,7 @@ xfs_iomap_write_allocate(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	size_t		count,
-	xfs_bmbt_irec_t *imap,
-	int		*retmap)
+	xfs_bmbt_irec_t *imap)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb, last_block;
@@ -557,8 +545,6 @@ xfs_iomap_write_allocate(
 	int		error = 0;
 	int		nres;
 
-	*retmap = 0;
-
 	/*
 	 * Make sure that the dquots are there.
 	 */
@@ -680,7 +666,6 @@ xfs_iomap_write_allocate(
 		if ((offset_fsb >= imap->br_startoff) &&
 		    (offset_fsb < (imap->br_startoff +
 				   imap->br_blockcount))) {
-			*retmap = 1;
 			XFS_STATS_INC(xs_xstrat_quick);
 			return 0;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
