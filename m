Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Nov 2008 15:19:10 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA7NIxUb019755
	for <xfs@oss.sgi.com>; Fri, 7 Nov 2008 15:19:00 -0800
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1A1D19A7F85
	for <xfs@oss.sgi.com>; Fri,  7 Nov 2008 15:18:58 -0800 (PST)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by cuda.sgi.com with ESMTP id F71BupXnG7RXx2EA for <xfs@oss.sgi.com>; Fri, 07 Nov 2008 15:18:58 -0800 (PST)
Date: Fri, 7 Nov 2008 18:00:54 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: [PATCH] XFS: random cleanups of xfs_swap_extents
Message-ID: <20081107230054.GH26208@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>

XFS: random cleanups of xfs_swap_extents

From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

1) remove lock_flags var since it's never modified and only obfuscates the
code

2) calling kfree/vfree on a NULL is valid

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

--

I did only compile testing. If people really want, I can go ahead and set up
my xfsqa test box again and run the patch through it.

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index 75b0cd4..d65e81e 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -132,7 +132,6 @@ xfs_swap_extents(
 	xfs_bstat_t	*sbp = &sxp->sx_stat;
 	xfs_ifork_t	*tempifp, *ifp, *tifp;
 	int		ilf_fields, tilf_fields;
-	static uint	lock_flags = XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL;
 	int		error = 0;
 	int		aforkblks = 0;
 	int		taforkblks = 0;
@@ -346,10 +345,10 @@ xfs_swap_extents(
 
 
 	IHOLD(ip);
-	xfs_trans_ijoin(tp, ip, lock_flags);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
 	IHOLD(tip);
-	xfs_trans_ijoin(tp, tip, lock_flags);
+	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
 	xfs_trans_log_inode(tp, ip,  ilf_fields);
 	xfs_trans_log_inode(tp, tip, tilf_fields);
@@ -367,10 +366,10 @@ xfs_swap_extents(
 
  error0:
 	if (locked) {
-		xfs_iunlock(ip,  lock_flags);
-		xfs_iunlock(tip, lock_flags);
+		xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+		xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 	}
-	if (tempifp != NULL)
-		kmem_free(tempifp);
+
+	kmem_free(tempifp);
 	return error;
 }
