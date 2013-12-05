Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 29BD27F58
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 09:59:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB22BAC007
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 07:59:52 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Pypl1H1rALcvI6xC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 07:59:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VobLD-0004xz-Vo
	for xfs@oss.sgi.com; Thu, 05 Dec 2013 15:59:52 +0000
Message-Id: <20131205155951.874279041@bombadil.infradead.org>
Date: Thu, 05 Dec 2013 07:58:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: assert that we hold the ilock for extent map access
References: <20131205155830.620826868@bombadil.infradead.org>
Content-Disposition: inline; filename=iread_extents-assert
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

Make sure that xfs_bmapi_read has the ilock held in some way, and that
xfs_bmapi_write, xfs_bmapi_delay and xfs_iread_extents are called with
the ilock held exclusively.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2013-11-29 14:25:12.172459195 +0100
+++ xfs/fs/xfs/xfs_bmap.c	2013-12-05 10:03:28.243801633 +0100
@@ -3997,6 +3997,7 @@ xfs_bmapi_read(
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
 			   XFS_BMAPI_IGSTATE)));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -4191,6 +4192,7 @@ xfs_bmapi_delay(
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
 	ASSERT(!(flags & ~XFS_BMAPI_ENTIRE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
@@ -4484,6 +4486,7 @@ xfs_bmapi_write(
 	ASSERT(tp != NULL);
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
Index: xfs/fs/xfs/xfs_inode_fork.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_fork.c	2013-12-05 09:57:24.347809100 +0100
+++ xfs/fs/xfs/xfs_inode_fork.c	2013-12-05 09:59:04.767807039 +0100
@@ -431,6 +431,8 @@ xfs_iread_extents(
 	xfs_ifork_t	*ifp;
 	xfs_extnum_t	nextents;
 
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
 	if (unlikely(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
 		XFS_ERROR_REPORT("xfs_iread_extents", XFS_ERRLEVEL_LOW,
 				 ip->i_mount);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
