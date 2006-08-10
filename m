Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Aug 2006 23:00:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7A5xYDW004894
	for <xfs@oss.sgi.com>; Wed, 9 Aug 2006 22:59:48 -0700
Received: from wobbly.melbourne.sgi.com (wobbly.melbourne.sgi.com [134.14.55.135]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA19214 for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 15:58:55 +1000
Received: from wobbly.melbourne.sgi.com (localhost [127.0.0.1])
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k7A5wrgw2592802
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 15:58:53 +1000 (EST)
Received: (from nathans@localhost)
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k7A5wqYm2585092
	for xfs@oss.sgi.com; Thu, 10 Aug 2006 15:58:52 +1000 (EST)
Date: Thu, 10 Aug 2006 15:58:51 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: fsblock zero - don't panic
Message-ID: <20060810155851.C2591606@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

As part of attempting to understand what happened in a corruption
problem awhile back, and generally be a bit more defensive of our
precious primary superblock, some code was added to XFS to detect
(and panic) on any inode extents that start at block zero.

This has happened once or twice now, and when it does, we panic the
kernel.  This is not at all nice, as it means we take out the whole
system due to ondisk corruption.  This patch makes that code issue
a warning now, and fail whatever operation was in progress.

cheers.

-- 
Nathan


Index: xfs-linux/xfs_bmap.c
===================================================================
--- xfs-linux.orig/xfs_bmap.c	2006-08-08 15:59:14.396022750 +1000
+++ xfs-linux/xfs_bmap.c	2006-08-08 16:08:34.790988750 +1000
@@ -3722,16 +3722,19 @@ xfs_bmap_search_extents(
 
 	rt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
 	if (unlikely(!rt && !gotp->br_startblock && (*lastxp != NULLEXTNUM))) {
-                cmn_err(CE_PANIC,"Access to block zero: fs: <%s> inode: %lld "
-			"start_block : %llx start_off : %llx blkcnt : %llx "
-			"extent-state : %x \n",
-			(ip->i_mount)->m_fsname, (long long)ip->i_ino,
+		cmn_err(CE_WARN, "Access to block zero: fs: <%s> inode: %lld "
+				 "start_block : %llx start_off : %llx "
+				 "blkcnt : %llx extent-state : %x lastx : %x\n",
+			ip->i_mount->m_fsname, (long long)ip->i_ino,
 			(unsigned long long)gotp->br_startblock,
 			(unsigned long long)gotp->br_startoff,
 			(unsigned long long)gotp->br_blockcount,
-			gotp->br_state);
-        }
-        return ep;
+			gotp->br_state, *lastxp);
+		ASSERT(0);
+		*eofp = 1;
+		return NULL;
+	}
+	return ep;
 }
 
 
Index: xfs-linux/xfs_iomap.c
===================================================================
--- xfs-linux.orig/xfs_iomap.c	2006-08-08 15:59:14.428024750 +1000
+++ xfs-linux/xfs_iomap.c	2006-08-08 16:18:40.116068500 +1000
@@ -536,23 +536,28 @@ xfs_iomap_write_direct(
 	 * Copy any maps to caller's array and return any error.
 	 */
 	if (nimaps == 0) {
-		error = (ENOSPC);
+		error = ENOSPC;
 		goto error_out;
 	}
 
-	*ret_imap = imap;
-	*nmaps = 1;
-	if ( !(io->io_flags & XFS_IOCORE_RT)  && !ret_imap->br_startblock) {
-                cmn_err(CE_PANIC,"Access to block zero:  fs <%s> inode: %lld "
-                        "start_block : %llx start_off : %llx blkcnt : %llx "
-                        "extent-state : %x \n",
-                        (ip->i_mount)->m_fsname,
-                        (long long)ip->i_ino,
-                        (unsigned long long)ret_imap->br_startblock,
+	if (unlikely(
+	    !(io->io_flags & XFS_IOCORE_RT) && !ret_imap->br_startblock)) {
+		cmn_err(CE_WARN, "Access to block zero:  fs <%s> inode: %lld "
+				 "start_block : %llx start_off : %llx "
+				 "blkcnt : %llx extent-state : %x\n",
+			ip->i_mount->m_fsname,
+			(long long)ip->i_ino,
+			(unsigned long long)ret_imap->br_startblock,
 			(unsigned long long)ret_imap->br_startoff,
-                        (unsigned long long)ret_imap->br_blockcount,
+			(unsigned long long)ret_imap->br_blockcount,
 			ret_imap->br_state);
-        }
+		ASSERT(0);
+		error = EFSCORRUPTED;
+		goto error_out;
+	}
+
+	*ret_imap = imap;
+	*nmaps = 1;
 	return 0;
 
 error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
@@ -715,16 +720,19 @@ retry:
 		goto retry;
 	}
 
-	if (!(io->io_flags & XFS_IOCORE_RT)  && !ret_imap->br_startblock) {
-		cmn_err(CE_PANIC,"Access to block zero:  fs <%s> inode: %lld "
-                        "start_block : %llx start_off : %llx blkcnt : %llx "
-                        "extent-state : %x \n",
-                        (ip->i_mount)->m_fsname,
-                        (long long)ip->i_ino,
-                        (unsigned long long)ret_imap->br_startblock,
-			(unsigned long long)ret_imap->br_startoff,
-                        (unsigned long long)ret_imap->br_blockcount,
-			ret_imap->br_state);
+	if (unlikely(
+	    !(io->io_flags & XFS_IOCORE_RT) && !ret_imap->br_startblock)) {
+		cmn_err(CE_WARN, "Access to block zero:  fs <%s> inode: %lld "
+				 "start_block : %llx start_off : %llx "
+				 "blkcnt : %llx extent-state : %x\n",
+				ip->i_mount->m_fsname,
+				(long long)ip->i_ino,
+				(unsigned long long)ret_imap->br_startblock,
+				(unsigned long long)ret_imap->br_startoff,
+				(unsigned long long)ret_imap->br_blockcount,
+				ret_imap->br_state);
+		ASSERT(0);
+		return XFS_ERROR(EFSCORRUPTED);
 	}
 
 	*ret_imap = imap[0];
@@ -855,15 +863,15 @@ xfs_iomap_write_allocate(
 		 * See if we were able to allocate an extent that
 		 * covers at least part of the callers request
 		 */
-
 		for (i = 0; i < nimaps; i++) {
-			if (!(io->io_flags & XFS_IOCORE_RT)  &&
-			    !imap[i].br_startblock) {
-				cmn_err(CE_PANIC,"Access to block zero:  "
-					"fs <%s> inode: %lld "
-					"start_block : %llx start_off : %llx "
-					"blkcnt : %llx extent-state : %x \n",
-					(ip->i_mount)->m_fsname,
+			if (unlikely(!(io->io_flags & XFS_IOCORE_RT) &&
+				     !imap[i].br_startblock)) {
+				cmn_err(CE_WARN,
+					"Access to block zero: fs <%s> "
+					"inode: %lld start_block : %llx "
+					"start_off : %llx blkcnt : %llx "
+					"extent-state : %x\n",
+					ip->i_mount->m_fsname,
 					(long long)ip->i_ino,
 					(unsigned long long)
 						imap[i].br_startblock,
@@ -872,7 +880,9 @@ xfs_iomap_write_allocate(
 					(unsigned long long)
 				        	imap[i].br_blockcount,
 					imap[i].br_state);
-                        }
+				ASSERT(0);
+				return XFS_ERROR(EFSCORRUPTED);
+			}
 			if ((offset_fsb >= imap[i].br_startoff) &&
 			    (offset_fsb < (imap[i].br_startoff +
 					   imap[i].br_blockcount))) {
@@ -951,7 +961,7 @@ xfs_iomap_write_unwritten(
 		}
 		if (error) {
 			xfs_trans_cancel(tp, 0);
-			goto error0;
+			return XFS_ERROR(error);
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -977,18 +987,22 @@ xfs_iomap_write_unwritten(
 		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
-			goto error0;
+			return XFS_ERROR(error);
 
-		if ( !(io->io_flags & XFS_IOCORE_RT)  && !imap.br_startblock) {
-			cmn_err(CE_PANIC,"Access to block zero:  fs <%s> "
-				"inode: %lld start_block : %llx start_off : "
-				"%llx blkcnt : %llx extent-state : %x \n",
-				(ip->i_mount)->m_fsname,
+		if (unlikely(
+		    !(io->io_flags & XFS_IOCORE_RT) && !imap.br_startblock)) {
+			cmn_err(CE_WARN, "Access to block zero:  fs <%s> "
+					 "inode: %lld start_block : %llx "
+					 "start_off : %llx blkcnt : %llx "
+					 "extent-state : %x\n",
+				ip->i_mount->m_fsname,
 				(long long)ip->i_ino,
 				(unsigned long long)imap.br_startblock,
 				(unsigned long long)imap.br_startoff,
 				(unsigned long long)imap.br_blockcount,
 				imap.br_state);
+			ASSERT(0);
+			return XFS_ERROR(EFSCORRUPTED);
         	}
 
 		if ((numblks_fsb = imap.br_blockcount) == 0) {
@@ -1009,6 +1023,5 @@ error_on_bmapi_transaction:
 	xfs_bmap_cancel(&free_list);
 	xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT));
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-error0:
 	return XFS_ERROR(error);
 }
