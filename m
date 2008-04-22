Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 04:01:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3MB1YLg030012
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 04:01:37 -0700
Date: Tue, 22 Apr 2008 21:02:10 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Fix check for block zero access in xfs_write_iomap_allocate
Message-ID: <20080422110210.GZ103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Fix check for block zero access in xfs_write_iomap_allocate

The check for block zero access should be done on non-realtime
inodes. Fix the logic error in xfs_write_iomap_allocate(), and
simplify the logic on all checks for block zero access.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_iomap.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iomap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iomap.c	2008-04-22 11:54:54.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iomap.c	2008-04-22 20:45:53.469961429 +1000
@@ -523,8 +523,7 @@ xfs_iomap_write_direct(
 		goto error_out;
 	}
 
-	if (unlikely(!imap.br_startblock &&
-		     !(XFS_IS_REALTIME_INODE(ip)))) {
+	if (!(imap.br_startblock || XFS_IS_REALTIME_INODE(ip))) {
 		error = xfs_cmn_err_fsblock_zero(ip, &imap);
 		goto error_out;
 	}
@@ -686,8 +685,7 @@ retry:
 		goto retry;
 	}
 
-	if (unlikely(!imap[0].br_startblock &&
-		     !(XFS_IS_REALTIME_INODE(ip))))
+	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
 		return xfs_cmn_err_fsblock_zero(ip, &imap[0]);
 
 	*ret_imap = imap[0];
@@ -838,9 +836,9 @@ xfs_iomap_write_allocate(
 		 * See if we were able to allocate an extent that
 		 * covers at least part of the callers request
 		 */
-		if (unlikely(!imap.br_startblock &&
-			     XFS_IS_REALTIME_INODE(ip)))
+		if (!(imap.br_startblock || XFS_IS_REALTIME_INODE(ip)))
 			return xfs_cmn_err_fsblock_zero(ip, &imap);
+
 		if ((offset_fsb >= imap.br_startoff) &&
 		    (offset_fsb < (imap.br_startoff +
 				   imap.br_blockcount))) {
@@ -934,8 +932,7 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return XFS_ERROR(error);
 
-		if (unlikely(!imap.br_startblock &&
-			     !(XFS_IS_REALTIME_INODE(ip))))
+		if (!(imap.br_startblock || XFS_IS_REALTIME_INODE(ip)))
 			return xfs_cmn_err_fsblock_zero(ip, &imap);
 
 		if ((numblks_fsb = imap.br_blockcount) == 0) {
