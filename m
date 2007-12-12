Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 23:02:03 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBC71X9t029332
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 23:01:39 -0800
Message-ID: <475F878D.6090407@sgi.com>
Date: Wed, 12 Dec 2007 18:02:37 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] make inode reclaim synchronise with xfs_iflush_done()
Content-Type: multipart/mixed;
 boundary="------------090009090006020202070505"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------090009090006020202070505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On a forced shutdown, xfs_finish_reclaim() will skip flushing the inode.
If the inode flush lock is not already held and there is an outstanding
xfs_iflush_done() then we might free the inode prematurely.  By acquiring
and releasing the flush lock we will synchronise with xfs_iflush_done().

Alternatively we could take a hold on the inode when when issuing I/Os
with xfs_iflush_done() and release it in xfs_iflush_done().  Would this
be a better approach?

Lachlan

--------------090009090006020202070505
Content-Type: text/x-patch;
 name="xfs_finish_reclaim.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_finish_reclaim.diff"

--- fs/xfs/xfs_vnodeops.c_1.726	2007-12-12 17:14:59.000000000 +1100
+++ fs/xfs/xfs_vnodeops.c	2007-12-12 17:15:42.000000000 +1100
@@ -3762,20 +3762,29 @@ xfs_finish_reclaim(
 				goto reclaim;
 			}
 			xfs_iflock(ip); /* synchronize with xfs_iflush_done */
+			xfs_ifunlock(ip);
 		}
 
 		ASSERT(ip->i_update_core == 0);
 		ASSERT(ip->i_itemp == NULL ||
 		       ip->i_itemp->ili_format.ilf_fields == 0);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	} else if (locked) {
+	} else {
 		/*
 		 * We are not interested in doing an iflush if we're
 		 * in the process of shutting down the filesystem forcibly.
 		 * So, just reclaim the inode.
-		 */
-		xfs_ifunlock(ip);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		 * 
+		 * If the flush lock is not already held then temporarily
+		 * acquire it to synchronize with xfs_iflush_done.
+		 */
+		if (locked) {
+			xfs_ifunlock(ip);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		} else {
+			xfs_iflock(ip);
+			xfs_ifunlock(ip);
+		}
 	}
 
  reclaim:

--------------090009090006020202070505--
