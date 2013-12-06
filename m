Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 34B9F29E06
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 10:49:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 21A868F804B
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 08:49:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id ddQLTfMkpAnApmvA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 08:49:09 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VoyaQ-0000DC-Q8
	for xfs@oss.sgi.com; Fri, 06 Dec 2013 16:49:06 +0000
Message-Id: <20131206164906.720641204@bombadil.infradead.org>
Date: Fri, 06 Dec 2013 08:48:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/7] xfs: use xfs_ilock_map_shared in xfs_attr_list_int
References: <20131206164819.371654241@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-attr-locking-2
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

We might not have read in the extent list at this point, so make sure we
take the ilock exclusively if we have to do so.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_attr_list.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_list.c	2013-11-18 14:39:01.947589999 +0100
+++ xfs/fs/xfs/xfs_attr_list.c	2013-12-05 22:25:47.207821971 +0100
@@ -507,17 +507,17 @@ xfs_attr_list_int(
 {
 	int error;
 	xfs_inode_t *dp = context->dp;
+	uint		lock_mode;
 
 	XFS_STATS_INC(xs_attr_list);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return EIO;
 
-	xfs_ilock(dp, XFS_ILOCK_SHARED);
-
 	/*
 	 * Decide on what work routines to call based on the inode size.
 	 */
+	lock_mode = xfs_ilock_map_shared(dp);
 	if (!xfs_inode_hasattr(dp)) {
 		error = 0;
 	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
@@ -527,9 +527,7 @@ xfs_attr_list_int(
 	} else {
 		error = xfs_attr_node_list(context);
 	}
-
-	xfs_iunlock(dp, XFS_ILOCK_SHARED);
-
+	xfs_iunlock_map_shared(dp, lock_mode);
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
