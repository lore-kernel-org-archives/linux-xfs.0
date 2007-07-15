Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 13:40:21 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6FKeGbm029311
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 13:40:18 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6FKeINK017098
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 22:40:18 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6FKeIcf017096
	for xfs@oss.sgi.com; Sun, 15 Jul 2007 22:40:18 +0200
Date: Sun, 15 Jul 2007 22:40:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove confusing INT_ comments in xfs_bmap_btree.c
Message-ID: <20070715204018.GA17069@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2007-07-15 18:22:48.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2007-07-15 18:57:46.000000000 +0200
@@ -383,7 +383,7 @@ xfs_bmbt_delrec(
 		if (ptr < numrecs) {
 			memmove(&kp[ptr - 1], &kp[ptr],
 				(numrecs - ptr) * sizeof(*kp));
-			memmove(&pp[ptr - 1], &pp[ptr], /* INT_: direct copy */
+			memmove(&pp[ptr - 1], &pp[ptr],
 				(numrecs - ptr) * sizeof(*pp));
 			xfs_bmbt_log_ptrs(cur, bp, ptr, numrecs - 1);
 			xfs_bmbt_log_keys(cur, bp, ptr, numrecs - 1);
@@ -815,7 +815,7 @@ xfs_bmbt_insrec(
 #endif
 		memmove(&kp[ptr], &kp[ptr - 1],
 			(numrecs - ptr + 1) * sizeof(*kp));
-		memmove(&pp[ptr], &pp[ptr - 1], /* INT_: direct copy */
+		memmove(&pp[ptr], &pp[ptr - 1],
 			(numrecs - ptr + 1) * sizeof(*pp));
 #ifdef DEBUG
 		if ((error = xfs_btree_check_lptr(cur, *bnop, level))) {
@@ -1250,7 +1250,7 @@ xfs_bmbt_lshift(
 			return error;
 		}
 #endif
-		*lpp = *rpp; /* INT_: direct copy */
+		*lpp = *rpp;
 		xfs_bmbt_log_ptrs(cur, lbp, lrecs, lrecs);
 	} else {
 		lrp = XFS_BMAP_REC_IADDR(left, lrecs, cur);
@@ -1388,7 +1388,7 @@ xfs_bmbt_rshift(
 		}
 #endif
 		*rkp = *lkp;
-		*rpp = *lpp; /* INT_: direct copy */
+		*rpp = *lpp;
 		xfs_bmbt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
 		xfs_bmbt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
 	} else {
