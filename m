Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 12:49:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NJn3fL010864
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:08 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20A1431BC8F
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:56 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id IRR9m1UGXzthR6BM for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:56 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NJnlNg006626
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 21:49:47 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NJnlwF006624
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 21:49:47 +0200
Date: Wed, 23 Jul 2008 21:49:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] remove remaining VN_HOLD calls
Message-ID: <20080723194946.GE6188@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Use IHOLD(ip) instead of VN_HOLD(VFS_I(ip)).


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_dquot.c	2008-07-23 19:40:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_dquot.c	2008-07-23 19:40:42.000000000 +0200
@@ -431,7 +431,7 @@ xfs_qm_dqalloc(
 	 * when it unlocks the inode. Since we want to keep the quota
 	 * inode around, we bump the vnode ref count now.
 	 */
-	VN_HOLD(VFS_I(quotip));
+	IHOLD(quotip);
 
 	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
 	nmaps = 1;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-07-23 19:40:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-07-23 19:40:42.000000000 +0200
@@ -4000,7 +4000,7 @@ xfs_bmap_add_attrfork(
 		ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
 	ASSERT(ip->i_d.di_anextents == 0);
-	VN_HOLD(VFS_I(ip));
+	IHOLD(ip);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	switch (ip->i_d.di_format) {
Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c	2008-07-23 19:40:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c	2008-07-23 19:40:42.000000000 +0200
@@ -350,15 +350,11 @@ xfs_swap_extents(
 		break;
 	}
 
-	/*
-	 * Increment vnode ref counts since xfs_trans_commit &
-	 * xfs_trans_cancel will both unlock the inodes and
-	 * decrement the associated ref counts.
-	 */
-	VN_HOLD(vp);
-	VN_HOLD(tvp);
 
+	IHOLD(ip);
 	xfs_trans_ijoin(tp, ip, lock_flags);
+
+	IHOLD(tip);
 	xfs_trans_ijoin(tp, tip, lock_flags);
 
 	xfs_trans_log_inode(tp, ip,  ilf_fields);
